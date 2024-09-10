-- Procedimientos :)

-- 1. Insertar un nuevo producto
CREATE OR REPLACE FUNCTION insertar_producto(
    p_codigo_producto VARCHAR,
    p_nombre VARCHAR,
    p_gama VARCHAR,
    p_dimensiones VARCHAR,
    p_proveedor VARCHAR,
    p_descripcion TEXT,
    p_cantidad_en_stock SMALLINT,
    p_precio_venta NUMERIC(15,2),
    p_precio_proveedor NUMERIC(15,2)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO producto (
        codigo_producto, nombre, gama, dimensiones, proveedor, descripcion,
        cantidad_en_stock, precio_venta, precio_proveedor
    ) VALUES (
        p_codigo_producto, p_nombre, p_gama, p_dimensiones, p_proveedor, p_descripcion,
        p_cantidad_en_stock, p_precio_venta, p_precio_proveedor
    );
END;
$$ LANGUAGE plpgsql;

-- 2. Actualizar un producto existente
CREATE OR REPLACE FUNCTION actualizar_producto(
    p_codigo_producto VARCHAR,
    p_nombre VARCHAR,
    p_gama VARCHAR,
    p_dimensiones VARCHAR,
    p_proveedor VARCHAR,
    p_descripcion TEXT,
    p_cantidad_en_stock SMALLINT,
    p_precio_venta NUMERIC(15,2),
    p_precio_proveedor NUMERIC(15,2)
)
RETURNS VOID AS $$
BEGIN
    UPDATE producto
    SET nombre = p_nombre,
        gama = p_gama,
        dimensiones = p_dimensiones,
        proveedor = p_proveedor,
        descripcion = p_descripcion,
        cantidad_en_stock = p_cantidad_en_stock,
        precio_venta = p_precio_venta,
        precio_proveedor = p_precio_proveedor
    WHERE codigo_producto = p_codigo_producto;
END;
$$ LANGUAGE plpgsql;

-- 3. Eliminar un producto
CREATE OR REPLACE FUNCTION eliminar_producto(p_codigo_producto VARCHAR)
RETURNS VOID AS $$
BEGIN
    DELETE FROM producto WHERE codigo_producto = p_codigo_producto;
END;
$$ LANGUAGE plpgsql;

-- 4. Buscar productos por gama
CREATE OR REPLACE FUNCTION buscar_productos_por_gama(p_gama VARCHAR)
RETURNS TABLE (
    codigo_producto VARCHAR,
    nombre VARCHAR,
    dimensiones VARCHAR,
    proveedor VARCHAR,
    descripcion TEXT,
    cantidad_en_stock SMALLINT,
    precio_venta NUMERIC(15,2),
    precio_proveedor NUMERIC(15,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT codigo_producto, nombre, dimensiones, proveedor, descripcion, cantidad_en_stock, precio_venta, precio_proveedor
    FROM producto
    WHERE gama = p_gama;
END;
$$ LANGUAGE plpgsql;

-- 5. Insertar una nueva oficina
CREATE OR REPLACE FUNCTION insertar_oficina(
    p_codigo_oficina VARCHAR,
    p_ciudad VARCHAR,
    p_pais VARCHAR,
    p_region VARCHAR,
    p_codigo_postal VARCHAR,
    p_telefono VARCHAR,
    p_linea_direccion1 VARCHAR,
    p_linea_direccion2 VARCHAR
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO oficina (
        codigo_oficina, ciudad, pais, region, codigo_postal, telefono, linea_direccion1, linea_direccion2
    ) VALUES (
        p_codigo_oficina, p_ciudad, p_pais, p_region, p_codigo_postal, p_telefono, p_linea_direccion1, p_linea_direccion2
    );
END;
$$ LANGUAGE plpgsql;

-- 6. Actualizar una oficina existente
CREATE OR REPLACE FUNCTION actualizar_oficina(
    p_codigo_oficina VARCHAR,
    p_ciudad VARCHAR,
    p_pais VARCHAR,
    p_region VARCHAR,
    p_codigo_postal VARCHAR,
    p_telefono VARCHAR,
    p_linea_direccion1 VARCHAR,
    p_linea_direccion2 VARCHAR
)
RETURNS VOID AS $$
BEGIN
    UPDATE oficina
    SET ciudad = p_ciudad,
        pais = p_pais,
        region = p_region,
        codigo_postal = p_codigo_postal,
        telefono = p_telefono,
        linea_direccion1 = p_linea_direccion1,
        linea_direccion2 = p_linea_direccion2
    WHERE codigo_oficina = p_codigo_oficina;
END;
$$ LANGUAGE plpgsql;

-- 7. Eliminar una oficina
CREATE OR REPLACE FUNCTION eliminar_oficina(p_codigo_oficina VARCHAR)
RETURNS VOID AS $$
BEGIN
    DELETE FROM oficina WHERE codigo_oficina = p_codigo_oficina;
END;
$$ LANGUAGE plpgsql;

-- 8. Buscar oficinas por ciudad
CREATE OR REPLACE FUNCTION buscar_oficinas_por_ciudad(p_ciudad VARCHAR)
RETURNS TABLE (
    codigo_oficina VARCHAR,
    ciudad VARCHAR,
    pais VARCHAR,
    region VARCHAR,
    codigo_postal VARCHAR,
    telefono VARCHAR,
    linea_direccion1 VARCHAR,
    linea_direccion2 VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT codigo_oficina, ciudad, pais, region, codigo_postal, telefono, linea_direccion1, linea_direccion2
    FROM oficina
    WHERE ciudad = p_ciudad;
END;
$$ LANGUAGE plpgsql;

-- 9. Insertar un nuevo cliente
CREATE OR REPLACE FUNCTION insertar_cliente(
    p_codigo_cliente INTEGER,
    p_nombre_cliente VARCHAR,
    p_nombre_contacto VARCHAR,
    p_apellido_contacto VARCHAR,
    p_telefono VARCHAR,
    p_fax VARCHAR,
    p_linea_direccion1 VARCHAR,
    p_linea_direccion2 VARCHAR,
    p_ciudad VARCHAR,
    p_region VARCHAR,
    p_pais VARCHAR,
    p_codigo_postal VARCHAR,
    p_codigo_empleado_rep_ventas INTEGER,
    p_limite_credito NUMERIC(15,2)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO cliente (
        codigo_cliente, nombre_cliente, nombre_contacto, apellido_contacto, telefono, fax, linea_direccion1, linea_direccion2,
        ciudad, region, pais, codigo_postal, codigo_empleado_rep_ventas, limite_credito
    ) VALUES (
        p_codigo_cliente, p_nombre_cliente, p_nombre_contacto, p_apellido_contacto, p_telefono, p_fax, p_linea_direccion1, p_linea_direccion2,
        p_ciudad, p_region, p_pais, p_codigo_postal, p_codigo_empleado_rep_ventas, p_limite_credito
    );
END;
$$ LANGUAGE plpgsql;

-- 10. Actualizar un cliente existente
CREATE OR REPLACE FUNCTION actualizar_cliente(
    p_codigo_cliente INTEGER,
    p_nombre_cliente VARCHAR,
    p_nombre_contacto VARCHAR,
    p_apellido_contacto VARCHAR,
    p_telefono VARCHAR,
    p_fax VARCHAR,
    p_linea_direccion1 VARCHAR,
    p_linea_direccion2 VARCHAR,
    p_ciudad VARCHAR,
    p_region VARCHAR,
    p_pais VARCHAR,
    p_codigo_postal VARCHAR,
    p_codigo_empleado_rep_ventas INTEGER,
    p_limite_credito NUMERIC(15,2)
)
RETURNS VOID AS $$
BEGIN
    UPDATE cliente
    SET nombre_cliente = p_nombre_cliente,
        nombre_contacto = p_nombre_contacto,
        apellido_contacto = p_apellido_contacto,
        telefono = p_telefono,
        fax = p_fax,
        linea_direccion1 = p_linea_direccion1,
        linea_direccion2 = p_linea_direccion2,
        ciudad = p_ciudad,
        region = p_region,
        pais = p_pais,
        codigo_postal = p_codigo_postal,
        codigo_empleado_rep_ventas = p_codigo_empleado_rep_ventas,
        limite_credito = p_limite_credito
    WHERE codigo_cliente = p_codigo_cliente;
END;
$$ LANGUAGE plpgsql;

-- Vistas :)

-- 1. Listado de oficinas con código y ciudad
CREATE VIEW vista_oficinas AS
SELECT codigo_oficina, ciudad
FROM oficina;

-- 2. Oficinas en España con ciudad y teléfono
CREATE VIEW vista_oficinas_espana AS
SELECT ciudad, telefono
FROM oficina
WHERE pais = 'España';

-- 3. Empleados cuyo jefe tiene código 7
CREATE VIEW vista_empleados_jefe_7 AS
SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_jefe = 7;

-- 4. Información del jefe de la empresa
CREATE VIEW vista_jefe_empresa AS
SELECT puesto, nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_empleado = (SELECT codigo_jefe FROM empleado LIMIT 1);

-- 5. Empleados que no son representantes de ventas
CREATE VIEW vista_empleados_no_rep_ventas AS
SELECT nombre, apellido1, puesto
FROM empleado
WHERE puesto <> 'Representante de Ventas';

-- 6. Clientes españoles
create VIEW vista_clientes_espanoles AS
SELECT nombre_cliente
FROM cliente
WHERE pais = 'Spain';

-- 7. Estados posibles de los pedidos
CREATE VIEW vista_estados_pedidos AS
SELECT DISTINCT estado
FROM pedido;

-- 8. Códigos de cliente con pagos en 2008
CREATE VIEW vista_clientes_pagos_2008 AS
SELECT DISTINCT codigo_cliente
FROM pago
WHERE EXTRACT(YEAR FROM fecha_pago) = 2008;

-- 9. Pedidos no entregados a tiempo
CREATE VIEW vista_pedidos_no_entregados_tiempo AS
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega > fecha_esperada;

-- 10. Productos de la gama Ornamentales con más de 100 unidades en stock
CREATE VIEW vista_productos_gama_ornamentales AS
SELECT codigo_producto, nombre, cantidad_en_stock
FROM producto
WHERE gama = 'Ornamentales' AND cantidad_en_stock > 100;
