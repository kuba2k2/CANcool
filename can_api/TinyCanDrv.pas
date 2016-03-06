{ *********** TINY - CAN Treiber **************                          }
{ Copyright (C) 2009 - 2015 Klaus Demlehner (klaus@mhs-elektronik.de)    }
{     www.mhs-elektronik.de                                              }
{                                                                        }
{ This program is free software; you can redistribute it and/or modify   }
{ it under the terms of the GNU General Public License as published by   }
{ the Free Software Foundation; either version 2 of the License, or      }
{ (at your option) any later version.                                    }
{                                                                        }
{ This program is distributed in the hope that it will be useful,        }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of         }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          }
{ GNU General Public License for more details.                           }
{                                                                        }
{ You should have received a copy of the GNU General Public License      }
{ along with this program; if not, write to the Free Software            }
{ Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.              }

unit TinyCanDrv;

interface

{$WARN SYMBOL_DEPRECATED OFF}
{$IFNDEF VER140}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

uses
  Windows, SysUtils, Messages, Classes, ComCtrls, Forms, Controls, Registry;

const
  CM_CAN_PNP_EVENT = WM_USER + 100;
  CM_CAN_STATUS_EVENT = WM_USER + 101;
  CM_CAN_RXD_EVENT = WM_USER + 102;

  FlagsCanLength: DWORD = ($0000000F);
  FlagsCanTxD: DWORD    = ($00000010);
  FlagsCanError: DWORD  = ($00000020);
  FlagsCanRTR: DWORD    = ($00000040);
  FlagsCanEFF: DWORD    = ($00000080);
  FlagsCanSource: DWORD = ($0000FF00); // Quelle der Nachricht (Device)
  FlagsCanFilHit: DWORD = ($00010000); // FilHit -> 1 = Filter Hit

  FilFlagsEFF: DWORD    = ($00000080);
  FilFlagsEnable: DWORD = ($80000000);

  INDEX_FIFO_PUFFER_MASK: DWORD = ($0000FFFF);
  INDEX_SOFT_FLAG: DWORD        = ($02000000);
  INDEX_RXD_TXT_FLAG: DWORD     = ($01000000);
  INDEX_CAN_KANAL_MASK: DWORD   = ($000F0000);
  INDEX_CAN_DEVICE_MASK: DWORD  = ($00F00000);

  INDEX_CAN_KANAL_A: DWORD      = ($00000000);
  INDEX_CAN_KANAL_B: DWORD      = ($00010000);

  CAN_CMD_NONE: Word              = ($0000);
  CAN_CMD_RXD_OVERRUN_CLEAR: Word = ($0001);
  CAN_CMD_RXD_FIFOS_CLEAR: Word   = ($0002);
  CAN_CMD_TXD_OVERRUN_CLEAR: Word = ($0004);
  CAN_CMD_TXD_FIFOS_CLEAR: Word   = ($0008);
  CAN_CMD_HW_FILTER_CLEAR: Word   = ($0010);
  CAN_CMD_SW_FILTER_CLEAR: Word   = ($0020);
  CAN_CMD_TXD_PUFFERS_CLEAR: Word = ($0040);

  CAN_CMD_ALL_CLEAR: Word         = ($0FFF);

  // SetEvent
  EVENT_ENABLE_PNP_CHANGE: Word          = ($0001);
  EVENT_ENABLE_STATUS_CHANGE: Word       = ($0002);
  EVENT_ENABLE_RX_FILTER_MESSAGES: Word  = ($0004);
  EVENT_ENABLE_RX_MESSAGES: Word         = ($0008);
  EVENT_ENABLE_ALL: Word                 = ($00FF);

  EVENT_DISABLE_PNP_CHANGE: Word         = ($0100);
  EVENT_DISABLE_STATUS_CHANGE: Word      = ($0200);
  EVENT_DISABLE_RX_FILTER_MESSAGES: Word = ($0400);
  EVENT_DISABLE_RX_MESSAGES: Word        = ($0800);
  EVENT_DISABLE_ALL: Word                = ($FF00);

  MHS_EVENT_TERMINATE: DWORD             = ($80000000);

  {#define DEV_LIST_SHOW_TCAN_ONLY 0x01
  #define DEV_LIST_SHOW_UNCONNECT 0x02

  #define CAN_FEATURE_LOM          0x0001  // Silent Mode (LOM = Listen only Mode)
  #define CAN_FEATURE_ARD          0x0002  // Automatic Retransmission disable
  #define CAN_FEATURE_TX_ACK       0x0004  // TX ACK (Gesendete Nachrichten bestätigen)
  #define CAN_FEATURE_HW_TIMESTAMP 0x8000  // Hardware Time Stamp}
  
  CanSpeedTab: array[0..8] of Word = (10,    // 10 kBit/s
                                      20,    // 20 kBit/s
                                      50,    // 50 kBit/s
                                      100,   // 100 kBit/s
                                      125,   // 125 kBit/s
                                      250,   // 250 kBit/s
                                      500,   // 500 kBit/s
                                      800,   // 800 kBit/s
                                      1000); // 1 MBit/s

   BaudRateTab: array[0..18] of DWord = (0,
                                         4800,
                                         9600,
                                         10400,
                                         14400,
                                         19200,
                                         28800,
                                         38400,
                                         57600,
                                         115200,
                                         125000,
                                         153600,
                                         230400,
                                         250000,
                                         460800,
                                         500000,
                                         921600,
                                         1000000,
                                         3000000);                                      

  API_DRIVER_DLL: String = 'mhstcan.dll';
  REG_TINY_CAN_API: String = 'Software\Tiny-CAN\API\';
  REG_TINY_CAN_API_PATH_ENTRY: String = 'PATH';
  
// EX-API Konstanten
// (V)alue (T)ype
MhsValueTypeTab: array[0..23] of DWord = ($01,  // VT_BYTE
                                          $02,  // VT_UBYTE      
                                          $03,  // VT_WORD       
                                          $04,  // VT_UWORD      
                                          $05,  // VT_LONG       
                                          $06,  // VT_ULONG      
                                          $07,  // VT_BYTE_ARRAY 
                                          $08,  // VT_UBYTE_ARRAY
                                          $09,  // VT_WORD_ARRAY 
                                          $0A,  // VT_UWORD_ARRAY
                                          $0B,  // VT_LONG_ARRAY
                                          $0C,  // VT_ULONG_ARRAY
                                          $0D,  // VT_BYTE_RANGE_ARRAY 
                                          $0E,  // VT_UBYTE_RANGE_ARRAY
                                          $0F,  // VT_WORD_RANGE_ARRAY 
                                          $10,  // VT_UWORD_RANGE_ARRAY
                                          $11,  // VT_LONG_RANGE_ARRAY 
                                          $12,  // VT_ULONG_RANGE_ARRAY
                                          $40,  // VT_HBYTE  
                                          $41,  // VT_HWORD  
                                          $42,  // VT_HLONG  
                                          $80,  // VT_STREAM 
                                          $81,  // VT_STRING 
                                          $82); // VT_POINTER

type
EDllLoadError = class(Exception);

// CAN Übertragungsgeschwindigkeit
TCanSpeed = (CAN_10K_BIT, CAN_20K_BIT, CAN_50K_BIT, CAN_100K_BIT, CAN_125K_BIT,
             CAN_250K_BIT, CAN_500K_BIT, CAN_800K_BIT, CAN_1M_BIT);

TSerialBaudRate = (SER_AUTO_BAUD, SER_4800_BAUD, SER_9600_BAUD, SER_10k4_BAUD, 
                   SER_14k4_BAUD, SER_19k2_BAUD, SER_28k8_BAUD, SER_38k4_BAUD,
                   SER_57k6_BAUD, SER_115k2_BAUD, SER_125k_BAUD, SER_153k6_BAUD,
                   SER_230k4_BAUD, SER_250k_BAUD, SER_460k8_BAUD, SER_500k_BAUD,
                   SER_921k6_BAUD, SER_1M_BAUD, SER_3M_BAUD);

TEventMask = (PNP_CHANGE_EVENT, STATUS_CHANGE_EVENT, RX_FILTER_MESSAGES_EVENT,
              RX_MESSAGES_EVENT);
TEventMasks = set of TEventMask;
TInterfaceType = (INTERFACE_USB, INTERFACE_SERIEL);
TLogFlag = (LOG_F0, LOG_F1, LOG_F2, LOG_F3, LOG_F4, LOG_F5, LOG_F6, LOG_F7);
TLogFlags = set of TLogFlag;


// CAN Bus Mode
TCanMode = (OP_CAN_NONE,              // 0 = keine Änderung
            OP_CAN_START,             // 1 = Startet den CAN Bus
            OP_CAN_STOP,              // 2 = Stopt den CAN Bus
            OP_CAN_RESET,             // 3 = Reset CAN Controller
            OP_CAN_START_LOM,         // 4 = Startet den CAN-Bus im Silent Mode (Listen Only Mode)
            OP_CAN_START_NO_RETRANS); // 5 = Startet den CAN-Bus im Automatic Retransmission disable Mode
PCanMode = ^TCanMode;

// DrvStatus
TDrvStatus = (DRV_NOT_LOAD,             // 0 = Die Treiber DLL wurde noch nicht geladen
              DRV_STATUS_NOT_INIT,      // 1 = Treiber noch nicht Initialisiert
              DRV_STATUS_INIT,          // 2 = Treiber erfolgrich Initialisiert
              DRV_STATUS_PORT_NOT_OPEN, // 3 = Die Schnittstelle wurde geöffnet
              DRV_STATUS_PORT_OPEN,     // 4 = Die Schnittstelle wurde nicht geöffnet
              DRV_STATUS_DEVICE_FOUND,  // 5 = Verbindung zur Hardware wurde Hergestellt
              DRV_STATUS_CAN_OPEN,      // 6 = Device wurde geöffnet und erfolgreich Initialisiert
              DRV_STATUS_CAN_RUN_TX,    // 7 = CAN Bus RUN nur Transmitter (wird nicht verwendet !)
              DRV_STATUS_CAN_RUN);      // 8 = CAN Bus RUN
PDrvStatus = ^TDrvStatus;

// CanStatus
TCanStatus = (CAN_STATUS_OK,            // 0 = CAN-Controller: Ok
              CAN_STATUS_ERROR,         // 1 = CAN-Controller: CAN Error
              CAN_STATUS_WARNING,       // 2 = CAN-Controller: Error warning
              CAN_STATUS_PASSIV,        // 3 = CAN-Controller: Error passiv
              CAN_STATUS_BUS_OFF,       // 4 = CAN-Controller: Bus Off
              CAN_STATUS_UNBEKANNT);    // 5 = CAN-Controller: Status Unbekannt
PCanStatus = ^TCanStatus;

// Fifo Status
TCanFifoStatus = (CAN_FIFO_OK,                // 0 = Fifo-Status: Ok
                  CAN_FIFO_HW_OVERRUN,        // 1 = Fifo-Status: Überlauf
                  CAN_FIFO_SW_OVERRUN,        // 2 = Fifo-Status: Überlauf
                  CAN_FIFO_HW_SW_OVERRUN,     // 3 = Fifo-Status: Überlauf
                  CAN_FIFO_STATUS_UNBEKANNT); // 4 = Fifo-Status: Unbekannt
PCanFifoStatus = ^TCanFifoStatus;

// EX-API Typen definitionen
// (V)alue (T)ype
TMhsValueType = (VT_BYTE, VT_UBYTE, VT_WORD, VT_UWORD, VT_LONG, VT_ULONG, VT_BYTE_ARRAY,
                 VT_UBYTE_ARRAY, VT_WORD_ARRAY, VT_UWORD_ARRAY, VT_LONG_ARRAY, VT_ULONG_ARRAY,
                 VT_BYTE_RANGE_ARRAY, VT_UBYTE_RANGE_ARRAY, VT_WORD_RANGE_ARRAY,
                 VT_UWORD_RANGE_ARRAY, VT_LONG_RANGE_ARRAY, VT_ULONG_RANGE_ARRAY, VT_HBYTE,
                 VT_HWORD, VT_HLONG, VT_STREAM, VT_STRING, VT_POINTER);

{/******************************************/}
{/*            CAN Message Type            */}
{/******************************************/}
TCanData = packed record
  case Integer of
    0: (Chars: array[0..7] of Char);
    1: (Bytes: array[0..7] of Byte);
    2: (Words: array[0..3] of Word);
    3: (Longs: array[0..1] of DWORD);
  end;
PCanData = ^TCanData;

TCanTime = packed record
  Sec: DWORD;
  USec: DWORD;
  end;
PCanTime = ^TCanTime;

TCanMsg = packed record
  Id: DWORD;
  Flags: DWORD;
  Data: TCanData;
  Time: TCanTime;
  end;
 PCanMsg = ^TCanMsg;

{/******************************************/}
{/*         CAN Message Filter Type        */}
{/******************************************/}
TMsgFilter = packed record
  Maske: DWORD;
  Code: DWORD;
  Flags: DWORD;
  Data: TCanData;
  end;
PMsgFilter = ^TMsgFilter;


{/******************************************/}
{/*             Device Status              */}
{/******************************************/}
TDeviceStatus = record
  DrvStatus: TDrvStatus;
  CanStatus: TCanStatus;
  FifoStatus: TCanFifoStatus;
  BusFailure: boolean;
  end;
PDeviceStatus = ^TDeviceStatus;


TDeviceStatusDrv = packed record
  DrvStatus: Integer;
  CanStatus: Byte;
  FifoStatus: Byte;
  end;
PDeviceStatusDrv = ^TDeviceStatusDrv;

// EX-API
TModulFeatures = packed record
  CanClock: DWORD;           // Clock-Frequenz des CAN-Controllers, muss nicht mit
                             // der Clock-Frequenz des Mikrocontrollers übereinstimmen
  Flags: DWORD;              // Unterstützte Features des Moduls:
                             //  Bit  0 -> Silent Mode (LOM = Listen only Mode)
                             //       1 -> Automatic Retransmission disable
                             //       2 -> TX ACK (Gesendete Nachrichten bestätigen)
                             //      15 -> Hardware Time Stamp
  CanChannelsCount: DWORD;   // Anzahl der CAN Schnittstellen, reserviert für
                             // zukünftige Module mit mehr als einer Schnittstelle
  HwRxFilterCount: DWORD;    // Anzahl der zur Verfügung stehenden Receive-Filter
  HwTxPufferCount: DWORD;    // Anzahl der zur Verfügung stehenden Transmit Puffer mit Timer
  end;

TCanDevicesList = packed record
  TCanIdx: DWORD;                     // Ist das Device geöffnet ist der Wert auf dem Device-Index
                                      // gesetzt, ansonsten ist der Wert auf "INDEX_INVALID" gesetzt.
  HwId: DWORD;                        // Ein 32 Bit Schlüssel der die Hardware eindeutig Identifiziert.
                                      // Manche Module müssen erst geöffnet werden damit dieser Wert
                                      // gesetzt wird
  DeviceName: array[0..254] of Char;  // Nur Linux: entspricht den Device Namen des USB-Devices,
                                      //            z.B. /dev/ttyUSB0
  SerialNumber: array[0..15] of Char; // Seriennummer des Moduls
  Description: array[0..63] of Char;  // Modul Bezeichnung, z.B. "Tiny-CAN IV-XL",
                                      // muss in den USB-Controller programmiert sein,
                                      // was zur Zeit nur bei den Modulen Tiny-CAN II-XL,
                                      // IV-XL u. M1 der Fall ist.
  ModulFeatures: TModulFeatures;      // Unterstützte Features des Moduls, nur gültig
                                      // wenn HwId > 0
  end;
PCanDevicesList = ^TCanDevicesList; 

TCanDeviceInfo = packed record
  HwId: DWORD;                        // Ein 32 Bit Schlüssel der die Hardware eindeutig Identifiziert.
  FirmwareVersion: DWORD;             // Version der Firmware des Tiny-CAN Moduls
  FirmwareInfo: DWORD;                // Informationen zum Stand der Firmware Version
                                      //   0 = Unbekannt
                                      //   1 = Firmware veraltet, Device kann nicht geöffnet werden
                                      //   2 = Firmware veraltet, Funktionsumfang eingeschränkt
                                      //   3 = Firmware veraltet, keine Einschränkungen
                                      //   4 = Firmware auf Stand
                                      //   5 = Firmware neuer als Erwartet
  SerialNumber: array[0..15] of Char; // Seriennummer des Moduls
  Description: array[0..63] of Char;  // Modul Bezeichnung, z.B. "Tiny-CAN IV-XL"
  ModulFeatures: TModulFeatures;      // Unterstützte Features des Moduls
  end;
PCanDeviceInfo = ^TCanDeviceInfo;

TCanInfoVar = packed record   
  Key: DWORD;                  // Variablen Schlüssel
  ValueType: DWORD;            // Variablen Type
  Size: DWORD;                 // (Max)Größe der Variable in Byte
  Data: array[0..254] of Char; // Wert der Variable
  end;
PCanInfoVar = ^TCanInfoVar;

{/***************************************************************/}
{/*  Treiber Callback-Funktionen                                */}
{/***************************************************************/}
TF_CanPnPEventCallback = procedure(index: DWORD; status: Integer); stdcall;
PF_CanPnPEventCallback = ^TF_CanPnPEventCallback;

TF_CanStatusEventCallback = procedure(index: DWORD; device_status_drv: PDeviceStatusDrv); stdcall;
PF_CanStatusEventCallback = ^TF_CanStatusEventCallback;

TF_CanRxEventCallback = procedure(index: DWORD; msg: PCanMsg; count: Integer); stdcall;
PF_CanRxEventCallback = ^TF_CanRxEventCallback;

{/***************************************************************/}
{/*  Funktionstypen                                             */}
{/***************************************************************/}
TF_CanInitDriver = function(options: PAnsiChar): Integer; stdcall;
TF_CanDownDriver = procedure; stdcall;
TF_CanSetOptions = function(options: PAnsiChar): Integer; stdcall;
TF_CanDeviceOpen = function(index: DWORD; parameter: PAnsiChar): Integer; stdcall;
TF_CanDeviceClose = function(index: DWORD): Integer; stdcall;
TF_CanSetMode = function(index: DWORD; can_op_mode: Byte; can_command: Word): Integer; stdcall;

TF_CanTransmit = function(index: DWORD; msg: PCanMsg; count: Integer): Integer; stdcall;
TF_CanTransmitClear = procedure(index: DWORD); stdcall;
TF_CanTransmitGetCount = function(index: DWORD): DWORD; stdcall;
TF_CanTransmitSet = function(index: DWORD; cmd: Word; time: DWORD): Integer; stdcall;
TF_CanReceive = function(index: DWORD; msg: PCanMsg; count: Integer): Integer; stdcall;
TF_CanReceiveClear = procedure(index: DWORD); stdcall;
TF_CanReceiveGetCount = function(index: DWORD): DWORD; stdcall;

TF_CanSetSpeed = function(index: DWORD; speed: Word): Integer; stdcall;
TF_CanDrvInfo = function: PAnsiChar; stdcall;
TF_CanDrvHwInfo = function(index: DWORD): PAnsiChar; stdcall;
TF_CanSetFilter = function(index: DWORD; msg_filter: PMsgFilter): Integer; stdcall;

TF_CanGetDeviceStatus = function(index: DWORD; status: PDeviceStatusDrv): Integer; stdcall;

TF_CanSetPnPEventCallback = procedure(event_proc: PF_CanPnPEventCallback); stdcall;
TF_CanSetStatusEventCallback = procedure(event_proc: PF_CanStatusEventCallback); stdcall;
TF_CanSetRxEventCallback = procedure(event_proc: PF_CanRxEventCallback); stdcall;

TF_CanSetEvents = procedure(events: Word); stdcall;
TF_CanEventStatus = function:DWORD; stdcall;

// EX-API
TF_CanExGetDeviceCount = function(flags: Integer): Integer; stdcall;
//int32_t CanExGetDeviceList(struct TCanDevicesList **devices_list, int32_t flags);
TF_CanExGetDeviceListPerform = function(flags: Integer): Integer; stdcall;
TF_CanExGetDeviceListGet = function(item: PCanDevicesList): Integer; stdcall;
//int32_t CanExGetDeviceInfo(uint32_t index, struct TCanDeviceInfo *device_info, struct TCanInfoVar **hw_info, uint32_t *hw_info_size);
TF_CanExGetDeviceInfoPerform = function(index: DWORD; device_info: PCanDeviceInfo): Integer; stdcall;
TF_CanExGetDeviceInfoGet = function(item: PCanInfoVar): Integer; stdcall;

TF_CanExCreateDevice = function(index: PDWORD; options: PAnsiChar): Integer; stdcall;
TF_CanExDestroyDevice = function(index: PDWORD): Integer; stdcall;
TF_CanExCreateFifo = function(index: DWORD; size: DWORD; event_obj: Pointer; event: DWORD; channels: DWORD): Integer; stdcall;
TF_CanExBindFifo = function(fifo_index: DWORD; device_index: DWORD; bind: DWORD): Integer; stdcall;
TF_CanExCreateEvent = function: Pointer; stdcall;
TF_CanExSetObjEvent = function(index: DWORD; source: DWORD; event_obj: Pointer; event: DWORD): Integer; stdcall;
TF_CanExSetEvent = procedure(event_obj: Pointer; event: DWORD); stdcall;
TF_CanExSetEventAll = procedure(event: DWORD); stdcall;
TF_CanExResetEvent = procedure(event_obj: Pointer; event: DWORD); stdcall;
TF_CanExWaitForEvent = function(event_obj: Pointer; timeout: DWORD): DWORD; stdcall;

TF_CanExInitDriver = function(options: PAnsiChar): Integer; stdcall;
TF_CanExSetOptions = function(index: DWORD; char: PAnsiChar; options: PAnsiChar): Integer; stdcall;
TF_CanExSetAsByte = function(index: DWORD; name: PAnsiChar; value: shortint): Integer; stdcall;
TF_CanExSetAsWord = function(index: DWORD; name: PAnsiChar; value: smallint): Integer; stdcall;
TF_CanExSetAsLong = function(index: DWORD; name: PAnsiChar; value: Integer): Integer; stdcall;
TF_CanExSetAsUByte = function(index: DWORD; name: PAnsiChar; value: Byte): Integer; stdcall;
TF_CanExSetAsUWord = function(index: DWORD; name: PAnsiChar; value: WORD): Integer; stdcall;
TF_CanExSetAsULong = function(index: DWORD; name: PAnsiChar; value: DWORD): Integer; stdcall;
TF_CanExSetAsString = function(index: DWORD; name: PAnsiChar; value: PAnsiChar): Integer; stdcall;
TF_CanExGetAsByte = function(index: DWORD; name: PAnsiChar; value: PShortint): Integer; stdcall;
TF_CanExGetAsWord = function(index: DWORD; name: PAnsiChar; value: Psmallint): Integer; stdcall;
TF_CanExGetAsLong = function(index: DWORD; name: PAnsiChar; value: PInteger): Integer; stdcall;
TF_CanExGetAsUByte = function(index: DWORD; name: PAnsiChar; value: PByte): Integer; stdcall;
TF_CanExGetAsUWord = function(index: DWORD; name: PAnsiChar; value: PWORD): Integer; stdcall;
TF_CanExGetAsULong = function(index: DWORD; name: PAnsiChar; value: PDWORD): Integer; stdcall;
TF_CanExGetAsStringCopy = function(index: DWORD; name: PAnsiChar; dest: PAnsiChar; dest_size: PDWORD): Integer; stdcall;

TOnCanPnPEvent = procedure(Sender: TObject; index: DWORD; status: Integer) of Object;
TOnCanStatusEvent = procedure(Sender: TObject; index: DWORD; device_status: TDeviceStatus) of Object;
TOnCanRxDEvent = procedure(Sender: TObject; index: DWORD; msg: PCanMsg; count: Integer) of Object;

TTinyCAN = class(TComponent)
  private
    FExMode: Boolean;
    FTreiberName: String;
    FPort: Integer;
    FBaudRate: TSerialBaudRate;
    FCanSpeed: TCANSpeed;
    FEventMasks: TEventMasks;
    FInterfaceType: TInterfaceType;
    FPnPEnable: boolean;
    FAutoReOpen: boolean;
    FRxDFifoSize: Word;
    FTxDFifoSize: Word;
    FCanRxDBufferSize: Word;

    FDeviceSnr: String;
    FCfgFile: String;
    FLogFile: String;
    FLogFlags: TLogFlags;
    FInitParameterStr: String;
    FOptionsStr: String;
    FOpenStr: String;
    function CanInitDriver_Int(ex_mode: boolean): Integer;
    function GetLogFlags: DWORD;
    function TestApi(name: String): Boolean;
    function RegReadStringEntry(path, entry: String): String;
    function GetApiDriverWithPath(driver_file: String): String;
    procedure SetCanSpeed(speed: TCanSpeed);
    procedure SetEventMasks(value: TEventMasks);
    procedure WndProc(var msg : TMessage);
  public
    { Events}
    pmCanPnPEvent: TOnCanPnPEvent;
    pmCanStatusEvent: TOnCanStatusEvent;
    pmCanRxDEvent: TOnCanRxDEvent;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CanInitDriver: Integer;
    procedure CanDownDriver;
    function CanSetOptions: Integer;
    function CanDeviceOpen: Integer;
    function CanDeviceClose: Integer;
    function CanSetMode(index: DWORD; can_op_mode: TCanMode; can_command: Word): Integer;
    function CanTransmit(index: DWORD; msg: PCanMsg; count: Integer): Integer;
    procedure CanTransmitClear(index: DWORD);
    function CanTransmitGetCount(index: DWORD): DWORD;
    function CanTransmitSet(index: DWORD; cmd: Word; time: DWORD): Integer;
    function CanReceive(index: DWORD; msg: PCanMsg; count: Integer): Integer;
    procedure CanReceiveClear(index: DWORD);
    function CanReceiveGetCount(index: DWORD): DWORD;

    function CanSetSpeed(index: DWORD; speed: TCanSpeed): Integer;
    function CanDrvInfo: PAnsiChar;
    function CanDrvHwInfo(index: DWORD): PAnsiChar;
    function CanSetFilter(index: DWORD; msg_filter: PMsgFilter): Integer;

    function CanGetDeviceStatus(index: DWORD; status: PDeviceStatus): Integer;

    procedure CanSetPnPEventCallback(event_proc: PF_CanPnPEventCallback);
    procedure CanSetStatusEventCallback(event_proc: PF_CanStatusEventCallback);
    procedure CanSetRxEventCallback(event_proc: PF_CanRxEventCallback);

    procedure CanSetEvents(events: TEventMasks);
    function CanEventStatus: DWORD;
    // EX-API    
    function CanExGetDeviceCount(flags: Integer): Integer;
    function CanExGetDeviceListPerform(flags: Integer): Integer;
    function CanExGetDeviceListGet(item: PCanDevicesList): Integer;
    function CanExGetDeviceInfoPerform(index: DWORD; device_info: PCanDeviceInfo): Integer;
    function CanExGetDeviceInfoGet(item: PCanInfoVar): Integer;
    function CanExCreateDevice(var index: DWORD; options: String): Integer;
    function CanExDestroyDevice(var index: DWORD): Integer;
    function CanExCreateFifo(index: DWORD; size: DWORD; event_obj: Pointer; event: DWORD; channels: DWORD): Integer;
    function CanExBindFifo(fifo_index: DWORD; device_index: DWORD; bind: DWORD): Integer;
    function CanExCreateEvent:Pointer;
    function CanExSetObjEvent(index: DWORD; source: DWORD; event_obj: Pointer; event: DWORD): Integer;
    procedure CanExSetEvent(event_obj: Pointer; event: DWORD);
    procedure CanExSetEventAll(event: DWORD); 
    procedure CanExResetEvent(event_obj: Pointer; event: DWORD);
    function CanExWaitForEvent(event_obj: Pointer; timeout: DWORD): DWORD;
    
    function CanExInitDriver(options: PAnsiChar): Integer;
    function CanExSetOptions(index: DWORD; char: String; options: String): Integer;
    function CanExSetAsByte(index: DWORD; name: String; value: shortint): Integer;
    function CanExSetAsWord(index: DWORD; name: String; value: smallint): Integer;
    function CanExSetAsLong(index: DWORD; name: String; value: Integer): Integer;
    function CanExSetAsUByte(index: DWORD; name: String; value: Byte): Integer;
    function CanExSetAsUWord(index: DWORD; name: String; value: WORD): Integer;
    function CanExSetAsULong(index: DWORD; name: String; value: DWORD): Integer;
    function CanExSetAsString(index: DWORD; name: String; value: String): Integer;
    function CanExGetAsByte(index: DWORD; name: String; var value: shortint): Integer;
    function CanExGetAsWord(index: DWORD; name: String; var value: smallint): Integer;   
    function CanExGetAsLong(index: DWORD; name: String; var value: Integer): Integer;    
    function CanExGetAsUByte(index: DWORD; name: String; var value: Byte): Integer;      
    function CanExGetAsUWord(index: DWORD; name: String; var value: WORD): Integer;      
    function CanExGetAsULong(index: DWORD; name: String; var value: DWORD): Integer;     
    function CanExGetAsString(index: DWORD; name: String; var str: String): Integer;  
  
    function LoadDriver: Integer;
    procedure DownDriver;
  published
    { Published-Deklarationen }
    property ExMode: Boolean read FExMode write FExMode default FALSE;
    property TreiberName: String read FTreiberName write FTreiberName;
    property Port: Integer read FPort write FPort default 0;
    property BaudRate: TSerialBaudRate read FBaudRate write FBaudRate default SER_921k6_BAUD;
    property CanSpeed: TCanSpeed read FCanSpeed write SetCanSpeed default CAN_125K_BIT;
    property EventMasks: TEventMasks read FEventMasks write SetEventMasks default [];
    property InterfaceType: TInterfaceType read FInterfaceType write FInterfaceType default INTERFACE_USB;
    property PnPEnable: boolean read FPnPEnable write FPnPEnable default true;
    property AutoReOpen: boolean read FAutoReOpen write FAutoReOpen default true;
    property RxDFifoSize: Word read FRxDFifoSize write FRxDFifoSize default 4096;
    property TxDFifoSize: Word read FTxDFifoSize write FTxDFifoSize default 255;
    property CanRxDBufferSize: Word read FCanRxDBufferSize write FCanRxDBufferSize default 50;

    property DeviceSnr: String read FDeviceSnr write FDeviceSnr;
    property CfgFile: String read FCfgFile write FCfgFile;
    property LogFile: String read FLogFile write FLogFile;
    property LogFlags: TLogFlags read FLogFlags write FLogFlags default [];
    property InitParameterStr: String read FInitParameterStr write FInitParameterStr;
    property OptionsStr: String read FOptionsStr write FOptionsStr;
    property OpenStr: String read FOpenStr write FOpenStr;
    { Events }
    property OnCanPnPEvent: TOnCanPnPEvent read pmCanPnPEvent write pmCanPnPEvent;
    property OnCanStatusEvent: TOnCanStatusEvent read pmCanStatusEvent write pmCanStatusEvent;
    property OnCanRxDEvent: TOnCanRxDEvent read pmCanRxDEvent write pmCanRxDEvent;
  end;


procedure Register;
procedure CanPnPEventCallback(index: DWORD; status: Integer); stdcall;
procedure CanStatusEventCallback(index: DWORD; device_status_drv: PDeviceStatusDrv); stdcall;
procedure CanRxEventCallback(index: DWORD; msg: PCanMsg; count: Integer); stdcall;


implementation

var
  DrvDLLWnd: HWnd = 0;
  DrvRefCounter: Integer = 0;

  pmCanInitDriver: TF_CanInitDriver = nil;
  pmCanDownDriver: TF_CanDownDriver = nil;
  pmCanSetOptions: TF_CanSetOptions = nil;
  pmCanDeviceOpen: TF_CanDeviceOpen = nil;
  pmCanDeviceClose: TF_CanDeviceClose = nil;
  pmCanSetMode: TF_CanSetMode = nil;
  pmCanTransmit: TF_CanTransmit = nil;
  pmCanTransmitClear: TF_CanTransmitClear = nil;
  pmCanTransmitGetCount: TF_CanTransmitGetCount = nil;
  pmCanTransmitSet: TF_CanTransmitSet = nil;
  pmCanReceive: TF_CanReceive = nil;
  pmCanReceiveClear: TF_CanReceiveClear = nil;
  pmCanReceiveGetCount: TF_CanReceiveGetCount = nil;
  pmCanSetSpeed: TF_CanSetSpeed = nil;
  pmCanDrvInfo: TF_CanDrvInfo = nil;
  pmCanDrvHwInfo: TF_CanDrvHwInfo = nil;
  pmCanSetFilter: TF_CanSetFilter = nil;
  pmCanGetDeviceStatus: TF_CanGetDeviceStatus = nil;
  pmCanSetPnPEventCallback: TF_CanSetPnPEventCallback = nil;
  pmCanSetStatusEventCallback: TF_CanSetStatusEventCallback = nil;
  pmCanSetRxEventCallback: TF_CanSetRxEventCallback = nil;
  pmCanSetEvents: TF_CanSetEvents = nil;
  pmCanEventStatus: TF_CanEventStatus = nil;
  // EX-API
  pmCanExGetDeviceCount: TF_CanExGetDeviceCount = nil;
  pmCanExGetDeviceListPerform: TF_CanExGetDeviceListPerform = nil;
  pmCanExGetDeviceListGet: TF_CanExGetDeviceListGet = nil;
  pmCanExGetDeviceInfoPerform: TF_CanExGetDeviceInfoPerform = nil;
  pmCanExGetDeviceInfoGet: TF_CanExGetDeviceInfoGet = nil;
  pmCanExCreateDevice: TF_CanExCreateDevice = nil; 
  pmCanExDestroyDevice: TF_CanExDestroyDevice = nil;
  pmCanExCreateFifo: TF_CanExCreateFifo = nil;  
  pmCanExBindFifo: TF_CanExBindFifo = nil;
  pmCanExCreateEvent: TF_CanExCreateEvent = nil;
  pmCanExSetObjEvent: TF_CanExSetObjEvent = nil;
  pmCanExSetEvent: TF_CanExSetEvent = nil;
  pmCanExSetEventAll: TF_CanExSetEventAll = nil;
  pmCanExResetEvent: TF_CanExResetEvent = nil;
  pmCanExWaitForEvent: TF_CanExWaitForEvent = nil;
  pmCanExInitDriver: TF_CanExInitDriver = nil; 
  pmCanExSetOptions: TF_CanExSetOptions = nil; 
  pmCanExSetAsByte: TF_CanExSetAsByte = nil;
  pmCanExSetAsWord: TF_CanExSetAsWord = nil;
  pmCanExSetAsLong: TF_CanExSetAsLong = nil;
  pmCanExSetAsUByte: TF_CanExSetAsUByte = nil; 
  pmCanExSetAsUWord: TF_CanExSetAsUWord = nil;
  pmCanExSetAsULong: TF_CanExSetAsULong = nil; 
  pmCanExSetAsString: TF_CanExSetAsString = nil;
  pmCanExGetAsByte: TF_CanExGetAsByte = nil;
  pmCanExGetAsWord: TF_CanExGetAsWord = nil;
  pmCanExGetAsLong: TF_CanExGetAsLong = nil;
  pmCanExGetAsUByte: TF_CanExGetAsUByte = nil; 
  pmCanExGetAsUWord: TF_CanExGetAsUWord = nil; 
  pmCanExGetAsULong: TF_CanExGetAsULong = nil; 
  pmCanExGetAsStringCopy: TF_CanExGetAsStringCopy = nil;

  FIndex: DWORD;
  FPnPStatus: Integer;
  FDeviceStatus: TDeviceStatus;
  FRxDMsgs: PCanMsg;
  FRxDCount: Integer;
  FWindowHandle : HWND;


{**************************************************************}
{* Object erzeugen                                            *}
{**************************************************************}
constructor TTinyCAN.Create(AOwner: TComponent);

begin;
inherited Create(AOwner);
FWindowHandle := AllocateHWnd(WndProc);
FTreiberName := '';
FPort := 0;
FBaudRate := SER_921k6_BAUD;
FCanSpeed := CAN_125K_BIT;
FEventMasks := [];
FInterfaceType := INTERFACE_USB;
FPnPEnable := true;
FAutoReOpen := true;
FRxDFifoSize := 4096;
FTxDFifoSize := 255;
FCanRxDBufferSize := 50;

FDeviceSnr:='';
FCfgFile:='';
FLogFile:='';
FLogFlags:=[];
FInitParameterStr:='';
FOptionsStr:='';
FOpenStr:='';
end;


{**************************************************************}
{* Object löschen                                             *}
{**************************************************************}
destructor TTinyCAN.Destroy;

begin
DeAllocateHWnd(FWindowHandle);
inherited Destroy;
end;


{**************************************************************}
{* Treiber DLL suchen                                         *}
{**************************************************************}
function TTinyCAN.TestApi(name: String): Boolean;
var dll_wnd: HWnd;

begin;
result := False;
if length(name) > 0 then
  begin;
  dll_wnd := LoadLibrary(PChar(Name));
  if dll_wnd <> 0 then
    begin;
    if GetProcAddress(dll_wnd, 'CanDrvInfo') <> nil then
      result := True;
    FreeLibrary(dll_wnd);
    end;
  end;    
end;


function TTinyCAN.RegReadStringEntry(path, entry: String): String;
var R: TRegistry;

begin;
result := '';
{Registry Komponente erzeugen}
R := TRegistry.Create(KEY_READ);
R.RootKey := HKEY_LOCAL_MACHINE;
if R.OpenKey(path, False) then
  begin;
  result := R.ReadString(entry);
  end;
{Registry Komponente freigeben}
R.CloseKey;
R.Free;
end;


function TTinyCAN.GetApiDriverWithPath(driver_file: String): String;
var file_name: String;

begin;
result := '';
if driver_file = '' then
  driver_file := API_DRIVER_DLL
else
  begin;
  if ExtractFileExt(driver_file) = '' then
    driver_file := driver_file + '.dll';
  if ExtractFilePath(driver_file) <> '' then
    begin;
    result := driver_file;
    exit;
    end;
  end;  
file_name := RegReadStringEntry(REG_TINY_CAN_API, REG_TINY_CAN_API_PATH_ENTRY);
if length(file_name) > 0 then
  begin;
  file_name := file_name + '\' + driver_file;
  if TestApi(file_name) then
    result := file_name;
  end;
if length(result) = 0 then
  begin;
  file_name := ExtractFilePath(Application.ExeName) + driver_file;
  if TestApi(file_name) then
    result := file_name;
  end;
end;


{**************************************************************}
{* Message Handler                                            *}
{**************************************************************}
procedure TTinyCAN.WndProc(var msg : TMessage);

begin
with msg do
  begin;
  case Msg of
    CM_CAN_PNP_EVENT    : begin;
                          if Assigned(pmCanPnPEvent) then
                            pmCanPnPEvent(self, FIndex, FPnPStatus);
                          end;
    CM_CAN_STATUS_EVENT : begin;
                          if Assigned(pmCanStatusEvent) then
                            pmCanStatusEvent(self, FIndex, FDeviceStatus);
                          end;
    CM_CAN_RXD_EVENT    : begin;
                          if Assigned(pmCanRxDEvent) then
                            pmCanRxDEvent(self, FIndex, FRxDMsgs, FRxDCount);
                          end;
    else // Handle all messages with the default handler
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
    end;
  end;
end;


{**************************************************************}
{*  Events                                                    *}
{**************************************************************}
procedure CanPnPEventCallback(index: DWORD; status: Integer); stdcall;

begin;
InterlockedIncrement(DrvRefCounter);
FIndex := index;
FPnPStatus := status;
SendMessage(FWindowHandle, CM_CAN_PNP_EVENT, 0, 0);
InterlockedDecrement(DrvRefCounter);
end;


procedure CanStatusEventCallback(index: DWORD; device_status_drv: PDeviceStatusDrv); stdcall;
var can_status: Byte;

begin;
InterlockedIncrement(DrvRefCounter);
FIndex := index;
can_status := device_status_drv^.CanStatus;
FDeviceStatus.DrvStatus := TDrvStatus(device_status_drv^.DrvStatus);
FDeviceStatus.CanStatus := TCanStatus(can_status and $0F);
FDeviceStatus.FifoStatus := TCanFifoStatus(device_status_drv^.FifoStatus);
if (can_status and $10) = $10 then
  FDeviceStatus.BusFailure := TRUE
else
  FDeviceStatus.BusFailure := FALSE;
SendMessage(FWindowHandle, CM_CAN_STATUS_EVENT, 0, 0);
InterlockedDecrement(DrvRefCounter);
end;


procedure CanRxEventCallback(index: DWORD; msg: PCanMsg; count: Integer); stdcall;

begin;
InterlockedIncrement(DrvRefCounter);
FIndex := index;
FRxDMsgs := msg;
FRxDCount := count;
SendMessage(FWindowHandle, CM_CAN_RXD_EVENT, 0, 0);
InterlockedDecrement(DrvRefCounter);
end;


{**************************************************************}
{* Property Set Funktionen                                    *}
{**************************************************************}
procedure TTinyCAN.SetCanSpeed(speed: TCanSpeed);

begin;
if speed <> FCanSpeed then
  begin;
  FCanSpeed := speed;
  if not (csDesigning in ComponentState) then
    CanSetSpeed(0, speed);
  end;
end;


procedure TTinyCAN.SetEventMasks(value: TEventMasks);

begin;
if value <> FEventMasks then
  begin;
  FEventMasks := value;
  if not (csDesigning in ComponentState) then
    CanSetEvents(FEventMasks);
  end;
end;


function TTinyCan.GetLogFlags: DWORD;

begin
result := 0;
if LOG_F0 in FLogFlags then
  result := result or $01;
if LOG_F1 in FLogFlags then
  result := result or $02;
if LOG_F2 in FLogFlags then
  result := result or $04;
if LOG_F3 in FLogFlags then
  result := result or $08;
if LOG_F4 in FLogFlags then
  result := result or $10;
if LOG_F5 in FLogFlags then
  result := result or $20;
if LOG_F6 in FLogFlags then
  result := result or $40;
if LOG_F7 in FLogFlags then
  result := result or $80;
end;


{**************************************************************}
{* Treiber Funktionen                                         *}
{**************************************************************}
function TTinyCAN.CanInitDriver_Int(ex_mode: boolean): Integer;
var Str: String;

begin;
result := -1;
if FCanRxDBufferSize > 0 then
  Str := Format('CanRxDMode=1;CanRxDFifoSize=%u;CanTxDFifoSize=%u;CanRxDBufferSize=%u',
              [FRxDFifoSize, FTxDFifoSize, FCanRxDBufferSize])
else
  Str := Format('CanRxDMode=0;CanRxDFifoSize=%u;CanTxDFifoSize=%u',
              [FRxDFifoSize, FTxDFifoSize]);
if length(FCfgFile) > 0 then
  Str := Str + ';CfgFile=' + FCfgFile;
if length(FLogFile) > 0 then
  begin;
  Str := Str + ';LogFile=' + FLogFile;
  Str := Str + Format(';LogFlags=%u', [GetLogFlags]);
  end; 
if length(FInitParameterStr) > 0 then
  Str := Str + ';' + FInitParameterStr;
if ex_mode then
  begin
  if Assigned(pmCanExInitDriver) then
    result := pmCanExInitDriver(PAnsiChar(AnsiString(Str)));
  end
else
  begin;      
  if Assigned(pmCanInitDriver) then
    result := pmCanInitDriver(PAnsiChar(AnsiString(Str)));
  end;
end;


function TTinyCAN.CanInitDriver: Integer;

begin;
result := CanInitDriver_Int(FALSE);
end;


function TTinyCAN.CanExInitDriver(options: PAnsiChar): Integer;  

begin;
result := CanInitDriver_Int(TRUE);
end;


procedure TTinyCAN.CanDownDriver;
var i, cnt: Integer;

begin;
if Assigned(pmCanDownDriver) then
  begin;
  // **** Alle Events sperren
  if Assigned(pmCanSetEvents) then
    pmCanSetEvents(0);
  if Assigned(pmCanExSetEventAll) then
    pmCanExSetEventAll(MHS_EVENT_TERMINATE);
  for i := 0 to 5 do
    begin;
    cnt := 100;
    while DrvRefCounter > 0 do
      begin;
      Sleep(10);
      Application.ProcessMessages;
      dec(cnt);
      if cnt = 0 then
        break;
      end;
    Sleep(1);
    if DrvRefCounter = 0 then
      break;
    end;  
  DrvRefCounter := 0;    
  pmCanDownDriver;
  end;
end;


function TTinyCAN.CanSetOptions: Integer;
var Str: String;

begin;
// Treiber Optionen setzen
result := -1;
if FPnPEnable then
  begin;
  if FAutoReOpen then
    Str := 'AutoConnect=1;AutoReopen=1'
  else
    Str := 'AutoConnect=1'
  end
else
  Str := 'AutoConnect=0';
if length(FOptionsStr) > 0 then
  Str := Str + ';' + FOptionsStr;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetOptions) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetOptions(PAnsiChar(AnsiString(Str)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanDeviceOpen: Integer;
var str: String;
    baud_rate: DWord;

begin;
result := -1;
baud_rate := BaudRateTab[ord(FBaudRate)];
if FInterfaceType = INTERFACE_USB then
  begin;
  if (length(FDeviceSnr) > 0)  and (baud_rate > 0) then
    str := Format('ComDrvType=1;Snr=%s;BaudRate=%u', [FDeviceSnr, baud_rate])
  else if length(FDeviceSnr) > 0 then
    str := Format('ComDrvType=1;Snr=%s', [FDeviceSnr])
  else if baud_rate > 0 then
    str := Format('ComDrvType=1;BaudRate=%u', [baud_rate])
  else
    str := 'ComDrvType=1';
  end  
else
  begin;
  if baud_rate > 0 then                     
    Str := Format('ComDrvType=0;Port=%u;BaudRate=%u',[FPort, baud_rate])
  else
    Str := Format('ComDrvType=0;Port=%u',[FPort]);
  end;                        
if length(FOpenStr) > 0 then
  str := str + ';' + FOpenStr;
if (DrvDLLWnd <> 0) and Assigned(pmCanDeviceOpen) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanDeviceOpen(0, PAnsiChar(AnsiString(str)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanDeviceClose: Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanDeviceClose) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanDeviceClose(0);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanSetMode(index: DWORD; can_op_mode: TCanMode; can_command: Word): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetMode) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetMode(index, ord(can_op_mode), can_command);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanTransmit(index: DWORD; msg: PCanMsg; count: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanTransmit) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanTransmit(index, msg, count);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanTransmitClear(index: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanTransmitClear) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanTransmitClear(index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanTransmitGetCount(index: DWORD): DWORD;

begin;
result := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanTransmitGetCount) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanTransmitGetCount(index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanTransmitSet(index: DWORD; cmd: Word; time: DWORD): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanTransmitSet) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanTransmitSet(index, cmd, time);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanReceive(index: DWORD; msg: PCanMsg; count: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanReceive) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanReceive(index, msg, count);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanReceiveClear(index: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanReceiveClear) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanReceiveClear(index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanReceiveGetCount(index: DWORD): DWORD;

begin;
result := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanReceiveGetCount) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanReceiveGetCount(index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanSetSpeed(index: DWORD; speed: TCanSpeed): Integer;
var speed_value: Word;

begin;
result := -1;
speed_value := CanSpeedTab[ord(speed)];
if (DrvDLLWnd <> 0) and Assigned(pmCanSetSpeed) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetSpeed(index, speed_value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanDrvInfo: PAnsiChar;

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanDrvInfo) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanDrvInfo;
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := nil;
end;


function TTinyCAN.CanDrvHwInfo(index: DWORD): PAnsiChar;

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanDrvHwInfo) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanDrvHwInfo(index);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := nil;
end;


function TTinyCAN.CanSetFilter(index: DWORD; msg_filter: PMsgFilter): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetFilter) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetFilter(index, msg_filter);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanGetDeviceStatus(index: DWORD; status: PDeviceStatus): Integer;
var status_drv: TDeviceStatusDrv;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanGetDeviceStatus) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanGetDeviceStatus(index, @status_drv);
  InterlockedDecrement(DrvRefCounter);
  end;
status^.DrvStatus := TDrvStatus(status_drv.DrvStatus);
status^.CanStatus := TCanStatus(status_drv.CanStatus and $0F);
status^.FifoStatus := TCanFifoStatus(status_drv.FifoStatus);
if (status_drv.CanStatus and $10) = $10 then
  status^.BusFailure := TRUE
else
  status^.BusFailure := FALSE;
end;


procedure TTinyCAN.CanSetPnPEventCallback(event_proc: PF_CanPnPEventCallback);
begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetPnPEventCallback) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanSetPnPEventCallback(event_proc);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanSetStatusEventCallback(event_proc: PF_CanStatusEventCallback);
begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetStatusEventCallback) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanSetStatusEventCallback(event_proc);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanSetRxEventCallback(event_proc: PF_CanRxEventCallback);
begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetRxEventCallback) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanSetRxEventCallback(event_proc);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanSetEvents(events: TEventMasks);
var e: Word;

begin;
e := 0;
if PNP_CHANGE_EVENT in events then
  e := e or EVENT_ENABLE_PNP_CHANGE
else
  e := e or EVENT_DISABLE_PNP_CHANGE;
if STATUS_CHANGE_EVENT in events then
  e := e or EVENT_ENABLE_STATUS_CHANGE
else
  e := e or EVENT_DISABLE_STATUS_CHANGE;
if RX_FILTER_MESSAGES_EVENT in events then
  e := e or EVENT_ENABLE_RX_FILTER_MESSAGES
else
  e := e or EVENT_DISABLE_RX_FILTER_MESSAGES;
if RX_MESSAGES_EVENT in events then
  e := e or EVENT_ENABLE_RX_MESSAGES
else
  e := e or EVENT_DISABLE_RX_MESSAGES;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetEvents) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanSetEvents(e);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanEventStatus: DWORD;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanEventStatus) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanEventStatus;
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetDeviceCount(flags: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceCount) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceCount(flags);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetDeviceListPerform(flags: Integer): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceListPerform) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceListPerform(flags);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetDeviceListGet(item: PCanDevicesList): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceListGet) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceListGet(item);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetDeviceInfoPerform(index: DWORD; device_info: PCanDeviceInfo): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceInfoPerform) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceInfoPerform(index, device_info);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetDeviceInfoGet(item: PCanInfoVar): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceInfoGet) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceInfoGet(item);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExCreateDevice(var index: DWORD; options: String): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExCreateDevice) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExCreateDevice(@index, PAnsiChar(AnsiString(options)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExDestroyDevice(var index: DWORD): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExDestroyDevice) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExDestroyDevice(@index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExCreateFifo(index: DWORD; size: DWORD; event_obj: Pointer; event: DWORD; channels: DWORD): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExCreateFifo) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExCreateFifo(index, size, event_obj, event, channels);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExBindFifo(fifo_index: DWORD; device_index: DWORD; bind: DWORD): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExBindFifo) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExBindFifo(fifo_index, device_index, bind);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExCreateEvent: Pointer;

begin;
result := nil;
if (DrvDLLWnd <> 0) and Assigned(pmCanExCreateEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExCreateEvent;
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExSetObjEvent(index: DWORD; source: DWORD; event_obj: Pointer; event: DWORD): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetObjEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetObjEvent(index, source, event_obj, event);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanExSetEvent(event_obj: Pointer; event: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanExSetEvent(event_obj, event);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanExSetEventAll(event: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetEventAll) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanExSetEventAll(event);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

 
procedure TTinyCAN.CanExResetEvent(event_obj: Pointer; event: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanExResetEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanExResetEvent(event_obj, event);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExWaitForEvent(event_obj: Pointer; timeout: DWORD): DWORD;

begin;
result := $FFFFFFFF;  // <*> ?
if (DrvDLLWnd <> 0) and Assigned(pmCanExWaitForEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExWaitForEvent(event_obj, timeout);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

                             
function TTinyCAN.CanExSetOptions(index: DWORD; char: String; options: String): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetOptions) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetOptions(index, PAnsiChar(AnsiString(name)), PAnsiChar(AnsiString(options)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExSetAsByte(index: DWORD; name: String; value: Shortint): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsByte) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsByte(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

    
function TTinyCAN.CanExSetAsWord(index: DWORD; name: String; value: smallint): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsWord) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsWord(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

    
function TTinyCAN.CanExSetAsLong(index: DWORD; name: String; value: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsLong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsLong(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

     
function TTinyCAN.CanExSetAsUByte(index: DWORD; name: String; value: Byte): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsUByte) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsUByte(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

       
function TTinyCAN.CanExSetAsUWord(index: DWORD; name: String; value: WORD): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsUWord) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsUWord(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

       
function TTinyCAN.CanExSetAsULong(index: DWORD; name: String; value: DWORD): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsULong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsULong(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExSetAsString(index: DWORD; name: String; value: String): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsString) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsString(index, PAnsiChar(AnsiString(name)), PAnsiChar(AnsiString(value)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;

 
function TTinyCAN.CanExGetAsByte(index: DWORD; name: String; var value: shortint): Integer;
var read_value: shortint;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsByte) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsByte(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;


function TTinyCAN.CanExGetAsWord(index: DWORD; name: String; var value: smallint): Integer;
var read_value: smallint;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsWord) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsWord(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;

   
function TTinyCAN.CanExGetAsLong(index: DWORD; name: String; var value: Integer): Integer; 
var read_value: Integer;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsLong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsLong(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;  
end;

   
function TTinyCAN.CanExGetAsUByte(index: DWORD; name: String; var value: Byte): Integer;
var read_value: Byte;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsUByte) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsUByte(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;  
end;


function TTinyCAN.CanExGetAsUWord(index: DWORD; name: String; var value: WORD): Integer;
var read_value: WORD;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsUWord) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsUWord(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;

      
function TTinyCAN.CanExGetAsULong(index: DWORD; name: String; var value: DWORD): Integer;
var read_value: DWORD;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsULong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsULong(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;

    
function TTinyCAN.CanExGetAsString(index: DWORD; name: String; var str: String): Integer;

begin;
result := -1;
{result := -1;    <*>
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsString) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsString(PAnsiChar(AnsiString(name)), );
  InterlockedDecrement(DrvRefCounter);
  end;
  }
end;


{**************************************************************}
{* DLL Treiber laden                                          *}
{**************************************************************}
function TTinyCAN.LoadDriver: Integer;

begin;
result := 0;
try
  DownDriver;
  {Hardware Treiber laden}
  DRVDLLWnd:=LoadLibrary(PChar(GetApiDriverWithPath(FTreiberName)));
  if DRVDLLWnd=0 then raise EDllLoadError.create('');
  pmCanInitDriver := GetProcAddress(DrvDLLWnd, 'CanInitDriver');
  pmCanDownDriver := GetProcAddress(DrvDLLWnd, 'CanDownDriver');
  pmCanSetOptions := GetProcAddress(DrvDLLWnd, 'CanSetOptions');
  pmCanDeviceOpen := GetProcAddress(DrvDLLWnd, 'CanDeviceOpen');
  pmCanDeviceClose := GetProcAddress(DrvDLLWnd, 'CanDeviceClose');
  pmCanSetMode := GetProcAddress(DrvDLLWnd, 'CanSetMode');
  pmCanTransmit := GetProcAddress(DrvDLLWnd, 'CanTransmit');
  pmCanTransmitClear := GetProcAddress(DrvDLLWnd, 'CanTransmitClear');
  pmCanTransmitGetCount := GetProcAddress(DrvDLLWnd, 'CanTransmitGetCount');
  pmCanTransmitSet := GetProcAddress(DrvDLLWnd, 'CanTransmitSet');
  pmCanReceive := GetProcAddress(DrvDLLWnd, 'CanReceive');
  pmCanReceiveClear := GetProcAddress(DrvDLLWnd, 'CanReceiveClear');
  pmCanReceiveGetCount := GetProcAddress(DrvDLLWnd, 'CanReceiveGetCount');
  pmCanSetSpeed := GetProcAddress(DrvDLLWnd, 'CanSetSpeed');
  pmCanDrvInfo := GetProcAddress(DrvDLLWnd, 'CanDrvInfo');
  pmCanDrvHwInfo := GetProcAddress(DrvDLLWnd, 'CanDrvHwInfo');
  pmCanSetFilter := GetProcAddress(DrvDLLWnd, 'CanSetFilter');
  pmCanGetDeviceStatus := GetProcAddress(DrvDLLWnd, 'CanGetDeviceStatus');
  pmCanSetPnPEventCallback := GetProcAddress(DrvDLLWnd, 'CanSetPnPEventCallback');
  pmCanSetStatusEventCallback := GetProcAddress(DrvDLLWnd, 'CanSetStatusEventCallback');
  pmCanSetRxEventCallback := GetProcAddress(DrvDLLWnd, 'CanSetRxEventCallback');
  pmCanSetEvents := GetProcAddress(DrvDLLWnd, 'CanSetEvents');
  pmCanEventStatus := GetProcAddress(DrvDLLWnd, 'CanEventStatus');
  // EX-API
  pmCanExGetDeviceCount := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceCount');
  pmCanExGetDeviceListPerform := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceListPerform');
  pmCanExGetDeviceListGet := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceListGet');
  pmCanExGetDeviceInfoPerform := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceInfoPerform');
  pmCanExGetDeviceInfoGet := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceInfoGet');
  pmCanExCreateDevice := GetProcAddress(DrvDLLWnd, 'CanExCreateDevice'); 
  pmCanExDestroyDevice := GetProcAddress(DrvDLLWnd, 'CanExDestroyDevice');
  pmCanExCreateFifo := GetProcAddress(DrvDLLWnd, 'CanExCreateFifo'); 
  pmCanExBindFifo := GetProcAddress(DrvDLLWnd, 'CanExBindFifo');
  pmCanExCreateEvent := GetProcAddress(DrvDLLWnd, 'CanExCreateEvent');
  pmCanExSetObjEvent := GetProcAddress(DrvDLLWnd, 'CanExSetObjEvent');
  pmCanExSetEvent := GetProcAddress(DrvDLLWnd, 'CanExSetEvent');
  pmCanExSetEventAll := GetProcAddress(DrvDLLWnd, 'CanExSetEventAll');
  pmCanExResetEvent := GetProcAddress(DrvDLLWnd, 'CanExResetEvent');
  pmCanExWaitForEvent := GetProcAddress(DrvDLLWnd, 'CanExWaitForEvent');
  
  pmCanExInitDriver := GetProcAddress(DrvDLLWnd, 'CanExInitDriver'); 
  pmCanExSetOptions := GetProcAddress(DrvDLLWnd, 'CanExSetOptions'); 
  pmCanExSetAsByte := GetProcAddress(DrvDLLWnd, 'CanExSetAsByte');  
  pmCanExSetAsWord := GetProcAddress(DrvDLLWnd, 'CanExSetAsWord');  
  pmCanExSetAsLong := GetProcAddress(DrvDLLWnd, 'CanExSetAsLong');  
  pmCanExSetAsUByte := GetProcAddress(DrvDLLWnd, 'CanExSetAsUByte'); 
  pmCanExSetAsUWord := GetProcAddress(DrvDLLWnd, 'CanExSetAsUWord'); 
  pmCanExSetAsULong := GetProcAddress(DrvDLLWnd, 'CanExSetAsULong'); 
  pmCanExSetAsString := GetProcAddress(DrvDLLWnd, 'CanExSetAsString');
  pmCanExGetAsByte := GetProcAddress(DrvDLLWnd, 'CanExGetAsByte');  
  pmCanExGetAsWord := GetProcAddress(DrvDLLWnd, 'CanExGetAsWord');  
  pmCanExGetAsLong := GetProcAddress(DrvDLLWnd, 'CanExGetAsLong');  
  pmCanExGetAsUByte := GetProcAddress(DrvDLLWnd, 'CanExGetAsUByte'); 
  pmCanExGetAsUWord := GetProcAddress(DrvDLLWnd, 'CanExGetAsUWord'); 
  pmCanExGetAsULong := GetProcAddress(DrvDLLWnd, 'CanExGetAsULong');
  pmCanExGetAsStringCopy := GetProcAddress(DrvDLLWnd, 'CanExGetAsStringCopy');
    
  if @pmCanInitDriver = nil then raise EDllLoadError.create('');
  if @pmCanDownDriver = nil then raise EDllLoadError.create('');
  if @pmCanSetOptions = nil then raise EDllLoadError.create('');
  if @pmCanDeviceOpen = nil then raise EDllLoadError.create('');
  if @pmCanDeviceClose = nil then raise EDllLoadError.create('');
  if @pmCanSetMode = nil then raise EDllLoadError.create('');
  if @pmCanTransmit = nil then raise EDllLoadError.create('');
  if @pmCanTransmitClear = nil then raise EDllLoadError.create('');
  if @pmCanTransmitGetCount = nil then raise EDllLoadError.create('');
  if @pmCanTransmitSet = nil then raise EDllLoadError.create('');
  if @pmCanReceive = nil then raise EDllLoadError.create('');
  if @pmCanReceiveClear = nil then raise EDllLoadError.create('');
  if @pmCanReceiveGetCount = nil then raise EDllLoadError.create('');
  if @pmCanSetSpeed = nil then raise EDllLoadError.create('');
  if @pmCanDrvInfo = nil then raise EDllLoadError.create('');
  if @pmCanDrvHwInfo = nil then raise EDllLoadError.create('');
  if @pmCanSetFilter = nil then raise EDllLoadError.create('');
  if @pmCanGetDeviceStatus = nil then raise EDllLoadError.create('');
  if @pmCanSetPnPEventCallback = nil then raise EDllLoadError.create('');
  if @pmCanSetStatusEventCallback = nil then raise EDllLoadError.create('');
  if @pmCanSetRxEventCallback = nil then raise EDllLoadError.create('');
  if @pmCanSetEvents = nil then raise EDllLoadError.create('');
  if @pmCanEventStatus = nil then raise EDllLoadError.create('');
  // EX-API
  if @pmCanExGetDeviceCount = nil then raise EDllLoadError.create('');
  if @pmCanExGetDeviceListPerform = nil then raise EDllLoadError.create('');
  if @pmCanExGetDeviceListGet = nil then raise EDllLoadError.create('');
  if @pmCanExGetDeviceInfoPerform = nil then raise EDllLoadError.create('');
  if @pmCanExGetDeviceInfoGet = nil then raise EDllLoadError.create('');
  if @pmCanExCreateDevice = nil then raise EDllLoadError.create(''); 
  if @pmCanExDestroyDevice = nil then raise EDllLoadError.create('');
  if @pmCanExCreateFifo = nil then raise EDllLoadError.create(''); 
  if @pmCanExBindFifo = nil then raise EDllLoadError.create('');
  if @pmCanExCreateEvent = nil then raise EDllLoadError.create('');
  if @pmCanExSetObjEvent = nil then raise EDllLoadError.create('');
  if @pmCanExSetEvent = nil then raise EDllLoadError.create('');
  if @pmCanExSetEventAll = nil then raise EDllLoadError.create('');
  if @pmCanExResetEvent = nil then raise EDllLoadError.create('');
  if @pmCanExWaitForEvent = nil then raise EDllLoadError.create('');
  
  if @pmCanExInitDriver = nil then raise EDllLoadError.create(''); 
  if @pmCanExSetOptions = nil then raise EDllLoadError.create(''); 
  if @pmCanExSetAsByte = nil then raise EDllLoadError.create('');  
  if @pmCanExSetAsWord = nil then raise EDllLoadError.create('');  
  if @pmCanExSetAsLong = nil then raise EDllLoadError.create('');
  if @pmCanExSetAsUByte = nil then raise EDllLoadError.create(''); 
  if @pmCanExSetAsUWord = nil then raise EDllLoadError.create('');
  if @pmCanExSetAsULong = nil then raise EDllLoadError.create(''); 
  if @pmCanExSetAsString = nil then raise EDllLoadError.create('');
  if @pmCanExGetAsByte = nil then raise EDllLoadError.create('');  
  if @pmCanExGetAsWord = nil then raise EDllLoadError.create('');  
  if @pmCanExGetAsLong = nil then raise EDllLoadError.create('');  
  if @pmCanExGetAsUByte = nil then raise EDllLoadError.create(''); 
  if @pmCanExGetAsUWord = nil then raise EDllLoadError.create(''); 
  if @pmCanExGetAsULong = nil then raise EDllLoadError.create(''); 
  if @pmCanExGetAsStringCopy = nil then raise EDllLoadError.create('');
  // Treiber Initialisieren
  if CanInitDriver_Int(FExMode) <> 0 then raise EDllLoadError.create('');
  // Callback-Funktionen setzen
  CanSetPnPEventCallback(@CanPnPEventCallback);
  CanSetStatusEventCallback(@CanStatusEventCallback);
  CanSetRxEventCallback(@CanRxEventCallback);
  // Events freigeben
  CanSetEvents(FEventMasks);
  CanSetSpeed(0, FCanSpeed);
  // Treiber Optionen setzen
  CanSetOptions;
  if not FExMode then
    begin
    if CanDeviceOpen <> 0 then
      result := -2
    end;
except
  DownDriver;
  result := -1;
  end;
end;


procedure TTinyCAN.DownDriver;
var dll_wnd: HWnd;

begin;
dll_wnd := DrvDLLWnd;
DrvDLLWnd := 0;
{CanSetEvents([]);   // Alle Events löschen
while CanEventStatus = 0 do
  Application.ProcessMessages;}
if dll_wnd <> 0 then
  CanDownDriver;
pmCanInitDriver := nil;
pmCanDownDriver := nil;
pmCanSetOptions := nil;
pmCanDeviceOpen := nil;
pmCanDeviceClose := nil;
pmCanSetMode := nil;
pmCanTransmit := nil;
pmCanTransmitClear := nil;
pmCanTransmitGetCount := nil;
pmCanTransmitSet := nil;
pmCanReceive := nil;
pmCanReceiveClear := nil;
pmCanReceiveGetCount := nil;
pmCanSetSpeed := nil;
pmCanDrvInfo := nil;
pmCanDrvHwInfo := nil;
pmCanSetFilter := nil;
pmCanGetDeviceStatus := nil;
pmCanSetPnPEventCallback := nil;
pmCanSetStatusEventCallback := nil;
pmCanSetRxEventCallback := nil;
pmCanSetEvents := nil;
pmCanEventStatus := nil;
// EX-API
pmCanExGetDeviceCount := nil;
pmCanExGetDeviceListPerform := nil;
pmCanExGetDeviceListGet := nil;
pmCanExGetDeviceInfoPerform := nil;
pmCanExGetDeviceInfoGet := nil;

pmCanExCreateDevice := nil; 
pmCanExDestroyDevice := nil;
pmCanExCreateFifo := nil;
pmCanExBindFifo := nil;
pmCanExCreateEvent := nil;
pmCanExSetObjEvent := nil;
pmCanExSetEvent := nil;
pmCanExSetEventAll := nil;
pmCanExResetEvent := nil;
pmCanExWaitForEvent := nil;

pmCanExInitDriver := nil; 
pmCanExSetOptions := nil; 
pmCanExSetAsByte := nil;
pmCanExSetAsWord := nil;
pmCanExSetAsLong := nil;
pmCanExSetAsUByte := nil; 
pmCanExSetAsUWord := nil; 
pmCanExSetAsULong := nil; 
pmCanExSetAsString := nil;
pmCanExGetAsByte := nil;
pmCanExGetAsWord := nil;
pmCanExGetAsLong := nil;
pmCanExGetAsUByte := nil; 
pmCanExGetAsUWord := nil;
pmCanExGetAsULong := nil; 
pmCanExGetAsStringCopy := nil;

if dll_wnd <> 0 then
  FreeLibrary(dll_wnd);    
end;


procedure Register;
begin
  RegisterComponents('MHS', [TTinyCAN]);
end;

end.

