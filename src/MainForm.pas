{***************************************************************************
                         MainForm.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modified     : 27.02.2016     
    copyright         : (C) 2013 - 2016 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit MainForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, IniFiles, StdCtrls, ExtCtrls, Buttons,
  ToolWin, Grids, StrUtils, ImgList, TinyCanDrv, XLAboutDialog, CanRx, CanRxForm,
  CanTxForm, jpeg;

const
  RX_EVENT: DWORD = $00000001;
  RxMsgBufferSize: Cardinal = 4096;

  CANBaudParameter: array [0..8] of String =
       (' 10 kBit/s',
        ' 20 kBit/s',
        ' 50 kBit/s',
        '100 kBit/s',
        '125 kBit/s',
        '250 kBit/s',
        '500 kBit/s',
        '800 kBit/s',
        '  1 MBit/s');

  DrvStatusStrings: array[0..8] of String =
     ('Treiber DLL nicht geladen',         // Die Treiber DLL wurde noch nicht geladen
      'Treiber nicht Initialisiert ',      // Treiber noch nicht Initialisiert (Funktion "CanInitDrv" noch nicht aufgerufen)
      'Treiber DLL geladen',               // Treiber erfolgrich Initialisiert
      'Port kann nicht geöffnet werden',   // Die Schnittstelle wurde nicht geöffnet
      'System wird Initialisiert ...',     // Die Schnittstelle wurde geöffnet
      'System wird Initialisiert ...',     // Verbindung zur Hardware wurde Hergestellt
      'System Online',                     // Device wurde geöffnet und erfolgreich Initialisiert
      'System Online',                     // CAN Bus RUN nur Transmitter (wird nicht verwendet !)
      'System Online');                    // CAN Bus RUN

  CanStatusStrings: array[0..5] of String =
     ('CAN: Ok',                  // Ok
      'CAN: Error',               // CAN Error
      'CAN: Error warning',       // Error warning
      'CAN: Error passiv',        // Error passiv
      'CAN: Bus Off',             // Bus Off
      'CAN: Unbek. Fehler');      // Status Unbekannt

type
  TDataRecord = (RecordStart,  { Aufzeichnung Starten bzw. läuft     }
                 RecordStop,   { Aufzeichnung Stopen                 }
                 RecordOV,     { FIFO Überlauf !                     }
                 RecordLimit); { Empfangslimit Erreicht !            }

  TSyncThread = class;
  TComThread = class;

  TMainWin = class(TForm)
    HauptMenu: TMainMenu;
    DateiMnu: TMenuItem;
    HilfeMnu: TMenuItem;
    Info1: TMenuItem;
    BeendenMnu: TMenuItem;
    ProjectLoadMnu: TMenuItem;
    StatusBar: TStatusBar;
    FensterMnu: TMenuItem;
    ButtonImages: TImageList;
    CANMnu: TMenuItem;
    ConnectImages: TImageList;
    SaveDialog: TSaveDialog;
    ResetMnu: TMenuItem;
    OpenDialog: TOpenDialog;
    ToolBar: TToolBar;
    ToolImageList: TImageList;
    NextMDIMnu: TMenuItem;
    PrevMDIMnu: TMenuItem;
    N6: TMenuItem;
    ProjectSaveMnu: TMenuItem;
    N7: TMenuItem;
    TinyCAN: TTinyCAN;
    NewChildBtn: TToolButton;
    AboutDialog: TXLAboutDialog;
    ProjectLoadBtn: TToolButton;
    ProjectSaveBtn: TToolButton;
    ToolButton3: TToolButton;
    RxDListBtn: TToolButton;
    TxDListBtn: TToolButton;
    ToolButton6: TToolButton;
    SetupBtn: TToolButton;
    ProjectNewNmu: TMenuItem;
    Optionen1: TMenuItem;
    Einstellungen1: TMenuItem;
    RxWinMnu: TMenuItem;
    TxWinMnu: TMenuItem;
    RxTraceViewMnu: TMenuItem;
    RxObjectViewMnu: TMenuItem;
    N1: TMenuItem;
    SaveTraceMnu: TMenuItem;
    N2: TMenuItem;
    RxClearWinMnu: TMenuItem;
    TxLoadMnu: TMenuItem;
    TxSaveMnu: TMenuItem;
    N3: TMenuItem;
    TxClearWinMnu: TMenuItem;
    RxPanelShowMnu: TMenuItem;
    RxStatClearMnu: TMenuItem;
    N4: TMenuItem;
    ConnectMnu: TMenuItem;
    N5: TMenuItem;
    RxShowAllMnu: TMenuItem;
    RxShowUsedMnu: TMenuItem;
    RxShowUnusedMnu: TMenuItem;
    ToolButton1: TToolButton;
    TraceObjListBtn: TToolButton;
    TraceClearBtn: TToolButton;
    TraceSetupBtn: TToolButton;
    TraceStartStopBtn: TToolButton;
    TxIntervallOnBtn: TToolButton;
    TraceSetupPopup: TPopupMenu;
    RxShowAllPopup: TMenuItem;
    RxShowUsedPopup: TMenuItem;
    RxShowUnusedPopup: TMenuItem;
    N8: TMenuItem;
    RxPanelShowPopup: TMenuItem;
    RxStatClearPopup: TMenuItem;
    N9: TMenuItem;
    RxStartStopMnu: TMenuItem;
    N10: TMenuItem;
    ShowToolBarMnu: TMenuItem;
    CanResetBtn: TToolButton;
    LomCheckBtn: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TinyCANCanStatusEvent(Sender: TObject; index: Cardinal;
      device_status: TDeviceStatus);
    procedure NewChildBtnClick(Sender: TObject);
    procedure ProjectLoadBtnClick(Sender: TObject);
    procedure ProjectSaveBtnClick(Sender: TObject);
    procedure RxDListBtnClick(Sender: TObject);
    procedure TxDListBtnClick(Sender: TObject);
    procedure SetupBtnClick(Sender: TObject);
    procedure BeendenMnuClick(Sender: TObject);
    procedure ResetMnuClick(Sender: TObject);
    procedure NextMDIMnuClick(Sender: TObject);
    procedure PrevMDIMnuClick(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure ProjectNewNmuClick(Sender: TObject);
    procedure TinyCANCanPnPEvent(Sender: TObject; index: Cardinal;
      status: Integer);
    procedure RxViewMnuClick(Sender: TObject);
    procedure SaveTraceMnuClick(Sender: TObject);
    procedure RxClearWinMnuClick(Sender: TObject);
    procedure TxLoadMnuClick(Sender: TObject);
    procedure TxSaveMnuClick(Sender: TObject);
    procedure TxClearWinMnuClick(Sender: TObject);
    procedure RxPanelShowMnuClick(Sender: TObject);
    procedure RxStatClearMnuClick(Sender: TObject);
    procedure RxShowMnuClick(Sender: TObject);
    procedure ConnectMnuClick(Sender: TObject);
    procedure TraceSetupBtnClick(Sender: TObject);
    procedure TxIntervallOnBtnClick(Sender: TObject);
    procedure RxStartStopMnuClick(Sender: TObject);
    procedure ShowToolBarMnuClick(Sender: TObject);
    procedure LomCheckBtnClick(Sender: TObject);
    procedure RxPannelShowPopupClick(Sender: TObject);
    procedure RxShowPopupClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ComThread: TComThread;
    SyncThread: TSyncThread;
    procedure ComThreadTerminate;
    procedure SyncThreadTerminate;
    procedure RefreshStatusBar;
    procedure SetRxObjView;
    procedure SetStartStop;
  public
    { Public-Deklarationen }
    RxPannelShow: boolean;
    RxShowingMode: integer;
    DataRecord: TDataRecord;
    RxOjectView: boolean;
    DrvStatus: TDrvStatus;
    CanStatus: TCanStatus;
    BusFailure: boolean;
    ProjectFile: String;
    CanRxWin: TCanRxWin;
    CanTxWin: TCanTxWin;
    TinyCanEvent: Pointer;
    CanDeviceIndex: DWORD;
    procedure RxCanUpdate;
    function MDIClientNew(ClientForm: TFormClass): TForm;
    function  MenuMDIClientHinzufuegen(Sender: TForm): TMenuItem;
    procedure MenuMDIClientEntfernen(MenuItem: TMenuItem);
    procedure NewProject;
    function LoadProject(filename: String): boolean;
    function SaveProject(filename: String): boolean;
    function SetListenOnly: Integer;
    function ConnectHardware: Integer;
    procedure SetProjectName;
    procedure SetSetup(mode : Integer);
    procedure DisplayHint(Sender: TObject);
    procedure SetRxPannelShow;
    procedure SetRxShowingMode;
  end;

  TComThread = class(TThread)
  private
    Owner: TMainWin;
  protected
    procedure Execute; override;
  public
    TinyCanEvent: Pointer;
    constructor Create(AOwner: TMainWin);
    destructor Destroy; override;
  end;

  TSyncThread = class(TThread)
  private
    Owner: TMainWin;
    SyncEvent: THandle;
  protected
    procedure Execute; override;
  public
    procedure SetSync;
    constructor Create(AOwner: TMainWin);
    destructor Destroy; override;
  end;

var
  MainWin: TMainWin;

implementation

{$R *.dfm}

uses
  Util, Setup, CanRxPrototyp, CanGaugeForm, CanValueForm, CanBitValueForm, NewChild;

var
  RxMsgBuffer: PCanMsg;

{ TMainWin }

procedure TMainWin.FormCreate(Sender: TObject);
var cfg: TIniFile;

begin;
InitUtil;
RxMsgBuffer := AllocMem(RxMsgBufferSize * SizeOf(TCanMsg));
DataRecord := RecordStop;
//StatusBar.Font.Style := [];
cfg := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
try
  ProjectFile := cfg.ReadString('GLOBAL', 'ProjectFile', '');  
finally
  cfg.Free;
  end;
end;


procedure TMainWin.FormShow(Sender: TObject);
var default_prj_file: boolean;

begin;
{Hilfe in der Statuszeile}
//Application.OnHint:=DisplayHint;
// Project laden
default_prj_file := FALSE;
if ProjectFile = '' then
  begin;
  default_prj_file := TRUE;
  ProjectFile := ChangeFileExt(Application.ExeName, '.prj');
  end;
if not LoadProject(ProjectFile) then  
  begin;
  if not default_prj_file then  
    ProjectFile := '';
  NewProject;
  SetSetup(1);
  end;   
SetProjectName;  
RefreshStatusBar;
end;


procedure TMainWin.FormClose(Sender: TObject; var Action: TCloseAction);
var cfg: TIniFile;

begin;
TinyCAN.CanDeviceClose;
ComThreadTerminate;    // muss vor SyncThreadTerminate aufgerufen werden
SyncThreadTerminate;
TinyCAN.DownDriver;
cfg := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
try
  cfg.WriteString('GLOBAL', 'ProjectFile', ProjectFile);
finally
  cfg.Free;
  end;
// Project speichern
if ProjectFile <> '' then
  begin;
  if not SaveProject(ProjectFile) then
    MessageDlg('Projekt (' + ProjectFile + ') kann nicht gespeichert werden', mtError, [mbOk], 0);
  end;
DestroyUtil;
FreeMem(RxMsgBuffer);
end;


function TMainWin.MenuMDIClientHinzufuegen(Sender: TForm): TMenuItem;

begin
result := TMenuItem.Create(self);
result.Caption := Sender.Caption;
result.OnClick := Sender.OnShow;
Hauptmenu.Items.Find('Fenster').Add(result);
end;


procedure TMainWin.MenuMDIClientEntfernen(MenuItem: TMenuItem);
var MenuItemIndex: integer;

begin
if assigned(Hauptmenu) then
  begin
  MenuItemIndex := Hauptmenu.Items.Find('Fenster').IndexOf(MenuItem);
  Hauptmenu.Items.Find('Fenster').Delete(MenuItemIndex);
  end;
end;


procedure TMainWin.NewProject;
var form: TForm;
    i: Integer;

begin;
if MDIChildCount > 0 then
  begin;
  for i := 0 to MDIChildCount-1 do
    begin
    form := MDIChildren[i];
    if (form is TCanRxPrototypForm) then
      begin;
      if (form <> CanRxWin) and (form <> CanTxWin) then
        TCanRxPrototypForm(form).close;
      end;
    end;
  end;
if not Assigned(CanRxWin) then
  CanRxWin := TCanRxWin(MDIClientNew(TCanRxWin));
CanRxWin.Left := 2;
CanRxWin.Top := 2;
CanRxWin.Width := 600;
CanRxWin.Height := 303;
if not Assigned(CanTxWin) then
  CanTxWin := TCanTxWin(MDIClientNew(TCanTxWin));
CanTxWin.Left := 2;
CanTxWin.Top := 309;
CanTxWin.Width := 880;
CanTxWin.Height := 254;

CanRxWin.Show;
CanTxWin.Show;
end;


function TMainWin.LoadProject(filename: String): boolean;
var i: integer;
    ini_file: TIniFile;
    SectionsListe: TStringList;
    ConfigList: TStringList;
    form_class: TClass;
    Form: TForm;

begin
NewProject;
SectionsListe := TStringList.Create;
ConfigList := TStringList.Create;
result := TRUE;
ini_file := TIniFile.Create(filename);
try
  try
    LoadSetup(ini_file);
    Left := ini_file.ReadInteger('MainWin', 'XPos', 0);
    Top := ini_file.ReadInteger('MainWin', 'YPos', 0);
    Width := ini_file.ReadInteger('MainWin', 'Width', 1100);
    Height := ini_file.ReadInteger('MainWin', 'Height', 760);
    ini_file.ReadSections(SectionsListe);
    for i := SectionsListe.Count - 1 downto 0 do
      begin
      if AnsiStartsText('MDIWin', SectionsListe.Strings[i]) then
        begin
        form_class := GetClass(ini_file.ReadString(SectionsListe.Strings[i], 'Type', ''));
        if form_class <> nil then
          begin
          if form_class = TCanRxWin then
            form := CanRxWin
          else if form_class = TCanTxWin then
            form := CanTxWin
          else
            form := MDIClientNew(TFormClass(form_class));
          form.Left := ini_file.ReadInteger(SectionsListe.Strings[i], 'XPos', 0);
          form.Top := ini_file.ReadInteger(SectionsListe.Strings[i], 'YPos', 0);
          form.Width := ini_file.ReadInteger(SectionsListe.Strings[i], 'Width', 850);
          form.Height := ini_file.ReadInteger(SectionsListe.Strings[i], 'Height', 350);
          if form is TCanRxPrototypForm then
            begin
            ConfigList.Clear;
            ini_file.ReadSectionValues(SectionsListe.Strings[i], ConfigList);
            TCanRxPrototypForm(Form).LoadConfig(ConfigList);
            end;
          end;
        end;
      end;
  except
    result := FALSE;
    end;        
finally
  ConfigList.Free;
  SectionsListe.Free;
  ini_file.Free;
  end;
SetSetup(1);
end;


function TMainWin.SaveProject(filename: String): boolean;
var i, j: integer;
    ini_file: TIniFile;
    IniSections: TStringList;
    ConfigList: TStringList;
    Form: TForm;
    name: String;

begin
result := TRUE;
if MDIChildCount > 0 then
  begin;
  for i := 0 to MDIChildCount-1 do
    self.MDIChildren[i].WindowState := wsNormal;
  Application.ProcessMessages;
  end;
ConfigList := TStringList.Create;
ini_file := TIniFile.Create(filename);
try
  try
    SaveSetup(ini_file);
    ini_file.WriteInteger('MainWin', 'XPos', Left);
    ini_file.WriteInteger('MainWin', 'YPos', Top);
    ini_file.WriteInteger('MainWin', 'Width', Width);
    ini_file.WriteInteger('MainWin', 'Height', Height);

    IniSections := TStringList.Create;
    ini_file.ReadSections(IniSections);
    for i := 0 to IniSections.Count - 1 do
      begin
      if AnsiStartsText('MDIWin', IniSections.Strings[i]) then
        begin
        ini_file.EraseSection(IniSections.Strings[i]);
        end;
      end;
    IniSections.Free;
    if MDIChildCount > 0 then
      begin;
      for i := 0 to MDIChildCount-1 do
        begin
        Form := self.MDIChildren[i];
        ini_file.WriteString(format('MDIWin%u',[i]), 'Type', Form.ClassName);
        ini_file.WriteInteger(format('MDIWin%u',[i]), 'XPos', Form.Left);
        ini_file.WriteInteger(format('MDIWin%u',[i]), 'YPos', Form.Top);
        ini_file.WriteInteger(format('MDIWin%u',[i]), 'Width', Form.Width);
        ini_file.WriteInteger(format('MDIWin%u',[i]), 'Height', Form.Height);
        if Form is TCanRxPrototypForm then
          begin
          ConfigList.Clear;
          TCanRxPrototypForm(Form).SaveConfig(ConfigList);
          for j := 0 to ConfigList.Count - 1 do
            begin;
            name := ConfigList.Names[j];
            ini_file.WriteString(format('MDIWin%u',[i]), name, ConfigList.Values[name]);
            end;
          end;
        end;
      end;
  except
    result := FALSE;
    end;      
finally
  ConfigList.Free;
  ini_file.Free;
  end;
end;


function TMainWin.SetListenOnly: Integer;

begin;
if SetupData.ListenOnly then
  result := TinyCAN.CanSetMode(0, OP_CAN_START_LOM, CAN_CMD_ALL_CLEAR)
else
  result := TinyCAN.CanSetMode(0, OP_CAN_START, CAN_CMD_ALL_CLEAR);
end;


function TMainWin.ConnectHardware: Integer;

begin;
result := TinyCAN.CanDeviceOpen;
if result < 0 then
  exit;
result := SetListenOnly;
end;


procedure TMainWin.SetProjectName;
begin;
if ProjectFile = '' then
  MainWin.Caption := 'CANcool - Kein Project geladen' 
else
  MainWin.Caption := 'CANcool - ' + ExtractFileName(ProjectFile); 
end;


procedure TMainWin.SetSetup(mode : Integer);
var trace_clear: boolean;
    max_clumps: Integer;
    open_run: Integer;

begin;
trace_clear := FALSE;
open_run := 0;
if mode > 0 then
  begin;
  trace_clear := TRUE;
  ComThreadTerminate;    // muss vor SyncThreadTerminate aufgerufen werden
  SyncThreadTerminate;
  if SetupData.Driver = 0 then
    TinyCAN.TreiberName := 'mhstcan.dll'   // Tiny-CAN
  else
    TinyCAN.TreiberName := 'mhsslcan.dll'; // SL-CAN
  TinyCan.InterfaceType := TInterfaceType(SetupData.InterfaceType);
  TinyCan.Port := SetupData.Port;
  if (SetupData.Driver = 0) and (TinyCan.InterfaceType = INTERFACE_USB) then
    TinyCan.BaudRate := SER_AUTO_BAUD
  else
    TinyCan.BaudRate := TSerialBaudRate(SetupData.BaudRate+1);
  TinyCan.DeviceSnr := SetupData.HardwareSnr;
  if TinyCAN.LoadDriver = 0 then
    begin
    TinyCAN.CanExCreateDevice(CanDeviceIndex, '');
    TinyCanEvent := TinyCAN.CanExCreateEvent;
    TinyCAN.CanExCreateFifo($80000000, 30000, TinyCanEvent, RX_EVENT, $FFFFFFFF);
    ComThread := TComThread.Create(self);
    SyncThread := TSyncThread.Create(self);
    open_run := 2;
    end;
  end;
if Assigned(CanRxWin) then
  begin
  if CanRxWin.RxList.ClumpSize <> SetupData.RxDBufferSize then
    trace_clear := TRUE;
  if SetupData.RxDEnableDynamic then
    max_clumps := SetupData.RxDLimit
  else
    max_clumps := 1;
  if max_clumps <> CanRxWin.RxList.MaxClumps then
    trace_clear := TRUE;    
  if trace_clear then
    begin;
    CanRxWin.ExecuteCmd(RX_WIN_STOP_TRACE, nil);
    CanRxWin.ExecuteCmd(RX_WIN_CLEAR, nil);
    end;
  CanRxWin.RxList.ClumpSize := SetupData.RxDBufferSize;
  if SetupData.RxDEnableDynamic then
    CanRxWin.RxList.MaxClumps := SetupData.RxDLimit
  else
    CanRxWin.RxList.MaxClumps := 1;
  end;
TinyCan.CanSpeed := TCanSpeed(SetupData.CANSpeed);
if SetupData.ShowErrorMessages then
  TinyCan.OptionsStr := 'CanErrorMsgsEnable=1'
else
  TinyCan.OptionsStr := 'CanErrorMsgsEnable=0';
if (open_run = 0) and (LomCheckBtn.Down <> SetupData.ListenOnly) then  
  open_run := 1;   
LomCheckBtn.Down := SetupData.ListenOnly;
TinyCan.CanSetOptions;
if open_run = 2 then
  ConnectHardware
else if open_run = 1 then
  SetListenOnly;
RefreshStatusBar;
end;


function TMainWin.MDIClientNew(ClientForm: TFormClass): TForm;
begin;
result:=ClientForm.Create(self);
end;


procedure TMainWin.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var stat: Integer;

begin
  if Panel.ID = 0 then
  begin
    if DrvStatus >= DRV_STATUS_CAN_RUN then
      stat := 1
    else
      stat := 0;
    ConnectImages.Draw(StatusBar.Canvas, Rect.Left+1, Rect.Top, stat);
    StatusBar.Canvas.TextOut(Rect.Left + ConnectImages.Width + 5, Rect.Top + 1,
          CANBaudParameter[SetupData.CANSpeed]);
  end;
end;


procedure TMainWin.RefreshStatusBar;
begin
if BusFailure then
  StatusBar.Panels[1].Text := CanStatusStrings[ord(CanStatus)] + ' [BUS-FAILURE]'
else
  StatusBar.Panels[1].Text := CanStatusStrings[ord(CanStatus)];
StatusBar.Panels[2].Text := DrvStatusStrings[ord(DrvStatus)];
StatusBar.Refresh;
end;


{**************************************************************}
{* Hilfe in der Status Zeile anzeigen                         *}
{**************************************************************}
procedure TMainWin.DisplayHint(Sender: TObject);

begin;
if Application.Hint <> '' then
  begin;
  StatusBar.SimplePanel := True;
  StatusBar.SimpleText := Application.Hint;
  end
else
  RefreshStatusBar;  
end;


procedure TMainWin.TinyCANCanStatusEvent(Sender: TObject;
  index: Cardinal; device_status: TDeviceStatus);
begin
if DrvStatus >= DRV_STATUS_CAN_OPEN then
  begin;
  {if device_status.DrvStatus < DRV_STATUS_CAN_OPEN then
     }
  end;
{if (DrvStatus <> device_status.DrvStatus) and
  (device_status.DrvStatus >= DRV_STATUS_CAN_RUN) then
  begin;
  VerbindungsStat := 2;
  StatusBar.Refresh;
  end;}
DrvStatus := device_status.DrvStatus;
CanStatus := device_status.CanStatus;
BusFailure := device_status.BusFailure;
RefreshStatusBar;
end;


procedure TMainWin.TinyCANCanPnPEvent(Sender: TObject; index: Cardinal;
  status: Integer);
begin
{if TinyCan.CanExGetDeviceCount(1) > 0 then  // <*>
  ConnectHardware;}
RefreshStatusBar;
end;


procedure TMainWin.NewChildBtnClick(Sender: TObject);
var form: TNewChildForm;

begin
form := TNewChildForm.Create(self);
form.Left := self.Left;
form.Top := self.Top + ToolBar.Height;
form.ShowModal;
form.Free;
end;


procedure TMainWin.ProjectLoadBtnClick(Sender: TObject);

begin
OpenDialog.FileName := ProjectFile;
if OpenDialog.Execute then
  begin;
  ProjectFile := OpenDialog.FileName;
  if ProjectFile <> '' then
    begin;  
    if not LoadProject(ProjectFile) then
      begin;
      MessageDlg('Projekt (' + ProjectFile + ') kann nicht geladen werden', mtError, [mbOk], 0);
      ProjectFile := '';
      end;
    end;
  end;
SetProjectName;  
end;


procedure TMainWin.ProjectSaveBtnClick(Sender: TObject);

begin
SaveDialog.FileName := ProjectFile;
if SaveDialog.Execute then
  begin;
  ProjectFile := SaveDialog.FileName;
  if ProjectFile <> '' then
    begin;
    if not SaveProject(ProjectFile) then
      MessageDlg('Projekt (' + ProjectFile + ') kann nicht gespeichert werden', mtError, [mbOk], 0);    
    end;
  end;
SetProjectName;
end;


procedure TMainWin.RxDListBtnClick(Sender: TObject);

begin
CanRxWin.BringToFront;
CanRxWin.WindowState := wsNormal;
end;


procedure TMainWin.TxDListBtnClick(Sender: TObject);

begin
CanTxWin.BringToFront;
CanTxWin.WindowState := wsNormal;
end;


procedure TMainWin.SetupBtnClick(Sender: TObject);
var
  setup_win: TSetupForm;
  i : Integer;

begin
setup_win := TSetupForm.Create(self);
i := setup_win.Execute;
setup_win.Free;
if i > -1 then
  SetSetup(i);
end;


procedure TMainWin.ConnectMnuClick(Sender: TObject);
begin
if ConnectHardware < 0 then
  MessageDlg('Fehler beim öffnen des Device', mtError, [mbOk], 0);
RefreshStatusBar;
end;

procedure TMainWin.BeendenMnuClick(Sender: TObject);

begin
close;
end;


procedure TMainWin.ResetMnuClick(Sender: TObject);

begin
TinyCAN.CanSetMode(0, OP_CAN_RESET, CAN_CMD_RXD_FIFOS_CLEAR or CAN_CMD_TXD_FIFOS_CLEAR);
RefreshStatusBar;
end;


procedure TMainWin.NextMDIMnuClick(Sender: TObject);

begin
self.Next;
end;


procedure TMainWin.PrevMDIMnuClick(Sender: TObject);

begin
self.Previous;
end;


procedure TMainWin.Info1Click(Sender: TObject);

begin
AboutDialog.Execute;
end;


procedure TMainWin.ProjectNewNmuClick(Sender: TObject);

begin
NewProject;
ProjectFile := '';
SaveDialog.FileName := '';
if SaveDialog.Execute then
  begin;
  ProjectFile := SaveDialog.FileName;
  if ProjectFile <> '' then
    begin;
    if not SaveProject(ProjectFile) then
      begin;
      MessageDlg('Projekt (' + ProjectFile + ') kann nicht gespeichert werden', mtError, [mbOk], 0);
      ProjectFile := '';
      end;
    end;
  end;
SetProjectName;  
end;


procedure TMainWin.RxViewMnuClick(Sender: TObject);
begin
if RxOjectView then
  RxOjectView := False
else
  RxOjectView := True;
SetRxObjView;
end;


procedure TMainWin.SetRxPannelShow;

begin;
RxPanelShowMnu.Checked := RxPannelShow;
RxPanelShowPopup.Checked := RxPannelShow;
if Assigned(CanRxWin) then
  begin;
  if RxPannelShow then
    CanRxWin.ExecuteCmd(RX_WIN_SHOW_RX_PANNEL, nil)
  else
    CanRxWin.ExecuteCmd(RX_WIN_HIDE_RX_PANNEL, nil);
  end;
end;


procedure TMainWin.RxPanelShowMnuClick(Sender: TObject);
begin
RxPannelShow := RxPanelShowMnu.Checked;
SetRxPannelShow;
end;


procedure TMainWin.RxPannelShowPopupClick(Sender: TObject);

begin
RxPannelShow := RxPanelShowPopup.Checked;
SetRxPannelShow;
end;


procedure TMainWin.RxStatClearMnuClick(Sender: TObject);
begin
if Assigned(CanRxWin) then
  CanRxWin.ExecuteCmd(RX_WIN_STAT_CLEAR, nil);
end;


procedure TMainWin.SetRxShowingMode;

begin;
if RxShowingMode = 1 then
  begin;
  RxShowUsedMnu.Checked := True;
  RxShowUsedPopup.Checked := True;
  end
else if RxShowingMode = 2 then
  begin;
  RxShowUnusedMnu.Checked := True;
  RxShowUnusedPopup.Checked := True;
  end
else
  begin;
  RxShowAllMnu.Checked := True;
  RxShowAllPopup.Checked := True;
  end;
if Assigned(CanRxWin) then
  begin;
  if RxShowingMode = 1 then
    CanRxWin.ExecuteCmd(RX_WIN_SHOW_USED_MSG, nil)
  else if RxShowingMode = 2 then
    CanRxWin.ExecuteCmd(RX_WIN_SHOW_UNUSED_MSG, nil)
  else
    CanRxWin.ExecuteCmd(RX_WIN_SHOW_ALL_MSG, nil);
  end;
end;


procedure TMainWin.RxShowMnuClick(Sender: TObject);

begin
if RxShowUsedMnu.Checked then
  RxShowingMode := 1
else if RxShowUnusedMnu.Checked then
  RxShowingMode := 2
else
  RxShowingMode := 0;
SetRxShowingMode;
end;


procedure TMainWin.RxShowPopupClick(Sender: TObject);
begin
if RxShowUsedPopup.Checked then
  RxShowingMode := 1
else if RxShowUnusedPopup.Checked then
  RxShowingMode := 2
else
  RxShowingMode := 0;
SetRxShowingMode;
end;


procedure TMainWin.SaveTraceMnuClick(Sender: TObject);
begin
if Assigned(CanRxWin) then
  CanRxWin.ExecuteCmd(RX_WIN_SAVE_TRACE, nil);
end;


procedure TMainWin.RxClearWinMnuClick(Sender: TObject);
begin
if Assigned(CanRxWin) then
  CanRxWin.ExecuteCmd(RX_WIN_CLEAR, nil);
end;


procedure TMainWin.TxLoadMnuClick(Sender: TObject);
begin
if Assigned(CanTxWin) then
  CanTxWin.ExecuteCmd(TX_WIN_LOAD, nil);
end;


procedure TMainWin.TxSaveMnuClick(Sender: TObject);
begin
if Assigned(CanTxWin) then
  CanTxWin.ExecuteCmd(TX_WIN_SAVE, nil);
end;


procedure TMainWin.TxClearWinMnuClick(Sender: TObject);
begin
if Assigned(CanTxWin) then
  CanTxWin.ExecuteCmd(TX_WIN_CLEAR, nil);
end;


procedure TMainWin.SetRxObjView;

begin;
if RxOjectView then
  begin;
  TraceObjListBtn.Down := True;
  RxObjectViewMnu.Checked := True;
  if Assigned(CanRxWin) then
    CanRxWin.ExecuteCmd(RX_WIN_SHOW_OBJECT, nil);
  end
else
  begin;
  TraceObjListBtn.Down := False;
  RxTraceViewMnu.Checked := True;
  if Assigned(CanRxWin) then
    CanRxWin.ExecuteCmd(RX_WIN_SHOW_TRACE, nil);
  end;
end;


procedure TMainWin.SetStartStop;
var clear_data: boolean;

begin;
clear_data := FALSE;
if not Assigned(CanRxWin) then
  exit;
if DataRecord in [RecordStart, RecordOV] then
  begin;
  TraceStartStopBtn.Down := True;
  TraceStartStopBtn.ImageIndex := 10;
  TraceStartStopBtn.Caption := 'Stop';
  RxStartStopMnu.Caption := 'Aufzeichnung stoppen';
  if SetupData.DataClearMode = 0 then
    clear_data := TRUE
  else if SetupData.DataClearMode = 1 then
    begin;
    if CanRxWin.RxList.Count > 0 then
      begin;
      if MessageDlg('Trace Daten löschen ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        clear_data := TRUE;
      end;
    end;      
  if clear_data then 
    CanRxWin.ExecuteCmd(RX_WIN_CLEAR, nil);  
  CanRxWin.ExecuteCmd(RX_WIN_START_TRACE, nil);
  end
else
  begin;
  TraceStartStopBtn.Down := False;
  TraceStartStopBtn.ImageIndex := 9;
  TraceStartStopBtn.Caption := 'Start';
  RxStartStopMnu.Caption := 'Aufzeichnung starten';
  CanRxWin.ExecuteCmd(RX_WIN_STOP_TRACE, nil);
  end;
end;


procedure TMainWin.TraceSetupBtnClick(Sender: TObject);
begin
TraceSetupBtn.CheckMenuDropdown;
end;


procedure TMainWin.TxIntervallOnBtnClick(Sender: TObject);
begin
if TxIntervallOnBtn.Down then
  begin;
  if Assigned(CanTxWin) then
    CanTxWin.ExecuteCmd(TX_WIN_ENABLE_INTERVALL, nil);
  end
else
  begin;
  if Assigned(CanTxWin) then
    CanTxWin.ExecuteCmd(TX_WIN_DISABLE_INTERVALL, nil);
  end;
end;


procedure TMainWin.RxStartStopMnuClick(Sender: TObject);

begin
if DataRecord in [RecordStart, RecordOV] then
  DataRecord := RecordStop
else
  DataRecord := RecordStart;
SetStartStop;
end;


procedure TMainWin.ShowToolBarMnuClick(Sender: TObject);

begin
if ShowToolBarMnu.Checked then
  ToolBar.Show
else
  ToolBar.Hide;
end;


procedure TMainWin.LomCheckBtnClick(Sender: TObject);

begin
SetupData.ListenOnly := LomCheckBtn.Down;
SetListenOnly;
end;


procedure TMainWin.ComThreadTerminate;

begin
if Assigned(ComThread) then
  begin
  ComThread.Terminate;
  TinyCAN.CanExSetEvent(TinyCanEvent, MHS_EVENT_TERMINATE);
  ComThread.WaitFor;
  FreeAndNil(ComThread);
  end;
end;


{ TComThread }

constructor TComThread.Create(AOwner: TMainWin);
begin
Owner := AOwner;
inherited Create(True);  // Thread erzeugen nicht starten
//Priority := tpHighest;
Priority := tpHigher;
FreeOnTerminate := false;
Resume;                  // Thread starten
end;


destructor TComThread.Destroy;

begin
if not Terminated then
  begin
  Terminate;
  if Owner <> nil then
    begin
    if Owner.TinyCAN <> nil then
      Owner.TinyCAN.CanExSetEvent(TinyCanEvent, MHS_EVENT_TERMINATE);
    end;
  end;
inherited;
end;


procedure TComThread.Execute;
var
  i, event: DWORD;
  count: Integer;
  form: TForm;

begin
inherited;
if RxMsgBuffer = nil then
  exit;
while not Terminated do
  begin
  event := Owner.TinyCAN.CanExWaitForEvent(Owner.TinyCanEvent, 0);
  if event = $80000000 then
    break;
  if event = RX_EVENT then
    begin;    
    count := Owner.TinyCAN.CanReceive($80000000, RxMsgBuffer, RxMsgBufferSize);
    if count > 0 then
      begin;
      RxCanEnterCritical;      
      if Owner.MDIChildCount > 0 then
        begin;
        for i := 0 to Owner.MDIChildCount-1 do
          begin
          form := Owner.MDIChildren[i];
          if (form is TCanRxPrototypForm) then
            begin;
            if (form <> Owner.CanRxWin) and (form <> Owner.CanTxWin) then
              TCanRxPrototypForm(form).RxCanMessages(RxMsgBuffer, count);
            end;
          end;
        if Owner.CanRxWin <> nil then
          Owner.CanRxWin.RxCanMessages(RxMsgBuffer, count);
        if Owner.CanTxWin <> nil then
          Owner.CanTxWin.RxCanMessages(RxMsgBuffer, count);
        end;
      RxCanLeaveCritical;
      if Owner.SyncThread <> nil then
        Owner.SyncThread.SetSync;
      end;
    end;
  end;    
end;


procedure TMainWin.SyncThreadTerminate;

begin
if Assigned(SyncThread) then
  begin
  SyncThread.Terminate;
  SetEvent(SyncThread.SyncEvent);
  SyncThread.WaitFor;
  FreeAndNil(SyncThread);
  end;
end;


procedure TMainWin.RxCanUpdate;
var i: DWORD;
    form: TForm;

begin
if MDIChildCount > 0 then
  begin;
  for i := 0 to MDIChildCount-1 do
    begin
    form := MDIChildren[i];
    if (form is TCanRxPrototypForm) then
      begin;
      if (form <> CanRxWin) and (form <> CanTxWin) then
        TCanRxPrototypForm(form).RxCanUpdate;
      end;
    end;
  if CanRxWin <> nil then
    CanRxWin.RxCanUpdate;
  if CanTxWin <> nil then
    CanTxWin.RxCanUpdate;
  end;
end;  

{ TSyncThread }

constructor TSyncThread.Create(AOwner: TMainWin);
  
begin
Owner := AOwner;
inherited Create(True);  // Thread erzeugen nicht starten
SyncEvent := CreateEvent(nil, false, false, 'SYNC_EVENT');
if SyncEvent = 0 then
  raise Exception.Create('Unable to create SYNC_EVENT');
Priority := tpLower;
FreeOnTerminate := false;
Resume;                  // Thread starten
end;


destructor TSyncThread.Destroy;

begin
if not Terminated then
  begin
  Terminate;
  SetEvent(SyncEvent);
  WaitFor;
  end;
CloseHandle(SyncEvent);
inherited;
end;


procedure TSyncThread.SetSync;

begin
SetEvent(SyncEvent);
end;


procedure TSyncThread.Execute;
begin
while not Terminated do
  begin
  WaitForSingleObject(SyncEvent, INFINITE);
  if Terminated then
    break; 
  Synchronize(Owner.RxCanUpdate);
  Sleep(100);  // 100 ms Pause
  end;
end;


initialization
  RegisterClasses([TCanRxWin, TCanTxWin,
        TCanGaugeWin, TCanBitValueWin,
        TCanValueWin]); // TGraphWin

end.
