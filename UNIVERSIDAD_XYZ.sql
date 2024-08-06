drop  database if exists UNIVERSIDAD_XYZ;
CREATE DATABASE UNIVERSIDAD_XYZ;
use UNIVERSIDAD_XYZ;

CREATE TABLE CARRERAS (id int auto_increment primary key,nombre_carrera varchar(200));
CREATE TABLE CURSOS(id int auto_increment primary key, nombre_curso varchar(200), catidad_creditos smallint,id_carreras int, constraint FK_carrera_cursos foreign key (id_carreras) references CARRERAS(id));
CREATE TABLE ESTUDIANTES(id int auto_increment primary key, nombre_estudiante varchar(200),sexo char(2),fecha_nacimiento date,id_carrera int, constraint FK_carrera_estudiante foreign key (id_carrera) references CARRERAS(id));
CREATE TABLE MATRICULA(id int auto_increment primary key, id_estudiante int, id_cursos int,fecha_matricula date,constraint FK_estudiante_matricula foreign key (id_estudiante)references ESTUDIANTES(id), constraint FK_matricula_cursos foreign key (id_cursos) references CURSOS(id));


-- Insertando datos en la tabla CARRERAS
insert into CARRERAS(nombre_carrera) VALUES
("INGENERIA DE SISTEMAS"),
("INGENIERIA CIVIL"),
("INGENIERIA DE SOFTWARE"),
("INGENIERIA MECANICA"),
("INGENIERIA ELECTRICA");

-- Insertando datos en la tabla CURSOS
insert into CURSOS(nombre_curso, catidad_creditos, id_carreras) VALUES
("PROGRAMACION", 3, 1),
("CALCULOS", 2, 2),
("PROGRAMACION AVANZADA", 2, 3),
("MATEMATICAS", 3, 2),
("FISICA", 1, 1),
("ALGEBRA", 2, 1),
("QUIMICA", 3, 4),
("ELECTRONICA", 2, 5);

-- Insertando datos en la tabla ESTUDIANTES
insert into ESTUDIANTES(nombre_estudiante, sexo, fecha_nacimiento, id_carrera) VALUES
("FABIO", "M", "1990/03/20", 2),
("MARIA", "F", "1989/03/20", 3),
("JHONATAN", "M", "1998/03/20", 1),
("CARLOS", "M", "1995/07/12", 4),
("ANA", "F", "1997/11/23", 5),
("LUCIA", "F", "1993/05/18", 3),
("PEDRO", "M", "1992/08/30", 2);

-- Insertando datos en la tabla MATRICULA
insert into MATRICULA(id_estudiante, id_cursos, fecha_matricula) values
(1, 2, "2024-02-22"),
(1, 3, "2024-02-22"),
(2, 3, "2024-02-22"),
(2, 1, "2024-02-22"),
(3, 1, "2024-02-22"),
(3, 4, "2024-02-22"),
(4, 7, "2024-02-22"),
(5, 8, "2024-02-22"),
(6, 3, "2024-02-22"),
(7, 2, "2024-02-22");

select *  from ESTUDIANTES AS E
JOIN CARRERAS AS C ON E.id_carrera = c.id
JOIN MATRICULA AS M ON M.id_estudiante = E.id
join CURSOS as CU ON CU.id = M.id_cursos;

-- CUANTOS CREDITOS TIENE EL ALUMNO Y DE QUE CARRERA ES.

select E.nombre_estudiante,C.nombre_carrera,SUM(catidad_creditos) AS CANTIDAD_CREDITOS_all  from ESTUDIANTES AS E
JOIN CARRERAS AS C ON E.id_carrera = c.id
JOIN MATRICULA AS M ON M.id_estudiante = E.id
join CURSOS as CU ON CU.id = M.id_cursos
GROUP BY E.nombre_estudiante, C.nombre_carrera;

-- EN QUE CURSO ESTAN 
select E.nombre_estudiante,CU.nombre_curso from ESTUDIANTES AS E
JOIN CARRERAS AS C ON E.id_carrera = c.id
JOIN MATRICULA AS M ON M.id_estudiante = E.id
join CURSOS as CU ON CU.id = M.id_cursos;
