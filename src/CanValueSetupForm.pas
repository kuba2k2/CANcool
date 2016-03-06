  {***************************************************************************
                    CanValueSetupForm.pas  -  description
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
unit CanValueSetupForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, ExtCtrls, IniFiles, zahlen32;

type
  TCanValueSetupWin = class(TForm)
    RahmenBevel: TBevel;
    NameEdit: TEdit;
    EinheitEdit: TEdit;
    BerechnungsTermEdit: TEdit;
    SkalaGroup: TGroupBox;
    OKBtn: TBitBtn;
    AbbrechenBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    LadenBtn: TBitBtn;
    SpeichernBtn: TBitBtn;
    Label10: TLabel;
    Label7: TLabel;
    ColorEdit: TColorBox;
    SizeEdit: TComboBox;
    PrecDigitEdit: TSpinEdit;
    CanIdEdit: TZahlen32Edit;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LadenBtnClick(Sender: TObject);
    procedure SpeichernBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Dateiname: string;
  public
    { Public-Deklarationen }
  end;

implementation

uses MainForm, IntegerTerm;

{$R *.dfm}

procedure TCanValueSetupWin.FormCreate(Sender: TObject);

begin
TMainWin(Owner.Owner).ButtonImages.GetBitmap(0, OKBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(1, AbbrechenBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(5, LadenBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(4, SpeichernBtn.Glyph);
end;


procedure TCanValueSetupWin.OKBtnClick(Sender: TObject);
var
  i, fs, fl: integer;
  BerechnungsObj: TIntTerm;
  Varis: VarArray;

begin
BerechnungsObj := TIntTerm.Create;
Dateiname := '';

SetLength(Varis, 8);
for i := 0 to high(Varis) do
begin
  Varis[i].Name := format('d%u',[i]);
  Varis[i].Wert := 0;
end;

try
  BerechnungsObj.TermLoesen(BerechnungsTermEdit.Text, @Varis);
except
  MessageDlg('Im Berechnungs Term ist ein Fehler aufgetretten:'+#13+#10+
        BerechnungsObj.GetFehlerText, mtError, [mbOk], 0);
  BerechnungsObj.GetFehler(@fs, @fl);
  BerechnungsTermEdit.SetFocus;
  BerechnungsTermEdit.SelStart := fs-1;
  BerechnungsTermEdit.SelLength := fl;
  BerechnungsObj.Free;
  exit;
  end;
BerechnungsObj.Free;
ModalResult := mrOK;
end;


procedure TCanValueSetupWin.LadenBtnClick(Sender: TObject);
var
  IniDatei: TIniFile;

begin
TMainWin(Owner.Owner).OpenDialog.Title := 'Instrumenten-Einstellungen laden';
TMainWin(Owner.Owner).OpenDialog.DefaultExt := 'cin';
TMainWin(Owner.Owner).OpenDialog.Filter := 'Specific (*.cin)|*.cin|Alle Dateien (*.*)|*.*';

if TMainWin(Owner.Owner).OpenDialog.Execute then
  begin
  IniDatei := TIniFile.Create(TMainWin(Owner.Owner).OpenDialog.FileName);
  try
    NameEdit.Text := IniDatei.ReadString('Common', 'Name', TMainWin(Owner.Owner).OpenDialog.FileName);
    Dateiname := NameEdit.Text;
    CANIDEdit.Number := IniDatei.ReadInteger('Common', 'CanID', 0);
    BerechnungsTermEdit.Text := IniDatei.ReadString('Common', 'Formula', 'd0');
    EinheitEdit.Text := IniDatei.ReadString('Specific', 'Unit', 'Unit');
    ColorEdit.Selected := TColor(IniDatei.ReadInteger('Specific', 'BaseColor', 0));
    SizeEdit.ItemIndex := IniDatei.ReadInteger('Specific', 'SizeType', 0);
    PrecDigitEdit.Value := IniDatei.ReadInteger('Specific', 'PrecDigits', 0);
  finally
    IniDatei.Free;
    end;
  end;
end;


procedure TCanValueSetupWin.SpeichernBtnClick(Sender: TObject);
var
  IniDatei: TIniFile;

begin
TMainWin(Owner.Owner).SaveDialog.Title := 'Instrumenten-Einstellungen speichern';
TMainWin(Owner.Owner).SaveDialog.DefaultExt := 'cin';
if Dateiname = '' then
  TMainWin(Owner.Owner).SaveDialog.FileName := NameEdit.Text + '.cin'
else
  TMainWin(Owner.Owner).SaveDialog.FileName := Dateiname;
TMainWin(Owner.Owner).SaveDialog.Filter := 'Specific (*.cin)|*.cin|Alle Dateien (*.*)|*.*';

if TMainWin(Owner.Owner).SaveDialog.Execute then
  begin
  Dateiname := TMainWin(Owner.Owner).SaveDialog.FileName;
  IniDatei := TIniFile.Create(TMainWin(Owner.Owner).SaveDialog.FileName);
  try
    IniDatei.WriteString('Common', 'Type', Owner.ClassName);
    IniDatei.WriteString('Common', 'Name', NameEdit.Text);
    IniDatei.WriteInteger('Common', 'CanID', CANIDEdit.Number);
    IniDatei.WriteString('Common', 'Formula', BerechnungsTermEdit.Text);
    IniDatei.WriteString('Specific', 'Unit', EinheitEdit.Text);
    IniDatei.WriteInteger('Specific', 'BaseColor', Integer(ColorEdit.Selected));
    IniDatei.WriteInteger('Specific', 'SizeType', SizeEdit.ItemIndex);
    IniDatei.WriteInteger('Specific', 'PrecDigits', PrecDigitEdit.Value);
  finally
    IniDatei.Free;
    end;
  end;
end;

end.
