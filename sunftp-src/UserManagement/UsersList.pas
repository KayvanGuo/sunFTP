unit UsersList;

interface

uses
{  Windows, Forms, StdCtrls, ExtCtrls,
  ToolEdit, Controls, Grids, Classes,
  Mask, Messages, UserManagement, SysUtils; }

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Sockets, StdCtrls, Spin, ComCtrls, IniFiles, Buttons, Grids,
  Mask, ToolEdit, UserManagement;


type
  TUsersListForm = class(TForm)
    pnButtons: TPanel;
    pnMain: TPanel;
    pnUserProperties: TPanel;
    pnUsersList: TPanel;
    UsersList: TStringGrid;
    UserNameL: TLabel;
    UserName: TEdit;
    HomeDirectoryL: TLabel;
    Password: TEdit;
    PasswordL: TLabel;
    AllowLeaveHomeDir: TCheckBox;
    AllowRead: TCheckBox;
    AllowWrite: TCheckBox;
    AllowDelete: TCheckBox;
    Bevel1: TBevel;
    btnClose: TButton;
    Add: TButton;
    Delete: TButton;
    Bevel2: TBevel;
    HomeDirectory: TEdit;
    btnBrowse: TSpeedButton;
    Image1: TImage;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure UsersListSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure UserPropChanged(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    FUsers        : TUserManagement;
    FSelectedUser : TUserElement;
    LockUpdate    : Boolean;
    procedure WUsers(aUsers: TUserManagement);
    procedure CheckDialogs;
    procedure UpdateAll;
    procedure WUserProperties(aUser: TUserElement);
    function  RUserProperties: TUserElement;
    procedure GetSelectedUser;
  public
    procedure WMGetMinMaxInfo(var MSG: Tmessage); message WM_GETMINMAXINFO;
    property Users:TUserManagement read FUsers write WUsers;
  end;

var
  UsersListForm: TUsersListForm;

implementation

Uses DirFrm;
{$R *.DFM}

procedure TUsersListForm.FormCreate(Sender: TObject);
begin
  UsersList.Cells[0, 0] := 'User name';
  UsersList.Cells[1, 0] := 'Permissions';
  UsersList.Cells[2, 0] := 'Home directory';
  FUsers := nil;
  FSelectedUser := nil;
  LockUpdate := False;
end;

procedure TUsersListForm.FormResize(Sender: TObject);
begin
  UsersList.ColWidths[0] := Trunc(UsersList.Width*0.2);
  UsersList.ColWidths[1] := Trunc(UsersList.Width*0.2);
  UsersList.ColWidths[2] := UsersList.Width-UsersList.ColWidths[0]-
    UsersList.ColWidths[1]-UsersList.GridLineWidth*(UsersList.ColCount*2);

  btnClose.Top := Height-btnClose.Height*2-6;
end;

procedure TUsersListForm.WMGetMinMaxInfo(var MSG: Tmessage);
begin
  PMinMaxInfo(MSG.lparam)^.ptMaxTrackSize.X := Width;
  PMinMaxInfo(MSG.lparam)^.ptMinTrackSize.X := Width;
  PMinMaxInfo(MSG.lparam)^.ptMinTrackSize.Y := pnUserProperties.Height*3;
end;

procedure TUsersListForm.WUsers(aUsers: TUserManagement);
begin
  FUsers := aUsers;
  UpdateAll;
  GetSelectedUser;
  WUserProperties(FSelectedUser);
  CheckDialogs;
end;

procedure TUsersListForm.CheckDialogs;
begin
  Delete.Enabled            := FSelectedUser<>nil;
  UserName.Enabled          := FSelectedUser<>nil;
  UserNameL.Enabled         := FSelectedUser<>nil;
  Password.Enabled          := FSelectedUser<>nil;
  PasswordL.Enabled         := FSelectedUser<>nil;
//  HomeDirectory.Enabled     := FSelectedUser<>nil;
  HomeDirectoryL.Enabled    := FSelectedUser<>nil;
  btnBrowse.Enabled         := FSelectedUser<>nil;
  AllowLeaveHomeDir.Enabled := FSelectedUser<>nil;
  AllowRead.Enabled         := FSelectedUser<>nil;
  AllowWrite.Enabled        := FSelectedUser<>nil;
  AllowDelete.Enabled       := FSelectedUser<>nil;
end;

function Max(A,B: Integer):Integer;
begin
  If A>B Then Result:=A Else Result:=B;
end;
procedure TUsersListForm.UpdateAll;
Var
  I: Integer;
  OldLockUpdate : Boolean;
begin
  OldLockUpdate := LockUpdate;
  LockUpdate    := True;
  try
    UsersList.RowCount := Max(FUsers.Count+1, 2);
    if FUsers.Count=0 then begin
      UsersList.Cells[0, 1] := '';
      UsersList.Cells[1, 1] := '';
      UsersList.Cells[2, 1] := '';
      UsersList.Objects[0, 1] := nil;
    end;

    For I:=0 To FUsers.Count-1 do Begin
      UsersList.Cells[0, I+1] := FUsers.Users[I].UserName;
      UsersList.Cells[1, I+1] := FUsers.Users[I].PermisionsAsString;
      UsersList.Cells[2, I+1] := FUsers.Users[I].HomeDir;
      UsersList.Objects[0, I+1] := FUsers.Users[I];
    End;
  finally
    LockUpdate := OldLockUpdate;
  end;
end;

procedure TUsersListForm.GetSelectedUser;
begin
  FSelectedUser := TUserElement(UsersList.Objects[0, UsersList.Selection.Top]);
end;

procedure TUsersListForm.AddClick(Sender: TObject);
Var
  NewUser : TUserElement;
  OrigName: String;
  I       : Integer;
  GR      : TGridRect;
begin
  NewUser := TUserElement.Create;
  OrigName:= NewUser.UserName;
  I       := 1;
  while FUsers.AddUser(NewUser)=-1 do begin
    NewUser.UserName := OrigName+IntToStr(I);
    Inc(I);
  end;
  { Display it }
  FSelectedUser:=NewUser;
  WUserProperties(FSelectedUser);
  UpdateAll;
  { Move selector }
  GR.Left  := UsersList.Selection.Left;
  GR.Right := UsersList.Selection.Right;
  GR.Top   := UsersList.RowCount-1;
  GR.Bottom:= UsersList.RowCount-1;
  UsersList.Selection := GR;

  CheckDialogs;
end;

procedure TUsersListForm.WUserProperties(aUser: TUserElement);
Var
  OldLockUpdate : Boolean;
begin
  OldLockUpdate := LockUpdate;
  LockUpdate    := True;
  try
    If assigned(aUser) then begin
      UserName.Text             := aUser.UserName;
      Password.Text             := aUser.Password;
      HomeDirectory.Text        := aUser.HomeDir;
      AllowRead.Checked         := upRead in aUser.Permisions;
      AllowWrite.Checked        := upWrite in aUser.Permisions;
      AllowDelete.Checked       := upDelete in aUser.Permisions;
      AllowLeaveHomeDir.Checked := upLeaveHome in aUser.Permisions;
    end else begin
      UserName.Text             := '';
      Password.Text             := '';
      HomeDirectory.Text        := '';
      AllowRead.Checked         := False;
      AllowWrite.Checked        := False;
      AllowDelete.Checked       := False;
      AllowLeaveHomeDir.Checked := False;
    end;
  finally
    LockUpdate := OldLockUpdate;
  end;
end;

function  TUsersListForm.RUserProperties: TUserElement;
begin
  Result := FSelectedUser;
  Result.UserName   := UserName.Text;
  Result.Password   := Password.Text;
  Result.HomeDir    := HomeDirectory.Text;
  Result.Permisions := [];
  if AllowRead.Checked         then Result.Permisions := Result.Permisions + [upRead];
  if AllowWrite.Checked        then Result.Permisions := Result.Permisions + [upWrite];
  if AllowDelete.Checked       then Result.Permisions := Result.Permisions + [upDelete];
  if AllowLeaveHomeDir.Checked then Result.Permisions := Result.Permisions + [upLeaveHome];
end;

procedure TUsersListForm.UsersListSelectCell(Sender: TObject; Col, Row: Integer; var CanSelect: Boolean);
begin
  { Locking is absolutely required!!! Without it you will get terrible GPF }
  if LockUpdate then exit;
  LockUpdate := True;
  try
    FSelectedUser := TUserElement(UsersList.Objects[0, Row]);
    CheckDialogs;
    WUserProperties(FSelectedUser);
  finally
    LockUpdate := False;
  end;
end;

procedure TUsersListForm.UserPropChanged(Sender: TObject);
begin
  if LockUpdate then exit;
  RUserProperties;
  UpdateAll;
end;

procedure TUsersListForm.DeleteClick(Sender: TObject);
begin
  if FUsers.Count<0 then exit;
  FUsers.RemoveUser(FSelectedUser.UserName).Free;
  UpdateAll;
  GetSelectedUser;
  WUserProperties(FSelectedUser);
  CheckDialogs;
end;

procedure TUsersListForm.btnBrowseClick(Sender: TObject);
begin
DirForm.Label1.Caption := HomeDirectory.Text;
DirForm.DirTree.Directory := HomeDirectory.Text;
DirForm.ShowModal;
if LockUpdate then exit;
RUserProperties;
UpdateAll;
end;

end.
