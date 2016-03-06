object CanTxWin: TCanTxWin
  Left = 864
  Top = 807
  Width = 849
  Height = 314
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Senden'
  Color = clBtnFace
  Constraints.MinHeight = 160
  Constraints.MinWidth = 570
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TxView: TStringGrid
    Left = 0
    Top = 0
    Width = 841
    Height = 183
    Align = alClient
    ColCount = 9
    DefaultColWidth = 35
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = TxViewClick
    OnDrawCell = TxViewDrawCell
    OnMouseDown = TxViewMouseDown
    OnMouseUp = TxViewMouseUp
  end
  object KopfPanel: TPanel
    Left = 0
    Top = 183
    Width = 841
    Height = 97
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 60
      Top = 8
      Width = 11
      Height = 13
      Alignment = taRightJustify
      Caption = 'ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 160
      Top = 8
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Daten'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 122
      Top = 8
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = 'DLC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 488
      Top = 16
      Width = 44
      Height = 13
      Caption = 'TX Mode'
    end
    object Label5: TLabel
      Left = 245
      Top = 64
      Width = 54
      Height = 13
      Caption = 'Bemerkung'
    end
    object Label6: TLabel
      Left = 485
      Top = 48
      Width = 47
      Height = 13
      Caption = 'Trigger ID'
    end
    object Label7: TLabel
      Left = 480
      Top = 72
      Width = 52
      Height = 13
      Caption = 'Period (ms)'
    end
    object MsgAddBtn: TBitBtn
      Left = 648
      Top = 16
      Width = 97
      Height = 26
      Caption = 'Hinzuf'#252'gen'
      TabOrder = 15
      OnClick = MsgAddBtnClick
      NumGlyphs = 2
    end
    object MsgDelBtn: TBitBtn
      Left = 752
      Top = 56
      Width = 81
      Height = 26
      Caption = 'Entfernen'
      TabOrder = 16
      OnClick = MsgDelBtnClick
      NumGlyphs = 2
    end
    object Data1Edit: TZahlenEdit
      Tag = 2
      Left = 160
      Top = 24
      Width = 37
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object Data2Edit: TZahlenEdit
      Tag = 3
      Left = 197
      Top = 24
      Width = 37
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object Data3Edit: TZahlenEdit
      Tag = 4
      Left = 235
      Top = 24
      Width = 37
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object Data4Edit: TZahlenEdit
      Tag = 5
      Left = 273
      Top = 24
      Width = 37
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object Data8Edit: TZahlenEdit
      Tag = 9
      Left = 424
      Top = 24
      Width = 37
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
    object Data5Edit: TZahlenEdit
      Tag = 6
      Left = 310
      Top = 24
      Width = 37
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object Data6Edit: TZahlenEdit
      Tag = 7
      Left = 348
      Top = 24
      Width = 37
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object Data7Edit: TZahlenEdit
      Tag = 8
      Left = 386
      Top = 24
      Width = 37
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object DLCEdit: TZahlenEdit
      Tag = 1
      Left = 121
      Top = 24
      Width = 24
      Height = 21
      Number = 0
      ZahlenFormat = DezFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CanFormatGroupBox: TGroupBox
      Left = 7
      Top = 49
      Width = 221
      Height = 40
      Caption = 'CAN Format '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      object RTRCheck: TCheckBox
        Tag = 13
        Left = 8
        Top = 16
        Width = 91
        Height = 18
        Caption = 'RTR Packet'
        TabOrder = 0
      end
      object EFFCheck: TCheckBox
        Tag = 14
        Left = 104
        Top = 16
        Width = 113
        Height = 18
        Caption = 'Ext. Frame Format'
        TabOrder = 1
      end
    end
    object IDEdit: TZahlen32Edit
      Left = 8
      Top = 24
      Width = 97
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 0
    end
    object CommentEdit: TEdit
      Tag = 10
      Left = 304
      Top = 60
      Width = 161
      Height = 21
      TabOrder = 11
    end
    object TxModeCombo: TComboBox
      Tag = 15
      Left = 536
      Top = 12
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 12
      Text = 'OFF'
      Items.Strings = (
        'OFF'
        'Periodic'
        'RTR'
        'Trigger')
    end
    object TriggerIdEdit: TZahlen32Edit
      Tag = 11
      Left = 536
      Top = 44
      Width = 97
      Height = 21
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 13
    end
    object IntervallEdit: TZahlen32Edit
      Tag = 12
      Left = 536
      Top = 68
      Width = 57
      Height = 21
      Number = 0
      ZahlenFormat = DezFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 14
    end
    object MsgTxBtn: TBitBtn
      Left = 752
      Top = 16
      Width = 81
      Height = 25
      Caption = 'Senden'
      TabOrder = 17
      OnClick = MsgTxBtnClick
      NumGlyphs = 2
    end
    object MsgCopyBtn: TBitBtn
      Left = 648
      Top = 56
      Width = 97
      Height = 26
      Caption = 'Kopieren'
      TabOrder = 18
      OnClick = MsgCopyBtnClick
      NumGlyphs = 2
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'csv'
    Filter = 'CSV Format (*.csv)|*.csv|Alle Dateien (*.*)|*.*'
    Title = 'Senden Liste importieren'
    Left = 504
    Top = 136
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV Format (*.csv)|*.csv|Alle Dateien (*.*)|*.*'
    Title = 'Senden Liste exportieren'
    Left = 544
    Top = 136
  end
end
