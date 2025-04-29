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

procedure SortListQ(typeList, typeElement, typeCompare: integer);
var
  tempI: PIngredient;
  tempS: PSalat;
  tempO: POrder;
  sortArr: TSortPairArr;
  tempElement: TPair;
  index: integer;
begin
  setLength(sortArr, 20);
  index:= 0;
  //создаём массив 1 элемент сортировки 2 pointer
  case typeList of
    1:
    begin
      tempI:= HeadIngredient^.adr;
      while (tempI <> nil) do begin
        tempElement.PElement:= tempI;
        case typeElement of
          1: tempElement.ElemCompare:= tempI^.inf.Index;
          2: tempElement.ElemCompare:= tempI^.inf.Name;
          3: tempElement.ElemCompare:= tempI^.inf.Grams;
          4: tempElement.ElemCompare:= tempI^.inf.proteins;
          5: tempElement.ElemCompare:= tempI^.inf.Fats;
          6: tempElement.ElemCompare:= tempI^.inf.carbohydrates;
        end;
        if (index >= length(sortArr)) then setLength(sortArr, length(sortArr)*2);
        sortArr[index]:= tempElement;
        inc(index);
        tempI:= tempI^.adr;
      end;
    end;
    2:
    begin
      tempS:= HeadSalat^.adr;
      while (tempS <> nil) do begin
        tempElement.PElement:= tempS;
        case typeElement of
          1: tempElement.ElemCompare:= tempS^.inf.Index;
          2: tempElement.ElemCompare:= tempS^.inf.Name;
          3: tempElement.ElemCompare:= tempS^.inf.cost;
          4: tempElement.ElemCompare:= tempS^.inf.numOfIngredients;
        end;
        if (index >= length(sortArr)) then setLength(sortArr, length(sortArr)*2);
        sortArr[index]:= tempElement;
        inc(index);
        tempS:= tempS^.adr;
      end;
    end;
    3:
    begin
      tempO:= HeadOrder^.adr;
      while (tempO <> nil) do begin
        tempElement.PElement:= tempO;
        case typeElement of
          1: tempElement.ElemCompare:= PointSalat(tempO^.Index)^.inf.Name;
          2: tempElement.ElemCompare:= tempO^.amount;
          3: tempElement.ElemCompare:= tempO^.CadDo;
        end;
        if (index >= length(sortArr)) then setLength(sortArr, length(sortArr)*2);
        sortArr[index]:= tempElement;
        inc(index);
        tempO:= tempO^.adr;
      end;
    end;
  end;
  //обрезаем не нужную часть массива
  setLength(sortArr, index);
  //получаем отсортированный массив
  if (index = 0) then writeln('Список пустой!')
  else begin
    if (typeCompare = 1) then QuickSort(sortArr, compare1More2)
    else QuickSort(sortArr, compare1Less2);
    writeln('список отсортирован!');
  end;

  //return result of sort to list
  index:= 0;
  case typeList of
    1:
    begin
      tempI:= HeadIngredient;
      while (index < length(sortArr)) do begin
        tempI^.adr:= PIngredient(sortArr[index].PElement);
        inc(index);
        tempI:= tempI^.adr;
      end;
      tempI^.adr:= nil;
    end;
    2:
    begin
      tempS:= HeadSalat;
      while (index < length(sortArr)) do begin
        tempS^.adr:= PSalat(sortArr[index].PElement);
        inc(index);
        tempS:= tempS^.adr;
      end;
      tempS^.adr:= nil;
    end;
    3:
    begin
      tempO:= HeadOrder;
      while (index < length(sortArr)) do begin
        tempO^.adr:= POrder(sortArr[index].PElement);
        inc(index);
        tempO:= tempO^.adr;
      end;
      tempO^.adr:= nil;
    end;
  end;
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
