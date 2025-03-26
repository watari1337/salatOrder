unit Files;

interface

uses System.SysUtils;

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
      ingredients: array[0..12] of TPairIndexIngredient;
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

var
    HeadIngredient: PIngredient;
    HeadSalat: PSalat;
    HeadOrder: POrder; 
    ReadOnlyOne: boolean = true; //если false тогда данные загруженны

procedure ReadFile();
procedure CreateFile();



implementation

uses  Vcl.Dialogs, LoadMenu;

const
    AdresIngredientFile: string = 'Data\Ingredients.dat';
    AdresSalatFile: string = 'Data\Salat.dat';


procedure ReadFile();
var
    IngredientFile: File of TIngredient;
    SalatFile: File of TSalat;

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
      //создание пустой головы
      New(HeadIngredient);
      HeadIngredient^.adr:= nil;

      predI:= HeadIngredient;
      while (not EOF(IngredientFile)) do begin
        Read(IngredientFile, ingredientIn);
        new(nowI);    //выделение памяти для новой переменной
        predI^.adr:= nowI;  //ссылка на этот элемент в предыдущую запись
        predI:= nowI;
        nowI^.inf:= ingredientIn;
        nowI^.adr:= nil;
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
      //создание пустой головы
      New(HeadSalat);
      HeadSalat^.adr:= nil;

      predS:= HeadSalat;
      while (not EOF(SalatFile)) do begin
        Read(SalatFile, SalatIn);
        new(nowS);    //выделение памяти для новой переменной
        predS^.adr:= nowS;  //ссылка на этот элемент в предыдущую запись
        predS:= nowS;
        nowS^.inf:= SalatIn;
        nowS^.adr:= nil;
      end;
      CloseFile(SalatFile);
    except
      ShowMessage('Ошибка считывания файла салатов');
      isGoodRead:= false;
    end;
    if (isGoodRead) then ShowMessage('Файлы были считаны!');

  end
  else ShowMessage('Файлы уже были считаны!');
  New(HeadOrder); //инициализируем список банкета
  MainMenu();
end;

procedure WriteFile();
begin
  if not DirectoryExists('Data\') then
    CreateDir('Data\');

end;

procedure CreateFile();
const
    name: array[1..30] of string = ('Цезарь', 'Греческий', 'Оливье', 'Капрезе',
    'Винегрет', 'Кобб', 'Мимоза', 'Нисуаз', 'Табуле', 'Шопский', 'Коул слоу',
    'Сельдь под шубой', 'Вальдорф', 'Русский', 'Крабовый', 'Фатуш', 'Панцанелла',
    'Руккола с креветками', 'Теплый салат с курицей', 'Салат с тунцом',
    'Морковь по-корейски', 'Салат с авокадо', 'Салат с моцареллой',
    'Салат с кальмарами', 'Салат с рукколой и пармезаном', 'Салат с куриной печенью',
    'Салат с брынзой', 'Салат с ананасом', 'Салат с грибами', 'Салат с яйцом и ветчиной');

    ingredients: array[0..43] of string = ('помидоры', 'огурцы', 'куриная грудка',
    'сыр', 'листья салата', 'оливки', 'авокадо', 'морковь', 'капуста',
    'ветчина', 'яйца', 'креветки', 'греческий йогурт', 'чеснок', 'лук',
    'перец болгарский', 'грибы', 'анчоусы', 'руккола', 'моцарелла', 'брынза',
    'кукуруза', 'горошек', 'фасоль', 'картофель', 'сельдерей', 'яблоки',
    'грецкие орехи', 'изюм', 'ананас', 'крабовые палочки', 'свёкла',
    'редис', 'базилик', 'петрушка', 'укроп', 'кинза', 'оливковое масло',
    'лимонный сок', 'майонез', 'горчица', 'сухарики', 'пармезан', 'кедровые орешки');

    amountSalat: integer = 30;
    amountIng: integer = 43;

var
    tempingredients: Tingredient;
    tempSalat: TSalat;
    pair: TPairIndexIngredient;
    amounIngredients: integer;
    IngredientFile: File of TIngredient;
    SalatFile: File of TSalat;
begin
  try
    if not DirectoryExists('Data\') then
    CreateDir('Data\');
    
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
      tempingredients.change:= Random(amountIng+1); //если 0 то нет замены

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
      for var j:= 1 to amounIngredients do begin
        pair.Index:= Random(amountIng)+1;
        pair.Grams:= Random(31)+10; //от 10 до 40
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

end.
