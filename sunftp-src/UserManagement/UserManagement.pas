unit UserManagement;

interface
Uses
  CFGStore, Classes;

Type
  TUserPermisions_ = (upRead, upWrite, upDelete, upLeaveHome);
  TUserPermisions = set of TUserPermisions_;
  TOnUserNameChange = procedure(Sender: TObject; Const Old, New: String) of object;
  TUserElement = class(TObject)
  private
    FUserName   : String;
    FPassword   : String;
    FHomeDir    : String;
    FPermisions : TUserPermisions;
    FOnUserNameChange : TOnUserNameChange;
    procedure WUserName(aUserName: String);
    function RPermisionsAsString:String;
    procedure WPermisionsAsString(aPermisionsString:String);
  public
    constructor Create;
    constructor CreateDefined(Const aUserName, aPassword, aHomeDir: String; aPermisions: TUserPermisions);
    function Load(CFG: TCFGStore; Const aUserName: String):Boolean;
    procedure Save(CFG: TCFGStore);
    function IsUnderHome(Const FileName:String):Boolean;
    function CanWriteTo(Const FileName:String):Boolean;
    function CanReadFrom(Const FileName:String):Boolean;
    function CanDelete(Const Path:String):Boolean;
    function CanChangeTo(Const Path:String):Boolean;

    property UserName: String read FUserName write WUserName;
    property Password: String read FPassword write FPassword;
    property HomeDir: String read FHomeDir write FHomeDir;
    property Permisions: TUserPermisions read FPermisions write FPermisions;
    property PermisionsAsString: String read RPermisionsAsString write WPermisionsAsString;
    property OnUserNameChange: TOnUserNameChange read FOnUserNameChange write FOnUserNameChange;
  End;

  TUserManagement = class(TObject)
  private
    FUsersList : TStringList;
    function RUsers(Index: Integer):TUserElement;
    function RCount:Integer;
    procedure UserNameChange(Sender: TObject; Const Old, New: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load(CFG: TCFGStore);
    procedure Save(CFG: TCFGStore);
    function AddUser(aUser: TUserElement):Integer;
    function RemoveUser(Const aUserName: String):TUserElement;
    function IndexOf(Const aUserName:String):Integer;
    function VerifyUser(Const aUserName, aPassword: String):Boolean;
    function GetUserByName(Const aUserName: String): TUserElement;

    property Users[Index:Integer]:TUserElement read RUsers; default;
    property Count:Integer read RCount;
  End;

implementation
Uses
  SysUtils;
  
Const
  ctPassword      = 'Password';
  ctHomeDir       = 'HomeDir';
  ctPermisions    = 'Permissions';
  ctAllowedUsers  = 'AllowedUsers';
  ctListUserName  = 'UserName.%d';

  { This is not good, right way is to declare some class which will hold
    global configuration and load this value ... }
  { DefaultHomeDir    = 'C:\temp\anonymous'; } //I have let this out, due to default settings
  DefaultUserName   = 'anonymous';
  DefaultPermisions = '';
{******************************************************************************}
{*                                                                            *}
{* Global stuff                                                               *}
{*                                                                            *}
{******************************************************************************}
Function GetRandomPassword:String;
Var
  I: Integer;
Begin
  SetLength(Result, 15);
  Randomize;
  For I:=1 To Length(Result) Do Result[I]:=Char(33+Round(90*Random));
End;

{******************************************************************************}
{*                                                                            *}
{* TUserElement                                                               *}
{*                                                                            *}
{******************************************************************************}
constructor TUserElement.Create;
begin
  Inherited Create;

  FUserName      := DefaultUserName;
  FPassword      := GetRandomPassword; { Nice feature ;: }
  FHomeDir       := ExtractFilePath(ParamStr(0))+'users\user_anonymous\'; //Changed this, I think this is better, what do you think?
  FPermisions    := [];           
end; {-- TUserElement.Create --------------------------------------------------}

constructor TUserElement.CreateDefined(Const aUserName, aPassword, aHomeDir: String; aPermisions: TUserPermisions);
Begin
  Inherited Create;

  FUserName   := aUserName;
  FPassword   := aPassword;
  FHomeDir    := aHomeDir;
  FPermisions := aPermisions;
End; {-- TUserElement.CreateDefined -------------------------------------------}

function TUserElement.Load(CFG: TCFGStore; Const aUserName: String):Boolean;
Var
  RandomPassword : String;
Begin
  RandomPassword := GetRandomPassword;

  FUserName         := aUserName;
  FPassword         := CFG.ReadString(aUserName, ctPassword, RandomPassword);
  FHomeDir          := CFG.ReadString(aUserName, ctHomeDir,  ExtractFilePath(ParamStr(0))+'users\user_anonymous');
  PermisionsAsString:= CFG.ReadString(aUserName, ctPermisions,  DefaultPermisions);

  Result         := RandomPassword<>FPassword;
End; {-- TUserElement.Load ----------------------------------------------------}

procedure TUserElement.Save(CFG: TCFGStore);
begin
  CFG.DeleteGroup(FUserName);
  CFG.WriteString(FUserName, ctPassword, FPassword);
  CFG.WriteString(FUserName, ctHomeDir, FHomeDir);
  CFG.WriteString(FUserName, ctPermisions, PermisionsAsString);
end; {-- TUserElement.Save ----------------------------------------------------}

function TUserElement.IsUnderHome(Const FileName:String):Boolean;
begin
  Result := Pos(UpperCase(HomeDir), UpperCase(FileName))=1;
end; {-- TUserElement.IsUnderHome ---------------------------------------------}

function TUserElement.CanWriteTo(Const FileName:String):Boolean;
begin
  Result := upWrite in Permisions;
  if (not (upLeaveHome in Permisions)) and Result then Result := IsUnderHome(FileName);
end; {-- TUserElement.CanWriteTo ----------------------------------------------}

function TUserElement.CanReadFrom(Const FileName:String):Boolean;
begin
  Result := upRead in Permisions;
  if (not (upLeaveHome in Permisions)) and Result then Result := IsUnderHome(FileName);
end; {-- TUserElement.CanReadFrom ---------------------------------------------}

function TUserElement.CanDelete(Const Path:String):Boolean;
begin
  Result := upDelete in Permisions;
  if (not (upLeaveHome in Permisions)) and Result then Result := IsUnderHome(Path);
end; {-- TUserElement.CanDelete -----------------------------------------------}

function TUserElement.CanChangeTo(Const Path:String):Boolean;
begin
  Result := True;
  if not (upLeaveHome in Permisions) then Result := IsUnderHome(Path);
end; {-- TUserElement.CanChangeTo ---------------------------------------------}

procedure TUserElement.WUserName(aUserName: String);
begin
  if FUserName<>aUserName then begin
    if assigned(FOnUserNameChange) then FOnUserNameChange(Self, FUserName, aUserName);
    FUserName := aUserName;
  end;
end; {-- TUserElement.WUserName -----------------------------------------------}

function TUserElement.RPermisionsAsString;
begin
  Result := '';
  if upRead      in FPermisions then Result := Result+'R';
  if upWrite     in FPermisions then Result := Result+'W';
  if upDelete    in FPermisions then Result := Result+'D';
  if upLeaveHome in FPermisions then Result := Result+'L';
end; {-- TUserElement.RPermisionsAsString -------------------------------------}

procedure TUserElement.WPermisionsAsString(aPermisionsString:String);
begin
  FPermisions := [];
  if pos('R', aPermisionsString)>0 then FPermisions := FPermisions + [upRead];
  if pos('W', aPermisionsString)>0 then FPermisions := FPermisions + [upWrite];
  if pos('D', aPermisionsString)>0 then FPermisions := FPermisions + [upDelete];
  if pos('L', aPermisionsString)>0 then FPermisions := FPermisions + [upLeaveHome];
end; {-- TUserElement.WPermisionsAsString -------------------------------------}

{******************************************************************************}
{*                                                                            *}
{* TUserManagement                                                            *}
{*                                                                            *}
{******************************************************************************}
function TUserManagement.RUsers(Index: Integer):TUserElement;
Begin
  Result := nil;
  If Index<Count Then Result := TUserElement(FUsersList.Objects[Index]);
End; {-- TUserManagement.RUsers -----------------------------------------------}

function TUserManagement.RCount:Integer;
begin
  Result := FUsersList.Count;
end; {-- TUserManagement.RCount -----------------------------------------------}

procedure TUserManagement.UserNameChange(Sender: TObject; Const Old, New: String);
Var
  I: Integer;
begin
  I := IndexOf(Old);
  if I<0 then exit;
  FUsersList[I] := New;
end; {-- TUserManagement.UserNameChange ---------------------------------------}

constructor TUserManagement.Create;
Begin
  Inherited Create;

  FUsersList := TStringList.Create;
End; {-- TUserManagement.Create -----------------------------------------------}

destructor TUserManagement.Destroy;
Var
  I: Integer;
Begin
  if Assigned(FUsersList) then begin
    For I:=0 To Count-1 Do Self[I].Free;
    FUsersList.Free;
    FUsersList := nil;
  end;

  Inherited Destroy;
End; {-- TUserManagement.Destroy ----------------------------------------------}

procedure TUserManagement.Load(CFG: TCFGStore);
Var
  I: Integer;
  UE: TUserElement;
Begin
  { Read whole section of allowed users in to string list, later we can simply
    add list of temporary disabled acounts. }
  CFG.ReadGroup(ctAllowedUsers, FUsersList);
  For I:=0 To Count-1 Do Begin
    UE:=TUserElement.Create;
    UE.Load(CFG, FUsersList[I]);
    UE.OnUserNameChange:=UserNameChange;
    FUsersList.Objects[I]:=UE;
  End;
End; {-- TUserManagement.Load -------------------------------------------------}

procedure TUserManagement.Save(CFG: TCFGStore);
Var
  I: Integer;
begin
  CFG.DeleteGroup(ctAllowedUsers);
  For I:=0 To Count-1 Do begin
    CFG.WriteString(ctAllowedUsers, Format(ctListUserName, [I]), Self[I].UserName);
    Self[I].Save(CFG);
  end;  
end; {-- TUserManagement.Save -------------------------------------------------}

function TUserManagement.AddUser(aUser: TUserElement):Integer;
Begin
  Result:=-1; // user exist
  If IndexOf(aUser.UserName)<0 Then begin
    Result := FUsersList.AddObject(aUser.UserName, aUser);
    aUser.OnUserNameChange := UserNameChange;
  end;
End; {-- TUserManagement.AddUser ----------------------------------------------}

function TUserManagement.RemoveUser(Const aUserName: String):TUserElement;
Var
  I: Integer;
Begin
  Result := nil;
  I := IndexOf(aUserName);
  If I>=0 then begin
    Result := TUserElement(FUsersList.Objects[I]);
    FUsersList.Delete(I);
  end;
End; {-- TUserManagement.RemoveUser -------------------------------------------}

function TUserManagement.IndexOf(Const aUserName:String):Integer;
Begin
  Result := FUsersList.IndexOf(aUserName);
End; {-- TUserManagement.FindUser ---------------------------------------------}

function TUserManagement.VerifyUser(Const aUserName, aPassword: String):Boolean;
Var
  I: Integer;
Begin
  Result := False;
  I      := IndexOf(aUserName);
  if I>=0 then Result := Self[I].Password=aPassword;
End;

function TUserManagement.GetUserByName(Const aUserName: String): TUserElement;
var
  I : Integer;
begin
  Result := nil;
  I := IndexOf(aUserName);
  if I>=0 then Result := Self[I];
end; {-- TUserManagement.GetUserByName ----------------------------------------}

end.
