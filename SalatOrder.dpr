program SalatOrder;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Files in 'Files.pas',
  BasicFunction in 'BasicFunction.pas',
  LoadMenu in 'LoadMenu.pas',
  WorkWithList in 'WorkWithList.pas',
  PrintList in 'PrintList.pas',
  AddList in 'AddList.pas',
  SubList in 'SubList.pas',
  Special in 'Special.pas',
  SortAndFind in 'SortAndFind.pas';

var
    valueInput: integer;

begin
  //создание пустой головы
  New(HeadIngredient);
  HeadIngredient^.adr:= nil;
  New(HeadSalat);
  HeadSalat^.adr:= nil;
  New(HeadOrder); //инициализируем список банкета
  HeadOrder^.adr:= nil;

  if not DirectoryExists('Data\') then CreateDir('Data\');

  MainMenu();
end.
