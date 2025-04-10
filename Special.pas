unit Special;

interface

procedure chekAndInfo();

implementation

uses Files, WorkWithList, System.SysUtils, LoadMenu;


//проверяет возможность прикотовить салат по рецепту indexS и в количестве amount
//из ингредеиентов со склада
//true, елси можно приготовить
function canCook(const indexS, amount: integer; var myCost: integer): boolean;
type
  TPair = Record
    point: PIngredient;
    Grams: integer;
  end;

var
  salat: PSalat;
  ingr, changeIngr, notEnough: PIngredient;
  enough, changers: boolean;
  i, weightNow, notEnoughGram: integer;
  procent, proteins, fats, carbohydrates: double;
  Neads: array of TPair;

begin
  enough:= true;
  changers:= false;
  proteins:= 0;
  fats:= 0;
  carbohydrates:= 0;

  salat:= PointSalat(indexS);
  //в рецептах 1-го салата точно не повторяются ингредиенты
  with Salat^.inf do begin
    SetLength(Neads, numOfIngredients*2);
    {записываем ингредиент и сколько использовали, затем заменитель этого
    ингредиента и сколько использовали, если хватает в моменте то отнимаем из
    базы данных ингредиента}
    i:= 0;
    While (i < numOfIngredients) and (enough) do begin
      ingr:= PointIngr(ingredients[i].Index);
      weightNow:= ingredients[i].Grams * amount;
      if (weightNow > ingr.inf.Grams) then begin
        if (ingr.inf.change <> 0) then begin  //есть заменитель
          changeIngr:= PointIngr(ingr.inf.change);
          if ((ingredients[i].Grams * amount) > (changeIngr.inf.Grams + ingr.inf.Grams)) then begin
            enough:= false;
            notEnough:= ingr;
            notEnoughGram:= weightNow;
          end
          else begin
            changers:= true;

            Neads[i*2+1].point:= changeIngr;
            Neads[i*2+1].Grams:= weightNow - ingr^.inf.Grams;
            dec(changeIngr^.inf.Grams, (weightNow - ingr^.inf.Grams));

            procent:= (changeIngr^.inf.Grams) / (weightNow * 100);
            proteins:= proteins + changeIngr^.inf.proteins * procent;
            fats:= fats + changeIngr^.inf.fats * procent;
            carbohydrates:= carbohydrates + changeIngr^.inf.carbohydrates * procent;

            Neads[i*2].point:= ingr;
            Neads[i*2].Grams:= ingr^.inf.Grams;
            ingr^.inf.Grams:= 0;

            procent:= ingr^.inf.Grams / (weightNow * 100);
            proteins:= proteins + ingr^.inf.proteins * procent;
            fats:= fats + ingr^.inf.fats * procent;
            carbohydrates:= carbohydrates + ingr^.inf.carbohydrates * procent;
          end;
        end
        else enough:= false; //заменителя нет
      end
      else begin
        Neads[i*2].point:= ingr;
        Neads[i*2].Grams:= weightNow;
        dec(ingr^.inf.Grams, weightNow);
        procent:= ingredients[i].Grams / (100);
        proteins:= proteins + ingr^.inf.proteins * procent;
        fats:= fats + ingr^.inf.fats * procent;
        carbohydrates:= carbohydrates + ingr^.inf.carbohydrates * procent;

        Neads[i*2+1].point:= nil;
        Neads[i*2+1].Grams:= 0;
      end;
      inc(i);
    end;
    Writeln('Салат ', salat.inf.Name);
    if (enough) then begin
      inc(myCost, cost*amount);
      //хватило, выводим заменители
      if (changers) then begin
        //Writeln('В салате ', salat.inf.Name);
        for i:= 0 to numOfIngredients-1 do begin
          ingr:= Neads[i*2].point;
          changeIngr:= Neads[i*2+1].point;
          if (changeIngr <> nil) then begin
            writeln(Format('ингредиент %s был заменён на %s, в количестве %d грамм',
            [ingr.inf.Name, changeIngr.inf.Name, changeIngr.inf.Grams]));
          end;
        end;
      end;
      //Выводим Б/Ж/У
      proteins:= Round(proteins);
      fats:= Round(fats);
      carbohydrates:= Round(carbohydrates);
      writeln(Format('БЖУ для данного салата на 100г %.0f/%.0f/%.0f',
      [proteins, fats, carbohydrates]));
    end
    else begin
      Writeln(Format('Нельзя приготовить этот салат, нехваатет ингредиента "%s" в количество %d грамм.',
      [notEnough^.inf.Name, notEnoughGram]));
      //не хватило, возращаем то что отнимали
      dec(i, 2);
      for var j := i downto 0 do begin
        ingr:= Neads[j*2].point;
        changeIngr:= Neads[j*2+1].point;
        inc(ingr^.inf.Grams, Neads[j*2].Grams);
        inc(changeIngr^.inf.Grams, Neads[j*2+1].Grams);
      end;
    end;
    result:= enough;
  end;
end;

procedure chekAndInfo();
var
  tempO: POrder;
  cost: integer;
begin
  ClearScreen;

  cost:= 0;
  tempO:= HeadOrder;
  while (tempO^.adr <> nil) do begin
    tempO:= tempO^.adr;
    tempO.CadDo:= canCook(tempO.Index, tempO.amount, cost);
  end;
  Writeln;
  Writeln('Цена за салаты которые возможно приготовить: ', cost);

  readln;
  MainMenu;
end;

{по индексу салата и количеству салата удаляет из склада ингредиенты
затраченные на приготовление, допускаем что точно достаточно ингредиентов
procedure subIngr(indexS, amount: integer);
var
  salat: PSalat;
  ingr, changeIngr: PIngredient;
  changeGram: integer;
begin
  salat:= PointSalat(indexS);
  //в рецептах 1 салата точно не повторяются ингредиенты
  with Salat^.inf do begin
    for var i:= 1 to numOfIngredients do begin

      ingr:= PointIngr(ingredients[i].Index);
      if ((ingredients[i].Grams * amount) > ingr.inf.Grams) then begin
        //не хватает основного ингредиента
        changeGram:= (ingredients[i].Grams * amount) - ingr.inf.Grams;
        //заменителя точно хватает по условию
        changeIngr:= PointIngr(ingr.inf.change);
        dec(changeIngr.inf.Grams, changeGram);


      end
      else begin
        //хватает основного ингредиента
        dec(ingr.inf.Grams, ingredients[i].Grams * amount);
      end;
    end;
  end;
end;}

end.
