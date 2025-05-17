object FrmCalendar: TFrmCalendar
  Left = 0
  Top = 0
  Caption = 'Visualizador Temporario Horarios'
  ClientHeight = 751
  ClientWidth = 1350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlJmp: TPanel
    Left = 0
    Top = 0
    Width = 1350
    Height = 751
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object pnlCalendario: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 603
      Width = 1344
      Height = 144
      Align = alTop
      ParentColor = True
      TabOrder = 0
    end
    object pnlCalendario4: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 1344
      Height = 144
      Align = alTop
      ParentColor = True
      TabOrder = 1
    end
    object pnlCalendario1: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 453
      Width = 1344
      Height = 144
      Align = alTop
      ParentColor = True
      TabOrder = 2
    end
    object pnlCalendario2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 303
      Width = 1344
      Height = 144
      Align = alTop
      ParentColor = True
      TabOrder = 3
    end
    object pnlCalendario3: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 153
      Width = 1344
      Height = 144
      Align = alTop
      ParentColor = True
      TabOrder = 4
    end
    object pnlOculto: TPanel
      Left = 752
      Top = 112
      Width = 497
      Height = 291
      ParentColor = True
      TabOrder = 5
      Visible = False
      object Panel1: TPanel
        Left = -126
        Top = 66
        Width = 799
        Height = 192
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        ParentColor = True
        TabOrder = 0
        object lblTimeTotalativo: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 115
          Width = 791
          Height = 19
          Align = alTop
          Alignment = taCenter
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellowgreen
          Font.Height = -15
          Font.Name = 'Source Code Pro Black'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          ParentFont = False
          StyleElements = [seClient, seBorder]
          ExplicitWidth = 27
        end
        object lblTimeTotalInativo: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 89
          Width = 791
          Height = 20
          Align = alTop
          Alignment = taCenter
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clDarkorange
          Font.Height = -15
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          ParentFont = False
          StyleElements = [seClient, seBorder]
          ExplicitWidth = 12
        end
        object lblTotalInatividades2: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 34
          Width = 791
          Height = 18
          Align = alTop
          Alignment = taCenter
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clOrangered
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          ParentFont = False
          StyleElements = [seClient, seBorder]
          ExplicitWidth = 15
        end
        object lblIniciouDias: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 61
          Width = 791
          Height = 19
          Margins.Top = 6
          Margins.Bottom = 6
          Align = alTop
          Alignment = taCenter
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clSalmon
          Font.Height = -15
          Font.Name = 'Source Code Pro Black'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          ParentFont = False
          StyleElements = [seClient, seBorder]
          ExplicitWidth = 27
        end
        object lblDataSelecao: TLabel
          Left = 1
          Top = 1
          Width = 797
          Height = 30
          Margins.Bottom = 6
          Align = alTop
          Alignment = taCenter
          Caption = '00/00/0000'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          Font.Quality = fqAntialiased
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 114
        end
        object btn1: TButton
          Left = 144
          Top = 24
          Width = 75
          Height = 25
          Caption = 'btn1'
          TabOrder = 0
          Visible = False
          OnClick = btn1Click
        end
      end
    end
  end
  object jmpDadosTempos: TJmpDados
    NomeSecaoPath = 'SENHA_MESTRE_'
    Left = 200
    Top = 8
  end
end
