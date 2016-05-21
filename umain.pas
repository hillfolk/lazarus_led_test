unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls,Unix,BaseUnix;

type

  { TForm1 }

  TForm1 = class(TForm)
    cbAutoONOFF: TCheckBox;
    Memo1: TMemo;
    Panel1: TPanel;
    Shape1: TShape;
    Timer1: TTimer;
    tgbLED: TToggleBox;
    procedure cbAutoONOFFClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Shape1ChangeBounds(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure tgbLEDChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure Log(ALOG:string);
  end;

  const
    PIN_24:PChar = '24';
    PIN_ON:PChar = '0';
    PIN_OFF:PChar = '1';

    OUT_DIRECTION:PChar = 'out';


var
  Form1: TForm1;
  gReturnCode:LongInt;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.tgbLEDChange(Sender: TObject);
var
  fileDesc:Integer;
begin
  if tgbLED.Checked then
  begin
  try
  fileDesc := FpOpen('/sys/class/gpio/gpio24/value',O_WRONLY);
  gReturnCode := FpWrite(fileDesc,PIN_ON[0],1);
  Log(IntToStr(gReturnCode));
  finally
    gReturnCode:=FpClose(fileDesc);
    Log(IntToStr(gReturnCode));
  end;

  end
  else
  begin
  try
  fileDesc := FpOpen('/sys/class/gpio/gpio24/value',O_WRONLY);
  gReturnCode := FpWrite(fileDesc,PIN_OFF[0],1);
  Log(IntToStr(gReturnCode));
  finally
    gReturnCode:=FpClose(fileDesc);
    Log(IntToStr(gReturnCode));
  end;
  end;


end;

procedure TForm1.FormActivate(Sender: TObject);
var
  fileDesc:Integer;
begin
  try
  fileDesc := FpOpen('/sys/class/gpio/export',O_WRONLY);
  gReturnCode := FpWrite(fileDesc,PIN_24[0],2);
  Log(IntToStr(gReturnCode));
  finally
    gReturnCode:=FpClose(fileDesc);
    Log(IntToStr(gReturnCode));
  end;

  try
  fileDesc := FpOpen('/sys/class/gpio/gpio24/direction',O_WRONLY);
  gReturnCode := FpWrite(fileDesc,OUT_DIRECTION[0],3);
  Log(IntToStr(gReturnCode));
  finally
    gReturnCode:=FpClose(fileDesc);
    Log(IntToStr(gReturnCode));
  end
end;

procedure TForm1.cbAutoONOFFClick(Sender: TObject);
begin
  Timer1.Enabled:= cbAutoONOFF.Checked;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
fileDesc:Integer;
begin
  try
  fileDesc := FpOpen('/sys/class/gpio/unexport',O_WRONLY);
  gReturnCode := FpWrite(fileDesc,PIN_24[0],2);
  Log(IntToStr(gReturnCode));
  finally
    gReturnCode:=FpClose(fileDesc);
    Log(IntToStr(gReturnCode));
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Shape1ChangeBounds(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  tgbLED.Checked:= not tgbLED.Checked;
end;

procedure TForm1.Log(ALOG: string);
begin
  with Memo1 do
  begin
  Lines.Add(Format('%s:%s',[DateTimeToStr(Now), ALOG]));

  end;

end;

end.

