-- Base de Datos: Clínica Veterinaria
-- Autora: Gabriela de Jesús Alvarado Rosales
-- Módulo: Bases de Datos Relacionales
-- Descripción: Script para crear la base de datos clinica veterinaria, 
--              tablas, insertar datos y ejecutar consultas.


-- =========================================
-- CREAR BASE DE DATOS
-- =========================================

CREATE DATABASE clinica_veterinaria;

-- =========================================
-- CREAR TABLAS
-- =========================================

CREATE TABLE Dueno (
    id_dueno INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20)
);

CREATE TABLE Profesional (
    id_profesional INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100)
);

CREATE TABLE Mascota (
    id_mascota INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    fecha_nacimiento DATE,
    id_dueno INT NOT NULL,
    FOREIGN KEY (id_dueno) REFERENCES Dueno(id_dueno)
);

CREATE TABLE Atencion (
    id_atencion INT PRIMARY KEY,
    fecha_atencion DATE NOT NULL,
    descripcion TEXT,
    id_mascota INT NOT NULL,
    id_profesional INT NOT NULL,
    FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
    FOREIGN KEY (id_profesional) REFERENCES Profesional(id_profesional)
);

-- =========================================
-- INSERTAR DATOS
-- =========================================

INSERT INTO Dueno (id_dueno, nombre, direccion, telefono)
VALUES
(1,'Juan Pérez','Calle Falsa 123','555-1234'),
(2,'Ana Gómez','Avenida Siempre Viva 456','555-5678'),
(3,'Carlos Ruiz','Calle 8 de Octubre 789','555-8765');

INSERT INTO Mascota (id_mascota, nombre, tipo, fecha_nacimiento, id_dueno)
VALUES
(1,'Rex','Perro','2020-05-10',1),
(2,'Luna','Gato','2019-02-20',2),
(3,'Fido','Perro','2021-03-15',3);

INSERT INTO Profesional (id_profesional, nombre, especialidad)
VALUES
(1,'Dr. Martínez','Veterinario'),
(2,'Dr. Pérez','Especialista en dermatología'),
(3,'Dr. López','Cardiólogo veterinario');

INSERT INTO Atencion (id_atencion, fecha_atencion, descripcion, id_mascota, id_profesional)
VALUES
(1,'2025-03-01','Chequeo general',1,1),
(2,'2025-03-05','Tratamiento dermatológico',2,2),
(3,'2025-03-07','Consulta cardiológica',3,3);

-- =========================================
-- CONSULTAS
-- =========================================

-- // DUEÑOS Y MASCOTAS //

SELECT Dueno.nombre AS dueno, Mascota.nombre AS mascota
FROM Dueno
JOIN Mascota ON Dueno.id_dueno = Mascota.id_dueno;

-- // ATENCIONES CON DETALLE DEL PROFESIONAL //

SELECT Mascota.nombre AS mascota,
       Profesional.nombre AS profesional,
       Atencion.fecha_atencion,
       Atencion.descripcion
FROM Atencion
JOIN Mascota ON Atencion.id_mascota = Mascota.id_mascota
JOIN Profesional ON Atencion.id_profesional = Profesional.id_profesional;

-- // # ATENCIONES POR PROFESIONAL //

SELECT Profesional.nombre AS profesional,
       COUNT(Atencion.id_atencion) AS total_atenciones
FROM Profesional
LEFT JOIN Atencion ON Profesional.id_profesional = Atencion.id_profesional
GROUP BY Profesional.nombre;

-- // ACTUALIZAR INFORMACION DE DUEÑO //

UPDATE Dueno
SET direccion = 'Nueva direccion'
WHERE nombre = 'Juan Pérez';

-- // ELIMINAR UNA ATENCIÓN //

DELETE FROM Atencion
WHERE id_atencion = 2;

-- // TRANSACCIÓN : AÑADIR MASCOTA, ATENCION Y ACTUALIZAR INFORMACION//

BEGIN;

INSERT INTO Mascota (id_mascota, nombre, tipo, fecha_nacimiento, id_dueno)
VALUES (4,'Botas','Gato','2012-10-12',2);

INSERT INTO Atencion (id_atencion, fecha_atencion, descripcion, id_mascota, id_profesional)
VALUES (4,'2025-04-15','Control anual y revisión general',4,1);

UPDATE Dueno
SET telefono = '666-6666'
WHERE id_dueno = 2;

COMMIT;


