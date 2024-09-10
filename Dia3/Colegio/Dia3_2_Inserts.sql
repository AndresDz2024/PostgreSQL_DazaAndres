INSERT INTO departamento (nombre) VALUES 
('Matemáticas'),
('Física'),
('Química'),
('Literatura');
;

INSERT INTO persona (nif, nombre, apellido1, apellido2, ciudad, direccion, telefono, fecha_nacimiento, sexo, tipo) VALUES 
('12345678A', 'Juan', 'Pérez', 'Gómez', 'Madrid', 'Calle Falsa 123', '600000001', '1980-05-10', 'H', 'profesor'),
('87654321B', 'María', 'López', 'Martínez', 'Barcelona', 'Avenida Real 45', '600000002', '1992-11-25', 'M', 'alumno'),
('22334455C', 'Pedro', 'García', NULL, 'Sevilla', 'Plaza Mayor 7', '600000003', '1985-02-15', 'H', 'profesor'),
('99887766D', 'Ana', 'Sánchez', 'López', 'Valencia', 'Calle Mayor 1', '600000004', '1995-08-05', 'M', 'alumno');

INSERT INTO profesor (id_profesor, id_departamento) VALUES 
(1, 1),
(3, 2);

INSERT INTO grado (nombre) VALUES 
('Ingeniería Informática'),
('Filosofía'),
('Matemáticas Aplicadas');

INSERT INTO asignatura (nombre, creditos, tipo, curso, cuatrimestre, id_profesor, id_grado) VALUES 
('Cálculo Diferencial', 6.0, 'basica', 1, 1, 1, 3),
('Lógica Matemática', 5.0, 'obligatoria', 1, 2, 3, 3),
('Metafísica', 4.0, 'optativa', 2, 1, NULL, 2);

INSERT INTO curso_escolar (anyo_inicio, anyo_fin) VALUES 
(2023, 2024),
(2024, 2025);

INSERT INTO alumno_se_matricula_asignatura (id_alumno, id_asignatura, id_curso_escolar) VALUES 
(2, 1, 1),
(4, 3, 2);