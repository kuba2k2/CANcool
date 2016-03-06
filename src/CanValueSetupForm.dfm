object CanValueSetupWin: TCanValueSetupWin
  Left = 1131
  Top = 686
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Instrumenten Konfiguration'
  ClientHeight = 244
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RahmenBevel: TBevel
    Left = 0
    Top = 0
    Width = 236
    Height = 244
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 15
    Top = 45
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label5: TLabel
    Left = 114
    Top = 45
    Width = 32
    Height = 13
    Caption = 'Einheit'
  end
  object Label2: TLabel
    Left = 10
    Top = 65
    Width = 90
    Height = 13
    Caption = 'Berechnungs-Term'
  end
  object Label9: TLabel
    Left = 15
    Top = 15
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label10: TLabel
    Left = 11
    Top = 155
    Width = 29
    Height = 13
    Caption = 'Gr'#246#223'e'
  end
  object Label7: TLabel
    Left = 11
    Top = 123
    Width = 27
    Height = 13
    Caption = 'Farbe'
  end
  object EinheitEdit: TEdit
    Left = 154
    Top = 40
    Width = 76
    Height = 21
    TabOrder = 1
  end
  object BerechnungsTermEdit: TEdit
    Left = 10
    Top = 80
    Width = 196
    Height = 21
    TabOrder = 2
  end
  object SkalaGroup: TGroupBox
    Left = 10
    Top = 179
    Width = 196
    Height = 49
    Caption = 'Layout'
    TabOrder = 3
    object Label3: TLabel
      Left = 10
      Top = 20
      Width = 90
      Height = 13
      Caption = 'Nachkommastellen'
    end
    object PrecDigitEdit: TSpinEdit
      Left = 112
      Top = 16
      Width = 41
      Height = 22
      MaxValue = 3
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
  end
  object OKBtn: TBitBtn
    Left = 257
    Top = 5
    Width = 86
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = OKBtnClick
    NumGlyphs = 2
  end
  object AbbrechenBtn: TBitBtn
    Left = 257
    Top = 40
    Width = 85
    Height = 25
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 5
    NumGlyphs = 2
  end
  object NameEdit: TEdit
    Left = 50
    Top = 10
    Width = 178
    Height = 21
    TabOrder = 0
  end
  object LadenBtn: TBitBtn
    Left = 257
    Top = 85
    Width = 86
    Height = 25
    Caption = 'Laden'
    TabOrder = 6
    OnClick = LadenBtnClick
    NumGlyphs = 2
  end
  object SpeichernBtn: TBitBtn
    Left = 257
    Top = 120
    Width = 86
    Height = 25
    Caption = 'Speichern'
    TabOrder = 7
    OnClick = SpeichernBtnClick
    NumGlyphs = 2
  end
  object ColorEdit: TColorBox
    Left = 51
    Top = 115
    Width = 145
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 8
  end
  object SizeEdit: TComboBox
    Left = 51
    Top = 147
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
    Items.Strings = (
      'klein'
      'mittel'
      'gro'#223)
  end
  object CanIdEdit: TZahlen32Edit
    Left = 35
    Top = 39
    Width = 73
    Height = 21
    Number = 0
    ZahlenFormat = HexFormat
    IdShowing = False
    BinMode = Z32AutoMode
    HexMode = Z32AutoMode
    AutoFormat = False
    TabOrder = 10
  end
end
