unit uFrameCalendario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFrameCalendario = class(TFrame)
    pnlDataDia: TPanel;
    pnlDestaque: TPanel;
    pnlJmpCalendarioDia: TPanel;
    lblIniciouDias: TLabel;
    lblTotalInatividades2: TLabel;
    lblTimeTotalInativo: TLabel;
    lblTimeTotalativo: TLabel;
    pnlTopoDate: TPanel;
    lblSemana: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}


end.
