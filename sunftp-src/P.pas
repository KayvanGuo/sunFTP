{

 TPriority are removed from this project until further, the old TPriority
 component didn't work the way wanted!

}

unit P;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Sockets, StdCtrls, Spin, ComCtrls, IniFiles, Buttons, RXCtrls;

type
  TPForm = class(TForm)
    OpenDialog1: TOpenDialog;
    Timer: TTimer;
    Label8: TLabel;
    tvCategory: TTreeView;
    P: TPanel;
    N: TNotebook;
    Label9: TLabel;
    Bevel1: TBevel;
    Label11: TLabel;
    Bevel2: TBevel;
    Label12: TLabel;
    Bevel3: TBevel;
    Label13: TLabel;
    Bevel4: TBevel;
    Label14: TLabel;
    Bevel5: TBevel;
    Label15: TLabel;
    Bevel6: TBevel;
    Label23: TLabel;
    Bevel7: TBevel;
    Label5: TLabel;
    spPort: TSpinEdit;
    Label7: TLabel;
    spMaxClients: TSpinEdit;
    Label3: TLabel;
    eRestrict: TEdit;
    Label10: TLabel;
    lbRestricted: TListBox;
    btnAdd: TButton;
    btnDelete: TButton;
    btnClear: TButton;
    cbAutoStart: TCheckBox;
    cbMinimize: TCheckBox;
    cbAR: TCheckBox;
    Label4: TLabel;
    spServerInfo: TSpinEdit;
    Label17: TLabel;
    eLogfile: TEdit;
    cbLogEnable: TCheckBox;
    spMax: TSpinEdit;
    Label1: TLabel;
    btnBrowse: TSpeedButton;
    Label24: TLabel;
    Bevel8: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    Label26: TLabel;
    S: TSockets;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label27: TLabel;
    eServer: TEdit;
    Example: TLabel;
    RxLabel1: TRxLabel;
    Label16: TLabel;
    Label18: TLabel;
    GroupBox2: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    eServerAddress: TEdit;
    eServerName: TEdit;
    Image1: TImage;
    Label21: TLabel;
    Label22: TLabel;
    Label25: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    cbShowServerMsg: TCheckBox;
    cbShowRestrictMsg: TCheckBox;
    Label6: TLabel;
    Bevel9: TBevel;
    Image5: TImage;
    Label34: TLabel;
    mWelcome: TMemo;
    Label35: TLabel;
    eGoodbye: TMemo;
    Label36: TLabel;
    Label37: TLabel;
    RxLabel2: TRxLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure eServerNameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnBrowseClick(Sender: TObject);
    procedure eServerAddressMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure tvCategoryChange(Sender: TObject; Node: TTreeNode);
    procedure eServerChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbLogEnableClick(Sender: TObject);
    procedure cbShowServerMsgClick(Sender: TObject);
    procedure cbShowRestrictMsgClick(Sender: TObject);
    procedure cbARClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    procedure ServerInfo;
    procedure MainStartFTP;
    procedure MainStopFTP;
    procedure LoadIniFile;
    procedure SaveIniFile;
{ Private declarations }
  public
    { Public declarations }
  end;

var
  PForm: TPForm;
  Path: String;

Const
  LongListSeparator : Array[False..True] of Char = (' ', '-');

implementation

Uses Winsock, Main, UsersList;
{$R *.DFM}

function LocalIP : string;
type
TaPInAddr = array [0..10] of PInAddr;
PaPInAddr = ^TaPInAddr;
var
phe : PHostEnt;
pptr : PaPInAddr;
Buffer : array [0..63] of char;
I : Integer;
GInitData : TWSADATA;
begin
WSAStartup($101, GInitData);
Result := '';
GetHostName(Buffer, SizeOf(Buffer));
phe :=GetHostByName(buffer);
if phe = nil then Exit;
pptr := PaPInAddr(Phe^.h_addr_list);
I := 0;
while pptr^[I] <> nil do begin
result:=StrPas(inet_ntoa(pptr^[I]^));
Inc(I);
end;
WSACleanup;
end;

function Y2DateToStr(d : TDateTime ): string;
begin
   Result := FormatDateTime('yyyy.mm.dd hh:mm:ss', d);
end;

procedure TPForm.MainStopFTP;
begin
MainForm.FTPServer.DisconnectAll;
MainForm.FTPServer.Stop;
MainForm.lbLogfile.Items.Add(Y2DateToStr(Now)+' -- FTP Server stopped');
if cbLogEnable.Checked then
MainForm.lbLogfile.Items.SaveToFile(PForm.eLogfile.Text);
if MainForm.lbLogfile.Items.Count > spMax.Value then
MainForm.lbLogfile.Items.Delete(0);
MainForm.lbLogfile.ItemIndex := MainForm.lbLogfile.Items.Count -1 ;
MainForm.SB.Panels[1].Text := '0 User(s)';
end;

procedure TPForm.MainStartFTP;
Var
  FirstLine : String;
  I         : Integer;
begin
  if cbShowServerMsg.Checked then
    FirstLine := Format('%s FTP Server (SunFTP b9) ready on port %s...', [eServer.Text, MainForm.FTPServer.Port])
  else
    FirstLine := Format('SunFTP Server Project ready on port %s...', [MainForm.FTPServer.Port]);

  MainForm.FTPServer.Banner := Format('220%s%s', [LongListSeparator[mWelcome.Lines.Count>0], FirstLine]);
  for I:=0 to mWelcome.Lines.Count-1 do
    MainForm.FTPServer.Banner := Format('%s'^M^J+'220%s%s',
      [MainForm.FTPServer.Banner,
       LongListSeparator[PForm.mWelcome.Lines.Count-1>I], mWelcome.Lines[I]]);
{ ********************************************************************* }
   MainForm.FTPServer.Start;
   MainForm.lbLogfile.Items.Add(Y2DateToStr(Now)+' -- FTP Server started ('+MainForm.FTPServer.Port+', '+eServerAddress.Text+')');
   if cbLogEnable.Checked then
   MainForm.lbLogfile.Items.SaveToFile(PForm.eLogfile.Text);
   if cbLogEnable.Checked then begin
   MainForm.lbLogfile.Items.Add(Y2DateToStr(Now)+' -- Logging actions to file '+eLogfile.Text);
   if cbLogEnable.Checked then
   MainForm.lbLogfile.Items.SaveToFile(PForm.eLogfile.Text);
   end;
   if MainForm.lbLogfile.Items.Count > spMax.Value then
   MainForm.lbLogfile.Items.Delete(0);
   MainForm.lbLogfile.ItemIndex := MainForm.lbLogfile.Items.Count -1 ;
end;

procedure TPForm.ServerInfo;
begin
  if ((LocalIP = '0.0.0.0') or (LocalIP = '127.0.0.1')) then eServerAddress.Text := '127.0.0.1'
  else eServerAddress.Text := LocalIP;
  eServerName.Text := S.HostName;
end;

procedure TPForm.LoadIniFile;
var IniFile : TIniFile;
    CheckFile : String;
begin
IniFile := TIniFile.Create(Path+'conf\sunftp.ini');
CheckFile := Path+'conf\sunftp.ini';
 if FileExists(CheckFile) Then Begin
 { Server Settings }
 spPort.Value := IniFile.ReadInteger('Server', 'Port', spPort.Value);
  MainForm.FTPServer.Port := IntToStr(spPort.Value);
    MainForm.SB.Panels[0].Text := 'Port: '+MainForm.FTPServer.Port;
 spMaxClients.Value := IniFile.ReadInteger('Server', 'MaxClients', spMaxClients.Value);
  MainForm.FTPServer.MaxClients := spMaxClients.Value;
 eServer.Text := IniFile.ReadString('Server', 'ServerMsg', eServer.Text);
  Example.Caption := Format('Example: %s FTP Server (SunFTP b9) ready on port %s...', [eServer.Text, MainForm.FTPServer.Port]);
 eRestrict.Text := IniFile.ReadString('Server', 'RestrictMsg', eRestrict.Text); //New
 cbShowServerMsg.Checked := IniFile.ReadBool('Server', 'ShowServerMsg', cbShowServerMsg.Checked);
  eServer.Enabled := cbShowServerMsg.Checked;
 cbShowRestrictMsg.Checked := IniFile.ReadBool('Server', 'ShowRestrictMsg', cbShowRestrictMsg.Checked);
  eRestrict.Enabled := cbShowRestrictMsg.Checked;
 { Global Settings }
 cbAutoStart.Checked := IniFile.ReadBool('System', 'AutoStart', cbAutoStart.Checked);
 cbMinimize.Checked := IniFile.ReadBool('System', 'Minimized', cbMinimize.Checked);
  if cbMinimize.Checked then MainForm.WindowState := wsMinimized;
 spServerInfo.Value := IniFile.ReadInteger('System', 'ServerInfoInterval', spServerInfo.Value); //New
  Timer.Interval := spServerInfo.Value;
 cbAR.Checked := IniFile.ReadBool('System', 'AutoStartWin9x', cbAR.Checked);
  MainForm.AutoRunner.AutoRun := cbAR.Checked; 
  { Logging Settings }
 eLogfile.Text := IniFile.ReadString('Logging', 'Logfile', eLogfile.Text);
 cbLogEnable.Checked := IniFile.ReadBool('Logging', 'Enabled', cbLogEnable.Checked);
  if cbLogEnable.Checked then begin
  eLogfile.Enabled := True;
  end else begin
  eLogfile.Enabled := False;
  end;
 spMax.Value := IniFile.ReadInteger('Logging', 'MaxLines', spMax.Value);
 if cbAutoStart.Checked then MainStartFTP;
 end
 Else Begin
 spPort.Value := 21;
  MainForm.FTPServer.Port := IntToStr(spPort.Value);
 spMaxClients.Value := 10;
  MainForm.FTPServer.MaxClients := spMaxClients.Value;
 eLogfile.Text := Path+'logs\ftp.log';
 eServer.Text := eServerName.Text;
  Example.Caption := Format('Example: %s FTP Server (SunFTP b9) ready on port %s...', [eServer.Text, MainForm.FTPServer.Port]);
  Close;
 end;
end;

procedure TPForm.SaveIniFile;
var IniFile : TIniFile;
begin
 IniFile := TIniFile.Create(Path+'conf\sunftp.ini');
 IniFile.WriteInteger('Server', 'Port', spPort.Value);
 IniFile.WriteInteger('Server', 'MaxClients', spMaxClients.Value);
 IniFile.WriteString('Server', 'ServerMsg', eServer.Text);
 IniFile.WriteString('Server', 'RestrictMsg', eRestrict.Text); //New
 IniFile.WriteBool('Server', 'ShowServerMsg', cbShowServerMsg.Checked);
 IniFile.WriteBool('Server', 'ShowRestrictMsg', cbShowRestrictMsg.Checked);
 { Global Settings }
 IniFile.WriteBool('System', 'AutoStart', cbAutoStart.Checked);
 IniFile.WriteBool('System', 'Minimized', cbMinimize.Checked);
 IniFile.WriteInteger('System', 'ServerInfoInterval', spServerInfo.Value); //New
 IniFile.WriteBool('System', 'AutoStartWin9x', cbAR.Checked);
 { Logging Settings }
 IniFile.WriteString('Logging', 'Logfile', eLogfile.Text);
 IniFile.WriteBool('Logging', 'Enabled', cbLogEnable.Checked);
 IniFile.WriteInteger('Logging', 'MaxLines', spMax.Value);
end;

procedure TPForm.FormCreate(Sender: TObject);
var CH: String;
begin
Path := ExtractFilePath(ParamStr(0));
CH := Path+'conf\sunftp.ini';
tvCategory.FullCollapse;
tvCategory.FullExpand;
if FileExists(Path+'conf\welcome.msg') then
mWelcome.Lines.LoadFromFile(Path+'conf\welcome.msg');
if FileExists(Path+'conf\goodbye.msg') then
eGoodbye.Lines.LoadFromFile(Path+'conf\goodbye.msg');
ServerInfo;
LoadIniFile;
lbRestricted.Items.LoadFromFile(Path+'conf\restricted.ips');
 if not FileExists(CH) then begin
  MessageDlg('Since the file "'+CH+'" don''t exist, we need to edit the properties!', mtInformation, [mbOk], 0);
  PForm.ShowModal;
 end;
end;

procedure TPForm.btnAddClick(Sender: TObject);
var
  NewString: string;
  ClickedOK: Boolean;
begin
  ClickedOK := InputQuery('Restricted IP''s', 'Enter a new IP address', NewString);
  if ClickedOK then
  lbRestricted.Items.Add(NewString);
end;

procedure TPForm.btnDeleteClick(Sender: TObject);
var
i : integer;
begin
if lbRestricted.ItemIndex < 0 then Exit;
  for i := lbRestricted.items.count -1 downto 0  do
  begin
    if lbRestricted.selected[i] then
      lbRestricted.items.delete(i);
  end;
end;

procedure TPForm.btnClearClick(Sender: TObject);
begin
lbRestricted.Clear;
end;

procedure TPForm.eServerNameMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
eServerName.SelectAll;
eServerName.CopyToClipboard;
end;


procedure TPForm.btnBrowseClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := Path+'logs\';
  OpenDialog1.FileName := eLogfile.Text;
  OpenDialog1.DefaultExt := '.log';
  OpenDialog1.Filter := 'Log files (*.log)|*.log|All files (*.*)|*.*';
  if OpenDialog1.Execute then
  eLogfile.Text := OpenDialog1.FileName;
end;

procedure TPForm.eServerAddressMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
eServerAddress.SelectAll;
eServerAddress.CopyToClipboard;
end;

procedure TPForm.btnOKClick(Sender: TObject);
begin
SaveIniFile;
  mWelcome.Lines.SaveToFile(Path+'conf\welcome.msg');
  eGoodbye.Lines.SaveToFile(Path+'conf\goodbye.msg');
  MainForm.FTPServer.Port := IntToStr(spPort.Value);
  MainForm.FTPServer.MaxClients := spMaxClients.Value;
  Timer.Interval := spServerInfo.Value;
  MainForm.SB.Panels[0].Text := 'Port: '+MainForm.FTPServer.Port;
//  if MainForm.Enabled1.Checked = True Then begin
  if MainForm.btnFTPServer.Down Then begin
  MainStopFTP;
  MainStartFTP;
  end;
Close;
end;

procedure TPForm.btnCancelClick(Sender: TObject);
begin
Close;
end;

procedure TPForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
lbRestricted.Items.SaveToFile(Path+'conf\restricted.ips');
end;


procedure TPForm.TimerTimer(Sender: TObject);
begin
ServerInfo;
  eServerAddress.SelectAll;
   eServerAddress.CopyToClipboard;
    Edit1.Clear;
    Edit1.PasteFromClipboard;
    MainForm.e.Text := Edit1.Text;
   MainForm.lbLogfile.Items.Add(Y2DateToStr(Now)+' -- FTP Server running on IP '+MainForm.e.Text);
   if MainForm.lbLogfile.Items.Count > spMax.Value then
   MainForm.lbLogfile.Items.Delete(0);
   MainForm.lbLogfile.ItemIndex := MainForm.lbLogfile.Items.Count -1 ;
  if cbLogEnable.Checked then
 MainForm.lbLogfile.Items.SaveToFile(PForm.eLogfile.Text);
end;

procedure TPForm.tvCategoryChange(Sender: TObject; Node: TTreeNode);
begin
N.ActivePage := Node.Text;
end;

procedure TPForm.eServerChange(Sender: TObject);
begin
Example.Caption := Format('Example: %s FTP Server (SunFTP b9) ready on port %s...', [eServer.Text, MainForm.FTPServer.Port]);
end;

procedure TPForm.FormActivate(Sender: TObject);
begin
Example.Caption := Format('Example: %s FTP Server (SunFTP b9) ready on port %s...', [eServer.Text, MainForm.FTPServer.Port]);
end;

procedure TPForm.cbLogEnableClick(Sender: TObject);
begin
 if cbLogEnable.Checked then begin
  eLogfile.Enabled := True;
  end else begin
  eLogfile.Enabled := False;
  end;
end;

procedure TPForm.cbShowServerMsgClick(Sender: TObject);
begin
 eServer.Enabled := cbShowServerMsg.Checked;
end;

procedure TPForm.cbShowRestrictMsgClick(Sender: TObject);
begin
 eRestrict.Enabled := cbShowRestrictMsg.Checked;
end;

procedure TPForm.cbARClick(Sender: TObject);
begin
 MainForm.AutoRunner.AutoRun := cbAR.Checked;
end;

procedure TPForm.Edit1Change(Sender: TObject);
begin
with Edit1 do
 if Text = 'YES' then begin ServerInfo;
  eServerAddress.SelectAll;
   eServerAddress.CopyToClipboard;
    Edit1.Clear;
    Edit1.PasteFromClipboard;
    MainForm.e.Text := Edit1.Text;
   MainForm.lbLogfile.Items.Add(Y2DateToStr(Now)+' -- FTP Server running on IP '+MainForm.e.Text);
   if MainForm.lbLogfile.Items.Count > spMax.Value then
   MainForm.lbLogfile.Items.Delete(0);
   MainForm.lbLogfile.ItemIndex := MainForm.lbLogfile.Items.Count -1 ;
  if cbLogEnable.Checked then
 MainForm.lbLogfile.Items.SaveToFile(PForm.eLogfile.Text);
 end;
end;

end.
