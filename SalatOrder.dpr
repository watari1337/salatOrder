program SalatOrder;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Files in 'Files.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
end.
