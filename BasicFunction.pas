unit BasicFunction;

interface

type
  TPair = record
    ElemCompare: Variant;
    PElement: Pointer;
  end;
  TSortPairArr = array of TPair;
  TComparator = function (element1, element2: Variant): integer;

function ReadInt(min, max: integer): integer;
procedure ReadRusStr(var str: string);
procedure LowerRus(var s1: String);

function compare1More2(element1, element2: Variant): integer;
function compare1Less2(element1, element2: Variant): integer;
procedure QuickSort(var arr: TSortPairArr; compare: TComparator);

implementation

uses System.SysUtils;

type SArr = array of string;

const //splitSimbol: string = ' ,;.';
      rusLetters: string = 'ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ';
      engLettersAndNum: string = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789';

//from big to little
procedure shake_sort(var arr: array of integer; long: integer);
var left, right, i, temp, lastSwap :integer;
begin
   left := 0;  //dinamic
   right := long-1; //dinamic
   lastSwap := 0;
   while (right > left) do begin
     for i := left to right-1 do begin
       if (arr[i] < arr[i+1]) then begin //change < on > to make from little to big
          temp := arr[i];
          arr[i] := arr[i+1];
          arr[i+1] := temp;
          lastSwap := i;
       end;
     end;
     right := lastSwap;
     for i := right downto left + 1 do begin
       if (arr[i] > arr[i-1]) then begin //change < on > to make from little to big
          temp := arr[i];
          arr[i] := arr[i-1];
          arr[i-1] := temp;
          lastSwap := i;
       end;
     end;
     left := lastSwap;
   end;
end;

function compare1More2(element1, element2: Variant): integer;
begin
  if (element1 = element2) then result:= 0
  else if (element1 > element2) then result:= 1
  else result:= -1;
end;

function compare1Less2(element1, element2: Variant): integer;
begin
  if (element1 = element2) then result:= 0
  else if (element1 < element2) then result:= 1
  else result:= -1;
end;

procedure QuickSort(var arr: TSortPairArr; compare: TComparator);

Procedure MyQuickSort(L,R: Integer);
var
  I, J: Integer;
  X: Variant;
  temp: TPair;
begin
  I:=L;
  J:=R;
  X:=arr[(L+R) div 2].ElemCompare;
  Repeat
    While (compare(arr[I].ElemCompare, X) < 0) do Inc(I); //<
    While (compare(arr[J].ElemCompare, X) > 0)do Dec(J);  //>
    If (I <= J) then begin
      temp:= arr[I];
      arr[I]:= arr[J];
      arr[J]:= temp;
      Inc(I);
      Dec(J);
    end
  until I > J;
  If J > L then MyQuickSort(L,J);
  If I < R then MyQuickSort(I,R);
end;

begin
  MyQuickSort(Low(arr), High(arr));
end;

function ReadInt(min, max: integer): integer;
var
    num: integer;
begin
  num:= min-1;
  while (num < min) or (num > max) do begin
    try
      read(num);
      if (num < min) or (num > max) then begin
        writeln('число должно быть больше ', min, ' и меньше ', max, ', повторите ввод');
      end;
    except
      on EInOutError do begin
        num:= min-1;
        writeln('принимается только ввод чисел, повторите ввод');
      end;
    end;
  end;
  result:= num;
  readln;   //съедаем строчку перехода после ввода чисел
end;

procedure LowerRus(var s1: String);
var
  len, i: Integer;
begin
  len := Length(s1);
  for i := 1 to len do
  begin
    if (s1[i] >= 'А') and (s1[i] <= 'Я') then
      s1[i] := Chr(Ord(s1[i])+32)
  end;
end;

procedure BiggerRus(var s1: String);
var
  len, i: Integer;
begin
  len := Length(s1);
  for i := 1 to len do
  begin
    if (s1[i] >= 'а') and (s1[i] <= 'я') then
      s1[i] := Chr(Ord(s1[i])-32)
  end;
end;

procedure ReadRusStr(var str: string);
var
  stop: boolean;
begin
  repeat
    stop:= true;
    readln(str);
    str:= trim(str);
    if (str = '') then begin
      writeln('строка не должна быть пустой!');
      stop:= false;
    end;
  until (stop);
  if (rusLetters.contains(str[1])) then LowerRus(str)
  else str:= LowerCase(str);
end;

function NumOfWords(str: string): integer;
begin
  insert(' ', str, 1);
  str := str + ' ';
  result := 0;
  for var i := 1 to length(str) - 1 do
  begin
    if ((not rusLetters.contains(str[i])) and rusLetters.contains(str[i+1])) then
      result := result + 1;
  end;
end;

function ListOfWords(str: string): SArr;
var
  startPos, endPos, wordNow, CountWords: integer;
  startFlag, endFlag: boolean;
  word: string;

begin
  insert(' ', str, 1);
  str := str + ' ';
  CountWords:= NumOfWords(str);
  setLength(result, CountWords);
  startFlag := False;
  endFlag := False;
  wordNow := 0;
  for var i := 1 to length(str) - 1 do
  begin
    if ((not rusLetters.contains(str[i])) and rusLetters.contains(str[i+1])) then
    begin
      startPos := i + 1;
      startFlag := True;
    end;
    if (rusLetters.contains(str[i]) and (not rusLetters.contains(str[i+1]))) then
    begin
      endPos := i;
      endFlag := True;
    end;
    if (startFlag and endFlag) then
    begin
      word:= copy(str, startPos, endPos - startPos + 1);
      LowerRus(word);
      result[wordNow] := word;
      wordNow := wordNow + 1;
      startFlag := False;
      endFlag := False;
    end;
  end;
end;

function NumOfWordsAndNum(str: string): integer;
begin
  insert(' ', str, 1);
  str := str + ' ';
  result := 0;
  for var i := 1 to length(str) - 1 do
  begin
    if ((not engLettersAndNum.contains(str[i])) and engLettersAndNum.contains(str[i+1])) then
      result := result + 1;
  end;
end;

function ListOfWordsAndNum(str: string): SArr;
var
  startPos, endPos, wordNow, CountWords: integer;
  startFlag, endFlag: boolean;
  word: string;

begin
  insert(' ', str, 1);
  str := str + ' ';
  CountWords:= NumOfWordsAndNum(str);
  setLength(result, CountWords);
  startFlag := False;
  endFlag := False;
  wordNow := 0;
  for var i := 1 to length(str) - 1 do
  begin
    if ((not engLettersAndNum.contains(str[i])) and engLettersAndNum.contains(str[i+1])) then
    begin
      startPos := i + 1;
      startFlag := True;
    end;
    if (engLettersAndNum.contains(str[i]) and (not engLettersAndNum.contains(str[i+1]))) then
    begin
      endPos := i;
      endFlag := True;
    end;
    if (startFlag and endFlag) then
    begin
      word:= copy(str, startPos, endPos - startPos + 1);
      result[wordNow] := word;
      wordNow := wordNow + 1;
      startFlag := False;
      endFlag := False;
    end;
  end;
end;

end.
