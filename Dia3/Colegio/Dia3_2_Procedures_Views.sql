-- 1. Procedimiento para insertar un alumno
CREATE OR REPLACE FUNCTION insertar_alumno(
    nombre VARCHAR,
    apellido1 VARCHAR,
    apellido2 VARCHAR,
    fecha_nacimiento DATE,
    nif VARCHAR,
    sexo CHAR,
    telefono VARCHAR DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO persona (nombre, apellido1, apellido2, fecha_nacimiento, nif, sexo, tipo, telefono)
    VALUES (nombre, apellido1, apellido2, fecha_nacimiento, nif, sexo, 'alumno', telefono);
END;
$$ LANGUAGE plpgsql;

-- 2. Procedimiento para actualizar los datos de un alumno
CREATE OR REPLACE FUNCTION actualizar_alumno(
    id_alumno INT,
    nuevo_nombre VARCHAR,
    nuevo_apellido1 VARCHAR,
    nuevo_apellido2 VARCHAR,
    nueva_fecha_nacimiento DATE,
    nuevo_nif VARCHAR,
    nuevo_telefono VARCHAR
)
RETURNS VOID AS $$
BEGIN
    UPDATE persona
    SET nombre = nuevo_nombre,
        apellido1 = nuevo_apellido1,
        apellido2 = nuevo_apellido2,
        fecha_nacimiento = nueva_fecha_nacimiento,
        nif = nuevo_nif,
        telefono = nuevo_telefono
    WHERE id = id_alumno AND tipo = 'alumno';
END;
$$ LANGUAGE plpgsql;

-- 3. Procedimiento para buscar profesores sin departamento asignado
CREATE OR REPLACE FUNCTION buscar_profesores_sin_departamento()
RETURNS TABLE(id INT, nombre VARCHAR, apellido1 VARCHAR, apellido2 VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.nombre, p.apellido1, p.apellido2
    FROM persona p
    LEFT JOIN profesor prof ON p.id = prof.id_profesor
    WHERE p.tipo = 'profesor' AND prof.id_departamento IS NULL;
END;
$$ LANGUAGE plpgsql;

-- 4. Procedimiento para eliminar un alumno por su ID
CREATE OR REPLACE FUNCTION eliminar_alumno(id_alumno INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM persona WHERE id = id_alumno AND tipo = 'alumno';
END;
$$ LANGUAGE plpgsql;

-- 5. Procedimiento para insertar un profesor
CREATE OR REPLACE FUNCTION insertar_profesor(
    nombre VARCHAR,
    apellido1 VARCHAR,
    apellido2 VARCHAR,
    fecha_nacimiento DATE,
    nif VARCHAR,
    sexo CHAR,
    telefono VARCHAR DEFAULT NULL,
    id_departamento INT DEFAULT NULL
)
RETURNS VOID AS $$
DECLARE
    nuevo_id_profesor INT;
BEGIN
    INSERT INTO persona (nombre, apellido1, apellido2, fecha_nacimiento, nif, sexo, tipo, telefono)
    VALUES (nombre, apellido1, apellido2, fecha_nacimiento, nif, sexo, 'profesor', telefono)
    RETURNING id INTO nuevo_id_profesor;
    
    INSERT INTO profesor (id_profesor, id_departamento)
    VALUES (nuevo_id_profesor, id_departamento);
END;
$$ LANGUAGE plpgsql;

-- 6. Procedimiento para actualizar la información de un profesor
CREATE OR REPLACE FUNCTION actualizar_profesor(
    id_profesor INT,
    nuevo_nombre VARCHAR,
    nuevo_apellido1 VARCHAR,
    nuevo_apellido2 VARCHAR,
    nueva_fecha_nacimiento DATE,
    nuevo_nif VARCHAR,
    nuevo_telefono VARCHAR,
    nuevo_id_departamento INT
)
RETURNS VOID AS $$
BEGIN
    UPDATE persona
    SET nombre = nuevo_nombre,
        apellido1 = nuevo_apellido1,
        apellido2 = nuevo_apellido2,
        fecha_nacimiento = nueva_fecha_nacimiento,
        nif = nuevo_nif,
        telefono = nuevo_telefono
    WHERE id = id_profesor AND tipo = 'profesor';

    UPDATE profesor
    SET id_departamento = nuevo_id_departamento
    WHERE id_profesor = id_profesor;
END;
$$ LANGUAGE plpgsql;

-- 7. Procedimiento para insertar una asignatura
CREATE OR REPLACE FUNCTION insertar_asignatura(
    nombre VARCHAR,
    creditos FLOAT,
    tipo CHAR,
    curso INT,
    cuatrimestre INT,
    id_profesor INT,
    id_grado INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO asignatura (nombre, creditos, tipo, curso, cuatrimestre, id_profesor, id_grado)
    VALUES (nombre, creditos, tipo, curso, cuatrimestre, id_profesor, id_grado);
END;
$$ LANGUAGE plpgsql;

-- 8. Procedimiento para eliminar un profesor
CREATE OR REPLACE FUNCTION eliminar_profesor(id_profesor INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM profesor WHERE id_profesor = id_profesor;
    DELETE FROM persona WHERE id = id_profesor AND tipo = 'profesor';
END;
$$ LANGUAGE plpgsql;

-- 9. Procedimiento para buscar todas las asignaturas de un grado
CREATE OR REPLACE FUNCTION buscar_asignaturas_por_grado(id_grado INT)
RETURNS TABLE(id INT, nombre VARCHAR, creditos FLOAT, tipo CHAR, curso INT, cuatrimestre INT) AS $$
BEGIN
    RETURN QUERY
    SELECT id, nombre, creditos, tipo, curso, cuatrimestre
    FROM asignatura
    WHERE id_grado = id_grado;
END;
$$ LANGUAGE plpgsql;

-- 10. Procedimiento para insertar un departamento
CREATE OR REPLACE FUNCTION insertar_departamento(nombre VARCHAR)
RETURNS VOID AS $$
BEGIN
    INSERT INTO departamento (nombre)
    VALUES (nombre);
END;
$$ LANGUAGE plpgsql;


------ vistas --------------------- :)

-- 1. Vista de todos los alumnos con sus datos básicos
CREATE OR REPLACE VIEW vista_alumnos AS
SELECT id, nombre, apellido1, apellido2, fecha_nacimiento, nif, sexo, telefono
FROM persona
WHERE tipo = 'alumno';

-- 2. Vista de todos los profesores con sus departamentos
CREATE OR REPLACE VIEW vista_profesores_departamentos AS
SELECT p.id AS id_profesor, p.nombre, p.apellido1, p.apellido2, d.nombre AS nombre_departamento
FROM persona p
LEFT JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN departamento d ON prof.id_departamento = d.id
WHERE p.tipo = 'profesor';

-- 3. Vista de todas las asignaturas con información de los grados y profesores
CREATE OR REPLACE VIEW vista_asignaturas_grados_profesores AS
SELECT a.id, a.nombre AS nombre_asignatura, g.nombre AS nombre_grado, p.nombre AS nombre_profesor
FROM asignatura a
LEFT JOIN grado g ON a.id_grado = g.id
LEFT JOIN profesor prof ON a.id_profesor = prof.id_profesor
LEFT JOIN persona p ON prof.id_profesor = p.id;

-- 4. Vista de alumnos matriculados en cada curso escolar
CREATE OR REPLACE VIEW vista_alumnos_por_curso_escolar AS
SELECT ce.anyo_inicio, ce.anyo_fin, COUNT(asa.id_alumno) AS total_alumnos
FROM curso_escolar ce
LEFT JOIN alumno_se_matricula_asignatura asa ON ce.id = asa.id_curso_escolar
GROUP BY ce.anyo_inicio, ce.anyo_fin;

-- 5. Vista de profesores sin asignaturas asignadas
CREATE OR REPLACE VIEW vista_profesores_sin_asignaturas AS
SELECT p.id, p.nombre, p.apellido1, p.apellido2
FROM persona p
LEFT JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor' AND a.id_profesor IS NULL;

-- 6. Vista de asignaturas sin profesor asignado
CREATE OR REPLACE VIEW vista_asignaturas_sin_profesor AS
SELECT a.id, a.nombre AS nombre_asignatura, g.nombre AS nombre_grado
FROM asignatura a
LEFT JOIN grado g ON a.id_grado = g.id
WHERE a.id_profesor IS NULL;

-- 7. Vista de profesores con el número de asignaturas que imparten
CREATE OR REPLACE VIEW vista_numero_asignaturas_por_profesor AS
SELECT p.id AS id_profesor, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS numero_asignaturas
FROM persona p
LEFT JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor'
GROUP BY p.id, p.nombre, p.apellido1, p.apellido2;

-- 8. Vista de asignaturas por grado
CREATE OR REPLACE VIEW vista_asignaturas_por_grado AS
SELECT g.id AS id_grado, g.nombre AS nombre_grado, COUNT(a.id) AS numero_asignaturas
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id, g.nombre;

-- 9. Vista de departamentos sin profesores asociados
CREATE OR REPLACE VIEW vista_departamentos_sin_profesores AS
SELECT d.id, d.nombre AS nombre_departamento
FROM departamento d
LEFT JOIN profesor prof ON d.id = prof.id_departamento
WHERE prof.id_departamento IS NULL;

-- 10. Vista de cursos escolares con el número de alumnos matriculados
CREATE OR REPLACE VIEW vista_cursos_con_alumnos AS
SELECT ce.id, ce.anyo_inicio, ce.anyo_fin, COUNT(asa.id_alumno) AS numero_alumnos
FROM curso_escolar ce
LEFT JOIN alumno_se_matricula_asignatura asa ON ce.id = asa.id_curso_escolar
GROUP BY ce.id, ce.anyo_inicio, ce.anyo_fin;

