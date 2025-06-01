unit SortAndFind;

interface

uses Files;

procedure SortListQ(typeList, typeElement, typeCompare: integer);
function Find(elementFind: variant; arr: ArrPoint; var typeList, typeElement, typeCompare: integer): ArrPoint;
function ArrFromList(listNum: integer): ArrPoint;

implementation

uses BasicFunction, WorkWithList, printList;

function ArrFromList(listNum: integer): ArrPoint;
var
  tempI: PIngredient;
  tempS: PSalat;
  tempO: POrder;
  index: integer;
begin
  index:= 0;
  setLength(result, 20);
  case listNum of
    1: begin
      tempI:= HeadIngredient^.adr;
      while (tempI <> nil) do begin
        if (index >= length(result)) then setLength(result, length(result)*2);
        result[index]:= tempI;
        tempI:= tempI^.adr;
        inc(index);
      end;
    end;
    2: begin
      tempS:= HeadSalat^.adr;
      while (tempS <> nil) do begin
        if (index >= length(result)) then setLength(result, length(result)*2);
        result[index]:= tempS;
        tempS:= tempS^.adr;
        inc(index);
      end;
    end;
    3: begin
      tempO:= HeadOrder^.adr;
      while (tempO <> nil) do begin
        if (index >= length(result)) then setLength(result, length(result)*2);
        result[index]:= tempO;
        tempO:= tempO^.adr;
        inc(index);
      end;
    end;
  end;
  setLength(result, index);
end;

//typeCompare 1-= 2-not= 3-> 4-<
function FindCompare(element1, element2: variant; typeCompare: integer): boolean;
begin
  case typeCompare of
    1: result:= element1 = element2;
    2: result:= (element1 <> element2);
    3: result:= (element1 > element2);
    4: result:= (element1 < element2);
  end;
end;

procedure SortListQ(typeList, typeElement, typeCompare: integer);

var
  tempI: PIngredient;
  tempS: PSalat;
  tempO: POrder;
  element: Pointer;

procedure assign(element, value: Pointer);
var
  tempI: PIngredient;
  tempS: PSalat;
  tempO: POrder;
begin
  tempI:= element;
  tempS:= element;
  tempO:= element;
  case typeList of
    1: tempI^.adr:= value;
    2: tempS^.adr:= value;
    3: tempO^.adr:= value;
  end;
end;

function Next(element: Pointer): Pointer;
var
  tempI: PIngredient;
  tempS: PSalat;
  tempO: POrder;
begin
  tempI:= element;
  tempS:= element;
  tempO:= element;
  case typeList of
    1: result:= tempI^.adr;
    2: result:= tempS^.adr;
    3: result:= tempO^.adr;
  end;
end;

function Take(element: Pointer): variant;
var
  tempI: PIngredient;
  tempS: PSalat;
  tempO: POrder;
begin
  tempI:= element;
  tempS:= element;
  tempO:= element;
  case typeList of
    1:
    case typeElement of
      1: result:= tempI^.inf.Index;
      2: result:= tempI^.inf.Name;
      3: result:= tempI^.inf.Grams;
      4: result:= tempI^.inf.proteins;
      5: result:= tempI^.inf.Fats;
      6: result:= tempI^.inf.carbohydrates;
    end;
    2:
    case typeElement of
      1: result:= tempS^.inf.Index;
      2: result:= tempS^.inf.Name;
      3: result:= tempS^.inf.cost;
      4: result:= tempS^.inf.numOfIngredients;
    end;
    3:
    case typeElement of
      1: result:= PointSalat(tempO^.Index)^.inf.Name;
      2: result:= tempO^.amount;
      3: result:= tempO^.CadDo;
    end;
  end;
end;

// Сливает два отсортированных подсписка в один отсортированный список
function SortedMerge(Left, Right: Pointer): Pointer;
begin
  // Базовые случаи рекурсии
  if Left = nil then result:= Right
  else if Right = nil then result:= Left
  else begin
    if FindCompare(Take(Right), Take(Left), typeCompare) then begin
      result:= Left;
      assign(result, SortedMerge(Next(Left), Right));
    end
    else begin
      result:= Right;
      assign(result, SortedMerge(Left, Next(Right)));
    end;
  end;
end;

// Разбивает список на две половины
Procedure Split(head: pointer; var first, second: pointer);
begin
  //базовые случаи: 0 или 1 элемент
  if (head = nil) or (Next(head) = nil) then begin
    first:= head;
    second:= nil;
  end
  else begin
    first:= head;
    second:= Next(head);

    while second <> nil do begin
      second := Next(second);
      if second <> nil then begin
        first := Next(first);
        second := Next(second);
      end;
    end;

    second:= Next(first);
    assign(first, nil);
    first:= head;
  end;
end;

procedure MergeSort(var AHead: Pointer);
var
  Head: pointer;
  Left, Right: Pointer;
begin
  Head := AHead;

  //базовый случай
  if (Head = nil) or (Next(Head) = nil) then Exit;

  Split(Head, Left, Right);

  //рекурсивно сортируем каждую половину
  MergeSort(Left);
  MergeSort(Right);

  AHead := SortedMerge(Left, Right);
end;

begin
  case typeList of
    1: element:= HeadIngredient;
    2: element:= HeadSalat;
    3: element:= HeadOrder;
  end;
  if (Next(element) = nil) then writeln('список пустой!')
  else begin
    case typeList of
      1: MergeSort(Pointer(HeadIngredient^.adr));
      2: MergeSort(Pointer(HeadSalat^.adr));
      3: MergeSort(Pointer(HeadOrder^.adr));
    end;
    writeln('список отсортирован! ');
  end;
end;

//typeCompare 1-= 2-not= 3-> 4-<
function Find(elementFind: variant; arr: ArrPoint;
         var typeList, typeElement, typeCompare: integer): ArrPoint;
var
  tempI: PIngredient;
  tempS: PSalat;
  tempO: POrder;
  elementNow: variant;
  index, indexResult: integer;
  check: boolean;
begin
  setLength(result, 20);
  indexResult:= 0;
  index:= 0;
  case typeList of
    1:
    begin
      while (index < length(arr)) do begin
        tempI:= PIngredient(arr[index]);

        case typeElement of              //prepare element
          1: elementNow:= tempI^.inf.change;
          2: elementNow:= tempI^.inf.Grams;
          3: elementNow:= tempI^.inf.proteins;
          4: elementNow:= tempI^.inf.Fats;
          5: elementNow:= tempI^.inf.carbohydrates;
        end;

        if (FindCompare(elementNow, elementFind, typeCompare)) then begin  //check all elements
          if (indexResult >= length(result)) then setLength(result, length(result)*2);
          result[indexResult]:= tempI;
          inc(indexResult);
        end;

        inc(index);
      end;
    end;
    2:
    begin
      while (index < length(arr)) do begin
        tempS:= PSalat(arr[index]);
        if (typeElement = 1) then begin
          check:= false;
          for var i:= 1 to tempS^.inf.numOfIngredients do begin
            elementNow:= tempS^.inf.ingredients[i].Index;
            if (FindCompare(elementNow, elementFind, typeCompare)) then
              check:= true;
          end;
          if (check) then begin
            if (indexResult >= length(result)) then setLength(result, length(result)*2);
            result[indexResult]:= tempS;
            inc(indexResult);
          end;
        end
        else if (typeElement = 2) then begin
          elementNow:= tempS^.inf.cost;
          if (FindCompare(elementNow, elementFind, typeCompare)) then begin
            if (indexResult >= length(result)) then setLength(result, length(result)*2);
            result[indexResult]:= tempS;
            inc(indexResult);
          end;
        end;
        inc(index);
      end;
    end;
    3:
    begin
      while (index < length(arr)) do begin
        tempO:= POrder(arr[index]);

        case typeElement of
          1: elementNow:= tempO^.CadDo;
          2: elementNow:= tempO^.amount;
          3: begin
            check:= false;
            tempS:= PointSalat(tempO^.Index);
            for var i:= 1 to tempS^.inf.numOfIngredients do begin
              elementNow:= tempS^.inf.ingredients[i].Index;
              if (FindCompare(elementNow, elementFind, typeCompare)) then
                check:= true;
            end;
            if (check) then begin
              if (indexResult >= length(result)) then setLength(result, length(result)*2);
              result[indexResult]:= tempO;
              inc(indexResult);
            end;
          end;
          4: begin
            tempS:= PointSalat(tempO^.Index);
            elementNow:= tempS^.inf.cost * tempO^.amount;
          end;
        end;

        if (FindCompare(elementNow, elementFind, typeCompare)) and (typeElement <> 3) then begin
          if (indexResult >= length(result)) then setLength(result, length(result)*2);
          result[indexResult]:= tempO;
          inc(indexResult);
        end;

        inc(index);
      end;
    end;
  end;
  setLength(result, indexResult);
  if (length(result) = 0) then begin
    writeln('Ничего не найдено');
    typeList:= 0;
    readln;
  end;
  PrintTitle(typeList);
  for var i:= 0 to length(result)-1 do begin
    case typeList of
      1: Print1I(PIngredient(result[i]));
      2: Print1S(PSalat(result[i]));
      3: Print1O(POrder(result[i]));
    end;
  end;
end;

end.
