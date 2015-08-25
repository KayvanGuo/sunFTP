program SunFTP;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Config in 'Config.pas',
  CFGStore in 'UserManagement\CFGStore.pas',
  UserManagement in 'UserManagement\UserManagement.pas',
  UsersList in 'UserManagement\UsersList.pas' {UsersListForm},
  P in 'P.pas' {PForm},
  DirFrm in 'BrowseDir\DirFrm.pas' {DirForm};

{$R *.RES}
 
begin
  Application.Initialize;
  Application.Title := 'SunFTP Server Project';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TUsersListForm, UsersListForm);
  Application.CreateForm(TPForm, PForm);
  Application.CreateForm(TDirForm, DirForm);
  Config.Init('users.ini');
  Application.Run;
  Config.Done;
end.
