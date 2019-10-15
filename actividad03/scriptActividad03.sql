USE master 
GO

-- Creando primera base de datos de prueba.
DROP DATABASE IF EXISTS prueba1;
GO
CREATE DATABASE prueba1 
GO
sp_helpdb prueba1
GO


-- Creando segunda base de datos de prueba.
DROP DATABASE IF EXISTS prueba2;
GO
CREATE DATABASE prueba2
ON PRIMARY 
(name='prueba2_data', filename='/var/opt/mssql/data/prueba2_data.mdf', size=10Mb, maxsize=20Mb, filegrowth=1Mb);
GO
sp_helpdb prueba2;
GO

-- Creando tercera base de datos de prueba.
DROP DATABASE IF EXISTS prueba3;
GO
CREATE DATABASE prueba3
ON PRIMARY 
(name='prueba3_data', filename='/var/opt/mssql/data/prueba3_data.mdf', size=15Mb, maxsize=30Mb, filegrowth=5Mb)
log ON 
(name='prueba3_log', filename='/var/opt/mssql/data/prueba3_log.ldf', size=5Mb, maxsize=10Mb, filegrowth=1Mb);
GO
sp_helpdb prueba3;
GO 



