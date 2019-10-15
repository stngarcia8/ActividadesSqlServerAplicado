USE master;
GO
SET NOCOUNT ON;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO

-- Creando triggers para monitorizar acciones.
CREATE OR ALTER TRIGGER ddl_trig_database   
ON ALL SERVER   
FOR CREATE_DATABASE, drop_database    
AS   
BEGIN
    SET NOCOUNT ON;
    DECLARE @InfoEvento XML, @Objeto NVARCHAR(max);
    SET @InfoEvento = EVENTDATA();
    SET @Objeto = @InfoEvento.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'varchar(500)');
    PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + @Objeto + '.';
END;
GO



-- Creando la base de datos.
DROP DATABASE IF EXISTS [Seguros]
GO
CREATE DATABASE Seguros
ON PRIMARY 
(name='seguros_data', filename='/var/opt/mssql/data/seguros_data.mdf', 
size=30Mb, maxsize=60Mb, filegrowth=10Mb)
log ON
(name='seguros_log', filename='/var/opt/mssql/data/seguros_log.ldf', 
size=5Mb, maxsize=10Mb, filegrowth=1Mb)
GO
USE seguros;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO

-- Creando triggers para la base de datos y monitorizar los objetos creados.
CREATE TRIGGER trgDBMonitor ON DATABASE 
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE  
  AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InfoEvento XML,@Accion VARCHAR(500),@Objeto VARCHAR(500);
    SET @InfoEvento = EVENTDATA();
    SET @Accion = @InfoEvento.value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(500)');
    SET @Objeto = @InfoEvento.value('(/EVENT_INSTANCE/SchemaName)[1]', 'varchar(250)') 
                   +'.'
                   +@InfoEvento.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(250)');
    PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + @accion + ' ' + @Objeto + '.';
END;
GO




-- Creando tablas de la base de datos.
CREATE TABLE dbo.parentezco
(
    id_parentezco TINYINT     IDENTITY(1,1) PRIMARY KEY NOT NULL,
    parentezco    VARCHAR(25) NOT NULL
)
GO

CREATE TABLE dbo.sexo
(
    id_sexo TINYINT      IDENTITY(1,1) PRIMARY KEY NOT NULL,
    sexo    NVARCHAR(10) NOT NULL
)
GO

CREATE TABLE dbo.estado_civil
(
    id_estado_civil TINYINT      IDENTITY(1,1) PRIMARY KEY NOT NULL,
    estado_civil    NVARCHAR(12) NOT NULL
)
GO

CREATE TABLE dbo.enfermedad
(
    id_enfermedad     TINYINT      PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_enfermedad NVARCHAR(50) NOT NULL,
);
GO

CREATE TABLE dbo.seguro
(
    id_seguro     INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    codigo        NVARCHAR(25) NOT NULL,
    fecha_emision DATE         DEFAULT getdate() NOT NULL,
    creation_date DATETIME     DEFAULT getdate() NOT NULL,
    update_date   DATETIME
)
GO

CREATE TABLE dbo.informacion_adicional
(
    id_adicional     INT           PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_seguro        INT           NOT NULL,
    monto_asegurado  MONEY         DEFAULT 0 NOT NULL,
    plazo_prestamo   VARCHAR(15)   NOT NULL,
    posee_prestamo   BIT           DEFAULT 0 NOT NULL,
    plan_prestamo    NVARCHAR(50)  NOT NULL,
    motivo_prestamo  NVARCHAR(50),
    refinanciamiento BIT           DEFAULT 0 NOT NULL,
    detalle          NVARCHAR(100),
    creation_date    DATETIME      DEFAULT getdate() NOT NULL,
    update_date      DATETIME,
    CONSTRAINT seguro_infoadicional_fk FOREIGN KEY ( id_seguro)
    REFERENCES dbo.seguro ( id_seguro)
)
GO

CREATE TABLE dbo.beneficiario
(
    id_beneficiario  INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_sexo          TINYINT      NOT NULL,
    id_estado_civil  TINYINT      NOT NULL,
    tarjeta_id       NVARCHAR(25) NOT NULL,
    nombre           NVARCHAR(50) NOT NULL,
    profesion        NVARCHAR(20),
    direccion        NVARCHAR(50) NOT NULL,
    fecha_nacimiento DATE         NOT NULL,
    email            NVARCHAR(75),
    creation_date    DATETIME     DEFAULT getdate() NOT NULL,
    update_date      DATETIME,
    CONSTRAINT beneficiario_sexo_fk FOREIGN KEY ( id_sexo)
    REFERENCES dbo.sexo ( id_sexo),
    CONSTRAINT beneficiario_estadocivil_fk FOREIGN KEY ( id_estado_civil )
    REFERENCES dbo.estado_civil ( id_estado_civil)
)
GO

CREATE TABLE dbo.antecedentes_salud
(
    id_antecedente  TINYINT       PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_beneficiario INT           NOT NULL,
    id_enfermedad   TINYINT       NOT NULL,
    descripcion     NVARCHAR(100),
    creation_date   DATETIME      DEFAULT getdate() NOT NULL,
    update_date     DATETIME,
    CONSTRAINT salud_beneficiario_fk FOREIGN KEY ( id_beneficiario )
    REFERENCES dbo.beneficiario ( id_beneficiario ),
    CONSTRAINT salud_enfermedad_fk FOREIGN KEY ( id_enfermedad )
    REFERENCES dbo.enfermedad ( id_enfermedad )
)
GO

CREATE TABLE dbo.parientes
(
    id_pariente   SMALLINT     IDENTITY(1,1) PRIMARY KEY NOT NULL,
    id_parentezco TINYINT      NOT NULL,
    nombre        NVARCHAR(50) NOT NULL,
    distribucion  NVARCHAR(50),
    creation_date DATETIME     DEFAULT getdate() NOT NULL,
    update_date   DATETIME,
    CONSTRAINT pariente_parentezco_fk FOREIGN KEY ( id_parentezco)
    REFERENCES dbo.parentezco ( id_parentezco)
)
GO

CREATE TABLE dbo.beneficiario_parientes
(
    id_beneficiario INT      NOT NULL,
    id_pariente     SMALLINT NOT NULL,
    CONSTRAINT beneficiario_parientes_beneficiario_fk FOREIGN KEY ( id_beneficiario)
    REFERENCES dbo.beneficiario ( id_beneficiario),
    CONSTRAINT beneficiario_parientes_parientes_fk FOREIGN KEY ( id_pariente)
    REFERENCES dbo.parientes (id_pariente)
)
GO

CREATE TABLE dbo.cesionario
(
    id_cesionario TINYINT      IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombre        NVARCHAR(50) NOT NULL,
    relacion      NVARCHAR(25) NOT NULL,
    distribucion  NVARCHAR(50),
    creation_date DATETIME     DEFAULT getdate() NOT NULL,
    update_date   DATETIME
)
GO

CREATE TABLE dbo.beneficiario_cesionario
(
    id_beneficiario INT     NOT NULL,
    id_cesionario   TINYINT NOT NULL,
    CONSTRAINT beneficiario_cesionario_beneficiario_fk FOREIGN KEY ( id_beneficiario)
    REFERENCES dbo.beneficiario (id_beneficiario),
    CONSTRAINT beneficiario_cesionario_cesionario_fk FOREIGN KEY ( id_cesionario)
    REFERENCES dbo.cesionario ( id_cesionario)
)
GO

CREATE TABLE dbo.vendedor
(
    id_vendedor   INT          IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombre        NVARCHAR(50) NOT NULL,
    creation_date DATETIME     DEFAULT getdate() NOT NULL,
    update_date   DATETIME
)
GO

CREATE TABLE dbo.venta_seguro
(
    id_venta        INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_beneficiario INT          NOT NULL,
    id_seguro       INT          NOT NULL,
    id_vendedor     INT          NOT NULL,
    fecha_venta     DATE         DEFAULT getdate() NOT NULL,
    lugar           NVARCHAR(30) NOT NULL,
    creation_date   DATETIME     DEFAULT getdate() NOT NULL,
    update_date     DATETIME,
    CONSTRAINT venta_beneficiario_fk FOREIGN KEY ( id_beneficiario)
    REFERENCES dbo.beneficiario ( id_beneficiario),
    CONSTRAINT venta_seguro_fk FOREIGN KEY ( id_seguro)
    REFERENCES dbo.seguro (id_seguro),
    CONSTRAINT venta_vendedor_fk FOREIGN KEY ( id_vendedor)
    REFERENCES dbo.vendedor (id_vendedor)
)
GO




-- Insercion de datos.
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando parentezcos.';
INSERT INTO dbo.parentezco
    ([parentezco])
VALUES
    ('Padres'),
    ('Hijos'),
    ('Conyuge'),
    ('Abuelos'),
    ('Hermanos'),
    ('Tios');
GO


PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando sexos.';
INSERT INTO dbo.sexo
    ([sexo])
VALUES
    ('Femenino'),
    ('Masculino')
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando estados civiles.';
INSERT INTO dbo.estado_civil
    ([estado_civil])
VALUES
    ('Soltero'),
    ('Casado'),
    ('Viudo'),
    ('Divorciado');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando enfermedades.';
INSERT INTO dbo.enfermedad
    ([nombre_enfermedad])
VALUES
    ('Tiene cancer'),
    ('Tiene diabetes'),
    ('Tiene enfermedad coronaria'),
    ('Tiene epilepsia'),
    ('Posee tumores'),
    ('Problemas de presion arterial'),
    ('Tiene problemas a los riñones'),
    ('Tiene alguna enfermedad mental'),
    ('Problemas cerbro vascular'),
    ('Enfermedad a la prostata'),
    ('Problemas de aparato digestivo'),
    ('Problemas al utero u ovario'),
    ('otra enfermedad');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando seguros.';
INSERT INTO dbo.seguro
    ([codigo])
VALUES
    ('A001'),
    ('A002'),
    ('A003');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando información adicional de los seguros.';
INSERT INTO dbo.informacion_adicional
    ([id_seguro], [monto_asegurado], [plazo_prestamo], [posee_prestamo], [plan_prestamo], [motivo_prestamo], [refinanciamiento], [detalle])
VALUES
    (1, 5000000, '1 año', 0, 'Operacion urgencia', 'Operacion de urgencia digestiva', 0, 'Solicitando prestamo para operacion de urgencia de cirugia digestiva.'),
    (2, 3000000, '6 meses', 1, 'refinanciamiento operación', 'Operación de urgencia digestiva', 1, 'Solicitando prestamo para refinanciar operacion de urgencia de cirugia digestiva.'),
    (3, 15000000, '1 año', 0, 'Operacion programada', 'Operación cardio vascular', 0, 'Solicitando prestamo para operacion de inserción de cateter.');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando beneficiarios.';
INSERT INTO dbo.beneficiario
    ([id_sexo], [id_estado_civil], [tarjeta_id], [nombre], [profesion], [direccion], [fecha_nacimiento], [email])
VALUES
    (1, 2, 'X123456', 'Ana Lisa Melano Rojo', 'Contador', 'Las parcelas 44', '1975/09/29', 'ana.lisa.melano@gmail.com'),
    (2, 3, 'X654321', 'Sacarias Conchita Del Rio', 'Camionero', 'Las margaritas 88', '1965/02/15', 'camionerogeek@gmail.com');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando antecedentes de salud a los beneficiarios.';
INSERT INTO dbo.antecedentes_salud
    ([id_beneficiario], [id_enfermedad], [descripcion])
VALUES
    (1, 11, ''),
    (1, 13, 'Obesidad morbida'),
    (2, 3, ''),
    (2, 6, ''),
    (2, 13, 'Presuncion de paro cardiaco'),
    (2, 13, 'Esta chalao!');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando parientes a los beneficiarios.';
INSERT INTO dbo.parientes
    ([id_parentezco], [nombre], [distribucion])
VALUES
    (3, 'Juan Piña Angulo', 'Nada'),
    (2, 'Luis Piña Melano', '35% del seguro'),
    (2, 'Penelope Piña Melano', '35% del seguro'),
    (3, 'Zoila y la Vaca', '50% del seguro'),
    (2, 'Rosa Conchita y la Vaca', '50% del seguro')
    GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando relaciones de los parientes a los beneficiarios.';
INSERT INTO dbo.beneficiario_parientes
    ([id_beneficiario], [id_pariente])
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 4),
    (2, 5)
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando sesionarios a los beneficiarios.';
INSERT INTO dbo.cesionario
    ([nombre], [relacion], [distribucion])
VALUES
    ('Juan Carlos Aravena', 'Amante', '30% del seguro')
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Relacionando los cesionarios a los beneficiarios.';
INSERT INTO dbo.beneficiario_cesionario
    ([id_beneficiario], [id_cesionario])
VALUES
    (1, 1);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando vendedores.';
INSERT INTO dbo.vendedor
    ([nombre])
VALUES
    ('Armando Casas'),
    ('Ernesto Mador');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Agregando la venta de los seguros.';
INSERT INTO dbo.venta_seguro
    ([id_beneficiario], [id_seguro], [id_vendedor], [lugar])
VALUES
    (1, 1, 1, 'Oficina Mall Plaza Norte'),
    (1, 2, 1, 'Officina Mall Plaza Norte'),
    (2, 3, 2, 'Oficina Avenida Holanda 69');
GO

-- Terminando el script.
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Inserciones finalizadas.';
