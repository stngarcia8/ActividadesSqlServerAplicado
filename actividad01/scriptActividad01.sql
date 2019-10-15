SET NOCOUNT ON;
GO
USE master;
GO


-- Creando base de datos de casos de proyectos.
DROP DATABASE IF EXISTS CasoProyectos;
GO

CREATE DATABASE CasoProyectos;
GO

USE CasoProyectos;
GO


-- Creando tablas.
CREATE TABLE dbo.area
(
    id_area     TINYINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_area VARCHAR(30) NOT NULL
);
GO

CREATE TABLE dbo.campus
(
    id_campus     TINYINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_campus VARCHAR(20) NOT NULL
);
GO

CREATE TABLE dbo.cargo
(
    id_cargo     TINYINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_cargo VARCHAR(25) NOT NULL
);
GO

CREATE TABLE dbo.departamento
(
    id_depto   SMALLINT    PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_area    TINYINT     NOT NULL,
    fono_depto VARCHAR(15) NOT NULL,
    CONSTRAINT departamento_area_fk FOREIGN KEY ( id_area )
    REFERENCES dbo.area ( id_area )
);
GO

CREATE TABLE dbo.grupo
(
    id_grupo     INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_grupo VARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.moneda
(
    id_moneda    SMALLINT    PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre       VARCHAR(20) NOT NULL,
    nomenclatura VARCHAR(15) NOT NULL
);
GO

CREATE TABLE dbo.valor_moneda
(
    id_valor      INT      PRIMARY KEY IDENTITY(1,1) NOT NULL,
    fecha_inicio  DATE     NOT NULL,
    fecha_termino DATE,
    valor_cambio  MONEY    DEFAULT 0 NOT NULL,
    id_moneda     SMALLINT NOT NULL,
    CONSTRAINT valormoneda_moneda_fk FOREIGN KEY ( id_moneda )
    REFERENCES dbo.moneda ( id_moneda )
);
GO

CREATE TABLE dbo.programa
(
    id_programa INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre      VARCHAR(50)  NOT NULL,
    descripcion VARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.sede
(
    id_sede     TINYINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_sede VARCHAR(25) NOT NULL
);
GO

CREATE TABLE dbo.titulo
(
    id_titulo        TINYINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_titulo    VARCHAR(35) NOT NULL,
    fecha_titulacion DATE        NOT NULL
);
GO




CREATE TABLE dbo.financiamiento
(
    id_financiamiento    INT      PRIMARY KEY IDENTITY(1,1) NOT NULL,
    fecha_inicio         DATE     NOT NULL,
    monto_financiamiento MONEY    DEFAULT 0 NOT NULL,
    id_programa          INT      NOT NULL,
    id_moneda            SMALLINT NOT NULL,
    CONSTRAINT financiamiento_programa_fk FOREIGN KEY ( id_programa )
    REFERENCES dbo.programa ( id_programa ),
    CONSTRAINT financiamiento_moneda_fk FOREIGN KEY ( id_moneda )
    REFERENCES dbo.moneda ( id_moneda )
);
GO

CREATE TABLE dbo.proyecto
(
    id_proyecto       INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_proyecto   VARCHAR(50)  NOT NULL,
    descripcion       VARCHAR(100),
    fecha_inicio      DATE         NOT NULL,
    fecha_termino     DATE,
    id_financiamiento INT          NOT NULL,
    CONSTRAINT proyecto_financiamiento_fk FOREIGN KEY ( id_financiamiento )
    REFERENCES dbo.financiamiento ( id_financiamiento )
);
GO

CREATE TABLE dbo.presupuesto
(
    id_presupuesto INT  PRIMARY KEY IDENTITY(1,1) NOT NULL,
    fecha_presupuesto DATE NOT NULL,
    id_proyecto    INT  NOT NULL,
    CONSTRAINT presupuesto_proyecto_fk FOREIGN KEY ( id_proyecto )
    REFERENCES dbo.proyecto ( id_proyecto )
);

CREATE TABLE dbo.detalle_presupuesto
(
    id_detalle       SMALLINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_presupuesto   INT          NOT NULL,
    nombre_item      VARCHAR(50)  NOT NULL,
    desc_item        VARCHAR(100) NOT NULL,
    cant_item        SMALLINT     DEFAULT 0 NOT NULL,
    valunitario_item MONEY        DEFAULT 0 NOT NULL,
    CONSTRAINT detallepresup_presupuesto_fk FOREIGN KEY ( id_presupuesto )
    REFERENCES dbo.presupuesto ( id_presupuesto )
);
GO

CREATE TABLE dbo.profesor
(
    id_profesor SMALLINT    PRIMARY KEY IDENTITY(1,1) NOT NULL,
    rut         VARCHAR(10) NOT NULL,
    nombre      VARCHAR(25) NOT NULL,
    apaterno    VARCHAR(20) NOT NULL,
    amaterno    VARCHAR(20),
    habilitado  BIT         DEFAULT 1 NOT NULL
);
GO

CREATE TABLE dbo.profesor_cargo
(
    id_profesor SMALLINT NOT NULL,
    id_cargo    TINYINT  NOT NULL,
    CONSTRAINT profesor_cargo_pk PRIMARY KEY ( id_profesor, id_cargo ),
    CONSTRAINT profesorcargo_profesor_fk FOREIGN KEY ( id_profesor )
    REFERENCES dbo.profesor ( id_profesor ),
    CONSTRAINT profesorcargo_cargo_fk FOREIGN KEY ( id_cargo )
    REFERENCES dbo.cargo ( id_cargo )
);
GO

CREATE TABLE dbo.profesor_titulo
(
    id_profesor SMALLINT NOT NULL,
    id_titulo   TINYINT  NOT NULL,
    CONSTRAINT profesor_titulo_pk PRIMARY KEY ( id_profesor, id_titulo ),
    CONSTRAINT profesortitulo_profesor_fk FOREIGN KEY ( id_profesor )
    REFERENCES dbo.profesor ( id_profesor ),
    CONSTRAINT profesortitutlo_titulo_fk FOREIGN KEY ( id_titulo )
    REFERENCES dbo.titulo ( id_titulo )
);
GO

CREATE TABLE dbo.participaciones
(
    id_participacion INT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_grupo         INT     NOT NULL,
    eslider          BIT     DEFAULT 0 NOT NULL,
    horas_dedicacion TINYINT DEFAULT 0 NOT NULL
);
GO

CREATE TABLE dbo.participar_proyecto
(
    id_participacion INT NOT NULL,
    id_proyecto      INT NOT NULL,
    CONSTRAINT participar_proyecto_pk PRIMARY KEY ( id_participacion , id_proyecto),
    CONSTRAINT participacionproyecto_participacion_fk FOREIGN KEY ( id_participacion )
    REFERENCES dbo.participaciones ( id_participacion ),
    CONSTRAINT participacionesproyecto_proyecto FOREIGN KEY ( id_proyecto )
    REFERENCES dbo.proyecto ( id_proyecto )
);
GO

CREATE TABLE dbo.enrolamiento
(
    id_enrolamiento    INT      PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_profesor        SMALLINT NOT NULL,
    id_campus          TINYINT  NOT NULL,
    id_sede            TINYINT  NOT NULL,
    id_depto           SMALLINT NOT NULL,
    fecha_enrolamiento DATE     NOT NULL,
    CONSTRAINT enrolamiento_profesor_fk FOREIGN KEY ( id_profesor )
    REFERENCES dbo.profesor ( id_profesor ),
    CONSTRAINT enrolamiento_campus_fk FOREIGN KEY ( id_campus )
    REFERENCES dbo.campus ( id_campus ),
    CONSTRAINT enrolamiento_sede_fk FOREIGN KEY ( id_sede )
    REFERENCES dbo.sede ( id_sede ),
    CONSTRAINT enrolamiento_depto_fk FOREIGN KEY ( id_depto )
    REFERENCES dbo.departamento ( id_depto )
);
GO

CREATE TABLE dbo.enrolamiento_participaciones
(
    id_enrolamiento  INT NOT NULL,
    id_participacion INT NOT NULL,
    CONSTRAINT enrolamiento_participaciones_pk PRIMARY KEY  ( id_enrolamiento, id_participacion ),
    CONSTRAINT enrolpart_enrolamiento_fk FOREIGN KEY ( id_enrolamiento )
    REFERENCES dbo.enrolamiento ( id_enrolamiento ),
    CONSTRAINT enrolpart_participaciones_fk FOREIGN KEY ( id_participacion )
    REFERENCES dbo.participaciones ( id_participacion )
);
GO 


