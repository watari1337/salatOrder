unit LoadMenu;

interface

procedure MainMenu();
procedure ClearScreen;

implementation

uses SysUtils, Files, BasicFunction, Windows, PrintList, AddList, SubList;

procedure ClearScreen;
var
  ConsoleHandle: THandle;                // Дескриптор консоли
  ConsoleInfo: TConsoleScreenBufferInfo; // Структура с информацией о консоли
  ConsoleSize: DWORD;                    // Размер буфера консоли (количество символов)
  CursorPos: TCoord;                     // Координаты курсора
  Written: DWORD;                        // Количество записанных символов
begin
  ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE); // Получаем дескриптор консоли
  GetConsoleScreenBufferInfo(ConsoleHandle, ConsoleInfo); // Информация о консоли
  ConsoleSize := ConsoleInfo.dwSize.X * ConsoleInfo.dwSize.Y; // Размер буфера
  CursorPos.X := 0;                         // Устанавливаем координату X курсора
  CursorPos.Y := 0;                         // Устанавливаем координату Y курсора

  // Заполняем консоль пробелами
  FillConsoleOutputCharacter(ConsoleHandle, ' ', ConsoleSize, CursorPos, Written);
  // Перемещаем курсор в начало
  SetConsoleCursorPosition(ConsoleHandle, CursorPos);
end;

procedure LookList();
var
    valueInput: integer;
begin
  ClearScreen;

  writeln('0. Вернуться назад');
  writeln('1. Ингредиенты');
  writeln('2. Салаты');
  writeln('3. Банкет');

  valueInput:= BasicFunction.ReadInt(0, 3);
  ClearScreen;

  case valueInput of
    0: MainMenu;
    1:
    begin
      printIngredients;
      readln;
      MainMenu;
    end;
    2:
    begin
      printSalat;
      readln;
      MainMenu;
    end;
    3:
    begin
      printOrder;
      readln;
      MainMenu;
    end;
  end;
end;

procedure AddToList();
var
    valueInput: integer;
begin
  ClearScreen;

  writeln('0. Вернуться назад');
  writeln('1. Ингредиенты');
  writeln('2. Салаты');
  writeln('3. Банкет');

  valueInput:= BasicFunction.ReadInt(0, 3);
  ClearScreen;

  case valueInput of
    1:
    begin
      repeat
        AddIngredient;
        Writeln('Хотите добавить ещё 1 элемент? 0 - нет; 1 - да');
        valueInput:= BasicFunction.ReadInt(0, 1);
      until valueInput = 0;
    end;
    2:
    begin
      if (headIngredient^.adr = nil) then begin
        writeln('нет добавленных ингредиентов, добавить салат невозможно.');
        readln;
      end
      else begin
        repeat
          AddSalat;
          Writeln('Хотите добавить ещё 1 элемент? 0 - нет; 1 - да');
          valueInput:= BasicFunction.ReadInt(0, 1);
        until valueInput = 0;
      end;
    end;
    3:
    begin
      if (headSalat^.adr = nil) then begin
        writeln('нет добавленных салатов, добавить салат для заказа невозможно.');
        readln;
      end
      else begin
        repeat
          AddOrder;
          Writeln('Хотите добавить ещё 1 элемент? 0 - нет; 1 - да');
          valueInput:= BasicFunction.ReadInt(0, 1);
        until valueInput = 0;
      end;
    end;
  end;
  MainMenu;
end;

procedure subList();
var
    valueInput: integer;
begin
  ClearScreen;

  writeln('0. Вернуться назад');
  writeln('1. Ингредиенты');
  writeln('2. Салаты');
  writeln('3. Банкет');

  valueInput:= BasicFunction.ReadInt(0, 3);
  ClearScreen;

  case valueInput of
    0: MainMenu;
    1:
    begin
      repeat
        SubIngr();
        Writeln('Хотите удалить ещё 1 элемент? 0 - нет; 1 - да');
        valueInput:= BasicFunction.ReadInt(0, 1);
      until valueInput = 0;
      MainMenu;
    end;
    2:
    begin
      repeat
        SubSalat;
        Writeln('Хотите удалить ещё 1 элемент? 0 - нет; 1 - да');
        valueInput:= BasicFunction.ReadInt(0, 1);
      until valueInput = 0;
      MainMenu;
    end;
    3:
    begin
      repeat
        SubOrder;
        Writeln('Хотите удалить ещё 1 элемент? 0 - нет; 1 - да');
        valueInput:= BasicFunction.ReadInt(0, 1);
      until valueInput = 0;
      MainMenu;
    end;
  end;
end;

procedure editList;
var
    valueInput: integer;
begin
  ClearScreen;

  writeln('0. Вернуться назад');
  writeln('1. Ингредиенты');
  writeln('2. Салаты');
  writeln('3. Банкет');

  valueInput:= BasicFunction.ReadInt(0, 3);
  ClearScreen;

  case valueInput of
    1: editIngr;
    2: editSalat;
    3: editOrder;
  end;
  MainMenu
end;

procedure MainMenu();
var
    valueInput: integer;
begin
  ClearScreen;

  writeln('1.  Чтение данных из файла');
  writeln('2.  Просмотр всего списка');
  writeln('3.  Сортировка данных');
  writeln('4.  Поиск данных с использованием фильтров');
  writeln('5.  Добавление данных в список');
  writeln('6.  Удаление данных из списка');
  writeln('7.  Редактирование данных');
  writeln('8.  Специальные функции задания.');
  writeln('9.  Выход из программы без сохранения изменений');
  writeln('10. Выход с сохранением изменений');
  writeln('11. Дебаг!!!!!!');

  {Repeat
    valueInput:= BasicFunction.ReadInt(1, 10);
    if (valueInput <> 9) and (valueInput <> 1) and (ReadOnlyOne = true) then
    Writeln('Нельзя использовать функции программы пока не загружены файлы!');
  Until (valueInput = 9) or (valueInput = 1) or (ReadOnlyOne = false);}
  valueInput:= BasicFunction.ReadInt(1, 11);
  case valueInput of
    1: Files.ReadFile();
    2: LookList();
    3:;
    4:;
    5: AddToList;
    6: subList;
    7: editList;
    8:;
    9:
    begin
      ClearAllList;//обычный выход, очищение списков
      Halt(0);
    end;
    10:
    begin
      Files.WriteFile();
      ClearAllList;
      Halt(0);
    end;
    11:
    begin
      Files.CreateFile;
    end;
  end;
end;

end.
