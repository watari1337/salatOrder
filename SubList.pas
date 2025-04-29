unit SubList;

interface

procedure SubIngr();
procedure SubSalat();
procedure SubOrder();

procedure editIngr();
procedure editSalat();
procedure editOrder();

implementation

uses BasicFunction, LoadMenu, WorkWithList, Files, SysUtils;

//temp указатель на предыдущий элемент перед del, del выбраный пользователем элемент
procedure FindIngr(var tempI, delI: Pingredient);
var
  myArrIngr: ArrIngr;
  valueInput, i: integer;
  str: string;
begin
  tempI:= nil;
  delI:= nil;
  ClearScreen;
  writeln('0. Вернуться назад');
  writeln('1. Выбрать ингредиент по имени');
  writeln('2. Выбрать ингредиент по индексу');

  valueInput:= BasicFunction.ReadInt(0, 2);
  ClearScreen;

  //выбор элемента и его адрес в delI, адрес предшествующего в tempI
  case valueInput of
    0: MainMenu;
    1:
    begin
      Writeln('Введите имя ингредиента: ');
      ReadRusStr(str);
      myArrIngr:= PointNameIngr(str);
      if (myArrIngr = nil) then writeln('Ингредиент не найден')
      else if (Length(myArrIngr) = 1) then begin
        delI:= myArrIngr[0];
        tempI:= PointIngrPre(delI^.inf.Index);
      end
      else begin
        i:= 0;
        writeln('Было найдено несколько вариантов, выберите нужный:');
        writeln('    код   ингредиент           код заменителя   грам   Б/Ж/У');
        while (i < Length(myArrIngr)) and (myArrIngr[i] <> nil) do begin
          tempI:= myArrIngr[i];
          Writeln(Format('%2d. %4-d  %20-s %14d %6d  %3d/%2d/%2d', [
          i, tempI^.inf.Index, tempI^.inf.Name, tempI^.inf.change, tempI^.inf.Grams,
          tempI^.inf.proteins, tempI^.inf.Fats, tempI^.inf.carbohydrates
          ]));
          inc(i);
        end;
        valueInput:= BasicFunction.ReadInt(0, i-1);
        delI:= myArrIngr[valueInput];
        tempI:= PointIngrPre(delI^.inf.Index);
      end;
    end;
    2:
    begin
      Writeln('Введите код ингредиента: ');
      valueInput:= BasicFunction.ReadInt(0, 9999);
      tempI:= PointIngrPre(valueInput);
      if (tempI = nil) then writeln('Ингредиент не найден')
      else begin
        delI:= tempI^.adr;
      end;
    end;
  end;
end;

procedure SubIngr();
var
  valueInput, i: integer;
  Salats: ArrSalat;
  tempI, delI: Pingredient;
  tempS, delS: PSalat;
  flag: boolean;
begin
   FindIngr(tempI, delI);
  //удаление
  if (tempI <> nil) and (delI <> nil) then begin
    Salats:= FindIngrInSalat(delI);
    if (Salats = nil) then begin
      tempI^.adr:= tempI^.adr^.adr;
      //удаление заменителей
      tempI:= HeadIngredient;
      while (tempI^.adr <> nil) do begin
        tempI:= tempI^.adr;
        if (tempI^.inf.change = delI^.inf.Index) then tempI^.inf.change:= 0;
      end;

      dispose(delI);
      writeln('Ингредиент удалён');
    end
    else begin
      //выводим салты
      Writeln('Данный ингредиент содержится в данных салатах:');
      writeln('код   салат           ингредиент   грам');
      i:= 0;
      while (i < Length(Salats)) and (Salats[i] <> nil) do begin
        tempS:= Salats[i];
        Write(Format('%4-d  %20-s ', [
        tempS^.inf.index, tempS^.inf.Name
        ]));
        for var k := 1 to tempS^.inf.numOfIngredients do begin
          write(Format('%4d  %4d',
          [tempS^.inf.ingredients[k-1].Index, tempS^.inf.ingredients[k-1].Grams]));
          writeln;
          if (k <> tempS^.inf.numOfIngredients) then  //в последний раз сдвиг не нужен
          write('                           ');   //красивое форматировние в столбец
        end;
        inc(i);
      end;
      writeln('Удалить ингредиент а так же удалить его из рецептов?');
      writeln('в случае если после удаления в салате не останется ингредиентов, то запись салата удалится');
      writeln('0 - не удалять, 1 - всё равно удалить');
      valueInput:= BasicFunction.ReadInt(0, 1);
      //не удалять -- просто заканчиввается функция
      if (valueInput = 1) then begin
        i:= 0;
        while (i < Length(Salats)) and (Salats[i] <> nil) do begin
          delS:= Salats[i];
          if (delS^.inf.numOfIngredients = 1) then begin
            tempS:= pointSalatPre(delS^.inf.index);
            tempS^.adr:= delS^.adr^.adr;
            dispose(delS);
          end
          else begin
            flag:= false;
            for var k:= 1 to delS^.inf.numOfIngredients-1 do begin
              if (delS^.inf.ingredients[k-1].Index = delI.inf.Index) then begin
                flag:= true;
              end;
              if (flag) then 
              delS^.inf.ingredients[k-1].Index:= delS^.inf.ingredients[k].Index;
            end;
            dec(delS^.inf.numOfIngredients);
          end;
          inc(i);
        end;
        //удаление ингредиента из базы
        tempI^.adr:= tempI^.adr^.adr;
        //удаление заменителей
        tempI:= HeadIngredient;
        while (tempI^.adr <> nil) do begin
          tempI:= tempI^.adr;
          if (tempI^.inf.change = delI^.inf.Index) then tempI^.inf.change:= 0;        
        end;
        
        dispose(delI);
        writeln('Ингредиент удалён');
      end;
    end;
  end;
end;



//temp указатель на предыдущий элемент перед del, del выбраный пользователем элемент
procedure FindSalat(var tempS, delS: PSalat);
var
  valueInput, i: integer;
  Salats: ArrSalat;
  str: string;
begin
  tempS:= nil;
  delS:= nil;
  ClearScreen;
  writeln('0. Вернуться назад');                              //элемент для удаления
  writeln('1. Выбрать элемент по имени');        //салат для удаления из заказа
  writeln('2. Выбрать элемент по индексу');      //салат

  valueInput:= BasicFunction.ReadInt(0, 2);
  ClearScreen;

  //выбор элемента и его адрес в delS, адрес предшествующего в tempS
  case valueInput of
    0: MainMenu;
    1:
    begin
      Writeln('Введите имя салата: ');
      ReadRusStr(str);
      Salats:= PointNameSalat(str);
      if (Salats = nil) then writeln('Салат не найден')
      else if (Length(Salats) = 1) then begin
        delS:= Salats[0];
        tempS:= PointSalatPre(delS^.inf.Index);
      end
      else begin
        i:= 0;
        writeln('Было найдено несколько вариантов, выберите нужный:');
        writeln('    код   цена   салат           ингредиент   грам');
        while (i < Length(Salats)) and (Salats[i] <> nil) do begin
          tempS:= Salats[i];
          Write(Format('%2d. %4-d  %6-d %20-s ',
          [i, tempS^.inf.index, tempS^.inf.cost, tempS^.inf.Name
          ]));
          for var k := 1 to tempS^.inf.numOfIngredients do begin
            write(Format('%4d  %4d',
            [tempS^.inf.ingredients[k-1].Index, tempS^.inf.ingredients[k-1].Grams]));
            writeln;
            if (k <> tempS^.inf.numOfIngredients) then  //в последний раз сдвиг не нужен
            write('                                      ');   //красивое форматировние в столбец
          end;
          inc(i);
        end;
        valueInput:= BasicFunction.ReadInt(0, i-1);
        delS:= Salats[valueInput];
        tempS:= PointSalatPre(delS^.inf.Index);
      end;
    end;
    2:
    begin
      Writeln('Введите код салата: ');
      valueInput:= BasicFunction.ReadInt(0, 9999);
      tempS:= PointSalatPre(valueInput);
      if (tempS = nil) then writeln('Салат не найден')
      else begin
        delS:= tempS^.adr;
      end;
    end;
  end;
end;

procedure SubSalat();
var
  valueInput, i: integer;
  tempS, delS: PSalat;
  tempO, delO: POrder;
  flag: boolean;
begin
  FindSalat(tempS, delS);
  //удаление
  if (tempS <> nil) and (delS <> nil) then begin
    tempO:= PointOrderPre(delS^.inf.index);
    if (tempO = nil) then begin
      tempS^.adr:= tempS^.adr^.adr;
      dispose(delS);
      writeln('Салат удалён');
    end
    else begin
      delO:= tempO^.adr;
      //выводим
      Write(Format('Данный салат содержится в заказе, заказали порций: %4-d ', 
      [delO^.amount]));
      if (delO^.CadDo) then begin
        Writeln('этот салат можно приготовить.');
      end
      else begin
        Writeln('этот салат невозможно приготовить.');
      end;
      writeln('Удалить салат а так же удалить его из заказа?');
      writeln('0 - не удалять, 1 - всё равно удалить');
      valueInput:= BasicFunction.ReadInt(0, 1);
      //не удалять -- просто заканчиввается функция
      if (valueInput = 1) then begin
        tempO^.adr:= tempO^.adr^.adr;
        dispose(delO);
        
        tempS^.adr:= tempS^.adr^.adr;
        dispose(delS);
        writeln('Салат удалён');
      end;
    end;
  end;
end;



procedure SubOrder();
var
  valueInput, i: integer;
  str: string;
  Salats: ArrSalat;
  tempS, delS: PSalat;
  tempO, delO: POrder;
  flag: boolean;
begin
  FindSalat(tempS, delS);
  //удаление
  if (tempS <> nil) and (delS <> nil) then begin
    tempO:= PointOrderPre(delS^.inf.index);
    if (tempO = nil) then begin
      writeln('Салат не найден в заказах');
    end
    else begin
      delO:= tempO^.adr;
      tempO^.adr:= tempO^.adr^.adr;
      dispose(delO);
    end;
  end;
end;





procedure editIngr();
var
  valueInput: integer;
  tempI, delI: Pingredient;
  strIn: string;
  stop: boolean;
begin
  repeat
    stop:= true;
    FindIngr(tempI, delI);
    if (tempI = nil) or (delI = nil) then begin
      Writeln('Хотите изменить другой ингредиент? 0 - нет; 1 - да');
      valueInput:= BasicFunction.ReadInt(0, 1);
      if (valueInput = 1) then stop:= false;
    end;
  until stop;

  if (tempI <> nil) and (delI <> nil) then begin
    repeat
      with delI^.inf do begin
        ClearScreen;
        Writeln('0. Выйти в меню');
        Writeln('1. Изменить выбранный ингредиент');
        Writeln('2. Изменить имя ингредиента');
        Writeln('3. Изменить заменитель для ингредиента');
        Writeln('4. Изменить количество ингредиента на складе');
        Writeln('5. Изменить БЖУ');
        Writeln;
        writeln('код   ингредиент           код заменителя   грам   Б/Ж/У');
        Writeln(Format('%4-d  %20-s %14d %6d  %3d/%2d/%2d',
        [Index, Name, change, Grams, proteins, Fats, carbohydrates]));

        valueInput:= BasicFunction.ReadInt(0, 5);

        case valueInput of
          0: MainMenu;
          1: FindIngr(tempI, delI);
          2:
          begin
            writeln('Введите название ингредиента: ');
            ReadRusStr(strIn);
            Name:= strIn;
          end;
          3:
          begin
            writeln('Введите код ингредиента заменителя или 0 если его нет: ');
            repeat
              change:= ReadInt(0, 9999); //а если введённого элемеента нету?
              if (PointIngr(change) = nil) and (change <> 0) then begin
                writeln('код ингредиента не найден! Повторите ввод: ');
              end;

            until (PointIngr(change) <> nil) or (change = 0);
          end;
          4:
          begin
            writeln('Введите количество ингредиена на складе в граммах: ');
            Grams:= ReadInt(0, 999999);
          end;
          5:
          begin
            writeln('Количество белков в этом продукте на 100г');
            proteins:= ReadInt(0, 100);
            writeln('Количество жиров в этом продукте на 100г');
            Fats:= ReadInt(0, 100);
            writeln('Количество углеводов в этом продукте на 100г');
            carbohydrates:= ReadInt(0, 100);
          end;
        end;
      end;
    until valueInput = 0;
  end;
end;

procedure chooseSalat(var tempS, delS: PSalat; var valueInput: integer);
var
  stop: boolean;
begin
  repeat
    stop:= true;
    FindSalat(tempS, delS);
    if (tempS = nil) or (delS = nil) then begin
      Writeln('Хотите изменить другой салат? 0 - нет; 1 - да');
      valueInput:= BasicFunction.ReadInt(0, 1);
      if (valueInput = 1) then stop:= false;
    end;
  until stop;
end;

procedure editSalat();
var
  valueInput, valueInput2: integer;
  strIn: string;
  tempS, delS: PSalat;
  stop: boolean;
begin
  chooseSalat(tempS, delS, valueInput);

  if (tempS <> nil) and (delS <> nil) then begin
    repeat
      with delS^.inf do begin
        ClearScreen;
        Writeln('0. Выйти в меню');
        Writeln('1. Изменить выбранный салат');
        Writeln('2. Изменить имя салата');
        Writeln('3. Изменить цену салата');
        Writeln('4. Добавить ингредиент в рецепт');
        Writeln('5. Удалить ингредиент из рецепта');
        //Writeln('6. Изменить ингредиент в рецепте');
        writeln;
        writeln('код   цена   салат           ингредиент   грам   номер ингредиента в рецепте');
        Write(Format('%4-d  %6-d %20-s ',[index, Cost, Name]));
        for var k := 1 to numOfIngredients do begin
          write(Format('%4d  %4d        %8-d',
          [ingredients[k-1].Index, ingredients[k-1].Grams, (k-1) ]));
          writeln;
          if (k <> numOfIngredients) then  //в последний раз сдвиг не нужен
          write('                                  ');   //красивое форматировние в столбец
        end;

        valueInput:= BasicFunction.ReadInt(0, 5);

        case valueInput of
          0: MainMenu;
          1: chooseSalat(tempS, delS, valueInput);
          2:
          begin
            writeln('Введите название салата: ');
            ReadRusStr(strIn);
            Name:= strIn;
          end;
          3:
          begin
            writeln('Введите цену за салат в копейках: ');
            cost:= ReadInt(0, 9999);
          end;
          4:
          begin
            if (numOfIngredients > MaxIngredientOfSalat) then begin     //от 0 до MaxIngredientOfSalat
              Writeln('рецеп салата не может содержать больше чем ', numOfIngredients, 'ингредиентов');
            end
            else begin
              writeln('Введите индекс игредиента: ' );
              repeat
                stop:= true;

                ingredients[numOfIngredients].Index:= ReadInt(0, 9999); //а если введённого элемеента нету?
                if (PointIngr(ingredients[numOfIngredients].Index) = nil) then begin
                  writeln('не найден код ингредиента, повторите ввод');
                  stop:= false;
                end
                else begin
                  for var j := 0 to numOfIngredients-1 do begin
                    if (ingredients[numOfIngredients].Index = ingredients[j].Index) then begin
                      writeln('этот код ингредиента уже был введён. Повторите ввод');
                      stop:= false;
                    end;
                  end;
                end;
              until stop;
              writeln('Введите нужное количество грамм ингредиента' );
              ingredients[numOfIngredients].Grams:= ReadInt(0, 200);

              inc(numOfIngredients);
            end;
          end;
          5:
          begin
            Writeln('Введите номер ингредиента в рецепте для его удаления из рецепта');
            valueInput2:= ReadInt(0, numOfIngredients-1);
            if (numOfIngredients = 1) then begin
              tempS^.adr:= tempS^.adr^.adr;
              dispose(delS);

              Writeln('Хотите изменить другой салат? 0 - нет; 1 - да');
              valueInput:= BasicFunction.ReadInt(0, 1);
              if (valueInput = 1) then begin
                repeat
                  stop:= true;
                  FindSalat(tempS, delS);
                  if (tempS = nil) or (delS = nil) then begin
                    Writeln('Хотите изменить другой салат? 0 - нет; 1 - да');
                    valueInput:= BasicFunction.ReadInt(0, 1);
                    if (valueInput = 1) then stop:= false;
                  end;
                until stop;
              end;
            end
            else begin
              for var k:= valueInput2 to numOfIngredients-2 do begin
                ingredients[k].Index:= ingredients[k+1].Index;
              end;
              dec(numOfIngredients);
            end;
          end;
          {6:
          begin

          end;}
        end;
      end;
    until valueInput = 0;
  end;
end;

procedure chooseSalatO(var tempS, delS: PSalat; var valueInput: integer; var tempO: POrder);
var
  stop: boolean;
begin
  repeat
    tempO:= nil;
    stop:= true;
    FindSalat(tempS, delS);
    if (delS <> nil) then tempO:= PointOrder(delS^.inf.index);
    if (tempS = nil) or (delS = nil) or (tempO = nil) then begin
      if (tempO = nil) then writeln('Этого салата нет в заказах');
      Writeln('Хотите изменить другой салат? 0 - нет; 1 - да');
      valueInput:= BasicFunction.ReadInt(0, 1);
      if (valueInput = 1) then stop:= false;
    end;

  until stop;
end;

procedure editOrder();
var
  tempS, delS: PSalat;
  tempO: POrder;
  valueInput, myIndex: integer;
  stop: boolean;
  strOut: string;
begin
  chooseSalatO(tempS, delS, valueInput, tempO);

  if (tempS <> nil) and (delS <> nil) and (tempO <> nil) then begin
    repeat
      with delS^.inf do begin
        //tempO:= PointOrder(index);
        ClearScreen;
        Writeln('0. Выйти в меню');
        Writeln('1. Выбранный другой салат для редактирования');
        Writeln('2. Изменить салат в заказе');
        Writeln('3. Изменить количество заказанного салата');
        writeln;
        writeln('код салата   название            кол-во салатов     возможность приготовить');

        if (tempO^.CadDo) then strOut:= 'приготовим'
        else strOut:= 'не приготовим';
        Writeln(Format('     %4-d    %20-s       %12-d   %20-s', [
        tempO^.Index, Name, tempO^.amount, strOut
        ]));

        valueInput:= BasicFunction.ReadInt(0, 5);

        case valueInput of
          0: MainMenu;
          1: chooseSalatO(tempS, delS, valueInput, tempO);
          2:
          begin
            if (NumOfSalat() > NumOfOrder()) then begin
              writeln('Введите индекс салата: ' );
              repeat
                stop:= true;
                myIndex:= ReadInt(0, 9999); //а если введённого элемеента нету?
                if (PointSalat(myIndex) = nil) then begin
                  writeln('не найден код салата, повторите ввод');
                  stop:= false;
                end;
                if (PointOrderPre(myIndex) <> nil) then begin
                  writeln('данный салат уже добавлен, повторите ввод');
                  stop:= false;
                end;

              until stop;
              tempO^.Index:= myIndex;
            end
            else Writeln('невозможно добавить, уже заказаны все салаты');
          end;
          3:
          begin
            writeln('Введите количество порций этого салата: ');
            tempO^.amount:= ReadInt(1, 999);
          end;
        end;
      end;
    until valueInput = 0;
  end;
end;

end.
