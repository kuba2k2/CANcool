{***************************************************************************
                          Util.pas  -  description
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
unit Util;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const
  HexDigits : array[0..15] of Char = '0123456789ABCDEF';


procedure InitUtil;
procedure DestroyUtil;

{ Globale Funktionen }
function ReadListInteger(Liste: TStrings; Name: string; Standard: integer): integer;
function ReadListString(Liste: TStrings; Name: string; Standard: string): string;
function StrToHex(str: String): DWord;
//function PosEx(const Substr: string; const S: string; Offset: Integer): Integer;
function ExtractSubstr(const s: string; var pos: Integer; const delims: TSysCharSet): string;
procedure RxCanEnterCritical;
procedure RxCanLeaveCritical;

implementation

var RxCanCriticalSection: TRTLCriticalSection;

function ReadListInteger(Liste: TStrings; Name: string; Standard: integer): integer;
var
  s: string;
begin
  s := Liste.Values[Name];
  if s <> '' then
  begin
    try
      result := StrToInt(s);
    except
      result := Standard;
    end;
  end
  else
    result := Standard;
end;


function ReadListString(Liste: TStrings; Name: string; Standard: string): string;
begin
  result := Liste.Values[Name];
  if result = '' then
    result := Standard;
end;


function StrToHex(str: String): DWord;
var i: Integer;
    n: Byte;
    z: DWord;
    
begin;
z := 0;
for i := 1 to length(str) do
  begin;
  if str[i] in ['0' .. '9'] then 
    n := ord(str[i]) - $30
  else if str[i] in ['A' .. 'F'] then
    n := ord(str[i]) - $37
  else
    n := 0;
  z := (z shl 4) + n;  
  end;
result := z;
end;


function ExtractSubstr(const s: string; var pos: Integer; const delims: TSysCharSet): string;
var i, l: Integer;

begin
i := pos;
l := Length(s);
while (i <= l) and not (s[i] in delims) do Inc(i);
if i = pos then
  Result := ''
else
  Result := Copy(s, pos, i - pos);
if (i <= Length(s)) and (s[i] in delims) then Inc(i);
pos := i;
end;


procedure InitUtil;
begin
InitializeCriticalSection(RxCanCriticalSection)
end;


procedure DestroyUtil;
begin
DeleteCriticalSection(RxCanCriticalSection);
end;


procedure RxCanEnterCritical;
begin
EnterCriticalSection(RxCanCriticalSection);
end;


procedure RxCanLeaveCritical;
begin
LeaveCriticalSection(RxCanCriticalSection);  
end;

end.