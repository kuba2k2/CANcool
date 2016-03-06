object CanRxWin: TCanRxWin
  Left = 1207
  Top = 861
  Width = 580
  Height = 296
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Empfang'
  Color = clBtnFace
  Constraints.MinHeight = 160
  Constraints.MinWidth = 476
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
  PixelsPerInch = 96
  TextHeight = 13
  object RxView: TStringGrid
    Left = 0
    Top = 0
    Width = 572
    Height = 160
    Align = alClient
    ColCount = 6
    DefaultColWidth = 53
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    PopupMenu = RxWinPopup
    ShowHint = True
    TabOrder = 0
    OnClick = RxViewClick
    OnDrawCell = RxViewDrawCell
  end
  object RxPanel: TPanel
    Left = 0
    Top = 160
    Width = 572
    Height = 102
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = RxWinPopup
    TabOrder = 1
    Visible = False
    object HeaderLabel: TLabel
      Left = 0
      Top = 0
      Width = 301
      Height = 14
      Caption = '[ID: ] [Count: 0] [Period: * Min: * Max: *]'
    end
    object Label2: TLabel
      Left = 0
      Top = 40
      Width = 28
      Height = 14
      Caption = 'Hex:'
    end
    object Label3: TLabel
      Left = 0
      Top = 56
      Width = 56
      Height = 14
      Caption = 'Dezimal:'
    end
    object Label4: TLabel
      Left = 0
      Top = 72
      Width = 49
      Height = 14
      Caption = 'Binary:'
    end
    object AsciiLabel: TLabel
      Left = 56
      Top = 88
      Width = 7
      Height = 14
    end
    object Label6: TLabel
      Left = 0
      Top = 88
      Width = 42
      Height = 14
      Caption = 'ASCII:'
    end
    object BinLabel: TLabel
      Left = 56
      Top = 72
      Width = 7
      Height = 14
    end
    object DezLabel: TLabel
      Left = 56
      Top = 56
      Width = 7
      Height = 14
    end
    object HexLabel: TLabel
      Left = 56
      Top = 40
      Width = 7
      Height = 14
    end
    object Label10: TLabel
      Left = 56
      Top = 16
      Width = 497
      Height = 14
      Caption = 
        '--- 0 -- --- 1 -- --- 2 -- --- 3 -- --- 4 -- --- 5 -- --- 6 -- -' +
        '-- 7 --'
    end
    object Analog1: TProgressBar
      Left = 56
      Top = 32
      Width = 56
      Height = 9
      Max = 255
      Smooth = True
      TabOrder = 0
    end
    object Analog2: TProgressBar
      Left = 119
      Top = 32
      Width = 56
      Height = 9
      Max = 255
      Smooth = True
      TabOrder = 1
    end
    object Analog3: TProgressBar
      Left = 182
      Top = 32
      Width = 56
      Height = 9
      Max = 255
      Smooth = True
      TabOrder = 2
    end
    object Analog4: TProgressBar
      Left = 245
      Top = 32
      Width = 56
      Height = 9
      Max = 255
      Smooth = True
      TabOrder = 3
    end
    object Analog5: TProgressBar
      Left = 308
      Top = 32
      Width = 56
      Height = 9
      Max = 255
      Smooth = True
      TabOrder = 4
    end
    object Analog6: TProgressBar
      Left = 371
      Top = 32
      Width = 56
      Height = 9
      Max = 255
      Smooth = True
      TabOrder = 5
    end
    object Analog7: TProgressBar
      Left = 434
      Top = 32
      Width = 56
      Height = 9
      Max = 255
      Smooth = True
      TabOrder = 6
    end
    object Analog8: TProgressBar
      Left = 497
      Top = 32
      Width = 56
      Height = 9
      Max = 255
      Smooth = True
      TabOrder = 7
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CAN-Log (*.csv)|*.csv|Alle Dateien (*.*)|*.*'
    Title = 'CAN Trace speichern'
    Left = 344
    Top = 8
  end
  object RxWinPopup: TPopupMenu
    Left = 376
    Top = 8
    object AddMsgToTxWinPopup: TMenuItem
      Caption = 'Nachricht in Senden-Fenster einf'#252'gen'
      OnClick = AddMsgToTxWinPopupClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ShowRxPannelPopup: TMenuItem
      AutoCheck = True
      Caption = 'Show Rx Pannel'
      OnClick = ShowRxPannelPopupClick
    end
    object ClearStatistikPopup: TMenuItem
      Caption = 'Statistik l'#246'schen'
      OnClick = ClearStatistikPopupClick
    end
  end
end
