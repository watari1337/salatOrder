unit WorkWithList;

interface

uses Files;

function NumOfIngr(): integer;
function PointIngr(index: integer): PIngredient;
function PointIngrPre(index: integer): PIngredient;
function PointNameIngr(name: string): ArrIngr;

function NumOfSalat(): integer;
function PointSalat(index: integer): PSalat;
function PointSalatPre(index: integer): PSalat;
function PointNameSalat(name: string): ArrSalat;
function FindIngrInSalat(tempI: PIngredient): arrSalat;

function NumOfOrder(): integer;
function PointOrder(codeSalat: integer): POrder;
function PointOrderPre(codeSalat: integer): POrder;


implementation

uses BasicFunction, System.SysUtils, Dialogs;

//считает число различных ингредиентов
function NumOfIngr(): integer;
var
  tempI: PIngredient;
begin
  result:= 0;
  tempI:= HeadIngredient;
  while (tempI^.adr <> nil) do begin
    tempI:= tempI^.adr;
    inc(result);
  end;
end;

//находит указатель на элемент ингредиента по индексу, nil если нет элемента
function PointIngr(index: integer): PIngredient;
var
  tempI: PIngredient;
  stop: boolean;
begin
  result:= nil;
  tempI:= HeadIngredient;
  stop:= false;
  while (tempI^.adr <> nil) and (stop = false) do begin
    tempI:= tempI^.adr;
    if (tempI^.inf.Index = index) then begin
      result:= tempI;
      stop:= true;
    end;
  end;
end;

//находит указатель на предыдущий элемент ингредиента по индексу, nil если нет элемента
function PointIngrPre(index: integer): PIngredient;
var
  tempI, preTempI: PIngredient;
  stop: boolean;
begin
  result:= nil;
  tempI:= HeadIngredient;
  stop:= false;
  while (tempI^.adr <> nil) and (stop = false) do begin
    preTempI:= tempI;
    tempI:= tempI^.adr;
    if (tempI^.inf.Index = index) then begin
      result:= preTempI;
      stop:= true;
    end;
  end;
end;

//находит массив указателей указатель на элемент ингредиента по имени, nil если нет элемента
function PointNameIngr(name: string): ArrIngr;
var
  tempI: PIngredient;
  index: integer;
begin
  SetLength(result, 1);
  index:= 0;
  result[index]:= nil;
  tempI:= HeadIngredient;
  while (tempI^.adr <> nil) do begin
    tempI:= tempI^.adr;
    if (tempI^.inf.Name = name) then begin
      if (index >= Length(result)) then SetLength(result, Length(result)*2);
      result[index]:= tempI;
      inc(index);
    end;
  end;
  if (result[0] = nil) then result:= nil;
end;

//считает число различных ингредиентов
function NumOfSalat(): integer;
var
  tempS: PSalat;
begin
  result:= 0;
  tempS:= HeadSalat;
  while (tempS^.adr <> nil) do begin
    tempS:= tempS^.adr;
    inc(result);
  end;
end;

//находит указатель на салат по индексу, nil если нет элемента
function PointSalat(index: integer): PSalat;
var
  tempS: PSalat;
  stop: boolean;
begin
  result:= nil;
  tempS:= HeadSalat;
  stop:= false;
  while (tempS^.adr <> nil) and (stop = false) do begin
    tempS:= tempS^.adr;
    if (tempS^.inf.Index = index) then begin
      result:= tempS;
      stop:= true;
    end;
  end;
end;

function PointSalatPre(index: integer): PSalat;
var
  tempS, preS: PSalat;
  stop: boolean;
begin
  result:= nil;
  tempS:= HeadSalat;
  stop:= false;
  while (tempS^.adr <> nil) and (stop = false) do begin
    preS:= tempS;
    tempS:= tempS^.adr;
    if (tempS^.inf.Index = index) then begin
      result:= preS;
      stop:= true;
    end;
  end;
end;

//находит массив указателей указатель на салат по имени, nil если нет элемента
function PointNameSalat(name: string): ArrSalat;
var
  tempS: PSalat;
  index: integer;
begin
  SetLength(result, 1);
  index:= 0;
  result[index]:= nil;
  tempS:= HeadSalat;
  while (tempS^.adr <> nil) do begin
    tempS:= tempS^.adr;
    if (tempS^.inf.Name = name) then begin
      if (index >= Length(result)) then SetLength(result, Length(result)*2);
      result[index]:= tempS;
      inc(index);
    end;
  end;
  if (result[0] = nil) then result:= nil;
end;

{возвращает массив указателей на салаты в которых содержится указанный
ингредиент, передаётся адрес ингредиента, nil если нет элементов}
function FindIngrInSalat(tempI: PIngredient): arrSalat;
var
  tempS: PSalat;
  index: integer;
begin
  SetLength(result, 1);
  index:= 0;
  result[index]:= nil;
  tempS:= HeadSalat;
  while (tempS^.adr <> nil) do begin
    tempS:= tempS^.adr;
      for var i := 1 to tempS^.inf.numOfIngredients do begin
        if tempS^.inf.ingredients[i-1].Index = tempI^.inf.Index then begin
          if (index >= Length(result)) then SetLength(result, Length(result)*2);
          result[index]:= tempS;
          inc(index);
          //можно break так как в салате все ингредиенты различны
        end;
      end;
  end;
  if (result[0] = nil) then result:= nil;
end;

//считает число различных ингредиентов
function NumOfOrder(): integer;
var
  tempO: POrder;
begin
  result:= 0;
  tempO:= HeadOrder;
  while (tempO^.adr <> nil) do begin
    tempO:= tempO^.adr;
    inc(result);
  end;
end;

{возвращает указатель на салат в заказе, передаётся код салата, nil если нет элементов}
function PointOrder(codeSalat: integer): POrder;
var
  tempO: POrder;
  stop: boolean;
begin
  result:= nil;
  tempO:= HeadOrder;
  stop:= false;
  while (tempO^.adr <> nil) and (stop = false) do begin
    tempO:= tempO^.adr;
    if (tempO^.Index = codeSalat) then begin
      result:= tempO;
      stop:= true;
    end;
  end;
end;

{возвращает указатель на салат в заказе перед нужным, передаётся код салата, nil если нет элементов}
function PointOrderPre(codeSalat: integer): POrder;
var
  tempO, preO: POrder;
  stop: boolean;
begin
  result:= nil;
  tempO:= HeadOrder;
  stop:= false;
  while (tempO^.adr <> nil) and (stop = false) do begin
    preO:= tempO;
    tempO:= tempO^.adr;
    if (tempO^.Index = codeSalat) then begin
      result:= preO;
      stop:= true;
    end;
  end;
end;

end.
