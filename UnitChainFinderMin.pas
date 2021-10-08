unit UnitChainFinderMin;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  NuclideClassesMin, MaskEdit, Menus, Spin, Buttons;
// There were in T_FormChainFinder   PopupMenu: TPopupMenu;    OpenDialog: TOpenDialog;   SaveDialog: TSaveDialog;
// All ones were not used in real life, TPopupMenu is not stable till September 2021
// All deleted, implementations are commented:
(*
  procedure ItemSaveToFileClick(Sender: TObject);
  procedure PopupMenuPopup(Sender: TObject);
  procedure ItemLoadFromFileClick(Sender: TObject);
  procedure ItemStateNamesToClipboardClick(Sender: TObject);
  procedure ItemStateAllNamesToClipboardClick(Sender: TObject);
  procedure ItemCopyChainNamesClick(Sender: TObject);
*)

type

  { T_FormChainFinder }

  T_FormChainFinder = class(TForm)
    ButtonAbortFind: TButton;
    ButtonFind: TButton;
    MainMenu: TMainMenu;
    MenuItemCopyAllStatesNamesToClipBrd: TMenuItem;
    MenuItemEdit: TMenuItem;
    PanelTop: TPanel;
    CheckBoxCapture: TCheckBox;
    CheckBoxDecay: TCheckBox;
    CheckBoxFission: TCheckBox;
    CheckBoxThreshold: TCheckBox;
    LabelInfo: TLabel;
    LabelMaxDepth: TLabel;
    EditStart: TComboBox;
    EditFinish: TComboBox;
    SpeedButtonInfo: TSpeedButton;
    TreeView: TTreeView;
    CheckBoxClearFound: TCheckBox;
    EditMaxTime: TSpinEdit;
    LabelMaxTime: TLabel;
    LabelStartState: TLabel;
    LabelFinishState: TLabel;
    EditMaxStepNo: TSpinEdit;
    Label2FocusChains: TLabel;
    procedure ButtonFindClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ButtonAbortFindClick(Sender: TObject);
    procedure MenuItemCopyAllStatesNamesToClipBrdClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure SpeedButtonInfoClick(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure SetDataModule(aDataModule: TObject);
  private
    { Private declarations }
    fTheDataModule: TObject;
    fNuclideList: TNuclideList;
    fEditItems: TStringList;
  public
    { Public declarations }
    FoundChains: TList;
    ShowSplashScreen: boolean;
    procedure FoundChainsToTreeView;
    property NuclideList: TNuclideList read fNuclideList write fNuclideList;
    procedure CreateNuclideList;
    procedure LoadNuclideList;
    property TheDataModule: TObject read fTheDataModule write SetDataModule;
  end;

var
  _FormChainFinder: T_FormChainFinder;

implementation

uses ClipBrd, UnitSplashFinderMin, UnitDM_OOB, EuLibMin;

{$R *.frm}

{ T_FormChainFinder }

procedure T_FormChainFinder.LoadNuclideList;
var
  I, J: integer;
  aStateName: string;
begin
  try
    with _FormSplashFinder do
      if (ShowSplashScreen) then
      begin
        Self.Enabled := False;
        Caption := 'Data loading...';
        Show;
      end;
    NuclideList.Clear;
    if (fTheDataModule is T_DataModuleOOB) then
      NuclideList.LoadFromDB(T_DataModuleOOB(fTheDataModule), _FormSplashFinder.ProgressBar);
    _FormSplashFinder.Close;
    ShowSplashScreen := True;
    if fNuclideList <> nil then
    begin
      fEditItems.Clear;
      for I := 0 to fNuclideList.Count - 1 do
        for J := 0 to fNuclideList[I].StateList.Count - 1 do
        begin
          aStateName := fNuclideList[I].StateList[J].GetStateName;
          if Length(aStateName) > 1 then
          begin
            fEditItems.Add(aStateName);
          end;
        end;
    end;
    EditStart.Items.Assign(fEditItems);
    EditFinish.Items.Assign(fEditItems);
  finally
    Self.Enabled := True;
  end;
end;

procedure T_FormChainFinder.FormCreate(Sender: TObject);
begin
  NuclideList := nil;
  ShowSplashScreen := True;
  fEditItems := TStringList.Create;
  // for quick tests
  // EditStart.Text:= 'U-235';//'Po-218';//'Pu-238';//'U-235'; //'Cf-249';//'Ra-226';
  // EditFinish.Text:= 'U-234';//'Po-214';//'Es-255';//'U-234'; //'Es-255';//'Ac-225';
  FoundChains := TList.Create;
  // OpenDialog.InitialDir:= ExtractFilePath(Application.ExeName);
  // SaveDialog.InitialDir:= ExtractFilePath(Application.ExeName);
  MenuItemCopyAllStatesNamesToClipBrd.Enabled := False;
end;

procedure T_FormChainFinder.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (_FormSplashFinder <> nil) then
    _FormSplashFinder.Free;
  Application.Terminate;
end;

procedure T_FormChainFinder.ButtonFindClick(Sender: TObject);
var
  I, J, MaxStep: integer;
  ThZpA_sStart, ThZpA_sFinish: integer;
  StateFount, ChainFound: boolean;
  Transitions: TNuclideTransitions;
  TmpChains, TmpIntList: TLongIntList;
  SaveCaption: string;
begin
  // Text-> ThZpA_s
  ButtonAbortFind.Enabled := True;
  if CheckBoxClearFound.Checked then
  begin
    for I := FoundChains.Count - 1 downto 0 do
      TLongIntList(FoundChains[I]).Clear;
    FoundChains.Clear;
  end;
  ThZpA_sStart := StrToThZpA_s(EditStart.Text);
  ThZpA_sFinish := StrToThZpA_s(EditFinish.Text);
  if ((ThZpA_sStart < 10000) or (ThZpA_sFinish < 10000)) then
  begin
    MessageDlg('Error in Start or Finish state name ! ' + #13 + #10 + 'Use notation like ''Tc-99'', ''U-235g'', ''U-235m''' +
      #13 + #10 + 'Exiting find', mtWarning, [mbOK], 0);
    LabelInfo.Caption := 'Error in Start or Finish state name !';
    Exit;
  end;
  SaveCaption := Caption;
  ChainFound := False;
  Caption := ' LOOKING for chain';
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  TmpChains := TLongIntList.Create;
  try
    Transitions := [];
    if CheckBoxCapture.Checked then
      Transitions := Transitions + [ntCapture];
    if CheckBoxDecay.Checked then
      Transitions := Transitions + [ntDecay];
    if CheckBoxFission.Checked then
      Transitions := Transitions + [ntFission];
    if CheckBoxThreshold.Checked then
      Transitions := Transitions + [ntTHreshold];
    StateFount := False;
    I := NuclideList.FindInList((ThZpA_sStart div 10) div 1000, (ThZpA_sStart div 10) mod 1000);
    if I >= 0 then
    begin
      for J := 0 to NuclideList[I].StateList.Count - 1 do
        if NuclideList[I].StateList[J].State = ThZpA_sStart mod 10 then
        begin
          StateFount := True;
          break;
        end;
    end;
    if not (StateFount) then
    begin
      LabelInfo.Caption := 'The Start was not found in the loaded nuclide list !!!';
      exit;
    end;
    try
      MaxStep := StrToInt(EditMaxStepNo.Text);
    except
      MaxStep := MaxLongint div 2;
      LabelInfo.Caption := 'MaxStep = ' + IntToStr(MaxStep);
    end;
    with Self do
    begin
      CheckBoxDecay.Enabled := False;
      CheckBoxCapture.Enabled := False;
      CheckBoxFission.Enabled := False;
      CheckBoxThreshold.Enabled := False;
      CheckBoxClearFound.Enabled := False;
      EditMaxStepNo.Enabled := False;
      EditMaxTime.Enabled := False;
      EditStart.Enabled := False;
      EditFinish.Enabled := False;
      ButtonFind.Enabled := False;
    end;
    if (((GetKeyState(VK_SHIFT) shr 16) and 1) = 0) then  //If the high-order bit is 1, the key is down; otherwise, it is up.
      ChainFound := NuclideList.FindChain[1](T_DataModuleOOB(fTheDataModule), ThZpA_sStart, ThZpA_sFinish, MaxStep,
        Transitions, TmpChains, EditMaxTime.Value * 40 * 1000) // MaxTime 60*100, some reserve for stack come-back
    else
      ChainFound := NuclideList.FindChain[0](T_DataModuleOOB(fTheDataModule), ThZpA_sStart, ThZpA_sFinish, MaxStep,
        Transitions, TmpChains, EditMaxTime.Value * 40 * 1000); // MaxTime 60*100, some reserve for stack come-back
  finally
    with Self do
    begin
      CheckBoxDecay.Enabled := True;
      CheckBoxCapture.Enabled := True;
      CheckBoxFission.Enabled := True;
      CheckBoxThreshold.Enabled := True;
      CheckBoxClearFound.Enabled := True;
      EditMaxStepNo.Enabled := True;
      EditMaxTime.Enabled := True;
      EditStart.Enabled := True;
      EditFinish.Enabled := True;
      ButtonFind.Enabled := True;
      ButtonAbortFind.Enabled := False;
    end;
    if not (ChainFound) then
    begin
      if not (NuclideList.ChainFinderTimeAborted) then
        LabelInfo.Caption := 'Chain was NOT found. Max ' + IntToStr(MaxStep) + ' steps in depth'
      else
        LabelInfo.Caption := 'Chain was NOT found. Time limit exceeded.';
    end
    else
      LabelInfo.Caption := IntToStr(MaxStep) + ' steps in depth';
    if TmpChains.Count > 0 then
    begin
      if TmpChains[0] > 0 then
        TmpChains.Insert(0, -11);
      if TmpChains.Last > 0 then
        TmpChains.Add(-11);
    end;
    Self.Enabled := True;
    Screen.Cursor := crDefault;
    Caption := SaveCaption;
    TmpIntList := TLongIntList.Create;
    for I := 1 to TmpChains.Count - 1 do
      if TmpChains[I] > 0 then
      begin
        TmpIntList.Add(TmpChains[I]);
      end
      else
      begin
        FoundChains.Add(TmpIntList);
        if I < TmpChains.Count - 1 then
          TmpIntList := TLongIntList.Create;
      end;
    for I := FoundChains.Count - 1 downto 0 do
      if TLongIntList(FoundChains[I]).Count <= 1 then
      begin
        TLongIntList(FoundChains[I]).Clear;
        FoundChains.Delete(I);
      end;
    for I := FoundChains.Count - 1 downto 0 do
      for J := FoundChains.Count - 1 downto I + 1 do
        if ListEqual(TLongIntList(FoundChains[I]), TLongIntList(FoundChains[J])) then
        begin
          TLongIntList(FoundChains[J]).Clear;
          FoundChains.Delete(J);
        end;
    // TreeView
    FoundChainsToTreeView;
    TmpChains.Free;
    if TreeView.Items.Count > 0 then
      MenuItemCopyAllStatesNamesToClipBrd.Enabled := True
    else
      MenuItemCopyAllStatesNamesToClipBrd.Enabled := False;
  end;
end;


procedure T_FormChainFinder.FoundChainsToTreeView;
var
  I, J, K, L: integer;
  ParentNode: TTreeNode;
begin
  TreeView.Items.Clear;
  with TreeView.Items do
    for I := 0 to FoundChains.Count - 1 do
    begin
      ParentNode := TreeView.Items.Add(nil, 'Chain');
      ParentNode.Data := FoundChains[I];
      for J := 0 to TLongIntList(FoundChains[I]).Count - 1 do
        if NuclideList.FindThZpA_s(TLongIntList(FoundChains[I])[J], K, L) then
          TreeView.Items.AddChild(ParentNode, NuclideList[K].StateList[L].GetStateName)
        else
          TreeView.Items.AddChild(ParentNode, IntToStr(TLongIntList(FoundChains[I])[J]));
    end;
end;

procedure T_FormChainFinder.ButtonAbortFindClick(Sender: TObject);
begin
  NuclideList.AbortChainFinder := True;
end;

procedure T_FormChainFinder.CreateNuclideList;
begin
  fNuclideList := TNuclideList.Create;
end;

(*
procedure T_FormChainFinder.ItemSaveToFileClick(Sender: TObject);
var
 TmpChain: TChain;
 I, K, L, aThZpA_s: integer;
 TmpState: TChainState;
 Transitions: TNuclideTransitions;
begin
 SaveDialog.DefaultExt:= 'chn';
 if UpperCase(Trim(TreeView.Selected.Text))='CHAIN' then
  if SaveDialog.Execute then begin
   TmpChain:= TChain.Create;
   for I:= 0 to TLongIntList(TreeView.Selected.Data).Count-1 do begin
    aThZpA_s:= TLongIntList(TreeView.Selected.Data)[I];
    NuclideList.FindThZpA_s(aThZpA_s, K, L);
    TmpState:= TChainState.CreateFromNuclideState(TmpChain, NuclideList[K].StateList[L]);
    TmpChain.AddState(TmpState);
   end;
   Transitions:= [];
   if CheckBoxCapture.Checked then
    Transitions:= Transitions+ [ntCapture];
   if CheckBoxDecay.Checked then
    Transitions:= Transitions+ [ntDecay];
   if CheckBoxFission.Checked then
    Transitions:= Transitions+ [ntFission];
   if CheckBoxThreshold.Checked then
    Transitions:= Transitions+ [ntTHreshold];
   TmpChain.BuildDefaultLinks(Transitions, NuclideList);
   TmpChain.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure T_FormChainFinder.PopupMenuPopup(Sender: TObject);
begin
 if TreeView.Items.Count>0 then begin
  if TreeView.Selected<>nil then begin
   if UpperCase(Trim(TreeView.Selected.Text))='CHAIN' then begin
    ItemSaveToFile.Enabled:= True;
    ItemStateNamesToClipboard.Enabled:= True;
    ItemCopyChainNames.Enabled:= True;
   end
   else begin
    ItemSaveToFile.Enabled:= False;
    ItemStateNamesToClipboard.Enabled:= False;
    ItemCopyChainNames.Enabled:= False;
   end;
  end
 end
 else begin
  ItemCopyChainNames.Enabled:= False;
  ItemSaveToFile.Enabled:= False;
 end;
end;

procedure T_FormChainFinder.ItemLoadFromFileClick(Sender: TObject);
var
 TmpChain: TChain;
 I: integer;
 ThereExists: Boolean;
 TmpIntList: TLongIntList;
begin
 if OpenDialog.Execute then begin
  TmpChain:= TChain.Create;
  TmpChain.LoadFromFile(OpenDialog.FileName);
  TmpIntList:= TLongIntList.Create;
  ThereExists:= True;
  try
   if TmpChain.States.Count>0 then begin
    for I:= 0 to TmpChain.States.Count-1 do
     TmpIntList.Add(TmpChain.States[I].ThZpA_s);
    ThereExists:= False;
    for I:= 0 to FoundChains.Count-1 do
     if ListEqual(TLongIntList(FoundChains[I]), TmpIntList) then begin
      ThereExists:= True;
      break;
     end;
    if not(ThereExists) then begin
     FoundChains.Add(TmpIntList);
     FoundChainsToTreeView;
    end;
   end;
  finally
   TmpChain.Free;
   if ThereExists then
    TmpIntList.Free;
  end;
 end;
end;

procedure T_FormChainFinder.ItemStateNamesToClipboardClick(Sender: TObject);
var
 I: integer;
 Txt: string;
begin
 Txt:= '';
// for I:= 0 to TLongIntList(TreeView.Selected.Data).Count-1 do begin
 for I:= 0 to TreeView.Selected.Count-1 do
  Txt:= Txt+TreeView.Selected[I].Text+',';
 Clipboard.AsText:= Copy(Txt, 1, Length(Txt)-1);
end;

procedure T_FormChainFinder.ItemStateAllNamesToClipboardClick(
 Sender: TObject);
var
 I: integer;
 NameList: TStringList;
 Txt: string;
begin
 Txt:= '';
 NameList:= TStringList.Create;
 NameList.Duplicates:= dupIgnore;
 NameList.Sorted:= True;
 try
  for I:= 0 to TreeView.Items.Count-1 do
   if UpperCase(Trim(TreeView.Items[I].Text))<>'CHAIN' then
    NameList.Add(TreeView.Items[I].Text);
  for I:= 0 to NameList.Count-1 do
   Txt:= Txt+NameList[I]+',';
  Clipboard.AsText:= Copy(Txt, 1, Length(Txt)-1);
 finally
  NameList.Free;
 end;
end;

procedure T_FormChainFinder.ItemCopyChainNamesClick(Sender: TObject);
var
 I: integer;
 aStr: string;
begin
 aStr:= '';
 for I:= 0 to TLongIntList(TreeView.Selected.Data).Count-1 do begin
  aStr:= aStr+ThZpA_sToStr(TLongIntList(TreeView.Selected.Data)[I])+',';
 end;
 Clipboard.AsText:= Copy(aStr, 1, Length(aStr)-1);
end;
*)

procedure T_FormChainFinder.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if ButtonAbortFind.Enabled then
    ButtonAbortFindClick(Self);
  CanClose := True;
end;

procedure T_FormChainFinder.SpeedButtonInfoClick(Sender: TObject);
begin
  ShowMessage(_FormSplashFinder.Label2.Caption);
(* stoped working with FormStyle fsSplash
 with _FormSplashFinder do
  if not(Visible) then begin
   LabelDataLoading.Visible:= False;
   ProgressBar.Visible:= False;
   ButtonOK.Visible:= True;
   ShowModal;
  end;
*)
end;

procedure T_FormChainFinder.EditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    ButtonFindClick(Self);
end;

procedure T_FormChainFinder.SetDataModule(aDataModule: TObject);
var
  BaseFileName: string;
begin
  if (aDataModule <> Self.fTheDataModule) then
  begin
    fTheDataModule := aDataModule;
    BaseFileName := ExtractFilePath(Application.ExeName) + 'ORIP_XXId.oob';
    if FileExists('ORIP_XXId.oob') then
      T_DataModuleOOB(fTheDataModule).DatabaseName := 'ORIP_XXId.oob'
    else if FileExists(BaseFileName) then
      T_DataModuleOOB(fTheDataModule).DatabaseName := BaseFileName
    else
      T_DataModuleOOB(fTheDataModule).DatabaseName := '  '; // Open dialog - in T_DataModuleOOB
  end;
end;

procedure T_FormChainFinder.MenuItemCopyAllStatesNamesToClipBrdClick(Sender: TObject);
var
  I: integer;
  NameList: TStringList;
  Txt: string;
begin
  MenuItemCopyAllStatesNamesToClipBrd.Enabled:= False;
  Txt := '';
  NameList := TStringList.Create;
  NameList.Duplicates := dupIgnore;
  NameList.Sorted := True;
  try
    for I := 0 to TreeView.Items.Count - 1 do
      if UpperCase(Trim(TreeView.Items[I].Text)) <> 'CHAIN' then
        NameList.Add(TreeView.Items[I].Text);
    for I := 0 to NameList.Count - 1 do
      Txt := Txt + NameList[I] + ',';
    Clipboard.AsText := Copy(Txt, 1, Length(Txt) - 1);
  finally
    MenuItemCopyAllStatesNamesToClipBrd.Enabled:= True;
    NameList.Free;
  end;
end;


end.
