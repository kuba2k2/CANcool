{***************************************************************************
                          CanRx.pas  -  description
                             -------------------
    begin             : 07.01.2013
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
unit CanRx;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Classes, StrUtils, Menus, mmsystem, util, TinyCanDrv,
  CanRxSaveForm;

const
  MemLimit: Cardinal = 100000000;
  MaxCanListSize     =  20000000;
  MaxCanMemListSize  =    100000;

type
  TCanMsgList = array[0..MaxCanListSize] of TCanFdMsg;
  PCanFdMsgList = ^TCanMsgList;
  
  TCanMemList = array[0..MaxCanMemListSize] of PCanFdMsgList;
  PCanMemList = ^TCanMemList;

  TSaveThread = class;

  TRxCanList = class(TComponent)
  private
    Lock: boolean;
    FUsedClumps: Integer;    
    FCount: Integer;
    FClumpSize: Integer;
    FMaxClumps: Integer;    
    FCanMemList: PCanMemList;
    TotalBufferSize: Integer;
    TraceFileName: String;
  protected
    procedure BufferFree;
    function GetCanMsg(index: Integer): PCanFdMsg;
    procedure SetCapacity;
    procedure SetClumpSize(value: Integer);
    procedure SetMaxClumps(value: Integer);
    function Grow: Boolean;
    function SaveToFileInt: Integer;
    function SaveThreadTerminate: Integer;
  public
    Capacity: Integer;
    FirstTime: TCanTime; 
    TraceSaveProgressForm: TTraceSaveProgress;
    SaveThread : TSaveThread;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add(can_msg: PCanFdMsg): Integer;
    procedure Clear;
    function ReadCanMsg(index: Integer; var msg: TCanFdMsg): Integer;
    function SaveToFile(filename: String): Integer;
  published
    property Count: Integer read FCount;
    property ClumpSize: Integer read FClumpSize write SetClumpSize;
    property MaxClumps: Integer read FMaxClumps write SetMaxClumps;
  end;

  TSaveThread = class(TThread)
  private
    Owner: TRxCanList;    
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TRxCanList);
  end;

implementation


constructor TRxCanList.Create;

begin
inherited Create(AOwner);
Lock := FALSE;
FClumpSize := 100000;
FMaxClumps := 100;
SetCapacity;
FirstTime.Sec := 0;
FirstTime.USec := 0;
end;


procedure TRxCanList.BufferFree;
var i: Integer;
    msgs: PCanFdMsgList;
    
begin
if FCanMemList <> nil then
  begin 
  if FUsedClumps > 0 then  
    begin
    for i:= 0 to FUsedClumps-1 do
      begin
      msgs := FCanMemList[i];
      FreeMem(msgs);
      end;
    end;  
  FreeMem(FCanMemList);      
  end;
FCount:=0;
FirstTime.Sec := 0;
FirstTime.USec := 0;  
FUsedClumps := 0;
TotalBufferSize := 0;
Capacity := 0;
FCanMemList := nil;
end;


destructor TRxCanList.Destroy;

begin
BufferFree();
inherited Destroy;
end;


function TRxCanList.GetCanMsg(index: Integer): PCanFdMsg;
var idx, clump: Integer;
    msgs: PCanFdMsgList;

begin
If (FCanMemList <> nil) and (index < FCount) and (index >= 0) then
  begin;
  idx := index mod FClumpSize;
  clump := index div FClumpSize;
  msgs := FCanMemList[clump];
  Result := @msgs[idx];
  end
else
  Result := nil;
end;


function TRxCanList.ReadCanMsg(index: Integer; var msg: TCanFdMsg): Integer;
var idx, clump: Integer;
    msgs: PCanFdMsgList;

begin
Result := -1;
RxCanEnterCritical;
if Lock then
  begin
  RxCanLeaveCritical;
  exit;
  end;
If (FCanMemList <> nil) and (index < FCount) and (index >= 0) then
  begin;
  idx := index mod FClumpSize; 
  clump := index div FClumpSize;
  msgs := FCanMemList[clump];
  Move(msgs[idx], msg, SizeOf(TCanFdMsg));
  Result := 0;
  end;  
RxCanLeaveCritical;
end;


procedure TRxCanList.SetCapacity;

begin;
RxCanEnterCritical;
if Lock then
  begin
  RxCanLeaveCritical;
  exit;
  end;
Lock := TRUE;
RxCanLeaveCritical;
BufferFree;
FCanMemList := AllocMem(FMaxClumps * SizeOf(PCanFdMsgList));
TotalBufferSize := FClumpSize * FMaxClumps;
Grow;
RxCanEnterCritical;
Lock := FALSE;
RxCanLeaveCritical;
end;


procedure TRxCanList.SetClumpSize(value: Integer);

begin
if (value = FClumpSize) or (value < 10000) or (value > MaxCanListSize) then
  exit;
if (Cardinal(value) * Cardinal(FMaxClumps)) > MemLimit then
  FMaxClumps := MemLimit div Cardinal(value);
FClumpSize := value;
SetCapacity;
end;


procedure TRxCanList.SetMaxClumps(value: Integer);

begin
if (value = FMaxClumps) or (value < 1) or (value > MaxCanMemListSize) then
  exit;
if (Cardinal(value) * Cardinal(FClumpSize)) > MemLimit then
  FClumpSize := MemLimit div Cardinal(value);
FMaxClumps := value;
SetCapacity;  
end;


function TRxCanList.Grow: Boolean;
var mem: PCanFdMsgList;

begin;
result := FALSE;
if (FCanMemList = nil) or (FUsedClumps >= FMaxClumps) then
  exit; 
mem := AllocMem(FClumpSize * SizeOf(TCanFdMsg));
if mem = nil then
  exit;
FCanMemList[FUsedClumps] := mem;
inc(FUsedClumps);
Capacity := FClumpSize * FUsedClumps;
result := TRUE;
end;


function TRxCanList.Add(can_msg: PCanFdMsg): Integer;
var idx, clump: Integer;
    msgs: PCanFdMsgList;
    
begin
result := -1;
if (FCanMemList = nil) or Lock then
  exit;
if FCount = Capacity then
  begin;
  if not Grow then
    exit;
  end;
Inc(FCount);
if FCount = 1 then
  begin;
  FirstTime.Sec := can_msg^.Time.Sec;
  FirstTime.Usec := can_msg^.Time.USec;
  end;
idx := (FCount-1) mod FClumpSize; 
clump := (FCount-1) div FClumpSize;
msgs := FCanMemList[clump];    
if can_msg <> nil then
  Move(can_msg^, msgs[idx], SizeOf(TCanFdMsg));
result := FCount;  
end;


procedure TRxCanList.Clear;
var i: Integer;
    msgs: PCanFdMsgList;

begin
RxCanEnterCritical;
if Lock then
  begin
  RxCanLeaveCritical;
  exit;
  end;
Lock := TRUE;
RxCanLeaveCritical;
if (FCanMemList <> nil) and (FUsedClumps > 1) then
  begin
  for i:= 1 to FUsedClumps-1 do
    begin
    msgs := FCanMemList[i]; 
    FreeMem(msgs);
    end;
  FUsedClumps := 1;
  end;
FCount := 0;
FirstTime.Sec := 0;
FirstTime.USec := 0;
Capacity := FClumpSize;
RxCanEnterCritical;
Lock := FALSE;
RxCanLeaveCritical;
end;


function TRxCanList.SaveToFile(filename: String): Integer;
begin
TraceFileName := filename;

if FCount < 10000 then
  begin
  result := SaveToFileInt;
  end
else
  begin  
  TraceSaveProgressForm := TTraceSaveProgress.Create(self);
  SaveThread := TSaveThread.Create(self);
  TraceSaveProgressForm.ShowModal;
  result := SaveThreadTerminate;
  FreeAndNil(TraceSaveProgressForm);
  end;
end;


function TRxCanList.SaveThreadTerminate: Integer;

begin
result := -1;
if Assigned(SaveThread) then
  begin
  SaveThread.Terminate;
  result := SaveThread.WaitFor;
  FreeAndNil(SaveThread);
  end;
end;


{ TSaveThread }

constructor TSaveThread.Create(AOwner: TRxCanList);
begin
Owner := AOwner;
inherited Create(True);  // Thread erzeugen nicht starten
FreeOnTerminate := false;
Resume;                  // Thread starten
end;


procedure TSaveThread.Execute;
begin
ReturnValue := Owner.SaveToFileInt;
PostMessage(Owner.TraceSaveProgressForm.Handle, WM_SYSCOMMAND, SC_CLOSE, 0);
end;


function TRxCanList.SaveToFileInt: Integer;
var can_msg: PCanFdMsg;
    str: string[250];
    d, len: Byte;
    dlc, i, ii, last_pos, p: integer;
    rtr, eff: boolean;
    ofs, timestamp: DWord;
    f: TextFile;
    scale: double;

begin;
result := 0;
if FCount < 1 then
  begin
  result := -1;
  exit;
  end;
RxCanEnterCritical;
if Lock then
  begin
  RxCanLeaveCritical;
  exit;
  end;
Lock := TRUE;
RxCanLeaveCritical;
last_pos := 0;
ofs := (FirstTime.USec div 1000) + (FirstTime.Sec * 1000);
try
  AssignFile(f, TraceFileName);
  Rewrite(f);
  Writeln(f, 'Timestamp;Frame;ID;DLC;D0;D1;D2;D3;D4;D5;D6;D7;');
  for i := 0 to FCount-1 do
    begin
    if SaveThread <> nil then
      begin
      scale := i + 1;
      scale := (scale / FCount) * 400;
      p := Trunc(scale);
      if last_pos <> p then
        begin
        last_pos := p;
        TraceSaveProgressForm.NewPosition := last_pos;
        SaveThread.Synchronize(TraceSaveProgressForm.SetPosition);
        end;
      if SaveThread.Terminated then
        begin
        result := -1;
        break;
        end;
      end;
    can_msg := GetCanMsg(i);
    if can_msg = nil then
      begin
      result := -1;
      break;
      end;
    dlc := can_msg^.Length;
    if (can_msg^.Flags and FlagCanFdEFF) > 0 then
      eff := True
    else
      eff := False;
    if (can_msg^.Flags and FlagCanFdRTR) > 0 then
      rtr := True
    else
      rtr := False;    
    timestamp := (can_msg^.Time.USec div 1000) + (can_msg^.Time.Sec * 1000) - ofs;
    // Timestamp; Frame Format; ID; DLC; Daten         
    if rtr and eff then
      str := format('%u;EFF/RTR;%X;%u;', [timestamp, can_msg^.ID, dlc])
    else if eff then
      str := format('%u;EFF;%X;%u;', [timestamp, can_msg^.ID, dlc])
    else if rtr then
      str := format('%u;STD/RTR;%X;%u;', [timestamp, can_msg^.ID, dlc])
    else
      str := format('%u;STD;%X;%u;', [timestamp, can_msg^.ID, dlc]);
    len := Byte(str[0]);
    if (dlc > 0) and not rtr then
      begin;
      for ii := 0 to dlc-1 do
        begin;
        d := can_msg^.Data.Bytes[ii];
        inc(len);
        str[len] := HexDigits[d SHR $04];
        inc(len);
        str[len] := HexDigits[d AND $0F];
        inc(len);
        str[len] := ';';
        end;      
      end;
    if rtr then
      dlc := 0;
    if dlc < 8 then
      begin;
      for ii := dlc to 7 do
        begin;
        inc(len);
        str[len] := ';';
        end;
      end;
    str[0] := Char(len);
    Writeln(f, str);
    end;
finally
  CloseFile(f);
  RxCanEnterCritical;
  Lock := FALSE;
  RxCanLeaveCritical;  
  end;
end;


end.
