CREATE TABLE ROLES(
idRoles SERIAL,
tipo VARCHAR(20),
PRIMARY KEY(idRoles)
);

SELECT *FROM ROLES;

CREATE TABLE USUARIOS(
idUsuarios SERIAL,
idRoles INT,
correo VARCHAR(30) UNIQUE NOT NULL,
password VARCHAR(10) UNIQUE NOT NULL,
PRIMARY KEY(idUsuarios),
FOREIGN KEY(idRoles) REFERENCES ROLES(idRoles)
);

SELECT *FROM USUARIOS;

CREATE TABLE EMPLEADOS(
idEmpleados SERIAL,
idUsuarios INT,
fecha_nac DATE NOT NULL,
nombre VARCHAR(30) NOT NULL,
apPaterno VARCHAR(30) NOT NULL,
apMaterno VARCHAR(30) NOT NULL,
telefono VARCHAR(10) NOT NULL,
PRIMARY KEY(idEmpleados),
FOREIGN KEY(idUsuarios) REFERENCES USUARIOS(idUsuarios)
);
SELECT *FROM EMPLEADOS;

CREATE TABLE PACIENTES(
idPacientes SERIAL,
idUsuarios INT,
fecha_nac DATE NOT NULL,
nombre VARCHAR(30) NOT NULL,
apPaterno VARCHAR(30)NOT NULL,
apMaterno VARCHAR(30),
telefono VARCHAR(10) NOT NULL,
PRIMARY KEY(idPacientes),
FOREIGN KEY(idUsuarios) REFERENCES USUARIOS(idUsuarios));
SELECT *FROM PACIENTES;

CREATE TABLE VENTAS(
idVentas SERIAL,
idPacientes INT,
idEmpleados INT,
fecha_compra DATE NOT NULL,
total DOUBLE PRECISION NOT NULL,
PRIMARY KEY(idVentas),
FOREIGN KEY(idPacientes)REFERENCES PACIENTES(idPacientes),
FOREIGN KEY(idEmpleados)REFERENCES EMPLEADOS(idEmpleados)
);
SELECT *FROM VENTAS;

CREATE TABLE TIPO_SERVICIOS(
idTipoSer SERIAL,
tipo VARCHAR(20) NOT NULL,
PRIMARY KEY(idTipoSer)
);
SELECT *FROM TIPO_SERVICIOS;

CREATE TABLE SERVICIOS(
idServicios SERIAL,
idTipoSer INT,
nombre VARCHAR(30) NOT NULL,
precio DOUBLE PRECISION NOT NULL,
PRIMARY KEY(idServicios),
FOREIGN KEY(idTipoSer)REFERENCES TIPO_SERVICIOS(idTipoSer)
);
SELECT *FROM SERVICIOS;

CREATE TABLE CONSTAN(
idServicios INT,
idVentas INT,
cantidad VARCHAR(20) NOT NULL,
FOREIGN KEY(idServicios)REFERENCES SERVICIOS(idServicios),
FOREIGN KEY(idVentas)REFERENCES VENTAS(idVentas)
);
SELECT *FROM CONSTAN;

CREATE TABLE CITAS(
idCitas SERIAL,
idServicios INT,
idPacientes INT,
idEmpleados INT,
descripción VARCHAR(150) NOT NULL,
hora TIME(6) NOT NULL,
fecha_cita DATE NOT NULL,
PRIMARY KEY(idCitas),
FOREIGN KEY(idServicios)REFERENCES SERVICIOS(idServicios),
FOREIGN KEY(idPacientes)REFERENCES PACIENTES(idPacientes),
FOREIGN KEY(idEmpleados) REFERENCES EMPLEADOS(idEmpleados)
);
SELECT *FROM CITAS;

CREATE TABLE TIPO_PRODUCTOS(
idTipoPro SERIAL,
tipo VARCHAR(20) NOT NULL,
PRIMARY KEY(idTipoPro)
);
SELECT *FROM TIPO_PRODUCTOS;

CREATE TABLE PRODUCTOS(
idProductos SERIAL,
idTipoPro INT,
precio DOUBLE PRECISION NOT NULL,
nombre VARCHAR(30) NOT NULL,
PRIMARY KEY(idProductos),
FOREIGN KEY(idTipoPro) REFERENCES TIPO_PRODUCTOS(idTipoPro)
);
SELECT *FROM PRODUCTOS;

CREATE TABLE INCLUYEN(
idVentas INT,
idProductos INT,
cantidad VARCHAR(20) NOT NULL,
FOREIGN KEY(idVentas)REFERENCES VENTAS(idVentas),
FOREIGN KEY(idProductos)REFERENCES PRODUCTOS(idProductos)
);
SELECT *FROM INCLUYEN;

/*-------------------------------------------------------------------------*/

CREATE TABLE BITACORA_ROLES(
    timestamp_ TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	idRol INTEGER,
    nombre_disparador text,
    tipo_disparador text,
    nivel_disparador text,
    comando text
);

CREATE OR REPLACE FUNCTION Grabar_Operaciones() RETURNS TRIGGER AS $Grabar_Operaciones$
	DECLARE
	BEGIN 
	
		INSERT INTO BITACORA_ROLES(
					idRol,
					nombre_disparador,
					tipo_disparador,
					nivel_disparador,
					comando)
			VALUES(
					New.idRol,
					TG_NAME,
					TG_WHEN,
					TG_LEVEL,
					TG_OP
					);
		RETURN NEW;
	END;
$Grabar_Operaciones$ LANGUAGE plpgsql;
	
CREATE TRIGGER Grabar_Operaciones
AFTER INSERT OR UPDATE OR DELETE
ON ROLES FOR EACH ROW
EXECUTE PROCEDURE Grabar_Operaciones();

BEGIN
INSERT INTO ROLES(tipo)
VALUES('Administrador'),
('Empleado'),
('Paciente');
COMMIT;
ROLLBACK;
SELECT *FROM BITACORA_ROLES;

SELECT *FROM ROLES;
/*--------------------------*/

CREATE TABLE BITACORA_USUARIOS(
    timestamp_ TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	idUsuario INTEGER,
    nombre_disparador text,
    tipo_disparador text,
    nivel_disparador text,
    comando text
);
DROP FUNCTION grabar_operaciones CASCADE;
CREATE OR REPLACE FUNCTION grabar_operaciones() RETURNS TRIGGER AS $grabar_operaciones$
	DECLARE
	BEGIN 
	
		INSERT INTO BITACORA_USUARIOS(
					IdUsuario,
					nombre_disparador,
					tipo_disparador,
					nivel_disparador,
					comando)
			VALUES(
					New.idUsuario,
					TG_NAME,
					TG_WHEN,
					TG_LEVEL,
					TG_OP
					);
		RETURN NEW;
	END;
$grabar_operaciones$ LANGUAGE plpgsql;
	
CREATE TRIGGER grabar_operaciones
AFTER INSERT OR UPDATE OR DELETE
ON USUARIOS FOR EACH ROW
EXECUTE PROCEDURE grabar_operaciones();

BEGIN
INSERT INTO USUARIOS(idRoles,correo,password)
VALUES(1,'josenaredo01@gmail.com',PGP_SYM_ENCRYPT('C@rl0sNa1234','AES_KEY'));
COMMIT;
ROLLBACK;
SELECT *FROM BITACORA_USUARIOS;

SELECT *FROM USUARIOS;
/*---------------------*/

CREATE TABLE BITACORA_EMPLEADOS(
    timestamp_ TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	idEmpleado INTEGER,
    nombre_disparador text,
    tipo_disparador text,
    nivel_disparador text,
    comando text
);

CREATE OR REPLACE FUNCTION Grabar_operaciones() RETURNS TRIGGER AS $Grabar_operaciones$
	DECLARE
	BEGIN 
	
		INSERT INTO BITACORA_EMPLEADOS(
					idEmpleado,
					nombre_disparador,
					tipo_disparador,
					nivel_disparador,
					comando)
			VALUES(
					New.idEmpleado,
					TG_NAME,
					TG_WHEN,
					TG_LEVEL,
					TG_OP
					);
		RETURN NEW;
	END;
$Grabar_operaciones$ LANGUAGE plpgsql;
	
CREATE TRIGGER Grabar_operaciones
AFTER INSERT OR UPDATE OR DELETE
ON EMPLEADOS FOR EACH ROW
EXECUTE PROCEDURE Grabar_operaciones();

BEGIN
INSERT INTO EMPLEADOS(idUsuario,fecha_nac,nombre,apPaterno,apMaterno,telefono)
VALUES('Administrador');
COMMIT;
ROLLBACK;
SELECT *FROM BITACORA_EMPLEADOS;

SELECT *FROM EMPLEADOS;
/*--------------------*/





