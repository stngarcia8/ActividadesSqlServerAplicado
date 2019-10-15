USE AdventureWorksDW2017;
GO

-- Creando funciones para usarlas en las vistas.
CREATE OR ALTER FUNCTION dbo.vwMostrarGenero(@genero AS VARCHAR) 
returns VARCHAR(20) 
AS 
BEGIN
	DECLARE @retorno VARCHAR(20);
	SET @retorno = (SELECT
		CASE 
WHEN upper(@genero) = 'F' THEN 'Femenino'
WHEN upper(@genero) = 'M' THEN 'Masculino'
ELSE '...'
END)
	RETURN @retorno;
END;
GO

-- Creando vista para el resumen de las finanzas.
DROP  VIEW IF EXISTS dbo.vwResumenFinanzas  
GO

CREATE VIEW dbo.vwResumenFinanzas
AS
	SELECT
		FactFinance.Amount AS Cantidad,
		DimAccount.AccountType AS 'Tipo Cuenta',
		DimAccount.AccountDescription AS 'Descripcion Cuenta',
		DimOrganization.OrganizationName AS Organizacion,
		DimScenario.Scenarioname AS Escenario,
		DimDepartmentGroup.DepartmentGroupName AS 'Grupo Departamento',
		DimDate.FullDateAlternateKey AS Fecha
	FROM
		FactFinance
		INNER JOIN DimAccount ON FactFinance.AccountKey = DimAccount.AccountKey
		INNER JOIN DimOrganization ON FactFinance.OrganizationKey = DimOrganization.OrganizationKey
		INNER JOIN DimScenario ON FactFinance.ScenarioKey = DimScenario.ScenarioKey
		INNER JOIN DimDepartmentGroup ON FactFinance.DepartmentGroupKey =DimDepartmentGroup.DepartmentGroupKey
		INNER JOIN DimDate ON FactFinance.DateKey = DimDate.DateKey
GO


-- Creando vista para el resumen de las ventas.
DROP  VIEW IF EXISTS dbo.vwResumenCuotaVentas;
GO

CREATE VIEW dbo.vwResumenCuotaVentas
AS
	SELECT
		DimEmployee.FirstName AS 'Nombre Empleado',
		DimEmployee.LastName AS 'Apellido Empleado',
		DimEmployee.Gender AS 'Genero Empleado',
		DimEmployee.Title AS 'Titulo Empleado',
		DimEmployee.DepartmentName AS 'Departamento',
		DimDate.DayNumberOfMonth AS Dia,
		DimDate.MonthNumberOfYear AS Mes,
		DimDate.CalendarYear AS 'Año',
		FactSalesQuota.SalesAmountQuota AS 'Cuota Cantidad Ventas',
		DimSalesTerritory.SalesTerritoryCountry AS Ciudad,
		DimSalesTerritory.SalesTerritoryRegion AS Region
	FROM
		FactSalesQuota
		INNER JOIN DimEmployee ON FactSalesQuota.EmployeeKey = DimEmployee.EmployeeKey
		INNER JOIN DimDate ON FactSalesQuota.DateKey = DimDate.DateKey
		INNER JOIN DimSalesTerritory ON DimEmployee.SalesTerritoryKey =DimSalesTerritory.SalesTerritoryKey
GO

-- Creando las vistas para el resumen de las encuestas.
DROP  VIEW IF EXISTS dbo.vwResumenEncuestas ;
GO

CREATE VIEW dbo.vwResumenEncuestas
AS
	SELECT
		DimCustomer.FirstName AS 'Nombre',
		DimCustomer.LastName AS 'Apellidos',
		DimCustomer.Gender AS 'Genero',
		DimCustomer.EmailAddress AS 'Correo electronico',
		DimDate.DayNumberOfMonth AS 'Dia',
		DimDate.MonthNumberOfYear AS 'Mes',
		DimDate.CalendarYear AS 'Año',
		DimProductSubcategory.SpanishProductSubcategoryName AS 'Categoria',
		DimProductCategory.SpanishProductCategoryName AS 'Categoria (español)'
	FROM
		FactSurveyResponse
		INNER JOIN DimDate ON FactSurveyResponse.DateKey = DimDate.DateKey
		INNER JOIN DimProductSubcategory ON FactSurveyResponse.ProductSubcategoryKey =DimProductSubcategory.ProductSubcategoryKey
		INNER JOIN DimProductCategory ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
		INNER JOIN DimCustomer ON FactSurveyResponse.CustomerKey = DimCustomer.CustomerKey
GO

-- Creando la funcion que devuelbe el resumen de encuestas por mes.
CREATE OR ALTER FUNCTION dbo.vwMostrarEncuestasPormes(@mes INT)
returns TABLE
AS
RETURN (SELECT
	Nombre,
	Apellidos,
	dbo.vwMostrarGenero(Genero) AS Genero,
	[Correo electronico] AS Email,
	mes,
	año
FROM
	dbo.vwResumenEncuestas
WHERE mes=@mes )
GO


-- Probando las vistas.
SELECT 	*
FROM 	dbo.vwResumenFinanzas;

SELECT 	*
FROM 	dbo.vwResumenCuotaVentas;

SELECT 	*
FROM 	dbo.vwResumenEncuestas;


-- Probando el resultado de la visualizacion del genero.
SELECT
	Nombre,
	Apellidos,
	dbo.vwMostrarGenero(Genero) AS Genero,
	[Correo electronico] AS Email,
	mes,
	año
FROM 	dbo.vwResumenEncuestas;

-- Consultando la funcion.
SELECT 	*
FROM 	dbo.vwMostrarEncuestasPormes(2);
