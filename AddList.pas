unit AddList;

interface

procedure AddIngredient();
procedure AddSalat;
procedure AddOrder;

implementation

uses Files, BasicFunction, WorkWithList;

procedure AddIngredient();
var
  tempI: PIngredient;
  strIn: string;
begin
  new(tempI);

  with tempI^.inf do begin
    inc(maxIngredient);
    Index:= maxIngredient;
    writeln('Введите название ингредиента: ');
    ReadRusStr(strIn);
    Name:= strIn;

    writeln('Введите код ингредиента заменителя или 0 если его нет: ');
    repeat
      change:= ReadInt(0, 9999); //а если введённого элемеента нету?
      if (PointIngr(change) = nil) and (change <> 0) then begin
        writeln('код ингредиента не найден! Повторите ввод: ');
      end;

    until (PointIngr(change) <> nil) or (change = 0);

    writeln('Введите количество ингредиена на складе в граммах: ');
    Grams:= ReadInt(0, 9999);
    writeln('Количество белков в этом продукте на 100г');
    proteins:= ReadInt(0, 100);
    writeln('Количество жиров в этом продукте на 100г');
    Fats:= ReadInt(0, 100);
    writeln('Количество углеводов в этом продукте на 100г');
    carbohydrates:= ReadInt(0, 100);
  end;


  //добавление в список
  tempI^.adr:= HeadIngredient^.adr;
  HeadIngredient^.adr:= tempI;
end;

procedure AddSalat;
var
    tempS: PSalat;
    strIn: string;
    stop: boolean;
begin
  new(tempS);

  with tempS^.inf do begin
    inc(MaxSalat);
    index:= MaxSalat;
    writeln('Введите название салата: ');
    ReadRusStr(strIn);
    Name:= strIn;
    writeln('Введите цену за салат в копейках: ');
    cost:= ReadInt(0, 9999);
    writeln('Введите количество игредиентов: ');
    repeat
      stop:= true;
      numOfIngredients:= ReadInt(1, MaxIngredientOfSalat+1);
      if (numOfIngredients > NumOfIngr()) then begin
        writeln('на складе количество различных ингредиентов меньше, повторите ввод');
        writeln('различных ингредиентов: ', NumOfIngr());
        stop:= false;
      end;
    until stop;
    for var i := 1 to numOfIngredients do begin
      writeln('Введите индекс игредиента ',i ,': ' );
      repeat
        stop:= true;

        ingredients[i-1].Index:= ReadInt(0, 9999); //а если введённого элемеента нету?
        if (PointIngr(ingredients[i-1].Index) = nil) then begin
          writeln('не найден код ингредиента, повторите ввод');
          stop:= false;
        end
        else begin
          for var j := 0 to i-2 do begin
            if (ingredients[i-1].Index = ingredients[j].Index) then begin
              writeln('этот код ингредиента уже был введён. Повторите ввод');
              stop:= false;
            end;
          end;
        end;
      until stop;
      writeln('Введите нужное количество грамм для ингредиента ',i ,': ' );
      tempS^.inf.ingredients[i-1].Grams:= ReadInt(0, 200);
    end;
  end;



  tempS^.adr:= headSalat^.adr;
  headSalat^.adr:= tempS;
end;

procedure AddOrder;
var
    tempO: POrder;
    str: string;
    stop: boolean;
begin
  new(tempO);

  writeln('Введите индекс салата: ' );
  repeat
    stop:= true;
    tempO^.Index:= ReadInt(0, 9999); //а если введённого элемеента нету?
    if (PointSalat(tempO^.Index) = nil) then begin
      writeln('не найден код салата, повторите ввод');
      stop:= false;
    end;
    if (PointOrderPre(tempO^.Index) <> nil) then begin
      writeln('данный салат уже добавлен, повторите ввод');
      stop:= false;
    end;

  until stop;

  writeln('Введите количество порций этого салата: ');
  tempO^.amount:= ReadInt(1, 999);
  tempO^.CadDo:= false;
  {tempO^.CadDo:= canCook(tempO^.Index, tempO^.amount);
  if (tempO^.CadDo = true) then begin
    write('салат может быть приготовлен');
    subIngr(tempO^.Index, tempO^.amount);
  end
  else write('салат НЕ может быть приготовлен');}

  tempO^.adr:= headOrder^.adr;
  HeadOrder^.adr:= tempO;
end;

end.
