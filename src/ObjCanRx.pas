{***************************************************************************
                        ObjCanRx.pas  -  description
                             -------------------
    begin             : 08.01.2013
    last modified     : 17.01.2016     
    copyright         : (C) 2013 - 2016 by MHS-Elektronik GmbH & Co. KG, Germany
                               http://www.mhs-elektronik.de    
    autho             : Klaus Demlehner, klaus@mhs-elektronik.de
 ***************************************************************************}

{***************************************************************************
 *                                                                         *
 *   This program is free software, you can redistribute it and/or modify  *
 *   it under the terms of the MIT License <LICENSE.TXT or                 *
 *   http://opensource.org/licenses/MIT>                                   *              
 *                                                                         *
 ***************************************************************************}
unit ObjCanRx;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, SysUtils, Classes, StrUtils, Menus, mmsystem, util, TinyCanDrv;

const
  MaxObjCanRxListSize = 10000000;

type
  TRxCanMsgObj = record
    CanMsg: TCanMsg;
    MsgCount: DWord;
    Min: DWord;
    Max: DWord;
    Intervall: DWord;
    LastIntervall: DWord;
    IntervallSumm: DWord;
    IntervallMsgCount: DWord;
    LastTime: DWord;
    end;
  PRxCanMsgObj = ^TRxCanMsgObj;

  TRxCanMsgObjList = array[0..MaxObjCanRxListSize] of TRxCanMsgObj;
  PRxCanMsgObjList = ^TRxCanMsgObjList;

  TRxCanObjList = class(TComponent)
  private
    Clump: Integer;
    StartCapacity: Integer;
    FCount: Integer;
    FCapacity: Integer;
    FCanMsgs: PRxCanMsgObjList;
  protected        
    procedure SetCapacity(value: Integer);
    function Grow: Boolean;
    function AddMsg(can_msg: PRxCanMsgObj): Integer;
    function InsertMsg(index: Integer; can_msg: PRxCanMsgObj): Integer;
    procedure ClearStatObj(obj: PRxCanMsgObj);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearStat;    
    function Add(can_msg: PCanMsg): Integer;    
    procedure Clear;
    function ReadCanMsg(index: Integer; var msg: TRxCanMsgObj): Integer;       
  published
    property Count: Integer read FCount;
    property Capacity: Integer read FCapacity write SetCapacity;
  end;

implementation


constructor TRxCanObjList.Create;

begin
inherited Create(AOwner);
FCanMsgs := nil;
FCount := 0;
Capacity := 1000;
Clump := 1000;
end;


destructor TRxCanObjList.Destroy;

begin
FreeMem(FCanMsgs);
inherited Destroy;
end;


procedure TRxCanObjList.ClearStatObj(obj: PRxCanMsgObj);
begin;
obj^.Min := 0;
obj^.Max := 0;
obj^.Intervall := 0;
obj^.LastIntervall := 0;
obj^.IntervallSumm := 0;
obj^.IntervallMsgCount := 0;
obj^.LastTime := 0;

obj^.MsgCount := 0;
end;


procedure TRxCanObjList.ClearStat;
var i: Integer;

begin;
if FCount = 0 then
  exit;
for i := 0 to (FCount-1) do
  ClearStatObj(@FCanMsgs[i]);
end;


function TRxCanObjList.ReadCanMsg(index: Integer; var msg: TRxCanMsgObj): Integer;

begin
Result := -1;
RxCanEnterCritical;
If (index < FCount) and (index >= 0) then
  begin;
  Move(FCanMsgs[index], msg, SizeOf(TRxCanMsgObj));
  Result := 0;
  end;
RxCanLeaveCritical;  
end;


procedure TRxCanObjList.SetCapacity(value: Integer);

begin;
if (value < FCount) or (value > MaxObjCanRxListSize) then
  exit;
if value < 10 then value := 10;
StartCapacity := value;
if value <> FCapacity then
  begin;
  FCapacity := value;  
  ReallocMem(FCanMsgs, value * SizeOf(TRxCanMsgObj));
  end;
end;


function TRxCanObjList.Grow: Boolean;
begin;
if Clump > 0 then
  begin;  
  if (FCapacity + Clump) > MaxObjCanRxListSize then
    result := False
  else
    begin;
    FCapacity := FCapacity + Clump;
    ReallocMem(FCanMsgs, FCapacity * SizeOf(TRxCanMsgObj));
    result := True;
    end;
  end
else
  result := False;
end;


function TRxCanObjList.AddMsg(can_msg: PRxCanMsgObj): Integer;

begin
result := -1;
if FCount = FCapacity then
  begin;
  if not Grow then
    exit; 
  end;
result := FCount;
Inc(FCount);
if can_msg <> nil then
  Move(can_msg^, FCanMsgs[FCount-1], SizeOf(TRxCanMsgObj));
end;


function TRxCanObjList.InsertMsg(index: Integer; can_msg: PRxCanMsgObj): Integer;
begin
result := -1;
if (Index < 0) or (Index > FCount) then
  exit;  
if FCount = FCapacity then
  begin;
  if not Grow then
    exit; 
  end;  
if index < FCount then
  Move(FCanMsgs[index], FCanMsgs[index + 1], (FCount - index) * SizeOf(TRxCanMsgObj));
if can_msg <> nil then
  Move(can_msg^, FCanMsgs[index], SizeOf(TRxCanMsgObj));
Inc(FCount);
result := index;
end;


procedure TRxCanObjList.Clear;

begin
RxCanEnterCritical;
SetCapacity(StartCapacity);
FCount := 0;
RxCanLeaveCritical;
end;


function TRxCanObjList.Add(can_msg: PCanMsg): Integer;
var i: Integer;
    a_msg: PRxCanMsgObj;
    tmp_msg: TRxCanMsgObj;
    timestamp, msg_count, last_time, last_intervall: DWord;

begin;
i := 0;
timestamp := (can_msg^.Time.USec div 1000) + (can_msg^.Time.Sec * 1000); // Zeitstempel in ms umrechnen
while (i < FCount) do
  begin
  a_msg := @FCanMsgs[i];
  if a_msg^.CanMsg.Id = can_msg^.Id then   // Bekannte Nachricht ?
    begin                                         // Ja
    msg_count := a_msg^.MsgCount;
    last_time := a_msg^.LastTime;
    Move(can_msg^, a_msg^.CanMsg, SizeOf(TCanMsg)); // Nachricht mit neusten Inhalt überschreiben    
    a_msg^.MsgCount := msg_count + 1;
    a_msg^.LastTime := timestamp;
    if a_msg^.MsgCount > 1 then
      begin;
      // **** Last Intervall berechnen
      if timestamp >= last_time then
        last_intervall := timestamp - last_time
      else
        last_intervall := 0;

      a_msg^.LastIntervall := last_intervall;
      // **** Min/Max
      if a_msg^.MsgCount = 2 then
        begin;
        a_msg^.Min := last_intervall;
        a_msg^.Max := last_intervall;
        end
      else
        begin;
        if last_intervall < a_msg^.Min then
          a_msg^.Min := last_intervall;
        if last_intervall > a_msg^.Max then
          a_msg^.Max := last_intervall;
        end;
      // **** Intervall Durchschnitt berechnen
      inc(a_msg^.IntervallSumm, last_intervall);
      inc(a_msg^.IntervallMsgCount);
      if a_msg^.IntervallSumm >= 1000 then  // Intervall nach 1 Sek updaten
        begin;
        a_msg^.Intervall := a_msg^.IntervallSumm div a_msg^.IntervallMsgCount;
        a_msg^.IntervallSumm := 0;
        a_msg^.IntervallMsgCount := 0;
        end;
      end;

    result := i;
    exit;
    end
  else
    begin
    if a_msg^.CanMsg.ID > can_msg^.ID then
      break;
    end;
  inc(i);
  end;
Move(can_msg^, tmp_msg.CanMsg, SizeOf(TCanMsg)); // Nachricht mit neusten Inhalt überschreiben
tmp_msg.MsgCount := 1;
tmp_msg.Min := 0;
tmp_msg.Max := 0;
tmp_msg.Intervall := 0;
tmp_msg.LastIntervall := 0;
tmp_msg.LastTime := timestamp;
tmp_msg.IntervallSumm := 0;
tmp_msg.IntervallMsgCount := 0;

if i < FCount then
  begin;
  result := i;
  InsertMsg(i, @tmp_msg);
  end
else
  result := AddMsg(@tmp_msg);
end;

end.


