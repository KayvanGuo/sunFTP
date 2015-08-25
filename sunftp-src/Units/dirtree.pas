
{TDirTree Component for Delphi 2/3  written by Markus Stephany
                                             MirBir.St@T-Online.de
                                             http://home.t-online.de/home/mirbir.st/

 V 1.22    july 05, 1998


credits to all the people who reported bugs and suggestions to me,
especially to Feng Ting, Davendra Patel, Yuval Perlov, Doug Hay, botevi@bu.omega.bg, Sebastian Hildebrandt, Heiko Webers,
Keith Speers, Ashley Bass, Jean Louis LeClef, Demian Lessa, Herbert Sauro, Adam Roslon, Jason Baldwin,
Eric and Pat Leidlmair, Gerd Volk
and all the others i forgot now...



 // a treeview that shows the system's drives and folders (or a part of them ,s.b.)
 // displays explorer-like icons and filenames

 this is free for freeware, public domain, shareware and also for commercial applications.

 if something is going wrong (or even not), contact me (see above), but do not make
 me responsable for anything !!

 added properties :
 Directory      read/write    gets/sets the DirTree's directory
 Drive          read/write    gets/sets the drive (restoring the previously used
                                                   directory for that drive)

 added functions :
 Reload                       reads the items again and tries to set the old dir.
                              (use it e.g. with a shell-notification)

 added event :
 OnAddDir (Filename : string ; var DoAdd : boolean)
                              You can use this event to decide whether to add
                              a drive/path or not (see the sample for more info)

 ********** revision 1.02:
 now it runs a bit faster at startup.
 added property :
 ReadOnStart :                Now You can decide whether the control should read
                              the directories on creation or explicit by calling
                              Reload

 ********** revision 1.1:
 now it should run under NT without getting asked to insert a floppy disk or cd-rom
 added properties:

 DirTypes :                    You can set the file-attributes to decide which directories
                              to show (this works not for the drive-items (cause of NT))

 ShellIcons (readonly) :      an imagelist where you can read the shell's small-icons
                              (maybe for a listview for files, you have not to create
                              another imagelist for small icons)

(* AllowNetwork  :              enables/disables displaying of network-drives ***removed *)

 ********** revision 1.11:
 uses ...forms... was missed by some people (and i can understand them)
 i hope that there are not longer problems under delphi3 and delphi 2.00 and windows nt,
 oh, i hope it so !

 ********** revision 1.12:
 a bug is fixed when using a "real" network-drive ('\\blabla...')
 added property:

 DropDirectory :              is something is dropped to TDirTree, this property
                              gives you the directory of the droptarget-node
 GoBelowRecycleBin :          if set to false, don't show subdirectories of the
                              recycle bin-folders (and recycler under nt )

 ********** revision 1.13:
 added function:

 GetNodefromPath(dir:string):ttreenode : returns the node which belongs to the
                                         specified path (if existing in the items);

 ********** revision 1.14:
 property-name items changed to Items (because of the case sensitivity of bcb)
 thanks to keith speers kspeers@ms5.hinet.net for this bug-report

 added procedure: (thanks to ashley bass abass@iname.com for his suggestions)

 RenamePart(oldpath,newname:string); rename the node belonging to the give path and correct the children
 DeletePart(dpath:string); deletes the node belonging to the path and all its kids;
 AddPath(expath,newsub:string); adds a new sub dir to the children of the existing path expath

 ********** revision 1.15:   (feb 27, 1998)
 added property :
 FastLoad : boolean ; if set to true (default), DirTree will not search for all subdirectories, it will
            just show a + button in front of each root-node (much faster startup than set to false)
            credits to jean louis leclef OrionTech@euronet.be

 added procedure :
 ClearNode(node:ttreenode); deletes all kids of the given node and checks whether there are subs or not
                             (this may be useful for adding dynamic reloading of nodes on collapsing
                              a node, e.g. if this is called in oncollapsed-event, the node will reread
                              its subdirectories when it gets expanded again)

 made a change in getsubkids for speeding up reading of "child-owning" directories

 ********** revision 1.15a: (mar 08, 1998)
 changed property Readonly to property ReadOnly (because of compiler errors in bcb)

 ********** revision 1.16 (mar 13,1998)
 changed some internal stuff, rewritten with case-sensitivity, added some documentation,
 changed TDirName-Objects to TDirEntry-record pointers, fixed some bugs if we are in the delphi-ide
 property shellicons is no longer published, now it is public.
 most of the stuff above comes from demian lessa, know-how@svn.com.br, thanx a lot

 changed event handler OnAddDir (Filename : string ; var DoAdd : boolean) to
 OnAddDir (Sender : TObject ; Filename : string ; var DoAdd : boolean)

 error-management under nt added, regards to sebastian hildebrandt, hildebrandt@t0.or.at

 i do not longer support c++builder, if someone wants to use tdirtree in bcb, he is invited to do so,
 but this unit is written and supported "Only for Delphi 3.x" (maybe for d2.x too)

 added functions :  thanx for the suggestion to Herbert Sauro, Herbert.Sauro@ft.com
 GetSysPathName(Path:string):string; returns the real name of the given path (as it is written to the disk), e.g.
                                     ...('C:\WINDOWS\SYSTEM\') might return 'C:\Windows\System', this is not a
                                     procedure of object, (do not use DirTree1.GetSysPathName...,
                                     just use GetSysPathName...), the trailing backslash will not be returned

 GetShellPathName(Path:string):string; returns the shell parsed name of the given path or file

 added events :
 OnGetIcon(Sender:TObject ; Node:TTreeNode) ; here you can give the node a custom imageindex and selectedindex
 OnFindDir (Sender : TObject ; Path : string ; var Rec : TDirRec ; var Result : Integer ; const First : Boolean)
           now you can completely decide by yourself what files to add (e.g. archives)
           you have just to set the faDirectory-Flag in Rec.Attr to add the file to the directory tree
           this is based on an idea of adam roslon, adam@roslon.com, thanx

 added function :
 FileOrDirExists(Path : string) : Boolean; returns true if the file or directory called path is present on the system

 ********** revision 1.16a (mar 15,1998)

 added tag-fields to the tdirrec and tdirentry-structures

 ********** revision 1.17 (jun 08,1998)

 fixed problem with removable drives, cd-roms will automatically be updated, floppies will be updated by clicking
 a floppy's node (or one of its subfolders)

 added procedure :

 procedure ForcePath ( Path : string );  // to force adding a complete path to the tree, credits to ashley bass

 ********** revision 1.18 (jun 13,1998)

 added procedure GoUp ( CollapseCurrent : Boolean ) to change to the Parent Directory, thanx to gerd volk gvolk@metronet.de for this suggestion
 added property InitialDirectory : TFileName to set an initial directory
       +++property Directory isn't published anymore. in delphi, you now can use this new property instead
       to select a directory on startup


 ********** revision 1.19 (jun 15,1998)

 fixed problem that tdirtree doesn't show anything in the ide

 added function CheckDrives :Boolean : checks if drives have been removed and/or added to the system, if so the return true

 added procedures BeginUpdate / EndUpdate to avoid too much change events getting fired



 ********** revision 1.20 (jun 20,1998)

 removed AllowNetWork property, instead added property :

 DriveTypes : [drtUnknown , drtRemovable , drtFixed , drtRemote , drtCDRom , drtRamDisk]
              what drivetypes to show ?

 ********** revision 1.21 (jul 04,1998)

 added property ShowShareOverlay : Boolean (default : False )
       if this is set to true, all paths that are shared will get a "hand" overlay icon
       (thanx for the idea to ashley bass )

 some code rewritten to be compatible with delphi 2, thanx to ash

 ********** revision 1.22 (jul 05,1998)

 added compiler switch MPDTSUBCLASS, if this condition isn't defined, no subclassing will be generated and no
 wm_devicechange message will be captured ( there was an error reported by harrie rooymans harrie.rooymans@tip.nl
 with the raize splitter component, i hope subclassing is the problem, but i cannot check this )

 added property AcceptDropFiles : Boolean ( default : False )
       if this is enabled, cursor will change if files are dragged from explorer to the dirtree
       and an event (s.b.) will get fired on dropping these files to dirtree

 added event OnDropFiles ( Sender : TObject ; x , y : Integer ; aDropDir : strings ; aDropFiles : TStrings ; Shift : TShiftState);
       this is fired when acceptdropfiles is true and some files from explorer are dropped to tdirtree

 a bug with recreating the handle / the owner's handle fixed ( thanx to marcus luk marcusl@globalpac.com for reporting)

}


{$Define MPDTSUBCLASS} // set a '.' before the '$' to avoid compiling subclassing of the owner's window proc

unit DirTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,
  ComCtrls,ShellApi,FileCtrl,Forms{$IFDEF Ver100},ShlObj,ComObj,ActiveX{$ELSE},ShlObj,OLE2{$ENDIF};

{declaration of the drive types}
type

TDriveType = (drtUnknown , drtRemovable , drtFixed , drtRemote , drtCDRom , drtRamDisk);
TDriveTypes = set of TDriveType;

{these are all supported file-attributes}
TDirType = (dtReadOnly, dtHidden, dtSystem, dtArchive, dtNormal, dtAll);
TDirTypes = set of TDirType;

{this is an internally used directory-descriptor}
TDirRec = packed record
        Attr         : Integer;
        Name         : string;
        Handle       : Integer;
        Data         : TWin32FindData;
        Tag          : Integer;
end;

TDriveBits = set of 0..25;

{this is an event-descriptor for the OnAddDir-event}
TAddFileEvent = procedure (Sender : TObject ; AFileName : string ; var DoAdd : Boolean) of object;
{this is an event-descriptor for the OnDropFiles-event}
TDropFilesEvent = procedure ( Sender : TObject ; X , Y : Integer ; aDropDir : string ;
                              aDropFiles : TStrings ; Shift : TShiftState) of object;
{this is an event-descriptor for the OnFindDir-event}
TFindDirEvent = procedure ( Sender : TObject ; APath : string ; var ARec : TDirRec ;
                            var AResult : Integer ; AFirst : Boolean) of Object;

{this is the data-property of each node}
PDirEntry = ^TDirEntry;
TDirEntry = packed record
          Name         : string;
          IsExp        : Boolean;
          Tag          : Integer;
          ShellFolder  : IShellFolder;
          RelativePIDL : PItemIDList;
end;


  TDirTree = class(TcustomTreeView)
  private
    { Private-Deklarationen }
    {$IFDEF MPDTSUBCLASS}
    fOWnd : HWND;                                // handle of owner form for hooking ( getting WM_DEVICECHANGE messages)
    fWndProcInst,fODefProc : Pointer;            // owner's new and old window proc
    {$EndIf}
    fFastLoad : Boolean;                         // to start without getting the button-state of all available drives
    fIList : TImageList;                         // the placeholder for the shell's small image-list
    fActDirs : array['A'..'Z'] of string;        // remember the last used directories on the given drives
    fSerNRs  : array['A'..'Z'] of DWORD ;        // the serial numbers of all drives
    fOnAdd : TAddFileEvent;                      // will be fired before adding an directory to the list
    fOnDeletion : TTVExpandedEvent;              // to delete the direntry record if a node is to be deleted
    fOnGetIcon  : TTVExpandedEvent;              // this can be fired to store a different image index
    fOnFindDir  : TFindDirEvent ;                // this can be assigned to read custom dirs and other files to the tree
    fIFolS : Integer ;                           // shell's icon-index for "normal" folders, selected state (opened)
    fIFolN : Integer ;                           // the same for non-selected "normal" folders
    fReadOnStart : Boolean;                      // shall we read the tree automatically at startup ?
    fAllowChange : Integer;                      // if false, don't fire the onchange-event
    fDirType : TDirTypes;                         // which folders to read
//    fNetAll  : Boolean;                          // shared drives allowed ?
    fBelBin  : Boolean;                          // allowed to go to subdirs of "recycled" (for norton's protection) )
    fWinDir  : string;                           // holder for windows' directory
    fInitialDirectory : TFileName;               // the initial directory variable
    fCurrentDriveBits : TDriveBits;              // current displayed drivetypes and inserted removable drives
    fDriveTypes       : TDriveTypes;             // allowed drive types
    fDriveFolder      : IShellFolder;            // ishellfolder interface to each drive's node
    fShowShareOverlay : Boolean;                 // if true, then show "hand" overlay for shared folders

    fAcceptDropFiles  : Boolean;                 // if true, we can drop files from explorer to the dirtree
    fDropList         : TStrings;                // dropped files' list
    fOnDropFiles      : TDropFilesEvent;

    fRecreateWnd      : Boolean ;                // to reset the stored directory property
    fRecreateDir      : string ;                 // ''

    procedure MakeTDirEntry(const a:TTreeNode ; const b : string ; const c : Boolean ; const Tag : Integer);
    procedure DelItem (Sender: TObject; Node: TTreeNode);
                                                 // overwritten event-handler to delete items
  protected
    { Protected-Deklarationen }
    destructor Destroy; override;

    procedure CreateWnd ; override; // to implement readonstart  and subclassing owner's window proc
    procedure DestroyWnd; override; // to end subclassing
    procedure ReadNew;  // refreshs the tree
    procedure AddNode (var Item : TTreeNode; A : string ; fTag : Integer); //adds a (root-) node to the tree (for drives) (?)
    procedure GetSubKids (Par : TTreeNode); //get the button-states of the item's kids
    procedure SetDrive (Val : Char); // change to the given drive
    procedure SetDirectory (Val : string); // change to the given directory ( for writing of directory )
    procedure SetDirType (Val : TDirTypes); // what directories to display (attributes)
    procedure Change(Node: TTreeNode); override;  // overwritten event handler to detect directories that doesn't exist anymore
//    procedure SetNetAllow (Val : Boolean); // allow shared drives
    procedure SetBelBin(Val:Boolean); // allow displaying subs of RECYCLED folders
    procedure ClearList; // clears the list and frees the pdirentry-records
    procedure Loaded; override; // set the directory
    procedure GetImageIndex(Node:TTreeNode; NormalIcon:Integer); // can fire an event handler to get a different icon

    function CanExpand(Node: TTreeNode): Boolean ; override; // detect if we have sub directories
    function GetDirectory : string; // read directory
    procedure SetInitialDirectory ( Value : TFileName ); // changes the initial directory
    function GetDrive : Char; // get current drive
    function AddKid (Par:TTreeNode; A : string ; fTag : Integer):TTreeNode; // adds an item and returns this one
    function GetDropDir:string; // get the directory belonging to the drop-target item
    function AskAdd (FNam : string):Boolean; // can we add the elemnt to the tree (calls onadddir-event)
    function Okay (Attr:Integer):Boolean; // are the dir's attributes in the current mask ?
    function IsExpanded(Item : TTreeNode):Boolean; // credits to demian lessa,know-how@svn.com.br

    property Items stored False;
    {$IFDEF MPDTSUBCLASS}
    procedure OWndProc(var Message: TMessage); // new hook window proc
    {$ENDIF}
    procedure Click ; override; // overwrite click to detect changes in directory tree
    procedure SetDriveTypes ( Value : TDriveTypes );
    function GetDrives : TDriveBits;
    procedure SetShowShareOverlay ( Value : Boolean );
    function GetShareOverlay ( node : TTreeNode ) : Integer;
    procedure SetAcceptDropFiles ( Value : Boolean );
    procedure WMDropFiles ( var message : TWMDropFiles ) ; message WM_DROPFILES;

  public
    { Public-Deklarationen }
    constructor Create (AOwner: TComponent);override;

    procedure GetBtn (var Item : TTreeNode);                // get the first kid of the item's path
    procedure ReLoad ;                                      // Reload the tree
    procedure FullExpand;                                   // expands all nodes
    procedure GetKids (var Item : TTreeNode);               // get all child node's for the item-node
    procedure RenamePart (OldPath , NewName : string );          // eg ..('c:\windows\system','sys32') renames 'c:\windows\system' to 'c:\windows\sys32' (only in the tree, not on the drive)
    procedure DeletePart (DPath : string );                    // eg ..('c:\windows') deletes the node belonging to 'c:\windows' an all its child nodes ('')
    procedure AddPath (ExPath , NewSub : string; fTag : Integer); // adds a child node newsub to the existing node expath
    procedure ForcePath ( fPath : string );                 // to force adding a complete path to the tree
    procedure ClearNode ( Node:TTreeNode);                   // deletes the subnodes of the given node
    function GetNodeFromPath ( Path : string ):TTreeNode;       // returns the node belonging to a special directory, if existant

    procedure GoUp ( const Collapse : Boolean );            // Changes to the parent Directory and can also collapse the node
    function CheckDrives : Boolean ;                                 // are there drives removed/added
    procedure BeginUpdate;
    procedure EndUpdate;

    property Drive : Char read GetDrive write SetDrive;     // get/set current drive
    property DropDirectory : string read GetDropDir;        // if something is dropped to tdirtree, this gives the related directory
    property ShellIcons : TImageList read fIList;           // the shell's small image list (to associate with other components !!!!just read it!!!
    property ClosedFolderIcon : Integer read fIFolN;        // the normal icon for a folder
    property OpenFolderIcon : Integer read fIFolS;          // the open icon for a folder
    property Directory : string read GetDirectory write SetDirectory;  // sets/reads the selected node/path
  published
    { Published-Deklarationen }
    property OnAddDir : TAddFileEvent read fOnAdd write fOnAdd;                      // event handler get fired on adding a node to the tree
    property OnDeleteItem : TTVExpandedEvent read fOnDeletion write fOnDeletion;     // overwritten ondeletion event
    property OnGetIcon : TTVExpandedEvent read fOnGetIcon write fOnGetIcon;          // to set custom images for a node
    property OnFindDir : TFindDirEvent read fOnFindDir write fOnFindDir;             // read also files into the tree;
    property BorderStyle;
    property ReadOnStart : Boolean read fReadOnStart write fReadOnStart;             // read the tree automaticaaly on startup ?
    property DragCursor;
    property DirTypes   : TDirTypes read fDirType write SetDirType;                    // described above
//    property AllowNetwork : Boolean read fNetAll write SetNetAllow;                  // ''
    property GoBelowRecycleBin : Boolean read fBelBin write SetBelBin;               // ''
    property FastLoad : Boolean read fFastLoad write fFastLoad;                      // ''
    property InitialDirectory : TFileName read fInitialDirectory write SetInitialDirectory;
    property DriveTypes : TDriveTypes read fDriveTypes write SetDriveTypes;
    property ShowShareOverlay : Boolean read fShowShareOverlay write SetShowShareOverlay ;
    property AcceptDropFiles  : Boolean read fAcceptDropFiles write SetAcceptDropFiles;
    property OnDropFiles      : TDropFilesEvent read fOnDropFiles write fOnDropFiles;
    property ReadOnly;
    property DragMode;
    property HideSelection;
    property OnEditing;
    property OnEdited;
    property OnExpanding;
    property OnExpanded;
    property OnCollapsing;
    property OnCollapsed;
    property OnChanging;
    property OnChange;
    property Align;
    property Enabled;
    property Font;
    property Color;
    property ParentColor;
    property ParentCtl3D;
    property Ctl3D;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property PopupMenu;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
  end;

procedure Register;

function GetSysPathName (const Path : string ):string; // returns the name of the given path as it is written to the disk (upper, lowercase and so on)
function GetShellPathName (const Path : string ):string; // returns the name of the given path as it is displayed by the shell
function FileOrDirExists (const Path : string ):Boolean; // checks whether the specified file exists on the drive (can also be a directory)
function GetDriveTitle (const Drive : Char ) : string; // get the drive's label and char
function GetDriveSerial (const Drive : Char ) : DWORD; // get the drive's label and char
implementation

procedure Register;
begin
  RegisterComponents('SunFTP'' Pages', [TDirTree]);
end;

// our special version of findfirst, forward cause of usage in getsysfilename
function FindFirstDir ( const Path : string ; var Rec : TDirRec ) : Integer ; forward;

(* string manipulation *)

// calculates the count of "\" in the given string
function AzPos ( a: string ) : Integer;
var ct: Integer;
begin
     Result := 0;
     repeat
           ct := Pos ('\',a);
           if ct = 0
	   then
		Break;

           Inc (Result,1);
           a:=Copy(a,ct+1,MaxInt);

     until False;
end;

// get the b'st "\" delimited part of a
function GetPart ( const a : string ; const b : Integer ) : string;
var ct , ix : Integer;
begin
     Result := a;
     ix := 0;
     for ct := 1 to Length(a) 
     do begin
         if a[ct] = '\' 
         then 
             Inc (ix,1);

         if ix = b 
	 then begin
              Result := Copy(a,1,ct);
              Break;
         end;  

     end;
end;

// add a trailing backslash to val if there is none
procedure AddBSlash ( var Val : string );
begin
     if Val <> ''
     then
        if Val[Length(Val)] <> '\'
        then
           Val := Val+'\';
end;

// remove a trailing backslash from val if there is one
function DelBSlash ( const Val : string ) : string;
begin
     Result := Val ;
     if Val <> '' 
     then
         if Val[Length(Val)] = '\' 
         then
             Delete ( Result , Length ( Val ) , 1 );
end;

(*drive and folder functions *)

// returns the filename as read from the drive
function GetSysFileName ( const Name : string):string;
var rec : TDirRec;
    E   : Integer;
begin
     E := SetErrorMode(SEM_FAILCRITICALERRORS);
     try
        Result := ExtractFileName ( DelBSlash ( Name ));
        if FindFirstDir ( DelBSlash ( Name ),rec) = 0
        then begin
             Result := rec.Name;
             Windows.FindClose(rec.Handle);
        end;
        AddBSlash(Result);
     finally
            SetErrorMode(E);
     end;
end;

// returns the filename as displayed by the shell
function GetShellFileName ( const Name : string ):string;
var sfi : TSHFileInfo;
    E   : Integer;
begin
     E := SetErrorMode(SEM_FAILCRITICALERRORS);
     try
       Result := ExtractFileName ( DelBSlash ( Name ));
       if SHGetFileInfo(PChar(DelBSlash ( Name )),0,sfi,SizeOf(TSHFileInfo),SHGFI_DISPLAYNAME) <> 0
       then
           Result := sfi.szDisplayName;
       AddBSlash(Result);
     finally
            SetErrorMode(E);
     end;
end;

// returns the name of the given path as it is written to the disk or as displayed by the shell
function GetSysShellName (Path : string ; const Shell : Boolean ):string;
var az,afg : Integer;
    part   : string;
begin
     Path := DelBSlash(Path);
     Result := Path;
     az := AzPos(Path)+1;
     if az < 2
     then begin
          if Path <> ''
          then
              Path[1] := UpCase(Path[1]);
          Exit;
     end;
     Result := UpCase(Path[1])+':\';
     AddBSlash(Path);
     for afg := 2 to az
     do begin
        part := GetPart(Path,afg);
        if Shell
        then
            Result := Result+GetShellFileName(part)
         else
            Result := Result+GetSysFileName(part);
     end;
     Result := DelBSlash(Result);
end;

// returns the drive's title and serial number
function GetDriveDesc ( const Drive : Char ; var ser : DWORD ) : string;
var rootpathname : string;
    namebuffer : string;
    serialnumber : dword;
    maximumcomponentlength : dword;
    filesystemflags : dword;
    filesystemnamebuffer : string;
begin

   rootpathname := drive+':\'; // build the rootpath for our api

   // predefine buffers
   setlength(namebuffer,25) ;
   setlength(filesystemnamebuffer,500) ;

   // call the api
   if getvolumeinformation (           // returns boolean true if succeeded
      pchar(rootpathname),
      pchar(namebuffer),
      24,
      @serialnumber,
      maximumcomponentlength,
      filesystemflags,
      pchar(filesystemnamebuffer),
      499)

   // build the resulting dword
   then begin
       Result := StrPas ( PChar (NameBuffer) )+' ('+UpCase(Drive)+':)';
       ser := SerialNumber;
   end
   else begin
       Result := '('+UpCase(Drive)+':)';
       ser := -1;
   end;
   case  GetDriveType ( PChar ( Drive+':\' ) )
         of  DRIVE_REMOVABLE , DRIVE_REMOTE :
         begin
              Result := GetShellFileName ( Drive+':\\');
              Delete ( Result , Length ( Result ) ,1 );
         end;
   end;
end;

// get the drive's label
function GetDriveTitle (const Drive : Char ) : string;
var
   ser : DWORD;
begin
     Result := GetDriveDesc ( Drive , ser );
end;

// get the drive's serial
function GetDriveSerial (const Drive : Char ) : DWORD;
var ser : DWORD;
begin
     GetDriveDesc ( Drive , ser );
     Result := ser;
end;

(*helper routines*)


// our special version of findfirst
function FindFirstDir (const Path : string ; var Rec : TDirRec ) : Integer;
begin
     FillChar ( Rec , SizeOf( TDirRec ) , 0);
     with Rec
     do begin
        Handle := FindFirstFile ( PChar ( Path ) , Data );
        if Handle <> INVALID_HANDLE_VALUE
        then begin
             Result := 0; // we have found the directory (or file)
             Attr := Data.dwFileAttributes;
             Name := Data.cFileName;
             Tag  := 0;
        end
        else
            Result := GetLastError; // we got no valid handle for the searched directory
     end;
end;
// our version of findnext (a bit faster than borland's cause we do not convert all items of the win32finddata)
function FindNextDir(var Rec:TDirRec):Integer;
begin
     with Rec
     do begin
        if FindNextFile(Handle,Data)
        then begin
             Result := 0;
             Attr := Data.dwFileAttributes;
             Name := Data.cFileName;
             Tag  := 0;
        end
        else
            Result := GetLastError;
     end;
end;

// is node and data <> nil ?
function DataAssigned ( Node : TTreeNode ) : Boolean;
begin
     Result := ( Node <> nil ) and ( Node.Data <> nil );
end;

// get the current shift state (ctrl, shift, alt...)
function GetShiftState : TShiftState;
begin
     Result := [];
     if ( GetKeyState ( VK_SHIFT ) and 254 ) <> 0 then Include ( Result , ssShift );
     if ( GetKeyState ( VK_CONTROL ) and 254 ) <> 0 then Include ( Result , ssCtrl );
     if ( GetKeyState ( VK_MENU ) and 254 ) <> 0 then Include ( Result , ssAlt );

end;

(**)

function TDirTree.GetShareOverlay ( node : TTreeNode ) : Integer;
var
   fFolder : IShellFolder;
   eaten : DWORD;
   eaten1 : LongInt;
   OLEStr: array[0..MAX_PATH] of TOLEChar;
   sr : string;
   d : PDirEntry;
begin
   Result := -1;
   try

     d := PDirEntry ( node.Data );
     sr := d^.Name;

     fFolder := fDriveFolder;

     if DataAssigned (node.Parent)
     then begin
         fFolder := PDirEntry ( node.Parent.Data )^.ShellFolder;
         sr := ExtractFileName ( DelBSlash(sr ));
     end;


     if SUCCEEDED ( fFolder.ParseDisplayName ( Handle , nil , StringToWideChar ( sr , OLEStr , MAX_PATH) , eaten1 , d^.RelativePidl , eaten1 ))
     then
         if SUCCEEDED ( fFolder.BindToObject ( d^.RelativePidl , nil , IID_ISHELLFOLDER , Pointer ( d^.ShellFolder )) )
         then begin

              eaten := SFGAO_SHARE;

              if SUCCEEDED (fFolder.GetAttributesOf(1, d^.relativepidl, eaten))
              then

                  if ( eaten and SFGAO_SHARE ) <> 0
                  then
                      Result := 0

         end;

   finally
   end;
end;

// creates the directory-data for the node a, path=b, expanded=c
procedure TDirTree.MakeTDirEntry(const a:TTreeNode ; const b : string ; const c : Boolean ; const Tag : Integer);
var
   d : PDirEntry;
begin
     if not Assigned ( a )
     then
         Exit;

     d := New(PDirEntry);
     //FillChar ( d , SizeOf ( PDirEntry ) , 0);

     d^.IsExp := c;
     d^.Name  := AnsiUpperCase(b);
     d^.Tag   := Tag;
     a.Data   := d;
     d^.ShellFolder := nil;

     if fShowShareOverlay
     then
         a.OverlayIndex := GetShareOverlay ( a );
end;


// get the tdirentry-name (the real path) for the specified node;
function EntryName(Node:TTreeNode):string;
begin
     Result := '';
     if Assigned (Node ) and Assigned(Node.Data)
     then
         Result := PDirEntry( Node.Data )^.Name;
end;

(**)

// returns the name of the given path as it is written to the disk (upper, lowercase and so on)
function GetSysPathName (const Path:string):string;
begin
     Result := GetSysShellName(Path,False);
end;


// returns the name of the given path as it is displayed by the shell
function GetShellPathName (const Path:string):string;
begin
     Result := GetSysShellName(Path,True);
end;

// checks whether the specified file exists on the drive (can also be a directory)
function FileOrDirExists (const Path:string):Boolean;
var
   E : Integer;
begin
     E := SetErrorMode(SEM_FAILCRITICALERRORS);
     try
        Result := GetFileAttributes(PChar(Path)) <> -1;
     finally
            SetErrorMode(E);
     end;
end;

(* TDirTree implementation *)


constructor TDirTree.Create;
var
   sfi : TSHFileInfo;
   n   : Char;  // drive-holder
   fPIDL : PITEMIDLIST;
   fPar : IShellFolder;
begin
     inherited Create(AOwner);
    {$IFDEF MPDTSUBCLASS}
     fOWnd := 0;
     fODefProc := nil;
     {$ENDIF}
     fIList := TImageList.Create(Self); // create the shell's image list (or better, a copy)

     // now get the closed and open icon for normal folders (i hope the windir is a normal folder)
     SetLength ( fWinDir , MAX_PATH );
     SetLength ( fWinDir , GetWindowsDirectory(PChar ( fWinDir ),MAX_PATH));
     AddBSlash(fWinDir);

     fIList.Handle :=
       SHGetFileInfo(PChar ( fWinDir ),0,sfi,SizeOf(TSHFileInfo),
       SHGFI_SYSICONINDEX or SHGFI_SMALLICON); // get the shell's image list's handle
     fIList.ShareImages := True; // don't free the shell's image list on destroying our copy !
     Images := fIList; // set the dirtree's images to this copy of the shell's il
     fIFolN := sfi.iIcon;
     SHGetFileInfo(PChar ( fWinDir ),0,sfi,SizeOf(TSHFileInfo), SHGFI_OPENICON or
       SHGFI_SYSICONINDEX or SHGFI_SMALLICON); // get the shell's image list's handle
     fIFolS := sfi.iIcon;

     fFastLoad := False; // no fastload for default
     OnDeletion := DelItem; // set our own event-handler for deleting a node (to delete the tdirentry)
     fReadOnStart := True; // default: read automatically at startup
     fBelBin := False; // default: show subdirectories of "recycled" pathes
     fDirType := [dtAll,dtNormal]; // read all types of directories
//     fNetAll := True; // allow network drives
     fDriveTypes := [drtUnknown , drtRemovable , drtFixed , drtRemote , drtCDRom , drtRamDisk];
     fInitialDirectory := GetCurrentDir;

     for n := 'A' to 'Z'
     do
       fActDirs[n]:=AnsiUpperCase(n)+':\'; // read the root of all drives as default dirs for the drives
     try
        fActDirs[UpCase(GetCurrentDir[1])] := AnsiUpperCase(GetCurrentDir); // read the current directory
     except;
     end;
     SortType := stNone; // no sorting (it's slow)
     HideSelection := False;
     fAllowChange := 0; // firing onchange event is not allowed until the first reading has been done
     fOnGetIcon := nil;
     fOnFindDir := nil;
     if SUCCEEDED ( SHGetSpecialFolderLocation ( 0 , CSIDL_DRIVES , fPidl ))
     then
         if SUCCEEDED ( SHGetDesktopFolder ( fPar ) )
         then begin
              fPar.BindToObject ( fPidl , nil , IID_ISHELLFOLDER , Pointer ( fDriveFolder ) );
              {$IFNDEF Ver100}
              fPar.Release;
              {$ENDIF}
         end;
     fShowShareOverlay := False;
     fAcceptDropFiles := False;
     fDropList := TStringList.Create;
     fRecreateWnd := False;
end;


// delete all items and their data-object
procedure TDirTree.ClearList;
var
   ct : Integer;
begin
     BeginUpdate;

     if HandleAllocated
     then
         Items.BeginUpdate;

     if Items.Count > 0
     then
         for ct := 0 to Pred ( Items.Count ) do
            try
               if DataAssigned (Items[ct] )
               then begin
                    PDirEntry(Items[ct].Data)^.Name := '';
                    {$IFNDEF Ver100}
                    if PDirEntry(Items[ct].Data)^.ShellFolder <> nil
                    then
                        PDirEntry(Items[ct].Data)^.ShellFolder.Release;
                    {$ENDIF}
                    Dispose(PDirEntry(Items[ct].Data));
               end;
            finally
                   Items[ct].Data := nil;
            end;
     Items.Clear; // delete all items and their data
     EndUpdate;

     if HandleAllocated
     then
         Items.EndUpdate;
         
end;


destructor TDirTree.Destroy;
begin
     fAllowChange := 0; // don't fire onchange-event
     ClearList; // clear all items
     fIList.Free; // clear the image list
     {$IFNDEF Ver100}
     fDriveFolder.Release;
     {$ENDIF}
     fDropList.Free;
     inherited Destroy;
end;


// go below recycle bin ?
procedure TDirTree.SetBelBin(Val:Boolean);
begin
     if fBelBin <> Val
     then begin
          fBelBin:=Val;
          ReLoad;
     end;
end;


// can fire the event handler to get an icon index
procedure TDirTree.GetImageIndex( Node:TTreeNode ; NormalIcon:Integer);
var
   Info : TSHFileInfo;
begin
     Node.ImageIndex := NormalIcon;
     // now check whether a normal folder icon or not
     if NormalIcon = fIFolN
     then
         Node.SelectedIndex := fIFolS
     else begin
          FillChar(Info,SizeOF(TSHFileInfo),0);
          SHGetFileInfo(PChar(PDirEntry(Node.Data)^.Name),0,Info,SizeOf(TSHFileInfo),SHGFI_SYSICONINDEX or SHGFI_SMALLICON
                        or SHGFI_OPENICON);
          Node.SelectedIndex := Info.iIcon;
     end;
     if Assigned(fOnGetIcon)
     then
         fOnGetIcon(Self,Node); // for setting custom image indices
end;

// get the path belonging to the node where dropped to
function TDirTree.GetDropDir:string;
begin
     Result := '';
     try
        if DataAssigned ( DropTarget )
        then
            Result := EntryName(DropTarget);
     finally
     end;
end;


// reload all items
procedure TDirTree.ReLoad ;
var
   t        : Char;       // drive-holder
   node,nd1 : TTreeNode;  // first node, first child
   tdir     : string;     // holder for path name
begin
     tdir := GetDirectory; // store the current directory
     ReadNew;              // reread the whole tree
     SetDirectory(tdir);   // try to restore the actual path
     if Items.Count = 0 then
        Exit;
     if Selected = nil
        then
            SetDirectory(Copy(tdir,1,3)); // actual directory is no longer existant, set root path
     if Selected = nil
     then begin // didn't work , try to get another drive
          node := Items.GetFirstNode;
          nd1 := Node.GetFirstChild;
          while (nd1 <> nil) and (not IsExpanded(nd1)) and (Node.GetNextSibling <> nil)
          do begin
             node := node.GetNextSibling;
             nd1 := node.GetFirstChild;
          end;
          t := UpCase(EntryName(node)[1]);
          try
             SetDirectory(fActDirs[t]); // try to set this directory
             if GetDirectory <> fActDirs[t]
             then begin
                  node.Selected := True; // no, select this existing node
                  Change(node);
             end;
          except
          end;
     end;
end;


// check if the dir-attributes fit to the mask
function TDirTree.Okay (Attr:Integer):Boolean;
begin
     Result := False;
     if dtAll in fDirType
     then Result := True
          else begin
               if (Attr and faHidden) = faHidden
               then
                   if not (dtHidden in fDirType)
                   then
                       Exit; // is hidden, but not in mask, don't add

               if (Attr and faSysFile) = faSysFile
               then
                   if not (dtSystem in fDirType)
                   then
                       Exit; // '', for system-attribute

               if (Attr and faArchive) = faArchive
               then
                   if not (dtArchive in fDirType)
                   then
                       Exit;

               Result := True; // exclusive mask fits, return true

               if dtNormal in fDirType
               then
                   Exit;

               // check if some attribute(s) must be set ?

               if (Attr and (faHidden or faSysFile or faArchive)) = 0
               then
                   Result := False;
          end;
end;


// check if recycle bin, if not (or allowed ), fire onadd
function TDirTree.AskAdd (FNam : string):Boolean;
var
   c : integer;
begin
     Result := True;
     // is it allowed to go below rycle-bin ?
     if not fBelBin
     then begin
          c:= Pos('\recycled\',AnsiLowerCase(FNam));
          if c = 0
          then
              c:= Pos('\recycler\',AnsiLowerCase(FNam));

          if c > 0
          then
              if c < (Length(FNam) -9)
              then
                  Result:=False; // would be a path under the recycle bin
     end;
     if Result and Assigned (fOnAdd)
     then
         fOnAdd(Self,FNam,Result); // allow custom decision whether to add or not
end;


// set allowed file-attributes
procedure TDirTree.SetDirType (Val :TDirTypes);
begin
     if Val <> fDirType
     then begin
          fDirType := Val;
          ReLoad;
     end;
end;



// set the directory to the desired path , if possible
procedure TDirTree.SetDirectory (Val : string);
var
   az     : Integer;        // count of "\" in the path
   node,nd: TTreeNode;      // temp.
   oldcur : TCursor;        // show busy-corsor
   afg    : Integer;        // current "\..." part index (belongs to az)
   tsr    : string;         // current "\..." part ''


    // get the rootnode ("x:\") for the given path
    function GetRoot(a:string):TTreeNode;
    begin
         Result:=nil;
         nd := Items.GetFirstNode;
         while DataAssigned (nd )
         do begin
            if lstrcmpi(PChar(a),PChar(EntryName(nd))) = 0
            then begin
                 if not IsExpanded(nd)
                 then
                     GetKids(nd); // expand root node

                 Result:=nd;
                 Break;  // found, end
            end;
            nd := nd.GetNextSibling; // not yet found, continue searching
         end;
    end;

    // get the node belonging to the specified path and expand it
    function GetChi ( c : TTreeNode ; a : string ) : TTreeNode;
    begin
         Result:=nil;
         nd := c.GetFirstChild;
         while DataAssigned (nd)
         do begin
            if lstrcmpi(PChar(a),PChar(EntryName(nd))) = 0
            then begin
                 if not IsExpanded(nd)
                 then
                     GetKids(nd);

                 Result:=nd;
                 Break;
            end;
            nd := c.GetNextChild(nd);
         end;
    end;


begin
     if Val = ''
     then
         raise Exception.Create('Invalid Path Name');

     if Val = '?'
     then
         Exit; // what happened here (if no directory can be found)

     AddBSlash(Val); // add a backslash if necessary

     if not FileOrDirExists(DelBSlash(Val))
     then
	 Val := GetCurrentDir[1]+':\'; // if the wanted path isn't present, use the current dir

(*     if (not FNetAll) and (not(csDesigning in ComponentState)) and
        (GetDriveType(PChar(Val[1]+':\')) = Drive_Remote)
     then
         Val := fWinDir;*)

     // get the partial strings

     az := AzPos(Val); // get count of "\"

     if az = 0
     then
         Exit; // seems to be an empty val

     oldcur := Screen.Cursor;
     Screen.Cursor := crHourGlass; // show that we are busy

     try
        Items.BeginUpdate; // don't update the tree until finished
        Val := AnsiUpperCase(Val); // cast up for better comparing (?)
        node := nil;
        for afg := 1 to az
        do begin
            // get the partial string #afg
            tsr := GetPart(Val,afg);

            if afg = 1
            then
                // if the first (root), get the root node
                node := GetRoot(tsr)

            // otherwise get the child node
            else
                node := GetChi(node,tsr);

            if node = nil
            then
                Exit; // if there is no child node, just set the existing part of the path

        end;

        Selected := node; // select the node found
        node.MakeVisible; // scroll into view

     finally
          Items.EndUpdate; // no update the tree on screen
          Screen.Cursor := oldcur; // and restore the previous cursor
     end;
end;


// retrieve the currently selected path
function TDirTree.GetDirectory : string;
begin
     if Selected = nil
     then
         Result := '?'  // no path selected
     else
         try
            Result := EntryName(Selected);
         except
               Result := '?'; // there's something wrong
         end;
end;


// add a child node (a subdir) to the given node/path
function TDirTree.AddKid (Par:TTreeNode; A : string ; fTag : Integer):TTreeNode;
var
    sfi   : TSHFileInfo;
    item  : TTreeNode;
begin
     Result := nil;
     if Par = nil
     then
         Exit; // no parent, no child

     AddBSlash(A); // add a backslash if necessary
     SHGetFileInfo ( PChar(A),0,sfi,SizeOf(TSHFileInfo),SHGFI_SYSICONINDEX or SHGFI_SMALLICON
                     or SHGFI_DISPLAYNAME);  // get the displayname and the normal icon index

     // add this item to the tree with the shell's displayed name+++
     item := Par.Owner.AddChild(Par,ExtractFileName ( GetSysPathName ( a )));

     MakeTDirEntry(item,A,False,fTag); // add an descriptor (node's data-property)

     GetImageIndex(item,sfi.iIcon);

     Result := item;
end;


// adds a root node to the tree (a drive node)
procedure TDirTree.AddNode (var Item : TTreeNode; A:string ; fTag : Integer);
var
   sfi   : TSHFileInfo;
begin
     AddBSlash(A); // add a bsl if needed

     SHGetFileInfo ( PChar(A),0,sfi,SizeOf(TSHFileInfo),SHGFI_SYSICONINDEX
                     or SHGFI_SMALLICON or SHGFI_DISPLAYNAME); // get the normal icon index

     item := Items.Add(nil,'' ); // and add it to the root of the tree

     if GetDriveType(PChar(A[1]+':\')) <> DRIVE_REMOVABLE
     then
         // if a cd rom is ejected, the shell doesn't seem to return an empty displayname (at least under nt4)
         item.Text := GetDriveDesc ( a[1],fSerNRs[UpCase(A[1])])
     else
         item.Text := sfi.szDisplayName; // on floppies, it works

     MakeTDirEntry(item,A,False,fTag); // add an descriptor (node's data-property)

     GetImageIndex(item,sfi.iIcon);
end;


// retrieves info if we should show + buttons or not
procedure TDirTree.GetSubKids (Par:TTreeNode);
var
   node : TTreeNode;
begin
     if csDesigning in ComponentState
     then
         Exit; // no buttons in the delphi ide

     if Par = nil
     then
         Exit;

     node := Par.GetFirstChild;

     while node <> nil
     do begin // walk thru all child nodes
        GetBtn(node);
        node := Par.GetNextChild(node);
     end;
end;


// read all subdirs of the given path
procedure TDirTree.GetKids (var Item:TTreeNode);
var
   sr      : TDirRec;     // our searchrecord
   res,ct  : Integer;     // search result, count of found subdirectories
   pt      : string;      // parent path for search
   fDirs   : TStringList; // container for subdirs
   E       : Integer;     // set error mode (to avoid problems under nt)

begin
     if csDesigning in ComponentState
     then
         Exit;

     if Item = nil
     then
         Exit; // delphi ide, no path : exit

     if IsExpanded(Item)
     then
         Exit; // already has read the subdirs, exit

     fDirs := TStringList.Create;
     try
        FillChar(sr,SizeOf(TDirRec),0);
        pt := EntryName(Item); // get the path for the specified node
        Item.DeleteChildren; // delete all (internal structure) children
        PDirEntry(Item.Data)^.IsExp := True; // after this procedure it is expanded and stores its subdirectories
        FillChar(sr,SizeOf(TDirRec),0);
        sr.Tag := PDirEntry(Item.Data)^.Tag;

        // here comes some error-handling to avoid an ugly error message under nt if the drive is empty
        // credits to sebastian hildebrandt, hildebrandt@t0.or.at

        E := SetErrorMode(SEM_FAILCRITICALERRORS);
        try
           if Assigned(fOnFindDir) then
              fOnFindDir(Self,pt,sr,res,True)

           else
               res := FindFirstDir(pt+'*.*',sr); // search for pathes

           while res = 0
           do begin
              if ((sr.Attr and faDirectory) > 0) and (sr.Name <> '.') and (sr.Name <> '..')
              then
                  if AskAdd(pt+sr.Name+'\')
                  then
                      if Okay(sr.Attr) // if all conditions are okay
                      then
                          fDirs.AddObject(sr.Name,Pointer(sr.Tag));  // add the path to the container

              if Assigned(fOnFindDir)
              then begin
                   sr.Tag := PDirEntry(Item.Data)^.Tag;
                   fOnFindDir(Self,pt,sr,res,False)
              end
              else
                  res := FindNextDir(sr);
           end;

        finally
               SetErrorMode(E);
        end;

        Windows.FindClose(sr.Handle); // nothing (more) found
        fDirs.Sorted := True; // now do an alphabetical sorting

        if fDirs.Count > 0
        then
            for ct := 0 to Pred ( fDirs.Count )
            do
              AddKid(Item,pt+fDirs[ct],Integer(fDirs.Objects[ct]));  // no add all subdirs to the tree

        finally
               FDirs.Free;
        end;
end;


// get the + button state for the spec. node
procedure TDirTree.GetBtn (var Item:TTreeNode);
var
   sr    : TDirRec;
   res   : Integer;
   pt    : string;
   E     : Integer;

    { this is almost the same as above, but here we just search for the first subdirectory, if one found,
      add a dummy child node to display the + button and exit}

begin
     if csDesigning in ComponentState
     then
         Exit;

     if Item = nil
     then
         Exit;

     if IsExpanded(Item)
     then
         Exit;

     pt := EntryName(Item);
     FillChar(sr,SizeOf(TDirRec),0);
     sr.Tag := PDirEntry(Item.Data)^.Tag;

     E := SetErrorMode(SEM_FAILCRITICALERRORS);

     try
        if Assigned(fOnFindDir)
        then
            fOnFindDir(Self,pt,sr,res,True)
        else
            res := FindFirstDir(pt+'*.*',sr);

        while res = 0
        do begin
           if ((sr.Attr and faDirectory) > 0) and (sr.Name <> '.') and (sr.Name <> '..')
           then
               if AskAdd(pt+sr.Name+'\')
               then
                   if Okay(sr.Attr)
                   then begin
                        Items.AddChild(Item,'');
                        Break;
                   end;

           if Assigned(fOnFindDir)
           then begin
                sr.Tag := PDirEntry(Item.Data)^.Tag;
                fOnFindDir(Self,pt,sr,res,False)
           end
           else
               res := FindNextDir(sr);
        end;

     finally
            SetErrorMode(E);
     end;

     Windows.FindClose(sr.Handle);
end;


// reload the tree
procedure TDirTree.ReadNew;
var
   oldcur   : TCursor;       // we want to display that we are busy
   node     : TTreeNode;     // the temp. node
   ct       : Integer;       // to walk thru all drives
   drv      : Char;          // a..z
   bits     : TDriveBits;  // binary array for all drives that do exist


begin
     if HandleAllocated
     then
         if not (csLoading in ComponentState)
         then begin

              Dec ( fAllowChange ); // no changes allowed and no event fired until this will be finished
              oldcur := Screen.Cursor;
              Screen.Cursor := crHourGlass; // show that we are busy
              try
                 Items.BeginUpdate;
                 ClearList;
                 Application.ProcessMessages; // let the task go ahead (a bit)

                 // now let us read the drives

                 bits:=GetDrives;
                 fCurrentDriveBits := Bits;

                 for ct := 0 to 25
                 do
                   if ct in Bits
                   then begin
                     drv := Char (ct+Ord('A')); // casting numbers 0..25 to drives A..Z
                     if AskAdd(drv+':\')
                     then begin // if it is allowed to add this drive
                          AddNode(node,drv+':\',0); // create a new root node in the tree
                          if fFastLoad
                          then // do not search for the existance of sub dirs
                               Items.AddChild(node,'')
                          else
                              case GetDriveType(PChar(drv+':\'))
                              of
                                0,1,DRIVE_REMOVABLE,DRIVE_CDROM :Items.AddChild(node,''); // always guess button state for disks and cdroms

                              else
                                  GetBtn(node); // net, hard : retrieve the real button state (if no fastload)
                              end;
                     end;
                   end;

              finally
                     Inc ( fAllowChange );
                     Items.EndUpdate;
                     if Selected <> nil
                     then
                         Selected.MakeVisible; // make the selected node visible

                     Screen.Cursor := oldcur;
              end;
         end;
end;

// set the hook for WM_DEVICECHANGE messages
procedure TDirTree.CreateWnd ;
begin
     inherited;

    {$IFDEF MPDTSUBCLASS}
     if Owner is TWinControl
     then
         if not ( csDesigning in ComponentState )
         then begin
              { Subclass the owner so this control can capture the WM_DEVICECHANGE message }
              FOWnd := TWinControl( Owner ).Handle;
              FWndProcInst := MakeObjectInstance( OWndProc );
              FODefProc := Pointer( GetWindowLong( FOWnd, GWL_WNDPROC ));
              SetWindowLong( FOWnd, GWL_WNDPROC, Longint( FWndProcInst ));
         end;
     {$ENDIF}

     if fReadOnStart
     then
         ReadNew; // for automatic startup-filling of the tree

     if fRecreateWnd // for setting the last used dire4ctory after recreating the handle
     then begin
          fRecreateWnd := False;
          SetDirectory ( fRecreateDir );
     end;

     SetAcceptDropFiles ( fAcceptDropFiles );
end;

// end subclassing the owner's window procedure
procedure TDirTree.DestroyWnd;
begin
     SetAcceptDropFiles ( False );
     fRecreateWnd := True;
     fRecreateDir := Directory;
     ClearList;

     {$IFDEF MPDTSUBCLASS}
     if FOWnd <> 0 then
     begin
          { Restore the original window procedure }
          SetWindowLong( FOWnd, GWL_WNDPROC, Longint( FODefProc ));
          FreeObjectInstance(FWndProcInst);
     end;
     {$ENDIF}

     inherited;
end;
// we can only expand a node, if there are some subdirectories
function TDirTree.CanExpand(Node: TTreeNode): Boolean ;
var
   oldcur : TCursor;
begin
     oldcur := Screen.Cursor;
     Screen.Cursor := crhourglass;
     GetKids(Node);   // first setup the subtree and the button states
     GetSubKids(Node);
     Screen.Cursor := oldcur;
     Result := inherited CanExpand(Node);
end;


// setup the current dir and check if it is allowed to fire the onchange-event
// also check out if a drive has been removed or inserted
procedure TDirTree.Change(Node: TTreeNode);
var
   sr : string;
   ct : char;
   s1 : Integer;

begin
     if not (csDestroying in ComponentState)
     then
         if fAllowChange  = 0  // changing allowed ?
         then begin
             if DataAssigned ( node )
             then begin
                  ct := PDirEntry(Node.Data)^.Name[1];
                  s1 := GetDriveSerial(ct);    // has the drive been removed / inserted ?
                  if fSerNrs[ct] <> s1 // different serial #, seems to be a different medium
                  then begin
                        Node := GetNodeFromPath (ct+':\');
                        if Node <> nil
                        then begin
                             ClearNode ( Node ); // rebuild the tree for this drive
                             Node.Text := GetDriveDesc ( ct , fSerNrs[ct] );
                             if s1 <> -1
                             then
                                 Items.AddChild ( Node , '' );
                        end;
                  end;
                  if DataAssigned ( Node )
                  then begin
                       sr := AnsiUpperCase(EntryName(Node));
                       if sr <> ''
                       then
                           fActDirs[sr[1]] := sr; // setup the current directory variable
                  end;
             end;

        inherited Change (Node);

     end;
end;

// read all missing subdirectories  for full expansion
procedure TDirTree.FullExpand;
var
   oldcur : TCursor;
   Node: TTreeNode;
begin
     oldcur := Screen.Cursor;
     Screen.Cursor := crHourGlass;

     Node := Items.GetFirstNode;

     while Node <> nil
     do begin
        Node.Expand(True);
        Node := Node.GetNextSibling;
     end;

     Screen.Cursor := oldcur;
end;


// try to set the wanted drive and the last used directory on that drive
procedure TDirTree.SetDrive (Val : Char);
var
   sr : string;
begin
     if UpCase(val) <> UpCase (GetDirectory[1])
     then
         try
            sr := fActDirs[UpCase(Val)];

            if not FileOrDirExists(sr)
            then
                sr := val+':\';

            SetDirectory(sr);
         except
         end;
end;


function TDirTree.GetDrive : Char;
begin
     Result := UpCase(GetDirectory[1]);
end;


// if there is a node that belongs to the given path, returns it
function TDirTree.GetNodeFromPath(Path:string):TTreeNode;
var
   az        : Integer;
   node      : TTreeNode;
   oldcur    : TCursor;
   afg       : Integer;
   tsr       : string;

    // find a node that has this path
    function GNd(c:TTreeNode;a:string):TTreeNode;
    var
       nd : TTreeNode;
    begin
         Result := nil;

         if Items.Count = 0
         then
             Exit;

         if c <> nil
         then
             nd := c.GetFirstChild
         else
             nd := Items[0];

         while DataAssigned ( nd )
         do begin
            if EntryName(nd) = a
            then begin
                 Result := nd;
                 Exit;
            end;
            nd := nd.GetNextSibling;
         end;
    end;

begin
     Result := nil;

     AddBSlash(Path);

     // get the part strings (delimited by "\")
     az := AzPos(Path);

     if az = 0
     then
         Exit;

     oldcur := Screen.Cursor;
     Screen.Cursor := crHourGlass;

     Path := AnsiUpperCase(Path);

     node := nil;

     for afg := 1 to az
     do begin
         // get the partial directories
         tsr := GetPart(Path,afg);
         node := GNd(node,tsr);

         if node = nil
         then begin
              Screen.Cursor := oldcur;
              Exit;
         end;

     end;

     Result := Node;
     Screen.Cursor := oldcur;
end;


// delete not only the item but also the assigned tdirentry
procedure TDirTree.DelItem (Sender: TObject; Node: TTreeNode);
begin
     if DataAssigned ( Node )
     then begin
          PDirEntry(Node.Data)^.Name := '';
          {$IFNDEF Ver100}
          if PDirEntry(Node.Data)^.ShellFolder <> nil
          then
              PDirEntry(Node.Data)^.ShellFolder.Release;
          {$ENDIF}
          Dispose(PDirEntry(Node.Data));
          Node.Data := nil;
     end;

     if Assigned(fOnDeletion)
     then
         fOnDeletion(Sender,Node);
end;


// rename a part of the tree (e.g. after renaming a directory on the drive)
procedure TDirTree.RenamePart (OldPath , NewName :string);
var
   n : TTreeNode;

   procedure RenameNodeAndKids(n:TTreeNode); // renames all childs (and assigned tdirentries) of that node
   var
      sfi    : TSHFileInfo;
      oldsr  : string;
      n1     : TTreeNode;
   begin
        // first look whether the icon of this directory has changed
        oldsr := NewName+Copy(EntryName(n),Length(OldPath)+1,MaxInt);

        SHGetFileInfo( PChar(oldsr),0,sfi,SizeOf(TSHFileInfo),SHGFI_SYSICONINDEX or SHGFI_SMALLICON
                       or SHGFI_DISPLAYNAME);

        n.Text := sfi.szDisplayName;
        PDirEntry(n.Data)^.Name := oldsr;
        GetImageIndex(n,sfi.iIcon);

        if n = Selected
        then
            Change(n);

        if IsExpanded(n) and n.HasChildren
        then begin
             n1 := n.GetFirstChild;
             while DataAssigned ( n1 )
             do begin
                RenameNodeAndKids(n1); // recurse subdirectories
                n1 := n.GetNextChild(n1);
             end;
        end;
   end;

begin
     if (NewName <> '') and (OldPath <> '' ) // nothing to do resp. empty string is not usefull
     then begin
          n := GetNodeFromPath(OldPath); // find the wanted path
          if DataAssigned ( n )
          then begin
               OldPath := EntryName(n); // fix the name
               NewName := ExtractFilePath(DelBSlash(OldPath))+NewName; // add the newname to the parent path of oldpath
               AddBSlash(NewName);
               NewName := AnsiUpperCase(NewName);
               RenameNodeAndKids(n); // now rename the partial tree
          end;
     end;
end;


// remove the given path incl. child nodes from the tree
procedure TDirTree.DeletePart (DPath:string);
var
   n : TTreeNode;
begin
     n := GetNodeFromPath(DPath);

     if n <> nil
     then
         Items.Delete(n);
end;


// adds a partial tree under the given (and existing) path
procedure TDirTree.AddPath(ExPath,NewSub:string; fTag:Integer);
var
   n,n1 : TTreeNode;
begin
     n := GetNodeFromPath(ExPath);

     if DataAssigned ( n )
     then
         n1:=AddKid(n,EntryName(n)+NewSub,fTag);

     GetBtn(n1);
     n.AlphaSort;
end;


// delete the children of that node and read them new on next access
procedure TDirTree.ClearNode (Node:TTreeNode);
begin
     if Node <> nil
     then begin
          Node.DeleteChildren;
          if DataAssigned ( Node )
          then
              PDirEntry(Node.Data)^.IsExp := False;
          GetBtn(Node);
     end;
end;


//check if the node is truely expanded (by the direntry.isexp item )
function TDirTree.IsExpanded(Item : TTreeNode):Boolean;
begin
     Result := False;
     try
        if DataAssigned ( Item )
        then
            Result := PDirEntry(Item.Data)^.IsExp;
     except
     end;
end;

// the new wind proc to get WM_DEVICECHANGE messages
{$IFDEF MPDTSUBCLASS}
procedure TDirTree.OWndProc(var Message: TMessage);

  // something has changed, so check for the first changed drive
  procedure ReadNewDrives;
  var
     ct : char;
     nd : TTreeNode;
     s1 : Integer;
  begin
       for ct := 'Z' downto 'A' // begin from 'z' to avoid ugly noises from floppies if not necessary
       do begin
          s1 := GetDriveSerial(ct);
          if fSerNrs[ct] <> s1
          then begin
               nd := GetNodeFromPath (ct+':\');
               if nd <> nil
               then begin
                    ClearNode ( nd );
                    nd.Text := GetDriveDesc ( ct , fSerNrs[ct] );
                    if s1 <> -1
                    then
                        Items.AddChild ( nd , '' );
               end;
               Exit;
          end;
       end;
  end;

begin
     with Message
     do
       if Msg = WM_DEVICECHANGE
       then begin
            Result := 0;
            Dec ( fAllowChange );
            try
               if not CheckDrives // first check for removed/added (network ) drives
               then
                   ReadNewDrives;
            finally
                   Inc ( fAllowChange );
            end;
            Change ( Selected); // change , if node doesn't exist anymore, parent form should be notified
       end
       else
           Result := CallWindowProc( FODefProc, FOWnd, Msg, WParam, LParam);

end;
{$ENDIF}

// overwritten to see if a directory has changed
procedure TDirTree.Click ;
var
   Node : TTreeNode;
   ct : Char;
   s1 : Integer;
begin
     Node := Selected;
     if DataAssigned ( Node )
     then begin
          ct := PDirEntry(Node.Data)^.Name[1];
          s1 := GetDriveSerial(ct);
          if fSerNrs[ct] <> s1
          then
              Change ( Node )
          else
              Inherited;

     end;
end;

// same like ForceDirectories
procedure TDirTree.ForcePath ( fPath : string );
var
   n,n1           : TTreeNode;
   temp,kidname   : string;
   count          : Integer;
begin
     while Pos( '\' , fPath ) > 0 do
     begin
          count := Pos ( '\' , fPath );
          temp := temp + Copy ( fPath , 1 , count );
          fPath := Copy ( fPath , count + 1 , MaxInt );
          if Pos ( '\' , fPath ) > 0
          then
              kidname := Copy ( fPath , 1, Pos ( '\' , fPath ) -1 )
          else
              kidname := fPath;

          n := GetNodeFromPath ( temp );
          if n <> nil
          then begin
               n1 := GetNodeFromPath ( temp + kidname );
               if n1 = nil
               then
                   n1 := AddKid ( n , EntryName ( n ) + kidname  , 0);
               GetBtn ( n1 );
               n.AlphaSort;
          end;
     end;
end;

// Changes to the parent Directory and can also collapse the node
procedure TDirTree.GoUp ( const Collapse : Boolean );
begin
     if Selected <> nil
     then begin
         if Selected.Parent <> nil
             then
                 Selected := Selected.Parent;

         if Collapse
         then
             Selected.Collapse ( True);
     end;
end;

// set the directory that will be displayed at start
procedure TDirTree.SetInitialDirectory ( Value : TFileName );
begin
     fInitialDirectory := Value;
     if csDesigning in ComponentState
     then
         SetDirectory ( Value ); // only show this directory in design time (or better the root of it )
end;

procedure TDirTree.BeginUpdate;
begin
     Dec ( fAllowChange );
end;

procedure TDirTree.EndUpdate;
begin
     Inc ( fAllowChange );
     if fAllowChange > 0
     then
         fAllowChange := 0;

     if fAllowChange = 0
     then
         Change ( Selected );
end;

// checks the adding/removing of (shared) drives
function TDirTree.CheckDrives : Boolean;

  function FindPrev ( var Res : TTreeNode;const aPath : string ) : Boolean;
  var sr : string;
      nd : TTreeNode;
  begin
       Res := nil ;
       Result := False;
       if Items.Count > 0
       then begin
            nd := Items[0];
            while DataAssigned ( nd )
            do begin
               Res := nd;
               sr := EntryName ( nd );
               if sr > aPath
               then begin
                    Result := True;
                    Break;
                    Exit;
               end;
               nd := nd.GetNextSibling;
            end;

       end;
  end;

  procedure InsertNode (var Item : TTreeNode; A : string ; fTag : Integer);
  var
     sfi   : TSHFileInfo;
     nd : TTreeNode;
     begin
          AddBSlash(A); // add a bsl if needed

          SHGetFileInfo ( PChar(A),0,sfi,SizeOf(TSHFileInfo),SHGFI_SYSICONINDEX
                          or SHGFI_SMALLICON or SHGFI_DISPLAYNAME); // get the normal icon index
          if FindPrev ( nd , UpCase(a[1])+':\')
          then
              item := Items.Insert(nd,'' ) // and add it to the root of the tree
          else
              item := Items.Add ( nil , '' );

          if GetDriveType(PChar(A[1]+':\')) <> DRIVE_REMOVABLE
          then
              // if a cd rom is ejected, the shell doesn't seem to return an empty displayname (at least under nt4)
              item.Text := GetDriveDesc ( a[1],fSerNRs[UpCase(A[1])])
          else
              item.Text := sfi.szDisplayName; // on floppies, it works

          MakeTDirEntry(item,A,False,fTag); // add an descriptor (node's data-property)

          GetImageIndex(item,sfi.iIcon);
     end;



var fBits : TDriveBits;
    ct : Integer;
    nd : TTreeNode;
    ShouldChange : Boolean;
begin
     ShouldChange := False;


     Dec ( fAllowChange );
     Items.BeginUpdate;
     try
        fBits := GetDrives;

        // first check all deleted items
        for ct := 0 to 25
        do
          if ct in fCurrentDriveBits
          then
              if not (ct in fBits)
              then begin
                   // drive has been removed
                   nd := GetNodeFromPath ( Char ( ct + Ord ( 'A' ) )+':\' );
                   if nd <> nil
                   then begin
                        ClearNode ( nd );
                        Items.Delete ( nd );
                        ShouldChange := True;
                   end;
              end;

        // now search for added items
        for ct := 0 to 25
        do
          if ct in fBits
          then
              if not (ct in fCurrentDriveBits)
              then begin
                   // drive has been added
                   InsertNode(nd,Char ( ct + Ord ( 'A' ) )+':\',0); // create a new root node in the tree
                   if fFastLoad
                   then // do not search for the existance of sub dirs
                        Items.AddChild(nd,'')
                   else
                   case GetDriveType(PChar(Char ( ct + Ord ( 'A' ) )+':\'))
                   of
                     0,1,DRIVE_REMOVABLE,DRIVE_CDROM :Items.AddChild(nd,''); // always guess button state for disks and cdroms
                   else
                       GetBtn(nd); // net, hard : retrieve the real button state (if no fastload)
                   end;
                   ShouldChange := True;
              end;

        fCurrentDriveBits := fBits;

     finally
            Inc ( fAllowChange );
            Result := ShouldChange;
            Items.EndUpdate;
            Update;
            if ShouldChange
            then
                Change ( Selected );
     end;

end;

procedure TDirTree.Loaded;
begin
	inherited Loaded;
        if csDesigning in ComponentState
        then
            ReadNew;
        if DirectoryExists ( fInitialDirectory )
        then
	    SetDirectory( fInitialDirectory ) // set the initaldirectory
        else
            SetDirectory ( GetCurrentDir );

end;

procedure TDirTree.SetDriveTypes ( Value : TDriveTypes );
begin
     if fDriveTypes <> Value
     then begin
          fDriveTypes := Value;
          CheckDrives;
     end;
end;

function TDirTree.GetDrives : TDriveBits;
var
   E,ct : Integer;
begin
     E := SetErrorMode ( SEM_FAILCRITICALERRORS );
     try
        Integer ( Result ) := GetLogicalDrives;

        // now check if each present drive is allowed to show

        for ct := 0 to 25
        do
          if ct in Result
          then
              case GetDriveType ( PChar (Char (ct+Ord('A'))+':\'))
              of
                DRIVE_UNKNOWN : if not (drtUnknown in fDriveTypes)
                                then
                                    Exclude ( Result , ct );
                DRIVE_REMOVABLE : if not (drtRemovable in fDriveTypes)
                                then
                                    Exclude ( Result , ct );
                DRIVE_FIXED : if not (drtFixed in fDriveTypes)
                                then
                                    Exclude ( Result , ct );
                DRIVE_REMOTE : if not (drtRemote in fDriveTypes)
                                then
                                    Exclude ( Result , ct );
                DRIVE_CDROM : if not (drtCDRom in fDriveTypes)
                                then
                                    Exclude ( Result , ct );
                DRIVE_RAMDISK : if not (drtRamDisk in fDriveTypes)
                                then
                                    Exclude ( Result , ct );
              end;

     finally
            SetErrorMode ( E );
     end;

end;

// switch showshareoverlay
procedure TDirTree.SetShowShareOverlay ( Value : Boolean );

  procedure ReadShared ( Node : TTreeNode );
  begin
       while DataAssigned ( Node )
       do begin
          node.OverlayIndex := GetShareOverlay ( node );
          if PDirEntry(Node.Data)^.IsExp
          then
              ReadShared ( Node.GetFirstChild );
          node := Node.GetNextSibling;
       end;
  end;


var ct : Integer;
begin
     if Value <> fShowShareOverlay
     then begin
          fShowShareOverlay := Value ;
          if Items.Count = 0
          then
              Exit;

          if not Value
          then
              for ct := 0 to Pred ( Items.Count )
              do
                Items[ct].OverlayIndex := -1
          else ReadShared ( Items.GetFirstNode );
     end;
end;

//switch acceptdropfiles
procedure TDirTree.SetAcceptDropFiles ( Value : Boolean );
begin
     fAcceptDropFiles := Value;
     if not (csDesigning in ComponentState )
     then
         if HandleAllocated
         then
             DragAcceptFiles ( Handle , Value );
end;

// fire the ondropfiles event
procedure TDirTree.WMDropFiles ( var message : TWMDropFiles ) ;
var pt : TPoint;
    d  : HDrop;
    num: Integer;
    sr : string;
begin
     d := message.Drop;
     if fAcceptDropFiles and DragQueryPoint ( d , pt )
     then begin
          // get the droptarget node
          DropTarget := GetNodeAt ( pt.x , pt.y );

          if DropTarget <> nil
          then begin

               // now get the dropped files
               fDropList.Clear;
               num := DragQueryFile ( d , $FFFFFFFF , PChar ( sr ) , MAX_PATH );

               if num > 0
               then begin
                    for num := 0 to num -1
                    do begin
                       SetLength ( sr , MAX_PATH + 1 );
                       SetLength ( sr , DragQueryFile ( d , num , PChar ( sr ) , Max_Path ) );
                       fDropList.Add ( sr );
                    end;
                    DragFinish ( d );
                    // fire the event
                    if Assigned ( fOnDropFiles )
                    then
                        fOnDropFiles ( self , pt.x , pt.y , DropDirectory , fDropList , GetShiftState );
                    // remove the droptarget
                    DropTarget := nil;
               end;
          end;
     end;
end;

end.
