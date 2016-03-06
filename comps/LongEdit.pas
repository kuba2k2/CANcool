{***************************************************************************
                        zahlen32.pas  -  description
                             -------------------   
    copyright         : (C) 2000 MHS-Elektronik GmbH & Co. KG, Germany
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
unit Longedit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls;

type
  TLongIntEdit = class(TEdit)
  protected
    function AsInt : longint;
    procedure SetInt(i : longint);
  published
    property Number : longint read AsInt write SetInt;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MHS', [TLongIntEdit]);
end;

function TLongIntEdit.AsInt : longint;
begin
  try
    Result:=StrToInt(Text);
  except
    on EConvertError do
      Result:=0;
  end;
end;

procedure TLongIntEdit.SetInt(i : longint);
begin
  Text:=IntToStr(i);
end;

end.
