program Project1;

uses
  Forms,
  UsersList in 'UsersList.pas' {fUsersList},
  UserManagement in 'UserManagement.pas',
  CFGStore in 'CFGStore.pas';

{$R *.RES}

Var
  UList : TUserManagement;
  CFG   : TCFGStoreINI;
begin
  Application.Initialize;
  Application.CreateForm(TfUsersList, fUsersList);
  CFG := TCFGStoreINI.Create('c:\temp\sunftp.ini');
  UList := TUserManagement.Create();
  UList.Load(CFG);
  fUsersList.Users := UList;
  Application.Run;
  UList.Save(CFG);
end.
