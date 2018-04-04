unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, bsSkinData, Menus, bsSkinMenus, ActnList, StdCtrls,
  BusinessSkinForm, ExtCtrls, Mask, bsSkinBoxCtrls, FileCtrl, bsfilectrl,
  DropListBox,ShellAPI, ImgList, DB, DBClient,MainConst,MidasLib;

type
  THideStyle = (hsHide,hsShow);

  TItemRec = record
    FileName:string;
    FilePath:string;
    IcoFile:TMemoryStream;
  end;
  PItemRec = ^TItemRec;

  TFrmMyTool = class(TForm)
    pnHead: TbsSkinPanel;
    pnMain: TbsSkinPanel;
    skinData: TbsSkinData;
    skinList: TbsCompressedSkinList;
    sbInfo: TbsSkinStatusBar;
    pp1: TbsSkinPopupMenu;
    N1: TMenuItem;
    Ubuntu1: TMenuItem;
    Aero1: TMenuItem;
    Office20101: TMenuItem;
    Office20102: TMenuItem;
    Win7Aero1: TMenuItem;
    Win8Aero1: TMenuItem;
    actlst1: TActionList;
    actSetTheme_Ubuntu: TAction;
    actSetTheme_SilverAero: TAction;
    actSetThemeOffice2010blue: TAction;
    actSetThemeOffice2010Silver: TAction;
    actSetThemeWin7Aero: TAction;
    actSetThemeWin8Aero: TAction;
    bsbsnsknfrm1: TbsBusinessSkinForm;
    tbSet: TbsSkinToolBar;
    pnQry: TbsSkinPanel;
    edtQry: TbsSkinEdit;
    imgQry: TImage;
    bsknpnl1: TbsSkinPanel;
    bsknpnl2: TbsSkinPanel;
    lbdt: TbsSkinLabel;
    tmr1: TTimer;
    lstContent: TbsSkinDropFileListBox;
    lbXQ: TbsSkinLabel;
    lbTime: TbsSkinLabel;
    il1: TImageList;
    ds1: TClientDataSet;
    tmr2: TTimer;
    tmr3: TTimer;
    ppList: TbsSkinPopupMenu;
    act_Delete: TAction;
    N2: TMenuItem;
    act_Set: TAction;
    ppMin: TbsSkinPopupMenu;
    act_showFrm: TAction;
    act_Exit: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    act_OffenUse: TAction;
    ilOffenUse: TImageList;
    N5: TMenuItem;
    bsSkinMenuSpeedButton1: TbsSkinMenuSpeedButton;
    ppSpeedButton: TbsSkinPopupMenu;
    act_DeleteSpeed: TAction;
    N6: TMenuItem;
    btn1: TbsSkinSpeedButton;
    bsknstspnl1: TbsSkinStatusPanel;
    procedure actSetTheme_UbuntuExecute(Sender: TObject);
    procedure actSetTheme_SilverAeroExecute(Sender: TObject);
    procedure actSetThemeOffice2010blueExecute(Sender: TObject);
    procedure actSetThemeOffice2010SilverExecute(Sender: TObject);
    procedure actSetThemeWin7AeroExecute(Sender: TObject);
    procedure actSetThemeWin8AeroExecute(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstContentDropFiles(Sender: TObject; FileNames: TStringList);
    procedure tmr2Timer(Sender: TObject);
    procedure tmr3Timer(Sender: TObject);  //靠边缩进
    procedure lstContentListBoxDblClick(Sender: TObject);
    procedure act_DeleteExecute(Sender: TObject);
    procedure act_ExitExecute(Sender: TObject);
    procedure act_OffenUseExecute(Sender: TObject);
    procedure act_DeleteSpeedExecute(Sender: TObject);
  private
    AppName:string;
    FBtnCount:Integer;
    procedure DateInit;
    procedure FreeDynamicBtn(sID:Integer);
    function GetFormNameAt(X,Y:Integer):string;
    procedure HideFrm(hs:THideStyle;hsSpped:Integer);
    procedure DynamicClick(Sender:TObject);
    procedure OpenLink(vID:Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMyTool: TFrmMyTool;

implementation

{$R *.dfm}

procedure TFrmMyTool.actSetThemeOffice2010blueExecute(Sender: TObject);
begin
  skinData.SkinIndex := 2;
end;

procedure TFrmMyTool.actSetThemeOffice2010SilverExecute(Sender: TObject);
begin
  skinData.SkinIndex := 3;
end;

procedure TFrmMyTool.actSetThemeWin7AeroExecute(Sender: TObject);
begin
  skinData.SkinIndex := 4;
end;

procedure TFrmMyTool.actSetThemeWin8AeroExecute(Sender: TObject);
begin
  skinData.SkinIndex := 5;
end;

procedure TFrmMyTool.actSetTheme_SilverAeroExecute(Sender: TObject);
begin
  skinData.SkinIndex := 1;
end;

procedure TFrmMyTool.actSetTheme_UbuntuExecute(Sender: TObject);
begin
  skinData.SkinIndex := 0;
end;

procedure TFrmMyTool.act_DeleteExecute(Sender: TObject);
var
  CurIndex,I:Integer;
  btn:TComponent;
begin
  //获取当前ID
  if lstContent.ItemIndex < 0 then
  begin
    ShowMessage('请选择要删除的记录！');
    Exit;
  end;
  CurIndex := Integer(lstContent.Items.Objects[lstContent.ItemIndex]);
  try
    with ds1 do
    begin
      if Locate('ID',CurIndex,[]) then
      begin
        if FieldByName('OffenUse').AsBoolean then
        begin
          FreeDynamicBtn(CurIndex);
        end;
        //删除imagelist中对应图片
        il1.Delete(lstContent.ItemIndex);
        //删除listbox中数据
        lstContent.Items.Delete(lstContent.ItemIndex);
        //删除数据集中数据
        Delete;
        SaveToFile(AppName);
        DateInit;
      end;
    end;
  except on E:Exception do
    ShowMessage(E.message);
  end;
end;

procedure TFrmMyTool.act_DeleteSpeedExecute(Sender: TObject);
var
  CurIndex:Integer;
begin
  //获取当前ID
  CurIndex := TbsSkinSpeedButton(TbsSkinPopupMenu(TMenuItem(TAction(Sender).ActionComponent).GetParentComponent).PopupComponent).Tag;
  with ds1 do
  begin
    if Locate('ID',CurIndex,[]) then
    begin
      Edit;
      FieldByName('OffenUse').AsBoolean := False;
      Post;
      TbsSkinSpeedButton(TbsSkinPopupMenu(TMenuItem(TAction(Sender).ActionComponent).GetParentComponent).PopupComponent).Destroy;
      SaveToFile(AppName);
      DateInit;
    end;
  end;
end;

procedure TFrmMyTool.act_ExitExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmMyTool.act_OffenUseExecute(Sender: TObject);
var
  CurIndex:Integer;
begin
  //获取当前ID
  if lstContent.ItemIndex < 0 then
  begin
    ShowMessage('请选择要添加的记录！');
    Exit;
  end;
  CurIndex := Integer(lstContent.Items.Objects[lstContent.ItemIndex]);
  with ds1 do
  begin
    if Locate('ID',CurIndex,[]) then
    begin
      Edit;
      FieldByName('OffenUse').AsBoolean := True;
      Post;
    end;
    SaveToFile(AppName);
  end;
  DateInit;
end;

procedure TFrmMyTool.btnSetClick(Sender: TObject);
var
  pc:TPoint;
  vValue : LongBool;
begin
  GetCursorPos(pc);
  if Owner is TForm then
     SetForegroundWindow(TForm(Owner).Handle);
  pp1.Popup(pc.X,pc.Y);
  PostMessage( 0, 0, 0, 0 );
end;

procedure TFrmMyTool.DateInit;
var
  ico:TIcon;
  FileRec:PItemRec;
begin
  lstContent.Clear;
  with ds1 do
  begin
    with FieldDefs do
    begin
      Close;
      Clear;
      Add('ID',ftInteger,0,True);
      Add('FileName',ftString,50,True);
      Add('FilePath',ftString,500,True);
      Add('OffenUse',ftBoolean);
      Add('Ico',ftBlob,0,True);
    end;
    CreateDataSet;
    FBtnCount := 0;  //用于计算动态生成的按钮
    il1.Clear;  //清楚所有图片
    ilOffenUse.Clear;
    if FileExists(AppName) then
    begin
      LoadFromFile(AppName);
      Open;
      FreeDynamicBtn(0);
      First;
      while not Eof do
      begin
        try
          try
            New(FileRec);
            ico := TIcon.Create;
            FileRec.IcoFile := TMemoryStream.Create;
            FileRec.FileName := FieldByName('FileName').AsString;
            TBlobField(FieldByName('Ico')).SaveToStream(FileRec.IcoFile);
            lstContent.Items.AddObject(filerec.FileName,TObject(FieldByName('ID').AsInteger));
            FileRec.IcoFile.Position := 0;
            ico.LoadFromStream(FileRec.IcoFile);
            il1.AddIcon(ico);
            //添加常用软件
            try
              if Assigned(FindField('OffenUse')) and FieldByName('OffenUse').AsBoolean then
              begin
                ilOffenUse.AddIcon(ico);
                with TbsSkinSpeedButton.Create(self) do
                begin
                  Name := 'btn_' + IntToStr(FieldByName('ID').AsInteger);
                  Parent := sbInfo;
                  Width := Parent.Height;
                  Height := Parent.Height;
                  top := 0;
                  Left := FBtnCount * Parent.Height ;
                  Align := alNone;
                  ImageList := ilOffenUse;
                  ImageIndex := FBtnCount;
                  Tag := FieldByName('ID').AsInteger;
                  SkinData := skinData;
                  OnClick := DynamicClick;
                  PopupMenu := ppSpeedButton;
                  BringToFront;
                end;
                FBtnCount := FBtnCount + 1;
              end;
            except ON e:Exception do
              ShowMessage(E.Message);
            end;
          except on E:Exception do
            ShowMessage(e.Message);
          end;
        finally
          FileRec.IcoFile.Free;
          ico.Free;
          Dispose(FileRec);
        end;
        Next;
      end;
    end;
  end;
end;

procedure TFrmMyTool.DynamicClick(Sender: TObject);
begin
  OpenLink(TbsSkinSpeedButton(Sender).Tag);
end;

procedure TFrmMyTool.FormCreate(Sender: TObject);
begin
  AppName := ExtractFilePath(Application.ExeName) + 'MyTools.dat';
  ds1.FileName := AppName;
  DateInit;
  tmr1.Interval := 1000;
  tmr1.Enabled := True;
  tmr1Timer(tmr1);
  //由于skin控件禁止，这里手动在开启一次
  DragAcceptFiles(lstContent.Handle,lstContent.DropEnabled);
end;

procedure TFrmMyTool.FreeDynamicBtn(sID: Integer);
var
  I:integer;
  btn:TComponent;
begin
  with ds1 do
  begin
    DisableControls;
    Filtered := False;
    if sID = 0 then    
       Filter := 'OffenUse <> 0'
    else
       Filter := 'ID = ' + IntToStr(sID);
    Filtered := True;
    ds1.First;
    while not Eof do
    begin
      btn := Self.FindComponent('btn_' + FieldByName('ID').AsString);
      if Assigned(Btn) then
         TbsSkinSpeedButton(btn).Destroy;
      Next;
    end;
    Filtered := False;
    EnableControls;
  end;
end;

function TFrmMyTool.GetFormNameAt(X, Y: Integer): string;
var
  P:TPoint;
  W:TWinControl;
begin
  P.X := x;
  p.y := y;
  W := FindVCLWindow(P);
  if (W <> nil) then
  begin
    while w.Parent <> nil do
    begin
      w := w.Parent;
    end;
    Result := w.Name;
  end
  else
    Result := '';
end;

procedure TFrmMyTool.HideFrm(hs: THideStyle; hsSpped: Integer);
var
  finalHeight:Integer;
begin
  if hs = hsHide then
  begin
    finalHeight := -(Self.height - 10);

    while Self.Top >= finalHeight do
    begin
      Self.Top := Self.Top - hsSpped;
    end;
    if Self.Top < finalHeight then
       Self.Top := finalHeight;
    SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);
  end;
  if hs = hsShow then
  begin
    finalHeight := 0;
    while Self.top < finalHeight do
    begin
      Self.Top := Self.Top + hsSpped;
    end;
    if Self.Top > finalHeight then
       Self.Top := finalHeight;
  end;

end;

procedure TFrmMyTool.lstContentDropFiles(Sender: TObject;
  FileNames: TStringList);
var
  I,count: Integer;
  ico:TIcon;
  FileInfo:SHFILEINFO;
  FileRec:PItemRec;
  F:file of PItemRec;
begin
  //提取exe图标
  for I := 0 to FileNames.Count - 1 do
  begin
   try
     ico := TIcon.Create;
     count := SHGetFileInfo(PAnsiChar(FileNames[I]),0,FileInfo,SizeOf(FileInfo),SHGFI_ICON);
     ico.Handle := FileInfo.hIcon;
     il1.AddIcon(ico);

     //保存到文件
     New(FileRec);
     try
       FileRec.FileName := ExtractFileName(FileNames[I]);
       FileRec.FilePath := FileNames[I];
       FileRec.IcoFile := TMemoryStream.Create;
       ico.SaveToStream(FileRec.IcoFile);

       ds1.Append;
       ds1.FieldByName('ID').AsInteger := ds1.RecordCount + 1;
       ds1.FieldByName('FileName').AsString := FileRec.FileName;
       ds1.FieldByName('FilePath').AsString := FileRec.FilePath;
       TBlobField(ds1.FieldByName('Ico')).LoadFromStream(FileRec.IcoFile);
       ds1.Post;

       ds1.SaveToFile(AppName);
       lstContent.Items.AddObject(FileRec.FileName,TObject(ds1.FieldByName('ID').AsInteger));
     finally
       FileRec.IcoFile.Free;
       Dispose(FileRec);
     end;
   finally
     ico.Free;
   end;
  end;
end;

procedure TFrmMyTool.lstContentListBoxDblClick(Sender: TObject);
begin
  OpenLink(Integer(lstContent.Items.Objects[lstContent.ItemIndex]))
end;

procedure TFrmMyTool.OpenLink(vID: Integer);
begin
  with ds1 do
  begin
    if Locate('ID',vID,[]) then
    begin
      ShellExecute(0,'open',PChar(FieldByName('FilePath').AsString),nil,nil,SW_NORMAL);
    end;
  end;
end;

procedure TFrmMyTool.tmr1Timer(Sender: TObject);
var
  Date,XQ,Time:string;
begin
  Date := FormatDateTime('yyyy年mm月dd日',now);
  case DayOfWeek(Now) - 1 of
    1: XQ := '星期一';
    2: XQ := '星期二';
    3: XQ := '星期三';
    4: XQ := '星期四';
    5: XQ := '星期五';
    6: XQ := '星期六';
    7: XQ := '星期日';
  end;
  time := FormatDateTime('hh:mm:ss',Now);
  lbdt.Caption := Date;
  lbXQ.Caption := XQ;
  lbTime.Caption := Time;
end;

procedure TFrmMyTool.tmr2Timer(Sender: TObject);
var
  winPos:TPoint;
begin
  if (Self.Top <= 3) or (Self.Left >= screen.Width - self.Width - 3) then
  begin
    GetCursorPos(winPos);
    if Self.Name = GetFormNameAt(winPos.X,winPos.y) then
    begin
      Self.tmr3.Enabled := False;
      HideFrm(hsShow,HideSpeed);
    end
    else
      tmr3.Enabled := True;
  end;  
end;

procedure TFrmMyTool.tmr3Timer(Sender: TObject);
begin
  if (Self.Top <= 20) and (Self.Top >= 0) then
  begin
    HideFrm(hsHide,HideSpeed);
    tmr3.Enabled := False;
  end;
end;

end.
