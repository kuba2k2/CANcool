///////////////////////////////////////
// class   KrLed                     //
// Version 1.0                       //
// Date    04-10-97                  //
// E-Mail  kray@iaehv.nl             //
// Page    www.at-krays.com          //
///////////////////////////////////////

unit Kr_Led;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TAlign=(alLeft, alRight, alCenter, alBottom, alTop);
  TBorder=(olNone, ol3dUp, ol3dDown, olLine);
  TState=(stOn, stOff);
  TCAlign=(caLeft, caRight, caCenter, caTop, caBottom);

  TBeforeChange=procedure(Sender:TObject; var AStatus:boolean) of object;
  TAfterChange=procedure(Sender:TObject) of object;

  KrLed = class(TGraphicControl)
  private
    _Caption:string;
    _CaptionAlign:TCAlign;
    _CaptionMargin:integer;
    _CaptionBorder:TBorder;
    _CaptionLineColor:TColor;
    _CaptionTransparant:boolean;
    _CaptionBackGround:TColor;
    _ColorLedOn:TColor;
    _ColorLedOff:TColor;
    _LedColorLine:TColor;
    _ColorBackGround:TColor;
    _Led:TState;
    _LedAlign:TAlign;
    _Circle:integer;
    _LedBorder:TBorder;
    _LedMargin:integer;
    _Border:TBorder;
    _Transparant:boolean;
    _BorderLine:TColor;
    _LedSpot:boolean;
    _LedSpotColorOn:TColor;
    _LedSpotColorOff:TColor;

    _BeforeChange:TBeforeChange;
    _AfterChange:TAfterChange;

    OnlyPaintLed:boolean;

    procedure SetColorBackGround(value:TColor);
    procedure SetColorLedOn(value:TColor);
    procedure SetColorLedOff(value:TColor);
    procedure SetLed(value:TState);
    procedure SetCircle(value:integer);
    procedure SetLedBorder(value:TBorder);
    procedure SetLedColorLine(value:TColor);
    procedure SetLedAlign(value:TAlign);
    procedure SetLedMargin(value:integer);
    procedure SetBorder(value:TBorder);
    procedure SetTransparant(value:boolean);
    procedure SetBorderLine(value:TColor);
    procedure SetCaptionAlign(value:TCAlign);
    procedure SetCaptionMargin(value:integer);
    procedure SetCaption(value:string);
    procedure SetCaptionBorder(value:TBorder);
    procedure SetCaptionLineColor(value:TColor);
    procedure SetCaptionBackground(value:TColor);
    procedure SetCaptionTransparant(value:boolean);
    procedure SetLedSpot(value:boolean);
    procedure SetLedSpotColorOn(value:TColor);
    procedure SetLedSpotColorOff(value:TColor);

    procedure CM_PARENTCOLORCHANGED(var Msg:TMessage); message cm_ParentColorChanged;

    procedure PaintBackGround;
    procedure PaintLed;
    procedure PaintText;
  protected
    procedure Paint; override;

    procedure DoBeforeChange(var AStatus:boolean); virtual;
    procedure DoAfterChange; virtual;
  public
    constructor Create(AOwner:TComponent); override;
  published
    property Caption:string read _Caption write SetCaption;
    property CaptionAlign:TCAlign read _CaptionAlign write SetCaptionAlign;
    property CaptionMargin:integer read _CaptionMargin write SetCaptionMargin default 2;
    property CaptionBorder:TBorder read _CaptionBorder write SetCaptionBorder;
    property CaptionLineColor:TColor read _CaptionLineColor write SetCaptionLineColor;
    property CaptionBackGround:TColor read _CaptionBackGround write SetCaptionBackground;
    property CaptionTransparant:boolean read _CaptionTransparant write SetCaptionTransparant default True;
    property LedOnColor:TColor read _ColorLedOn write SetColorLedOn;
    property LedOffColor:TColor read _ColorLedOff write SetColorLedOff;
    property ColorBackGround:TColor read _ColorBackGround write SetColorBackGround;
    property LedColorLine:TColor read _LedColorLine write SetLedColorLine;
    property LedState:TState read _Led write SetLed;
    property LedAlign:TAlign read _LedAlign write SetLedAlign;
    property LedCircle:integer read _Circle write SetCircle default 12;
    property LedBorder:TBorder read _LedBorder write SetLedBorder;
    property LedMargin:integer read _LedMargin write SetLedMargin default 5;
    property Border:TBorder read _Border write SetBorder;
    property Transparant:boolean read _Transparant write SetTransparant;
    property BorderLine:TColor read _BorderLine write SetBorderLine;
    property LedSpot:boolean read _LedSpot write SetLedSpot default True;
    property LedSpotColorOn:TColor read _LedSpotColorOn write SetLedSpotColorOn;
    property LedSpotColorOff:TColor read _LedSpotColorOff write SetLedSpotColorOff;

    property Visible;
    property ParentShowHint;
    property ShowHint;
    property Hint;
    property Font;
    property Tag;
    property Enabled;

    property OnBeforeChange:TBeforeChange read _BeforeChange write _BeforeChange;
    property OnAfterChange:TAfterChange read _AfterChange write _AfterChange;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
  end;

  procedure Register;

implementation

  constructor KrLed.Create(AOwner:TComponent);
  begin
    inherited Create(AOwner);
    _ColorLedOn:=clBlue;
    _ColorLedOff:=clNavy;
    _LedColorLine:=clBlack;
    _ColorBackGround:=clSilver;
    _Led:=stOn;
    _Circle:=12;
    _LedBorder:=ol3dDown;
    _LedAlign:=alLeft;
    _LedMargin:=5;
    _Border:=olNone;
    _Transparant:=False;
    _BorderLine:=clBlack;
    _CaptionAlign:=caLeft;
    _CaptionMargin:=2;
    _CaptionBorder:=olNone;
    _CaptionLineColor:=clBlack;
    _CaptionBackGround:=clSilver;
    _CaptionTransparant:=True;
    _LedSpot:=True;
    _LedSpotColorOff:=clWhite;
    _LedSpotColorOn:=clWhite;
    OnlyPaintLed:=False;
  end;

  procedure KrLed.DoBeforeChange(var AStatus:boolean);
  begin
    if Assigned(_BeforeChange) then _BeforeChange(Self, AStatus);
  end;

  procedure KrLed.DoAfterChange;
  begin
    if Assigned(_AfterChange) then _AfterChange(Self);
  end;

  procedure KrLed.Paint;
  begin
    if OnlyPaintLed=False then begin
      PaintBackGround;
      PaintText;
    end;
    PaintLed;
  end;

  procedure KrLed.PaintText;
  var
    r:TRect;
    tHeight, tWidth:integer;
  begin
    Canvas.Font:=Font;
    with Canvas do begin
      tHeight:=TextHeight(_Caption);
      tWidth:=TextWidth(_Caption);

      case _LedAlign of
      alLeft: begin
          r.Left:=_LedMargin+_Circle+_CaptionMargin;
          r.Top:=1;
          r.Right:=Width-1;
          r.Bottom:=Height-1;
        end;
      alRight: begin
          r.Left:=1;
          r.Top:=1;
          r.Right:=Width-_LedMargin-_Circle-_CaptionMargin;
          r.Bottom:=Height-1;
        end;
      alCenter: begin
          r.Left:=1;
          r.Top:=1;
          r.Right:=Width-1;
          r.Bottom:=Height-1;
        end;
      alTop: begin
          r.Left:=1;
          r.Top:=_LedMargin+_Circle+_CaptionMargin;
          r.Right:=Width-1;
          r.Bottom:=Height-1;
        end;
      alBottom: begin
          r.Left:=1;
          r.Top:=1;
          r.Right:=Width-1;
          r.Bottom:=Height-_LedMargin-_Circle-_CaptionMargin;
        end;
      end;

      if _CaptionTransparant=True then begin
        if _Transparant=True then
            Brush.Color:=TWincontrol(Parent).Brush.Color
          else
            Brush.Color:=_ColorBackGround
      end else
        Brush.Color:=_CaptionBackGround;

      case _CaptionBorder of
      olNone: begin
          if _CaptionTransparant=True then begin
            if _Transparant=True then
              Pen.Color:=TWincontrol(Parent).Brush.Color
            else
              Pen.Color:=_ColorBackGround
          end else
            Pen.Color:=_CaptionBackGround;
        end;
      olLine: begin
          Pen.Color:=_CaptionLineColor;
        end;
      end;
      Rectangle(r.Left, r.Top, r.Right, r.Bottom);

      case _CaptionBorder of
      ol3dUp: begin
          Pen.Color:=clWhite;
          MoveTo(r.Left, r.Bottom);
          LineTo(r.Left,r.Top);
          LineTo(r.Right, r.Top);
          Pen.Color:=clGray;
          LineTo(r.Right, r.Bottom);
          LineTo(r.Left, r.Bottom);
        end;
      ol3dDown: begin
          Pen.Color:=clGray;
          MoveTo(r.Left, r.Bottom);
          LineTo(r.Left,r.Top);
          LineTo(r.Right, r.Top);
          Pen.Color:=clWhite;
          LineTo(r.Right, r.Bottom);
          LineTo(r.Left, r.Bottom);
        end;
      end;

      inc(r.Left);
      inc(r.Top);
      dec(r.right);
      dec(r.Bottom);
      case _CaptionAlign of
      caLeft:   TextRect(r, r.Left+1, (r.Top+r.Bottom) div 2 - tHeight div 2, _Caption);
      caCenter: TextRect(r, (r.Left+r.Right) div 2 - tWidth div 2, (r.Top+r.Bottom) div 2 - tHeight div 2, _Caption);
      caRight:  TextRect(r, r.Right-tWidth-1, (r.Top+r.Bottom) div 2- theight div 2, _Caption);
      caTop:    TextRect(r, (r.Left+r.Right) div 2 - tWidth div 2, r.Top+1, _Caption);
      caBottom: TextRect(r, (r.Left+r.Right) div 2 - tWidth div 2, r.Bottom-tHeight-1, _Caption);
      end;
    end;
  end;

  procedure KrLed.PaintBackGround;
  begin
    with canvas do begin
      if _Transparant=True then begin
        Brush.Color:=TWincontrol(Parent).Brush.Color;
        Pen.Color:=TWincontrol(Parent).Brush.Color
      end else begin
        Brush.Color:=_ColorBackGround;
        Pen.Color:=_ColorBackGround;
      end;

      if _Border=olLine then Pen.Color:=BorderLine;
      Rectangle(0, 0, Width, Height);

      case _Border of
      ol3dUp: begin
          Pen.Color:=clWhite;
          MoveTo(0, Height-1);
          LineTo(0,0);
          LineTo(Width-1, 0);
          Pen.Color:=clGray;
          LineTo(Width-1, Height-1);
          LineTo(0, Height-1);
        end;
      ol3dDown: begin
          Pen.Color:=clGray;
          MoveTo(0, Height-1);
          LineTo(0,0);
          LineTo(Width-1, 0);
          Pen.Color:=clWhite;
          LineTo(Width-1, Height-1);
          LineTo(0, Height-1);
        end;
      end;
    end;
  end;

  procedure KrLed.PaintLed;
  var
    t, l, r, b:integer;
    t1, l1, r1, b1:integer;
  begin
    t:=0;
    l:=0;
    r:=0;
    b:=0;
    case _LedAlign of
    alLeft: begin
        l:=_LedMargin;
        t:=(Height div 2)-(_Circle div 2);
        r:=_Circle+_LedMargin;
        b:=t+_Circle;
      end;
    alTop: begin
        l:=(Width div 2)-(_Circle div 2);
        t:=_LedMargin;
        r:=l+_Circle;
        b:=_Circle+_LedMargin;
      end;
    alRight: begin
        l:=Width-_Circle-_LedMargin;
        t:=(Height div 2)-(_Circle div 2);
        r:=Width-_LedMargin;
        b:=t+_Circle;
      end;
    alBottom: begin
        l:=(Width div 2)-(_Circle div 2);
        t:=Height-_Circle-_LedMargin;
        r:=l+_Circle;
        b:=Height-_LedMargin;
      end;
    alCenter: begin
        l:=(Width div 2)-(_Circle div 2);
        t:=(Height div 2)-(_Circle div 2);
        r:=l+_Circle;
        b:=t+_Circle;
      end;
    end;

    with Canvas do begin
      if _led=stOn then begin
        Brush.Color:=_ColorLedOn;
        case _LedBorder of
        olNone:    Pen.Color:=_ColorLedOn;
        ol3dUp:    Pen.Color:=clWhite;
        ol3dDown:  Pen.Color:=clGray;
        olLine:    Pen.Color:=_LedColorLine;
        end;
      end else begin
        Brush.Color:=_ColorLedOff;
        case _LedBorder of
        olNone:    Pen.Color:=_ColorLedOff;
        ol3dUp:    Pen.Color:=clWhite;
        ol3dDown:  Pen.Color:=clGray;
        olLine:    Pen.Color:=_LedColorLine;
        end;
      end;
      Ellipse(l, t, r, b);

      case _LedBorder of
      ol3dUp: begin
          Pen.Color:=clGray;
          Arc(l, t, r, b, l, t+(_Circle+5) div 2, l+_Circle, t+(_Circle-5) div 2);
        end;
      ol3dDown: begin
          Pen.Color:=clWhite;
          Arc(l, t, r, b, l, t+(_Circle+5) div 2, l+_Circle, t+(_Circle-5) div 2);
        end;
      end;

      if _LedSpot=True then begin
        if _Led=stOn then begin
          Brush.Color:=_LedSpotColorOn;
          Pen.Color:=_LedSpotColorOn;
        end else begin
          Brush.Color:=_LedSpotColorOff;
          Pen.Color:=_LedSpotColorOff;
        end;
        l1:=l+_Circle div 5;
        t1:=t+_Circle div 4;
        r1:=l+_Circle div 2;
        b1:=t+_Circle div 2;
        Ellipse(l1, t1, r1, b1);
        l1:=l+_Circle div 4;
        t1:=t+_Circle div 5;
        r1:=l+_Circle div 2;
        b1:=t+_Circle div 2;
        Ellipse(l1, t1, r1, b1);
      end;
    end;
  end;

  procedure KrLed.CM_PARENTCOLORCHANGED(var msg:TMessage);
  begin
    if _Transparant=True then _Transparant:=True;
    inherited;
  end;

  procedure KrLed.SetTransparant(value:boolean);
  begin
    _Transparant:=value;
    Paint;
  end;

  procedure KrLed.SetCaptionAlign(value:TCALign);
  begin
    if CaptionAlign=value then exit;
    _CaptionAlign:=value;
    Paint;
  end;

  procedure KrLed.SetCaptionBorder(value:TBorder);
  begin
    if CaptionBorder=value then exit;
    _CaptionBorder:=value;
    Paint;
  end;

  procedure KrLed.SetCaptionLineColor(value:TColor);
  begin
    if CaptionLineColor=value then exit;
    _CaptionLineColor:=value;
    Paint;
  end;

  procedure KrLed.SetCaptionBackGround(value:TColor);
  begin
    if CaptionBackGround=value then exit;
    _CaptionBackGround:=value;
    Paint;
  end;

  procedure KrLed.SetLedSpot(value:boolean);
  begin
    if LedSpot=value then exit;
    _LedSpot:=value;
    Paint;
  end;

  procedure KrLed.SetLedSpotColorOn(value:TColor);
  begin
    if LedSpotColorOn=value then exit;
    _LedSpotColorOn:=value;
    Paint;
  end;

  procedure KrLed.SetLedSpotColorOff(value:TColor);
  begin
    if LedSpotColorOff=value then exit;
    _LedSpotColorOff:=value;
    Paint;
  end;

  procedure KrLed.SetCaptionTransparant(value:boolean);
  begin
    if CaptionTransparant=value then exit;
    _CaptionTransparant:=value;
    Paint;
  end;

  procedure KrLed.SetBorder(value:TBorder);
  begin
    if Border=value then exit;
    _Border:=value;
    Paint;
  end;

  procedure KrLed.SetCaptionMargin(value:integer);
  begin
    if CaptionMargin=value then exit;
    _CaptionMargin:=value;
    Paint;
  end;

  procedure KrLed.SetCaption(value:string);
  begin
    if Caption=value then exit;
    _Caption:=value;
    Paint;
  end;

  procedure KrLed.SetBorderLine(value:TColor);
  begin
    if BorderLine=value then exit;
    _BorderLine:=value;
    Paint;
  end;

  procedure KrLed.SetLedAlign(value:TAlign);
  begin
    if LedAlign=value then exit;
    _LedAlign:=value;
    Paint;
  end;

  procedure KrLed.SetLedBorder(value:TBorder);
  begin;
    if LedBorder=value then exit;
    _LedBorder:=value;
    Paint;
  end;

  procedure KrLed.SetLedMargin(value:integer);
  begin
    if LedMargin=value then exit;
    _LedMargin:=value;
    Paint;
  end;

  procedure KrLed.SetLedColorLine(value:TColor);
  begin
    if LedColorLine=value then exit;
    _LedColorLine:=value;
    Paint;
  end;

  procedure KrLed.SetColorBackGround(value:TColor);
  begin
    if ColorBackGround=value then exit;
    _ColorBackGround:=value;
    Paint;
  end;

  procedure KrLed.SetColorLedOn(value:TColor);
  begin
    if LedOnColor=value then exit;
    _ColorLedOn:=Value;
    Paint;
  end;

  procedure KrLed.SetColorLedOff(value:TColor);
  begin
    if LedOffColor=value then exit;
    _ColorLedOff:=Value;
    Paint;
  end;

  procedure KrLed.SetLed(value:TState);
  var
    b:boolean;
  begin
    if LedState=value then exit;
    b:=True;
    DoBeforeChange(b);
    if b=False then exit;
    _Led:=value;
    OnlyPaintLed:=True;
    Paint;
    OnlyPaintLed:=False;
    DoAfterChange;
  end;

  procedure KrLed.SetCircle(value:integer);
  begin
    if LedCircle=value then exit;
    _Circle:=value;
    Paint;
  end;

  procedure Register;
  begin
    RegisterComponents('MHS', [KrLed]);
  end;


end.
