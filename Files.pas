unit Files;

interface

uses System.SysUtils;

const
    MaxIngredientOfSalat = 12;

type
//индекс, имя, кол во в граммах, БЖУ на 100г, индекс ингредиента на который можно заменить
    TIngredient = Record
      Index: integer;
      Name: String[255];
      Grams: integer;
      proteins: integer;
      Fats: integer;
      carbohydrates: integer;
      change: integer;
    End;

//пара индекс и ингредиент
    TPairIndexIngredient = Record
      Index: integer;
      Grams: integer;
    End;
//индекс, имя, цена, массив ингредиентов в граммах
    TSalat = Record
      index: integer;
      Name: String[255];
      numOfIngredients: integer;
      ingredients: array[0..MaxIngredientOfSalat] of TPairIndexIngredient;
      cost: integer;
    End;

//динамический список
//индекс салата для готовки, количество порций, возможно ли приготовить
    POrder = ^TOrder;
    TOrder = Record
      Index: integer;
      amount: integer;
      CadDo: boolean;
      adr: POrder;
    End;

// динамический список ингредиентов
    PIngredient = ^TListIngredient;
    TListIngredient = Record
      inf: TIngredient;
      adr: PIngredient;
    End;
//динамический список салатов
    PSalat = ^TListSalat;
    TListSalat = Record
      inf: TSalat;
      adr: PSalat;
    End;
    ArrIngr = array of PIngredient;
    ArrSalat = array of PSalat;
    //ArrOrder = array of POrder;

var
    HeadIngredient: PIngredient;
    HeadSalat: PSalat;
    HeadOrder: POrder;
    ReadOnlyOne: boolean = true; //если false тогда данные загруженны
    MaxIngredient, MaxSalat: integer;

procedure ReadFile();
procedure CreateFile();
procedure WriteFile();
procedure ClearAllList();


implementation

uses  Vcl.Dialogs, LoadMenu;

const
    AdresIngredientFile: string = 'Data\Ingredients.dat';
    AdresSalatFile: string = 'Data\Salat.dat';

var
    IngredientFile: File of TIngredient;
    SalatFile: File of TSalat;

procedure ReadFile();
var
    nowI, predI: PIngredient;
    nowS, predS: PSalat;
    ingredientIn: TIngredient;
    SalatIn: TSalat;
    isGoodRead: boolean;
begin
  if (ReadOnlyOne) then begin
    ReadOnlyOne:= false;
    isGoodRead:= true;
    try
      AssignFile(IngredientFile, AdresIngredientFile);
      ReSet(IngredientFile);

      predI:= HeadIngredient;
      MaxIngredient:= 0;
      while (not EOF(IngredientFile)) do begin
        Read(IngredientFile, ingredientIn);
        new(nowI);    //выделение памяти для новой переменной
        predI^.adr:= nowI;  //ссылка на этот элемент в предыдущую запись
        predI:= nowI;
        nowI^.inf:= ingredientIn;
        nowI^.adr:= nil;
        if (nowI^.inf.Index > MaxIngredient) then MaxIngredient:= nowI^.inf.Index;
      end;
      CloseFile(IngredientFile);
    except
      ShowMessage('Ошибка считывания файла ингредиентов');
      isGoodRead:= false;
    end;
    //создание списка салатов
    try
      AssignFile(SalatFile, AdresSalatFile);
      ReSet(SalatFile);

      predS:= HeadSalat;
      MaxSalat:= 0;
      while (not EOF(SalatFile)) do begin
        Read(SalatFile, SalatIn);
        new(nowS);    //выделение памяти для новой переменной
        predS^.adr:= nowS;  //ссылка на этот элемент в предыдущую запись
        predS:= nowS;
        nowS^.inf:= SalatIn;
        nowS^.adr:= nil;
        if (nowS^.inf.index > MaxSalat) then MaxSalat:= nowS^.inf.index;
      end;
      CloseFile(SalatFile);
    except
      ShowMessage('Ошибка считывания файла салатов');
      isGoodRead:= false;
    end;
    if (isGoodRead) then ShowMessage('Файлы были считаны!');

  end
  else ShowMessage('Файлы уже были считаны!');
  MainMenu();
end;



procedure WriteFile();
var
  tempI: PIngredient;
  tempS: PSalat;
begin
  try
    //ingredients
    ReWrite(IngredientFile, AdresIngredientFile);
    tempI:= HeadIngredient;
    while (tempI^.adr <> nil) do begin
      tempI:= tempI^.adr;
      write(IngredientFile, tempI^.inf);
    end;
    Close(IngredientFile);

    //salat
    ReWrite(SalatFile, AdresSalatFile);
    tempS:= HeadSalat;
    while (tempS^.adr <> nil) do begin
      tempS:= tempS^.adr;
      write(SalatFile, tempS^.inf);
    end;
    Close(SalatFile);
    ShowMessage('данные были сохранены');
  except
    ShowMessage('Ошибка записи данных');
  end;
end;



procedure CreateFile();
const
    amountSalat = 10;
    amountIng = 44;

    name: array[1..30] of string = ('цезарь', 'греческий', 'оливье', 'капрезе',
    'винегрет', 'кобб', 'мимоза', 'нисуаз', 'табуле', 'шопский', 'коул слоу',
    'сельдь под шубой', 'вальдорф', 'русский', 'крабовый', 'фатуш', 'панцанелла',
    'руккола с креветками', 'теплый салат с курицей', 'салат с тунцом',
    'морковь по-корейски', 'салат с авокадо', 'салат с моцареллой',
    'салат с кальмарами', 'салат с рукколой и пармезаном', 'салат с куриной печенью',
    'салат с брынзой', 'салат с ананасом', 'салат с грибами', 'салат с яйцом и ветчиной');

    ingredients: array[1..amountIng] of string = ('помидоры', 'огурцы', 'куриная грудка',
    'сыр', 'листья салата', 'оливки', 'авокадо', 'морковь', 'капуста',
    'ветчина', 'яйца', 'креветки', 'греческий йогурт', 'чеснок', 'лук',
    'перец болгарский', 'грибы', 'анчоусы', 'руккола', 'моцарелла', 'брынза',
    'кукуруза', 'горошек', 'фасоль', 'картофель', 'сельдерей', 'яблоки',
    'грецкие орехи', 'изюм', 'ананас', 'крабовые палочки', 'свёкла',
    'редис', 'базилик', 'петрушка', 'укроп', 'кинза', 'оливковое масло',
    'лимонный сок', 'майонез', 'горчица', 'сухарики', 'пармезан', 'кедровые орешки');

    numbers: array[0..43] of integer = (7, 42, 19, 33, 12, 28, 3, 39,
    15, 26, 44, 8, 21, 36, 1, 30, 17, 41, 10, 24, 5, 37, 14, 29, 2, 43, 18,
    32, 9, 25, 40, 4, 22, 35, 11, 27, 16, 38, 6, 31, 20, 13, 34, 23);

var
    tempingredients: Tingredient;
    tempSalat: TSalat;
    pair: TPairIndexIngredient;
    amounIngredients, value, k: integer;
begin
  try
    randomize;
    //indredients
    AssignFile(IngredientFile, AdresIngredientFile);
    ReWrite(IngredientFile);
    for var i:= 1 to amountIng do begin
      tempingredients.Index:= i;
      tempingredients.Name:= ingredients[i];
      tempingredients.Grams:= Random(4001)+1000; //количество в грамах на складе
      tempingredients.proteins:= Random(30);
      tempingredients.Fats:= Random(20);
      tempingredients.carbohydrates:= Random(40);
      repeat
        value:= Random(amountIng+1); //если 0 то нет замены
      until value <> tempingredients.index;//заменитель не может быть самим ингредиентом
      if (value mod 8 = 0) then value:= 0; //шанс что нет заменителя 1 к 8
      tempingredients.change:= value;

      Write(IngredientFile, tempingredients);
    end;
    CloseFile(IngredientFile);

    //salat
    AssignFile(SalatFile, AdresSalatFile);
    ReWrite(SalatFile);
    for var i := 1 to amountSalat do begin
      tempSalat.index:= i;
      tempSalat.Name:= name[i];
      tempSalat.cost:= Random(2301)+700; //от 700 до 3000 копеек, от 7 до 30 рублей

      amounIngredients:= Random(5)+3; //от 3 до  7
      tempSalat.numOfIngredients:= amounIngredients;
      k:= Random(44);
      for var j:= 1 to amounIngredients do begin
        k:= (k+1) mod 44;
        pair.Index:= numbers[k];
        pair.Grams:= Random(31)+10; //от 10 до 50
        tempSalat.ingredients[j-1]:= pair;
      end;

      Write(SalatFile, tempSalat);
    end;
    CloseFile(SalatFile);
    showMessage('create File');
  except
    showMessage('error create File');
  end;
end;

procedure ClearAllList();
var
  tempI: PIngredient;
  tempS: PSalat;
  tempO: POrder;
begin
  if (ReadOnlyOne = false) then begin
    while (HeadSalat^.adr <> nil) do begin
      tempS:= HeadSalat;
      dispose(tempS);
      HeadSalat:= HeadSalat^.adr;
    end;
    dispose(HeadSalat);

    while (HeadIngredient^.adr <> nil) do begin
      tempI:= HeadIngredient;
      dispose(tempI);
      HeadIngredient:= HeadIngredient^.adr;
    end;
    dispose(HeadIngredient);

    while (HeadOrder^.adr <> nil) do begin
      tempO:= HeadOrder;
      dispose(tempO);
      HeadOrder:= HeadOrder^.adr;
    end;
    dispose(HeadOrder);
  end;
end;

end.
