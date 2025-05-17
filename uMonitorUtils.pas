unit uMonitorUtils;

interface

uses
   System.Classes, Vcl.Forms, Winapi.Windows, System.SysUtils;

type
  TMonitorInfo = record
    MonitorNum: Integer;
    Width: Integer;
    Height: Integer;
  end;

procedure ListMonitors(Monitors: TStrings);

implementation

procedure ListMonitors(Monitors: TStrings);
var
  i: Integer;
begin
  Monitors.Clear;
  for i := 0 to Screen.MonitorCount - 1 do
  begin
    Monitors.Add(Format('Monitor %d: %d x %d', [
      i + 1,
      Screen.Monitors[i].Width,
      Screen.Monitors[i].Height
    ]));
  end;
end;

end.

