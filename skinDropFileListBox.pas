unit skinDropFileListBox;

interface

uses
  Classes,bsfilectrl,Messages,Windows,ShellAPI;

type
  TDropFileNotifyEvent = procedure (Sender:TObject;FileNames:TStringList) of object;

  TskinDropFileListBox = class(TbsSkinFileListBox)
  private
    FEnabled:Boolean;
    FDropFile:TDropFileNotifyEvent;

    procedure DropFiles(var Msg:Tmessage); message WM_DROPFILES;
    procedure SetDropEnabled(bEnabled:Boolean);
  public
    constructor Create(AOwner:TComponent);override;
  published
    property OnDropFiles: TDropFileNotifyEvent read FDropFile write FDropFile;
    property DropEnabled: Boolean read FEnabled write SetDropEnabled;
  end;

procedure Register;

implementation

{ TskinDropFileListBox }

procedure Register;
begin
  RegisterComponents('myDropFileList',[TskinDropFileListBox]);
end;

constructor TskinDropFileListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
end;

procedure TskinDropFileListBox.DropFiles(var Msg: Tmessage);
var
  FileNames:TStringList;
  FileName:array [0..MAX_PATH - 1] of Char;
  i,nCount:integer;
begin
  try
    FileNames := TStringList.Create;
    nCount := DragQueryFile(Msg.WParam,$FFFFFFFF,@FileName,MAX_PATH);

    for I := 0 to nCount - 1 do
    begin
      DragQueryFile(Msg.WParam,i,FileName,MAX_PATH);
      FileNames.Add(FileName);
    end;
    DragFinish(Msg.WParam);
    if Assigned(FDropFile) then
       FDropFile(Self,FileNames);
  finally
    FileNames.Free;
  end;
end;

procedure TskinDropFileListBox.SetDropEnabled(bEnabled: Boolean);
begin
  FEnabled := bEnabled;
  DragAcceptFiles(Handle,bEnabled);
end;

end.
