unit IntegerTerm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
     
uses SysUtils;

type
  VarRec = record
    Name: string;
    Wert: variant;
  end;
  VarArray = array of VarRec;
  PVarArray = ^VarArray;

  TIntTerm = class
    constructor Create();
  private
    { Private-Deklarationen }
    pVari: PVarArray;
    FehlerPos: integer;
    FehlerLaenge: integer;
    FehlerText: string;
    procedure FindeOperation(Formula, Op: string; pPos: pinteger; p: integer);
    function  TermZerlegung(Formula: string; p: integer): Extended;
    procedure SetFehlerMeldung(s: string; p: integer; l: integer);
  public
    { Public-Deklarationen }
    function TermLoesen(Formula: string; pVariablen: PVarArray): Extended;
    function GetFehler(FPos, FLaenge: pinteger): integer;
    function GetFehlerText: string;
  end;

const
  // Zeichen bzw. Symbole für Rechenoperation
  //    << Bits links schieben, >> Bits rechts schieben
  //    & AND, | OR, ~ XOR
  OpStr: array[0..8] of string = ('+','-','*','/','>>','<<','&','|','~');

implementation

constructor TIntTerm.Create;

begin
pVari := nil;
FehlerPos := 0;
FehlerLaenge := 0;
FehlerText := '';
end;


function TIntTerm.TermLoesen(Formula: string; pVariablen: PVarArray): Extended;

begin
FehlerPos := 0;
FehlerText := '';
pVari := pVariablen;
result := TermZerlegung(Formula, 1);
end;

// -----------------------------------------------------------------------------
//  FindeOperation
//
//  Sucht die Rechenopertion, und gibt die Position zurück. In Klammern wird
//  nicht gesucht.
//
//  Term : Term, der nach einer Operation/Verknüpfung durchsucht werden soll
//  Op : Operation/Verknüpfung nach der in Term gesucht werden soll
//  pPos : Rückgabe der Position an der die Operation gefunden wurde
//  p : Zeichenposition im gesamt Term. Dient der Fehlerausgabe
// -----------------------------------------------------------------------------
procedure TIntTerm.FindeOperation(Formula: string; Op: string; pPos: pinteger; p: integer);
var
  n: integer;     // Zeichenzähler
  k: integer;     // Klammerzähler, '(' plus 1 ; ')' minus 1
  kPos: integer;  // Merker für Position der ersten Klammer (Fehlerausgabe)
begin
  kPos := 0;
  k := 0;
  for n := 1 to length(Formula) do
  begin
    if Formula[n] = '(' then
    begin
      if k = 0 then
        kPos := n;
      inc(k);
    end;
    if Formula[n] = ')' then
    begin
      dec(k);
      if k < 0 then
      begin
        SetFehlerMeldung('Klammer nicht geöffnet.', p+n-1, 1);
        exit;
      end;
    end;
    // if (k = 0) and (Formula[n] = Op) then
    if (k = 0) and (copy(Formula, n, length(Op)) = Op) then
    begin
      pPos^ := n;
      exit;
    end;
  end;
  pPos^ := 0;
  if k > 0 then
    SetFehlerMeldung('Öffnende Klammer gefunden, die nicht geschlossen wird.', p+kPos-1, 1);
end;
// ^^ FindeOperation ^^^^^^^^^^^^^^^^^^^^^^^^^^

// -----------------------------------------------------------------------------
// TermZerlegung
//
// Teilt den Term in seine Bestandteile auf
//
// Term : String des Term der entschlüsselt werden soll
// p : Zeichenposition im gesamt Term. Dient der Fehlerausgabe
// -----------------------------------------------------------------------------
function TIntTerm.TermZerlegung(Formula: string; p: integer): Extended;
var i: integer;
    n: integer;
    o1: Extended;
    o2: Extended;
    int_o1: int64;
    int_o2: int64;
    TempStr: string;

begin
result := 0;

if FehlerPos > 0 then
  begin
  result := 1;
  exit;
  end;

p := p + length(Formula) - length(TrimLeft(Formula));
Formula := trim(Formula);

i := 0;
while (i <= high(OpStr)) do
  begin
  FindeOperation(Formula, OpStr[i], @n, p);
  if n > 0 then
    begin
    o1 := TermZerlegung(copy(Formula, 1, n-1), p);
    o2 := TermZerlegung(copy(Formula, n+length(OpStr[i]), length(Formula)-n), p+n+length(OpStr[i])-1);
    if i >= 4 then
      begin
      int_o1 := Trunc(o1);
      int_o2 := Trunc(o2);
      end;
    case i of
      0: result := o1 + o2;
      1: result := o1 - o2;
      2: result := o1 * o2;
      3: result := o1 / o2;
      4: result := int_o1 shr int_o2;
      5: result := int_o1 shl int_o2;
      6: result := int_o1 and int_o2;
      7: result := int_o1 or int_o2;
      8: result := int_o1 xor int_o2;
      end;
    exit;
    end;
  inc(i);
  end;

// Ist Term in Klammern
if Formula[1] = '(' then
  begin
  if Formula[length(Formula)] = ')' then
    begin
    result := TermZerlegung(trim(copy(Formula, 2, length(Formula)-2)), p+1);
    exit;
    end;
  end;

// Auf Variable oder Funktion prüfen
if Formula[1] in ['a'..'z','A'..'Z','_'] then
  begin
  i := 2;
  while ((i <= length(Formula)) and (Formula[1] in ['a'..'z','A'..'Z','_','0'..'9'])) do
    begin
    inc(i);
    end;
  TempStr := copy(Formula, 1, i-1);

  // Auf Variablen prüfen
  if assigned(pVari) then
    begin
    for n := low(pVari^) to high(pVari^) do
      begin
      if lowercase(pVari^[n].Name) = lowercase(TempStr) then
        begin
        result := pVari^[n].Wert;
        exit;
        end;
      end;
    end;
  SetFehlerMeldung('Syntax Fehler, Variable "'+TempStr+'" unbekannt.', p, length(TempStr));

  // Auf Funktionen prüfen (z.B. Not, sin, cos)
  end;

  // Wenn Term eine Zahl ist
if Formula[1] in ['0'..'9', '.'] then
  begin
    try
      result := StrToFloat(Formula);
    except
      SetFehlerMeldung('Syntax Fehler, "'+Formula+'" ist keine gültige Zahl.', p, length(Formula));
    end;
    exit;
  end;
end;
// ^^ TermZerlegung ^^^^^^^^^^^^^^^^^^^^^^^^^^^


procedure TIntTerm.SetFehlerMeldung(s: string; p: integer; l: integer);

begin
FehlerPos := p;
FehlerLaenge := l;
FehlerText := s;
raise Exception.Create(s);
end;


function TIntTerm.GetFehler(FPos: pinteger; FLaenge: pinteger): integer;

begin
result := 0;
FPos^ := FehlerPos;
FLaenge^ := FehlerLaenge;
if FehlerPos > 0 then
  result := -1;
end;


function TIntTerm.GetFehlerText(): string;

begin
result := FehlerText;
end;

end.
