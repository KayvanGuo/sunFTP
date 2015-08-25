unit CFGStore;

interface
Uses
  INIFiles, Classes;
  
Type
  TCFGStore = class(TObject)
    public
      procedure DeleteGroup(Const GroupName:String); virtual; abstract;
      procedure ReadGroup(Const GroupName: String; Strings: TStrings); virtual; abstract;
      function ReadInteger(Const GroupName, ItemName: String; Default:Integer):Integer; virtual; abstract;
      function ReadString(Const GroupName, ItemName: String; Default:String):String; virtual; abstract;
      function ReadBoolean(Const GroupName, ItemName: String; Default:Boolean):Boolean; virtual; abstract;
      procedure WriteInteger(Const GroupName, ItemName: String; Value:Integer); virtual; abstract;
      procedure WriteString(Const GroupName, ItemName: String; Value:String); virtual; abstract;
      procedure WriteBoolean(Const GroupName, ItemName: String; Value:Boolean); virtual; abstract;
  End; {-- TCFGStore ----------------------------------------------------------}

  TCFGStoreINI = class(TCFGStore)
    private
      FFileName : String;
      FINI      : TINIFile;
    public
      constructor Create(aFileName:String);
      destructor Destroy; override;
      procedure DeleteGroup(Const GroupName:String); override;
      procedure ReadGroup(Const GroupName: String; Strings: TStrings); override;
      function ReadInteger(Const GroupName, ItemName: String; Default:Integer):Integer; override;
      function ReadString(Const GroupName, ItemName: String; Default:String):String; override;
      function ReadBoolean(Const GroupName, ItemName: String; Default:Boolean):Boolean; override;
      procedure WriteInteger(Const GroupName, ItemName: String; Value:Integer); override;
      procedure WriteString(Const GroupName, ItemName: String; Value:String); override;
      procedure WriteBoolean(Const GroupName, ItemName: String; Value:Boolean); override;
  End; {-- TCFGStoreINI -------------------------------------------------------}

implementation

{******************************************************************************}
{*                                                                            *}
{* TCFGStoreINI                                                               *}
{*                                                                            *}
{******************************************************************************}
constructor TCFGStoreINI.Create(aFileName:String);
Begin
  FFileName := aFileName;
  FINI      := TINIFile.Create(FFileName);
End; {-- TCFGStoreINI.Create --------------------------------------------------}

destructor TCFGStoreINI.Destroy;
Begin
  If Assigned(FINI) Then FINI.Destroy; FINI:=nil;
End; {-- TCFGStoreINI.Destroy -------------------------------------------------}

procedure TCFGStoreINI.DeleteGroup(Const GroupName:String);
Begin
  If Assigned(FINI) Then FINI.EraseSection(GroupName);
End; {-- TCFGStoreINI.DeleteGroup ---------------------------------------------}

procedure TCFGStoreINI.ReadGroup(Const GroupName: String; Strings: TStrings);
Var
  I: Integer;
Begin
  If Assigned(FINI) Then begin
    FINI.ReadSection(GroupName, Strings);
    for I:=0 to Strings.Count-1 do
      Strings[I]:=FINI.ReadString(GroupName, Strings[I], '');
  end;
End; {-- TCFGStoreINI.ReadGroup -----------------------------------------------}

function TCFGStoreINI.ReadInteger(Const GroupName, ItemName: String; Default:Integer):Integer;
Begin
  If Assigned(FINI) Then Result:=FINI.ReadInteger(GroupName, ItemName, Default)
  Else Result:=Default;
End; {-- TCFGStoreINI.ReadInteger ---------------------------------------------}

function TCFGStoreINI.ReadString(Const GroupName, ItemName: String; Default:String):String;
Begin
  If Assigned(FINI) Then Result:=FINI.ReadString(GroupName, ItemName, Default)
  Else Result:=Default;
End; {-- TCFGStoreINI.ReadString ----------------------------------------------}

function TCFGStoreINI.ReadBoolean(Const GroupName, ItemName: String; Default:Boolean):Boolean;
Begin
  If Assigned(FINI) Then Result:=FINI.ReadBool(GroupName, ItemName, Default)
  Else Result:=Default;
End; {-- TCFGStoreINI.ReadBoolean ---------------------------------------------}

procedure TCFGStoreINI.WriteInteger(Const GroupName, ItemName: String; Value:Integer);
Begin
  If Assigned(FINI) Then FINI.WriteInteger(GroupName, ItemName, Value);
End; {-- TCFGStoreINI.WriteInteger --------------------------------------------}

procedure TCFGStoreINI.WriteString(Const GroupName, ItemName: String; Value:String);
Begin
  If Assigned(FINI) Then FINI.WriteString(GroupName, ItemName, Value);
End; {-- TCFGStoreINI.WriteString ---------------------------------------------}

procedure TCFGStoreINI.WriteBoolean(Const GroupName, ItemName: String; Value:Boolean);
Begin
  If Assigned(FINI) Then FINI.WriteBool(GroupName, ItemName, Value);
End; {-- TCFGStoreINI.WriteBoolean --------------------------------------------}

end.
