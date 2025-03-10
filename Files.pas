unit Files;

interface

uses System.SysUtils;

type
//индекс, имя, кол во в граммах, БЖУ на 100г, код ингредиента на который можно заменить
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
//индекс, имя, массив ингредиентов в граммах
    TSalat = Record
      index: integer;
      Name: String[255];
      ingredients: array[0..12] of TPairIndexIngredient;
    End;

//индекс салата для готовки, количество порций, возможно ли приготовить
    TSalatOrder = Record
      Index: integer;
      amount: integer;
      CadDo: boolean;
    End;
//индекс заказа, имя заказа, массив из заказанных салатов
    TOrder = Record
      index: integer;
      Name: String[255];
      CookSalats: array[0..20] of TSalatOrder;
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

implementation

const
    AdresIngredientFile: string = 'Data\Ingredients.dat';
    AdresSalatFile: string = 'Data\Salat.dat';
    AdresOrderFile: string = 'Data\Order.dat';

procedure ReadFile();
var
    IngredientFile: File of TIngredient;
    SalatFile: File of TSalat;
    OrderFile: File of TOrder;

    nowI, predI: PIngredient;
    nowS, predS: PSalat;
    ingredientIn: TIngredient;
    SalatIn: TSalat;
begin
  try
    AssignFile(IngredientFile, AdresIngredientFile);
    //создание пустой головы
    New(HeadIngredient);
    HeadIngredient^.adr:= nil;

    predI:= HeadIngredient;
    while (not EOF(IngredientFile)) do begin
      Read(IngredientFile, ingredientIn);
      new(nowI);    //выделение памяти для новой переменной
      predI^.adr:= nowI;  //ссылка на этот элемент в предыдущую запись
      nowI^.inf:= ingredientIn;
      nowI^.adr:= nil;
    end;

  except
    Write('Ошибка считывания файла ингредиентов');
  end;
  //создание списка салатов
  try
    AssignFile(SalatFile, AdresSalatFile);
    //создание пустой головы
    New(HeadSalat);
    HeadSalat^.adr:= nil;

    predS:= HeadSalat;
    while (not EOF(SalatFile)) do begin
      Read(SalatFile, SalatIn);
      new(nowS);    //выделение памяти для новой переменной
      predS^.adr:= nowS;  //ссылка на этот элемент в предыдущую запись
      nowS^.inf:= SalatIn;
      nowS^.adr:= nil;
    end;

  except
    Write('Ошибка считывания файла ингредиентов');
  end;
end;

procedure WriteFile();
begin
  if not DirectoryExists('Data\') then
    CreateDir('saves\');

end;

end.
