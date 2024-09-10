-- Crear Tabla Departamento
CREATE TABLE departamento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Crear Tabla Persona
CREATE TABLE persona (
    id SERIAL PRIMARY KEY,
    nif VARCHAR(9),
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('H', 'M')) NOT NULL,
    tipo VARCHAR(8) CHECK (tipo IN ('profesor', 'alumno')) NOT NULL
);

-- Crear Tabla Profesor
CREATE TABLE profesor (
    id_profesor INT PRIMARY KEY,
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES persona(id),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

-- Crear Tabla Grado
CREATE TABLE grado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear Tabla Asignatura
CREATE TABLE asignatura (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos REAL NOT NULL,
    tipo VARCHAR(12) NOT NULL,
    curso SMALLINT NOT NULL,
    cuatrimestre SMALLINT,
    id_profesor INT,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    id_grado INT NOT NULL,
    FOREIGN KEY (id_grado) REFERENCES grado(id)
);

-- Crear Tabla Curso Escolar
CREATE TABLE curso_escolar (
    id SERIAL PRIMARY KEY,
    anyo_inicio INT CHECK (anyo_inicio >= 1000 AND anyo_inicio <= 9999) NOT NULL,
    anyo_fin INT CHECK (anyo_fin >= 1000 AND anyo_fin <= 9999) NOT NULL
);

-- Crear Tabla alumno se matricula asignatura
CREATE TABLE alumno_se_matricula_asignatura (
    id_alumno INT PRIMARY KEY,
    id_asignatura INT NOT NULL,
    id_curso_escolar INT NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES persona(id),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
);