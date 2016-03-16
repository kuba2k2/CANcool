{***************************************************************************
                       CanRxForm.pas  -  description
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
unit CanRxForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, StrUtils, Util,
  CanRxPrototyp, CanRx, ObjCanRx, TinyCanDrv, ComCtrls, Menus;


const
  RX_WIN_SHOW_TRACE      = 1;
  RX_WIN_SHOW_OBJECT     = 2;
  RX_WIN_CLEAR           = 3;
  RX_WIN_SAVE_TRACE      = 4;
  RX_WIN_SHOW_RX_PANNEL  = 5;
  RX_WIN_HIDE_RX_PANNEL  = 6;
  RX_WIN_STAT_CLEAR      = 7;
  RX_WIN_SHOW_ALL_MSG    = 8;
  RX_WIN_SHOW_USED_MSG   = 9;
  RX_WIN_SHOW_UNUSED_MSG = 10;
  RX_WIN_START_TRACE     = 11;
  RX_WIN_STOP_TRACE      = 12;

  CanBusStatusStr: array[0..3] of String = ('Bus Ok',
                                            'Error Warn.',
                                            'Error Passiv',
                                            'Bus Off!');
                                           
  CanErrorsStr: array[1..6] of String = ('Stuff Error',
                                         'Form Error',
                                         'Ack Error',
                                         'Bit1 Error',
                                         'Bit0 Error',
                                         'CRC Error');

type
  TRxMsgShowMode = (RxMsgShowAll, RxMsgShowUsed, RxMsgShowUnused);

  TCanRxWin = class(TCanRxPrototypForm)
    RxView: TStringGrid;
    SaveDialog: TSaveDialog;
    RxPanel: TPanel;
    HeaderLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    AsciiLabel: TLabel;
    Label6: TLabel;
    BinLabel: TLabel;
    DezLabel: TLabel;
    HexLabel: TLabel;
    Label10: TLabel;
    Analog1: TProgressBar;
    Analog2: TProgressBar;
    Analog3: TProgressBar;
    Analog4: TProgressBar;
    Analog5: TProgressBar;
    Analog6: TProgressBar;
    Analog7: TProgressBar;
    Analog8: TProgressBar;
    RxWinPopup: TPopupMenu;
    AddMsgToTxWinPopup: TMenuItem;
    N1: TMenuItem;
    ClearStatistikPopup: TMenuItem;
    ShowRxPannelPopup: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RxViewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure RxViewClick(Sender: TObject);
    procedure AddMsgToTxWinPopupClick(Sender: TObject);
    procedure ShowRxPannelPopupClick(Sender: TObject);
    procedure ClearStatistikPopupClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FObjectMode: Boolean;
    FRxDetailsShow: Boolean;
    RxFilterMode: TRxMsgShowMode;
    procedure SetRxDetailsShow(mode: Boolean);
    procedure SetObjectMode(mode: Boolean);
    procedure CleanStatMessage;
    procedure DrawStatMessage(index: Integer);
  public
    { Public-Deklarationen }
    EnableTrace: boolean;
    RxList: TRxCanList;
    RxObjList: TRxCanObjList;
    TraceFile: String;
    procedure RxCanMessages(can_msg: PCanMsg; count: Integer); override;
    procedure RxCanUpdate; override;    
    procedure ExecuteCmd(cmd: Integer; can_msg: PCanMsg);
    property ObjectMode: Boolean read FObjectMode write SetObjectMode;
    property RxDetailsShow: Boolean read FRxDetailsShow write SetRxDetailsShow;
  end;

implementation

uses MainForm, CanTxForm;

{$R *.dfm}

{ TEmpfangForm }


procedure TCanRxWin.SetObjectMode(mode: Boolean);
var cnt: Integer;

begin;
FObjectMode := mode;
if mode then
  begin;
  if FRxDetailsShow then
    RxPanel.Visible := True
  else
    RxPanel.Visible := False;
  cnt := RxObjList.Count + 1;
  if cnt < 2 then
    cnt := 2;
  RxView.RowCount := cnt;
  RxView.ColCount := 7;
  RxView.ColWidths[0]:=70;
  RxView.Cells[0,0]:='Anzahl';
  RxView.ColWidths[1]:=80;
  RxView.Cells[1,0]:='Period [ms]';
  RxView.ColWidths[2]:=55;
  RxView.Cells[2,0]:='Frame';
  RxView.ColWidths[3]:=65;
  RxView.Cells[3,0]:='ID';
  RxView.ColWidths[4]:=30;
  RxView.Cells[4,0]:='DLC';
  RxView.ColWidths[5]:=185;
  RxView.Cells[5,0]:='DATA [HEX]';
  RxView.ColWidths[6]:=100;
  RxView.Cells[6,0]:='DATA [ASCII]';
  end
else
  begin;
  cnt := RxList.Count + 1;
  if cnt < 2 then
    cnt := 2;
  RxView.RowCount := cnt;
  RxView.ColCount := 6;
  RxView.ColWidths[0]:=80;
  RxView.Cells[0,0]:='Time [ms]';
  RxView.ColWidths[1]:=55;
  RxView.Cells[1,0]:='Frame';
  RxView.ColWidths[2]:=65;
  RxView.Cells[2,0]:='ID';
  RxView.ColWidths[3]:=30;
  RxView.Cells[3,0]:='DLC';
  RxView.ColWidths[4]:=185;
  RxView.Cells[4,0]:='DATA [HEX]';
  RxView.ColWidths[5]:=100;
  RxView.Cells[5,0]:='DATA [ASCII]';
  RxPanel.Visible := False;
  end;
RxView.Refresh;
end;


procedure TCanRxWin.SetRxDetailsShow(mode: Boolean);

begin;
if FRxDetailsShow <> mode then
  begin;
  FRxDetailsShow := mode;
  SetObjectMode(FObjectMode);
  end;
end;


procedure TCanRxWin.FormCreate(Sender: TObject);

begin
inherited;
RxList := TRxCanList.Create(self);
RxObjList := TRxCanObjList.Create(self);
ObjectMode := False;
RxDetailsShow := False;
TraceFile := '';
end;


procedure TCanRxWin.FormDestroy(Sender: TObject);

begin
if Assigned(RxList) then
  FreeAndNil(RxList);
if Assigned(RxObjList) then
  FreeAndNil(RxObjList);
inherited;
end;


procedure TCanRxWin.CleanStatMessage;

begin;
HeaderLabel.Caption := '[ID: ] [Count: 0] [Period: * Min: * Max: *]';
Analog1.Position := 0;
Analog2.Position := 0;
Analog3.Position := 0;
Analog4.Position := 0;
Analog5.Position := 0;
Analog6.Position := 0;
Analog7.Position := 0;
Analog8.Position := 0;
HexLabel.Caption := '';
BinLabel.Caption := '';
DezLabel.Caption := '';
AsciiLabel.Caption := '';
end;


procedure TCanRxWin.DrawStatMessage(index: Integer);
var can_msg: PCanMsg;
    msg_buf: TRxCanMsgObj;
    bin_str: string[200];
    ascii_str: string[200];
    bin_len, ascii_len, d: byte;
    dlc, i, ii: integer;
    rtr, eff, err: boolean;
    intervall, min, max, msg_count: DWord;

begin;
if not RxPanel.Visible then
  exit;
if RxObjList.ReadCanMsg(index, msg_buf) < 0 then
  begin;
  CleanStatMessage;
  exit;
  end;   
can_msg := @msg_buf.CanMsg;
msg_count := msg_buf.MsgCount;
intervall := msg_buf.Intervall;
min := msg_buf.Min;
max := msg_buf.Max;

dlc := can_msg^.Flags and FlagsCanLength;
if (can_msg^.Flags and FlagsCanError) > 0 then
  err := True
else
  err := False;    
if (can_msg^.Flags and FlagsCanEFF) > 0 then
  eff := True
else
  eff := False;
if (can_msg^.Flags and FlagsCanRTR) > 0 then
  rtr := True
else
  rtr := False;
if err then
  begin;  
  HeaderLabel.Caption := 'CAN Bus Fehler';
  dlc := 0;  
  end
else if rtr and eff then
  HeaderLabel.Caption := Format('[ID:%.8X  EFF/RTR] [Count: %10u] [Period: %u  Min: %u Max: %u]',
    [can_msg^.ID, msg_count, intervall, min, max])
else if eff then
  HeaderLabel.Caption := Format('[ID:%.8X  EFF] [Count: %10u] [Period: %u  Min: %u Max: %u]',
    [can_msg^.ID, msg_count, intervall, min, max])
else if rtr then
  HeaderLabel.Caption := Format('[ID:%.3X  STD/RTR] [Count: %10u] [Period: %u  Min: %u Max: %u]',
    [can_msg^.ID, msg_count, intervall, min, max])
else
  HeaderLabel.Caption := Format('[ID:%.3X  STD] [Count: %10u] [Period: %u  Min: %u Max: %u]',
    [can_msg^.ID, msg_count, intervall, min, max]);
// **** Daten (Hex)
if (dlc > 0) and not rtr then
  begin;
  case dlc of
    1 : begin;
        HexLabel.Caption := format('   %.2x ', [can_msg^.Data.Bytes[0]]);
        DezLabel.Caption := format('   %-3u ', [can_msg^.Data.Bytes[0]]);
        Analog1.Position := can_msg^.Data.Bytes[0];
        Analog2.Position := 0;
        Analog3.Position := 0;
        Analog4.Position := 0;
        Analog5.Position := 0;
        Analog6.Position := 0;
        Analog7.Position := 0;
        Analog8.Position := 0;
        end;
    2 : begin;
        HexLabel.Caption := format('   %.2X       %.2X', [can_msg^.Data.Bytes[0], can_msg^.Data.Bytes[1]]);
        DezLabel.Caption := format('   %-3u      %-3u', [can_msg^.Data.Bytes[0], can_msg^.Data.Bytes[1]]);
        Analog1.Position := can_msg^.Data.Bytes[0];
        Analog2.Position := can_msg^.Data.Bytes[1];
        Analog3.Position := 0;
        Analog4.Position := 0;
        Analog5.Position := 0;
        Analog6.Position := 0;
        Analog7.Position := 0;
        Analog8.Position := 0;
        end;
    3 : begin;
        HexLabel.Caption := format('   %.2X       %.2X       %.2X', [can_msg^.Data.Bytes[0],
         can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2]]);
        DezLabel.Caption := format('   %-3u      %-3u      %-3u', [can_msg^.Data.Bytes[0],
         can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2]]);
        Analog1.Position := can_msg^.Data.Bytes[0];
        Analog2.Position := can_msg^.Data.Bytes[1];
        Analog3.Position := can_msg^.Data.Bytes[2];
        Analog4.Position := 0;
        Analog5.Position := 0;
        Analog6.Position := 0;
        Analog7.Position := 0;
        Analog8.Position := 0;
        end;
    4 : begin;
        HexLabel.Caption := format('   %.2X       %.2X       %.2X       %.2X', [can_msg^.Data.Bytes[0],
         can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2],can_msg^.Data.Bytes[3]]);
        DezLabel.Caption := format('   %-3u      %-3u      %-3u      %-3u', [can_msg^.Data.Bytes[0],
         can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2],can_msg^.Data.Bytes[3]]);
        Analog1.Position := can_msg^.Data.Bytes[0];
        Analog2.Position := can_msg^.Data.Bytes[1];
        Analog3.Position := can_msg^.Data.Bytes[2];
        Analog4.Position := can_msg^.Data.Bytes[3];
        Analog5.Position := 0;
        Analog6.Position := 0;
        Analog7.Position := 0;
        Analog8.Position := 0;
        end;
    5 : begin;
        HexLabel.Caption := format('   %.2X       %.2X       %.2X       %.2X       %.2X', [can_msg^.Data.Bytes[0],
         can_msg^.Data.Bytes[1], can_msg^.Data.Bytes[2], can_msg^.Data.Bytes[3], can_msg^.Data.Bytes[4]]);
        DezLabel.Caption := format('   %-3u      %-3u      %-3u      %-3u      %-3u', [can_msg^.Data.Bytes[0],
         can_msg^.Data.Bytes[1], can_msg^.Data.Bytes[2], can_msg^.Data.Bytes[3], can_msg^.Data.Bytes[4]]);
        Analog1.Position := can_msg^.Data.Bytes[0];
        Analog2.Position := can_msg^.Data.Bytes[1];
        Analog3.Position := can_msg^.Data.Bytes[2];
        Analog4.Position := can_msg^.Data.Bytes[3];
        Analog5.Position := can_msg^.Data.Bytes[4];
        Analog6.Position := 0;
        Analog7.Position := 0;
        Analog8.Position := 0;
        end;
    6 : begin;
        HexLabel.Caption := format('   %.2X       %.2X       %.2X       %.2X       %.2X       %.2X',
         [can_msg^.Data.Bytes[0], can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2],can_msg^.Data.Bytes[3],
         can_msg^.Data.Bytes[4], can_msg^.Data.Bytes[5]]);
        DezLabel.Caption := format('   %-3u      %-3u      %-3u      %-3u      %-3u      %-3u',
         [can_msg^.Data.Bytes[0], can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2],can_msg^.Data.Bytes[3],
         can_msg^.Data.Bytes[4], can_msg^.Data.Bytes[5]]);
        Analog1.Position := can_msg^.Data.Bytes[0];
        Analog2.Position := can_msg^.Data.Bytes[1];
        Analog3.Position := can_msg^.Data.Bytes[2];
        Analog4.Position := can_msg^.Data.Bytes[3];
        Analog5.Position := can_msg^.Data.Bytes[4];
        Analog6.Position := can_msg^.Data.Bytes[5];
        Analog7.Position := 0;
        Analog8.Position := 0;
        end;
    7 : begin;
        HexLabel.Caption := format('   %.2X       %.2X       %.2X       %.2X       %.2X       %.2X       %.2X',
         [can_msg^.Data.Bytes[0], can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2],can_msg^.Data.Bytes[3],
         can_msg^.Data.Bytes[4], can_msg^.Data.Bytes[5],can_msg^.Data.Bytes[6]]);
        DezLabel.Caption := format('   %-3u      %-3u      %-3u      %-3u      %-3u      %-3u      %-3u',
         [can_msg^.Data.Bytes[0], can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2],can_msg^.Data.Bytes[3],
         can_msg^.Data.Bytes[4], can_msg^.Data.Bytes[5],can_msg^.Data.Bytes[6]]);
        Analog1.Position := can_msg^.Data.Bytes[0];
        Analog2.Position := can_msg^.Data.Bytes[1];
        Analog3.Position := can_msg^.Data.Bytes[2];
        Analog4.Position := can_msg^.Data.Bytes[3];
        Analog5.Position := can_msg^.Data.Bytes[4];
        Analog6.Position := can_msg^.Data.Bytes[5];
        Analog7.Position := can_msg^.Data.Bytes[6];
        Analog8.Position := 0;
        end;
    8 : begin;
        HexLabel.Caption := format('   %.2X       %.2X       %.2X       %.2X       %.2X       %.2X       %.2X       %.2X',
         [can_msg^.Data.Bytes[0], can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2],can_msg^.Data.Bytes[3],
         can_msg^.Data.Bytes[4], can_msg^.Data.Bytes[5],can_msg^.Data.Bytes[6],can_msg^.Data.Bytes[7]]);
        DezLabel.Caption := format('   %-3u      %-3u      %-3u      %-3u      %-3u      %-3u      %-3u      %-3u',
         [can_msg^.Data.Bytes[0], can_msg^.Data.Bytes[1],can_msg^.Data.Bytes[2],can_msg^.Data.Bytes[3],
         can_msg^.Data.Bytes[4], can_msg^.Data.Bytes[5],can_msg^.Data.Bytes[6],can_msg^.Data.Bytes[7]]);
        Analog1.Position := can_msg^.Data.Bytes[0];
        Analog2.Position := can_msg^.Data.Bytes[1];
        Analog3.Position := can_msg^.Data.Bytes[2];
        Analog4.Position := can_msg^.Data.Bytes[3];
        Analog5.Position := can_msg^.Data.Bytes[4];
        Analog6.Position := can_msg^.Data.Bytes[5];
        Analog7.Position := can_msg^.Data.Bytes[6];
        Analog8.Position := can_msg^.Data.Bytes[7];
        end;
    end;
  // Init Bin
  bin_len := 1;
  // Init ASCII
  ascii_len := 4;
  ascii_str := '   ';
  for i := 0 to dlc-1 do
    begin;
    d := can_msg^.Data.Bytes[i];
    // ASCII / Bin
    if i > 0 then
      begin
      for ii := 1 to 8 do
        begin;
        ascii_str[ascii_len] := ' ';
        inc(ascii_len);
        end;
      bin_str[bin_len] := ' ';
      inc(bin_len);
      end;
    // ASCII
    if chr(d) in [chr(32)..chr(126)] then
      ascii_str[ascii_len] := chr(d)
    else
      ascii_str[ascii_len] := '.';
    inc(ascii_len);
    // Binär
    for ii := 0 to 7 do
      begin;
      if (d and $80) > 0 then
        bin_str[bin_len] := '1'
      else
        bin_str[bin_len] := '0';
      inc(bin_len);
      d := d SHL $01;
      end;
    end;
  // Fini Binär
  bin_str[0] := Char(bin_len);
  BinLabel.Caption := bin_str;
  // Fini ASCII
  ascii_str[0] := Char(ascii_len);
  AsciiLabel.Caption := ascii_str;
  end
else
  begin;
  Analog1.Position := 0;
  Analog2.Position := 0;
  Analog3.Position := 0;
  Analog4.Position := 0;
  Analog5.Position := 0;
  Analog6.Position := 0;
  Analog7.Position := 0;
  Analog8.Position := 0;
  HexLabel.Caption := '';
  BinLabel.Caption := '';
  DezLabel.Caption := '';
  AsciiLabel.Caption := '';
  end;
end;


procedure TCanRxWin.RxViewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var can_msg: PCanMsg;
    msg_buf: TCanMsg;
    msg_obj_buf: TRxCanMsgObj;
    str: string[200];
    d, len, err_nr, bus_stat: Byte;
    dlc, i: integer;
    rtr, eff: boolean;
    ofs, timestamp, s, ms, msg_count: DWord;

begin
if ARow = 0 then
  exit;
RxView.Canvas.Brush.Color := RxView.Color;
RxView.Canvas.Font.Color := clWindowText;

if gdFocused in State then
  begin
  RxView.Canvas.Brush.Color := clActiveCaption;
  RxView.Canvas.Font.Color := clCaptionText;
  end
else if gdFixed in State then
  RxView.Canvas.Brush.Color := RxView.FixedColor;
RxView.Canvas.FillRect(Rect);
str := '';
msg_count := 0;
if FObjectMode then
  begin;
  if RxObjList.ReadCanMsg(ARow-1, msg_obj_buf) < 0 then
    begin;
    RxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
    DrawStatMessage(-1);
    exit;
    end;
  if ARow = RxView.Row then
    DrawStatMessage(ARow-1);
  can_msg := @msg_obj_buf.CanMsg;
  msg_count := msg_obj_buf.MsgCount;
  timestamp := msg_obj_buf.Intervall;    
  end
else
  begin;
  if RxList.ReadCanMsg(ARow-1, msg_buf) < 0 then
    begin;
    RxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
    exit;
    end;  
  can_msg := @msg_buf;  
  ofs := (RxList.FirstTime.USec div 1000) + (RxList.FirstTime.Sec * 1000);
  timestamp := (can_msg^.Time.USec div 1000) + (can_msg^.Time.Sec * 1000) - ofs;
  end;

if (can_msg^.Flags and FlagsCanError) > 0 then
  begin;  // Fehler
   RxView.Canvas.Font.Color := clRed;
  case ACol of
    0 : str := format('%u', [timestamp]);   // Timestamp
    1 : str := 'ERROR';                     // Frame Format
    2 : str := '';                          // ID
    3 : str := '';                          // DLC
    4 : begin;                              // Daten (Hex)
        err_nr := can_msg^.Data.Bytes[0];
        bus_stat := can_msg^.Data.Bytes[1] and $0F;
        if (err_nr > 0) and (err_nr < 7) and (bus_stat < 4) then
          str := format('[%s] %s', [CanBusStatusStr[bus_stat], CanErrorsStr[err_nr]])
        else
          str := 'Unbek. Fehler';
        end;
    5 : begin;
        if (can_msg^.Data.Bytes[1] and $10) = $10 then
          str := 'BUS-FAILURE'
        else
          str := '';                          // Daten (ASCII)
        end;
  end;
  RxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
  exit;
  end;

if (can_msg^.Flags and FlagsCanFilHit) > 0 then
  RxView.Canvas.Font.Color := clLime;
dlc := can_msg^.Flags and FlagsCanLength;
if (can_msg^.Flags and FlagsCanEFF) > 0 then
  eff := True
else
  eff := False;
if (can_msg^.Flags and FlagsCanRTR) > 0 then
  rtr := True
else
  rtr := False;
if FObjectMode then
  begin;
  if ACol = 0 then
    str := format('%u', [msg_count]);
  dec(ACol);
  end;
case ACol of
  0 : begin        // Timestamp
      //str := format('%u', [timestamp]); <*>
      s := timestamp div 1000;
      ms := timestamp mod 1000;
      str := format('%6u.%.3u', [s,ms]);
      
      end;
  1 : begin;                         // Frame Format
      if rtr and eff then
        str := 'EFF/RTR'
      else if eff then
        str := 'EFF'
      else if rtr then
        str := 'STD/RTR'
      else
        str := 'STD';
      end;
  2 : begin;
      if eff then
        str := Format('%08X',[can_msg^.ID])   // ID
      else
        str := Format('%04X',[can_msg^.ID]);  // ID
      end;
  3 : str := format('%u',[dlc]);     // DLC
  4 : begin;                          // Daten (Hex)
      if (dlc > 0) and not rtr then
        begin;
        len := 0;
        for i := 0 to dlc-1 do
          begin;
          d := can_msg^.Data.Bytes[i];
          if i > 0 then
            begin
            inc(len);
            str[len] := ' ';
            end;
          inc(len);
          str[len] := HexDigits[d SHR $04];
          inc(len);
          str[len] := HexDigits[d AND $0F];
          end;
        str[0] := Char(len);
        end
      else
        str := '';
      end;
  5 : begin;       // Daten (ASCII)
      if (dlc > 0) and not rtr then
        begin;
        len := 0;
        for i := 0 to dlc-1 do
          begin;
          inc(len);
          d := can_msg^.Data.Bytes[i];
          if chr(d) in [chr(32)..chr(126)] then
            str[len] := chr(d)
          else
            str[len] := '.';
          end;
        str[0] := Char(len);
        end
      else
        str := '';
      end;
  end;
RxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
end;


procedure TCanRxWin.RxCanMessages(can_msg: PCanMsg; count: Integer);
var i: Integer;

begin
if (not EnableTrace) or (count = 0) then
  exit;
for i := 1 to count do
  begin;  
  if RxFilterMode = RxMsgShowUsed then
    begin;
    if (can_msg^.Flags and FlagsCanFilHit) = 0 then
      continue;
    end
  else if RxFilterMode = RxMsgShowUnused then
    begin;
    if (can_msg^.Flags and FlagsCanFilHit) <> 0 then
      continue;
    end;
  RxList.Add(can_msg);
  RxObjList.Add(can_msg);
  inc(can_msg);
  end;
end;


procedure TCanRxWin.RxCanUpdate;
var cnt: Integer;

begin
if not EnableTrace then
  exit;
if FObjectMode then
  cnt := RxObjList.Count + 1
else
  cnt := RxList.Count + 1;  
if cnt < 2 then
  cnt := 2;
if RxView.RowCount <> cnt then
  begin;
  RxView.RowCount := cnt;
  if not FObjectMode then
    RxView.Row := cnt - 1;
  end;
RxView.Refresh;
end;


procedure TCanRxWin.ExecuteCmd(cmd: Integer; can_msg: PCanMsg);

begin;
case cmd of
  RX_WIN_SHOW_TRACE  : begin;
                       ObjectMode := False;   
                       end;
  RX_WIN_SHOW_OBJECT : begin;
                       ObjectMode := True;
                       end;
  RX_WIN_CLEAR       : begin;
                       RxList.Clear;
                       RxObjList.Clear;
                       RxView.RowCount := 2;
                       RxView.Refresh;
                       end;
  RX_WIN_SAVE_TRACE  : begin;
                       if RxList.Count = 0 then
                         begin;
                         MessageDlg('Keine Daten zum Speichern!', mtError, [mbOk], 0);
                         exit;
                         end;
                       SaveDialog.FileName := TraceFile;
                       if SaveDialog.Execute then
                         begin;
                         TraceFile := SaveDialog.FileName;
                         if length(TraceFile) > 0 then
                           RxList.SaveToFile(TraceFile);
                         end;
                       end;
  RX_WIN_SHOW_RX_PANNEL :
                       begin;
                       RxDetailsShow := True;
                       ShowRxPannelPopup.Checked := RxDetailsShow;
                       //RxView.Refresh;
                       end;
  RX_WIN_HIDE_RX_PANNEL :
                       begin;
                       RxDetailsShow := False;
                       ShowRxPannelPopup.Checked := RxDetailsShow;
                       //RxView.Refresh;
                       end;
  RX_WIN_STAT_CLEAR  : begin;
                       RxObjList.ClearStat;
                       RxView.Refresh;
                       end;
  RX_WIN_SHOW_ALL_MSG: RxFilterMode := RxMsgShowAll;
  RX_WIN_SHOW_USED_MSG : RxFilterMode := RxMsgShowUsed;
  RX_WIN_SHOW_UNUSED_MSG : RxFilterMode := RxMsgShowUnused;
  RX_WIN_START_TRACE : EnableTrace := True;
  RX_WIN_STOP_TRACE  : EnableTrace := False;
  end;
end;


procedure TCanRxWin.RxViewClick(Sender: TObject);
begin
inherited;
if RxView.Row = 0 then
  exit;
DrawStatMessage(RxView.Row-1);
end;


procedure TCanRxWin.AddMsgToTxWinPopupClick(Sender: TObject);
var can_msg: PCanMsg;
    msg_buf: TCanMsg;
    msg_obj_buf: TRxCanMsgObj;

begin
  inherited;
if RxView.Row = 0 then
  exit;
if FObjectMode then
  begin;
  if RxObjList.ReadCanMsg(RxView.Row-1, msg_obj_buf) < 0 then
    exit;
  can_msg := @msg_obj_buf.CanMsg;
  end
else
  begin;
  if RxList.ReadCanMsg(RxView.Row-1, msg_buf) < 0 then
    exit;
  can_msg := @msg_buf;      
  end;
if (can_msg^.Flags and FlagsCanError) > 0 then
  exit;  // Fehler Message
if Assigned(MainWin.CanTxWin) then
  MainWin.CanTxWin.ExecuteCmd(TX_WIN_ADD_MESSAGE, can_msg);
end;


procedure TCanRxWin.ShowRxPannelPopupClick(Sender: TObject);
begin
  inherited;
MainWin.RxPannelShow := ShowRxPannelPopup.Checked;
MainWin.SetRxPannelShow;
end;


procedure TCanRxWin.ClearStatistikPopupClick(Sender: TObject);
begin
  inherited;
RxObjList.ClearStat;
RxView.Refresh;
end;

end.

