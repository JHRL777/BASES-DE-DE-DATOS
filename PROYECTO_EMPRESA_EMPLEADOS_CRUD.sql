-- crear base de empleados ok
-- crear base con auditoria cuando se elimine ok
-- calcular el sueldo total desde el sueldo neto ok
-- crear un procedure que solo deshabilite el empleado ok
-- crear una vista donde se pueda ver el empleado el cargo ok
-- crear un CRUD para  empleados. ok


drop database if exists empresa_jhrl;
create database empresa_jhrl;
use  empresa_jhrl;

create table cargos(id_cargo smallint auto_increment primary key,nombre_cargo varchar(200));
create table prestaciones(id_prestaciones int primary key auto_increment,pensiones decimal(10,3),salud decimal(10,3),bonos decimal(10,2));
create table empleados(id_empleado int primary key auto_increment,nombre varchar(100),id_cargo smallint,fecha_entrada date,salario_neto decimal(10,2), total_salario decimal(10,2), estado boolean default true, constraint FK_EMPLEADO_CARGO FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo));
create table auditoria_eliminado(id_eliminado int primary key auto_increment, id_empleado int,nombre varchar(100),id_cargo smallint,total_salario decimal(10,2),fecha_eliminado datetime);
create table vacaciones(id_vacaciones int primary key auto_increment, id_empleado int, fecha_inicio datetime, fecha_finalizar datetime, constraint FK_VACACIONES_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado));

-- creacion de vista para mejorar la legibilidad  de los empleados de la empreas reunionedo los datos de diferentes tablas.

create view empleados_jhrl as 
select e.id_empleado,e.nombre,c.nombre_cargo,e.total_salario,e.fecha_entrada from empleados as e
join cargos as c on c.id_cargo = e.id_cargo; 


-- crear trigger para cuando se elimine un datos en tabla  empleados pase a auditoria eliminados esto sucede automaticamente cuando se elimine un empleado. 
delimiter // 
create trigger auditoria_empleado_eliminado
after delete on empleados
for each row
begin
	insert into auditoria_eliminado(id_empleado, nombre, id_cargo, total_salario, fecha_eliminado)
		values (old.id_empleado, old.nombre, old.id_cargo, old.total_salario, now());	

end //
delimiter ;



-- CRUD
-- ANEXAR EMPLEADO CON MANEJO DE ERRORES A LA HORA DE INGRESAR UN DATO..
DROP procedure IF EXISTS insert_empleado;
delimiter //
create procedure insert_empleado(in p_nombre varchar(100),in p_id_cargo smallint,in p_fecha_entrada date,in p_salario_neto decimal(10,2),p_bono char(2))
begin
	declare v_pension decimal(10,3);
	declare v_salud decimal(10,3);
    declare v_bono decimal(10,2);
    declare v_salario_total decimal(10,2);
    declare v_cargo smallint;
    
    select id_cargo into v_cargo from cargos where id_cargo =  p_id_cargo;
    
    if v_cargo is not null then 
    
		SELECT pensiones, salud, bonos INTO v_pension, v_salud, v_bono
        FROM prestaciones
        LIMIT 1;
		
		IF p_bono = 'SI' THEN
            SET v_salario_total = p_salario_neto + (p_salario_neto * (v_pension + v_salud)) + v_bono;
        ELSE
            SET v_salario_total = p_salario_neto + (p_salario_neto * (v_pension + v_salud));
        END IF;
        
        insert into empleados(nombre, id_cargo, fecha_entrada, salario_neto, total_salario) values (p_nombre,p_id_cargo,p_fecha_entrada,p_salario_neto,v_salario_total);
        
	else 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cargo que colocaste no existe';
        
	end if;
    


end //

delimiter ;

-- eliminar empleado por el id
delimiter //
create procedure eliminar_empleado(p_id_empleado int)
begin
	delete from empleados where id_empleado = p_id_empleado;
end //

delimiter ;



-- actualizar cargo
drop procedure if exists actualizacion;
delimiter //
create procedure actualizacion(p_idempleado int, p_nuevoCargo smallint, p_nuevoSalario decimal(10,2),p_bono char(2))
begin
	declare v_pension decimal(10,3);
	declare v_salud decimal(10,3);
    declare v_bono decimal(10,2);
	declare v_salario_total decimal(10,2);
    declare v_cargo smallint;
    declare v_empleado smallint;
    
    select id_cargo into v_cargo from cargos where id_cargo =  p_nuevoCargo;
    select id_empleado into v_empleado  from empleados where id_empleado = p_idempleado; 
    
    
    if v_cargo is not null and v_empleado is not null  then 
    
		SELECT pensiones, salud, bonos INTO v_pension, v_salud, v_bono
			FROM prestaciones
			LIMIT 1;
		
		IF p_bono = 'SI' THEN
				SET v_salario_total = p_nuevoSalario + (p_nuevoSalario * (v_pension + v_salud)) + v_bono;
			ELSE
				SET v_salario_total = p_nuevoSalario + (p_nuevoSalario * (v_pension + v_salud));
			END IF;
            
		UPDATE empleados
		set id_cargo = p_nuevoCargo, salario_neto = p_nuevoSalario, total_salario = v_salario_total
		 where id_empleado = p_idempleado; 
	else 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cargo que colocaste no existe o el empleado no existe validar';
        
	end if;
end //

delimiter ;


-- desactivar usuario
drop procedure if exists desactivar_empleado;
delimiter //
create procedure desactivar_empleado(p_idempleado int, p_estado boolean)
begin
	
    
    declare v_empleado smallint;
    
    
    select id_empleado into v_empleado  from empleados where id_empleado = p_idempleado; 
    if v_empleado is not null  then 
               
		UPDATE empleados
		set estado = p_estado
		 where id_empleado = p_idempleado; 
	else 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'el id del empleado que coloco no existe validar';
        
	end if;
end //

delimiter ;






-- Insertar datos en la tabla de cargos
INSERT INTO cargos (nombre_cargo) VALUES 
('Gerente'),
('Desarrollador'),
('Analista de Sistemas'),
('Administrador de Base de Datos'),
('Soporte Técnico');


-- Insertar datos en la tabla de prestaciones
INSERT INTO prestaciones (pensiones, salud, bonos) VALUES 
(0.095, 0.095, 30000);

--   PARA UTILOZAR LOS CRUD CON PROCEDURE

-- Insertar datos en la tabla de empleados
-- SE INSERTA DE LA SIGUIENTE MANERA  insert_empleado(NOMBRE ENMPLEADO,ID DEL CARGO,FECHA QUE INGRESO,SALARIO NETO,Y SI TIENE BONO TIENE QUE SOLOCAR UNA DE LAS DOS "SI" O "NO");
call  insert_empleado("Juan",1,'2020-05-15',250000,"SI");
call  insert_empleado('Carlos Pérez', 1, '2020-05-15', 250000, "SI");
call  insert_empleado('Laura Gómez', 2, '2021-03-22', 180000, "NO");
call  insert_empleado('Juan Rodríguez', 3, '2019-08-10', 200000, "SI");
call  insert_empleado('Marta Suárez', 4, '2022-07-01', 220000, "NO");
call  insert_empleado('Pedro Ríos', 5, '2023-01-10', 150000,"SI");


-- para desactivar el usuario primero coloca el id empleado luego 1 es activo 0 desactivado call desactivar_empleado(id empleado,"0" es desactivado o "1" es activado);
call desactivar_empleado(3,0);



-- debe colocar el id del empleado call eliminar_empleado(id_empleado);
call eliminar_empleado(1);

-- actualizar el cargo actualizacion(p_idempleado int, p_nuevoCargo smallint, p_nuevoSalario decimal(10,2),p_bono char(2)) EN BONO SE COLOCAR "SI" O "NO"
call actualizacion(3,1,500000,"SI");









-- Insertar datos en la tabla de vacaciones
INSERT INTO vacaciones (id_empleado, fecha_inicio, fecha_finalizar) VALUES 
(3, '2024-08-01 08:00:00', '2024-08-15 17:00:00'),
(4, '2024-09-01 08:00:00', '2024-09-10 17:00:00');


