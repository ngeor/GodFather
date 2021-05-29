program GodFather;

{$MODE Delphi}

uses
  Forms,
  Interfaces,
  GF_Main in 'GF_Main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
