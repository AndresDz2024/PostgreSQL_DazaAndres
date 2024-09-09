create table People(
	id SERIAL primary key not null,
	nombre varchar(250),
	apellido varchar(250),
	municipio_nacimiento varchar(250),
	municipio_domicilio varchar(250)
);

create table Places(
	id SERIAL primary key not null,
	region varchar(250),
	departamento varchar(250),
	codigo_departamento varchar(250),
	municipio varchar(250),
	codigo_municipio varchar(250)
);

