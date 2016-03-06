inherited CanBitValueWin: TCanBitValueWin
  Left = 1522
  Top = 637
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Bit Indikator'
  ClientHeight = 31
  ClientWidth = 213
  OldCreateOrder = True
  PopupMenu = BitIndikMenu
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = nil
  PixelsPerInch = 96
  TextHeight = 13
  object BitIndikMenu: TPopupMenu
    object ConfigBtn: TMenuItem
      Caption = 'Konfiguration'
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
