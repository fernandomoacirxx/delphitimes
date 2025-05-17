unit uFrmPrincipal;

interface

uses  Winapi.ActiveX,
      Winapi.Messages,
      Winapi.Windows,
      System.Classes,
      System.ImageList,
      System.Math,
      System.SysUtils,
      System.Variants,
      System.Win.ComObj,
      Vcl.AppEvnts,
      Vcl.Clipbrd,
      Vcl.ComCtrls,
      Vcl.Controls,
      Vcl.Dialogs,
      Vcl.ExtCtrls,
      Vcl.Forms,
      Vcl.Graphics,
      Vcl.ImgList,
      Vcl.Menus,
      Vcl.StdCtrls,
      dmJmpImagemList32,
      uJmpDados,
      uJumpCardEdit,
      uJumpCardMemo,
      uJumpCardStatus,
      ufun,
      uMessageProcessor,
      uMonitorUtils,
      System.StrUtils,
      System.Generics.Collections,
      System.DateUtils,
      uActivityStorage,
      uRegistryUtils,
      uJmpSpin,
      Vcl.Buttons,
      uFrmCalendar;


const
  WM_TRAY_RESTORE = WM_USER + 1; // Definimos uma mensagem personalizada
 // WM_STRING_MESSAGE = WM_USER + 2;

type
  TFrmPrincipal = class(TForm)
    jmpStatus: TJMPCardStatus;
    imageList2: TImageList;
    spl1: TSplitter;
    tmr1: TTimer;
    pnlJmp: TPanel;
    trycn1: TTrayIcon;
    popTrayIcon: TPopupMenu;
    mniAbrir1: TMenuItem;
    mniN1: TMenuItem;
    mniFechar1: TMenuItem;
    pnl1: TPanel;
    chkTodosUsuarios: TCheckBox;
    appEvent1: TApplicationEvents;
    jmpDados2: TJmpDados;
    chkAutoMudo: TCheckBox;
    tmrMonitor: TTimer;
    jmpDadosTempos: TJmpDados;
    pnl: TPanel;
    spl2: TSplitter;
    pnl2: TPanel;
    lblTimer: TLabel;
    lbl1: TLabel;
    lblDiaSemana: TLabel;
    btnMstsc: TSpeedButton;
    pnl3: TPanel;
    lblTimeTotalativo: TLabel;
    lblTimeTotalInativo: TLabel;
    lblTotalInatividades2: TLabel;
    lblTimeTotalCarga: TLabel;
    pnl5: TPanel;
    btnRelatorio: TSpeedButton;
    btn1: TButton;
    btnMinimizar: TButton;
    jmpSpinInatividade: TJmpSpin;
    jmpSpinInatividadeOff: TJmpSpin;
    btnShowForms: TButton;
    btnSetPassword: TButton;
    pnl4: TPanel;
    jmpEditCaminhoFile: TJMPCardEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnSetPasswordClick(Sender: TObject);
    procedure edt1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnShowFormsClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure trycn1DblClick(Sender: TObject);
    procedure mniAbrir1Click(Sender: TObject);
    procedure mniFechar1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure appEvent1Exception(Sender: TObject; E: Exception);
    procedure chkTodosUsuariosClick(Sender: TObject);
    procedure chkAutoMudoClick(Sender: TObject);
    procedure tmrMonitorTimer(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FActivityPeriods: TList<TActivityPeriod>;
    FInactiveCount: Integer;
    FStartTime: TDateTime;
    procedure CreateFormsForMonitors;
    procedure CreateFormsA(var AForm: TForm;var AEdit: TEdit; AMonitor: TMonitor; const iType: Integer = 0);
    procedure CheckLogFile;
    procedure zzHandleFormClose(Sender: TObject; var Action: TCloseAction);
    { Private declarations }
    procedure WMTrayRestore(var Msg: TMessage); message WM_TRAY_RESTORE;
    procedure ToggleMute;
    procedure LogActivityPeriod(IsActive: Boolean);
    procedure GenerateReport;
    procedure jmpSpinInatividadeonEventChange(Sender: TObject);
    procedure procDesLigarSistema;
    procedure procLigarSistema;
    procedure OnMouseInactive(Sender: TObject);
    procedure OnMouseOff(Sender: TObject);
    procedure OnWindowStateChange(Sender: TObject);
    procedure procInactiveCount;
    procedure zzTrayUpdateView;
    procedure procSaveConfigs;
    procedure procResetInicial;
    procedure procSetDataAtual;
    procedure proRegistraInicioDoDia;
    procedure FormMouseMoveGeneric(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure HideAllForms;
    procedure ReleaseAllForms; // Definição correta
   // procedure WMStringMessage(var Msg: TMessage); message WM_STRING_MESSAGE;
  public
    procedure RestoreFromTray;  // Método para restaurar do tray
    { Public declarations }
  end;

type
  TMouseMonitor = class(TThread)
  private
    FInactiveTime: Integer;
    FInactiveTimeOff: Integer;
    FInterval: Integer;
    FOnInactive: TNotifyEvent;
    FOnMouseOff: TNotifyEvent;
    procedure CheckMouseActivity;
  protected
    procedure Execute; override;
  public
    FMaxInactiveTime   : Integer;
    FMaxInactiveTimeOff: Integer;
    constructor Create(AInterval, AMaxInactiveTime, AMaxInactiveTimeOff: Integer; AOnInactive, AOnMouseOff: TNotifyEvent);
  end;

type
  TWindowMonitor = class(TThread)
  private
    FClassName: string;
    FOnStateChange: TNotifyEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(AClassName: string; AOnStateChange: TNotifyEvent);
  end;

const
  LLKHF_EXTENDED = KF_EXTENDED shr 8;
  LLKHF_INJECTED = $00000010;
  LLKHF_ALTDOWN  = KF_ALTDOWN shr 8;
  LLKHF_UP       = KF_UP shr 8;
  LLMHF_INJECTED = $00000001;

type
  LPKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;
  tagKBDLLHOOKSTRUCT = record
    vkCode      : DWORD;
    scanCode    : DWORD;
    flags       : DWORD;
    time        : DWORD;
    dwExtraInfo : ULONG_PTR;
  end;
  KBDLLHOOKSTRUCT  = tagKBDLLHOOKSTRUCT;
  TKbDllHookStruct = KBDLLHOOKSTRUCT;
  PKbDllHookStruct = LPKBDLLHOOKSTRUCT;

var
  FrmPrincipal : TFrmPrincipal;
  aaFormsTampa : TArray<TForm>;
  aaEditPasswords: TArray<TEdit>;
  LastLogLine  : Integer;
  KeyHookHandle: HHOOK=0;

  MouseMonitor       : TMouseMonitor;
  WindowMonitor      : TWindowMonitor;
  aaMonitAtivo       : Boolean = false;
  aaTotalActiveTime  : TDateTime;
  aaTotalInactiveTime: TDateTime;
  aaDataInicial      : string;
  AHandlePrincipal   : HWND = 0;
  aaPerguntaAviso    : Boolean = True;
  aaInicioDoDia      : integer = 0;

  FLastMousePos: TPoint;



implementation


{$R *.dfm}


function LowLevelKeyProc(Code: Integer; wPar: wParam; lPar: LParam): LRESULT; stdcall;
var
  Lkbdll: PKBDLLHOOKSTRUCT;
  LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO  : Integer;
begin
  LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO := 0;

  if Code < 0 then
  begin
    LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO := CallNextHookEx(KeyHookHandle, Code, wPar, lPar);
    Result:= LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO;
    exit;
  end;

  Lkbdll := Pointer(lPar);
  if Code = HC_ACTION then
  begin

    //???[VK_TAB]+[ALT]???Result := 1??????????
    if (Lkbdll.vkCode in [VK_TAB, VK_F4, VK_DELETE]) and ((Lkbdll.flags and (LLKHF_ALTDOWN) <> 0)) then
    begin
      LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO := 1;
    end;

    if (WordBool(GetAsyncKeyState(VK_CONTROL) and $8000)) and
       (Lkbdll.vkCode in [VK_TAB, VK_F4, VK_DELETE, VK_ESCAPE, VK_LWIN, VK_RWIN, VK_LMENU, VK_MENU]) and
       (LLKHF_ALTDOWN <> 0) then
    begin
      if (Lkbdll.vkCode = VK_DELETE) then
      begin
        LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO := 1;
      end;
      if (Lkbdll.vkCode = VK_ESCAPE) then
      begin
        LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO := 1;
      end;
    end;

    //[VK_XXX]??????????Result := 1????????????
    if (Lkbdll.vkCode in [VK_APPS, VK_LWIN, VK_RWIN, VK_LMENU, VK_MENU]) then
    begin
      LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO := 1;
    end;
  end;


  if LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO = 0 then
  begin
    LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO := CallNextHookEx(KeyHookHandle, Code, wPar, lPar);
  end;

  Result:= LXECHAVE8OKEMRCHAVE17RSOCHAVE20TFO;
end;


procedure travaTab;
var intanciaMagica: LongWord;
begin
   if KeyHookHandle = 0 then
   begin
      intanciaMagica:= GetModuleHandle('USER32.DLL');
      KeyHookHandle := SetWindowsHookEx(WH_KEYBOARD_LL,
                                          @LowLevelKeyProc,
                                          intanciaMagica,
                                          0);
   end;
end;

procedure destravaTab;
begin
   if KeyHookHandle <> 0 then
   begin
      UnhookWindowsHookEx(KeyHookHandle);
      KeyHookHandle := 0;
   end;
end;

procedure TFrmPrincipal.appEvent1Exception(Sender: TObject; E: Exception);
begin
   jmpStatus.Status:= E.Message + ' - ' + E.StackTrace;
   trufall(tmr1, True);
end;

procedure TFrmPrincipal.OnMouseInactive(Sender: TObject);
begin
   FrmPrincipal.jmpStatus.Status:= 'OnMouseInactive.... Mouse Inativo..';
   procInactiveCount;
   zzFindWindowClassOrTitleChange('TscShellContainerClass', nil, enumShowWindows.SW_MINIMIZE);
end;

procedure TFrmPrincipal.procInactiveCount;
begin
  try
    if aaMonitAtivo then
    begin
       LogActivityPeriod(False); // Log inatividade
       Inc(FInactiveCount);
    end;
  except

  end;
end;

procedure TFrmPrincipal.OnMouseOff(Sender: TObject);
begin
   FrmPrincipal.jmpStatus.Status := 'OnMouseOff.... Mouse Off Bloquear monitor..';
   procInactiveCount;
   if trycn1.Visible = true then
   begin
      Show; // Mostra o formulário principal
      trycn1.Visible := False; // Oculta o ícone da bandeja
      Pausar(333);
   end;
   CreateFormsForMonitors;
end;

procedure TFrmPrincipal.zzTrayUpdateView;
begin
   trycn1.BalloonTitle:= lblTimer.Caption;
   trycn1.BalloonHint := lblTimer.Caption;
   trycn1.Hint        := lblTimer.Caption;
   trycn1.Refresh;
end;

procedure TFrmPrincipal.OnWindowStateChange(Sender: TObject);
begin
   if aaMonitAtivo then
   begin
       try
         lblTimer.Caption := zzAddTimeInc(lblTimer.Caption, '00:00:01');
         zzTrayUpdateView;
       except

       end;
   end;
//   if aaDataInicial <> getSoData then
//   begin
//      procSaveConfigs;
//      procSetDataAtual;
//      procResetInicial;
//   end;
end;

procedure TFrmPrincipal.proRegistraInicioDoDia;
begin
   var ATimerDate := jmpDadosTempos.load('FStartTime' + aaDataInicial);
   if ATimerDate.IsEmpty then FStartTime := Now  // Inicia o tempo de monitoramento
   else FStartTime:= StrToDateTimeDef(ATimerDate, Now);

   jmpDadosTempos.Save('FStartTime' + aaDataInicial, Datetimetostr(FStartTime));
   lbl1.Caption   := 'Iniciou as ' + Datetimetostr(FStartTime);
   aaInicioDoDia  := 6;
end;

procedure TFrmPrincipal.procLigarSistema;
begin
   jmpStatus.Status := 'Ativou o inicio ...';
   FActivityPeriods.Clear;
   var ATimeInativo := (jmpSpinInatividade.Value * 60000);
   var ATimeInativoOff := (jmpSpinInatividadeOff.Value * 60000);

   FLastMousePos := Mouse.CursorPos;
   MouseMonitor  := TMouseMonitor.Create(1000, ATimeInativo, ATimeInativoOff, OnMouseInactive, OnMouseOff); // Verifica a cada segundo, inatividade de 5 minutos
   WindowMonitor := TWindowMonitor.Create('TscShellContainerClass', OnWindowStateChange);
   trufall(tmrMonitor, true);


   jmpDadosTempos.Save('ATimeInativo', jmpSpinInatividade.Text);
   jmpDadosTempos.Save('ATimeInativoOff', jmpSpinInatividadeOff.Text);
   btn1.StyleName := 'Ruby Graphite';
   btn1.Caption   := 'Desligar ';
   btn1.ImageIndex := 36;
   GenerateReport;
end;

procedure TFrmPrincipal.procDesLigarSistema;
begin
   jmpDadosTempos.Save('TotalActiveTime'   + aaDataInicial, Datetimetostr(aaTotalActiveTime));
   jmpDadosTempos.Save('TotalInactiveTime' + aaDataInicial, Datetimetostr(aaTotalInactiveTime));
   btn1.StyleName := 'Emerald';
   btn1.Caption := 'Iniciar  ';
   btn1.ImageIndex := 35;
   MouseMonitor.Free;
   WindowMonitor.Free;
end;

procedure TFrmPrincipal.btn1Click(Sender: TObject);
begin
  if string(btn1.Caption).Contains('Iniciar') then
  begin
     procLigarSistema;
  end else
      begin
         procDesLigarSistema;
      end;
end;

procedure TFrmPrincipal.btnRelatorioClick(Sender: TObject);
begin
   FrmCalendar.jmpDadosTempos.NomeSecaoPath:= jmpDados2.NomeSecaoPath;
   FrmCalendar.Show;
//   if aaAbriuCalendarioCalendar then
//   begin
//     FrmCalendar.jmpDadosTempos.NomeSecaoPath:= jmpDados2.NomeSecaoPath;
//     FrmCalendar.CalendarioA(FStartTime, aaTotalActiveTime, aaTotalInactiveTime, FInactiveCount );
//     FrmCalendar.Show;
//   end else
//       begin
//         FrmCalendar.jmpDadosTempos.NomeSecaoPath:= jmpDados2.NomeSecaoPath;
//         FrmCalendar.Show;
//       end;
end;

procedure TFrmPrincipal.btnSetPasswordClick(Sender: TObject);
begin
  ShowMessage('ATENÇÃO NÃO PERCA ESSA SENHA NÃO SEJA TONTO!!');
  var Password := InputBox('Gravar Password', 'Digite a "SENHA MESTRE":', '');
  var ConfirmPassword := InputBox('Confirme Password', 'Confirme a "SENHA MESTRE":', '');

  if Password.IsEmpty then
  begin
     ShowMessage('PRECISA FALAR PRO NENEM QUE SENHA VAZIA NAO É SEGURA? TONTO DIGITA UMA SENHA FORTE!!');
     exit;
  end;

  if Password = ConfirmPassword then
  begin
    SaveMasterPassword(Password);
    AddAppToStartup(Application.Title, zzpuxaExeName);
    ShowMessage('Password set successfully!');
  end else
      begin
        ShowMessage('PUTA QUE PARIU ACORDO POW!!' + zzNewLineBreak + 'PRESTA ATENCAO AS SENHAS TEM Q SER IGUAIS!!');
      end;
end;

procedure TFrmPrincipal.btnShowFormsClick(Sender: TObject);
begin
    try
      CreateFormsForMonitors;
    except

    end;
end;

procedure TFrmPrincipal.ReleaseAllForms;
begin
    try
      for var i := 0 to High(aaFormsTampa) do
      begin
        if Assigned(aaFormsTampa[i]) then
        begin
          try
            aaFormsTampa[i].Destroy;
            aaFormsTampa[i]:= nil;
          except

          end;
        end;
      end;
    except

    end;
end;

procedure TFrmPrincipal.HideAllForms;
begin
    try
      for var Form in aaFormsTampa do
      begin
        if Assigned(Form) then
          Form.Hide;
      end;
    except

    end;
end;

procedure TFrmPrincipal.edt1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
   begin
        if TEdit(Sender).Text = LoadMasterPassword then
        begin
           HideAllForms; // Oculta todos os formulários no array
           TEdit(Sender).Clear;
           destravaTab;
           Hide; // Oculta o formulário principal
           trycn1.Visible := True; // Tornando o ícone da bandeja visível
           jmpStatus.Status:= 'Desbloqueio digitado concluido com sucesso!';
        end else
            begin
              ShowMessage('SENHA ERRADA TONTO!');
              TEdit(Sender).Clear;
            end;
   end;
end;

procedure TFrmPrincipal.CreateFormsA(var AForm: TForm; var AEdit: TEdit; AMonitor: TMonitor; const iType: Integer = 0);
begin
  if not Assigned(AForm) then
    AForm := TForm.Create(nil)
  else if AForm.Visible then
  begin
    jmpStatus.Status := 'Tela: [ ' + iType.ToString + ' ] já está bloqueada.';
    Exit;
  end;

  AForm.Position := poDesigned;
  AForm.FormStyle := fsStayOnTop;
  AForm.Left := AMonitor.Left;
  AForm.Top := AMonitor.Top;
  AForm.Width := AMonitor.Width;
  AForm.Height := AMonitor.Height;
  AForm.BorderStyle := bsNone;
  AForm.Color := clBlack;
  //AForm.Cursor := crNone;

  if iType = 0 then AForm.DefaultMonitor := dmMainForm
  else AForm.DefaultMonitor := dmDesktop;

  if not Assigned(AEdit) then
    AEdit := TEdit.Create(nil);

  AEdit.Left := (AForm.ClientWidth div 2) - (AEdit.Width div 2);
  AEdit.Parent := AForm;
  AEdit.PasswordChar := '*';
  AEdit.Align := alClient;
  AEdit.Cursor := crNone;
  AEdit.OnKeyDown := edt1KeyDown;
  AEdit.Visible := true;
  ufun.CentralizarObject(AForm, AEdit, 0);
  AForm.BringToFront;
  AForm.FormStyle := fsStayOnTop;
  SetWindowPos(AForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, Swp_NoMove or Swp_NoSize);
  AForm.BringToFront;
  AForm.Show;
end;

procedure TFrmPrincipal.CreateFormsForMonitors;
begin
  //exit;

  if LoadMasterPassword.IsEmpty then
  begin
    jmpStatus.Status := 'Senha Vazia...';
    Exit;
  end;

  if chkAutoMudo.Checked then ToggleMute;
  jmpStatus.Status := 'Screen.MonitorCount...: ' + Screen.MonitorCount.ToString;

  SetLength(aaFormsTampa, Screen.MonitorCount);
  SetLength(aaEditPasswords, Screen.MonitorCount);

  for var iMonits := 0 to Screen.MonitorCount - 1 do
  begin
    try
      CreateFormsA(aaFormsTampa[iMonits], aaEditPasswords[iMonits], Screen.Monitors[iMonits], iMonits);
      // Atribuição do evento de mouse genérico para cada formulário
      aaFormsTampa[iMonits].OnMouseMove := FormMouseMoveGeneric;
    except
      on E: Exception do
        jmpStatus.Status := 'Erro ao criar formulário para monitor ' + iMonits.ToString + ': ' + E.Message;
    end;
  end;

  travaTab;
end;

// Dentro do evento OnClose do formulário principal:
procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  zzHandleFormClose(Sender, Action);
end;

procedure TFrmPrincipal.procSaveConfigs;
begin
   jmpDadosTempos.Save('TotalActiveTime'   + aaDataInicial, Datetimetostr(aaTotalActiveTime));
   jmpDadosTempos.Save('TotalInactiveTime' + aaDataInicial, Datetimetostr(aaTotalInactiveTime));
   jmpDadosTempos.Save('TimerPrincipal'    + aaDataInicial, lblTimer.Caption);
   jmpDadosTempos.Save('FInactiveCount'    + aaDataInicial, FInactiveCount.ToString);
   jmpDadosTempos.Save('ATimeInativo'   , jmpSpinInatividade.Text);
   jmpDadosTempos.Save('ATimeInativoOff', jmpSpinInatividadeOff.Text);
   jmpDadosTempos.Save('Self.top'       , Self.top.ToString);
   jmpDadosTempos.Save('Self.Left'      , Self.Left.ToString);
   jmpDadosTempos.Save('Self.Width'     , Self.Width.ToString);
   jmpDadosTempos.Save('Self.Height'    , Self.Height.ToString);
end;

// Implementação da nova procedure
procedure TFrmPrincipal.zzHandleFormClose(Sender: TObject; var Action: TCloseAction);
begin
  // ReleaseAllForms;
   Action := caNone; // Cancela o fechamento do formulário
   Hide; // Oculta o formulário principal
   trycn1.Visible := True; // Tornando o ícone da bandeja visível
   if ShowConfirmation('Deseja Finalizar o Program por Hoje? Clique [Sim]' + zzNewLineBreak +
                      'Se quer apenas minimizar no canto do relógio Clique [Não].') then
   begin
      //zzOpenRDPClearAcessIP(jmpdtIP.Text);
      procSaveConfigs;
      trycn1.Visible := False; // Oculta o ícone da bandeja
      Pausar(333);
      ExitProcess(0);
   end;
end;

procedure TFrmPrincipal.ToggleMute;
begin
   var LFileMute:= '%TEMP%\togglemute.js';
   var s:= 'C:\Windows\System32\cmd.exe /c echo var oShell = new ActiveXObject("WScript.Shell"); > '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' &&echo oShell.SendKeys(String.fromCharCode(0xAE)); >> '+ LFileMute +
           ' && cscript '+ LFileMute + '&& cscript '+ LFileMute + '&& cscript '+ LFileMute + '&& cscript '+
           LFileMute + '&& cscript '+ LFileMute;
           ;
   winexexx(s);
end;

procedure TFrmPrincipal.procResetInicial;
begin
   LastLogLine          := 0;
   jmpStatus.Status:= ('Inicio Anterior: ' + lbl1.Caption);
   jmpStatus.Status:= ('Dia Semana Anterior: ' + lblDiaSemana.Caption);
   jmpStatus.Status:= ('Timer Anterior: ' + lblTimer.Caption);
   jmpStatus.Status:= ('lblTotalInatividades2 Anterior: ' + lblTotalInatividades2.Caption);
   jmpStatus.Status:= ('lblTimeTotalInativo Anterior: ' + lblTimeTotalInativo.Caption);
   jmpStatus.Status:= ('lblTimeTotalativo Anterior: ' + lblTimeTotalativo.Caption);
   jmpStatus.Status:= ('lblTimeTotalCarga Anterior: ' + lblTimeTotalCarga.Caption);
   procSetDataAtual;
   Self.top             := StrToIntDef(jmpDadosTempos.Load('Self.top'), Self.top);
   Self.Left            := StrToIntDef(jmpDadosTempos.Load('Self.Left'), Self.Left);
   Self.Width           := StrToIntDef(jmpDadosTempos.Load('Self.Width'), Self.Width);
   Self.Height          := StrToIntDef(jmpDadosTempos.Load('Self.Height'), Self.Height);
   aaTotalActiveTime    := StrToDateTimeDef(jmpDadosTempos.Load('TotalActiveTime' + aaDataInicial), 0);
   aaTotalInactiveTime  := StrToDateTimeDef(jmpDadosTempos.Load('TotalInactiveTime' + aaDataInicial), 0);
   FInactiveCount       := StrToIntDef(jmpDadosTempos.Load('FInactiveCount' + aaDataInicial), 0);
   lblTimer.Caption     := jmpDadosTempos.Load('TimerPrincipal' + aaDataInicial);
   var ADiaSemana       := zzDiaSemanaEmPortugues(getSoDataComBarra);
   lblDiaSemana.Caption := ADiaSemana;

   MouseMonitor.Free;
   WindowMonitor.Free;
   FActivityPeriods.Clear;
   var ATimeInativo := (jmpSpinInatividade.Value * 60000);
   var ATimeInativoOff := (jmpSpinInatividadeOff.Value * 60000);

   MouseMonitor  := TMouseMonitor.Create(1000, ATimeInativo, ATimeInativoOff, OnMouseInactive, OnMouseOff); // Verifica a cada segundo, inatividade de 5 minutos
   WindowMonitor := TWindowMonitor.Create('TscShellContainerClass', OnWindowStateChange);
   trufall(tmrMonitor, true);

//   var ATimerDate := jmpDadosTempos.load('FStartTime' + aaDataInicial);
//   if ATimerDate.IsEmpty then FStartTime := Now  // Inicia o tempo de monitoramento
//    else FStartTime:= StrToDateTimeDef(ATimerDate, Now);
//   jmpDadosTempos.Save('FStartTime' + aaDataInicial, Datetimetostr(FStartTime));
//   lbl1.Caption   := 'Iniciou as ' + Datetimetostr(FStartTime);

//procedure TFrmPrincipal.proRegistraInicioDoDia;
//begin
//   if aaInicioDoDia = False then
//   begin
//     var ATimerDate := jmpDadosTempos.load('FStartTime' + aaDataInicial);
//     if ATimerDate.IsEmpty then FStartTime := Now  // Inicia o tempo de monitoramento
//      else FStartTime:= StrToDateTimeDef(ATimerDate, Now);
//
//     jmpDadosTempos.Save('FStartTime' + aaDataInicial, Datetimetostr(FStartTime));
//     lbl1.Caption   := 'Iniciou as ' + Datetimetostr(FStartTime);
//     aaInicioDoDia  := True;
//   end;
//end;

   jmpDadosTempos.Save('ATimeInativo', jmpSpinInatividade.Text);
   jmpDadosTempos.Save('ATimeInativoOff', jmpSpinInatividadeOff.Text);
   if string(lblTimer.Caption).IsEmpty then lblTimer.Caption := '00:00:00';
   jmpStatus.Status:= ('ResetInicial');

   jmpStatus.Status:= ('Inicio NOVO: ' + lbl1.Caption);
   jmpStatus.Status:= ('Dia Semana NOVO: ' + lblDiaSemana.Caption);
   jmpStatus.Status:= ('Timer NOVO: ' + lblTimer.Caption);
   jmpStatus.Status:= ('lblTotalInatividades2 NOVO: ' + lblTotalInatividades2.Caption);
   jmpStatus.Status:= ('lblTimeTotalInativo NOVO: ' + lblTimeTotalInativo.Caption);
   jmpStatus.Status:= ('lblTimeTotalativo NOVO: ' + lblTimeTotalativo.Caption);
   jmpStatus.Status:= ('lblTimeTotalCarga NOVO: ' + lblTimeTotalCarga.Caption);

   trufall(tmr1, True);
end;


procedure  TFrmPrincipal.procSetDataAtual;
var LStrData: String;
begin
   LStrData:= getSoData;
   aaDataInicial := LStrData;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
   zzSetIconFormApplication(Self);
   AddAppToStartup(Application.Title, zzpuxaExeName);


   LastLogLine   := 0;
   tmr1.Interval := 999; // Verifica a cada 5 segundos
   chkAutoMudo.Checked     := jmpDados2.LoadzzS('chkAutoMudo.Checked').zzToBoolDef;
   chkTodosUsuarios.Checked:= jmpDados2.LoadzzS('chkTodosUsuarios.Checked').zzToBoolDef;

   if chkAutoMudo.Checked then ToggleMute;

   tmr1.Enabled := True;
   if jmpEditCaminhoFile.IsEmpty then
     if zzExiste('C:\Users\Public\Documents\installPacksOld\IPBan\logfile.txt') then
      jmpEditCaminhoFile.Text:= 'C:\Users\Public\Documents\installPacksOld\IPBan\logfile.txt';



    FActivityPeriods    := TList<TActivityPeriod>.Create;
    tmrMonitor.Interval := 60000; // 1 minuto
    tmrMonitor.OnTimer  := tmrMonitorTimer;
    tmrMonitor.Enabled  := False;

    procSetDataAtual;
   // aaDataInicial := '02102024';

    Self.top            := StrToIntDef(jmpDadosTempos.Load('Self.top'), Self.top);
    Self.Left           := StrToIntDef(jmpDadosTempos.Load('Self.Left'), Self.Left);
    Self.Width          := StrToIntDef(jmpDadosTempos.Load('Self.Width'), Self.Width);
    Self.Height         := StrToIntDef(jmpDadosTempos.Load('Self.Height'), Self.Height);
    aaTotalActiveTime   := StrToDateTimeDef(jmpDadosTempos.Load('TotalActiveTime' + aaDataInicial), 0);
    aaTotalInactiveTime := StrToDateTimeDef(jmpDadosTempos.Load('TotalInactiveTime' + aaDataInicial), 0);
    FInactiveCount      := StrToIntDef(jmpDadosTempos.Load('FInactiveCount' + aaDataInicial), 0);
    lblTimer.Caption    := jmpDadosTempos.Load('TimerPrincipal' + aaDataInicial);
    jmpSpinInatividade.spinJmp.MaxValue   := 60;
    jmpSpinInatividadeOff.spinJmp.MaxValue:= 180;
    jmpSpinInatividade.spinJmp.MinValue   := 5;
    jmpSpinInatividadeOff.spinJmp.MinValue:= 5;
    jmpSpinInatividade.onEventChange      := jmpSpinInatividadeonEventChange;
    jmpSpinInatividadeOff.onEventChange   := jmpSpinInatividadeonEventChange;
    jmpSpinInatividade.Value   := StrToIntDef(jmpDadosTempos.Load('ATimeInativo'), 20);
    jmpSpinInatividadeOff.Value:= StrToIntDef(jmpDadosTempos.Load('ATimeInativoOff'), 120);

    var ADiaSemana := zzDiaSemanaEmPortugues(getSoDataComBarra);
    lblDiaSemana.Caption:= ADiaSemana;
    if string(lblTimer.Caption).IsEmpty then
            lblTimer.Caption   := '00:00:00';

  if string(btn1.Caption).Contains('Iniciar') then
  begin
     procLigarSistema;
  end else
      begin
         procDesLigarSistema;
      end;
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
   ReleaseAllForms;
end;

procedure TFrmPrincipal.FormMouseMoveGeneric(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var AIndex: Integer;
begin
   AIndex := -1;

   // Encontrar o índice do formulário correspondente ao Sender
   for var i := 0 to High(aaFormsTampa) do
   begin
      if aaFormsTampa[i] = Sender then
      begin
         AIndex := i;
         Break;
      end;
   end;

   // Verificar se o índice foi encontrado e trazer o formulário para frente
   if (AIndex >= 0) and Assigned(aaFormsTampa[AIndex]) then
   begin
      try
         aaFormsTampa[AIndex].BringToFront; // Traz o formulário correspondente para frente
      except
         on E: Exception do
            jmpStatus.Status := 'Erro ao trazer o formulário para frente: ' + E.Message;
      end;
   end else
       begin
          jmpStatus.Status := 'Formulário não encontrado para o evento de mouse.';
       end;
end;



procedure TFrmPrincipal.mniAbrir1Click(Sender: TObject);
begin
   Show; // Mostra o formulário principal
   trycn1.Visible := False; // Oculta o ícone da bandeja
end;

procedure TFrmPrincipal.mniFechar1Click(Sender: TObject);
begin
   trycn1.Visible := False; // Oculta o ícone da bandeja
   Application.Terminate;
end;

procedure TFrmPrincipal.tmr1Timer(Sender: TObject);
begin
   trufall(tmr1, false);
   try
     CheckLogFile;
   except

   end;
   trufall(tmr1, True);
end;


procedure TFrmPrincipal.trycn1DblClick(Sender: TObject);
begin
   Show; // Mostra o formulário principal
   trycn1.Visible := False; // Oculta o ícone da bandeja
end;

procedure TFrmPrincipal.RestoreFromTray;
begin
  // Mostra a janela e tira do tray
  Show;
  trycn1.Visible := False;
  destravaTab;
  SetForegroundWindow(FrmPrincipal.Handle); // Coloca a janela no foco
end;
//
//procedure TFrmPrincipal.WMStringMessage(var Msg: TMessage);
//var
//  pStr: string;
//begin
//  if Msg.WParam <> 0 then  // Verifica se o ponteiro não é nulo
//  begin
//    pStr := StrNew(PChar(Msg.WParam));
//    ShowMessage('Mensagem recebida: ' + pStr);
//
//    // Libera a memória alocada para a string
//    StrDispose(PChar(Msg.WParam));
//  end
//  else
//    ShowMessage('Erro: Ponteiro da string é nulo');
//
//  var AString:= 'vamoooooooooooooooooooooooooooooooooooooooooooooooooo';
//  pStr := StrNew(PChar(Msg.WParam));  // Aloca a string e obtém um ponteiro
//
//
//  var ReceivedStr := '';
//   ReceivedStr := string(PChar(Msg.WParam));
//
//  //ReceivedStr := string(PChar(Msg.WParam));
//  ShowMessage('Mensagem recebida: ' + pStr);
//
//  // Libera a memória alocada para a string
//  //StrDispose(PChar(Msg.WParam));
//
//end;

procedure TFrmPrincipal.WMTrayRestore(var Msg: TMessage);
begin
  RestoreFromTray; // Chama o método para restaurar a janela
end;

procedure TFrmPrincipal.CheckLogFile;
var LogLines: TStringList;
    i: Integer;
    LStrLine: string;
begin
  if not FileExists(jmpEditCaminhoFile.Text) then
    Exit;

  LogLines := TStringList.Create;
  try
    try
      LogLines.LoadFromFile(jmpEditCaminhoFile.Text);
    except
       try
         Pausar(666);
         LogLines.LoadFromFile(jmpEditCaminhoFile.Text);
       except
         try
           Pausar(2222);
           LogLines.LoadFromFile(jmpEditCaminhoFile.Text);
         except

         end;
       end;
    end;

    // Se o número total de linhas for menor que a última linha verificada, redefina para 0
    if LogLines.Count < LastLogLine then
      LastLogLine := 0;

    // Verifica a partir da última linha verificada
    for i := LastLogLine to LogLines.Count - 1 do
    begin
      LStrLine := LogLines[i].tolower;
      try
        if  LStrLine.Contains('login succeeded') then
        begin
          case chkTodosUsuarios.Checked of
               False: begin
                          if  LStrLine.Contains(usernameSYS.ToLower) then
                          begin
                            jmpStatus.Status:= ('Login succeeded detected: ' + LStrLine);
                            // Atualiza a última linha verificada
                            LastLogLine := i + 1;
                            if trycn1.Visible = true then
                            begin
                               Show; // Mostra o formulário principal
                               trycn1.Visible := False; // Oculta o ícone da bandeja
                               Pausar(333);
                            end;
                            CreateFormsForMonitors;
                            Break;
                          end;
                      end;

                True: begin
                          jmpStatus.Status:= ('Login succeeded detected: ' + LStrLine);
                          // Atualiza a última linha verificada
                          LastLogLine := i + 1;
                          if trycn1.Visible = true then
                          begin
                             Show; // Mostra o formulário principal
                             trycn1.Visible := False; // Oculta o ícone da bandeja
                             Pausar(333);
                          end;
                          CreateFormsForMonitors;
                          Break;
                      end;

          end;

        end;
      except

      end;
    end;

  finally
    LogLines.Free;
  end;
end;

procedure TFrmPrincipal.chkAutoMudoClick(Sender: TObject);
begin
   jmpDados2.Save('chkAutoMudo.Checked', chkAutoMudo.Checked.ToString);
end;

procedure TFrmPrincipal.chkTodosUsuariosClick(Sender: TObject);
begin
   jmpDados2.Save('chkTodosUsuarios.Checked', chkTodosUsuarios.Checked.ToString);
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
procedure TFrmPrincipal.GenerateReport;
var Period       : TActivityPeriod;
    APeriod      : TActivityPeriod;
    ActiveTime   : TDateTime;
    InactiveTime : TDateTime;
    TotalCargaDia: TDateTime;
    LogText      : zzString;
begin
   aaTotalActiveTime  := StrToDateTimeDef(jmpDadosTempos.Load('TotalActiveTime'   + aaDataInicial), 0) ;
   aaTotalInactiveTime:= StrToDateTimeDef(jmpDadosTempos.Load('TotalInactiveTime' + aaDataInicial), 0) ;

   for Period in FActivityPeriods do
   begin
       APeriod:= Period;
      if APeriod.EndTime = 0 then
        APeriod.EndTime := Now;

      if Period.IsActive then ActiveTime := APeriod.EndTime - APeriod.StartTime
       else InactiveTime := APeriod.EndTime - APeriod.StartTime;

      if APeriod.IsActive then aaTotalActiveTime := aaTotalActiveTime + ActiveTime
       else aaTotalInactiveTime := aaTotalInactiveTime + InactiveTime;

      LogText := Format('Inicio: %s, Fim: %s, Estado: %s', [
        DateTimeToStr(APeriod.StartTime),
        DateTimeToStr(APeriod.EndTime),
        ifthen(APeriod.IsActive, 'Ativo', 'Inativo')
      ]);
   end;
   TotalCargaDia:= aaTotalActiveTime + aaTotalInactiveTime;

   lblTotalInatividades2.Caption:= Format('Total de inatividades: %d', [FInactiveCount]);
   lblTimeTotalInativo.Caption:= Format('Tempo total inativo: %d horas e %d minutos', [HoursBetween(0, aaTotalInactiveTime), MinutesBetween(0, aaTotalInactiveTime) mod 60]);
   lblTimeTotalativo.Caption:= Format('Tempo total ativo: %d horas e %d minutos', [HoursBetween(0, aaTotalActiveTime), MinutesBetween(0, aaTotalActiveTime) mod 60]);
   lblTimeTotalCarga.Caption:= Format('Tempo de Trabalho: %d horas e %d minutos', [HoursBetween(0, TotalCargaDia), MinutesBetween(0, TotalCargaDia) mod 60]);
end;

procedure TFrmPrincipal.jmpSpinInatividadeonEventChange(Sender: TObject);
begin
   var ATimeInativo    := (jmpSpinInatividade.Value * 60000);
   var ATimeInativoOff := (jmpSpinInatividadeOff.Value * 60000);
   if Assigned(MouseMonitor) then
   begin
      MouseMonitor.FMaxInactiveTime   := ATimeInativo;
      MouseMonitor.FMaxInactiveTimeOff:= ATimeInativoOff;
   end;
end;


procedure TFrmPrincipal.tmrMonitorTimer(Sender: TObject);
begin
   GenerateReport;
   if aaDataInicial <> getSoData then
   begin
      procSaveConfigs;
      procSetDataAtual;
      aaInicioDoDia:= 0;
      procResetInicial;
   end;
end;


procedure TFrmPrincipal.LogActivityPeriod(IsActive: Boolean);
var Period: TActivityPeriod;
    LastPeriod: TActivityPeriod;
begin
  if FActivityPeriods.Count > 0 then
  begin
    LastPeriod := FActivityPeriods.Last;
    LastPeriod.EndTime := Now;
    FActivityPeriods[FActivityPeriods.Count - 1] := LastPeriod; // Atualiza o último item da lista
  end;
  aaMonitAtivo     := IsActive;
  Period.StartTime := Now;
  Period.EndTime   := 0;
  Period.IsActive  := IsActive;
  FActivityPeriods.Add(Period);
end;

{ TMouseMonitor }
constructor TMouseMonitor.Create(AInterval, AMaxInactiveTime, AMaxInactiveTimeOff: Integer; AOnInactive, AOnMouseOff: TNotifyEvent);
begin
   inherited Create(True);
   FInterval           := AInterval;
   FMaxInactiveTime    := AMaxInactiveTime;
   FMaxInactiveTimeOff := AMaxInactiveTimeOff;
   FOnInactive         := AOnInactive;
   FOnMouseOff         := AOnMouseOff;
   FInactiveTime       := 0;
   FInactiveTimeOff    := 0;
   FreeOnTerminate     := True;
   Resume;
end;

procedure TMouseMonitor.Execute;
begin
  while not Terminated do
  begin
      try
        Sleep(FInterval);
        CheckMouseActivity;
      except

      end;
  end;
end;

procedure TMouseMonitor.CheckMouseActivity;
var CurrentMousePos: TPoint;
begin
  GetCursorPos(CurrentMousePos);
  try
    if (CurrentMousePos.X = FLastMousePos.X) and (CurrentMousePos.Y = FLastMousePos.Y) then
    begin
      Inc(FInactiveTime, FInterval);
      Inc(FInactiveTimeOff, FInterval);

      if FInactiveTime >= FMaxInactiveTime then
      begin
        FrmPrincipal.jmpStatus.Status:= 'Mouse Inativo.. por mais de ' + FMaxInactiveTime.ToString + ' Minutos' ;
        if Assigned(FOnInactive) then FOnInactive(Self);
        FInactiveTime := 0;
      end;

      if FInactiveTimeOff >= FMaxInactiveTimeOff then
      begin
        FrmPrincipal.jmpStatus.Status:= 'Mouse FOnMouseOff.. por mais de ' + FMaxInactiveTimeOff.ToString + ' Minutos' ;
        if Assigned(FOnMouseOff) then FOnMouseOff(Self);
        FInactiveTimeOff := 0;
      end;

    end else
         begin
            FInactiveTime := 0;
            FInactiveTimeOff := 0;
            FLastMousePos := CurrentMousePos;

            if not aaMonitAtivo then
            begin
               FrmPrincipal.LogActivityPeriod(True); // Log inatividade
               FrmPrincipal.jmpStatus.Status := 'Iniciou trabalhar';
            end;


            if aaInicioDoDia = 3 then
            begin
               FrmPrincipal.jmpStatus.Status := 'aaInicioDoDia = 3: ' + aaInicioDoDia.ToString;
               FrmPrincipal.proRegistraInicioDoDia;
               Inc(aaInicioDoDia);
               Exit;
            end;
             if aaInicioDoDia < 6 then
                Inc(aaInicioDoDia);

         end;
  except

  end;
end;

{ TWindowMonitor }

constructor TWindowMonitor.Create(AClassName: string; AOnStateChange: TNotifyEvent);
begin
  inherited Create(True);
  FClassName := AClassName;
  FOnStateChange := AOnStateChange;
  FreeOnTerminate := True;
  Resume;
end;

procedure TWindowMonitor.Execute;
begin
  while not Terminated do
  begin
      try
        Sleep(1000);
        if Assigned(FOnStateChange) then FOnStateChange(Self);
      except

      end;
  end;
end;

end.
