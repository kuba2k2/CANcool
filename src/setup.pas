{***************************************************************************
                          Setup.pas  -  description
                             -------------------
    begin             : 07.01.2013
    copyright         : (C) 2013 by MHS-Elektronik GmbH & Co. KG, Germany
                               http://www.mhs-elektronik.de     
    autho             : Klaus Demlehner, klaus@mhs-elektronik.de
 ***************************************************************************}

{***************************************************************************
 *                                                                         *
 *   This program is free software, you can redistribute it and/or modify  *
 *   it under the terms of the MIT License <LICENSE.TXT or                 *
 *   http://opensource.org/licenses/MIT>                                   *              
 *                                                                         *
 ***************************************************************************}
unit setup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, IniFiles, Longedit, zahlen;

type
  TSetupData = record
                   { Abschnitt: Hardware }
                Driver: Integer;   { => 0 = Tiny-CAN                    }
                                   {    1 = SL-CAN                      }
                Port: Integer;     { => 1 = COM1                        }
                                   {    2 = COM2                        }
                                   {    3 = COM3                        }
                                   {    4 = COM4                        }
                                   {    5 = COM5                        }
                                   {    6 = COM6                        }
                                   {    7 = COM7                        }
                                   {    8 = COM8                        }
                BaudRate: Integer;
                InterfaceType: Integer; { 0 = USB                       }
                                        { 1 = RS232                     }
                HardwareSnr: String;
                CANSpeed: Integer; { => 0 = 10kBit/s                    }
                                   {    1 = 20kBit/s                    }
                                   {    2 = 50kBit/s                    }
                                   {    3 = 100 kBit/s                  }
                                   {    4 = 125 kBit/s                  }
                                   {    5 = 250 kBit/s                  }
                                   {    6 = 500 kBit/s                  }
                                   {    7 = 800 kBit/s                  }
                                   {    8 = 1 MBit/s                    }
               ListenOnly: Boolean;
               ShowErrorMessages: Boolean;
               DataClearMode: Integer; { 0 = Automatisch löschen        }
                                       { 1 = Benutzer fragen            }
                                       { 2 = nicht löschen              }
               RxDBufferSize: Longint;
               RxDEnableDynamic: Boolean;
               RxDLimit: Longint;
               end;

  TSetupForm = class(TForm)
    Panel1: TPanel;
    SetupOkBtn: TButton;
    SetupBreakBtn: TButton;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    CANSpeedEdit: TRadioGroup;
    TabSheet3: TTabSheet;
    DataClearModeGrp: TRadioGroup;
    Label2: TLabel;
    RxDBufferSizeEdit: TLongIntEdit;
    Label3: TLabel;
    TabSheet1: TTabSheet;
    PortEdit: TRadioGroup;
    Label4: TLabel;
    SnrEdit: TEdit;
    InterfaceTypeEdit: TRadioGroup;
    BaudRateEdit: TComboBox;
    Label1: TLabel;
    DriverEdit: TRadioGroup;
    LomCheckBox: TCheckBox;
    ShowErrMsgCheckBox: TCheckBox;
    RxDEnableDynamicCheckBox: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    RxDLimitEdit: TLongIntEdit;
    procedure InterfaceTypeEditClick(Sender: TObject);
    procedure DriverEditClick(Sender: TObject);
    procedure RxDEnableDynamicCheckBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure UpdateDataList;
    procedure UpdateHardware;
  public
    { Public-Deklarationen }
    function Execute: integer;
    procedure UpdateSetupForm;    
  end;

procedure LoadSetup(ini_file: TIniFile);
procedure SaveSetup(ini_file: TIniFile);

var  
  SetupData: TSetupData;

implementation

{$R *.DFM}

uses MainForm;


function TSetupForm.Execute: integer;
var i: integer;

begin;
i := 0;
DriverEdit.ItemIndex:=SetupData.Driver;
CANSpeedEdit.ItemIndex:=SetupData.CANSpeed;
LomCheckBox.Checked := SetupData.ListenOnly;
ShowErrMsgCheckBox.Checked := SetupData.ShowErrorMessages;
DataClearModeGrp.ItemIndex:= SetupData.DataClearMode;
RxDBufferSizeEdit.Number := SetupData.RxDBufferSize;
RxDEnableDynamicCheckBox.Checked := SetupData.RxDEnableDynamic;
RxDLimitEdit.Number := SetupData.RxDLimit;
InterfaceTypeEdit.ItemIndex := SetupData.InterfaceType;
PortEdit.ItemIndex := SetupData.Port-1;
BaudRateEdit.ItemIndex := SetupData.BaudRate;
SnrEdit.Text := SetupData.HardwareSnr;
UpdateSetupForm;
if ShowModal = idOk then
  begin;
  SetupData.CANSpeed:=CANSpeedEdit.ItemIndex;
  SetupData.ListenOnly := LomCheckBox.Checked;
  SetupData.ShowErrorMessages := ShowErrMsgCheckBox.Checked;
  SetupData.DataClearMode:=DataClearModeGrp.ItemIndex;
  SetupData.RxDBufferSize := RxDBufferSizeEdit.Number;
  SetupData.RxDEnableDynamic := RxDEnableDynamicCheckBox.Checked;
  SetupData.RxDLimit := RxDLimitEdit.Number;
  if SetupData.Driver <> DriverEdit.ItemIndex then
    i := 1;
  if SetupData.InterfaceType <> InterfaceTypeEdit.ItemIndex then
    i := 1;
  if (SetupData.Port-1) <> PortEdit.ItemIndex then
    i := 1;
  if SetupData.BaudRate <> BaudRateEdit.ItemIndex then
    i := 1;
  if SetupData.HardwareSnr <> SnrEdit.Text then
    i := 1;
  SetupData.Driver := DriverEdit.ItemIndex;
  SetupData.InterfaceType := InterfaceTypeEdit.ItemIndex;
  SetupData.Port := PortEdit.ItemIndex+1;
  SetupData.BaudRate := BaudRateEdit.ItemIndex;
  SetupData.HardwareSnr := SnrEdit.Text;
  end;
result := i;
end;


procedure TSetupForm.UpdateSetupForm;

begin;
InterfaceTypeEdit.Enabled := True;
UpdateDataList;
UpdateHardware;
end;


procedure TSetupForm.UpdateDataList;

begin
if RxDEnableDynamicCheckBox.Checked then
  RxDLimitEdit.Enabled := TRUE
else
  RxDLimitEdit.Enabled := FALSE;
end;


procedure TSetupForm.UpdateHardware;

begin;
if DriverEdit.ItemIndex = 0 then
  begin;
  if InterfaceTypeEdit.ItemIndex = 0 then
    begin;
    PortEdit.Enabled := False;
    BaudRateEdit.Enabled := False;
    SnrEdit.Enabled := True;
    end
  else
    begin;
    PortEdit.Enabled := True;
    BaudRateEdit.Enabled := True;
    SnrEdit.Enabled := False;
    end;
  end
else
  begin;
  if InterfaceTypeEdit.ItemIndex = 0 then
    begin;
    PortEdit.Enabled := False;
    BaudRateEdit.Enabled := True;
    SnrEdit.Enabled := True;
    end
  else
    begin;
    PortEdit.Enabled := True;
    BaudRateEdit.Enabled := True;
    SnrEdit.Enabled := False;
    end;
  end;
end;


procedure TSetupForm.RxDEnableDynamicCheckBoxClick(Sender: TObject);
begin
UpdateDataList;
end;


procedure TSetupForm.DriverEditClick(Sender: TObject);
begin
UpdateHardware;
end;


procedure TSetupForm.InterfaceTypeEditClick(Sender: TObject);
begin
UpdateHardware;
end;


procedure LoadSetup(ini_file: TIniFile);

begin;
SetupData.Driver := ini_file.ReadInteger('GLOBAL', 'Driver', 0);
SetupData.Port := ini_file.ReadInteger('GLOBAL', 'Port', 0);
SetupData.BaudRate := ini_file.ReadInteger('GLOBAL', 'BaudRate', 0);
SetupData.InterfaceType := ini_file.ReadInteger('GLOBAL', 'InterfaceType', 0);
SetupData.HardwareSnr := ini_file.ReadString('GLOBAL', 'HardwareSnr', '');
SetupData.CANSpeed := ini_file.ReadInteger('GLOBAL', 'CANSpeed', 0);
SetupData.ListenOnly := ini_file.ReadBool('GLOBAL', 'ListenOnly', false);
SetupData.ShowErrorMessages := ini_file.ReadBool('GLOBAL', 'ShowErrorMessages', false);
SetupData.DataClearMode := ini_file.ReadInteger('GLOBAL', 'DataClearMode', 0);
SetupData.RxDBufferSize := ini_file.ReadInteger('GLOBAL', 'RxDBufferSize', 100000);
SetupData.RxDEnableDynamic := ini_file.ReadBool('GLOBAL', 'RxDEnableDynamic', false);
SetupData.RxDLimit := ini_file.ReadInteger('GLOBAL', 'RxDLimit', 0);
end;


procedure SaveSetup(ini_file: TIniFile);

begin;
ini_file.WriteInteger('GLOBAL', 'Driver', SetupData.Driver);
ini_file.WriteInteger('GLOBAL', 'Port', SetupData.Port);
ini_file.WriteInteger('GLOBAL', 'BaudRate', SetupData.BaudRate);
ini_file.WriteInteger('GLOBAL', 'InterfaceType', SetupData.InterfaceType);
ini_file.WriteString('GLOBAL', 'HardwareSnr', SetupData.HardwareSnr);
ini_file.WriteInteger('GLOBAL', 'CANSpeed', SetupData.CANSpeed);
ini_file.WriteBool('GLOBAL', 'ListenOnly', SetupData.ListenOnly);
ini_file.WriteBool('GLOBAL', 'ShowErrorMessages', SetupData.ShowErrorMessages);
ini_file.WriteInteger('GLOBAL', 'DataClearMode', SetupData.DataClearMode);
ini_file.WriteInteger('GLOBAL', 'RxDBufferSize', SetupData.RxDBufferSize);
ini_file.WriteBool('GLOBAL', 'RxDEnableDynamic', SetupData.RxDEnableDynamic);
ini_file.WriteInteger('GLOBAL', 'RxDLimit', SetupData.RxDLimit);
end;


end.
