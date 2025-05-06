unit Special;

interface

procedure chekAndInfo();

implementation

uses Files, WorkWithList, System.SysUtils, LoadMenu;

var
  textFileOut: textFile;

//проверяет возможность прикотовить салат по рецепту indexS и в количестве amount
//из ингредеиентов со склада
//true, елси можно приготовить
function canCook(const indexS, amount: integer; var myCost: integer; var strOut: string): boolean;
type
  TPair = Record
    point: PIngredient;
    Grams: integer;
  end;

var
  salat: PSalat;
  ingr, changeIngr: PIngredient;
  enough, changers: boolean;
  i, weightNow, indexEnt: integer;
  procent, proteins, fats, carbohydrates: double;
  Neads: array of TPair;
  notEnough: array of TPair;

begin
  enough:= true;
  changers:= false;
  proteins:= 0;
  indexEnt:= 0;
  fats:= 0;
  carbohydrates:= 0;

  salat:= PointSalat(indexS);
  //в рецептах 1-го салата точно не повторяются ингредиенты
  with Salat^.inf do begin
    SetLength(Neads, numOfIngredients*2);
    SetLength(notEnough, numOfIngredients);
    {записываем ингредиент и сколько использовали, затем заменитель этого
    ингредиента и сколько использовали, если хватает в моменте то отнимаем из
    базы данных ингредиента}
    i:= 0;
    While (i < numOfIngredients) {and (enough)} do begin
      ingr:= PointIngr(ingredients[i].Index);
      weightNow:= ingredients[i].Grams * amount;
      if (weightNow > ingr.inf.Grams) then begin
        if (ingr.inf.change <> 0) then begin  //есть заменитель
          changeIngr:= PointIngr(ingr.inf.change);
          if ((ingredients[i].Grams * amount) > (changeIngr.inf.Grams + ingr.inf.Grams)) then begin
            enough:= false;
            notEnough[indexEnt].point:= ingr;
            notEnough[indexEnt].Grams:= weightNow;
            inc(indexEnt);
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
        else begin    //заменителя нет
          enough:= false;
          notEnough[indexEnt].point:= ingr;
          notEnough[indexEnt].Grams:= weightNow;
          inc(indexEnt);
        end;
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

    writeln;
    Writeln('Салат ', salat.inf.Name);
    writeln(textFileOut);
    Writeln(textFileOut, 'Салат ', salat.inf.Name);
    if (enough) then begin  //enought ingredients to cook
      writeln('Этот салат мы можем приготовить!'); {Ингредиенты для его приготовления вычтены из склада.}
      writeln(textFileOut, 'Этот салат мы можем приготовить!');
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
            writeln(textFileOut, Format('ингредиент %s был заменён на %s, в количестве %d грамм',
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
      writeln(textFileOut, Format('БЖУ для данного салата на 100г %.0f/%.0f/%.0f',
      [proteins, fats, carbohydrates]));
    end
    else begin //cant cook not enought ingr
      for var k:= indexEnt-1 downto 0 do begin
        Writeln(Format('Нельзя приготовить этот салат, не хватает ингредиента "%s", его должно быть %d грамм.',
        [notEnough[k].point^.inf.Name, notEnough[k].Grams]));
        Writeln(textFileOut, Format('Нельзя приготовить этот салат, не хватает ингредиента "%s", его должно быть %d грамм.',
        [notEnough[k].point^.inf.Name, notEnough[k].Grams]));
      end;
      //не хватило, возращаем то что отнимали
      {dec(i, 2);
      for var j := i downto 0 do begin
        ingr:= Neads[j*2].point;
        changeIngr:= Neads[j*2+1].point;
        inc(ingr^.inf.Grams, Neads[j*2].Grams);
        if (changeIngr <> nil) then inc(changeIngr^.inf.Grams, Neads[j*2+1].Grams);
      end;}
      for i:= 0 to numOfIngredients-1 do begin
        ingr:= Neads[i*2].point;
        changeIngr:= Neads[i*2+1].point;
        if (ingr <> nil) then inc(ingr^.inf.Grams, Neads[i*2].Grams);
        if (changeIngr <> nil) then inc(changeIngr^.inf.Grams, Neads[i*2+1].Grams);
      end;
    end;
    result:= enough;
  end;
end;

{procedure printOutStr(str: string);
begin
  for var i:= 1 to length(str) do begin
    if (str[i] = '%') then writeln
    else write(str[i]);
  end;
end;}

procedure chekAndInfo();
const
  adrText = 'Data\Bell.txt';
var
  tempO: POrder;
  cost, index: integer;
  arrIngr: Array of integer;
  tempI: PIngredient;
  strOut: string;
begin
  try
    ClearScreen;

    //open TextFile
    assignFile(textFileOut, adrText);
    ReWrite(textFileOut);

    //remember all ingredients in base
    index:= 0;
    setLength(arrIngr, 20);
    tempI:= HeadIngredient^.adr;
    while (tempI <> nil) do begin
      if (index >= length(arrIngr)) then setLength(arrIngr, length(arrIngr)*2);
      arrIngr[index]:= tempI^.inf.Grams;
      inc(index);
      tempI:= tempI^.adr;
    end;
    setLength(arrIngr, index);

    cost:= 0;
    tempO:= HeadOrder;
    while (tempO^.adr <> nil) do begin
      tempO:= tempO^.adr;
      //if (tempO.CadDo = false) then
      tempO.CadDo:= canCook(tempO.Index, tempO.amount, cost, strOut);
    end;

    //return ingr grams
    tempI:= HeadIngredient^.adr;
    index:= 0;
    while (tempI <> nil) do begin
      tempI^.inf.Grams:= arrIngr[index];
      inc(index);
      tempI:= tempI^.adr;
    end;

    Writeln;
    Writeln('Цена за салаты которые возможно приготовить: ', cost);
    Writeln(textFileOut);
    Writeln(textFileOut, 'Цена за салаты которые возможно приготовить: ', cost);
    {strOut:= strOut + '%' + 'Цена за салаты которые возможно приготовить: ' + intTostr(cost);
    printOutStr(str);}

    readln;
  finally
    //close
    CloseFile(textFileOut);
  end;

end;


{procedure makeFileSpecial(str: string);
begin

end;}

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
