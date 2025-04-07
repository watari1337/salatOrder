unit PrintList;

interface

procedure printIngredients;
procedure printSalat;
procedure printOrder;

implementation

uses Files, SysUtils;

procedure printIngredients;
var
  tempI: PIngredient;
begin
  tempI:= HeadIngredient;
  if (tempI^.adr = nil) then Writeln('список ингредиентов пустой')
  else begin
    writeln;
    writeln('код   ингредиент           код заменителя   грам   Б/Ж/У');
    While (tempI^.adr <> nil) do begin
      tempI:= tempI^.adr;
      Writeln(Format('%4-d  %20-s %14d %6d  %3d/%2d/%2d', [
      tempI^.inf.Index, tempI^.inf.Name, tempI^.inf.change, tempI^.inf.Grams,
      tempI^.inf.proteins, tempI^.inf.Fats, tempI^.inf.carbohydrates
      ]));
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
    writeln('код   салат           ингредиент   грам');
    While (tempS^.adr <> nil) do begin
      tempS:= tempS^.adr;
      Write(Format('%4-d  %20-s ', [
      tempS^.inf.index, tempS^.inf.Name
      ]));
      for var i := 1 to tempS^.inf.numOfIngredients do begin
        write(Format('%4d  %4d',
        [tempS^.inf.ingredients[i-1].Index, tempS^.inf.ingredients[i-1].Grams]));
        writeln;
        if (i <> tempS^.inf.numOfIngredients) then  //в последний раз сдвиг не нужен
        write('                           ');   //красивое форматировние в столбец
      end;
    end;
  end;
end;

procedure printOrder;
var
  tempO: POrder;
  strOut: string;
begin
  tempO:= HeadOrder;
  if (tempO^.adr = nil) then Writeln('список салатов для банкета пустой')
  else begin
    writeln;
    writeln('код салата   кол-во салатов     возможность приготовить');
    While (tempO^.adr <> nil) do begin
      tempO:= tempO^.adr;
      if (tempO^.CadDo) then strOut:= 'приготовим'
      else strOut:= 'не приготовим';
      Writeln(Format('     %4-d           %12-d   %20-s', [
      tempO^.Index, tempO^.amount, strOut
      ]));
    end;
  end;
end;

end.
