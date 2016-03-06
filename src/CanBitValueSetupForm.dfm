object CanBitValueSetupWin: TCanBitValueSetupWin
  Left = 1174
  Top = 569
  Width = 482
  Height = 356
  AutoSize = True
  BorderWidth = 3
  Caption = 'Bit Indikator Konfiguration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object RahmenBevel: TBevel
    Left = 0
    Top = 0
    Width = 364
    Height = 316
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 35
    Top = 45
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label9: TLabel
    Left = 15
    Top = 15
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Bevel1: TBevel
    Left = 372
    Top = 160
    Width = 96
    Height = 6
    Shape = bsTopLine
  end
  object Label3: TLabel
    Left = 10
    Top = 70
    Width = 26
    Height = 13
    Caption = 'LEDs'
  end
  object OKBtn: TBitBtn
    Left = 377
    Top = 5
    Width = 86
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKBtnClick
    NumGlyphs = 2
  end
  object AbbrechenBtn: TBitBtn
    Left = 377
    Top = 40
    Width = 85
    Height = 25
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
    NumGlyphs = 2
  end
  object NameEdit: TEdit
    Left = 50
    Top = 10
    Width = 156
    Height = 21
    TabOrder = 2
  end
  object LadenBtn: TBitBtn
    Left = 377
    Top = 85
    Width = 86
    Height = 25
    Caption = 'Laden'
    TabOrder = 3
    OnClick = LadenBtnClick
    NumGlyphs = 2
  end
  object SpeichernBtn: TBitBtn
    Left = 377
    Top = 120
    Width = 86
    Height = 25
    Caption = 'Speichern'
    TabOrder = 4
    OnClick = SpeichernBtnClick
    NumGlyphs = 2
  end
  object BitNameGrid: TStringGrid
    Left = 10
    Top = 83
    Width = 346
    Height = 225
    ColCount = 4
    DefaultColWidth = 48
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 5
    OnDrawCell = BitNameGridDrawCell
    OnGetEditText = BitNameGridGetEditText
    OnSelectCell = BitNameGridSelectCell
    OnSetEditText = BitNameGridSetEditText
    ColWidths = (
      48
      48
      48
      48)
  end
  object HinzufuegenBtn: TBitBtn
    Left = 377
    Top = 175
    Width = 86
    Height = 25
    Caption = 'Hinzuf'#252'gen'
    TabOrder = 6
    OnClick = HinzufuegenBtnClick
    NumGlyphs = 2
  end
  object EntfernenBtn: TBitBtn
    Left = 377
    Top = 210
    Width = 86
    Height = 25
    Caption = 'Entfernen'
    TabOrder = 7
    OnClick = EntfernenBtnClick
    NumGlyphs = 2
  end
  object BitComboBox: TComboBox
    Left = 315
    Top = 11
    Width = 40
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 8
    Text = '0'
    OnExit = ComboBoxExit
    Items.Strings = (
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7')
  end
  object ColorBox: TColorBox
    Left = 219
    Top = 11
    Width = 89
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 9
    OnExit = ColorBoxExit
  end
  object CanIdEdit: TZahlen32Edit
    Left = 51
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
