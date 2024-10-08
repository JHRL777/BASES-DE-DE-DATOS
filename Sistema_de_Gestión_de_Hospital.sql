DROP DATABASE IF EXISTS HOSPITAL;
CREATE DATABASE HOSPITAL;
USE HOSPITAL;

CREATE TABLE DOCTORES (
    ID_DOCTOR INT AUTO_INCREMENT PRIMARY KEY,
    NOMBRE VARCHAR(255) NOT NULL,
    ESPECIALIDAD VARCHAR(255) NOT NULL
);

CREATE TABLE PACIENTES (
    ID_PACIENTE INT AUTO_INCREMENT PRIMARY KEY,
    NOMBRE VARCHAR(255) NOT NULL,
    FECHA_NACIMIENTO DATE,
    TELEFONO VARCHAR(50)
);

CREATE TABLE CITAS (
    ID_CITA INT AUTO_INCREMENT PRIMARY KEY,
    ID_DOCTOR INT,
    ID_PACIENTE INT,
    FECHA_CITA DATETIME,
    DESCRIPCION TEXT,
    CONSTRAINT FK_CITA_DOCTOR FOREIGN KEY (ID_DOCTOR) REFERENCES DOCTORES(ID_DOCTOR),
    CONSTRAINT FK_CITA_PACIENTE FOREIGN KEY (ID_PACIENTE) REFERENCES PACIENTES(ID_PACIENTE)
);

-- Insertar Doctores
INSERT INTO DOCTORES (NOMBRE, ESPECIALIDAD) VALUES 
('Dr. Juan Perez', 'Cardiología'),
('Dra. Ana Gomez', 'Dermatología'),
('Dr. Luis Martinez', 'Neurología');

-- Insertar Pacientes
INSERT INTO PACIENTES (NOMBRE, FECHA_NACIMIENTO, TELEFONO) VALUES 
('Carlos López', '1990-05-14', '555-1234'),
('María Rodriguez', '1985-07-19', '555-5678');

-- Insertar Citas
INSERT INTO CITAS (ID_DOCTOR, ID_PACIENTE, FECHA_CITA, DESCRIPCION) VALUES 
(1, 1, '2024-08-15 10:30:00', 'Consulta de cardiología'),
(2, 2, '2024-08-16 11:00:00', 'Revisión de piel');

-- vista
CREATE VIEW VISTA_CITAS_DOCTOR AS
SELECT D.NOMBRE AS DOCTOR, P.NOMBRE AS PACIENTE, C.FECHA_CITA, C.DESCRIPCION 
FROM CITAS C
JOIN DOCTORES D ON C.ID_DOCTOR = D.ID_DOCTOR
JOIN PACIENTES P ON C.ID_PACIENTE = P.ID_PACIENTE;

-- Consultar la vista
SELECT * FROM VISTA_CITAS_DOCTOR WHERE DOCTOR = 'Dr. Juan Perez';
-- trigger para registrar la fecha de modificación de una cita
DELIMITER //
CREATE TRIGGER TRIGGER_MODIFICACION_CITA
BEFORE UPDATE ON CITAS
FOR EACH ROW
BEGIN
    SET NEW.FECHA_CITA = NOW();
END //
DELIMITER ;

-- procedimiento almacenado para registrar una nueva cita
DELIMITER //
CREATE PROCEDURE NUEVA_CITA(
    IN p_id_doctor INT,
    IN p_id_paciente INT,
    IN p_fecha_cita DATETIME,
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO CITAS (ID_DOCTOR, ID_PACIENTE, FECHA_CITA, DESCRIPCION)
    VALUES (p_id_doctor, p_id_paciente, p_fecha_cita, p_descripcion);
END //
DELIMITER ;

-- Llamar al procedimiento
CALL NUEVA_CITA(1, 2, '2024-08-17 09:00:00', 'Chequeo general');

-- función para calcular la cantidad de citas de un doctor en un mes
DELIMITER //
CREATE FUNCTION CANTIDAD_CITAS_DOCTOR(p_id_doctor INT, p_mes INT, p_anio INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_citas INT;
    
    SELECT COUNT(*) INTO total_citas 
    FROM CITAS 
    WHERE ID_DOCTOR = p_id_doctor 
    AND MONTH(FECHA_CITA) = p_mes 
    AND YEAR(FECHA_CITA) = p_anio;
    
    RETURN total_citas;
END //
DELIMITER ;

-- Usar la función
SELECT CANTIDAD_CITAS_DOCTOR(1, 8, 2024) AS total_citas;


