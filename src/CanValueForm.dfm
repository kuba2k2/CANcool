inherited CanValueWin: TCanValueWin
  Left = 1403
  Top = 627
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Wert Anzeige'
  ClientHeight = 67
  ClientWidth = 264
  Color = clBlack
  OldCreateOrder = True
  PopupMenu = WertAnzMenu
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object EinheitLabel: TLabel
    Left = 224
    Top = 16
    Width = 12
    Height = 32
    Caption = 'x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clAqua
    Font.Height = -24
    Font.Name = 'Palatino Linotype'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LEDDisplay: TLEDDisplay
    Left = 0
    Top = 0
    Width = 209
    Height = 57
    BevelStyle = bvNone
    BorderStyle = bsSingle
    ColorBackGround = clBlack
    ColorLED = clAqua
    DecSeparator = dsPoint
    DigitHeight = 50
    DigitWidth = 28
    DigitLineWidth = 5
    DrawDigitShapes = True
    FractionDigits = 3
    LeadingZeros = False
    LEDContrast = 7
    SegmentStyle = ssBeveled
    Value = 888.888000000000000000
  end
  object WertAnzMenu: TPopupMenu
    object ConfigBtn: TMenuItem
      Caption = 'Konfigurieren'
      OnClick = ConfigBtnClick
    end
    object AktivBtn: TMenuItem
      AutoCheck = True
      Caption = 'Aktiv'
      Checked = True
      OnClick = AktivBtnClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object DestroyBtn: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = DestroyBtnClick
    end
  end
end
