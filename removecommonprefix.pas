unit RemoveCommonPrefix;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type
  StringArray = array of String;

function RemoveCommonPrefix(Filenames: StringArray): StringArray;

implementation

function Min(x, y: Integer): Integer;
begin
  if x > y then
    Result := y
  else
    Result := x;
end;

function MinLength(Filenames: StringArray): Integer;
var
  i: Integer;
  m: Integer;
begin
  m := Length(Filenames[0]);
  for i := 1 to Length(Filenames) - 1 do
  begin
    m := Min(m, Length(Filenames[i]));
  end;

  { m - 1 because we need to keep at least one character on the filenames }
  Result := m - 1;
end;

function AreEqualAtCharacterIndex(Filenames: StringArray; Index: Integer): Boolean;
var
  i: Integer;
begin
  i := 1;
  while (i < Length(Filenames)) and (Filenames[0][Index] = Filenames[i][Index]) do
    Inc(i);

  Result := i >= Length(Filenames);
end;

function CommonPrefixLength(Filenames: StringArray): Integer;
var
  i: Integer;
  min: Integer;
begin
  min := MinLength(Filenames);
  i := 1;
  while (i <= min) and (AreEqualAtCharacterIndex(Filenames, i)) do
    Inc(i);

  Result := i - 1;
end;

function RemoveCommonPrefix(Filenames: StringArray): StringArray;
var
  i: Integer;
  prefixLength: Integer;
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
