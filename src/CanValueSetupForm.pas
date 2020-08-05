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
  Dialogs, StdCtrls, Buttons, Spin, ExtCtrls, IniFiles, zahlen32, zahlen;

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
    GroupBox1: TGroupBox;
    DLCEdit: TZahlenEdit;
    Mask7Edit: TZahlenEdit;
    Mask8Edit: TZahlenEdit;
    Mask6Edit: TZahlenEdit;
    Mask5Edit: TZahlenEdit;
    Mask4Edit: TZahlenEdit;
    Mask3Edit: TZahlenEdit;
    Mask2Edit: TZahlenEdit;
    Mask1Edit: TZahlenEdit;
    Label4: TLabel;
    Label6: TLabel;
    Data8Edit: TZahlenEdit;
    Data7Edit: TZahlenEdit;
    Data6Edit: TZahlenEdit;
    Data5Edit: TZahlenEdit;
    Data4Edit: TZahlenEdit;
    Data3Edit: TZahlenEdit;
    Data2Edit: TZahlenEdit;
    Data1Edit: TZahlenEdit;
    Label11: TLabel;
    MuxEnabledCheck: TCheckBox;
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
    DLCEdit.Number := IniDatei.ReadInteger('Common', 'MuxDlc', 8);
    Mask1Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask0', 0);
    Mask2Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask1', 0);
    Mask3Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask2', 0);
    Mask4Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask3', 0);
    Mask5Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask4', 0);
    Mask6Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask5', 0);
    Mask7Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask6', 0);
    Mask8Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask7', 0);
    Data1Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData0', 0);
    Data2Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData1', 0);
    Data3Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData2', 0);
    Data4Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData3', 0);
    Data5Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData4', 0);
    Data6Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData5', 0);
    Data7Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData6', 0);
    Data8Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData7', 0);
    if IniDatei.ReadInteger('Common', 'MuxEnable', 0) > 0 then 
      MuxEnabledCheck.Checked := True
    else
      MuxEnabledCheck.Checked := False;
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
    IniDatei.WriteInteger('Common', 'MuxDlc', DLCEdit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask0', Mask1Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask1', Mask2Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask2', Mask3Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask3', Mask4Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask4', Mask5Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask5', Mask6Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask6', Mask7Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask7', Mask8Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData0', Data1Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData1', Data2Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData2', Data3Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData3', Data4Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData4', Data5Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData5', Data6Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData6', Data7Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData7', Data8Edit.Number);
    if MuxEnabledCheck.Checked then
      IniDatei.WriteInteger('Common', 'MuxEnable', 1)
    else
      IniDatei.WriteInteger('Common', 'MuxEnable', 0);
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
