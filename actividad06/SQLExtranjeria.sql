CREATE TABLE administrativo 
    (
     id_administrativo NUMERIC (30,30) NOT NULL , 
     nombre_completo VARCHAR (30) NOT NULL , 
     direccion VARCHAR (30) NOT NULL 
    )
GO

ALTER TABLE administrativo ADD CONSTRAINT administrativo_PK PRIMARY KEY CLUSTERED (id_administrativo)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Departamento 
    (
     id_departamneto VARCHAR (30) NOT NULL , 
     Pais_nacimiento_id_pais VARCHAR (30) NOT NULL , 
     administrativo_id_administrativo NUMERIC (30,30) NOT NULL 
    )
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    Departamento__IDX ON Departamento 
    ( 
     Pais_nacimiento_id_pais 
    ) 
GO

ALTER TABLE Departamento ADD CONSTRAINT Departamento_PK PRIMARY KEY CLUSTERED (id_departamneto)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
    GO

CREATE TABLE Estado_civil 
    (
     Pais_nacimiento_id_pais VARCHAR (30) NOT NULL , 
     Sexo_id_sexo VARCHAR (30) NOT NULL , 
     id_estadocivil NUMERIC (30,30) NOT NULL 
    )
GO 

CREATE UNIQUE NONCLUSTERED INDEX 
    Estado_civil__IDX ON Estado_civil 
    ( 
     Pais_nacimiento_id_pais 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    Estado_civil__IDXv1 ON Estado_civil 
    ( 
     Sexo_id_sexo 
    ) 
GO

ALTER TABLE Estado_civil ADD CONSTRAINT Estado_civil_PK PRIMARY KEY CLUSTERED (id_estadocivil)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
    GO

CREATE TABLE Pais_nacimiento 
    (
     id_pais VARCHAR (30) NOT NULL , 
     Nombre_pais VARCHAR (30) NOT NULL , 
     Departamento_id_departamneto VARCHAR (30) NOT NULL , 
     Estado_civil_id_estadocivil NUMERIC (30,30) NOT NULL 
    )
GO 

CREATE UNIQUE NONCLUSTERED INDEX 
    Pais_nacimiento__IDX ON Pais_nacimiento 
    ( 
     Departamento_id_departamneto 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    Pais_nacimiento__IDXv1 ON Pais_nacimiento 
    ( 
     Estado_civil_id_estadocivil 
    ) 
GO

ALTER TABLE Pais_nacimiento ADD CONSTRAINT Pais_nacimiento_PK PRIMARY KEY CLUSTERED (id_pais)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Sexo 
    (
     id_sexo VARCHAR (30) NOT NULL , 
     sexo VARCHAR (30) NOT NULL , 
     Estado_civil_id_estadocivil NUMERIC (30,30) NOT NULL 
    )
GO 

CREATE UNIQUE NONCLUSTERED INDEX 
    Sexo__IDX ON Sexo 
    ( 
     Estado_civil_id_estadocivil 
    ) 
GO

ALTER TABLE Sexo ADD CONSTRAINT Sexo_PK PRIMARY KEY CLUSTERED (id_sexo)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
    GO

CREATE TABLE Solicitante 
    (
     Rut NUMERIC (30,30) NOT NULL , 
     Nombre VARCHAR (30) NOT NULL , 
     Segundo_nombre VARCHAR (30) NOT NULL , 
     Apellido_paterno VARCHAR (30) NOT NULL , 
     apellido_materno VARCHAR (30) NOT NULL , 
     Solicitud_id_solicitud NUMERIC (30,30) NOT NULL , 
     Solicitud_administrativo_id_administrativo NUMERIC (30,30) NOT NULL , 
     Pais_nacimiento_id_pais VARCHAR (30) NOT NULL 
    )
GO

ALTER TABLE Solicitante ADD CONSTRAINT Solicitante_PK PRIMARY KEY CLUSTERED (Rut, Solicitud_id_solicitud, Solicitud_administrativo_id_administrativo)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
    GO

CREATE TABLE Solicitud 
    (
     id_solicitud NUMERIC (30,30) NOT NULL , 
     administrativo_id_administrativo NUMERIC (30,30) NOT NULL , 
     profesion VARCHAR (30) NOT NULL , 
     domicilio_chile VARCHAR (30) NOT NULL , 
     comuna VARCHAR (30) NOT NULL , 
     fijo_telefono NUMERIC (30,30) NOT NULL , 
     Telefono_celular NUMERIC (30,30) NOT NULL , 
     correo_electronico VARCHAR (30) NOT NULL , 
     n°_acompañante NUMERIC (30,30) NOT NULL , 
     N°_cedula NUMERIC (30,30) NOT NULL , 
     N°_pasaporte NUMERIC (30,30) NOT NULL , 
     tipo_visa VARCHAR (30) NOT NULL , 
     nacionalidad_actual VARCHAR (30) NOT NULL 
    )
GO

ALTER TABLE Solicitud ADD CONSTRAINT Solicitud_PK PRIMARY KEY CLUSTERED (id_solicitud, administrativo_id_administrativo)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
    GO

ALTER TABLE Departamento 
    ADD CONSTRAINT Departamento_administrativo_FK FOREIGN KEY 
    ( 
     administrativo_id_administrativo
    ) 
    REFERENCES administrativo 
    ( 
     id_administrativo 
    ) 
GO

ALTER TABLE Departamento 
    ADD CONSTRAINT Departamento_Pais_nacimiento_FK FOREIGN KEY 
    ( 
     Pais_nacimiento_id_pais
    ) 
    REFERENCES Pais_nacimiento 
    ( 
     id_pais 
    ) 
GO

ALTER TABLE Estado_civil 
    ADD CONSTRAINT Estado_civil_Pais_nacimiento_FK FOREIGN KEY 
    ( 
     Pais_nacimiento_id_pais
    ) 
    REFERENCES Pais_nacimiento 
    ( 
     id_pais 
    ) 
GO

ALTER TABLE Estado_civil 
    ADD CONSTRAINT Estado_civil_Sexo_FK FOREIGN KEY 
    ( 
     Sexo_id_sexo
    ) 
    REFERENCES Sexo 
    ( 
     id_sexo 
    ) 
GO

ALTER TABLE Pais_nacimiento 
    ADD CONSTRAINT Pais_nacimiento_Departamento_FK FOREIGN KEY 
    ( 
     Departamento_id_departamneto
    ) 
    REFERENCES Departamento 
    ( 
     id_departamneto 
    ) 
GO

ALTER TABLE Pais_nacimiento 
    ADD CONSTRAINT Pais_nacimiento_Estado_civil_FK FOREIGN KEY 
    ( 
     Estado_civil_id_estadocivil
    ) 
    REFERENCES Estado_civil 
    ( 
     id_estadocivil 
    ) 
GO

ALTER TABLE Sexo 
    ADD CONSTRAINT Sexo_Estado_civil_FK FOREIGN KEY 
    ( 
     Estado_civil_id_estadocivil
    ) 
    REFERENCES Estado_civil 
    ( 
     id_estadocivil 
    ) 
GO

ALTER TABLE Solicitante 
    ADD CONSTRAINT Solicitante_Pais_nacimiento_FK FOREIGN KEY 
    ( 
     Pais_nacimiento_id_pais
    ) 
    REFERENCES Pais_nacimiento 
    ( 
     id_pais 
    ) 
GO

ALTER TABLE Solicitante 
    ADD CONSTRAINT Solicitante_Solicitud_FK FOREIGN KEY 
    ( 
     Solicitud_id_solicitud, 
     Solicitud_administrativo_id_administrativo
    ) 
    REFERENCES Solicitud 
    ( 
     id_solicitud , 
     administrativo_id_administrativo 
    ) 
GO

ALTER TABLE Solicitud 
    ADD CONSTRAINT Solicitud_administrativo_FK FOREIGN KEY 
    ( 
     administrativo_id_administrativo
    ) 
    REFERENCES administrativo 
    ( 
     id_administrativo 
    ) 
GO