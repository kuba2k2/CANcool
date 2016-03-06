{***************************************************************************
                      CanValueForm.pas  -  description
                             -------------------
    begin             : 03.12.2012
    last modified     : 27.02.2016     
    copyright         : (C) 2012 - 2016 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanValueForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CanRxPrototyp, StdCtrls, Buttons, MainForm, IntegerTerm,
  ExtCtrls, Menus, RackCtls, Util, TinyCanDrv;

type
  TCanValueWin = class(TCanRxPrototypForm)
    EinheitLabel: TLabel;
    WertAnzMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    LEDDisplay: TLEDDisplay;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure AktivBtnClick(Sender: TObject);
    procedure DestroyBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LockStatus: boolean;
    WidgetAktiv: boolean;
    BerechnungsObj: TIntTerm;
    DataChange: Boolean;
    Data: array[0..7] of Byte;
    Varis: VarArray;
    CanId: longword;
    Formula: string;
    UnitStr: string;
    Margin: integer;       // Abstand der Skala zum Rand
    FSizeType: Integer;
    procedure Lock;
    procedure Unlock;
    procedure SetFSizeType(value: Integer);
    property SizeType: Integer read FSizeType write SetFSizeType;
  public
    { Public-Deklarationen }
    procedure RxCanMessages(can_msg: PCanMsg; count: Integer); override;
    procedure RxCanUpdate; override; 
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

var
  CanValueWin: TCanValueWin;

implementation

uses CanValueSetupForm; 

{$R *.dfm}

procedure TCanValueWin.FormCreate(Sender: TObject);
var
  i: integer;

begin
inherited;
BerechnungsObj := TIntTerm.Create;

SetLength(Varis, 8);
for i := 0 to high(Varis) do
  begin
  Varis[i].Name := format('d%u',[i]);
  Varis[i].Wert := 0;
  end;

WidgetAktiv := True;
LockStatus := False;
Margin := 5;
UnitStr := 'x';
CanId := 0;
Formula := '(d0 << 8) + d1';
SizeType := 1;
LEDDisplay.FractionDigits := 0;
LEDDisplay.Value := 0;
FormResize(self);
end;


procedure TCanValueWin.FormResize(Sender: TObject);
var h: Integer;

begin
inherited;
LEDDisplay.Left := Margin;
EinheitLabel.Left := LEDDisplay.Left + LEDDisplay.Width + Margin;
EinheitLabel.Width := EinheitLabel.Canvas.TextWidth(UnitStr);
EinheitLabel.Height := EinheitLabel.Canvas.TextHeight(UnitStr);
self.ClientWidth := LEDDisplay.Width + EinheitLabel.Width + (2 * Margin);
h := LEDDisplay.Top + LEDDisplay.Height + Margin;
EinheitLabel.Top := h - (EinheitLabel.Height + 5);
self.ClientHeight := h;
EinheitLabel.Caption := UnitStr;
end;


procedure TCanValueWin.SetFSizeType(value: Integer);
begin
if value <> FSizeType then
  begin
  FSizeType := value;
  case value of
    0 : begin;
        EinheitLabel.Font.Size := 10;
        LEDDisplay.DigitLineWidth := 2;
        LEDDisplay.DigitHeight := 28;
        LEDDisplay.DigitWidth := 15;
        LEDDisplay.Height := 30;
        LEDDisplay.Width := 120;
        end;
    1 : begin;
        EinheitLabel.Font.Size := 18;
        LEDDisplay.DigitLineWidth := 4;
        LEDDisplay.DigitHeight := 50;
        LEDDisplay.DigitWidth := 28;
        LEDDisplay.Height := 57;
        LEDDisplay.Width := 209;
        end;
    2 : begin;
        EinheitLabel.Font.Size := 28;
        LEDDisplay.DigitLineWidth := 7;
        LEDDisplay.DigitHeight := 90;
        LEDDisplay.DigitWidth := 57;
        LEDDisplay.Height := 100;
        LEDDisplay.Width := 400;
        end;
    else

    end;
  end;
end;


procedure TCanValueWin.LoadConfig(ConfigList: TStrings);

begin
Lock;
self.Caption := ReadListString(ConfigList, 'Name', self.Caption);
CanId := ReadListInteger(ConfigList, 'CanId', CanId);
Formula := ReadListString(ConfigList, 'Formula', Formula);
UnitStr := ReadListString(ConfigList, 'Unit', UnitStr);
LEDDisplay.ColorLED := TColor(ReadListInteger(ConfigList, 'BaseColor', Integer(LEDDisplay.ColorLED)));
EinheitLabel.Font.Color := LEDDisplay.ColorLED;
SizeType := ReadListInteger(ConfigList, 'SizeType', SizeType);
LEDDisplay.FractionDigits := ReadListInteger(ConfigList, 'PrecDigits', LEDDisplay.FractionDigits);
FormResize(self);
WindowMenuItem.Caption :=  self.Caption;
Unlock;
end;


procedure TCanValueWin.SaveConfig(ConfigList: TStrings);

begin
ConfigList.Append(format('Name=%s', [self.Caption]));
ConfigList.Append(format('CanId=%u', [CanId]));
ConfigList.Append(format('Formula=%s', [Formula]));
ConfigList.Append(format('Unit=%s', [UnitStr]));
ConfigList.Append(format('BaseColor=%d', [Integer(LEDDisplay.ColorLED)]));
ConfigList.Append(format('SizeType=%u', [SizeType]));
ConfigList.Append(format('PrecDigits=%d', [LEDDisplay.FractionDigits]));
end;


procedure TCanValueWin.RxCanMessages(can_msg: PCanMsg; count: Integer);
var
  dlc, i: integer;
  hit_msg: PCanMsg;
  
begin;
if (not WidgetAktiv) or (count = 0) or (LockStatus) then
  exit;
hit_msg := nil;   
for i := 1 to count do
  begin;
  if can_msg^.ID = CanId then
    begin
    can_msg^.Flags := can_msg^.Flags or FlagsCanFilHit;
    if (can_msg^.Flags and FlagsCanRTR) = 0 then
      hit_msg := can_msg; 
    end;
  inc(can_msg);
  end;
if hit_msg <> nil then
  begin;
  dlc := hit_msg^.Flags and FlagsCanLength;
  if (dlc >= 1) and (dlc <= 8) then
    begin
    for i := 0 to dlc-1 do
      begin
      if hit_msg^.Data.Bytes[i] <> Data[i] then
        DataChange := True;
      Data[i] := hit_msg^.Data.Bytes[i];
      end; 
    end;
  end;   
end;


procedure TCanValueWin.RxCanUpdate; 
var
  i: integer;

begin
RxCanEnterCritical;
if (not WidgetAktiv) or (not DataChange) or (LockStatus) then
  begin
  RxCanLeaveCritical;
  exit;
  end;  
DataChange := False;
for i := 0 to high(Varis) do
  Varis[i].Wert := Data[i];
RxCanLeaveCritical;

try
  LEDDisplay.Value := BerechnungsObj.TermLoesen(Formula, @Varis);
except
  WidgetAktiv := false;
  MessageDlg('Im Berechnungs Term ist ein Fehler aufgetretten:'+#13+#10+
        BerechnungsObj.GetFehlerText, mtError, [mbOk], 0);
  end;
end;


procedure TCanValueWin.ConfigBtnClick(Sender: TObject);
var
  Form: TCanValueSetupWin;

begin
Lock;
inherited;
Form := TCanValueSetupWin.Create(self);

Form.NameEdit.Text := self.Caption;
Form.CANIDEdit.Number := CanId;
Form.BerechnungsTermEdit.Text := Formula;
Form.EinheitEdit.Text := UnitStr;
Form.ColorEdit.Selected := LEDDisplay.ColorLED;
Form.SizeEdit.ItemIndex := SizeType;
Form.PrecDigitEdit.Value := LEDDisplay.FractionDigits;

if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  CanId := Form.CANIDEdit.Number;
  Formula := Form.BerechnungsTermEdit.Text;
  UnitStr := Form.EinheitEdit.Text;
  LEDDisplay.ColorLED := Form.ColorEdit.Selected;
  EinheitLabel.Font.Color := LEDDisplay.ColorLED;
  SizeType := Form.SizeEdit.ItemIndex;
  LEDDisplay.FractionDigits := Form.PrecDigitEdit.Value;

  FormResize(self);
  WindowMenuItem.Caption :=  self.Caption;
  end;
Form.Free;
Unlock;
end;


procedure TCanValueWin.AktivBtnClick(Sender: TObject);

begin
inherited;
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanValueWin.DestroyBtnClick(Sender: TObject);

begin
Lock;   // <*> ?
inherited;
close;
end;


procedure TCanValueWin.Lock;

begin
RxCanEnterCritical;
LockStatus := True;
RxCanLeaveCritical;
end;


procedure TCanValueWin.Unlock;

begin
RxCanEnterCritical;
LockStatus := False;
RxCanLeaveCritical;
end;


end.
