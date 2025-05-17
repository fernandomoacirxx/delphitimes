object FrameCalendario: TFrameCalendario
  Left = 0
  Top = 0
  Width = 170
  Height = 144
  TabOrder = 0
  object pnlDataDia: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 27
    Width = 170
    Height = 108
    Cursor = crHandPoint
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    Caption = '15'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = True
    ParentFont = False
    TabOrder = 0
    VerticalAlignment = taAlignTop
    ExplicitHeight = 130
    object pnlJmpCalendarioDia: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 25
      Width = 170
      Height = 83
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 25
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      ExplicitHeight = 105
      object lblIniciouDias: TLabel
        AlignWithMargins = True
        Left = 1
        Top = 2
        Width = 168
        Height = 16
        Cursor = crHandPoint
        Margins.Left = 1
        Margins.Top = 2
        Margins.Right = 1
        Margins.Bottom = 1
        Align = alTop
        Alignment = taCenter
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsUnderline]
        Font.Quality = fqClearTypeNatural
        ParentFont = False
        StyleElements = [seClient, seBorder]
        ExplicitWidth = 15
      end
      object lblTotalInatividades2: TLabel
        AlignWithMargins = True
        Left = 1
        Top = 20
        Width = 168
        Height = 18
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 0
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
      object lblTimeTotalInativo: TLabel
        AlignWithMargins = True
        Left = 1
        Top = 39
        Width = 168
        Height = 20
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 0
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
      object lblTimeTotalativo: TLabel
        AlignWithMargins = True
        Left = 1
        Top = 60
        Width = 168
        Height = 20
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 0
        Align = alTop
        Alignment = taCenter
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellowgreen
        Font.Height = -15
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        ParentFont = False
        StyleElements = [seClient, seBorder]
        ExplicitWidth = 12
      end
    end
  end
  object pnlDestaque: TPanel
    AlignWithMargins = True
    Left = 15
    Top = 138
    Width = 140
    Height = 5
    Margins.Left = 15
    Margins.Right = 15
    Margins.Bottom = 1
    Align = alBottom
    Color = clAquamarine
    ParentBackground = False
    TabOrder = 1
    StyleElements = [seFont, seBorder]
    ExplicitTop = 160
  end
  object pnlTopoDate: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 164
    Height = 21
    Align = alTop
    ParentColor = True
    TabOrder = 2
    object lblSemana: TLabel
      Left = 1
      Top = 1
      Width = 162
      Height = 19
      Align = alClient
      Alignment = taCenter
      Caption = 'SEG'
      Font.Charset = ANSI_CHARSET
      Font.Color = clMedGray
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = [seClient, seBorder]
      ExplicitWidth = 35
      ExplicitHeight = 18
    end
  end
end
