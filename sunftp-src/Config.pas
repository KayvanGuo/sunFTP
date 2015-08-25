unit Config;

interface

Uses
  CFGStore, UserManagement, SysUtils;
  
Var
  UserManag : TUserManagement;
  CFGS      : TCFGStore;
  Path      : String; //This is line were added

procedure Init(Const ININame: String);
procedure Done;

implementation

procedure Init(Const ININame: String);
begin
  Path := ExtractFilePath(ParamStr(0))+'conf\'; //This line were added
  CFGS := TCFGStoreINI.Create(Path+ININame); //This line were changed
  UserManag := TUserManagement.Create;
  UserManag.Load(CFGS);
end;

procedure Done;
begin
  UserManag.Save(CFGS);
  UserManag.Destroy;
  CFGS.Destroy;
end;

end.
