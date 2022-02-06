unit RemoveCommonPrefix;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type
  StringArray = array of string;

function RemoveCommonPrefix(Filenames: StringArray): StringArray;

implementation

function Min(x, y: integer): integer;
begin
  if x > y then
    Result := y
  else
    Result := x;
end;

function MinLength(Filenames: StringArray): integer;
var
  i: integer;
  m: integer;
begin
  m := Length(Filenames[0]);
  for i := 1 to Length(Filenames) - 1 do
  begin
    m := Min(m, Length(Filenames[i]));
  end;

  { m - 1 because we need to keep at least one character on the filenames }
  Result := m - 1;
end;

function AreEqualAtCharacterIndex(Filenames: StringArray; Index: integer): boolean;
var
  i: integer;
begin
  i := 1;
  while (i < Length(Filenames)) and (Filenames[0][Index] = Filenames[i][Index]) do
    Inc(i);

  Result := i >= Length(Filenames);
end;

function CommonPrefixLength(Filenames: StringArray): integer;
var
  i: integer;
  min: integer;
begin
  min := MinLength(Filenames);
  i := 1;
  while (i <= min) and (AreEqualAtCharacterIndex(Filenames, i)) do
    Inc(i);

  Result := i - 1;
end;

function RemoveCommonPrefix(Filenames: StringArray): StringArray;
var
  i: integer;
  prefixLength: integer;
begin
  prefixLength := CommonPrefixLength(Filenames);
  if prefixLength <= 0 then
  begin
    Result := Filenames;
  end
  else
  begin
    SetLength(Result, Length(Filenames));
    for i := 0 to Length(Filenames) - 1 do
    begin
      Result[i] := Copy(Filenames[i], prefixLength + 1, Length(Filenames[i]) -
        prefixLength);
    end;
  end;
end;

end.
