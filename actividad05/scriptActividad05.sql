/*
Nota:
En caso de no tener las bases de datos de pruebas, usar el script de la actividad03.
*/

-- Cambiando a master.
USE master 
GO

-- Visualizando datos de la base de pruebas2.
sp_helpdb prueba2;

/* 
Resultados.
name	fileid	filename	filegroup	size	maxsize	growth	usage
prueba2_data	1	/var/opt/mssql/data/prueba2_data.mdf	PRIMARY	10240 KB	20480 KB	1024 KB	data only
prueba2_log	2	/var/opt/mssql/data/prueba2_log.ldf	NULL	8192 KB	2147483648 KB	65536 KB	log only
*/

-- Agregando el archivo de grupo.
ALTER DATABASE Prueba2  
ADD FILE  ( 
    NAME = Prueba2Sec_Data, FILENAME = '/var/opt/mssql/data/Prue2Data.ndf',SIZE = 5MB, MAXSIZE = 10MB, FILEGROWTH = 1MB
    ) 
GO

-- Visualizando los cambios en la base prueba2
sp_helpdb prueba2;

/* 
Resultados esperados.
name	fileid	filename	filegroup	size	maxsize	growth	usage
-- prueba2_data	1	/var/opt/mssql/data/prueba2_data.mdf	PRIMARY	10240 KB	20480 KB	1024 KB	data only
prueba2_log	2	/var/opt/mssql/data/prueba2_log.ldf	NULL	8192 KB	2147483648 KB	65536 KB	log only
Prueba2Sec_Data	3	/var/opt/mssql/data/Prue2Data.ndf	PRIMARY	5120 KB	10240 KB	1024 KB	data only
*/

-- Agregando 2 grupos de archivos.
ALTER DATABASE Prueba2 
ADD FILEGROUP Consultores
go 

ALTER DATABASE Prueba2 
ADD  FILEGROUP Operaciones 
GO 


-- Visualizando los cambios.
Sp_HelpFileGroup 

/*
Resultados:
groupname	groupid	filecount
PRIMARY	1	2
Consultores	2	0
Operaciones	3	0
*/
