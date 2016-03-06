unit MHSTypes;

interface

uses Graphics;

type
TFormat = (HexFormat, DezFormat, BinFormat, ChrFormat);
TBin32Mode = (Z32Byte, Z32Word, Z32DWord, Z32AutoMode);

TBinMode = (ZByte, ZWord, ZAutoMode);

TSetupFont = record
  Name: String[33];
  Color: Longint;
  Size: Integer;
  Style: TFontStyles;
  end;

implementation

end.
 
