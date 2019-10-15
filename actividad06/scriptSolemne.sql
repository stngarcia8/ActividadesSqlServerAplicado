-- Prueba nro.01
-- Ramo: Sql Server Aplicado.
-- Profesora: Andrea Silva.
-- Alumnos: Daniel Garcia, Ignacio Salazar.
-- Fecha entrega: 13/09/2019

USE MASTER;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a' + db_name() + '.';
GO

SET nocount ON;
GO

-- Creando base de datos.
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Creando base de datos de extranjeria.';
DROP DATABASE IF EXISTS EXTRANJERIA;
GO

CREATE DATABASE EXTRANJERIA 
ON PRIMARY
(
    name = 'extranjeria_data',
    filename = '/var/opt/mssql/data/extranjeria_data.mdf',
    size = 100Mb,
    maxsize = 200Mb,
    filegrowth = 30Mb
)
log ON
(
    name = 'extranjeria_log',
    filename = '/var/opt/mssql/data/extranjeria_log.ldf',
    size = 5Mb,
    maxsize = 10Mb,
    filegrowth = 1Mb
);
GO

USE EXTRANJERIA;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a' + db_name() + '.';
GO
-- Creando triggers para la base de datos y monitorizar los objetos creados.
CREATE TRIGGER trgMonitoreoCreacionDeTablas ON DATABASE 
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
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Creando tablas de la base de datos.';
CREATE TABLE dbo.departamento
(
    id_departamento     SMALLINT    IDENTITY(1,1) NOT NULL,
    nombre_departamento VARCHAR(12) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion      DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion  DATE,
    estado_registro     BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT departamento_pk PRIMARY KEY CLUSTERED ( id_departamento )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.administrativo
(
    id_administrativo  INT         IDENTITY(1,1) NOT NULL,
    id_departamento    SMALLINT    NOT NULL,
    rut_administrativo VARCHAR(10) NOT NULL,
    nombre             VARCHAR(25) NOT NULL,
    apellido_paterno   VARCHAR(25) NOT NULL,
    apellido_materno   VARCHAR(25) DEFAULT '',
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT rut_administrativo_un UNIQUE( rut_administrativo),
    CONSTRAINT administrativo_pk PRIMARY KEY CLUSTERED ( id_administrativo )
    WITH (
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT administrativo_departamento_fk FOREIGN KEY ( id_departamento )
        REFERENCES dbo.departamento ( id_departamento )
);
GO

CREATE TABLE dbo.region
(
    id_region          TINYINT     IDENTITY(1,1) NOT NULL,
    nombre_region      VARCHAR(50) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT region_pk PRIMARY KEY CLUSTERED ( id_region )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.ciudad
(
    id_ciudad          SMALLINT    IDENTITY(1,1) NOT NULL,
    id_region          TINYINT     NOT NULL,
    nombre_ciudad      VARCHAR(50) NOT NULL,
    -- Metadata de los registros.
    tfecha_creacion    DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT ciudad_pk PRIMARY KEY CLUSTERED ( id_ciudad )
    WITH (
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT ciudad_region_fk FOREIGN KEY ( id_region )
    REFERENCES dbo.region ( id_region )
);
GO

CREATE TABLE dbo.comuna
(
    id_comuna          SMALLINT    IDENTITY(1,1) NOT NULL,
    id_ciudad          SMALLINT    NOT NULL,
    nombre_comuna      VARCHAR(50) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT comuna_pk PRIMARY KEY CLUSTERED ( id_comuna)
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT comuna_ciudad_fk FOREIGN KEY ( id_ciudad )
    REFERENCES dbo.ciudad ( id_ciudad )

);
GO

CREATE TABLE dbo.actividad
(
    id_actividad          INT         IDENTITY(1,1) NOT NULL,
    descripcion_actividad VARCHAR(50) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion        DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion    DATE,
    estado_registro       BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT actividad_pk PRIMARY KEY CLUSTERED ( id_actividad )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.estado_civil
(
    id_estadocivil          TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_estadocivil VARCHAR(12) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion          DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion      DATE,
    estado_registro         BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT estadocivil_pk PRIMARY KEY CLUSTERED ( id_estadocivil )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.estado_solicitud
(
    id_estadosolicitud TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_estado VARCHAR(15) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT estado_solicitud_pk PRIMARY KEY CLUSTERED ( id_estadosolicitud )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.otorgante
(
    id_otorgante          TINYINT     IDENTITY(1,1) NOT NULL,
    codigo_otorgante      VARCHAR(10) NOT NULL,
    descripcion_otorgante VARCHAR(30) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion        DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion    DATE,
    estado_registro       BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT codigo_otorgante_un UNIQUE ( codigo_otorgante ),
    CONSTRAINT otorgante_pk PRIMARY KEY CLUSTERED ( id_otorgante )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.medio_contacto
(
    id_mediocontacto          TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_mediocontacto VARCHAR(15) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion            DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion        DATE,
    estado_registro           BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT mediocontacto_pk PRIMARY KEY CLUSTERED ( id_mediocontacto )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.pais
(
    id_pais            SMALLINT    IDENTITY(1,1) NOT NULL,
    nombre_pais        VARCHAR(50) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT pais_pk PRIMARY KEY CLUSTERED ( id_pais )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.parentezco
(
    id_parentezco          TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_parentezco VARCHAR(10) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion         DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion     DATE,
    estado_registro        BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT parentezco_pk PRIMARY KEY CLUSTERED ( id_parentezco )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.sexo
(
    id_sexo            TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_sexo   VARCHAR(10) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT sexo_pk PRIMARY KEY CLUSTERED ( id_sexo )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.tipo_padres
(
    id_tipopadres          TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_tipopadres VARCHAR(15) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion         DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion     DATE,
    estado_registro        BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT tipopadres_pk PRIMARY KEY CLUSTERED ( id_tipopadres )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.tipo_solicitud
(
    id_tiposolicitud          TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_tiposolicitud VARCHAR(50) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion            DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion        DATE,
    estado_registro           BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT tiposolicitud_pk PRIMARY KEY CLUSTERED ( id_tiposolicitud )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO
CREATE TABLE dbo.tipo_vinculo
(
    id_tipovinculo     TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_tipo   VARCHAR(20) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT tipovinculo_pk PRIMARY KEY CLUSTERED  ( id_tipovinculo )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.tipo_visa
(
    id_tipovisa          TINYINT     IDENTITY(1,1) NOT NULL,
    descripcion_tipovisa VARCHAR(35) NOT NULL,
    plazo_visa           VARCHAR(20) DEFAULT '',
    -- Metadata de los registros.
    fecha_creacion       DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion   DATE,
    estado_registro      BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT tipovisa_pk PRIMARY KEY CLUSTERED ( id_tipovisa )
    WITH(
        ALLOW_PAGE_LOCKS = ON , 
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.solicitante
(
    id_solicitante      INT          IDENTITY(1,1) NOT NULL,
    id_estadocivil      TINYINT      NOT NULL,
    id_pais             SMALLINT     NOT NULL,
    id_sexo             TINYINT      NOT NULL,
    cedula              VARCHAR(20)  DEFAULT '',
    rut_chileno         VARCHAR(10)  DEFAULT '',
    primer_apellido     VARCHAR(50)  NOT NULL,
    segundo_apellido    VARCHAR(50)  NOT NULL,
    nombres             VARCHAR(50)  NOT NULL,
    nacionalidad_actual VARCHAR(50)  NOT NULL,
    fecha_nacimiento    DATE         NOT NULL,
    profesion_oficio    VARCHAR(100) DEFAULT '',
    -- Desnormalizando para efectos de cuentas
    nro_acompanantes    TINYINT      DEFAULT 0 NOT NULL,
    -- Metadata de los registros.
    fecha_creacion      DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion  DATE,
    estado_registro     BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT solicitante_pk PRIMARY KEY CLUSTERED ( id_solicitante )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT estadocivil_solicitante_fk FOREIGN KEY (id_estadocivil)
    REFERENCES dbo.estado_civil (id_estadocivil),
    CONSTRAINT pais_solicitante_fk FOREIGN KEY (id_pais)
    REFERENCES dbo.pais (id_pais),
    CONSTRAINT sexo_solicitante_fk FOREIGN KEY (id_sexo)
    REFERENCES dbo.sexo (id_sexo)
);
GO

CREATE TABLE dbo.padres_solicitante
(
    id_padre            INT         IDENTITY(1,1) NOT NULL,
    id_tipopadres       TINYINT     NOT NULL,
    nombre              VARCHAR(50) NOT NULL,
    nacionalidad_origen VARCHAR(30) NOT NULL,
    nacionalidad_actual VARCHAR(30) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion      DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion  DATE,
    estado_registro     BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT padre_pk PRIMARY KEY CLUSTERED ( id_padre )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT padres_tipopaddres_fk FOREIGN KEY (id_tipopadres)
    REFERENCES dbo.tipo_padres (id_tipopadres)
);
GO

CREATE TABLE dbo.solicitante_padres
(
    id_solicitante     INT  NOT NULL,
    id_padre           INT  NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT  DEFAULT 1 NOT NULL,
    CONSTRAINT solicitante_padres_pk PRIMARY KEY CLUSTERED  ( id_solicitante, id_padre) 
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT solicitante_padresolicitante_fk FOREIGN KEY (id_solicitante)
    REFERENCES dbo.solicitante (id_solicitante),
    CONSTRAINT padre_padresolicitante_fk FOREIGN KEY (id_padre )
    REFERENCES dbo.padres_solicitante (id_padre),
);
GO

CREATE TABLE dbo.direccion_solicitante
(
    id_direccion       INT          IDENTITY(1,1) NOT NULL,
    id_solicitante     INT          NOT NULL,
    id_comuna          SMALLINT     NOT NULL,
    direccion          VARCHAR(100) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT direccion_solicitante_pk PRIMARY KEY ( id_direccion, id_solicitante)
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT direccionsolicitante_solicitante_fk FOREIGN KEY ( id_solicitante)
    REFERENCES dbo.solicitante ( id_solicitante ),
    CONSTRAINT direccionsolicitante_comuna_fk FOREIGN KEY ( id_comuna )
    REFERENCES dbo.comuna ( id_comuna )
);
GO

CREATE TABLE dbo.solicitante_mediocontacto
(
    id_contacto          INT          IDENTITY(1,1) NOT NULL,
    id_solicitante       INT          NOT NULL,
    id_mediocontacto     TINYINT      NOT NULL,
    descripcion_contacto VARCHAR(max) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion       DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion   DATE,
    estado_registro      BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT contacto_pk PRIMARY KEY CLUSTERED ( id_contacto )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT mediocontacto_solicitante_fk FOREIGN KEY ( id_solicitante )
    REFERENCES dbo.solicitante ( id_solicitante ),
    CONSTRAINT mediocontacto_mediocontacto_fk FOREIGN KEY ( id_mediocontacto )
    REFERENCES dbo.medio_contacto ( id_mediocontacto)
);
GO

CREATE TABLE dbo.dependiente
(
    id_dependiente     INT         IDENTITY(1,1) NOT NULL,
    cedula_dependiente VARCHAR(20) NOT NULL,
    nombre_dependiente VARCHAR(50) NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT dependiente_pk PRIMARY KEY CLUSTERED ( id_dependiente )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON )
);
GO

CREATE TABLE dbo.solicitante_dependiente
(
    id_solicitante     INT     NOT NULL,
    id_dependiente     INT     NOT NULL,
    id_parentezco      TINYINT NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE    DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT     DEFAULT 1 NOT NULL,
    CONSTRAINT solicitantedependiente_pk PRIMARY KEY CLUSTERED ( id_solicitante, id_dependiente )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT solicitantedependiente_solicitante_fk FOREIGN KEY ( id_solicitante )
    REFERENCES dbo.solicitante ( id_solicitante ),
    CONSTRAINT solicitantedependiente_dependiente_fk FOREIGN KEY ( id_dependiente )
    REFERENCES dbo.dependiente ( id_dependiente ),
    CONSTRAINT solicitantedependiente_parentezco_fk FOREIGN KEY ( id_parentezco )
    REFERENCES dbo.parentezco ( id_parentezco )
);
GO

CREATE TABLE dbo.residencia
(
    id_residencia      INT     IDENTITY(1,1) NOT NULL,
    id_solicitante     INT     NOT NULL,
    id_tipovisa        TINYINT NOT NULL,
    id_otorgante       TINYINT NOT NULL,
    es_titular         BIT     DEFAULT 0 NOT NULL,
    fecha_inicio       DATE    NOT NULL,
    fecha_termino      DATE,
    -- Metadata de los registros.
    fecha_creacion     DATE    DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT     DEFAULT 1 NOT NULL,
    CONSTRAINT residencia_pk PRIMARY KEY CLUSTERED ( id_residencia )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT residencia_solicitante_fk FOREIGN KEY ( id_solicitante )
    REFERENCES dbo.solicitante ( id_solicitante),
    CONSTRAINT residencia_tipovisa_fk FOREIGN KEY ( id_tipovisa )
    REFERENCES dbo.tipo_visa ( id_tipovisa ),
    CONSTRAINT residencia_otorgante_fk FOREIGN KEY ( id_otorgante )
    REFERENCES dbo.otorgante ( id_otorgante )
);
GO


CREATE TABLE dbo.institucion_vinculante
(
    id_institucion       INT         IDENTITY(1,1) NOT NULL,
    id_solicitante       INT         NOT NULL,
    rut_institucion      VARCHAR(10) NOT NULL,
    nombre_institucion   VARCHAR(50) NOT NULL,
    telefono_institucion VARCHAR(15) DEFAULT '',
    -- Metadata de los registros.
    fecha_creacion       DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion   DATE,
    estado_registro      BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT institucionvinculante_pk PRIMARY KEY CLUSTERED ( id_institucion )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT institucion_solicitante_fk FOREIGN KEY ( id_solicitante )
    REFERENCES dbo.solicitante ( id_solicitante )
);
GO

CREATE TABLE dbo.sancion
(
    id_sancion          INT         IDENTITY(1,1) NOT NULL,
    id_solicitante      INT         NOT NULL,
    descripcion_sancion VARCHAR(50) NOT NULL,
    autoridad           VARCHAR(30) NOT NULL,
    fecha_sancion       DATE        NOT NULL,
    -- Metadata de los registros.
    fecha_creacion      DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion  DATE,
    estado_registro     BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT sancion_pk PRIMARY KEY CLUSTERED ( id_sancion )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT sancion_solicitante_fk FOREIGN KEY ( id_sancion )
    REFERENCES dbo.solicitante ( id_solicitante )
);
GO

CREATE TABLE dbo.solicitud
(
    id_solicitud       INT         IDENTITY(1,1) NOT NULL,
    id_solicitante     INT         NOT NULL,
    id_tipovinculo     TINYINT     NOT NULL,
    id_tiposolicitud   TINYINT     NOT NULL,
    id_actividad       INT         NOT NULL,
    folio_solicitud    VARCHAR(25) NOT NULL,
    fecha_solicitud    DATE        NOT NULL,
    es_titular         BIT         DEFAULT 0 NOT NULL,
    -- Metadata de los registros.
    fecha_creacion     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT solicitud_pk PRIMARY KEY CLUSTERED ( id_solicitud )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT folio_solicitud_un UNIQUE ( folio_solicitud ),
    CONSTRAINT solicitud_solicitante_fk FOREIGN KEY ( id_solicitante )
    REFERENCES dbo.solicitante ( id_solicitante ),
    CONSTRAINT solicitud_tipovinculo_fk FOREIGN KEY ( id_tipovinculo )
    REFERENCES dbo.tipo_vinculo ( id_tipovinculo ),
    CONSTRAINT solicitud_tiposolicitud_fk FOREIGN KEY ( id_tiposolicitud )
    REFERENCES dbo.tipo_solicitud ( id_tiposolicitud),
    CONSTRAINT solicitud_actividad FOREIGN KEY ( id_actividad )
    REFERENCES dbo.actividad ( id_actividad )
);
GO

CREATE TABLE dbo.historial_solicitud
(
    id_historial       INT          IDENTITY(1,1) NOT NULL,
    id_solicitud       INT          NOT NULL,
    id_estadosolicitud TINYINT      NOT NULL,
    id_administrativo  INT          NOT NULL,
    fecha_proceso      DATE         NOT NULL,
    motivo_historial   VARCHAR(max) DEFAULT '',
    -- Metadata de los registros.
    fecha_creacion     DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT historialsolicitud_pk PRIMARY KEY CLUSTERED ( id_historial )
    WITH (
        ALLOW_PAGE_LOCKS = ON,
        ALLOW_ROW_LOCKS = ON ),
    CONSTRAINT historial_solicitud_fk FOREIGN KEY ( id_solicitud )
    REFERENCES dbo.solicitud  ( id_solicitud ),
    CONSTRAINT historial_estadosolicitud_fk FOREIGN KEY ( id_estadosolicitud )
    REFERENCES dbo.estado_solicitud ( id_estadosolicitud ) ,
    CONSTRAINT historial_administrativo_fk FOREIGN KEY ( id_administrativo )
    REFERENCES dbo.administrativo ( id_administrativo ),
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Creacion de base de datos ' + db_name() + ' finalizada.';
GO 
