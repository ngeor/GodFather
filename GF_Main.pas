unit GF_Main;

{$MODE Delphi}

interface

uses
  SysUtils,
  Forms, Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    PageControl1: TPageControl;
    OpenDialog1: TOpenDialog;
    TabSheet2: TTabSheet;
    rdgTitle: TRadioGroup;
    rdgExt: TRadioGroup;
    btnOK_SO: TBitBtn;
    TabSheet3: TTabSheet;
    btnRemoveCommonLeadingPart: TBitBtn;
    btnOrganize: TBitBtn;
    lvFiles: TListView;
    btnAddFiles: TBitBtn;
    btnRemoveFiles: TBitBtn;
    btnClearAll: TBitBtn;
    procedure btnAddFilesClick(Sender: TObject);
    procedure btnRemoveFilesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOK_SOClick(Sender: TObject);
    procedure btnRemoveCommonLeadingPartClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure btnOrganizeClick(Sender: TObject);
  private
    procedure DoAddFile(const FileName: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses RemoveCommonPrefix;

procedure TForm1.DoAddFile(const FileName: String);
begin
  with lvFiles.Items.Add do
  begin
    Caption := ExtractFileName(FileName);
    SubItems.Add(ExtractFilePath(FileName));
  end;
end;

procedure TForm1.btnAddFilesClick(Sender: TObject);
var
  i: Integer;
begin
  with OpenDialog1 do
    if Execute then
      for i := 0 to Files.Count - 1 do
        DoAddFile(Files[i]);
end;

procedure TForm1.btnRemoveFilesClick(Sender: TObject);
var
  i: TListItem;
begin
  i := lvFiles.Selected;
  while Assigned(i) do
  begin
    i.Delete;
    i := lvFiles.Selected;
  end;
end;

procedure TForm1.btnClearAllClick(Sender: TObject);
begin
  lvFiles.Items.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
end;

function AnsiDummy(const s: String): String;
begin
  Result := s;
end;

{
  Capitalize first letter of each word
}
function AnsiNormalizeCase(const s: String): String;
var
  i, L: Integer;
begin
  i := 1;
  L := Length(s);
  Result := s;
  while i <= L do
  begin
    while (i <= L) and (Result[i] = ' ') do
      Inc(i);
    if i <= L then
    begin
      Result[i] := AnsiUpperCase(Result[i])[1];
      Inc(i);
    end;
    while (i <= L) and (Result[i] <> ' ') do
    begin
      Result[i] := AnsiLowerCase(Result[i])[1];
      Inc(i);
    end;
  end;
end;

type
  fnStringHandler = function(const s: String): String;

{
  simple ops: rename files
}
procedure TForm1.btnOK_SOClick(Sender: TObject);
var
  i: Integer;
  s, s2: String;
  fnTitle, fnExt: fnStringHandler;

  procedure RdgToFn(rdg: TRadioGroup; var fn: fnStringHandler);
  begin
    case rdg.ItemIndex of
      1: fn := AnsiUpperCase;
      2: fn := AnsiLowerCase;
      3: fn := AnsiNormalizeCase;
      else
        fn := AnsiDummy;
    end;
  end;

begin
  RdgToFn(rdgTitle, fnTitle);
  RdgToFn(rdgExt, fnExt);
  for i := 0 to lvFiles.Items.Count - 1 do
  begin
    s := IncludeTrailingBackSlash(lvFiles.Items[i].SubItems[0]);
    s2 := s;
    s := s + lvFiles.Items[i].Caption;
    s2 := s2 + fnTitle(lvFiles.Items[i].Caption);
    RenameFile(s, s2);
  end;
end;

{
  more ops: remove common leading part from filenames.
}
procedure TForm1.btnRemoveCommonLeadingPartClick(Sender: TObject);
var
  i: Integer;
  path: String;
  Filenames, RenamedFilenames: StringArray;
begin
  if lvFiles.Items.Count <= 1 then
    MessageDlg('There must be more than one files for this operation.',
      mtError, [mbOK], 0)
  else
  begin
    SetLength(Filenames, lvFiles.Items.Count);
    for i := 0 to lvFiles.Items.Count - 1 do
      Filenames[i] := lvFiles.Items[i].Caption;

    RenamedFilenames := RemoveCommonPrefix.RemoveCommonPrefix(Filenames);

    for i := 0 to lvFiles.Items.Count - 1 do
    begin
      path := IncludeTrailingBackSlash(lvFiles.Items[i].SubItems[0]);
      RenameFile(path + Filenames[i], path + RenamedFilenames[i]);
    end;
  end;
end;

{
  more ops: organize directory
}
procedure TForm1.btnOrganizeClick(Sender: TObject);
const
  delim: String = ' - ';
var
  i, j: Integer;
  rootFolder: String;
  filename, filedir: String;
  firstpart, secondpart: String;
  newfiledir: String;
begin
  if SelectDirectory('Select a directory', '', rootFolder) then
  begin
    rootFolder := IncludeTrailingBackslash(rootFolder);
    for i := 0 to lvFiles.Items.Count - 1 do
    begin
      filename := lvFiles.Items[i].Caption;
      j := Pos(delim, filename);
      if (j > 0) then
      begin
        firstpart := Copy(filename, 1, j - 1);
        secondpart := Copy(filename, j + Length(delim), Length(filename) - j -
          Length(delim) + 1);
        filedir := IncludeTrailingBackslash(lvFiles.Items[i].SubItems[0]);
        newfiledir := IncludeTrailingBackslash(rootFolder + firstpart);
        if (filedir <> newfiledir) then
        begin
          ForceDirectories(newfiledir);
        end;

        RenameFile(filedir + filename, newfiledir + secondpart);
      end;
    end;
  end;
end;

end.
