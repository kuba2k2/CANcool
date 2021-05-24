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
  StdCtrls, ExtCtrls, ComCtrls, IniFiles, Longedit, zahlen, zahlen32;

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
                CANSpeed: Integer; { => 0 = Benutzerdefiniert 
                                   {    1 = 10kBit/s                    }
                                   {    2 = 20kBit/s                    }
                                   {    3 = 50kBit/s                    }
                                   {    4 = 100 kBit/s                  }
                                   {    5 = 125 kBit/s                  }
                                   {    6 = 250 kBit/s                  }
                                   {    7 = 500 kBit/s                  }
                                   {    8 = 800 kBit/s                  }
                                   {    9 = 1 MBit/s                    }                                   
                CANDataSpeed: Integer; { => 0 = Benutzerdefiniert
                                       {    1 = 250kBit/s               }
                                       {    2 = 500kBit/s               }
                                       {    3 = 1 Bit/s                 }
                                       {    4 = 1,5 MBit/s              }
                                       {    5 = 2 MBit/s                }
                                       {    6 = 3 MBit/s                }
                                       {    7 = 4 MBit/s                }
                                       {    8 = 5 MBit/s                }                                       
               NBTRValue: Integer;
               NBTRBitrate: String;
               NBTRDesc: String;               
               DBTRValue: Integer;
               DBTRBitrate: String;
               DBTRDesc: String;
               ListenOnly: Boolean;
               ShowErrorMessages: Boolean;
               CanFd: Boolean;
               CanFifoOvClear: Boolean;
               CanFifoOvMessages: Boolean;
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
    CanFdCheckBox: TCheckBox;
    CANDataSpeedEdit: TRadioGroup;
    NBTRStr: TLabel;
    NBTRHexStr: TLabel;
    DBTRHexStr: TLabel;
    DBTRStr: TLabel;
    CustomNBTRSetupBtn: TButton;
    CustomDBTRSetupBtn: TButton;
    NBTRDescEdit: TEdit;
    DBTRDescEdit: TEdit;
    NBTREdit: TZahlen32Edit;
    DBTREdit: TZahlen32Edit;
    NBTRBitrateEdit: TEdit;
    NBTRBitrateStr: TLabel;
    DBTRBitrateEdit: TEdit;
    DBTRBitrateStr: TLabel;
    Bevel1: TBevel;
    CanFifoOvClearBox: TCheckBox;
    CanFifoOvMessagesBox: TCheckBox;
    procedure InterfaceTypeEditClick(Sender: TObject);
    procedure DriverEditClick(Sender: TObject);
    procedure RxDEnableDynamicCheckBoxClick(Sender: TObject);
    procedure CanFdCheckBoxClick(Sender: TObject);
    procedure CANSpeedEditClick(Sender: TObject);
    procedure CANDataSpeedEditClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure UpdateCan;
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
i := -1;
NBTREdit.Number := SetupData.NBTRValue;
NBTRBitrateEdit.Text := SetupData.NBTRBitrate;
NBTRDescEdit.Text := SetupData.NBTRDesc;
DBTREdit.Number := SetupData.DBTRValue;
DBTRBitrateEdit.Text := SetupData.DBTRBitrate;
DBTRDescEdit.Text := SetupData.DBTRDesc;
DriverEdit.ItemIndex := SetupData.Driver;
if SetupData.CANSpeed = 0 then
  CANSpeedEdit.ItemIndex := 9
else
  CANSpeedEdit.ItemIndex := SetupData.CANSpeed - 1;
if SetupData.CANDataSpeed = 0 then
  CANDataSpeedEdit.ItemIndex := 7
else
  CANDataSpeedEdit.ItemIndex := SetupData.CANDataSpeed - 1;
LomCheckBox.Checked := SetupData.ListenOnly;
ShowErrMsgCheckBox.Checked := SetupData.ShowErrorMessages;
CanFdCheckBox.Checked := SetupData.CanFd;
CanFifoOvClearBox.Checked := SetupData.CanFifoOvClear;
CanFifoOvMessagesBox.Checked := SetupData.CanFifoOvMessages;
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
  i := 0;
  SetupData.NBTRValue := NBTREdit.Number;
  SetupData.NBTRBitrate := NBTRBitrateEdit.Text;
  SetupData.NBTRDesc := NBTRDescEdit.Text;
  SetupData.DBTRValue := DBTREdit.Number;
  SetupData.DBTRBitrate := DBTRBitrateEdit.Text;
  SetupData.DBTRDesc := DBTRDescEdit.Text;
  if CANSpeedEdit.ItemIndex = 9 then
    SetupData.CANSpeed := 0
  else
    SetupData.CANSpeed := CANSpeedEdit.ItemIndex + 1;
  if CANDataSpeedEdit.ItemIndex = 7 then
    SetupData.CANDataSpeed := 0
  else
    SetupData.CANDataSpeed := CANDataSpeedEdit.ItemIndex + 1;
  SetupData.ListenOnly := LomCheckBox.Checked;
  SetupData.ShowErrorMessages := ShowErrMsgCheckBox.Checked;
  SetupData.CanFd := CanFdCheckBox.Checked;
  SetupData.CanFifoOvClear := CanFifoOvClearBox.Checked;
  SetupData.CanFifoOvMessages := CanFifoOvMessagesBox.Checked;
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
UpdateCan;
UpdateDataList;
UpdateHardware;
end;


procedure TSetupForm.UpdateCan;

begin
if CANSpeedEdit.ItemIndex = 9 then
  begin;
  NBTRStr.Enabled := TRUE;
  NBTREdit.Enabled := TRUE;
  NBTRHexStr.Enabled := TRUE;
  NBTRBitrateStr.Enabled := TRUE;
  NBTRBitrateEdit.Enabled := TRUE;
  CustomNBTRSetupBtn.Enabled := TRUE;
  NBTRDescEdit.Enabled := TRUE;
  end
else
  begin;
  NBTRStr.Enabled := FALSE;
  NBTREdit.Enabled := FALSE;
  NBTRHexStr.Enabled := FALSE;
  NBTRBitrateStr.Enabled := FALSE;
  NBTRBitrateEdit.Enabled := FALSE;
  CustomNBTRSetupBtn.Enabled := FALSE;
  NBTRDescEdit.Enabled := FALSE;
  end;
if CanFdCheckBox.Checked then
  begin;
  CANDataSpeedEdit.Enabled := TRUE;
  if CANDataSpeedEdit.ItemIndex = 7 then
    begin;
    DBTRStr.Enabled := TRUE;
    DBTREdit.Enabled := TRUE;
    DBTRHexStr.Enabled := TRUE;
    DBTRBitrateStr.Enabled := TRUE;
    DBTRBitrateEdit.Enabled := TRUE;
    CustomDBTRSetupBtn.Enabled := TRUE;
    DBTRDescEdit.Enabled := TRUE;
    end
  else
    begin;
    DBTRStr.Enabled := FALSE;
    DBTREdit.Enabled := FALSE;
    DBTRHexStr.Enabled := FALSE;
    DBTRBitrateStr.Enabled := FALSE;
    DBTRBitrateEdit.Enabled := FALSE;
    CustomDBTRSetupBtn.Enabled := FALSE;
    DBTRDescEdit.Enabled := FALSE;
    end;
  end
else
  begin;
  CANDataSpeedEdit.Enabled := FALSE;
  DBTRStr.Enabled := FALSE;
  DBTREdit.Enabled := FALSE;
  DBTRHexStr.Enabled := FALSE;
  DBTRBitrateStr.Enabled := FALSE;
  DBTRBitrateEdit.Enabled := FALSE;
  CustomDBTRSetupBtn.Enabled := FALSE;
  DBTRDescEdit.Enabled := FALSE;
  end;
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


procedure TSetupForm.CanFdCheckBoxClick(Sender: TObject);

begin
UpdateCan;
end;


procedure TSetupForm.CANSpeedEditClick(Sender: TObject);

begin
UpdateCan;
end;

procedure TSetupForm.CANDataSpeedEditClick(Sender: TObject);

begin
UpdateCan;
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
SetupData.Driver := ini_file.ReadInteger('GLOBAL', 'Driver', 1);
SetupData.Port := ini_file.ReadInteger('GLOBAL', 'Port', 1);
SetupData.BaudRate := ini_file.ReadInteger('GLOBAL', 'BaudRate', 8);
SetupData.InterfaceType := ini_file.ReadInteger('GLOBAL', 'InterfaceType', 1);
SetupData.HardwareSnr := ini_file.ReadString('GLOBAL', 'HardwareSnr', '');
// Tab CAN
SetupData.CANSpeed := ini_file.ReadInteger('GLOBAL', 'CANSpeed', 5);
SetupData.CANDataSpeed := ini_file.ReadInteger('GLOBAL', 'CANDataSpeed', 0);
SetupData.NBTRValue := ini_file.ReadInteger('GLOBAL', 'NBTRValue', 0);
SetupData.NBTRBitrate := ini_file.ReadString('GLOBAL', 'NBTRBitrate', '');
SetupData.NBTRDesc:= ini_file.ReadString('GLOBAL', 'NBTRDesc', '');
SetupData.DBTRValue := ini_file.ReadInteger('GLOBAL', 'DBTRValue', 0);
SetupData.DBTRBitrate := ini_file.ReadString('GLOBAL', 'DBTRBitrate', '');
SetupData.DBTRDesc:= ini_file.ReadString('GLOBAL', 'DBTRDesc', '');
SetupData.ListenOnly := ini_file.ReadBool('GLOBAL', 'ListenOnly', false);
SetupData.ShowErrorMessages := ini_file.ReadBool('GLOBAL', 'ShowErrorMessages', false);
SetupData.CanFd := ini_file.ReadBool('GLOBAL', 'CanFd', false);
SetupData.CanFifoOvClear := ini_file.ReadBool('GLOBAL', 'CanFifoOvClear', false);
SetupData.CanFifoOvMessages := ini_file.ReadBool('GLOBAL', 'CanFifoOvMessages', false);

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
ini_file.WriteInteger('GLOBAL', 'CANDataSpeed', SetupData.CANDataSpeed);
ini_file.WriteInteger('GLOBAL', 'NBTRValue', SetupData.NBTRValue);
ini_file.WriteString('GLOBAL', 'NBTRBitrate', SetupData.NBTRBitrate);
ini_file.WriteString('GLOBAL', 'NBTRDesc', SetupData.NBTRDesc);
ini_file.WriteInteger('GLOBAL', 'DBTRValue', SetupData.DBTRValue);
ini_file.WriteString('GLOBAL', 'DBTRBitrate', SetupData.DBTRBitrate);
ini_file.WriteString('GLOBAL', 'DBTRDesc', SetupData.DBTRDesc);
ini_file.WriteBool('GLOBAL', 'ListenOnly', SetupData.ListenOnly);
ini_file.WriteBool('GLOBAL', 'ShowErrorMessages', SetupData.ShowErrorMessages);
ini_file.WriteBool('GLOBAL', 'CanFd', SetupData.CanFd);
ini_file.WriteBool('GLOBAL', 'CanFifoOvClear', SetupData.CanFifoOvClear); 
ini_file.WriteBool('GLOBAL', 'CanFifoOvMessages', SetupData.CanFifoOvMessages);
ini_file.WriteInteger('GLOBAL', 'DataClearMode', SetupData.DataClearMode);
ini_file.WriteInteger('GLOBAL', 'RxDBufferSize', SetupData.RxDBufferSize);
ini_file.WriteBool('GLOBAL', 'RxDEnableDynamic', SetupData.RxDEnableDynamic);
ini_file.WriteInteger('GLOBAL', 'RxDLimit', SetupData.RxDLimit);
end;

end.
