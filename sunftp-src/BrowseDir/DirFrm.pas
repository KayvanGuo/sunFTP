unit DirFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DirTree, ExtCtrls, marsCap, Buttons, Menus;

type
  TDirForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    DirTree: TDirTree;
    Panel2: TPanel;
    btnOK: TButton;
    PopupMenu1: TPopupMenu;
    Createanewdirectory1: TMenuItem;
    Label2: TLabel;
    procedure DirTreeChange(Sender: TObject; Node: TTreeNode);
    procedure btnOKClick(Sender: TObject);
    procedure Createanewdirectory1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DirForm: TDirForm;

implementation

Uses UsersList;
{$R *.DFM}


procedure TDirForm.DirTreeChange(Sender: TObject; Node: TTreeNode);
begin
Label1.Caption := DirTree.Directory;
end;

procedure TDirForm.btnOKClick(Sender: TObject);
begin
UsersListForm.HomeDirectory.Text := DirTree.Directory;
Close;
end;

procedure TDirForm.Createanewdirectory1Click(Sender: TObject);
var
  NewString: string;
  ClickedOK: Boolean;
begin
  NewString := DirTree.Directory+'user_xxx';
  ClickedOK := InputQuery('New directory', 'Enter a new directory to create', NewString);
  if ClickedOK then
  { $I-}
  { Get directory name from TEdit control }
  MkDir(NewString);
  if IOResult <> 0 then begin
    MessageDlg('Cannot create directory', mtWarning, [mbOk], 0);
    end
  else begin
    DirTree.ReLoad;
    DirTree.Refresh;
    end;
end;

end.
