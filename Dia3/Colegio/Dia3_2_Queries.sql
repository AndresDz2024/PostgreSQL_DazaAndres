-- Consultas sobre una tabla

-- 1. Listado de alumnos ordenado alfabéticamente.
SELECT apellido1, apellido2, nombre 
FROM persona 
WHERE tipo = 'alumno' 
ORDER BY apellido1, apellido2, nombre;

-- 2. Alumnos sin número de teléfono.
SELECT nombre, apellido1, apellido2 
FROM persona 
WHERE tipo = 'alumno' AND telefono IS NULL;
-- no hay ningún alumnoo que no tenga número de teléfono

-- 3. Listado de alumnos nacidos en 1999.
SELECT * 
FROM persona 
WHERE tipo = 'alumno' AND EXTRACT(YEAR FROM fecha_nacimiento) = 1999;
-- no hay ningún alumno que haya nacido en 1999

-- 4. Profesores sin teléfono cuyo NIF termina en 'K'.
SELECT * 
FROM persona 
WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%K';
-- ningún profesor no tiene numero de telefono a la vez de que su nif termine en k

-- 5. Asignaturas impartidas en el primer cuatrimestre, tercer curso, grado ID 7.
SELECT * 
FROM asignatura 
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;
-- no hay ningúna asignatura que cumpla los requisitos

-- Consultas multitabla (Composición interna)

-- 1. Listado de alumnas matriculadas en Ingeniería Informática.
SELECT p.* 
FROM persona p
JOIN alumno_se_matricula_asignatura am ON p.id = am.id_alumno
JOIN asignatura a ON am.id_asignatura = a.id
JOIN grado g ON a.id_grado = g.id
WHERE p.tipo = 'alumno' AND p.sexo = 'M' AND g.nombre = 'Ingeniería Informática';
-- no hay ninguna alumna matriculada en ingeniería informática

-- 2. Asignaturas del Grado en Ingeniería Informática.
SELECT a.* 
FROM asignatura a
JOIN grado g ON a.id_grado = g.id
WHERE g.nombre = 'Ingeniería Informática';
-- no hay asignaturas en el grado específicado

-- 3. Listado de profesores con el nombre del departamento.
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS nombre_departamento 
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
JOIN departamento d ON prof.id_departamento = d.id
ORDER BY p.apellido1, p.apellido2, p.nombre;

-- 4. Asignaturas y cursos escolares del alumno con NIF específico.
SELECT a.nombre, ce.anyo_inicio, ce.anyo_fin 
FROM asignatura a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_asignatura
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
JOIN persona p ON am.id_alumno = p.id
WHERE p.nif = '26902806M';
-- toca especificar un nif que ya está registrado

-- 5. Departamentos con profesores que imparten en Ingeniería Informática.
SELECT DISTINCT d.nombre 
FROM departamento d
JOIN profesor prof ON d.id = prof.id_departamento
JOIN asignatura a ON prof.id_profesor = a.id_profesor
JOIN grado g ON a.id_grado = g.id
WHERE g.nombre = 'Ingeniería Informática';
-- no hay ningun departamento que cupla con el requisito

-- 6. Alumnos matriculados en asignaturas durante el curso 2018/2019.
SELECT p.* 
FROM persona p
JOIN alumno_se_matricula_asignatura am ON p.id = am.id_alumno
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;
--  no hay alumnos matriculados en ese rango de curso

-- Consultas multitabla (Composición externa)

-- 1. Listado de profesores y sus departamentos.
SELECT d.nombre AS nombre_departamento, p.apellido1, p.apellido2, p.nombre 
FROM profesor prof
LEFT JOIN persona p ON prof.id_profesor = p.id
LEFT JOIN departamento d ON prof.id_departamento = d.id
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;

-- 2. Profesores no asociados a un departamento.
SELECT p.* 
FROM persona p
LEFT JOIN profesor prof ON p.id = prof.id_profesor
WHERE p.tipo = 'profesor' AND prof.id_departamento IS NULL;
-- todos los profesores están registrados en un departamento

-- 3. Departamentos sin profesores asociados.
SELECT d.* 
FROM departamento d
LEFT JOIN profesor prof ON d.id = prof.id_departamento
WHERE prof.id_profesor IS NULL;

-- 4. Profesores que no imparten ninguna asignatura.
SELECT p.* 
FROM persona p
LEFT JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor' AND a.id IS NULL;
-- todos los profesores imparten alguna asignatura

-- 5. Asignaturas sin profesor asignado.
SELECT * 
FROM asignatura 
WHERE id_profesor IS NULL;

-- 6. Departamentos con asignaturas no impartidas en ningún curso.
SELECT d.nombre AS nombre_departamento, a.nombre AS nombre_asignatura 
FROM departamento d
JOIN profesor prof ON d.id = prof.id_departamento
JOIN asignatura a ON prof.id_profesor = a.id_profesor
LEFT JOIN alumno_se_matricula_asignatura am ON a.id = am.id_asignatura
WHERE am.id_asignatura IS NULL;

-- Consultas resumen

-- 1. Número total de alumnas.
SELECT COUNT(*) 
FROM persona 
WHERE tipo = 'alumno' AND sexo = 'M';

-- 2. Número de alumnos nacidos en 1999.
SELECT COUNT(*) 
FROM persona 
WHERE tipo = 'alumno' AND EXTRACT(YEAR FROM fecha_nacimiento) = 1999;

-- 3. Número de profesores por departamento.
SELECT d.nombre AS nombre_departamento, COUNT(prof.id_profesor) AS num_profesores 
FROM departamento d
JOIN profesor prof ON d.id = prof.id_departamento
GROUP BY d.id 
ORDER BY num_profesores DESC;

-- 4. Número de profesores por departamento incluyendo departamentos sin profesores.
SELECT d.nombre AS nombre_departamento, COUNT(prof.id_profesor) AS num_profesores 
FROM departamento d
LEFT JOIN profesor prof ON d.id = prof.id_departamento
GROUP BY d.id 
ORDER BY num_profesores DESC;

-- 5. Número de asignaturas por grado.
SELECT g.nombre, COUNT(a.id) AS num_asignaturas 
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id 
ORDER BY num_asignaturas DESC;

-- 6. Grados con más de 40 asignaturas asociadas.
SELECT g.nombre, COUNT(a.id) AS num_asignaturas 
FROM grado g
JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id 
HAVING COUNT(a.id) > 40;
-- no hay ningún grado con mas de 40 asignaturas asignadas

-- 7. Suma de créditos por tipo de asignatura y grado.
SELECT g.nombre AS nombre_grado, a.tipo, SUM(a.creditos) AS total_creditos 
FROM grado g
JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre, a.tipo 
ORDER BY total_creditos DESC;

-- 8. Número de alumnos matriculados por curso escolar.
SELECT ce.anyo_inicio, COUNT(DISTINCT am.id_alumno) AS num_alumnos 
FROM curso_escolar ce
LEFT JOIN alumno_se_matricula_asignatura am ON ce.id = am.id_curso_escolar
GROUP BY ce.anyo_inicio;

-- 9. Número de asignaturas impartidas por profesor.
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS num_asignaturas 
FROM persona p
LEFT JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor'
GROUP BY p.id 
ORDER BY num_asignaturas DESC;

-- Subconsultas

-- 1. Datos del alumno más joven.
SELECT * 
FROM persona 
WHERE tipo = 'alumno' 
ORDER BY fecha_nacimiento DESC 
LIMIT 1;

-- 2. Profesores no asociados a un departamento.
SELECT * 
FROM persona 
WHERE tipo = 'profesor' AND id NOT IN (
  SELECT id_profesor 
  FROM profesor
);
-- todos los profesores están asociados a un departamento

-- 3. Departamentos sin profesores asociados.
SELECT * 
FROM departamento 
WHERE id NOT IN (
  SELECT id_departamento 
  FROM profesor
);

-- 4. Profesores asociados a departamentos que no imparten ninguna asignatura.
SELECT * 
FROM persona 
WHERE tipo = 'profesor' AND id IN (
  SELECT id_profesor 
  FROM profesor 
  WHERE id_profesor NOT IN (
    SELECT id_profesor 
    FROM asignatura
  )
);
-- todos los profesores asociados a un departamento imparten alguna asignatura

-- 5. Asignaturas sin profesor asignado.
SELECT * 
FROM asignatura 
WHERE id_profesor IS NULL;

-- 6. Departamentos que no han impartido asignaturas en ningún curso escolar.
SELECT d.* 
FROM departamento d
WHERE d.id NOT IN (
  SELECT prof.id_departamento 
  FROM profesor prof
  JOIN asignatura a ON prof.id_profesor = a.id_profesor
  JOIN alumno_se_matricula_asignatura am ON a.id = am.id_asignatura
);
