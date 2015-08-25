{
  Welcome to SunFTP Server Project, Build: 9(1)

  by Rasmus J.P. Allenheim, Jan Tomasek and others

  Code are compatible with Borland Delphi 3 Std, Pro and C/S
  To compile this project you need the following components:

  RX Libraries from MasterBanks (rx.demo.ru)
  ICS (July 25th 1999) by Franocis Piette (www.rtfm.be/fpiette)
  TSockets from Gary T. Desrosiers (included)
  TDirTree from Markus Stephany (included)
  TAutoRunner from Aleksey Kuznetsov (included)

  This code currently only compiles under Delphi 3

  All code is released under the "lesser" GPL (see license.txt for more info.)
  Code are now Y2K secured, due to a new DateTime function implemented.
  From Build: 9 the file "restricted.lst" have the new name "restricted.ips"

  If you make modifications to the code or use parts of it for
  personal use, please send the modified source to: rasmus@xs4all.dk
  but do not attach the compiled .exe module.

  You can always find the latest build at: http://xs4all.dk/sunftp

  If you have any questions or comments regarding this project, please
  send them to: sunftp@xs4all.dk and mark the mail "q/c".

  //Rasmus, 1999.08.25

  PS! Sorry for the lack of comments in the core source
  DS!
}

unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, FtpSrv, FtpSrvC, Menus, RXShell, AppEvent,
  Sockets, Buttons, Spin, IniFiles, Mask, ToolEdit, ToolWin, RxMenus, FMXUtils,
  AutoRunner, RxGrdCpt;

type
  TMainForm = class(TForm)
    SB: TStatusBar;
    Timer: TTimer;
    FTPServer: TFtpServer;
    lbLogfile: TListBox;
    TrayIcon: TRxTrayIcon;
    AppEvents: TAppEvents;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ServerEnabled1: TMenuItem;
    ImmediatelySutdown1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    UserManager1: TMenuItem;
    Properties1: TMenuItem;
    N3: TMenuItem;
    Rotatelogfile1: TMenuItem;
    Help1: TMenuItem;
    about1: TMenuItem;
    Images: TImageList;
    OD: TOpenDialog;
    N6: TMenuItem;
    Openalogfile1: TMenuItem;
    PopupMenu: TRxPopupMenu;
    Restore1: TMenuItem;
    N7: TMenuItem;
    Misc2: TMenuItem;
    FTPServer2: TMenuItem;
    N8: TMenuItem;
    Shutdown2: TMenuItem;
    Enabled2: TMenuItem;
    Properties2: TMenuItem;
    UserManager2: TMenuItem;
    N9: TMenuItem;
    About2: TMenuItem;
    ToolBar: TToolBar;
    btnOpenlogfile: TToolButton;
    ToolButton5: TToolButton;
    btnFTPServer: TToolButton;
    ToolButton1: TToolButton;
    btnProperties: TToolButton;
    btnUserManager: TToolButton;
    ToolButton2: TToolButton;
    btnRotateLogfile: TToolButton;
    ToolButton3: TToolButton;
    btnAbout: TToolButton;
    AutoRunner: TAutoRunner;
    btnIPRestrict: TToolButton;
    btnStayOnTop: TToolButton;
    IPRestriction1: TMenuItem;
    ToolButton4: TToolButton;
    N1: TMenuItem;
    Rotatelogfile2: TMenuItem;
    IPRestriction2: TMenuItem;
    N4: TMenuItem;
    Immediatelyshutdown1: TMenuItem;
    Grad: TRxGradientCaption;
    PopupMenu1: TPopupMenu;
    Copyselectiontoclipboard1: TMenuItem;
    e: TEdit;
    btnUdateIPInfo: TToolButton;
    UpdateIPinfo1: TMenuItem;
    UpdateIPinfo2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FTPServerClientCommand(Sender: TObject;
      Client: TFtpCtrlSocket; var Keyword, Params, Answer: String);
    procedure FTPServerClientConnect(Sender: TObject;
      Client: TFtpCtrlSocket; Error: Word);
    procedure FTPServerClientDisconnect(Sender: TObject;
      Client: TFtpCtrlSocket; Error: Word);
    procedure FTPServerAuthenticate(Sender: TObject;
      Client: TFtpCtrlSocket; UserName, Password: String;
      var Authenticated: Boolean);
    procedure FTPServerChangeDirectory(Sender: TObject;
      Client: TFtpCtrlSocket; Directory: String; var Allowed: Boolean);
    procedure FTPServerValidateDele(Sender: TObject;
      Client: TFtpCtrlSocket; var FilePath: String;
      var Allowed: Boolean);
    procedure FTPServerValidateGet(Sender: TObject; Client: TFtpCtrlSocket;
      var FilePath: String; var Allowed: Boolean);
    procedure FTPServerValidatePut(Sender: TObject; Client: TFtpCtrlSocket;
      var FilePath: String; var Allowed: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure AppEventsMinimize(Sender: TObject);
    procedure AppEventsRestore(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure FTPServerAnswerToClient(Sender: TObject;
      Client: TFtpCtrlSocket; var Answer: String);
    procedure FTPServerStart(Sender: TObject);
    procedure FTPServerStop(Sender: TObject);
    procedure btnUserManagerClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ImmediatelySutdown1Click(Sender: TObject);
    procedure btnPropertiesClick(Sender: TObject);
    procedure btnRotateLogfileClick(Sender: TObject);
    procedure AppEventsException(Sender: TObject; E: Exception);
    procedure btnAboutClick(Sender: TObject);
    procedure btnOpenlogfileClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Restore1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnFTPServerClick(Sender: TObject);
    procedure ServerEnabled1Click(Sender: TObject);
    procedure Enabled2Click(Sender: TObject);
    procedure btnIPRestrictClick(Sender: TObject);
    procedure btnStayOnTopClick(Sender: TObject);
    procedure Copyselectiontoclipboard1Click(Sender: TObject);
    procedure btnUdateIPInfoClick(Sender: TObject);
  private
    procedure StartFTP;
    procedure StopFTP;
    procedure LoadIniFile;
    procedure SaveIniFile;  
    procedure UpdateClientCount;
    procedure AddLog(Line: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Path, Logfile : String;

Const
  LongListSeparator : Array[False..True] of Char = (' ', '-');

implementation

uses
  UsersList, Config, UserManagement, P;

{$R *.DFM}

function Y2DateToStr(d : TDateTime ): string;
begin
   Result := FormatDateTime('yyyy.mm.dd hh:mm:ss', d);
end;

procedure TMainForm.LoadIniFile;
var IniFile : TIniFile;
    CheckFile : String;
begin
IniFile := TIniFile.Create(Path+'conf\sunftp.ini');
CheckFile := Path+'conf\sunftp.ini';
 if FileExists(CheckFile) Then Begin
 MainForm.Left := IniFile.ReadInteger('Main', 'Left', MainForm.Left);
 MainForm.Top := IniFile.ReadInteger('Main', 'Top', MainForm.Top);
 MainForm.Height := IniFile.ReadInteger('Main', 'Height', MainForm.Height);
 MainForm.Width := IniFile.ReadInteger('Main', 'Width', MainForm.Width);
 end;
end;

procedure TMainForm.SaveIniFile;
var IniFile : TIniFile;
begin
IniFile := TIniFile.Create(Path+'conf\sunftp.ini');
 IniFile.WriteInteger('Main', 'Left', MainForm.Left);
 IniFile.WriteInteger('Main', 'Top', MainForm.Top);
 IniFile.WriteInteger('Main', 'Height', MainForm.Height);
 IniFile.WriteInteger('Main', 'Width', MainForm.Width);
end;

procedure TMainForm.AddLog(Line: String);
begin
  lbLogfile.Items.Add(Line);
  if lbLogfile.Items.Count > PForm.spMax.Value then
  lbLogfile.Items.Delete(0);
  lbLogFile.ItemIndex:=lbLogfile.Items.Count-1;
  if PForm.cbLogEnable.Checked then
  lbLogfile.Items.SaveToFile(PForm.eLogfile.Text);
end;

procedure TMainForm.StartFTP;
Var
  FirstLine : String;
  I         : Integer;
begin
  if PForm.cbShowServerMsg.Checked then
    FirstLine := Format('%s FTP Server (SunFTP b9) ready on port %s...', [PForm.eServer.Text, FTPServer.Port])
  else
    FirstLine := Format('SunFTP Server Project ready on port %s...', [FTPServer.Port]);

  FTPServer.Banner := Format('220%s%s', [LongListSeparator[PForm.mWelcome.Lines.Count>0], FirstLine]);
  for I:=0 to PForm.mWelcome.Lines.Count-1 do
    FTPServer.Banner := Format('%s'^M^J+'220%s%s',
      [FTPServer.Banner,
       LongListSeparator[PForm.mWelcome.Lines.Count-1>I], PForm.mWelcome.Lines[I]]);
{ ********************************************************************* }
FTPServer.Start;
AddLog(Y2DateToStr(Now)+' -- FTP Server started ('+FTPServer.Port+', '+PForm.eServerAddress.Text+')');
if PForm.cbLogEnable.Checked then AddLog(Y2DateToStr(Now)+' -- Logging actions to file '+PForm.eLogfile.Text);
end;

procedure TMainForm.StopFTP;
begin
FTPServer.DisconnectAll;
FTPServer.Stop;
AddLog(Y2DateToStr(Now)+' -- FTP Server stopped');
UpdateClientCount;
end;

procedure TMainForm.UpdateClientCount;
begin
    if FTPServer.ClientCount = 0 then
        SB.Panels[1].Text := '0 User(s)'
    else
        SB.Panels[1].Text := IntToStr(FTPServer.ClientCount) + ' User(s)';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
Path := ExtractFilePath(ParamStr(0));
TimerTimer(Sender);

 if FileExists(Path+'logs\ftp.bak')
 then DeleteFile(Path+'logs\ftp.bak');
 { Make sure to delete the old FTP.BAK before
 doing anything else, god bless object pascal! }
 
 if FileExists(Path+'logs\ftp.log')
 then  RenameFile(Path+'logs\ftp.log', Path+'logs\ftp.bak');
 { Ok, since the last procedure just loaded an already existing
   logfile, here's a nicer way to do things, the already existing
   file "ftp.log" in the "..\logs\" directory is being renamed
   to "ftp.bak", a backup of the elder logfile is made!
   ps! the function "RenameFile" are done with help from the unit
   file: FMXUtils, it's declared already in the beginning
   ds! } 

if FileExists(Path+'conf\restricted.hosts') then
  if lbLogfile.Items.Count > PForm.spMax.Value then begin
  lbLogfile.Items.Delete(0);
  end;
  lbLogFile.ItemIndex:=lbLogfile.Items.Count-1;
LoadIniFile;
end;

Function IsReRootAble(Const Command:String):Boolean;
Begin
  Result:=False;

//Result:= Command='PORT'; if Result then Exit;
  Result:= Command='STOR'; if Result then Exit;
  Result:= Command='RETR'; if Result then Exit;
  Result:= Command='CWD' ; if Result then Exit;
  Result:= Command='XPWD'; if Result then Exit;
  Result:= Command='PWD' ; if Result then Exit;
//Result:= Command='USER'; if Result then Exit;
//Result:= Command='PASS'; if Result then Exit;
//Result:= Command='LIST'; if Result then Exit;
  Result:= Command='NLST'; if Result then Exit;
  Result:= Command='TYPE'; if Result then Exit;
  Result:= Command='SYST'; if Result then Exit;
  Result:= Command='QUIT'; if Result then Exit;
  Result:= Command='DELE'; if Result then Exit;
  Result:= Command='SIZE'; if Result then Exit;
  Result:= Command='REST'; if Result then Exit;
  Result:= Command='RNFR'; if Result then Exit;
  Result:= Command='RNTO'; if Result then Exit;
  Result:= Command='MKD' ; if Result then Exit;
  Result:= Command='RMD' ; if Result then Exit;
//Result:= Command='ABOR'; if Result then Exit;
  Result:= Command='PASV'; if Result then Exit;
//Result:= Command='NOOP'; if Result then Exit;
  Result:= Command='CDUP'; if Result then Exit;
  Result:= Command='APPE'; if Result then Exit;
  Result:= Command='STRU'; if Result then Exit;
  Result:= Command='XMKD'; if Result then Exit;
  Result:= Command='XRMD'; if Result then Exit;
End;

procedure TMainForm.FTPServerClientCommand(Sender: TObject; Client: TFtpCtrlSocket; var Keyword, Params, Answer: String);
Var
  UE: TUserElement;
begin
  AddLog(Y2DateToStr(Now)+' -- ' + Client.GetPeerAddr + ' ' + Keyword + ' ' + Params);

  UE      := TUserElement(Client.UserData);
  if not Assigned(UE) then Exit;

  if not (upLeaveHome in UE.Permisions) then
    if IsReRootAble(Keyword) then
      if (Params<>'')and(Params[1] in ['\', '/'])and(not (Params[2] in ['\', '/'])) then begin
        Delete(Params, 1, 1);
        Params:=UE.HomeDir+Params;
        AddLog(Y2DateToStr(Now)+' -- ' + Client.GetPeerAddr + ' ReRooted ' + Keyword + ' ' + Params);
      end;
      end;

procedure TMainForm.FTPServerClientConnect(Sender: TObject;
  Client: TFtpCtrlSocket; Error: Word);
var i : integer;
begin
  for i := 0 to PForm.lbRestricted.Items.Count - 1 do begin
  if Client.GetPeerAddr = PForm.lbRestricted.Items[i] then begin
  if PForm.cbShowRestrictMsg.Checked then Client.SendStr('421 '+PForm.eRestrict.Text+#13#10);
  Client.Close;
  Exit;
  end else begin
AddLog(Y2DateToStr(Now)+' -- '+Client.GetPeerAddr+' connected');
UpdateClientCount;
end;
end;
end;

procedure TMainForm.FTPServerClientDisconnect(Sender: TObject; Client: TFtpCtrlSocket; Error: Word);
begin
  AddLog(Y2DateToStr(Now)+' -- '+Client.GetPeerAddr+' disconnected');
  UpdateClientCount;
end;

procedure TMainForm.FTPServerAuthenticate(Sender: TObject; Client: TFtpCtrlSocket; UserName, Password: String; var Authenticated: Boolean);
begin
  Authenticated := Config.UserManag.VerifyUser(UserName, Password);
  if Authenticated then begin
    { In Client.UserData we will store pointer to user's information
      in database }
    Client.UserData := Longint(Config.UserManag.GetUserByName(UserName));
    AddLog(Y2DateToStr(Now)+' -- User "'+UserName+'" authenticated');
    UpdateClientCount;
    if Client.UserData=0 then begin { Internal error !!! }
      AddLog(Y2DateToStr(Now)+' -- User "'+UserName+'" not authenticated');
      Authenticated := False;
      UpdateClientCount;
      exit;
    end;
    Client.HomeDir := TUserElement(Client.UserData).HomeDir;
  end;
end;

procedure TMainForm.FTPServerChangeDirectory(Sender: TObject; Client: TFtpCtrlSocket; Directory: String; var Allowed: Boolean);
Var
  UE: TUserElement;
begin
  Allowed := False;
  UE      := TUserElement(Client.UserData);
  if not Assigned(UE) then Exit;
  Allowed := UE.CanChangeTo(Directory);
end;

procedure TMainForm.FTPServerValidateDele(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: String; var Allowed: Boolean);
Var
  UE: TUserElement;
begin
  Allowed := False;
  UE      := TUserElement(Client.UserData);
  if not Assigned(UE) then Exit;
  Allowed := UE.CanDelete(FilePath);
end;

procedure TMainForm.FTPServerValidateGet(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: String; var Allowed: Boolean);
Var
  UE: TUserElement;
begin
  Allowed := False;
  UE      := TUserElement(Client.UserData);
  if not Assigned(UE) then Exit;
  Allowed := UE.CanReadFrom(FilePath);
end;

procedure TMainForm.FTPServerValidatePut(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: String; var Allowed: Boolean);
Var
  UE: TUserElement;
begin
  Allowed := False;
  UE      := TUserElement(Client.UserData);
  if not Assigned(UE) then Exit;
  Allowed := UE.CanWriteTo(FilePath);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
SaveIniFile;
end;

procedure TMainForm.AppEventsMinimize(Sender: TObject);
begin
if PForm.cbMinimize.Checked then begin
  TrayIcon.Active := true;
   ShowWindow(Application.Handle, SW_HIDE);
    end else begin end;
end;

procedure TMainForm.AppEventsRestore(Sender: TObject);
begin
if PForm.cbMinimize.Checked then begin
  TrayIcon.Active := false;
   ShowWindow(Application.Handle, SW_SHOW);
   Application.BringToFront;
    end else begin end;
end;

procedure TMainForm.TrayIconDblClick(Sender: TObject);
begin
Application.Restore;
end;

{$IFDEF VER100}
type
  TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase);

function StringReplace(const S, OldPattern, NewPattern: string;
  Flags: TReplaceFlags): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := AnsiPos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;
{$ENDIF}

procedure TMainForm.FTPServerAnswerToClient(Sender: TObject; Client: TFtpCtrlSocket; var Answer: String);
var
  strWork   : string;
  strAnswer : string;
  UE        : TUserElement;
  FirstLine : String;
  I         : Integer;
begin
  if Copy(Answer, 1, 3)='221' then begin
    FirstLine := 'Goodbye'; 
    Answer := Format('221%s%s', [LongListSeparator[PForm.eGoodbye.Lines.Count>0], FirstLine]);
    for I:=0 to PForm.eGoodbye.Lines.Count-1 do
      Answer := Format('%s'^M^J+'221%s%s', [Answer,
       LongListSeparator[PForm.eGoodbye.Lines.Count-1>I], PForm.eGoodbye.Lines[I]]);
       
  end else begin
    UE      := TUserElement(Client.UserData);
    if not Assigned(UE) then Exit;
    if not (upLeaveHome in UE.Permisions) then begin
      strWork   := StringReplace(Client.HomeDir, '\', '/', [rfReplaceAll, rfIgnoreCase]);
      strAnswer := StringReplace(Answer, '\', '/', [rfReplaceAll, rfIgnoreCase]);
      if Pos(UpperCase(strWork), UpperCase(strAnswer))>0 then
        Answer := StringReplace(strAnswer, strWork, '/', [rfReplaceAll, rfIgnoreCase]);
    end;
  end;
end;

procedure TMainForm.FTPServerStart(Sender: TObject);
begin
btnFTPServer.Down := True;
//Enabled1.Checked := True;
Enabled2.Checked := True;
ServerEnabled1.Checked := True;
TrayIcon.Hint := 'SunFTP Server Project [Active/'+FTPServer.Port+']';
end;

procedure TMainForm.FTPServerStop(Sender: TObject);
begin
btnFTPServer.Down := False;
//Enabled1.Checked := False;
Enabled2.Checked := False;
ServerEnabled1.Checked := False;
TrayIcon.Hint := 'SunFTP Server Project [Inactive/'+FTPServer.Port+']';
end;

procedure TMainForm.btnUserManagerClick(Sender: TObject);
begin
Application.Restore;
UsersListForm.Users:=Config.UserManag;
UsersListForm.ShowModal;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
MainForm.Close;
end;

procedure TMainForm.ImmediatelySutdown1Click(Sender: TObject);
begin
   StopFTP;
   Application.Terminate;
   { We ignore the question if we really want to
     quit SunFTP, everything is freed, no more, no less! }
end;

procedure TMainForm.btnPropertiesClick(Sender: TObject);
begin
Application.Restore;
PForm.N.ActivePage := 'Server';
PForm.ShowModal;
end;

procedure TMainForm.btnRotateLogfileClick(Sender: TObject);
begin
lbLogfile.Clear;
AddLog(Y2DateToStr(Now)+' -- Logfile rotated');
end;

procedure TMainForm.AppEventsException(Sender: TObject; E: Exception);
begin
Exit; //No more exception errors
end;

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
Application.Restore;
PForm.N.ActivePage := 'About';
PForm.ShowModal;
end;

procedure TMainForm.btnOpenlogfileClick(Sender: TObject);
begin
 OD.InitialDir := Path+'logs\';
if not OD.Execute then exit;
 lbLogfile.Clear;
 lbLogfile.Items.LoadFromFile(OD.FileName);
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
SB.Panels[2].Text := 'Build: 9 -- ['+Y2DateToStr(Now)+']';
end;

procedure TMainForm.Restore1Click(Sender: TObject);
begin
Application.Restore;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
MessageBeep(MB_ICONQUESTION);
  CanClose:= MessageDlg('Do you wish to quit and shutdown SunFTP?',
    mtConfirmation, [mbYes, mbNO], 0) = mrYes
end;

procedure TMainForm.btnFTPServerClick(Sender: TObject);
begin
if btnFTPServer.Down Then Begin
   StartFTP;
   //Start FTP Code here
   end
   else Begin
   StopFTP;
   //Stop FTP Code here
   end;
end;

procedure TMainForm.ServerEnabled1Click(Sender: TObject);
begin
 if not ServerEnabled1.Checked then begin
   StartFTP;
   //Start FTP Code here
   end
   else Begin
   StopFTP;
   //Stop FTP Code here
   end;
end;

procedure TMainForm.Enabled2Click(Sender: TObject);
begin
 if not Enabled2.Checked then begin
   StartFTP;
   //Start FTP Code here
   end
   else Begin
   StopFTP;
   //Stop FTP Code here
   end;
end;

procedure TMainForm.btnIPRestrictClick(Sender: TObject);
begin
Application.Restore;
PForm.N.ActivePage := 'IP Restriction';
PForm.ShowModal;
end;

procedure TMainForm.btnStayOnTopClick(Sender: TObject);
begin
if btnStayOnTop.Down Then Begin
   MainForm.FormStyle := fsStayOnTop;
   Grad.Active := False;
   Grad.Active := True;
   Grad.Update;
   end
   else Begin
   MainForm.FormStyle := fsNormal;
   Grad.Active := False;
   Grad.Active := True;
   Grad.Update;
   end;
end;

procedure TMainForm.Copyselectiontoclipboard1Click(Sender: TObject);
var Selection : String;
begin
With lbLogfile Do
Selection := Items[ItemIndex];
e.Text := Selection;
e.SelectAll;
e.CopyToClipboard;
{ In this procedure we basically just copy the selection
  to the clipboard, ok it's not nice I know, but it works
  hehe ;) }
end;


procedure TMainForm.btnUdateIPInfoClick(Sender: TObject);
begin
PForm.Edit1.Text := 'YES';
{ Not a very nice trick, but hey it works man :) }
end;

end.

