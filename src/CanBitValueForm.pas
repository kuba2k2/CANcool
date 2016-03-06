{***************************************************************************
                      CanBitValueForm.pas  -  description
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
unit CanBitValueForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CanRxPrototyp, StdCtrls, Buttons, Imglist, StrUtils, MainForm,
  IntegerTerm, ExtCtrls, Menus, Contnrs, Kr_Led, Util, TinyCanDrv;

type
  TBitConf = record
    Name: String[40];
    Color: TColor;
    BytePos: Byte;
    BitPos: Byte;
    end;

  PBitConf = ^TBitConf;

  TCanBitValueWin = class(TCanRxPrototypForm)
    BitIndikMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure AktivBtnClick(Sender: TObject);
    procedure DestroyBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    LockStatus: boolean;
    DataChange: Boolean;
    Data: array[0..7] of Byte;
    WidgetAktiv: boolean;
    CanId: longword;  
    BitConfListe: TList;
    LEDS: TObjectList;
    procedure Lock;
    procedure Unlock;   
    procedure CreateLEDS;
  public
    { Public-Deklarationen }
    procedure BitConfListeClear(liste: TList);
    procedure BitConfListeAdd(liste: TList; Name: String;
      LedColor: TColor; BytePos, BitPos: Byte);
    procedure RxCanMessages(can_msg: PCanMsg; count: Integer); override;
    procedure RxCanUpdate; override;               
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

var
  CanBitValueWin: TCanBitValueWin;

implementation

uses CanBitValueSetupForm;

{$R *.dfm}


procedure TCanBitValueWin.FormCreate(Sender: TObject);

begin
inherited;
BitConfListe := TList.Create;
LEDS := TObjectList.Create;

WidgetAktiv := True;
LockStatus := False;
CanId := 0;
end;


procedure TCanBitValueWin.FormDestroy(Sender: TObject);

begin
inherited;
LEDS.Free;
BitConfListeClear(BitConfListe);
BitConfListe.Free;
end;


procedure TCanBitValueWin.BitConfListeClear(liste: TList);
var i: Integer;

begin;
if liste.Count = 0 then
  exit;
for i := 0 to liste.Count-1 do
  dispose(liste.Items[i]);
liste.Clear;
end;


procedure TCanBitValueWin.BitConfListeAdd(liste: TList; Name: String;
    LedColor: TColor; BytePos, BitPos: Byte);
var item: PBitConf;
    
begin
new(item);
item.Name := Name;       // Bezeichnung
item.Color := LedColor;  // Farbe
item.BytePos := BytePos; // Byte
item.BitPos := BitPos;   // Bit
liste.Add(item);
end;


procedure TCanBitValueWin.FormResize(Sender: TObject);
var
  i, h, top: integer;

begin
inherited;
if LEDS.Count = 0 then
  exit;
h := KrLed(LEDS[0]).Height;
top := 0;  
for i := 0 to LEDS.Count-1 do
  begin
  KrLed(LEDS[i]).Top := top;
  top := top + h;
  end;
self.ClientWidth := KrLed(LEDS[0]).Width;   
self.ClientHeight := top;
end;  


procedure TCanBitValueWin.LoadConfig(ConfigList: TStrings);
const
  Delims = ['=', ';'];
var
  i, Pos, Idx: integer;
  Str, Item, Name: String;
  LedColor: TColor;
  BytePos, BitPos: Byte;

begin
Lock;
self.Caption := ReadListString(ConfigList, 'Name', self.Caption);
CanId := ReadListInteger(ConfigList, 'CanId', CanId);
BitConfListeClear(BitConfListe);
for i := 0 to ConfigList.Count-1 do
  begin
  Str := ConfigList.Strings[i];
  if AnsiStartsText('LED', Str) then
    begin
    Pos := 1;
    Idx := 0;
    LedColor := clRed;
    BytePos := 0;
    BitPos := 0;
    while Pos <= Length(Str) do
      begin
      Item := ExtractSubstr(Str, Pos, Delims);
      case Idx of
        1: Name := Item;
        2: LedColor := TColor(StrToInt(Item));  //StringToColor(Item); <*>
        3: BytePos := StrToInt(Item);
        4: BitPos := StrToInt(Item);
        end;
      Inc(Idx);
      end;
    BitConfListeAdd(BitConfListe, Name, LedColor, BytePos, BitPos);
    end;
  end;
CreateLEDS;
WindowMenuItem.Caption :=  self.Caption;
Unlock;
end;


procedure TCanBitValueWin.SaveConfig(ConfigList: TStrings);
var
  i, LedColor: integer;
  BytePos, BitPos : Byte;
  Name: String;

begin
ConfigList.Append(format('Name=%s', [self.Caption]));
ConfigList.Append(format('CanId=%u', [CanId]));
if BitConfListe.Count > 0 then
  begin;
  for i := 0 to BitConfListe.Count-1 do
    begin;
    Name := PBitConf(BitConfListe[i]).Name;
    //LedColor := ColorToString(PBitConf(BitConfListe[i]).Color); <*>
    LedColor := Integer(PBitConf(BitConfListe[i]).Color);
    BytePos := PBitConf(BitConfListe[i]).BytePos;
    BitPos := PBitConf(BitConfListe[i]).BitPos;
    ConfigList.Append(format('LED%u=%s;%d;%u;%u', [i, Name, LedColor, BytePos, BitPos]));
    end;
  end;  
end;


procedure TCanBitValueWin.CreateLEDS;
var i: Integer;
    led: KrLed;

begin;
LEDS.Clear;
if BitConfListe.Count = 0 then
  exit;
for i := 0 to BitConfListe.Count-1 do
  begin
  led := KrLed.Create(self);
  led.Parent := self;
  led.Left := 0;
  led.Height := 25;
  led.LedCircle := 16;
  led.Width := 200;
  led.LedOffColor := clSilver;
  led.Font.Style := [fsBold];
  led.LedOnColor := PBitConf(BitConfListe[i]).Color;
  led.Caption := PBitConf(BitConfListe[i]).Name;
  led.LedState := stOff;
  LEDS.Add(led);
  end;
FormResize(self);
end;


procedure TCanBitValueWin.RxCanMessages(can_msg: PCanMsg; count: Integer);
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


procedure TCanBitValueWin.RxCanUpdate; 
var
  i: integer;
  maske: Byte;
  tmp_data: array[0..7] of Byte;

begin;
RxCanEnterCritical;
if (not WidgetAktiv) or (not DataChange) or (LockStatus) then
  begin
  RxCanLeaveCritical;
  exit;
  end;  
DataChange := False;
Move(Data, tmp_data, 8);
RxCanLeaveCritical;  

if BitConfListe.Count = 0 then
  exit;
for i := 0 to BitConfListe.Count-1 do
  begin
  if i >= LEDS.Count then
    exit;
  maske := 1 shl PBitConf(BitConfListe[i]).BitPos;  
  if (tmp_data[PBitConf(BitConfListe[i]).BytePos] and maske) > 0 then
    KrLed(LEDS.Items[i]).LedState := stOn
  else
    KrLed(LEDS.Items[i]).LedState := stOff;
  end;
end;


procedure TCanBitValueWin.ConfigBtnClick(Sender: TObject);
var
  Form: TCanBitValueSetupWin;
  
begin
Lock;
inherited;
Form := TCanBitValueSetupWin.Create(self);

Form.NameEdit.Text := self.Caption;
Form.CANIDEdit.Number := CanId;
Form.SetBitConfListe(BitConfListe);
if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  CanId := Form.CANIDEdit.Number;
  Form.GetBitConfListe(BitConfListe);
  CreateLEDS;
  WindowMenuItem.Caption :=  self.Caption;
  end;
Form.Free;
Unlock;
end;


procedure TCanBitValueWin.AktivBtnClick(Sender: TObject);

begin
inherited;
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanBitValueWin.DestroyBtnClick(Sender: TObject);

begin
Lock;   // <*> ?
inherited;
close;
end;


procedure TCanBitValueWin.Lock;

begin
RxCanEnterCritical;
LockStatus := True;
RxCanLeaveCritical;
end;


procedure TCanBitValueWin.Unlock;

begin
RxCanEnterCritical;
LockStatus := False;
RxCanLeaveCritical;
end;

end.
