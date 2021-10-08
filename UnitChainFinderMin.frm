object _FormChainFinder: T_FormChainFinder
  Left = 303
  Height = 454
  Top = 171
  Width = 709
  Caption = 'Chain Finder Min'
  ClientHeight = 420
  ClientWidth = 709
  Color = clBtnFace
  DesignTimePPI = 120
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Icon.Data = {
    FE0200000000010001002020100000000000E802000016000000280000002000
    0000400000000100040000000000800200000000000000000000000000000000
    0000000000000000800000800000008080008000000080008000808000008080
    8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
    FF000000000000000000CCC00000000999000000000000000000C0CC00000099
    09000000000000000000C000CC00090009000000000000000000CC000CC09000
    99000000000000000000CC0071C90000990000000000000000000CC7111C2229
    9000000000000000000222771170C02222200000000000000222002518100C09
    002200000000000022000071007000CC000000000000000002220011001077CC
    0022000000000000002222977019170C22220077777880000000098771977220
    CC000000000000000000099007777000CC0000777778800000079900009C0000
    CC00007777788000000790000990C0000C000077777880000007900990000C00
    CC0000777778800000079999900000CCCC00007777788000000709900000000C
    C000007777788000000777788000000000000077777880778807777880000000
    0000007777780000000777788000000000000077777807778807777880000000
    0000007777780000000777788000000000000077777880000077777880000000
    0000000000000000000000000000000000000000778888000777888000000000
    0000000000000000000000000000000000000000007770000077700000000000
    0000000000000000000000000000000000000000077777000777770000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000FFFF1FE3FFFF4FCBFFFF73BBFFFF3973FFFF30F3FFFF8007FFFE0001FFF8
    C00CFFF3C00FFFF8C00C803C0020803F8013803D9873803C3CF3803C797B803C
    67B3803C07C3803C9BE7800003FF800003FF800003FF800003FF800003FF8000
    03FF801003FFE0100FFFE0100FFFF8383FFFF8383FFFF0101FFFF0101FFFFFFF
    FFFF
  }
  KeyPreview = True
  Menu = MainMenu
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '7.5'
  object Label2FocusChains: TLabel
    Left = 0
    Height = 17
    Top = 150
    Width = 709
    Align = alTop
    Caption = '     C&hain(s) found'
    FocusControl = TreeView
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    ParentFont = False
  end
  object PanelTop: TPanel
    Left = 0
    Height = 150
    Top = 0
    Width = 709
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ClientHeight = 150
    ClientWidth = 709
    Constraints.MinWidth = 412
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    ParentFont = False
    TabOrder = 0
    object LabelInfo: TLabel
      Left = 2
      Height = 17
      Top = 131
      Width = 705
      Align = alBottom
      Caption = '-'
      Font.CharSet = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Layout = tlCenter
      ParentFont = False
    end
    object LabelMaxDepth: TLabel
      Left = 220
      Height = 17
      Top = 80
      Width = 74
      Caption = 'Max.&depth'
      FocusControl = EditMaxStepNo
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
    end
    object LabelMaxTime: TLabel
      Left = 380
      Height = 17
      Top = 80
      Width = 100
      Caption = 'Max time, &min'
      FocusControl = EditMaxTime
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
    end
    object LabelStartState: TLabel
      Left = 90
      Height = 17
      Top = 0
      Width = 73
      Caption = '&Start state'
      FocusControl = EditStart
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
    end
    object LabelFinishState: TLabel
      Left = 480
      Height = 17
      Top = 0
      Width = 79
      Caption = '&Finish state'
      FocusControl = EditFinish
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
    end
    object CheckBoxCapture: TCheckBox
      Left = 2
      Height = 21
      Top = 50
      Width = 80
      Caption = '&Capture'
      Checked = True
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      State = cbChecked
      TabOrder = 2
    end
    object CheckBoxDecay: TCheckBox
      Left = 181
      Height = 21
      Top = 50
      Width = 68
      Caption = 'D&ecay'
      Checked = True
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      State = cbChecked
      TabOrder = 3
    end
    object CheckBoxFission: TCheckBox
      Left = 352
      Height = 21
      Top = 50
      Width = 70
      Caption = 'F&ission'
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      TabOrder = 4
    end
    object CheckBoxThreshold: TCheckBox
      Left = 525
      Height = 21
      Top = 50
      Width = 94
      Caption = '&Threshold'
      Checked = True
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      State = cbChecked
      TabOrder = 5
    end
    object EditStart: TComboBox
      Left = 70
      Height = 29
      Top = 20
      Width = 151
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ItemHeight = 0
      OnKeyDown = EditKeyDown
      ParentFont = False
      TabOrder = 0
    end
    object EditFinish: TComboBox
      Left = 455
      Height = 29
      Top = 20
      Width = 151
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ItemHeight = 0
      OnKeyDown = EditKeyDown
      ParentFont = False
      TabOrder = 1
    end
    object CheckBoxClearFound: TCheckBox
      Left = 10
      Height = 21
      Top = 155
      Width = 106
      Caption = 'Clea&r found'
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      TabOrder = 8
    end
    object EditMaxTime: TSpinEdit
      Left = 380
      Height = 29
      Top = 100
      Width = 80
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      MaxValue = 100000
      MinValue = 1
      ParentFont = False
      TabOrder = 7
      Value = 3
    end
    object EditMaxStepNo: TSpinEdit
      Left = 220
      Height = 29
      Top = 100
      Width = 80
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      MaxValue = 10000000
      MinValue = 2
      ParentFont = False
      TabOrder = 6
      Value = 100
    end
    object SpeedButtonInfo: TSpeedButton
      Left = 640
      Height = 40
      Top = 5
      Width = 40
      Flat = True
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888800008888888444444888888800008888844444444448888800008888
        4446FF644444888800008884444FFFF64444488800008844444FF64844444488
        000088444446FF4444444488010184444444FF64444444480833844444446FF4
        444444480000844444444FF64444444800008444444846FF4444444800008444
        4446FFFF444444480000844444446FF644444448000088444444444444444488
        00008844444444664444448800008884444446FF6444488800008888444446FF
        6444888800008888844444664448888800008888888444444888888800008888
        88888888888888880000
      }
      OnClick = SpeedButtonInfoClick
      ParentFont = False
    end
    object ButtonFind: TButton
      Left = 580
      Height = 31
      Top = 70
      Width = 94
      Caption = 'Fi&nd'
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      OnClick = ButtonFindClick
      ParentFont = False
      TabOrder = 9
    end
    object ButtonAbortFind: TButton
      Left = 580
      Height = 31
      Top = 110
      Width = 94
      Caption = '&Abort Find'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      OnClick = ButtonAbortFindClick
      ParentFont = False
      TabOrder = 10
    end
  end
  object TreeView: TTreeView
    Left = 0
    Height = 253
    Top = 167
    Width = 709
    Align = alClient
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    ParentFont = False
    TabOrder = 1
  end
  object MainMenu: TMainMenu
    Left = 280
    Top = 20
    object MenuItemEdit: TMenuItem
      Caption = 'Edit'
      object MenuItemCopyAllStatesNamesToClipBrd: TMenuItem
        Caption = '&Copy all states names to clipBoard'
        OnClick = MenuItemCopyAllStatesNamesToClipBrdClick
      end
    end
  end
end
