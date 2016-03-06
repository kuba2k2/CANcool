{***************************************************************************
                      CanRxSaveForm.pas  -  description
                             -------------------
    begin             : 10.01.2016
    copyright         : (C) 2016 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanRxSaveForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TTraceSaveProgress = class(TForm)
    ProgressBar: TProgressBar;
    CancelButton: TButton;
    MessageLabel: TLabel;
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    NewPosition: Integer;
    procedure SetPosition;
  end;

var
  TraceSaveProgress: TTraceSaveProgress;

implementation

{$R *.dfm}

uses
  CanRx;

  
procedure TTraceSaveProgress.SetPosition;

begin
ProgressBar.Position := NewPosition;
end;


procedure TTraceSaveProgress.CancelButtonClick(Sender: TObject);
var rx_can_list: TRxCanList;

begin
rx_can_list := TRxCanList(Owner);
if rx_can_list.SaveThread <> nil then
  rx_can_list.SaveThread.Terminate;
end;

end.
