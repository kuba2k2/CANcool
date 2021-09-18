{***************************************************************************
                       Can-Cool.dpr  -  description
                             -------------------
    begin             : 03.12.2012
    copyright         : (C) 2012 by MHS-Elektronik GmbH & Co. KG, Germany
    autho             : Klaus Demlehner, klaus@mhs-elektronik.de
 ***************************************************************************}

{***************************************************************************
 *                                                                         *
 *   This program is free software, you can redistribute it and/or modify  *
 *   it under the terms of the MIT License <LICENSE.TXT or                 *
 *   http://opensource.org/licenses/MIT>                                   *              
 *                                                                         *
 ***************************************************************************}
program CANcool;

uses
  Forms,
  Windows,
  MainForm in 'MainForm.pas' {MainWin},
  CanRxForm in 'CanRxForm.pas' {CanRxWin},
  IntegerTerm in 'IntegerTerm.pas',
  CanRxPrototyp in 'CanRxPrototyp.pas' {CanRxPrototypForm},
  CanGaugeForm in 'CanGaugeForm.pas' {CanGaugeWin},
  CanGaugeSetupForm in 'CanGaugeSetupForm.pas' {CanGaugeSetupWin},
  CanValueForm in 'CanValueForm.pas' {CanValueWin},
  CanBitValueForm in 'CanBitValueForm.pas' {CanBitValueWin},
  CanBitValueSetupForm in 'CanBitValueSetupForm.pas' {CanBitValueSetupWin},
  CanValueSetupForm in 'CanValueSetupForm.pas' {CanValueSetupWin},
  NewChild in 'NewChild.pas' {NewChildForm},
  CanTx in 'CanTx.pas',
  CanRx in 'CanRx.pas',
  Util in 'Util.pas',
  setup in 'setup.pas' {SetupForm},
  ObjCanRx in 'ObjCanRx.pas',
  CanRxSaveForm in 'CanRxSaveForm.pas' {TraceSaveProgress},
  CanFdTxForm in 'CanFdTxForm.pas' {CanFdTxWin},
  CanTxForm in 'CanTxForm.pas' {CanTxWin};
{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'CANcool';
  Application.CreateForm(TMainWin, MainWin);
  //Sleep(2500);
  //SplashForm.Hide;
  //SplashForm.Free;
  Application.Run;
end.   
