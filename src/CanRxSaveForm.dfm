object TraceSaveProgress: TTraceSaveProgress
  Left = 343
  Top = 981
  ActiveControl = CancelButton
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Trace Datei speichern...'
  ClientHeight = 81
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MessageLabel: TLabel
    Left = 8
    Top = 8
    Width = 50
    Height = 13
    Caption = 'Vortschritt:'
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 24
    Width = 425
    Height = 17
    Max = 400
    Smooth = True
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 216
    Top = 48
    Width = 217
    Height = 25
    Caption = 'Speichern der Datei abbrechen'
    TabOrder = 1
    OnClick = CancelButtonClick
  end
end
