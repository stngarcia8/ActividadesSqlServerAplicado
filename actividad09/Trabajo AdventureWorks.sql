
create view vwResumenFinanzas
as
select
	FactFinance.Amount as Cantidad,
	DimAccount.AccountType as 'Tipo Cuenta',
	DimAccount.AccountDescription as 'Descripción Cuenta',
	DimOrganization.OrganizationName as Organización, 
	DimScenario.Scenarioname as Escenario,
	DimDepartmentGroup.DepartmentGroupName as 'Grupo Departamento',
	DimDate.FullDateAlternateKey as Fecha
from FactFinance
inner join DimAccount
	on FactFinance.AccountKey = DimAccount.AccountKey
inner join DimOrganization
	on FactFinance.OrganizationKey = DimOrganization.OrganizationKey
inner join DimScenario
	on FactFinance.ScenarioKey = DimScenario.ScenarioKey
inner join DimDepartmentGroup
	on FactFinance.DepartmentGroupKey = DimDepartmentGroup.DepartmentGroupKey
inner join DimDate
	on FactFinance.DateKey = DimDate.DateKey
go

create view vwResumenCuotaVentas
as
select
	DimEmployee.FirstName as 'Nombre Empleado',
	DimEmployee.LastName as 'Apellido Empleado',
	DimEmployee.Gender as 'Genero Empleado',
	DimEmployee.Title as 'Titulo Empleado',
	DimEmployee.DepartmentName as 'Departamento',
	DimDate.DayNumberOfMonth as Dia,
	DimDate.MonthNumberOfYear as Mes,
	DimDate.CalendarYear as Annio,
	FactSalesQuota.SalesAmountQuota as 'Cuota Cantidad Ventas',
	DimSalesTerritory.SalesTerritoryCountry as Cuidad,
	DimSalesTerritory.SalesTerritoryRegion as Region
from FactSalesQuota
inner join DimEmployee
	on FactSalesQuota.EmployeeKey = DimEmployee.EmployeeKey
inner join DimDate
	on FactSalesQuota.DateKey = DimDate.DateKey
inner join DimSalesTerritory
	on DimEmployee.SalesTerritoryKey = DimSalesTerritory.SalesTerritoryKey
go

create view vwResumenEncuestas
as
select
	DimCustomer.FirstName,
	DimCustomer.LastName,
	DimCustomer.Gender, 
	DimCustomer.EmailAddress,
	DimDate.DayNumberOfMonth,
	DimDate.MonthNumberOfYear,
	DimDate.CalendarYear,
	DimProductSubcategory.SpanishProductSubcategoryName,
	DimProductCategory.SpanishProductCategoryName
from FactSurveyResponse
inner join DimDate
	on FactSurveyResponse.DateKey = DimDate.DateKey
inner join DimProductSubcategory
	on FactSurveyResponse.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
inner join DimProductCategory
	on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
inner join DimCustomer
	on FactSurveyResponse.CustomerKey = DimCustomer.CustomerKey
go

create function dbo.EncuestasPorMesAnnio (@mes int, @annio int)
returns int
as
begin
	return (
		select count(FactSurveyResponse.SurveyResponseKey)
		from dbo.FactSurveyResponse
		inner join DimDate
			on FactSurveyResponse.DateKey = DimDate.DateKey
		where DimDate.DayNumberOfMonth = @mes
			and DimDate.CalendarYear = @annio)
end
go

select dbo.EncuestasPorMesAnnio(1, 2010) as 'Encuestas Enero 2010'
go


create function dbo.BusquedaProductosVendidos (@nombre varchar)
returns table
as
begin
	
end
go
