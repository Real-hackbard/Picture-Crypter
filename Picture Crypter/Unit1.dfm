object Form1: TForm1
  Left = 241
  Top = 259
  Caption = 'Picture Crypter'
  ClientHeight = 504
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 54
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 636
    object Label1: TLabel
      Left = 14
      Top = 7
      Width = 198
      Height = 39
      Caption = 'Picture Crypter'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Impact'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 218
      Top = 28
      Width = 158
      Height = 13
      Caption = 'Encrypt images of various formats'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 54
    Width = 105
    Height = 431
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitHeight = 430
    object Label2: TLabel
      Left = 16
      Top = 173
      Width = 24
      Height = 13
      Caption = 'Key :'
    end
    object Label4: TLabel
      Left = 18
      Top = 225
      Width = 29
      Height = 13
      Caption = 'XOR :'
    end
    object Button1: TButton
      Left = 16
      Top = 368
      Width = 75
      Height = 25
      Caption = 'En/Decrypt'
      TabOrder = 0
      TabStop = False
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 16
      Top = 192
      Width = 75
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
      Text = '123'
      OnKeyPress = Edit1KeyPress
    end
    object Button2: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Picture'
      TabOrder = 2
      TabStop = False
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 16
      Top = 399
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 3
      TabStop = False
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 16
      Top = 337
      Width = 75
      Height = 25
      Caption = 'Generate'
      TabOrder = 4
      TabStop = False
      OnClick = Button4Click
    end
    object RadioGroup1: TRadioGroup
      Left = 14
      Top = 63
      Width = 77
      Height = 96
      Caption = ' Mode '
      ItemIndex = 0
      Items.Strings = (
        'Low'
        'Normal'
        'Hard')
      TabOrder = 5
      OnClick = RadioGroup1Click
    end
    object Edit2: TEdit
      Left = 16
      Top = 242
      Width = 75
      Height = 21
      TabStop = False
      MaxLength = 4
      TabOrder = 6
      Text = '256'
      OnKeyPress = Edit2KeyPress
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 288
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Stretch'
      TabOrder = 7
      OnClick = CheckBox1Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 485
    Width = 640
    Height = 19
    Panels = <
      item
        Text = 'File :'
        Width = 35
      end
      item
        Width = 150
      end
      item
        Text = 'Ext :'
        Width = 35
      end
      item
        Width = 40
      end
      item
        Text = 'Size :'
        Width = 40
      end
      item
        Text = '0 Kb'
        Width = 80
      end
      item
        Text = 'Bit :'
        Width = 35
      end
      item
        Text = '0'
        Width = 35
      end
      item
        Text = 'Dimension :'
        Width = 75
      end
      item
        Text = '0x0'
        Width = 50
      end>
    ExplicitTop = 484
    ExplicitWidth = 636
  end
  object ScrollBox1: TScrollBox
    Left = 105
    Top = 54
    Width = 535
    Height = 431
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 3
    ExplicitWidth = 531
    ExplicitHeight = 430
    object Image1: TImage
      Left = 4
      Top = 5
      Width = 103
      Height = 132
      AutoSize = True
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Bitmap (*.bmp)|*.bmp|Jpg (*.jpg)|*.jpg|Portable Network Graphic ' +
      '(*.png)|*.png|Graphics Interchange Format (*.gif)|*.gif'
    Left = 169
    Top = 105
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Bitmap (*.bmp)|*.bmp'
    Left = 281
    Top = 105
  end
end
