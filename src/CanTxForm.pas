{***************************************************************************
                       CanTxForm.pas  -  description
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
unit CanTxForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, Buttons, StrUtils, Menus, mmsystem,
  util, TinyCanDrv, zahlen32, zahlen, CanRxPrototyp, CanRx, CanTx;

const
  TX_WIN_SAVE  = 1;
  TX_WIN_LOAD  = 2;
  TX_WIN_CLEAR = 3;
  TX_WIN_ENABLE_INTERVALL = 4;
  TX_WIN_DISABLE_INTERVALL = 5;
  TX_WIN_ADD_MESSAGE = 6;

type
  TCanTxWin = class(TCanRxPrototypForm)
    TxView: TStringGrid;
    KopfPanel: TPanel;
    MsgAddBtn: TBitBtn;
    MsgDelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Data1Edit: TZahlenEdit;
    Data2Edit: TZahlenEdit;
    Data3Edit: TZahlenEdit;
    Data4Edit: TZahlenEdit;
    Data8Edit: TZahlenEdit;
    Data5Edit: TZahlenEdit;
    Data6Edit: TZahlenEdit;
    Data7Edit: TZahlenEdit;
    DLCEdit: TZahlenEdit;
    CanFormatGroupBox: TGroupBox;
    RTRCheck: TCheckBox;
    EFFCheck: TCheckBox;
    IDEdit: TZahlen32Edit;
    Label4: TLabel;
    Label5: TLabel;
    CommentEdit: TEdit;
    TxModeCombo: TComboBox;
    TriggerIdEdit: TZahlen32Edit;
    Label6: TLabel;
    Label7: TLabel;
    IntervallEdit: TZahlen32Edit;
    MsgTxBtn: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    MsgCopyBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MsgAddBtnClick(Sender: TObject);
    procedure MsgDelBtnClick(Sender: TObject);
    procedure TxViewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure TxViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TxViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MsgTxBtnClick(Sender: TObject);
    procedure MsgCopyBtnClick(Sender: TObject);
    procedure TxViewClick(Sender: TObject);
  private
    { Private-Deklarationen }
    PressedBtn: integer;
    //AIndex: Integer;
    procedure EmptyMessage(can_msg: PTxCanMsg);
    procedure GetMsgFromUi(can_msg: PTxCanMsg);
    procedure SetMsgToUi(can_msg: PTxCanMsg);
    procedure DisableTxEditEvents;
    procedure EnableTxEditEvents;
    procedure TxEditChange(sender: TObject);
    procedure TxEditOnChange(Sender: TObject);
    procedure TxEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    { Public-Deklarationen }
    TxList: TTxCanList;
    TxListFile: String;
    procedure RxCanMessages(can_msg: PCanMsg; count: Integer); override;
    procedure RxCanUpdate; override;    
    procedure ExecuteCmd(cmd: Integer; can_msg: PCanMsg);
  end;


implementation

uses MainForm;

{$R *.dfm}

{ TSendenForm }

procedure TCanTxWin.FormCreate(Sender: TObject);

begin
inherited;
TMainWin(owner).ButtonImages.GetBitmap(2, MsgAddBtn.Glyph);
TMainWin(owner).ButtonImages.GetBitmap(0, MsgCopyBtn.Glyph);
TMainWin(owner).ButtonImages.GetBitmap(6, MsgTxBtn.Glyph);
TMainWin(owner).ButtonImages.GetBitmap(3, MsgDelBtn.Glyph);
PressedBtn := 0;
TxList := TTxCanList.Create(self);

TxView.ColWidths[0]:=55;
TxView.Cells[0,0]:='Frame';
TxView.ColWidths[1]:=65;
TxView.Cells[1,0]:='ID';
TxView.ColWidths[2]:=30;
TxView.Cells[2,0]:='DLC';
TxView.ColWidths[3]:=185;
TxView.Cells[3,0]:='DATA [HEX]';
TxView.ColWidths[4]:=70;
TxView.Cells[4,0]:='Auto';
TxView.ColWidths[5]:=70;
TxView.Cells[5,0]:='Intervall';
TxView.ColWidths[6]:=75;
TxView.Cells[6,0]:='Trigger ID';
TxView.ColWidths[7]:=200;
TxView.Cells[7,0]:='Komentar';
TxView.ColWidths[8]:=56;
TxView.Cells[8,0]:='Senden';
EnableTxEditEvents;
end;


procedure TCanTxWin.FormDestroy(Sender: TObject);

begin
if Assigned(TxList) then
  FreeAndNil(TxList);
inherited;
end;


procedure TCanTxWin.EmptyMessage(can_msg: PTxCanMsg);

begin;
can_msg^.CanMsg.Flags := 0;
can_msg^.CanMsg.ID := 0;
can_msg^.CanMsg.Data.Bytes[0] := 0;
can_msg^.CanMsg.Data.Bytes[1] := 0;
can_msg^.CanMsg.Data.Bytes[2] := 0;
can_msg^.CanMsg.Data.Bytes[3] := 0;
can_msg^.CanMsg.Data.Bytes[4] := 0;
can_msg^.CanMsg.Data.Bytes[5] := 0;
can_msg^.CanMsg.Data.Bytes[6] := 0;
can_msg^.CanMsg.Data.Bytes[7] := 0;
can_msg^.TxMode := 0;  // 0 = Off, 1 = Periodic, 2 = RTR, 3 = Trigger
can_msg^.Intervall := 0;
can_msg^.TriggerId := 0;
can_msg^.Comment := '';
end;


procedure TCanTxWin.GetMsgFromUi(can_msg: PTxCanMsg);

begin;
can_msg^.CanMsg.Flags:= DLCEdit.Number and FlagsCanLength;
if EFFCheck.Checked then
  can_msg^.CanMsg.Flags := can_msg^.CanMsg.Flags or FlagsCanEFF;
if RTRCheck.Checked then
  can_msg^.CanMsg.Flags := can_msg^.CanMsg.Flags or FlagsCanRTR;
can_msg^.CanMsg.ID:=IDEdit.Number;
can_msg^.CanMsg.Data.Bytes[0]:=Data1Edit.Number;
can_msg^.CanMsg.Data.Bytes[1]:=Data2Edit.Number;
can_msg^.CanMsg.Data.Bytes[2]:=Data3Edit.Number;
can_msg^.CanMsg.Data.Bytes[3]:=Data4Edit.Number;
can_msg^.CanMsg.Data.Bytes[4]:=Data5Edit.Number;
can_msg^.CanMsg.Data.Bytes[5]:=Data6Edit.Number;
can_msg^.CanMsg.Data.Bytes[6]:=Data7Edit.Number;
can_msg^.CanMsg.Data.Bytes[7]:=Data8Edit.Number;
can_msg^.TxMode := TxModeCombo.ItemIndex;   // 0 = Off, 1 = Periodic, 2 = RTR, 3 = Trigger
can_msg^.Intervall := IntervallEdit.Number;
can_msg^.TriggerId := TriggerIdEdit.Number;
can_msg^.Comment := CommentEdit.Text;
end;


procedure TCanTxWin.SetMsgToUi(can_msg: PTxCanMsg);
var len: integer;

begin;
DisableTxEditEvents;
if can_msg = nil then
  begin;
  DLCEdit.Number := 0;
  EFFCheck.Checked := False;
  RTRCheck.Checked := False;
  IDEdit.Number := 0;
  Data1Edit.Number := 0;
  Data2Edit.Number := 0;
  Data3Edit.Number := 0;
  Data4Edit.Number := 0;
  Data5Edit.Number := 0;
  Data6Edit.Number := 0;
  Data7Edit.Number := 0;
  Data8Edit.Number := 0;
  TxModeCombo.ItemIndex := 0;
  IntervallEdit.Number := 0;
  TriggerIdEdit.Number := 0;
  CommentEdit.Text := '';
  end
else
  begin;
  len := can_msg^.CanMsg.Flags and FlagsCanLength;
  DLCEdit.Number := len;
  if (can_msg^.CanMsg.Flags and FlagsCanEFF) > 0 then
    EFFCheck.Checked := True
  else
    EFFCheck.Checked := False;
  if (can_msg^.CanMsg.Flags and FlagsCanRTR) > 0 then
    RTRCheck.Checked := True
  else
    RTRCheck.Checked := False;
  IDEdit.Number := can_msg^.CanMsg.ID;
  if len > 0 then
    Data1Edit.Number := can_msg^.CanMsg.Data.Bytes[0]
  else
    Data1Edit.Number := 0;
  if len > 1 then
    Data2Edit.Number := can_msg^.CanMsg.Data.Bytes[1]
  else
    Data2Edit.Number := 0;
  if len > 2 then
    Data3Edit.Number := can_msg^.CanMsg.Data.Bytes[2]
  else
    Data3Edit.Number := 0;
  if len > 3 then
    Data4Edit.Number := can_msg^.CanMsg.Data.Bytes[3]
  else
    Data4Edit.Number := 0;
  if len > 4 then
    Data5Edit.Number := can_msg^.CanMsg.Data.Bytes[4]
  else
    Data5Edit.Number := 0;
  if len > 5 then
    Data6Edit.Number := can_msg^.CanMsg.Data.Bytes[5]
  else
    Data6Edit.Number := 0;
  if len > 6 then
    Data7Edit.Number := can_msg^.CanMsg.Data.Bytes[6]
  else
    Data7Edit.Number := 0;
  if len > 7 then
    Data8Edit.Number := can_msg^.CanMsg.Data.Bytes[7]
  else
    Data8Edit.Number := 0;

  TxModeCombo.ItemIndex := can_msg^.TxMode;   // 0 = Off, 1 = Periodic, 2 = RTR, 3 = Trigger
  IntervallEdit.Number := can_msg^.Intervall;
  TriggerIdEdit.Number := can_msg^.TriggerId;
  CommentEdit.Text := can_msg^.Comment;
  end;
EnableTxEditEvents;
end;


procedure TCanTxWin.MsgAddBtnClick(Sender: TObject);
var can_msg: TTxCanMsg;

begin
if TxList = nil then
  exit;
EmptyMessage(@can_msg);
TxList.Add(@can_msg);
TxView.RowCount := TxList.Count+1;
TxView.Row := TxView.RowCount - 1;
TxView.Refresh;
end;


procedure TCanTxWin.MsgCopyBtnClick(Sender: TObject);
var can_msg: TTxCanMsg;

begin
if TxList = nil then
  exit;
GetMsgFromUi(@can_msg);
TxList.Add(@can_msg);
TxView.RowCount := TxList.Count+1;
TxView.Row := TxView.RowCount - 1;
TxView.Refresh;
end;


procedure TCanTxWin.MsgDelBtnClick(Sender: TObject);

begin
if (TxList = nil) or (TxView.Row < 1) or (TxView.Row > TxList.Count) then
  exit;
TxList.Delete(TxView.Row-1);
if TxList.Count > 0 then
  TxView.RowCount := TxList.Count+1
else
  begin;
  TxView.RowCount := 2;
  TxView.Row := 1;
  end;
TxView.Refresh;
end;


procedure TCanTxWin.MsgTxBtnClick(Sender: TObject);
var can_msg: TTxCanMsg;

begin
if TxList = nil then
  exit;
if TxList.Count = 0 then
  begin;
  GetMsgFromUi(@can_msg);
  TxList.Add(@can_msg);
  TxView.RowCount := TxList.Count + 1;
  TxView.Row := TxView.RowCount - 1;
  TxView.Refresh;
  end;
if (TxView.Row <= TxList.Count) and (TxView.Row > 0) then
  TxList.Transmit(TxView.Row-1);
end;


procedure TCanTxWin.TxViewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  can_msg: PTxCanMsg;
  str: string[100];
  d, len: Byte;
  x, y, dlc, i: integer;
  rtr, eff: boolean;

begin
if ARow = 0 then
  exit;
str := '';
TxView.Canvas.Brush.Color := TxView.Color;
TxView.Canvas.Font.Color := clWindowText;
if gdFixed in State then
  TxView.Canvas.Brush.Color := TxView.FixedColor
else if (ARow = TxView.Row) and (ACol <> 8) then  // or (gdFocused in State)
  begin
  TxView.Canvas.Brush.Color := clActiveCaption;
  TxView.Canvas.Font.Color := clCaptionText;
  end;
TxView.Canvas.FillRect(Rect);

if (TxList.Count = 0) then
  begin;
  TxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, '');
  exit;
  end;
can_msg := TxList[ARow-1];
if can_msg = nil then
  exit;
dlc := can_msg^.CanMsg.Flags and FlagsCanLength;
if (can_msg^.CanMsg.Flags and FlagsCanEFF) > 0 then
  eff := True
else
  eff := False;
if (can_msg^.CanMsg.Flags and FlagsCanRTR) > 0 then
  rtr := True
else
  rtr := False;
case ACol of
  0 :  begin;                         // Frame Format
       if rtr and eff then
         str := 'EFF/RTR'
       else if eff then
         str := 'EFF'
       else if rtr then
         str := 'STD/RTR'
       else
         str := 'STD';
       end;
  1 :  begin;
       if eff then
         str := Format('%08X',[can_msg^.CanMsg.ID])   // ID
       else
         str := Format('%03X',[can_msg^.CanMsg.ID]);  // ID
       end;
  2 : str := format('%u',[dlc]);      // DLC
  3 : begin;                          // Daten (Hex)
      if (dlc > 0) and not rtr then
        begin;
        len := 0;
        for i := 0 to dlc-1 do
          begin;
          d := can_msg^.CanMsg.Data.Bytes[i];
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
  4 : begin;    // Auto
      case can_msg^.TxMode of
        0 : str := 'Off';
        1 : str := 'Periodic';
        2 : str := 'RTR';
        3 : str := 'Trigger';
        end;
      end;
  5 : begin;
      str := format('%u',[can_msg^.Intervall])  // Intervall
      end;
  6 : begin;
      if can_msg^.TxMode = 3 then
        begin;
        if eff then
          str := Format('%08X',[can_msg^.TriggerId]) // Trigger ID
        else
          str := format('%03X',[can_msg^.TriggerId]) // Trigger ID
        end
      else
        str := '';
      end;
  7 : str := can_msg.Comment;  // Comment
  8 : begin       // Senden
      with TxView.Canvas do
        begin
        Brush.Color := clBtnFace;
        FillRect(Rect);
        if (PressedBtn <> ARow) then
          Pen.Color := clBtnHighlight
        else
          Pen.Color := clBtnShadow;
        MoveTo(Rect.Left, Rect.Bottom-1);
        LineTo(Rect.Left, Rect.Top);
        LineTo(Rect.Right-1, Rect.Top);
        if (PressedBtn <> ARow) then
          Pen.Color := clBtnShadow
        else
          Pen.Color := clBtnHighlight;
        LineTo(Rect.Right-1, Rect.Bottom-1);
        LineTo(Rect.Left, Rect.Bottom-1);
        str := 'Senden';
        Font.Color := clBtnText;
        x := (TxView.ColWidths[ACol] - TextWidth(str)) div 2;
        y := (TxView.DefaultRowHeight - TextHeight(str)) div 2;
        if (PressedBtn = ARow) then
          begin
          inc(x);
          inc(y);
          end;
        TextOut(Rect.Left+x, Rect.Top+y, str);
        end;
      end;
  end;
if ACol <> 8 then
  TxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
if (ACol = TxView.Col) and (ARow = TxView.Row) and (ACol <> 8) then
  TxView.Canvas.DrawFocusRect(Rect);
end;


procedure TCanTxWin.TxViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
ACol, ARow: integer;

begin
TxView.MouseToCell(X, Y, ACol, ARow);
if ACol = 8 then       // Senden Schaltfläche
  PressedBtn := ARow;
end;


procedure TCanTxWin.TxViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
ACol, ARow: integer;
//Key: char;

begin
TxView.MouseToCell(X, Y, ACol, ARow);
if (Button <> mbLeft) then
  Exit;
PressedBtn := 0;
if TxView.Col = 8 then    // Senden Schaltfläche
  begin
  TxViewDrawCell(Sender, TxView.Col, TxView.Row, TxView.CellRect(TxView.Col, TxView.Row), []);
  if (ACol = TxView.Col) and (ARow = TxView.Row) then
    if (ARow <= TxList.Count) and (ARow > 0) then
      TxList.Transmit(ARow-1);
  exit;
  end;
end;


procedure TCanTxWin.RxCanMessages(can_msg: PCanMsg; count: Integer);
var i: Integer;

begin;
if count = 0 then
  exit;
for i := 1 to count do
  begin;  
  TxList.RxMessage(can_msg);
  inc(can_msg);
  end;
end;


procedure TCanTxWin.RxCanUpdate;
begin
  ;
end;  


procedure TCanTxWin.ExecuteCmd(cmd: Integer; can_msg: PCanMsg);
var tx_msg: TTxCanMsg;

begin;
case cmd of  
  TX_WIN_SAVE  : begin;
                 if TxList.Count = 0 then
                   begin;
                   MessageDlg('Keine Daten zum Speichern!', mtError, [mbOk], 0);
                   exit;
                   end;
                 SaveDialog.FileName := TxListFile;
                 if SaveDialog.Execute then
                   begin;
                   TxListFile := SaveDialog.FileName;
                   if length(TxListFile) > 0 then
                     TxList.SaveToFile(TxListFile);
                   end;
                 end;
  TX_WIN_LOAD  : begin;
                 OpenDialog.FileName := TxListFile;
                 if OpenDialog.Execute then
                   begin;
                   TxListFile := OpenDialog.FileName;
                   if length(TxListFile) > 0 then
                     TxList.LoadFromFile(TxListFile);
                   end;
                 TxView.RowCount := TxList.Count + 1;
                 TxView.Row := 1;
                 if TxView.Row <= TxList.Count then
                   SetMsgToUi(TxList.Items[TxView.Row-1])
                 else
                   SetMsgToUi(nil);
                 TxView.Refresh;
                 end;
  TX_WIN_CLEAR : begin;
                 TxList.Clear;
                 SetMsgToUi(nil);
                 TxView.RowCount := 2;
                 TxView.Row := 1;
                 TxView.Refresh;
                 end;
  TX_WIN_ENABLE_INTERVALL :
                 begin;
                 TxList.SetIntervallMode(TRUE);
                 end;
  TX_WIN_DISABLE_INTERVALL :
                 begin;
                 TxList.SetIntervallMode(FALSE);
                 end;
  TX_WIN_ADD_MESSAGE :                 
                 begin;
                 if TxList <> nil then
                   begin;
                   EmptyMessage(@tx_msg);
                   Move(can_msg^, tx_msg.CanMsg, SizeOf(TCanMsg));
                   TxList.Add(@tx_msg);
                   TxView.RowCount := TxList.Count+1;
                   TxView.Row := TxView.RowCount - 1;
                   SetMsgToUi(TxList.Items[TxView.Row-1]);
                   TxView.Refresh;
                   end;
                 end;
  end;
end;


procedure TCanTxWin.DisableTxEditEvents;

begin;
IdEdit.OnChange := nil;
DLCEdit.OnChange := nil;
IdEdit.OnKeyUp := nil;
DLCEdit.OnKeyUp := nil;
Data1Edit.OnChange := nil;
Data2Edit.OnChange := nil;
Data3Edit.OnChange := nil;
Data4Edit.OnChange := nil;
Data5Edit.OnChange := nil;
Data6Edit.OnChange := nil;
Data7Edit.OnChange := nil;
Data8Edit.OnChange := nil;
Data1Edit.OnKeyUp := nil;
Data2Edit.OnKeyUp := nil;
Data3Edit.OnKeyUp := nil;
Data4Edit.OnKeyUp := nil;
Data5Edit.OnKeyUp := nil;
Data6Edit.OnKeyUp := nil;
Data7Edit.OnKeyUp := nil;
Data8Edit.OnKeyUp := nil;
TriggerIdEdit.OnChange := nil;
TriggerIdEdit.OnKeyUp := nil;
IntervallEdit.OnChange := nil;
IntervallEdit.OnKeyUp := nil;
CommentEdit.OnChange := nil;
RTRCheck.OnClick := nil;
EFFCheck.OnClick := nil;
TxModeCombo.OnChange := nil;
end;


procedure TCanTxWin.EnableTxEditEvents;

begin;
IdEdit.OnChange := TxEditOnChange;
DLCEdit.OnChange := TxEditOnChange;
IdEdit.OnKeyUp := TxEditKeyUp;
DLCEdit.OnKeyUp := TxEditKeyUp;
Data1Edit.OnChange := TxEditOnChange;
Data2Edit.OnChange := TxEditOnChange;
Data3Edit.OnChange := TxEditOnChange;
Data4Edit.OnChange := TxEditOnChange;
Data5Edit.OnChange := TxEditOnChange;
Data6Edit.OnChange := TxEditOnChange;
Data7Edit.OnChange := TxEditOnChange;
Data8Edit.OnChange := TxEditOnChange;
Data1Edit.OnKeyUp := TxEditKeyUp;
Data2Edit.OnKeyUp := TxEditKeyUp;
Data3Edit.OnKeyUp := TxEditKeyUp;
Data4Edit.OnKeyUp := TxEditKeyUp;
Data5Edit.OnKeyUp := TxEditKeyUp;
Data6Edit.OnKeyUp := TxEditKeyUp;
Data7Edit.OnKeyUp := TxEditKeyUp;
Data8Edit.OnKeyUp := TxEditKeyUp;
TriggerIdEdit.OnChange := TxEditOnChange;
TriggerIdEdit.OnKeyUp := TxEditKeyUp;
IntervallEdit.OnChange := TxEditOnChange;
IntervallEdit.OnKeyUp := TxEditKeyUp;
CommentEdit.OnChange := TxEditOnChange;
RTRCheck.OnClick := TxEditOnChange;
EFFCheck.OnClick := TxEditOnChange;
TxModeCombo.OnChange := TxEditOnChange;
end;


procedure TCanTxWin.TxEditChange(sender: TObject);
var can_msg: PTxCanMsg;
    flags: DWord;

begin;
can_msg := nil;
if (TxView.Row <= TxList.Count) and (TxView.Row > 0) then
  can_msg := TxList.Items[TxView.Row-1];
if can_msg = nil then
  exit;
case TComponent(sender).Tag of
  0  : can_msg^.CanMsg.ID:=IDEdit.Number;
  2  : can_msg^.CanMsg.Data.Bytes[0]:=Data1Edit.Number;
  3  : can_msg^.CanMsg.Data.Bytes[1]:=Data2Edit.Number;
  4  : can_msg^.CanMsg.Data.Bytes[2]:=Data3Edit.Number;
  5  : can_msg^.CanMsg.Data.Bytes[3]:=Data4Edit.Number;
  6  : can_msg^.CanMsg.Data.Bytes[4]:=Data5Edit.Number;
  7  : can_msg^.CanMsg.Data.Bytes[5]:=Data6Edit.Number;
  8  : can_msg^.CanMsg.Data.Bytes[6]:=Data7Edit.Number;
  9  : can_msg^.CanMsg.Data.Bytes[7]:=Data8Edit.Number;
  10 : can_msg^.Comment := CommentEdit.Text;
  11 : can_msg^.TriggerId := TriggerIdEdit.Number;
  12 : begin;
       can_msg^.Intervall := IntervallEdit.Number
       end;
  1, 13, 14 :
       begin;
       flags := DLCEdit.Number and FlagsCanLength;
       if RTRCheck.Checked then
         flags := flags or FlagsCanRTR;
       if EFFCheck.Checked then
         flags := flags or FlagsCanEFF;
       can_msg^.CanMsg.Flags:= flags;
       end;
  15 : can_msg^.TxMode := TxModeCombo.ItemIndex;   // 0 = Off, 1 = Periodic, 2 = RTR, 3 = Trigger
  end;
TxView.Refresh;
end;


procedure TCanTxWin.TxEditOnChange(Sender: TObject);
begin
TxEditChange(Sender);
end;


procedure TCanTxWin.TxEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
TxEditChange(Sender);
end;


procedure TCanTxWin.TxViewClick(Sender: TObject);
var can_msg: PTxCanMsg;

begin
TxView.Repaint;
{if TxView.Col = 8 then  // ?
  exit;}
can_msg := nil;
if (TxView.Row <= TxList.Count) and (TxView.Row > 0) then
  can_msg := TxList.Items[TxView.Row-1];
if can_msg = nil then
  exit;
SetMsgToUi(can_msg);
end;


end.

