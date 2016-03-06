{***************************************************************************
                       CanGaugeForm.pas  -  description
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
unit CanGaugeForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CanRxPrototyp, MainForm,
  IntegerTerm, CanGaugeSetupForm, Menus, A3nalogGauge, Util, TinyCanDrv;

type
  TCanGaugeWin = class(TCanRxPrototypForm)
    AnalogInstMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    Gauge: TA3nalogGauge;
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
    FSizeType: Integer;
    CanId: longword;
    Formula: string;
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

implementation

{$R *.dfm}

procedure TCanGaugeWin.FormCreate(Sender: TObject);
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
//slef.Selected;
Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMin, ShowIndicatorMid, ShowIndicatorMax];
WidgetAktiv := True;
LockStatus := False;
SizeType := 1;
Gauge.ScaleMin := 0;
Gauge.ScaleMax := 100;
Gauge.NumberMainTicks := 10;
Gauge.NumberSubTicks := 5;
Gauge.IndMinimum := 30;
Gauge.IndMaximum := 70;
Gauge.Caption := 'x';
CanId := 0;
Formula := '(d0 << 8) + d1';
FormResize(self);
end;


procedure TCanGaugeWin.FormResize(Sender: TObject);
begin
inherited;
self.ClientWidth := Gauge.Width;
self.ClientHeight := Gauge.Top + Gauge.Height;
end;

procedure TCanGaugeWin.SetFSizeType(value: Integer);
begin
if value <> FSizeType then
  begin
  FSizeType := value;
  case value of
    0 : begin;
        Gauge.Width := 150;
        Gauge.Height := 150;
        Gauge.ArrowWidth := 1;
        Gauge.TicksWidth := 1;
        Gauge.Font.Size := 8;
        end;
    1 : begin;
        Gauge.Width := 250;
        Gauge.Height := 250;
        Gauge.ArrowWidth := 2;
        Gauge.TicksWidth := 2;
        Gauge.Font.Size := 8;
        end;
    2 : begin;
        Gauge.Width := 400;
        Gauge.Height := 400;
        Gauge.ArrowWidth := 4;
        Gauge.TicksWidth := 4;
        Gauge.Font.Size := 14;
        end;
    else
      Gauge.Width := 250;
      Gauge.Height := 250;
      Gauge.ArrowWidth := 2;
      Gauge.TicksWidth := 2;
      Gauge.Font.Size := 8;
    end;
  end;
end;


procedure TCanGaugeWin.RxCanMessages(can_msg: PCanMsg; count: Integer);
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


procedure TCanGaugeWin.RxCanUpdate; 
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
  Gauge.Position := BerechnungsObj.TermLoesen(Formula, @Varis);
except
  WidgetAktiv := false;
  MessageDlg('Im Berechnungs Term ist ein Fehler aufgetretten:'+#13+#10+
        BerechnungsObj.GetFehlerText, mtError, [mbOk], 0);
  end;
end;


procedure TCanGaugeWin.LoadConfig(ConfigList: TStrings);

begin
Lock;
self.Caption := ReadListString(ConfigList, 'Name', self.Caption);
CanId := ReadListInteger(ConfigList, 'CanId', CanId);
Gauge.Caption := ReadListString(ConfigList, 'Unit', Gauge.Caption);
Formula := ReadListString(ConfigList, 'Formula', Formula);
Gauge.FaceColor := TColor(ReadListInteger(ConfigList, 'BaseColor', Integer(Gauge.FaceColor)));
SizeType := ReadListInteger(ConfigList, 'SizeType', SizeType);
Gauge.ScaleMax := ReadListInteger(ConfigList, 'ScaleMax', Gauge.ScaleMax);
Gauge.ScaleMin := ReadListInteger(ConfigList, 'ScaleMin', Gauge.ScaleMin);

Gauge.NumberMainTicks := ReadListInteger(ConfigList, 'NumberMainTicks', Gauge.NumberMainTicks);
Gauge.NumberSubTicks := ReadListInteger(ConfigList, 'NumberSubTicks', Gauge.NumberSubTicks);
Gauge.IndMinimum := ReadListInteger(ConfigList, 'IndMin', Gauge.IndMinimum);
Gauge.IndMaximum := ReadListInteger(ConfigList, 'IndMax', Gauge.IndMaximum);
if ReadListInteger(ConfigList, 'EnableMinRange', 0) > 0 then
  Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMin]
else
  Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMin];
if ReadListInteger(ConfigList, 'EnableMidRange', 0) > 0 then
  Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMid]
else
  Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMid];
if ReadListInteger(ConfigList, 'EnableMaxRange', 0) > 0 then
  Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMax]
else
  Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMax];
Gauge.MinColor := TColor(ReadListInteger(ConfigList, 'MinRangeColor', Integer(Gauge.MinColor)));
Gauge.MidColor := TColor(ReadListInteger(ConfigList, 'MidRangeColor', Integer(Gauge.MinColor)));
Gauge.MaxColor := TColor(ReadListInteger(ConfigList, 'MaxRangeColor', Integer(Gauge.MinColor)));  
FormResize(self);
WindowMenuItem.Caption :=  self.Caption;
Unlock;
end;


procedure TCanGaugeWin.SaveConfig(ConfigList: TStrings);

begin
ConfigList.Append(format('Name=%s', [self.Caption]));
ConfigList.Append(format('CanId=%u', [CanId]));
ConfigList.Append(format('Unit=%s', [Gauge.Caption]));
ConfigList.Append(format('Formula=%s', [Formula]));
ConfigList.Append(format('BaseColor=%d', [Integer(Gauge.FaceColor)]));
ConfigList.Append(format('SizeType=%u', [SizeType]));
ConfigList.Append(format('ScaleMin=%d', [Gauge.ScaleMin]));
ConfigList.Append(format('ScaleMax=%d', [Gauge.ScaleMax]));
ConfigList.Append(format('NumberMainTicks=%u', [Gauge.NumberMainTicks]));
ConfigList.Append(format('NumberSubTicks=%u', [Gauge.NumberSubTicks]));
ConfigList.Append(format('IndMin=%u', [Gauge.IndMinimum]));
ConfigList.Append(format('IndMax=%u', [Gauge.IndMaximum]));
if ShowIndicatorMin in Gauge.FaceOptions then
  ConfigList.Append('EnableMinRange=1')
else
  ConfigList.Append('EnableMinRange=0');
if ShowIndicatorMid in Gauge.FaceOptions then
  ConfigList.Append('EnableMidRange=1')
else
  ConfigList.Append('EnableMidRange=0');
if ShowIndicatorMax in Gauge.FaceOptions then
  ConfigList.Append('EnableMaxRange=1')
else
  ConfigList.Append('EnableMaxRange=0');
ConfigList.Append(format('MinRangeColor=%d', [Integer(Gauge.MinColor)]));
ConfigList.Append(format('MidRangeColor=%d', [Integer(Gauge.MidColor)]));
ConfigList.Append(format('MaxRangeColor=%d', [Integer(Gauge.MaxColor)]));
end;


procedure TCanGaugeWin.ConfigBtnClick(Sender: TObject);
var
  Form: TCanGaugeSetupWin;

begin
Lock;
inherited;
Form := TCanGaugeSetupWin.Create(self);

Form.NameEdit.Text := self.Caption;
Form.EinheitEdit.Text := Gauge.Caption;
Form.CANIDEdit.Number := CanId;
Form.BerechnungsTermEdit.Text := Formula;
Form.ColorEdit.Selected := Gauge.FaceColor;
Form.SizeEdit.ItemIndex := SizeType;
Form.MinSkalaSpin.Value := Gauge.ScaleMin;
Form.MaxSkalaSpin.Value := Gauge.ScaleMax;
Form.SkalaTeilungSpin.Value := Gauge.NumberMainTicks;
Form.SkalaUnterteilungSpin.Value := Gauge.NumberSubTicks;
Form.IndMinSpin.Value := Gauge.IndMinimum;
Form.IndMaxSpin.Value := Gauge.IndMaximum;
if ShowIndicatorMin in Gauge.FaceOptions then
  Form.MinRangeCheck.Checked := True
else
  Form.MinRangeCheck.Checked := False;
if ShowIndicatorMid in Gauge.FaceOptions then
  Form.MidRangeCheck.Checked := True
else
  Form.MidRangeCheck.Checked := False;
if ShowIndicatorMax in Gauge.FaceOptions then
  Form.MaxRangeCheck.Checked := True
else
  Form.MaxRangeCheck.Checked := False;
Form.MinRangeColorEdit.Selected := Gauge.MinColor; 
Form.MidRangeColorEdit.Selected := Gauge.MidColor;
Form.MaxRangeColorEdit.Selected := Gauge.MaxColor;

if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  CanId := Form.CANIDEdit.Number;
  Gauge.Caption := Form.EinheitEdit.Text;
  Formula := Form.BerechnungsTermEdit.Text;
  Gauge.FaceColor := Form.ColorEdit.Selected;
  SizeType := Form.SizeEdit.ItemIndex;
  Gauge.ScaleMin := Form.MinSkalaSpin.Value;
  Gauge.ScaleMax := Form.MaxSkalaSpin.Value;
  Gauge.NumberMainTicks := Form.SkalaTeilungSpin.Value;
  Gauge.NumberSubTicks := Form.SkalaUnterteilungSpin.Value;
  Gauge.IndMinimum := Form.IndMinSpin.Value;
  Gauge.IndMaximum := Form.IndMaxSpin.Value;
  if Form.MinRangeCheck.Checked then
    Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMin]
  else
    Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMin];
  if Form.MidRangeCheck.Checked then
    Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMid]
  else
    Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMid];
  if Form.MaxRangeCheck.Checked then
    Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMax]
  else
    Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMax];
  Gauge.MinColor := Form.MinRangeColorEdit.Selected;
  Gauge.MidColor := Form.MidRangeColorEdit.Selected;
  Gauge.MaxColor := Form.MaxRangeColorEdit.Selected;  
  FormResize(self);
  WindowMenuItem.Caption :=  self.Caption;
  end;
Form.Free;
Unlock;
end;


procedure TCanGaugeWin.AktivBtnClick(Sender: TObject);

begin
inherited;
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanGaugeWin.DestroyBtnClick(Sender: TObject);

begin
Lock;   // <*> ?
inherited;
close;
end;


procedure TCanGaugeWin.Lock;

begin
RxCanEnterCritical;
LockStatus := True;
RxCanLeaveCritical;
end;


procedure TCanGaugeWin.Unlock;

begin
RxCanEnterCritical;
LockStatus := False;
RxCanLeaveCritical;
end;

end.
