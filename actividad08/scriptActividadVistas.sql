use master
go

create table Alumnos(
	codalu int identity(1, 1) primary key not null,
	nom varchar(50) not null,
	pat varchar(50) not null,
	mat varchar(50) not null,
)
go

create table Profesores(
	codprofe int identity(1, 1) primary key not null,
	nombre varchar(50) not null,
	categ varchar(50) not null,
	fec_ing date default getdate(),
)
go

create table Secciones(
	sec int identity(1, 1) primary key not null,
	codprofe int not null,
	inicio date default getdate(),
	pension int not null,
	vacantes int not null,
	numhoras int not null,
	foreign key (codprofe)
	references Profesores (codprofe),
)
go

create table Inscritos(
	codins int identity(1, 1) primary key not null,
	codalu int not null,
	sec int not null,
	foreign key (codalu)
	references Alumnos (codalu),
	foreign key (sec)
	references Secciones (sec),
)
go

create table Calificaciones(
	codins int primary key not null,
	n1 int not null,
	n2 int not null,
	foreign key (codins)
	references Inscritos (codins),
)
go

insert into Alumnos (nom, pat, mat)
values 
	('Juan', 'Perez', 'Mesa'),
	('Antonia', 'Salas', 'Rodriguez'),
	('Carlos', 'Martinez', 'Rojas')
go

insert into Profesores (nombre, categ)
values
	('Ramiro Alba', 'Lenguaje'),
	('Josefa Valenzuela', 'Ciencias'),
	('Valeska Alvarez', 'Matematicas')
go

insert into Secciones (codprofe, pension, vacantes, numhoras)
values
	(1, 150000, 5, 8),
	(2, 125000, 8, 6),
	(3, 200000, 2, 8)
go

insert into Inscritos (codalu, sec)
values
	(1, 1),
	(1, 2),
	(1, 3),
	(2, 1),
	(2, 2),
	(2, 3),
	(3, 1),
	(3, 2),
	(3, 3)
go

insert into Calificaciones (codins, n1, n2)
values
	(1, 5, 6),
	(2, 6, 6),
	(3, 5, 4),
	(4, 7, 6),
	(5, 4, 5),
	(6, 6, 5),
	(7, 5, 5),
	(8, 5, 7),
	(9, 5, 3)
go

-- Vistas

create view relacion_de_promedios
as
select
	inscritos.codalu as codigo,
	alumnos.nom + ' ' + alumnos.pat as nomape,
	inscritos.sec as seccion,
	profesores.nombre as profesor,
	(calificaciones.n1 + calificaciones.n2) / 2 as promedio
from
	alumnos,
	secciones,
	inscritos,
	calificaciones,
	profesores
where
	alumnos.codalu = inscritos.codalu and
	inscritos.sec = secciones.sec and
	secciones.codprofe = profesores.codprofe and
	inscritos.codins = calificaciones.codins
go

select * from relacion_de_promedios
go

sp_helptext relacion_de_promedios
go

sp_depends relacion_de_promedios
go

CREATE VIEW Resumen 
AS 
select
	Inscritos.Sec As Seccion,
	MAX(nombre) As Profesor,
	Count(Inscritos.codalu) As Alumnado,
	Max((N1+N2)/2) As MayorPromedio,
	Min((N1+N2)/2) As MenorPromedio,
	Avg((N1+N2)/2) As PromedioSec,
	Sum(Pension) As Acumulado
From
	Inscritos
INNER JOIN Calificaciones
	On Inscritos.codins = Calificaciones.codins
INNER JOIN Secciones
	On Inscritos.Sec = Secciones.Sec
INNER JOIN Profesores
	On Secciones.CodProfe = Profesores.CodProfe
Group by Inscritos.Sec 
GO

Select * From Resumen 
GO 

Sp_HelpText Resumen
GO

ALTER VIEW Resumen 
WITH ENCRYPTION 
AS 
Select
	Inscritos.Sec As Seccion,
	MAX(nombre) As Profesor,
	Count(Inscritos.Codalu) As Alumnado,
	Max((N1+N2)/2) As MayorPromedio,
	Min((N1+N2)/2) As MenorPromedio,
	Avg((N1+N2)/2) As PromedioSec,
	Sum(Pension) As Acumulado
From
	Inscritos
INNER JOIN Calificaciones
	On Inscritos.codins = Calificaciones.codins
INNER JOIN Secciones
	On Inscritos.Sec = Secciones.Sec
INNER JOIN Profesores
	On Secciones.CodProfe = Profesores.CodProfe
Group by Inscritos.Sec 
GO

Sp_HelpText Resumen 
GO 

Select * From SysComments 
GO

DROP VIEW Relacion_de_Promedios
GO

Select * From Relacion_de_Promedios
GO

-- Funciones

drop function dbo.Suma
go

create function dbo.Suma (@a int, @b int)
returns int
as
begin
	declare @c int
	set @c = @a + @b
	return (select @c)
end
go

select dbo.Suma(2, 5)
go
