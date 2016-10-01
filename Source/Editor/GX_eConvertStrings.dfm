inherited fmERawStrings: TfmERawStrings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Convert Strings'
  ClientHeight = 369
  ClientWidth = 689
  ParentFont = False
  OnResize = FormResize
  DesignSize = (
    689
    369)
  PixelsPerInch = 96
  TextHeight = 13
  object l_Input: TLabel
    Left = 8
    Top = 8
    Width = 26
    Height = 13
    Caption = '&Input'
    FocusControl = m_Input
  end
  object l_Output: TLabel
    Left = 440
    Top = 8
    Width = 34
    Height = 13
    Caption = '&Output'
    FocusControl = m_Output
  end
  object l_Prefix: TLabel
    Left = 264
    Top = 280
    Width = 28
    Height = 13
    Caption = '&Prefix'
    FocusControl = ed_Prefix
    OnClick = b_CopyToClipboardClick
  end
  object m_Input: TMemo
    Left = 8
    Top = 24
    Width = 241
    Height = 297
    Anchors = [akLeft, akTop, akBottom]
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnChange = m_InputChange
  end
  object m_Output: TMemo
    Left = 440
    Top = 24
    Width = 241
    Height = 297
    Anchors = [akLeft, akTop, akBottom]
    ScrollBars = ssBoth
    TabOrder = 6
    WordWrap = False
  end
  object chk_QuoteStrings: TCheckBox
    Left = 264
    Top = 232
    Width = 161
    Height = 25
    Caption = '&Quote strings'
    TabOrder = 3
    OnClick = chk_QuoteStringsClick
  end
  object chk_AppendSpace: TCheckBox
    Left = 264
    Top = 256
    Width = 161
    Height = 17
    Caption = '&Append space'
    TabOrder = 4
    OnClick = chk_AppendSpaceClick
  end
  object b_CopyToClipboard: TButton
    Left = 400
    Top = 336
    Width = 121
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Copy &To Clipboard'
    TabOrder = 8
    OnClick = b_CopyToClipboardClick
  end
  object b_Insert: TButton
    Left = 528
    Top = 336
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'I&nsert'
    TabOrder = 9
    OnClick = b_InsertClick
  end
  object b_Cancel: TButton
    Left = 608
    Top = 336
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 10
  end
  object chk_ExtractRaw: TCheckBox
    Left = 264
    Top = 24
    Width = 161
    Height = 17
    Caption = '&Extract Raw Strings'
    TabOrder = 1
    OnClick = chk_ExtractRawClick
  end
  object rg_ConvertType: TRadioGroup
    Left = 264
    Top = 48
    Width = 161
    Height = 185
    Caption = '&Convert Type'
    ItemIndex = 0
    Items.Strings = (
      '&1: %s'
      '&2: %s,'
      '&3: Add(%s);'
      '&4: %s + sLineBreak +'
      '&5: %s + #10 +'
      '&6: %s + #13 +'
      '&7: %s + #13#10 +'
      '&8: %s + CRLF +'
      '&9: %s + CR_LF +')
    TabOrder = 2
    OnClick = rg_ConvertTypeClick
  end
  object ed_Prefix: TEdit
    Left = 264
    Top = 296
    Width = 161
    Height = 21
    TabOrder = 5
    OnChange = ed_PrefixChange
  end
  object b_PasteFromClipboard: TButton
    Left = 8
    Top = 336
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Paste &From Clipboard'
    TabOrder = 7
    OnClick = b_PasteFromClipboardClick
  end
end
