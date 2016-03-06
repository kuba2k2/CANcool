{***************************************************************************
                       CanRxPrototyp.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modified     : 17.01.2016    
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
unit CanRxPrototyp;

interface

uses Windows, Forms, Classes, Dialogs, Menus, TinyCanDrv;

type
  TCanRxPrototypForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  protected
    WindowMenuItem: TMenuItem;
  public
    { Public-Deklarationen }
    procedure RxCanMessages(can_msg: PCanMsg; count: Integer); virtual;
    procedure RxCanUpdate; virtual;
    procedure SaveConfig(ConfigList: TStrings); virtual;
    procedure LoadConfig(ConfigList: TStrings); virtual;
  end;

implementation

uses MainForm;

{$R *.dfm}

{ TEmpfangPrototypForm }

procedure TCanRxPrototypForm.FormCreate(Sender: TObject);
var MenuHandle: HMENU;

begin
WindowMenuItem := TMainWin(owner).MenuMDIClientHinzufuegen(self);
MenuHandle := GetSystemMenu(Self.Handle, False);
DeleteMenu(MenuHandle, 7, MF_BYPOSITION);
DeleteMenu(MenuHandle, 6, MF_BYPOSITION);
DeleteMenu(MenuHandle, 4, MF_BYPOSITION);
end;


procedure TCanRxPrototypForm.FormClose(Sender: TObject; var Action: TCloseAction);

begin
TMainWin(owner).MenuMDIClientEntfernen(WindowMenuItem);
Action := caFree;
end;


procedure TCanRxPrototypForm.RxCanMessages(can_msg: PCanMsg; count: Integer);

begin
  ;
end;


procedure TCanRxPrototypForm.RxCanUpdate;

begin
  ;
end;


procedure TCanRxPrototypForm.LoadConfig(ConfigList: TStrings);

begin
  ;
end;


procedure TCanRxPrototypForm.SaveConfig(ConfigList: TStrings);

begin
  ;
end;


procedure TCanRxPrototypForm.FormShow(Sender: TObject);

begin
self.BringToFront;
self.WindowState := wsNormal;
end;

end.
