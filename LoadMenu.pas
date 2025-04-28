unit LoadMenu;

interface

procedure MainMenu();
procedure ClearScreen;

implementation

uses SysUtils, Files, BasicFunction, Windows, PrintList, AddList, SubList,
     Special, sortAndFind;

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

function chooseList(): integer;
begin
  ClearScreen;

  writeln('0. Вернуться назад');
  writeln('1. Ингредиенты');
  writeln('2. Салаты');
  writeln('3. Банкет');

  result:= BasicFunction.ReadInt(0, 3);
  ClearScreen;
end;

procedure LookList();
begin
  case chooseList of
    1: printIngredients;
    2: printSalat;
    3: printOrder;
  end;
  readln;
  //0-выход в меню = конец выпоолнения функции
end;

procedure AddToList();
var
    valueInput: integer;
begin
  case chooseList of
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
  //выход обратно в меню
end;

procedure subList();
var
    valueInput: integer;
begin
  case chooseList of
    1:
    begin
      repeat
        SubIngr();
        Writeln('Хотите удалить ещё 1 элемент? 0 - нет; 1 - да');
        valueInput:= BasicFunction.ReadInt(0, 1);
      until valueInput = 0;
    end;
    2:
    begin
      repeat
        SubSalat;
        Writeln('Хотите удалить ещё 1 элемент? 0 - нет; 1 - да');
        valueInput:= BasicFunction.ReadInt(0, 1);
      until valueInput = 0;
    end;
    3:
    begin
      repeat
        SubOrder;
        Writeln('Хотите удалить ещё 1 элемент? 0 - нет; 1 - да');
        valueInput:= BasicFunction.ReadInt(0, 1);
      until valueInput = 0;
    end;
  end;
end;

procedure editList;
begin
  case chooseList of
    1: editIngr;
    2: editSalat;
    3: editOrder;
  end;
end;

procedure Sort();
var
  typeList, typeElement, typeCompare: integer;
begin
  typeList:= chooseList;
  case typeList of
    0: exit;
    1:
    begin
      writeln('0. Вернуться в меню');
      writeln('1. Сортировать ингредиенты по коду');
      writeln('2. Сортировать ингредиенты по имени');
      writeln('3. Сортировать ингредиенты по граммам на складе');
      writeln('4. Сортировать ингредиенты по белкам');
      writeln('5. Сортировать ингредиенты по жирам');
      writeln('6. Сортировать ингредиенты по углеродам');
      typeElement:= BasicFunction.ReadInt(0, 6);
    end;
    2:   //салаты
    begin
      writeln('0. Вернуться в меню');
      writeln('1. Сортировать салаты по коду');
      writeln('2. Сортировать салаты по имени');
      writeln('3. Сортировать салаты по цене');
      writeln('4. Сортировать салаты по количеству продуктов');
      typeElement:= BasicFunction.ReadInt(0, 4);
    end;
    3:
    begin
      writeln('0. Вернуться в меню');
      writeln('1. Сортировать заказы по имени салата');
      writeln('2. Сортировать салаты по количеству порций салатов');
      writeln('3. Сортировать салаты по приготовления');
      typeElement:= BasicFunction.ReadInt(0, 4);
    end;
  end;
  if (typeElement = 0) then exit;
  ClearScreen;
  writeln('0. Вернуться в меню');
  writeln('1. Сортировать по возрастанию');
  writeln('2. Сортировать по убыванию');
  typeCompare:= BasicFunction.ReadInt(0, 2);

  if (typeCompare = 0) then exit;

  SortListQ(typeList, typeElement, typeCompare);
  readln;
end;

procedure MainMenu();
var
    valueInput: integer;
begin
  repeat
    ClearScreen;

    writeln('1.  Чтение данных из файла');
    writeln('2.  Просмотр всего списка');
    writeln('3.  Сортировка данных');
    writeln('4.  Поиск данных с использованием фильтров');
    writeln('5.  Добавление данных в список');
    writeln('6.  Удаление данных из списка');
    writeln('7.  Редактирование данных');
    writeln('8.  Проверить возможность приготовления заказа.');
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
      3: Sort;
      4:;
      5: AddToList;
      6: subList;
      7: editList;
      8: chekAndInfo;
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
  until (False);
end;

end.
