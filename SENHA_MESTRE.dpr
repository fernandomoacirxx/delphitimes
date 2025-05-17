program SENHA_MESTRE;

uses
  Winapi.Windows,
  Vcl.Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {FrmPrincipal},
  Vcl.Themes,
  Winapi.ShellAPI,
  Winapi.Messages,
  Vcl.Styles,
  uRegistryUtils in 'uRegistryUtils.pas',
  uMonitorUtils in 'uMonitorUtils.pas',
  System.SysUtils,
  uFrameCalendario in 'uFrameCalendario.pas' {FrameCalendario: TFrame},
  uFrmCalendar in 'uFrmCalendar.pas' {FrmCalendar},
  dmJmpImagemList32 in '..\PackageJumper\dmJmpImagemList32.pas' {JmpImagemList32: TDataModule};

{$R *.res}
{(*}
var
  hMutex: THandle;

function IsAlreadyRunning: Boolean;
begin
  hMutex := CreateMutex(nil, False, 'SENHA_MESTRE_UnicoTray'); // Nome único do mutex
  Result := (hMutex <> 0) and (GetLastError = ERROR_ALREADY_EXISTS);
end;

procedure SendRestoreMessage;
var
  AhWnd: HWND;
 //pStr: PChar;
begin
  Application.Title:= '[ SENHA MESTRE ]';
  var AMyTitle:= Application.Title;
  Application.Title:= '';
  AhWnd := FindWindow(nil, PChar(AMyTitle)); // Busca pela janela da aplicação
  if AhWnd <> 0 then
  begin
     PostMessage(AhWnd, WM_TRAY_RESTORE, 0, 0); // Envia a mensagem personalizada
    // var AString:= 'vamoooooooooooooooooooooooooooooooooooooooooooooooooo';
     //pStr := StrNew(PChar(AString));  // Aloca a string e obtém um ponteiro
    // PostMessage(AhWnd, WM_STRING_MESSAGE, WPARAM(pStr), 0); // Envia o ponteiro da string como WPARAM
  end;

  Application.Title:= AMyTitle;
 end;



begin
  if IsAlreadyRunning then
  begin
    SendRestoreMessage;  // Restaura a aplicação se já estiver rodando no tray
    Halt;             // Fecha a nova instância
  end else
    begin
      Application.Initialize;
      Application.MainFormOnTaskbar := True;
      TStyleManager.TrySetStyle('Glow');
      Application.CreateForm(TFrmPrincipal, FrmPrincipal);
      Application.CreateForm(TFrmCalendar, FrmCalendar);
      Application.Run;
    end;



end.
