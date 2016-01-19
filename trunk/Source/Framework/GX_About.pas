unit GX_About;

{$I GX_CondDefine.inc}

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, ExtCtrls, GX_BaseForm;

type
  TfmAbout = class(TfmBaseForm)
    lblGExperts: TLabel;
    btnClose: TButton;
    lblVersion: TLabel;
    pnlLogo: TPanel;
    imgLogo: TImage;
    btnEmail: TButton;
    lblWebPage: TLabel;
    lblProjectLeader: TLabel;
    lblContributors: TLabel;
    lblErik: TLabel;
    lblWebSite: TLabel;
    lblPreRelease1: TLabel;
    lblPreRelease2: TLabel;
    mmoBuildDetails: TMemo;
    mmoContributors: TMemo;
    tim_Scroll: TTimer;
    procedure btnEmailClick(Sender: TObject);
    procedure lblWebPageClick(Sender: TObject);
    procedure tim_ScrollTimer(Sender: TObject);
  private
    procedure InitVersionInfoControls;
  protected
    class function GetVersionStr: string;
    class function DoAddToAboutDialog: Integer; virtual;
    class function GetAboutIcon: HBITMAP; virtual;
    class function GetSplashIcon: HBITMAP; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    // If you release an experimental GExperts, either
    // set gblAboutFormClass to your own descentant of this form or
    // call SetCustomBuildDetails and SetCustomBuildEmails to
    // describe your build and provide feedback email adresses.
    class procedure SetCustomBuildDetails(const Details: string);
    class procedure SetCustomBuildEmails(const ABugEmail, ASuggestionEmail: string);
    class procedure AddToSplashScreen;
    class procedure AddToAboutDialog;
    class procedure RemoveFromAboutDialog;
  end;

type
  TAboutFormClass = class of TfmAbout;

var
  gblAboutFormClass: TAboutFormClass;

implementation

{$R *.dfm}
{$R GX_About.res}

uses
  {$IFOPT D+} GX_DbugIntf, {$ENDIF}
  SysUtils, Graphics, ToolsApi, Messages,
  GX_GenericUtils, GX_FeedbackWizard;

const
  DefaultBugEmail = 'bugs@gexperts.org';  // Do not localize.
  DefaultSuggestionEmail = 'suggestions@gexperts.org'; // Do not localize.
var
  BuildDetails: string = '';
  BugEmail: string = DefaultBugEmail;
  SuggestionEmail: string = DefaultSuggestionEmail;

procedure TfmAbout.btnEmailClick(Sender: TObject);
begin
  TfmFeedbackWizard.Execute(Application, BugEmail, SuggestionEmail);
  Close;
end;

procedure TfmAbout.lblWebPageClick(Sender: TObject);
var
  Lbl: TLabel;
  URL: string;
begin
  Lbl := Sender as TLabel;
  URL := Lbl.Hint;
  if URL = '' then
    URL := Lbl.Caption;
  GXShellExecute(URL, '', True);
end;

constructor TfmAbout.Create(AOwner: TComponent);
begin
  inherited;
  SetFontBold(lblContributors);
  SetFontBold(lblProjectLeader);
  SetFontBold(lblWebSite);
  SetFontBold(lblVersion);
  SetFontBold(lblGExperts);
  SetFontColor(lblPreRelease1, clRed);
  SetFontColor(lblPreRelease2, clRed);
  SetFontSize(lblGExperts, +4);
  SetFontSize(lblVersion, +4);
  SetFontUnderline(lblErik);
  SetFontUnderline(lblWebPage);
  SetFontColor(lblErik, clBlue);
  SetFontColor(lblWebPage, clBlue);
  SetFontColor(mmoBuildDetails, clRed);

  imgLogo.Picture.Bitmap.LoadFromResourceName(HInstance, 'ABOUT_WIZ');
  InitVersionInfoControls;

  if NotEmpty(BuildDetails) then
  begin
    if (BugEmail = DefaultBugEmail) or (SuggestionEmail = DefaultSuggestionEmail) then
      btnEmail.Visible := False;
    mmoBuildDetails.Visible := True;
    mmoBuildDetails.Lines.Text := BuildDetails;
  end
  else
  begin
    if gblAboutFormClass = TfmAbout then
      btnEmail.Visible := True;
    mmoBuildDetails.Visible := False;
  end;
end;

procedure TfmAbout.InitVersionInfoControls;
resourcestring
  SVersion = 'Version';
  SUnknown = '<unknown>';
var
  Version: TVersionNumber;
begin
  try
    Version := GetFileVersionNumber(ThisDllName);
    lblVersion.Caption := Format('%s %d.%d%d', [SVersion, Version.Major, Version.Minor, Version.Release]);
  except
    lblVersion.Caption := Format('%s %s', [SVersion, SUnknown]);
  end;
  if Version.Build <> 0 then
    lblVersion.Caption := lblVersion.Caption + '.' + IntToStr(Version.Build);
end;

class procedure TfmAbout.SetCustomBuildDetails(const Details: string);
begin
  BuildDetails := Details;
end;

class procedure TfmAbout.SetCustomBuildEmails(const ABugEmail, ASuggestionEmail: string);
begin
  BugEmail := ABugEmail;
  SuggestionEmail := ASuggestionEmail;
end;

procedure TfmAbout.tim_ScrollTimer(Sender: TObject);
var
  Res: Integer;
begin
  inherited;

  if mmoContributors.Focused then
    Exit;
    
  Res :=  SendMessage(mmoContributors.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  if Res = 0 then begin
    // we have reached the end
    SendMessage(mmoContributors.Handle, WM_VSCROLL, SB_TOP, 0);
  end;
end;

class function TfmAbout.GetAboutIcon: HBITMAP;
const
  GX_ABOUT_ICON32 = 'GX32';
begin
  Result := LoadBitmap(HInstance, GX_ABOUT_ICON32);
end;

class function TfmAbout.GetSplashIcon: HBITMAP;
const
  GX_ABOUT_ICON24 = 'GX24';
begin
  Result := LoadBitmap(HInstance, GX_ABOUT_ICON24);
end;

class function TfmAbout.GetVersionStr: string;
resourcestring
  SVersion = 'Version';
  SUnknown = '<unknown>';
var
  Version: TVersionNumber;
begin
  try
    Version := GetFileVersionNumber(ThisDllName);
    Result := Format('%s %d.%d%d', [SVersion, Version.Major, Version.Minor, Version.Release]);
  except
    Result := Format('%s %s', [SVersion, SUnknown]);
  end;
  if Version.Build <> 0 then
    Result := Result + '.' + IntToStr(Version.Build);
end;

{$IFOPT D+}
procedure SendDebugComponent(_cmp: TComponent; _Recursive: Boolean = False; _Prefix: string = '');
var
  i: integer;
begin
  SendDebug(_Prefix + _cmp.Name + ': ' + _cmp.ClassName);
  if  _Recursive and (_cmp.ComponentCount > 0) then begin
    SendIndent;
    for i := 0 to _cmp.ComponentCount - 1 do begin
      SendDebugComponent(_cmp.Components[i], _Recursive, '(' + IntToStr(i) + ') ');
    end;
    SendUnIndent;
  end;
end;
{$ENDIF}

procedure AddPluginToSplashScreen(_Icon: HBITMAP; const _Title: string; const _Version: string);
{$IFDEF GX_VER170_up}
// Only Delphi 2005 and up support the splash screen services
begin
  if Assigned(SplashScreenServices) then
    SplashScreenServices.AddPluginBitmap(_Title,
      _Icon, False, _Version);
end;
{$ELSE GX_VER170_up}
const
  XPOS = 140;
  YPOS = 150;
  PluginLogoStr = 'PluginLogo';
var
  imgLogo: TImage;
  lblTitle: TLabel;
  lblVersion: TLabel;
  i: integer;
  PluginIdx: integer;
  frm: TCustomForm;
begin
{$IFOPT D+} SendDebug('Screen.Forms[]:'); {$ENDIF}
{$IFOPT D+} SendIndent; {$ENDIF}
  for i := 0 to Screen.FormCount - 1 do begin
    frm := Screen.Forms[i];
    if (frm.Name = 'SplashScreen') and frm.ClassNameIs('TForm') then begin
      {$IFOPT D+} SendDebugComponent(frm, True, '(' + IntToStr(i) + ') '); {$ENDIF}
      PluginIdx := 0;
      while frm.FindComponent(PluginLogoStr + IntToStr(PluginIdx)) <> nil do
        Inc(PluginIdx);

      imgLogo := TImage.Create(frm);
      imgLogo.Name := PluginLogoStr + IntToStr(PluginIdx);
      imgLogo.Parent := frm;
      imgLogo.AutoSize := True;
      imgLogo.Picture.Bitmap.Handle := _Icon;
      imgLogo.Left := XPOS;
      imgLogo.Top := YPOS + 32 * PluginIdx;

      lblTitle := TLabel.Create(frm);
      lblTitle.Name := 'PluginTitle' + IntToStr(PluginIdx);
      lblTitle.Parent := frm;
      lblTitle.Caption := _Title;
      lblTitle.Top := imgLogo.Top;
      lblTitle.Left := imgLogo.Left + 32 + 8;
      lblTitle.Transparent := True;
      lblTitle.Font.Color := clWhite;
      lblTitle.Font.Style := [fsbold];

      lblVersion := TLabel.Create(frm);
      lblVersion.Name := 'PluginVersion' + IntToStr(PluginIdx);
      lblVersion.Parent := frm;
      lblVersion.Caption := _Version;
      lblVersion.Top := imgLogo.Top + lblTitle.Height;
      lblVersion.Left := imgLogo.Left + 32 + 20;
      lblVersion.Transparent := True;
      lblVersion.Font.Color := clWhite;
    end else begin
      {$IFOPT D+} SendDebugComponent(frm, False, '(' + IntToStr(i) + ') '); {$ENDIF}
    end;
  end;
{$IFOPT D+} SendUnIndent; {$ENDIF}
end;
{$ENDIF GX_VER170_up}

class procedure TfmAbout.AddToSplashScreen;
begin
  AddPluginToSplashScreen(GetSplashIcon, 'GExperts', GetVersionStr);
end;

class function TfmAbout.DoAddToAboutDialog: Integer;
{$IFDEF GX_VER170_up}
// Only Delphi 2005 and up support the about box services
var
  AboutBoxServices: IOTAAboutBoxServices;
begin
  Result := -1;
  if Supports(BorlandIDEServices, IOTAAboutBoxServices, AboutBoxServices) then
  begin
    Result := AboutBoxServices.AddPluginInfo(
      'GExperts',
      'GExperts is a free set of tools built to increase the productivity of Delphi and C++Builder'
      + ' programmers by adding several features to the IDE.'
      + ' GExperts is developed as Open Source software and we encourage user contributions to the project.'#13#10
      + '(c) Erik Berry and the GExperts Team'#13#10
      + 'http://www.gexperts.org',
      GetAboutIcon,
      False,
      '', // leave this empty!
      GetVersionStr);
  end;
end;
{$ELSE not GX_VER170_up}
begin
  Result := -1;
end;
{$ENDIF not GX_VER170_up}

var
  FAboutPluginIndex: Integer;

class procedure TfmAbout.AddToAboutDialog;
begin
  FAboutPluginIndex := DoAddToAboutDialog;
end;

class procedure TfmAbout.RemoveFromAboutDialog;
{$IFDEF GX_VER170_up}
// Only Delphi 2005 and up support the about box services
var
  AboutBoxServices: IOTAAboutBoxServices;
begin
  if FAboutPluginIndex <> -1 then
  begin
    if Supports(BorlandIDEServices, IOTAAboutBoxServices, AboutBoxServices) then
      AboutBoxServices.RemovePluginInfo(FAboutPluginIndex);
    FAboutPluginIndex := -1;
  end;
end;
{$ELSE not GX_VER170_up}
begin
end;
{$ENDIF not GX_VER170_up}

initialization
  TfmAbout.AddToSplashScreen;
  gblAboutFormClass := TfmAbout;

finalization
end.

