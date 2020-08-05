{***************************************************************************
                         CanTx.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modified     : 21.01.2016      
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
unit CanTx;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, SysUtils, Classes, StrUtils, Menus, mmsystem, ExtCtrls,
  util, TinyCanDrv;

const
  MaxTxCanListSize = 10000000;

type
  TTxCanMsg = record
    CanMsg: TCanFdMsg;
    TxMode: Integer;
    TriggerId : longword;
    Intervall: longword;
    Timer: longword;
    Comment : String[100];
    end;

  PTxCanMsg = ^TTxCanMsg;

  TTxCanMsgList = array[0..MaxTxCanListSize] of TTxCanMsg;
  PTxCanMsgList = ^TTxCanMsgList;

  TTxCanList = class(TComponent)
  private
    FCount: Integer;
    Lock: boolean;
    FCanMsgs: PTxCanMsgList;
    FIntTimer: TTimer;
    GlobalIntervallEnable: boolean;
    LastSleepTime: Cardinal;
  protected
    procedure OnIntTimer(Sender : TObject);
    function GetCanMsg(index: Integer): PTxCanMsg;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Transmit(index: integer);
    procedure RxMessage(rx_msg: PCanFdMsg);
    function Add(can_msg: PTxCanMsg): Integer;
    procedure Delete(index: Integer);
    procedure Clear;
    property Items[index: Integer]: PTxCanMsg read GetCanMsg; default;
    function SaveToFile(filename: String): Integer;
    function LoadFromFile(filename: String): Integer;
    procedure ResetIntervallTimers;
    procedure SetIntervallMode(enable: boolean);
  published
    property Count: Integer read FCount;
  end;

implementation

uses MainForm;

constructor TTxCanList.Create;

begin
inherited Create(AOwner);
FCount := 0;
Lock := FALSE;
FCanMsgs := nil;
FIntTimer := TTimer.Create(self);
FIntTimer.Enabled := False;
FIntTimer.OnTimer := OnIntTimer;
end;


destructor TTxCanList.Destroy;

begin
FreeMem(FCanMsgs);
FIntTimer.Destroy;
inherited Destroy;
end;


procedure TTxCanList.OnIntTimer(Sender : TObject);
var can_msg :PTxCanMsg;
    i: Integer;
    sleep_time, timer: DWord;

begin;
if FCount = 0 then
  exit;
sleep_time := 100;
for i := 0 to FCount-1 do
  begin;
  can_msg := @FCanMsgs[i];
  if (can_msg.TxMode = 1) and (can_msg^.Intervall > 0) then  // Intervall Timer aktiv
    begin;
    if can_msg^.Timer <= LastSleepTime then
      begin;  // Timer ist abgelaufen
      timer := can_msg^.Intervall;
      // CAN Nachricht senden
      MainWin.TinyCAN.CanFdTransmit(MainWin.CanDeviceIndex, @can_msg^.CanMsg, 1);
      end
    else
      timer := can_msg^.Timer - LastSleepTime;
    if timer < sleep_time then
      sleep_time := timer;
    can_msg^.Timer := timer;        
    end;
  end;
LastSleepTime := sleep_time;
FIntTimer.Interval := sleep_time;
end;


procedure TTxCanList.RxMessage(rx_msg: PCanFdMsg);
var can_msg :PTxCanMsg;
    i : Integer;
    tx : Boolean;

begin;
if (FCount = 0) or Lock then
  exit;
for i := 0 to FCount-1 do
  begin;
  can_msg := @FCanMsgs[i];
  tx := False;
  if can_msg.TxMode = 2 then      // RTR
    begin;
    if ((rx_msg.Flags and FlagCanFdRTR) > 0) and (can_msg^.CanMsg.ID = rx_msg.ID) then
      tx := True;
    end
  else if can_msg.TxMode = 3 then // Trigger ID
    begin;
    if rx_msg.ID = can_msg^.TriggerId then
      tx := True;
    end;
  if tx then
    begin;
    can_msg^.Timer := can_msg^.Intervall;   // Interval Timer rÃ¼cksetzen
    // CAN Nachricht senden
    MainWin.TinyCAN.CanFdTransmit(MainWin.CanDeviceIndex, @can_msg^.CanMsg, 1);    
    end;
  end;
end;


procedure TTxCanList.Transmit(index: integer);
var can_msg: PTxCanMsg;

begin
can_msg := GetCanMsg(index);
if can_msg = nil then
  exit;
can_msg^.Timer := can_msg^.Intervall;   // Interval Timer zurücksetzen
// CAN Nachricht senden
MainWin.TinyCAN.CanFdTransmit(MainWin.CanDeviceIndex, @can_msg^.CanMsg, 1);
end;


function TTxCanList.GetCanMsg(index: Integer): PTxCanMsg;

begin
If (index < FCount) and (index >= 0) then
  Result := @FCanMsgs[index]
else
  Result := nil;
end;


function TTxCanList.Add(can_msg: PTxCanMsg): Integer;

begin
RxCanEnterCritical;
result := FCount;
ReallocMem (FCanMsgs, (FCount+1) * SizeOf(TTxCanMsg));
Move(can_msg^, FCanMsgs[FCount], SizeOf(TTxCanMsg));
Inc(FCount);
RxCanLeaveCritical;  
end;


procedure TTxCanList.Delete(index: Integer);

begin
If (index < 0) OR (index >= FCount) then
  exit;  
RxCanEnterCritical;  
If index < FCount-1 then
  Move(FCanMsgs[index+1], FCanMsgs[index], (FCount - index-1) * SizeOf(TTxCanMsg));
Dec(FCount);
If FCount = 0 then
  begin
  FreeMem(FCanMsgs);
  FCanMsgs := nil;
  end
else    
  ReallocMem(FCanMsgs, FCount*SizeOf(TTxCanMsg));
RxCanLeaveCritical;  
end;


procedure TTxCanList.Clear;

begin
RxCanEnterCritical;
FCount:=0;
FreeMem(FCanMsgs);
FCanMsgs := nil;
RxCanLeaveCritical;  
end;  


function TTxCanList.SaveToFile(filename: String): Integer;
var tx_msg: PTxCanMsg;
    can_msg: PCanFdMsg;
    str: string[250];
    txm_str: string[20];
    line: string;
    d, len: Byte;
    dlc, i, ii: integer;
    rtr, eff: boolean;
    f: TextFile;

begin;
try
  AssignFile(f, filename);
  Rewrite(f);
  Writeln(f, 'Frame;ID;DLC;D0;D1;D2;D3;D4;D5;D6;D7;TxMode;TriggerId;Intervall;Coment');
  for i := 0 to FCount-1 do
    begin
    tx_msg := @FCanMsgs[i];
    can_msg := @tx_msg^.CanMsg;
    dlc := can_msg^.Length;
    if (can_msg^.Flags and FlagCanFdEFF) > 0 then
      eff := True
    else
      eff := False;
    if (can_msg^.Flags and FlagCanFdRTR) > 0 then
      rtr := True
    else
      rtr := False;
    // Frame Format; ID; DLC; Daten
    if rtr and eff then
      str := format('EFF/RTR;%X;%u;', [can_msg^.ID, dlc])
    else if eff then
      str := format('EFF;%X;%u;', [can_msg^.ID, dlc])
    else if rtr then
      str := format('STD/RTR;%X;%u;', [can_msg^.ID, dlc])
    else
      str := format('STD;%X;%u;', [can_msg^.ID, dlc]);
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
    case tx_msg^.TxMode of
      0 : txm_str := 'Off';
      1 : txm_str := 'Periodic';
      2 : txm_str := 'RTR';
      3 : txm_str := 'Trigger'
      end;
    line := format('%s%s;%X;%u;%s;', [str, txm_str, tx_msg^.TriggerId, tx_msg^.Intervall, tx_msg^.Comment]);
    Writeln(f, line);
    end;
finally
  CloseFile(f);
  end;
result := 0;
end;


function TTxCanList.LoadFromFile(filename: String): Integer;
const
    Delims = [';'];
var  f: TextFile;
     line, item: String;
     i, p: Integer;
     tx_msg: TTxCanMsg;
     value: DWord;

begin;
result := 0;
RxCanEnterCritical;
Lock := TRUE;
RxCanLeaveCritical;
Clear;
try
  AssignFile(f, filename);
  Reset(f);
  Readln(f, line);  // Header Ã¼berspringen
  while not(eof(f)) do // Zeilenschleife
    begin
    // Frame;ID;DLC;D0;D1;D2;D3;D4;D5;D6;D7;TxMode;TriggerId;Intervall;Coment
    Readln(f, line);

    p := 1;
    tx_msg.CanMsg.Flags := 0;
    // *** Frame Type lesen
    item := UpperCase(ExtractSubstr(line, p, Delims));
    if Pos('EFF', item) <> 0 then
      tx_msg.CanMsg.Flags := tx_msg.CanMsg.Flags or FlagCanFdEFF;
    if Pos('RTR', item) <> 0 then
      tx_msg.CanMsg.Flags := tx_msg.CanMsg.Flags or FlagCanFdRTR;
    // **** ID
    item := ExtractSubstr(line, p, Delims);
    tx_msg.CanMsg.ID := StrToHex(item);
    // **** DLC
    item := ExtractSubstr(line, p, Delims);
    value := StrtoIntDef(item, 0);
    tx_msg.CanMsg.Flags := tx_msg.CanMsg.Flags or (value and FlagsCanLength);
    for i := 0 to 7 do
      begin;
      item := ExtractSubstr(line, p, Delims);
      tx_msg.CanMsg.Data.Bytes[i] := StrToHex(item);
      end;
    // **** TxMode
    item := UpperCase(ExtractSubstr(line, p, Delims));
    if Pos('PERIODIC', item) <> 0 then
      tx_msg.TxMode := 1
    else if Pos('RTR', item) <> 0 then
      tx_msg.TxMode := 2
    else if Pos('TRIGGER', item) <> 0 then
      tx_msg.TxMode := 3
    else
      tx_msg.TxMode := 0;
    // **** TriggerId
    item := ExtractSubstr(line, p, Delims);
    tx_msg.TriggerId := StrToHex(item);
    // **** Intervall
    item := ExtractSubstr(line, p, Delims);
    tx_msg.Intervall := StrtoIntDef(item, 0);
    // **** Comment
    item := ExtractSubstr(line, p, Delims);
    tx_msg.Comment := item;

    Add(@tx_msg);
    end;
finally
  CloseFile(f);
  RxCanEnterCritical;
  Lock := FALSE;
  RxCanLeaveCritical;
  end;
end;


procedure TTxCanList.ResetIntervallTimers;
var tx_msg: PTxCanMsg;
    i: Integer;

begin;
for i := 0 to FCount-1 do
  begin
  tx_msg := @FCanMsgs[i];
  tx_msg^.Timer := tx_msg^.Intervall;   // Interval Timer zurücksetzen
  end;
end;


procedure TTxCanList.SetIntervallMode(enable: boolean);

begin;
GlobalIntervallEnable := enable;
if GlobalIntervallEnable then
  begin;
  ResetIntervallTimers;
  LastSleepTime := 100;
  FIntTimer.Interval := 100;
  FIntTimer.Enabled := True;
  end
else
  FIntTimer.Enabled := False;
end;

end.