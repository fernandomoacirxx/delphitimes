unit uFrmCalendar;

interface

uses
   Winapi.Windows,
   Winapi.Messages,
   System.SysUtils,
   System.Variants,
   System.Classes,
   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.StdCtrls,
   Vcl.ExtCtrls,
   uJmpListBox,
   ufun,
   uFrameCalendario,
   System.DateUtils,
   Vcl.Buttons,
   uJmpDados;

type
  TFrmCalendar = class(TForm)
    pnlJmp: TPanel;
    pnlCalendario: TPanel;
    pnlCalendario4: TPanel;
    pnlCalendario1: TPanel;
    pnlCalendario2: TPanel;
    jmpDadosTempos: TJmpDados;
    pnlCalendario3: TPanel;
    pnlOculto: TPanel;
    Panel1: TPanel;
    lblTimeTotalativo: TLabel;
    lblTimeTotalInativo: TLabel;
    lblTotalInatividades2: TLabel;
    lblIniciouDias: TLabel;
    lblDataSelecao: TLabel;
    btn1: TButton;
    procedure FormShow(Sender: TObject);
    procedure procClickPanelData(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    procedure AddDia(dt: TDateTime; ind_destaque: boolean; APanelLocal: Tpanel);
    procedure SelectDay(Item: TPanel);
    procedure procConsultaTrabalhoData(ADataConsulta: string);
    procedure getDataTimesAtividades(var AFStartTime, ATotalActiveTime, ATotalInactiveTime, ATotalCargaDia: TDateTime;
                                               var AFInactiveCount: Integer; ADataConsulta : string; AAddTotalTimes : Boolean = true);
    procedure proResteDatesTimes;
    procedure AttachFrameEvents(LFrameItem: TFrameCalendario);
    function CreateFrameItem(LPanelItem: TPanel; dt: TDateTime; ind_destaque: boolean): TFrameCalendario;
    function CreatePanelItem(APanelLocal: TPanel; dt: TDateTime; const AIDSemana: Boolean = false): TPanel;
    procedure UpdateFrameData(LFrameItem: TFrameCalendario; AFStartTime, ATotalActiveTime, ATotalInactiveTime, ATotalCargaDia: TDateTime; FInactiveCount: Integer);
    procedure AddSemana(dt: TDateTime; ind_destaque: boolean; APanelLocal: TPanel);
    function funHorarioMedioInicio: string;
    procedure AddDiaSelf(dt: TDateTime; ind_destaque: boolean; APanelLocal: TPanel; LFStartTime, LTotalActiveTime, LTotalInactiveTime: TDateTime; LFInactiveCount: Integer);
    { Private declarations }
  public
    procedure Calendario;
    procedure CalendarioA(LFStartTime, LTotalActiveTime, LTotalInactiveTime: TDateTime; LFInactiveCount: Integer);
    { Public declarations }
  end;

type
  TDateTimeArray = array of TDateTime;

var
  FrmCalendar: TFrmCalendar;
  aaFStartTime       : TDateTime;
  aaTotalActiveTimeCalendar  : TDateTime;
  aaTotalInactiveTimeCalendar: TDateTime;
  aaTotalCargaDiaCalendar    : TDateTime;
  aaFInactiveCountCalendar   : Integer;
  aaHorariosCalendar         : TDateTimeArray;
  aaAbriuCalendarioCalendar  : Boolean = False;


implementation

{$R *.dfm}


procedure AdicionarHorario(Horario: TDateTime);
begin
  SetLength(aaHorariosCalendar, Length(aaHorariosCalendar) + 1);
  aaHorariosCalendar[High(aaHorariosCalendar)] := Horario;
end;

procedure DeletarTodosHorarios;
begin
  SetLength(aaHorariosCalendar, 0);
end;

function CalcularHorarioMedioInicio(Horarios: TDateTimeArray): TTime;
var TotalMinutes: Int64;
    AvgMinutes: Double;
    i: Integer;
begin
  if Length(Horarios) = 0 then
  begin
    Result := 0;
    Exit;
  end;

  TotalMinutes := 0;
  for i := 0 to Length(Horarios) - 1 do
    TotalMinutes := TotalMinutes + HourOf(Horarios[i]) * 60 + MinuteOf(Horarios[i]);

  AvgMinutes := TotalMinutes / Length(Horarios);
  Result := EncodeTime(Trunc(AvgMinutes) div 60, Trunc(AvgMinutes) mod 60, 0, 0);
end;

function TFrmCalendar.funHorarioMedioInicio : string;
var LHorarioMedio: TTime;
begin
   LHorarioMedio := CalcularHorarioMedioInicio(aaHorariosCalendar);
   Result:= FormatDateTime('hh:nn:ss', LHorarioMedio);
end;

function TranslateDay(d: integer): string;
begin
    case d of
        1: Result := 'DOM';
        2: Result := 'SEG';
        3: Result := 'TER';
        4: Result := 'QUA';
        5: Result := 'QUI';
        6: Result := 'SEX';
        else Result := 'SAB';
    end;
end;

procedure TFrmCalendar.UpdateFrameData(LFrameItem: TFrameCalendario; AFStartTime, ATotalActiveTime, ATotalInactiveTime, ATotalCargaDia: TDateTime; FInactiveCount: Integer);
begin
   var AConfereTime:= AFStartTime;
   if AConfereTime = 0 then LFrameItem.lblIniciouDias.Caption := '  .....  '
    else LFrameItem.lblIniciouDias.Caption := DateTimeToStr(AFStartTime);

   LFrameItem.lblTotalInatividades2.Caption := Format('Paradas: %d', [FInactiveCount]);
   LFrameItem.lblTimeTotalInativo.Caption := Format('Inativo: %d hrs %d min', [HoursBetween(0, ATotalInactiveTime), MinutesBetween(0, ATotalInactiveTime) mod 60]);
   LFrameItem.lblTimeTotalativo.Caption := Format('  Ativo: %d hrs %d min', [HoursBetween(0, ATotalActiveTime), MinutesBetween(0, ATotalActiveTime) mod 60]);
 //  LFrameItem.lblTimeTotalCarga.Caption := Format('  Carga: %d hrs %d min', [HoursBetween(0, ATotalCargaDia), MinutesBetween(0, ATotalCargaDia) mod 60]);
end;

procedure TFrmCalendar.AddDia(dt: TDateTime; ind_destaque: boolean; APanelLocal: TPanel);
var LFStartTime, LTotalActiveTime, LTotalInactiveTime, LTotalCargaDia: TDateTime;
    LFInactiveCount: Integer;
    LPanelItem: TPanel;
    LLFrameItem: TFrameCalendario;
begin
  LPanelItem := CreatePanelItem(APanelLocal, dt);
  LLFrameItem := CreateFrameItem(LPanelItem, dt, ind_destaque);

  getDataTimesAtividades(LFStartTime, LTotalActiveTime, LTotalInactiveTime, LTotalCargaDia, LFInactiveCount, zzString(LLFrameItem.pnlDataDia.Hint).zzDeleteString('/'));
  UpdateFrameData(LLFrameItem, LFStartTime, LTotalActiveTime, LTotalInactiveTime, LTotalCargaDia, LFInactiveCount);
end;

procedure TFrmCalendar.AddDiaSelf(dt: TDateTime; ind_destaque: boolean; APanelLocal: TPanel; LFStartTime, LTotalActiveTime, LTotalInactiveTime: TDateTime; LFInactiveCount: Integer);
var dt1, dt2, dt3, dt4: TDateTime;
    iidt : Integer;
    TotalCargaDia: TDateTime;
    LPanelItem: TPanel;
    LLFrameItem: TFrameCalendario;
begin
  LPanelItem := CreatePanelItem(APanelLocal, dt);
  LLFrameItem := CreateFrameItem(LPanelItem, dt, ind_destaque);

  getDataTimesAtividades(dt1, dt2, dt3, dt4, iidt, zzString(LLFrameItem.pnlDataDia.Hint).zzDeleteString('/'), false);

  TotalCargaDia:= LTotalActiveTime + LTotalInactiveTime;

   aaTotalActiveTimeCalendar  := aaTotalActiveTimeCalendar   + LTotalActiveTime;
   aaTotalInactiveTimeCalendar:= aaTotalInactiveTimeCalendar + LTotalInactiveTime;
   aaFInactiveCountCalendar   := aaFInactiveCountCalendar    + LFInactiveCount ;
   aaTotalCargaDiaCalendar    := aaTotalCargaDiaCalendar     + TotalCargaDia;

  UpdateFrameData(LLFrameItem, dt1, LTotalActiveTime, LTotalInactiveTime, TotalCargaDia, LFInactiveCount);
end;

procedure TFrmCalendar.AddSemana(dt: TDateTime; ind_destaque: boolean; APanelLocal: TPanel);
var LFStartTime, LTotalActiveTime, LTotalInactiveTime, LTotalCargaDia: TDateTime;
    LFInactiveCount: Integer;
    LPanelItem: TPanel;
    LFrameItem: TFrameCalendario;
begin
  LPanelItem := CreatePanelItem(APanelLocal, dt, true);
  LFrameItem := CreateFrameItem(LPanelItem, dt, ind_destaque);
  UpdateFrameData(LFrameItem, LFStartTime, aaTotalActiveTimeCalendar, aaTotalInactiveTimeCalendar, aaTotalCargaDiaCalendar, aaFInactiveCountCalendar);

  LFrameItem.pnlDataDia.Caption:= 'TOTAL';
  LFrameItem.lblSemana.Caption:= 'SEMANA';
  LFrameItem.lblIniciouDias.Caption:= 'Média Inicio: ' + funHorarioMedioInicio;
  LPanelItem.Align:= alClient;

  proResteDatesTimes;
end;

function TFrmCalendar.CreatePanelItem(APanelLocal: TPanel; dt: TDateTime; const AIDSemana: Boolean = false): TPanel;
begin
   var ANewname:= '';
   case AIDSemana of
          True: ANewname:= 'Semana' + APanelLocal.Name + FormatDateTime('dd', dt);
         False: ANewname:= APanelLocal.Name + FormatDateTime('dd', dt);
   end;

   var APanelExist:=  TPanel(APanelLocal.FindChildControl(ANewname));
   if Assigned(APanelExist) then
   begin
      Result:= APanelExist;
      Exit;
   end;

  Result := TPanel.Create(APanelLocal);
  Result.Parent := APanelLocal;
  Result.Align := alLeft;
  Result.Width := 165;
  Result.AlignWithMargins := True;
  Result.Margins.Left := 0;
  Result.Margins.Top := 0;
  Result.Margins.Bottom := 0;
  Result.Margins.Right := 1;
  Result.Tag := FormatDateTime('dd', dt).ToInteger;
  Result.Hint := FormatDateTime('dd/MM/yyyy', dt);
  Result.VerticalAlignment := taAlignTop;
  if AIDSemana then
  begin
     Result.ParentBackground:= False;
     Result.StyleName:= 'Lucky Point';
     Result.Name := ANewname;
  end else Result.Name := ANewname;

  Result.Caption := '';
end;

function TFrmCalendar.CreateFrameItem(LPanelItem: TPanel; dt: TDateTime; ind_destaque: boolean): TFrameCalendario;
begin
   var ANewname:= LPanelItem.Name + 'Frame'+ FormatDateTime('dd', dt);

   var LFrameCalendarioExist:=  TFrameCalendario(LPanelItem.FindChildControl(ANewname));
   if Assigned(LFrameCalendarioExist) then
   begin
      Result:= LFrameCalendarioExist;
      Exit;
   end;

  Result := TFrameCalendario.Create(LPanelItem);
  Result.Parent := LPanelItem;
  Result.lblSemana.Caption := TranslateDay(DayOfWeek(dt));
  Result.pnlDataDia.Hint := FormatDateTime('dd/MM/yyyy', dt);
  Result.pnlDataDia.Caption := FormatDateTime('d', dt);
  Result.pnlDestaque.Visible := ind_destaque;
  Result.Align := alRight;
  Result.Name:= ANewname;
  // Attach event handlers
  //AttachFrameEvents(Result);
end;

procedure TFrmCalendar.AttachFrameEvents(LFrameItem: TFrameCalendario);
begin
  LFrameItem.lblSemana.OnClick := procClickPanelData;
  LFrameItem.pnlDataDia.OnClick := procClickPanelData;
  LFrameItem.pnlDestaque.OnClick := procClickPanelData;
  LFrameItem.lblIniciouDias.OnClick := procClickPanelData;
  LFrameItem.lblTotalInatividades2.OnClick := procClickPanelData;
  LFrameItem.lblTimeTotalInativo.OnClick := procClickPanelData;
  LFrameItem.lblTimeTotalativo.OnClick := procClickPanelData;
  //LFrameItem.lblTimeTotalCarga.OnClick := procClickPanelData;
end;



procedure TFrmCalendar.btn1Click(Sender: TObject);
begin
   Calendario;
end;

procedure TFrmCalendar.SelectDay(Item: TPanel);
var frame: TFrameCalendario;
    i: integer;
begin
    lblDataSelecao.Caption := Item.Hint;

    if zzString(Item.Name).Contains('Semana') then Exit
     else procConsultaTrabalhoData(zzString(Item.Hint).zzDeleteString('/'));
end;

function DecDay(const ADate: TDateTime; const ANumberOfDays: Integer = 1): TDateTime;
begin
  Result := IncDay(ADate, -ANumberOfDays);
end;


function IncDay(const ADate: TDateTime; const ANumberOfDays: Integer = 1): TDateTime;
begin
  Result := IncDay(ADate, +ANumberOfDays);
end;


procedure TFrmCalendar.CalendarioA(LFStartTime, LTotalActiveTime, LTotalInactiveTime: TDateTime; LFInactiveCount: Integer);
var i: Integer;
begin
   proResteDatesTimes;

   for i := 6 downto 0 do
      if i = 0 then AddDiaSelf(DecDay(Date, i), True, pnlCalendario, LFStartTime, LTotalActiveTime, LTotalInactiveTime, LFInactiveCount)
      else AddDia(DecDay(Date, i), False, pnlCalendario);
   AddSemana( Date, True, pnlCalendario);

   for i := 13 downto 7 do AddDia(DecDay(Date, i), False, pnlCalendario1);
   AddSemana( Date, True, pnlCalendario1);

   for i := 20 downto 14 do AddDia(DecDay(Date, i), False, pnlCalendario2);
   AddSemana( Date, True, pnlCalendario2);

   for i := 27 downto 21 do AddDia(DecDay(Date, i), False, pnlCalendario3);
   AddSemana( Date, True, pnlCalendario3);

   for i := 34 downto 28 do AddDia(DecDay(Date, i), False, pnlCalendario4);
   AddSemana( Date, True, pnlCalendario4);

    var APanelNameSelected:= 'pnlCalendario' + FormatDateTime('dd/MM/yyyy', now);
    var APanelSelecionado:= TPanel(pnlCalendario.FindChildControl(APanelNameSelected) );
    if isNotNill(APanelSelecionado) then SelectDay(APanelSelecionado);

    aaAbriuCalendarioCalendar:= True;
end;

procedure TFrmCalendar.Calendario;
var i: Integer;
begin
   proResteDatesTimes;

   for i := 0 to 6 do
      if i = 0 then AddDia(DecDay(Date, i), True, pnlCalendario)
      else AddDia(DecDay(Date, i), False, pnlCalendario);
   AddSemana( Date, True, pnlCalendario);

   for i := 7 to 13 do AddDia(DecDay(Date, i), False, pnlCalendario1);
   AddSemana( Date, True, pnlCalendario1);

   for i := 14 to 20 do AddDia(DecDay(Date, i), False, pnlCalendario2);
   AddSemana( Date, True, pnlCalendario2);

   for i := 21 to 27 do AddDia(DecDay(Date, i), False, pnlCalendario3);
   AddSemana( Date, True, pnlCalendario3);

   for i := 28 to 34 do AddDia(DecDay(Date, i), False, pnlCalendario4);
   AddSemana( Date, True, pnlCalendario4);

    var APanelNameSelected:= 'pnlCalendario' + FormatDateTime('dd/MM/yyyy', now);
    var APanelSelecionado:= TPanel(pnlCalendario.FindChildControl(APanelNameSelected) );
    if isNotNill(APanelSelecionado) then SelectDay(APanelSelecionado);

    aaAbriuCalendarioCalendar:= True;
end;

procedure TFrmCalendar.proResteDatesTimes;
begin
   aaTotalActiveTimeCalendar  := 0;
   aaTotalInactiveTimeCalendar:= 0;
   aaFInactiveCountCalendar   := 0;
   aaTotalCargaDiaCalendar    := 0;
   DeletarTodosHorarios;
end;


procedure TFrmCalendar.getDataTimesAtividades(var AFStartTime, ATotalActiveTime, ATotalInactiveTime, ATotalCargaDia : TDateTime;
                                               var AFInactiveCount: Integer; ADataConsulta : string; AAddTotalTimes : Boolean);
begin
   AFStartTime          := StrToDateTimeDef(jmpDadosTempos.Load('FStartTime' + ADataConsulta), 0);
   ATotalActiveTime     := StrToDateTimeDef(jmpDadosTempos.Load('TotalActiveTime' + ADataConsulta), 0);
   ATotalInactiveTime   := StrToDateTimeDef(jmpDadosTempos.Load('TotalInactiveTime' + ADataConsulta), 0);
   AFInactiveCount      := StrToIntDef(jmpDadosTempos.Load('FInactiveCount' + ADataConsulta), 0);
   ATotalCargaDia       := ATotalActiveTime + ATotalInactiveTime;

   if AAddTotalTimes then
   begin
     aaTotalActiveTimeCalendar  := aaTotalActiveTimeCalendar   + ATotalActiveTime;
     aaTotalInactiveTimeCalendar:= aaTotalInactiveTimeCalendar + ATotalInactiveTime;
     aaFInactiveCountCalendar   := aaFInactiveCountCalendar    + AFInactiveCount ;
     aaTotalCargaDiaCalendar    := aaTotalCargaDiaCalendar     + ATotalCargaDia;
   end;

   var AConfereTime:= AFStartTime;
   if AConfereTime = 0 then Exit;
   AdicionarHorario(AFStartTime);
end;

procedure TFrmCalendar.procConsultaTrabalhoData(ADataConsulta : string);
var FStartTime       : TDateTime;
    TotalActiveTime  : TDateTime;
    TotalInactiveTime: TDateTime;
    TotalCargaDia    : TDateTime;
    FInactiveCount   : Integer;
begin
   getDataTimesAtividades(FStartTime, TotalActiveTime, TotalInactiveTime, TotalCargaDia,  FInactiveCount, ADataConsulta);
   proResteDatesTimes;
   var AConfereTime:= FStartTime;
   if AConfereTime = 0 then lblIniciouDias.Caption := '  .....  '
   else lblIniciouDias.Caption   := 'Iniciou as ' + Datetimetostr(FStartTime);
   lblTotalInatividades2.Caption:= Format('Total de inatividades: %d', [FInactiveCount]);
   lblTimeTotalInativo.Caption:= Format('Tempo total inativo: %d horas e %d minutos', [HoursBetween(0, TotalInactiveTime), MinutesBetween(0, TotalInactiveTime) mod 60]);
   lblTimeTotalativo.Caption:= Format('Tempo total ativo: %d horas e %d minutos', [HoursBetween(0, TotalActiveTime), MinutesBetween(0, TotalActiveTime) mod 60]);
   //lblTimeTotalCarga.Caption:= Format('Tempo de Trabalho: %d horas e %d minutos', [HoursBetween(0, TotalCargaDia), MinutesBetween(0, TotalCargaDia) mod 60]);
end;

procedure TFrmCalendar.FormShow(Sender: TObject);
begin
  if not aaAbriuCalendarioCalendar then
      Calendario;
end;

procedure TFrmCalendar.procClickPanelData(Sender: TObject);
begin
   if (Sender is TPanel) then
       SelectDay(TPanel(Sender));

   if (Sender is TLabel) then
   begin
       try
         var LPanelParene:= TPanel(TPanel(TPanel(TPanel(TLabel(Sender).Parent).Parent).Parent).Parent);
         if Assigned(LPanelParene) then
         begin
            SelectDay(LPanelParene);
         end;
       except

       end;
   end;

end;

end.
