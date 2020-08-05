object CanFdTxWin: TCanFdTxWin
  Left = 279
  Top = 1265
  Width = 925
  Height = 727
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Senden'
  Color = clBtnFace
  Constraints.MinHeight = 160
  Constraints.MinWidth = 570
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
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
  PixelsPerInch = 110
  TextHeight = 16
  object TxView: TStringGrid
    Left = 0
    Top = 0
    Width = 917
    Height = 352
    Align = alClient
    ColCount = 9
    DefaultColWidth = 35
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
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
    Top = 352
    Width = 917
    Height = 321
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 74
      Top = 10
      Width = 13
      Height = 16
      Alignment = taRightJustify
      Caption = 'ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 301
      Top = 10
      Width = 36
      Height = 16
      Alignment = taRightJustify
      Caption = 'Daten'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 254
      Top = 10
      Width = 26
      Height = 16
      Alignment = taRightJustify
      Caption = 'DLC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 25
      Top = 164
      Width = 55
      Height = 16
      Caption = 'TX Mode'
    end
    object Label5: TLabel
      Left = 14
      Top = 279
      Width = 69
      Height = 16
      Caption = 'Bemerkung'
    end
    object Label6: TLabel
      Left = 21
      Top = 203
      Width = 60
      Height = 16
      Caption = 'Trigger ID'
    end
    object Label7: TLabel
      Left = 15
      Top = 233
      Width = 69
      Height = 16
      Caption = 'Period (ms)'
    end
    object Label9: TLabel
      Left = 312
      Top = 56
      Width = 22
      Height = 16
      Caption = '[08]'
      Layout = tlCenter
    end
    object Label10: TLabel
      Left = 312
      Top = 80
      Width = 22
      Height = 16
      Caption = '[16]'
      Layout = tlCenter
    end
    object Label11: TLabel
      Left = 312
      Top = 104
      Width = 22
      Height = 16
      Caption = '[24]'
      Layout = tlCenter
    end
    object Label12: TLabel
      Left = 312
      Top = 128
      Width = 22
      Height = 16
      Caption = '[32]'
      Layout = tlCenter
    end
    object Label13: TLabel
      Left = 312
      Top = 152
      Width = 22
      Height = 16
      Caption = '[40]'
      Layout = tlCenter
    end
    object Label14: TLabel
      Left = 312
      Top = 176
      Width = 22
      Height = 16
      Caption = '[48]'
      Layout = tlCenter
    end
    object Label15: TLabel
      Left = 312
      Top = 200
      Width = 22
      Height = 16
      Caption = '[56]'
      Layout = tlCenter
    end
    object Label8: TLabel
      Left = 312
      Top = 32
      Width = 22
      Height = 16
      Caption = '[00]'
      Layout = tlCenter
    end
    object Label16: TLabel
      Left = 341
      Top = 10
      Width = 45
      Height = 16
      Alignment = taCenter
      Caption = '+0'
    end
    object Label17: TLabel
      Left = 384
      Top = 10
      Width = 41
      Height = 16
      Alignment = taCenter
      Caption = '+1'
    end
    object Label18: TLabel
      Left = 432
      Top = 10
      Width = 14
      Height = 16
      Caption = '+2'
    end
    object Label19: TLabel
      Left = 480
      Top = 10
      Width = 14
      Height = 16
      Caption = '+3'
    end
    object Label20: TLabel
      Left = 528
      Top = 10
      Width = 14
      Height = 16
      Caption = '+4'
    end
    object Label21: TLabel
      Left = 568
      Top = 10
      Width = 14
      Height = 16
      Caption = '+5'
    end
    object Label22: TLabel
      Left = 616
      Top = 10
      Width = 14
      Height = 16
      Caption = '+6'
    end
    object Label23: TLabel
      Left = 664
      Top = 10
      Width = 14
      Height = 16
      Caption = '+7'
    end
    object MsgAddBtn: TBitBtn
      Left = 734
      Top = 100
      Width = 119
      Height = 32
      Caption = 'Hinzuf'#252'gen'
      TabOrder = 15
      OnClick = MsgAddBtnClick
      NumGlyphs = 2
    end
    object MsgDelBtn: TBitBtn
      Left = 734
      Top = 189
      Width = 115
      Height = 32
      Caption = 'Entfernen'
      TabOrder = 16
      OnClick = MsgDelBtnClick
      NumGlyphs = 2
    end
    object Data1Edit: TZahlenEdit
      Tag = 2
      Left = 341
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object Data2Edit: TZahlenEdit
      Tag = 3
      Left = 386
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object Data3Edit: TZahlenEdit
      Tag = 4
      Left = 433
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object Data4Edit: TZahlenEdit
      Tag = 5
      Left = 480
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object Data8Edit: TZahlenEdit
      Tag = 9
      Left = 666
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
    object Data5Edit: TZahlenEdit
      Tag = 6
      Left = 526
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object Data6Edit: TZahlenEdit
      Tag = 7
      Left = 572
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object Data7Edit: TZahlenEdit
      Tag = 8
      Left = 619
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object DLCEdit: TZahlenEdit
      Tag = 1
      Left = 253
      Top = 30
      Width = 29
      Height = 24
      Number = 0
      ZahlenFormat = DezFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CanFormatGroupBox: TGroupBox
      Left = 9
      Top = 60
      Width = 280
      Height = 77
      Caption = 'CAN Format '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      object RTRCheck: TCheckBox
        Tag = 13
        Left = 10
        Top = 20
        Width = 112
        Height = 22
        Caption = 'RTR Packet'
        TabOrder = 0
      end
      object EFFCheck: TCheckBox
        Tag = 14
        Left = 136
        Top = 20
        Width = 139
        Height = 22
        Caption = 'Ext. Frame Format'
        TabOrder = 1
      end
      object CheckBox1: TCheckBox
        Tag = 13
        Left = 10
        Top = 44
        Width = 112
        Height = 22
        Caption = 'CAN-FD Frame'
        TabOrder = 2
      end
      object CheckBox2: TCheckBox
        Tag = 14
        Left = 136
        Top = 44
        Width = 139
        Height = 22
        Caption = 'Bit Rate Switch'
        TabOrder = 3
      end
    end
    object IDEdit: TZahlen32Edit
      Left = 10
      Top = 30
      Width = 119
      Height = 24
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
      Left = 86
      Top = 274
      Width = 198
      Height = 24
      TabOrder = 11
    end
    object TxModeCombo: TComboBox
      Tag = 15
      Left = 84
      Top = 159
      Width = 99
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
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
      Left = 84
      Top = 198
      Width = 119
      Height = 24
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
      Left = 84
      Top = 228
      Width = 70
      Height = 24
      Number = 0
      ZahlenFormat = DezFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 14
    end
    object MsgTxBtn: TBitBtn
      Left = 734
      Top = 28
      Width = 99
      Height = 30
      Caption = 'Senden'
      TabOrder = 17
      OnClick = MsgTxBtnClick
      NumGlyphs = 2
    end
    object MsgCopyBtn: TBitBtn
      Left = 734
      Top = 141
      Width = 119
      Height = 32
      Caption = 'Kopieren'
      TabOrder = 18
      OnClick = MsgCopyBtnClick
      NumGlyphs = 2
    end
    object ZahlenEdit1: TZahlenEdit
      Tag = 2
      Left = 341
      Top = 54
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 19
    end
    object ZahlenEdit2: TZahlenEdit
      Tag = 3
      Left = 386
      Top = 54
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 20
    end
    object ZahlenEdit3: TZahlenEdit
      Tag = 4
      Left = 433
      Top = 54
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 21
    end
    object ZahlenEdit4: TZahlenEdit
      Tag = 5
      Left = 480
      Top = 54
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 22
    end
    object ZahlenEdit5: TZahlenEdit
      Tag = 9
      Left = 666
      Top = 54
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 23
    end
    object ZahlenEdit6: TZahlenEdit
      Tag = 6
      Left = 526
      Top = 54
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 24
    end
    object ZahlenEdit7: TZahlenEdit
      Tag = 7
      Left = 572
      Top = 54
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 25
    end
    object ZahlenEdit8: TZahlenEdit
      Tag = 8
      Left = 619
      Top = 54
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 26
    end
    object ZahlenEdit9: TZahlenEdit
      Tag = 2
      Left = 341
      Top = 78
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 27
    end
    object ZahlenEdit10: TZahlenEdit
      Tag = 3
      Left = 386
      Top = 78
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 28
    end
    object ZahlenEdit11: TZahlenEdit
      Tag = 4
      Left = 433
      Top = 78
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 29
    end
    object ZahlenEdit12: TZahlenEdit
      Tag = 5
      Left = 480
      Top = 78
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 30
    end
    object ZahlenEdit13: TZahlenEdit
      Tag = 9
      Left = 666
      Top = 78
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 31
    end
    object ZahlenEdit14: TZahlenEdit
      Tag = 6
      Left = 526
      Top = 78
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 32
    end
    object ZahlenEdit15: TZahlenEdit
      Tag = 7
      Left = 572
      Top = 78
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 33
    end
    object ZahlenEdit16: TZahlenEdit
      Tag = 8
      Left = 619
      Top = 78
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 34
    end
    object ZahlenEdit17: TZahlenEdit
      Tag = 2
      Left = 341
      Top = 102
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 35
    end
    object ZahlenEdit18: TZahlenEdit
      Tag = 3
      Left = 386
      Top = 102
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 36
    end
    object ZahlenEdit19: TZahlenEdit
      Tag = 4
      Left = 433
      Top = 102
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 37
    end
    object ZahlenEdit20: TZahlenEdit
      Tag = 5
      Left = 480
      Top = 102
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 38
    end
    object ZahlenEdit21: TZahlenEdit
      Tag = 9
      Left = 666
      Top = 102
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 39
    end
    object ZahlenEdit22: TZahlenEdit
      Tag = 6
      Left = 526
      Top = 102
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 40
    end
    object ZahlenEdit23: TZahlenEdit
      Tag = 7
      Left = 572
      Top = 102
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 41
    end
    object ZahlenEdit24: TZahlenEdit
      Tag = 8
      Left = 619
      Top = 102
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 42
    end
    object ZahlenEdit25: TZahlenEdit
      Tag = 2
      Left = 341
      Top = 126
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 43
    end
    object ZahlenEdit26: TZahlenEdit
      Tag = 3
      Left = 386
      Top = 126
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 44
    end
    object ZahlenEdit27: TZahlenEdit
      Tag = 4
      Left = 433
      Top = 126
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 45
    end
    object ZahlenEdit28: TZahlenEdit
      Tag = 5
      Left = 480
      Top = 126
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 46
    end
    object ZahlenEdit29: TZahlenEdit
      Tag = 9
      Left = 666
      Top = 126
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 47
    end
    object ZahlenEdit30: TZahlenEdit
      Tag = 6
      Left = 526
      Top = 126
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 48
    end
    object ZahlenEdit31: TZahlenEdit
      Tag = 7
      Left = 572
      Top = 126
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 49
    end
    object ZahlenEdit32: TZahlenEdit
      Tag = 8
      Left = 619
      Top = 126
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 50
    end
    object ZahlenEdit33: TZahlenEdit
      Tag = 2
      Left = 341
      Top = 150
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 51
    end
    object ZahlenEdit34: TZahlenEdit
      Tag = 3
      Left = 386
      Top = 150
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 52
    end
    object ZahlenEdit35: TZahlenEdit
      Tag = 4
      Left = 433
      Top = 150
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 53
    end
    object ZahlenEdit36: TZahlenEdit
      Tag = 5
      Left = 480
      Top = 150
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 54
    end
    object ZahlenEdit37: TZahlenEdit
      Tag = 9
      Left = 666
      Top = 150
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 55
    end
    object ZahlenEdit38: TZahlenEdit
      Tag = 6
      Left = 526
      Top = 150
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 56
    end
    object ZahlenEdit39: TZahlenEdit
      Tag = 7
      Left = 572
      Top = 150
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 57
    end
    object ZahlenEdit40: TZahlenEdit
      Tag = 8
      Left = 619
      Top = 150
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 58
    end
    object ZahlenEdit41: TZahlenEdit
      Tag = 2
      Left = 341
      Top = 174
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 59
    end
    object ZahlenEdit42: TZahlenEdit
      Tag = 3
      Left = 386
      Top = 174
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 60
    end
    object ZahlenEdit43: TZahlenEdit
      Tag = 4
      Left = 433
      Top = 174
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 61
    end
    object ZahlenEdit44: TZahlenEdit
      Tag = 5
      Left = 480
      Top = 174
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 62
    end
    object ZahlenEdit45: TZahlenEdit
      Tag = 9
      Left = 666
      Top = 174
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 63
    end
    object ZahlenEdit46: TZahlenEdit
      Tag = 6
      Left = 526
      Top = 174
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 64
    end
    object ZahlenEdit47: TZahlenEdit
      Tag = 7
      Left = 572
      Top = 174
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 65
    end
    object ZahlenEdit48: TZahlenEdit
      Tag = 8
      Left = 619
      Top = 174
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 66
    end
    object ZahlenEdit49: TZahlenEdit
      Tag = 2
      Left = 341
      Top = 198
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 67
    end
    object ZahlenEdit50: TZahlenEdit
      Tag = 3
      Left = 386
      Top = 198
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 68
    end
    object ZahlenEdit51: TZahlenEdit
      Tag = 4
      Left = 433
      Top = 198
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 69
    end
    object ZahlenEdit52: TZahlenEdit
      Tag = 5
      Left = 480
      Top = 198
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 70
    end
    object ZahlenEdit53: TZahlenEdit
      Tag = 9
      Left = 666
      Top = 198
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 71
    end
    object ZahlenEdit54: TZahlenEdit
      Tag = 6
      Left = 526
      Top = 198
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 72
    end
    object ZahlenEdit55: TZahlenEdit
      Tag = 7
      Left = 572
      Top = 198
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 73
    end
    object ZahlenEdit56: TZahlenEdit
      Tag = 8
      Left = 619
      Top = 198
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 74
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
