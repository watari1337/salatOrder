unit SortAndFind;

interface

procedure SortListQ(typeList, typeElement, typeCompare: integer);

implementation

uses Files, BasicFunction, WorkWithList;

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
        tempI^.adr:= sortArr[index].PElement;
        inc(index);
        tempI:= tempI^.adr;
      end;
      tempI^.adr:= nil;
    end;
    2:
    begin
      tempS:= HeadSalat;
      while (index < length(sortArr)) do begin
        tempS^.adr:= sortArr[index].PElement;
        inc(index);
        tempS:= tempS^.adr;
      end;
      tempS^.adr:= nil;
    end;
    3:
    begin
      tempO:= HeadOrder;
      while (index < length(sortArr)) do begin
        tempO^.adr:= sortArr[index].PElement;
        inc(index);
        tempO:= tempO^.adr;
      end;
      tempO^.adr:= nil;
    end;
  end;
end;

end.
