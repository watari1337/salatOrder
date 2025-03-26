unit LoadMenu;

interface

procedure MainMenu();

implementation

uses Files, BasicFunction, Windows;

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

  valueInput:= BasicFunction.ReadInt(1, 11);
  case valueInput of
    1: Files.ReadFile();
    2:;
    9:;//обычный выход, ничего делать не надо
    11:;       //Files.CreateFile;
  end;
end;

end.
