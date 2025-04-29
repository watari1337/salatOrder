unit PrintList;

interface

uses Files;

procedure printIngredients;
procedure printSalat;
procedure printOrder;
procedure Print1I(tempI: PIngredient);
procedure Print1S(tempS: PSalat);
procedure Print1O(tempO: POrder);
procedure PrintTitle(listNum: integer);

implementation

uses SysUtils, WorkWithList;

procedure Print1I(tempI: PIngredient);
begin
  Writeln(Format('%4-d  %20-s %14d %6d   %3d/%2d/%2d', [
  tempI^.inf.Index, tempI^.inf.Name, tempI^.inf.change, tempI^.inf.Grams,
  tempI^.inf.proteins, tempI^.inf.Fats, tempI^.inf.carbohydrates
  ]));
end;

procedure Print1S(tempS: PSalat);
begin
  Write(Format('%4-d  %6-d %20-s ', [
  tempS^.inf.index, tempS^.inf.cost, tempS^.inf.Name
  ]));
  for var i := 1 to tempS^.inf.numOfIngredients do begin
    write(Format('%4d  %4d',
    [tempS^.inf.ingredients[i-1].Index, tempS^.inf.ingredients[i-1].Grams]));
    writeln;
    if (i <> tempS^.inf.numOfIngredients) then  //в последний раз сдвиг не нужен
    write('                                  ');   //красивое форматировние в столбец
  end;
end;

procedure Print1O(tempO: POrder);
var
  strOut: string;
begin
  if (tempO^.CadDo) then strOut:= 'приготовим'
  else strOut:= 'не приготовим';
  Writeln(Format('     %4-d    %20-s       %12-d   %20-s', [
  tempO^.Index, PointSalat(tempO^.Index)^.inf.Name, tempO^.amount, strOut
  ]));
end;

procedure PrintTitle(listNum: integer);
begin
  case listNum of
    1: writeln('код   ингредиент           код заменителя   грамм   Б/Ж/У');
    2: writeln('код   цена   салат           ингредиент   грамм');
    3: writeln('код салата   название            кол-во салатов     возможность приготовить');
  end;

end;

//передаётся head выводит все элементы
procedure printIngredients({head: PIngredient});
var
  tempI: PIngredient;
begin
  tempI:= HeadIngredient;
  if (tempI^.adr = nil) then Writeln('список ингредиентов пустой')
  else begin
    writeln;
    PrintTitle(1);
    While (tempI^.adr <> nil) do begin
      tempI:= tempI^.adr;
      Print1I(tempI);
    end;
  end;
end;

procedure printSalat;
var
    tempS: PSalat;
begin
  tempS:= HeadSalat;
  if (tempS^.adr = nil) then Writeln('список салатов пустой')
  else begin
    writeln;
    PrintTitle(2);
    While (tempS^.adr <> nil) do begin
      tempS:= tempS^.adr;
      Print1S(tempS);
    end;
  end;
end;

procedure printOrder;
var
  tempO: POrder;
begin
  tempO:= HeadOrder;
  if (tempO^.adr = nil) then Writeln('список салатов для банкета пустой')
  else begin
    writeln;
    PrintTitle(3);
    While (tempO^.adr <> nil) do begin
      tempO:= tempO^.adr;
      Print1O(tempO);
    end;
  end;
end;

end.
