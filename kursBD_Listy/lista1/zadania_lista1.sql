-- Zestaw zadań: KPABD — Podstawy T-SQL (bez aliasów tabel) — AdventureWorksLT2022
USE AdventureWorksLT2022;
GO

/* 0) Szybki test danych */
SELECT TOP 1 * FROM SalesLT.SalesOrderHeader;
SELECT TOP 1 * FROM SalesLT.SalesOrderDetail;
SELECT TOP 1 * FROM SalesLT.Product;
SELECT TOP 1 * FROM SalesLT.Address;
GO


/* 1) Miasta, do których wysłano towar (unikalne, posortowane) */
SELECT DISTINCT
       SalesLT.Address.City AS Miasto
FROM SalesLT.SalesOrderHeader
JOIN SalesLT.Address
  ON SalesLT.Address.AddressID = SalesLT.SalesOrderHeader.ShipToAddressID
ORDER BY SalesLT.Address.City;
GO


/* 2) Nazwa modelu produktu + liczba produktów w tym modelu (tylko >1) */
SELECT
    SalesLT.ProductModel.Name AS ModelProduktu,
    COUNT(*)                  AS LiczbaProduktów
FROM SalesLT.Product
JOIN SalesLT.ProductModel
  ON SalesLT.ProductModel.ProductModelID = SalesLT.Product.ProductModelID
GROUP BY SalesLT.ProductModel.Name
HAVING COUNT(*) > 1
ORDER BY LiczbaProduktów DESC, ModelProduktu;
GO


/* 3) Miasto, liczba klientów z danego miasta */
/* Za mało danych??? */
SELECT
    SalesLT.Address.City                       AS Miasto,
    COUNT(DISTINCT SalesLT.Customer.CustomerID) AS LiczbaKlientów
FROM SalesLT.Customer
JOIN SalesLT.CustomerAddress
  ON SalesLT.CustomerAddress.CustomerID = SalesLT.Customer.CustomerID
JOIN SalesLT.Address
  ON SalesLT.Address.AddressID = SalesLT.CustomerAddress.AddressID
GROUP BY SalesLT.Address.City
ORDER BY SalesLT.Address.City;
GO


/* 4) Kategorie nie-liściowe + produkty przypisane do tych kategorii
   (kategorie-rodzice to takie, które występują jako ParentProductCategoryID) */
SELECT
    SalesLT.ProductCategory.Name AS Kategoria,
    SalesLT.Product.Name         AS Produkt
FROM SalesLT.Product
JOIN SalesLT.ProductCategory
  ON SalesLT.ProductCategory.ProductCategoryID = SalesLT.Product.ProductCategoryID
WHERE SalesLT.Product.ProductCategoryID IN (
    SELECT SalesLT.ProductCategory.ParentProductCategoryID
    FROM SalesLT.ProductCategory
    WHERE SalesLT.ProductCategory.ParentProductCategoryID IS NOT NULL
    GROUP BY SalesLT.ProductCategory.ParentProductCategoryID
)
ORDER BY SalesLT.ProductCategory.Name, SalesLT.Product.Name;
GO

/* 5a) Raport zamówień: suma z rabatem / bez rabatu / kwota rabatu */
SELECT
    SalesLT.SalesOrderHeader.SalesOrderID       AS IDZamówienia,
    SalesLT.SalesOrderHeader.SalesOrderNumber   AS NrZamówienia,
    SalesLT.SalesOrderHeader.PurchaseOrderNumber AS NrZamówieniaKlienta,
    SUM(SalesLT.SalesOrderDetail.LineTotal) AS SumaZRabatem,
    SUM(SalesLT.SalesOrderDetail.UnitPrice * SalesLT.SalesOrderDetail.OrderQty) AS SumaBezRabatu,
    SUM(SalesLT.SalesOrderDetail.UnitPrice * SalesLT.SalesOrderDetail.OrderQty)
      - SUM(SalesLT.SalesOrderDetail.LineTotal) AS KwotaRabatu
FROM SalesLT.SalesOrderHeader
JOIN SalesLT.SalesOrderDetail
  ON SalesLT.SalesOrderDetail.SalesOrderID = SalesLT.SalesOrderHeader.SalesOrderID
GROUP BY SalesLT.SalesOrderHeader.SalesOrderID,
         SalesLT.SalesOrderHeader.SalesOrderNumber,
         SalesLT.SalesOrderHeader.PurchaseOrderNumber
ORDER BY KwotaRabatu DESC;
GO


/* 5b) Zamówienie z najwyższą łączną kwotą rabatu (bez aliasów tabel; używamy HAVING + podzapytanie) */
DECLARE @Threshold MONEY = 500.00;  -- próg rabatu

WITH Agg AS (
  -- agregaty per zamówienie (jak w 5a)
  SELECT
      SalesLT.SalesOrderDetail.SalesOrderID,
      SUM(SalesLT.SalesOrderDetail.LineTotal) AS SumaZRabatem,
      SUM(SalesLT.SalesOrderDetail.UnitPrice * SalesLT.SalesOrderDetail.OrderQty) AS SumaBezRabatu
  FROM SalesLT.SalesOrderDetail
  GROUP BY SalesLT.SalesOrderDetail.SalesOrderID
),
R AS (
  -- dokładnie te same kolumny co w 5a
  SELECT
      SalesLT.SalesOrderHeader.SalesOrderID       AS IDZamówienia,
      SalesLT.SalesOrderHeader.SalesOrderNumber   AS NrZamówienia,
      SalesLT.SalesOrderHeader.PurchaseOrderNumber AS NrZamówieniaKlienta,
      Agg.SumaZRabatem,
      Agg.SumaBezRabatu,
      Agg.SumaBezRabatu - Agg.SumaZRabatem        AS KwotaRabatu
  FROM SalesLT.SalesOrderHeader
  JOIN Agg
    ON Agg.SalesOrderID = SalesLT.SalesOrderHeader.SalesOrderID
)
SELECT
    IDZamówienia, NrZamówienia, NrZamówieniaKlienta,
    SumaZRabatem, SumaBezRabatu, KwotaRabatu
FROM R
WHERE KwotaRabatu >= @Threshold
ORDER BY KwotaRabatu DESC, IDZamówienia;

/* 6) Łączny „zaoszczędzony” rabat dla każdego klienta */
SELECT
    (SalesLT.Customer.LastName + ' ' + SalesLT.Customer.FirstName) AS Klient,
    SUM(SalesLT.SalesOrderDetail.UnitPrice * SalesLT.SalesOrderDetail.OrderQty)
      - SUM(SalesLT.SalesOrderDetail.LineTotal) AS ŁącznyRabat
FROM SalesLT.Customer
JOIN SalesLT.SalesOrderHeader
  ON SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID
JOIN SalesLT.SalesOrderDetail
  ON SalesLT.SalesOrderDetail.SalesOrderID = SalesLT.SalesOrderHeader.SalesOrderID
GROUP BY (SalesLT.Customer.LastName + ' ' + SalesLT.Customer.FirstName)
ORDER BY ŁącznyRabat DESC;
GO


/* 7) Tabela testowa z IDENTITY (start 1000, przyrost 10) + @@IDENTITY vs IDENT_CURRENT */

/* 1. Usuń tabelę, jeśli istnieje (żeby skrypt był powtarzalny) */
IF OBJECT_ID('dbo.Test','U') IS NOT NULL
    DROP TABLE dbo.Test;
GO

/* 2. Utwórz tabelę z IDENTITY od 1000, przyrost 10 */
CREATE TABLE dbo.Test
(
    Id   INT IDENTITY(1000,10) PRIMARY KEY,
    Opis VARCHAR(50) NOT NULL
);
GO

/* 3. Wstaw kilka wierszy (to podbije licznik IDENTITY: 1000, 1010, 1020) */
INSERT INTO dbo.Test (Opis) VALUES ('a'), ('b'), ('c');
GO

/* 4. Pokaż wartości IDENTITY:
      - @@IDENTITY        → ostatnia wartość IDENTITY w TEJ sesji (dowolna tabela)
      - SCOPE_IDENTITY()  → ostatnia wartość IDENTITY w TEJ sesji i TEGO scope (najbezpieczniejsze po INSERT)
      - IDENT_CURRENT('dbo.Test') → ostatnia wartość IDENTITY dla KONKRETNEJ tabeli (niezależnie od sesji)
*/
SELECT
    @@IDENTITY                 AS OstatniaTozsamoscWSesji,
    SCOPE_IDENTITY()           AS OstatniaTozsamoscWTymScope,
    IDENT_CURRENT('dbo.Test')  AS OstatniaTozsamoscDla_Tabeli_Test;
GO

/* 5. Pokaż ustawienia tożsamości i aktualny „następny” numer */
SELECT
    IDENT_SEED('dbo.Test')  AS Seed_Poczatek,     -- 1000
    IDENT_INCR('dbo.Test')  AS Przyrost,          -- 10
    IDENT_CURRENT('dbo.Test') AS OstatniaNadana_Tozsamosc,
    IDENT_CURRENT('dbo.Test') + IDENT_INCR('dbo.Test') AS NastepnaWartosc_IDENTITY;
GO

/* 6. Wstaw jeszcze jeden wiersz, zwróć jego nowe Id bezpośrednio (SCOPE_IDENTITY) */
INSERT INTO dbo.Test (Opis) VALUES ('d');
SELECT SCOPE_IDENTITY() AS IdNowoWstawionegoWiersza;
GO

/* 7. Podgląd danych */
SELECT * FROM dbo.Test ORDER BY Id;
GO


/* 8) Ograniczenie CHECK dot. daty wysyłki vs daty zamówienia */
-- Lista wszystkich CHECK na tabeli:
SELECT c.name AS NazwaOgraniczenia
FROM sys.check_constraints AS c
WHERE c.parent_object_id = OBJECT_ID('SalesLT.SalesOrderHeader');
GO
-- Jeśli istnieje 'SalesLT.CK_SalesOrderHeader_ShipDate', pokaż definicję (odkomentuj):
 SELECT OBJECT_DEFINITION(OBJECT_ID('SalesLT.CK_SalesOrderHeader_ShipDate')) AS Definicja;
 GO


/* 9) Dodaj kolumnę z numerem karty, ustaw część kodów autoryzacji i zamaskuj numery */
IF COL_LENGTH('SalesLT.Customer','CreditCardNumber') IS NULL
    ALTER TABLE SalesLT.Customer ADD CreditCardNumber VARCHAR(25) NULL;
GO

;WITH RandomOrders AS (
    SELECT TOP (3)
           SalesLT.SalesOrderHeader.SalesOrderID
    FROM SalesLT.SalesOrderHeader
    WHERE SalesLT.SalesOrderHeader.CreditCardApprovalCode IS NULL
    ORDER BY NEWID()   -- losowy wybór 3 wierszy
)
UPDATE SalesLT.SalesOrderHeader
SET    SalesLT.SalesOrderHeader.CreditCardApprovalCode = 'ABC123'  -- dowolna wartość
WHERE  SalesLT.SalesOrderHeader.SalesOrderID IN (SELECT SalesOrderID FROM RandomOrders);
GO

UPDATE SalesLT.Customer
SET    SalesLT.Customer.CreditCardNumber = 'X'
WHERE  SalesLT.Customer.CustomerID IN (
    SELECT DISTINCT SalesLT.SalesOrderHeader.CustomerID
    FROM SalesLT.SalesOrderHeader
    WHERE SalesLT.SalesOrderHeader.CreditCardApprovalCode IS NOT NULL
);
GO

-- Pokaż 10 przykładowych klientów, którzy mają zamówienia z ustawionym ApprovalCode
SELECT TOP (10)
       SalesLT.Customer.CustomerID,
       SalesLT.Customer.FirstName,
       SalesLT.Customer.LastName,
       SalesLT.Customer.CreditCardNumber,
       SalesLT.SalesOrderHeader.SalesOrderID,
       SalesLT.SalesOrderHeader.CreditCardApprovalCode
FROM SalesLT.Customer
JOIN SalesLT.SalesOrderHeader
  ON SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID
WHERE SalesLT.SalesOrderHeader.CreditCardApprovalCode IS NOT NULL
ORDER BY SalesLT.Customer.CustomerID, SalesLT.SalesOrderHeader.SalesOrderID;


/* 10) Zachowanie kluczy obcych (NO ACTION / SET NULL / CASCADE) */
IF OBJECT_ID('dbo.S2','U') IS NOT NULL DROP TABLE dbo.S2;
IF OBJECT_ID('dbo.M2','U') IS NOT NULL DROP TABLE dbo.M2;
IF OBJECT_ID('dbo.S1','U') IS NOT NULL DROP TABLE dbo.S1;
IF OBJECT_ID('dbo.M1','U') IS NOT NULL DROP TABLE dbo.M1;
GO

CREATE TABLE dbo.M1 (K INT PRIMARY KEY, Opis VARCHAR(20));
CREATE TABLE dbo.S1 (
  K INT PRIMARY KEY,
  MFK INT NULL,
  Opis VARCHAR(20),
  CONSTRAINT FK_S1_M1 FOREIGN KEY (MFK) REFERENCES dbo.M1(K)
);
INSERT INTO dbo.M1 VALUES (1,'m1'),(2,'m2');
INSERT INTO dbo.S1 VALUES (10,1,'s1'),(11,2,'s2');
GO

CREATE TABLE dbo.M2 (
  K1 INT,
  K2 INT,
  Opis VARCHAR(20),
  CONSTRAINT PK_M2 PRIMARY KEY (K1,K2)
);
CREATE TABLE dbo.S2 (
  K INT PRIMARY KEY,
  MFK1 INT NULL,
  MFK2 INT NULL,
  Opis VARCHAR(20),
  CONSTRAINT FK_S2_M2 FOREIGN KEY (MFK1,MFK2) REFERENCES dbo.M2(K1,K2)
);
INSERT INTO dbo.M2 VALUES (1,1,'m11'),(2,2,'m22');
INSERT INTO dbo.S2 VALUES (20,1,1,'s20'),(21,2,2,'s21');
GO

ALTER TABLE dbo.S1 DROP CONSTRAINT FK_S1_M1;
ALTER TABLE dbo.S1 ADD CONSTRAINT FK_S1_M1
FOREIGN KEY (MFK) REFERENCES dbo.M1(K) ON DELETE SET NULL ON UPDATE CASCADE;

-- Testy (odkomentuj w razie potrzeby):
-- UPDATE dbo.M1 SET K = 3 WHERE K = 1;   -- CASCADE
-- DELETE FROM dbo.M1 WHERE K = 2;         -- SET NULL

-- Sprzątanie (opcjonalnie):
-- DROP TABLE dbo.S2, dbo.M2, dbo.S1, dbo.M1;
