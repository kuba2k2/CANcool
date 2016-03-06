object CanGaugeSetupWin: TCanGaugeSetupWin
  Left = 1205
  Top = 317
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Instrumenten Konfiguration'
  ClientHeight = 468
  ClientWidth = 367
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
    Width = 268
    Height = 468
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
    Left = 122
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
  object Label7: TLabel
    Left = 11
    Top = 123
    Width = 27
    Height = 13
    Caption = 'Farbe'
  end
  object Label10: TLabel
    Left = 11
    Top = 155
    Width = 29
    Height = 13
    Caption = 'Gr'#246#223'e'
  end
  object EinheitEdit: TEdit
    Left = 163
    Top = 40
    Width = 59
    Height = 21
    TabOrder = 1
  end
  object BerechnungsTermEdit: TEdit
    Left = 10
    Top = 80
    Width = 218
    Height = 21
    TabOrder = 2
  end
  object SkalaGroup: TGroupBox
    Left = 10
    Top = 187
    Width = 250
    Height = 273
    Caption = 'Skala'
    TabOrder = 3
    object Label3: TLabel
      Left = 10
      Top = 20
      Width = 46
      Height = 13
      Caption = 'Min. Wert'
    end
    object Label4: TLabel
      Left = 10
      Top = 45
      Width = 49
      Height = 13
      Caption = 'Max. Wert'
    end
    object Teilung2Label: TLabel
      Left = 10
      Top = 95
      Width = 57
      Height = 13
      Caption = 'Unterteilung'
    end
    object Teilung1Label: TLabel
      Left = 10
      Top = 70
      Width = 60
      Height = 13
      Caption = 'Hauptteilung'
    end
    object Label6: TLabel
      Left = 8
      Top = 128
      Width = 69
      Height = 13
      Caption = 'Min - Mid Wert'
    end
    object Label8: TLabel
      Left = 8
      Top = 152
      Width = 72
      Height = 13
      Caption = 'Mid - Max Wert'
    end
    object MinSkalaSpin: TSpinEdit
      Left = 65
      Top = 15
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object MaxSkalaSpin: TSpinEdit
      Left = 65
      Top = 40
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SkalaUnterteilungSpin: TSpinEdit
      Left = 75
      Top = 90
      Width = 46
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
    end
    object SkalaTeilungSpin: TSpinEdit
      Left = 75
      Top = 65
      Width = 46
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object MinRangeColorEdit: TColorBox
      Left = 96
      Top = 176
      Width = 145
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 4
    end
    object MidRangeColorEdit: TColorBox
      Left = 96
      Top = 208
      Width = 145
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 5
    end
    object MaxRangeColorEdit: TColorBox
      Left = 96
      Top = 240
      Width = 145
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 6
    end
    object MinRangeCheck: TCheckBox
      Left = 8
      Top = 184
      Width = 81
      Height = 17
      Caption = 'Min Range'
      TabOrder = 7
    end
    object MidRangeCheck: TCheckBox
      Left = 8
      Top = 216
      Width = 81
      Height = 17
      Caption = 'Mid Range'
      TabOrder = 8
    end
    object MaxRangeCheck: TCheckBox
      Left = 8
      Top = 248
      Width = 81
      Height = 17
      Caption = 'Max Range'
      TabOrder = 9
    end
    object IndMaxSpin: TSpinEdit
      Left = 96
      Top = 144
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 10
      Value = 0
    end
    object IndMinSpin: TSpinEdit
      Left = 96
      Top = 120
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 11
      Value = 0
    end
  end
  object OKBtn: TBitBtn
    Left = 281
    Top = 5
    Width = 86
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = OKBtnClick
    NumGlyphs = 2
  end
  object AbbrechenBtn: TBitBtn
    Left = 281
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
    Width = 170
    Height = 21
    TabOrder = 0
  end
  object LadenBtn: TBitBtn
    Left = 281
    Top = 85
    Width = 86
    Height = 25
    Caption = 'Laden'
    TabOrder = 6
    OnClick = LadenBtnClick
    NumGlyphs = 2
  end
  object SpeichernBtn: TBitBtn
    Left = 281
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
