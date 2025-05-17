unit uActivityStorage;

interface

uses
  System.SysUtils, System.Classes, Generics.Collections, DateUtils;

type
  TActivityPeriod = record
    StartTime: TDateTime;
    EndTime: TDateTime;
    IsActive: Boolean;
  end;

const
  LOG_FILE_PREFIX = 'ActivityLog_';
  DATE_FORMAT = 'yyyy-mm-dd';

type
  TActivityStorage = class
  private
    FFilePath: string;
    FActivityPeriods: TList<TActivityPeriod>;
    FInactiveCount: Integer;
    FStartTime: TDateTime;
    FTotalActiveTime: TDateTime;
    FTotalInactiveTime: TDateTime;
    FTimerCaption: string;
    FStarted: Boolean;
    function GetLogFilePath: string;
    procedure LoadFromFile;
    procedure SaveToFile;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddActivityPeriod(const Period: TActivityPeriod);
    function GetActivityPeriods: TList<TActivityPeriod>;
    procedure NewDayCheck;
    procedure SaveState(const InactiveCount: Integer; const StartTime, TotalActiveTime, TotalInactiveTime: TDateTime; const TimerCaption: string);
    procedure LoadState(out InactiveCount: Integer; out StartTime, TotalActiveTime, TotalInactiveTime: TDateTime; out TimerCaption: string);
    function IsStarted: Boolean;
  end;

implementation

constructor TActivityStorage.Create;
begin
  FActivityPeriods := TList<TActivityPeriod>.Create;
  FFilePath := GetLogFilePath;
  LoadFromFile;
end;

destructor TActivityStorage.Destroy;
begin
  SaveToFile;
  FActivityPeriods.Free;
  inherited;
end;

procedure TActivityStorage.AddActivityPeriod(const Period: TActivityPeriod);
begin
  FActivityPeriods.Add(Period);
  SaveToFile;
end;

procedure TActivityStorage.LoadFromFile;
var
  FileStream: TFileStream;
  Period: TActivityPeriod;
  Value: Integer;
  DateValue: TDateTime;
  StrValue: string;
  StrLength: Integer;
begin
  if FileExists(FFilePath) then
  begin
    FileStream := TFileStream.Create(FFilePath, fmOpenRead);
    try
      while FileStream.Position < FileStream.Size do
      begin
        FileStream.ReadBuffer(Period, SizeOf(TActivityPeriod));
        FActivityPeriods.Add(Period);
      end;

      FileStream.ReadBuffer(FInactiveCount, SizeOf(Integer));
      FileStream.ReadBuffer(FStartTime, SizeOf(TDateTime));
      FileStream.ReadBuffer(FTotalActiveTime, SizeOf(TDateTime));
      FileStream.ReadBuffer(FTotalInactiveTime, SizeOf(TDateTime));
      FileStream.ReadBuffer(StrLength, SizeOf(Integer));
      SetLength(FTimerCaption, StrLength);
      FileStream.ReadBuffer(FTimerCaption[1], StrLength * SizeOf(Char));
      FileStream.ReadBuffer(FStarted, SizeOf(Boolean));
    finally
      FileStream.Free;
    end;
  end;
end;

procedure TActivityStorage.SaveToFile;
var
  FileStream: TFileStream;
  Period: TActivityPeriod;
  StrLength: Integer;
begin
  FileStream := TFileStream.Create(FFilePath, fmCreate);
  try
    for Period in FActivityPeriods do
    begin
      FileStream.WriteBuffer(Period, SizeOf(TActivityPeriod));
    end;

    FileStream.WriteBuffer(FInactiveCount, SizeOf(Integer));
    FileStream.WriteBuffer(FStartTime, SizeOf(TDateTime));
    FileStream.WriteBuffer(FTotalActiveTime, SizeOf(TDateTime));
    FileStream.WriteBuffer(FTotalInactiveTime, SizeOf(TDateTime));
    StrLength := Length(FTimerCaption);
    FileStream.WriteBuffer(StrLength, SizeOf(Integer));
    FileStream.WriteBuffer(FTimerCaption[1], StrLength * SizeOf(Char));
    FileStream.WriteBuffer(FStarted, SizeOf(Boolean));
  finally
    FileStream.Free;
  end;
end;

function TActivityStorage.GetLogFilePath: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + LOG_FILE_PREFIX +
            FormatDateTime(DATE_FORMAT, Date) + '.log';
end;

function TActivityStorage.GetActivityPeriods: TList<TActivityPeriod>;
begin
  Result := FActivityPeriods;
end;

procedure TActivityStorage.NewDayCheck;
var
  NewFilePath: string;
begin
  NewFilePath := GetLogFilePath;
  if FFilePath <> NewFilePath then
  begin
    SaveToFile;
    FFilePath := NewFilePath;
    FActivityPeriods.Clear;
    LoadFromFile;
  end;
end;

procedure TActivityStorage.SaveState(const InactiveCount: Integer; const StartTime, TotalActiveTime, TotalInactiveTime: TDateTime; const TimerCaption: string);
begin
  FInactiveCount := InactiveCount;
  FStartTime := StartTime;
  FTotalActiveTime := TotalActiveTime;
  FTotalInactiveTime := TotalInactiveTime;
  FTimerCaption := TimerCaption;
  FStarted := True;
  SaveToFile;
end;

procedure TActivityStorage.LoadState(out InactiveCount: Integer; out StartTime, TotalActiveTime, TotalInactiveTime: TDateTime; out TimerCaption: string);
begin
  InactiveCount := FInactiveCount;
  StartTime := FStartTime;
  TotalActiveTime := FTotalActiveTime;
  TotalInactiveTime := FTotalInactiveTime;
  TimerCaption := FTimerCaption;
end;

function TActivityStorage.IsStarted: Boolean;
begin
  Result := FStarted;
end;

end.

