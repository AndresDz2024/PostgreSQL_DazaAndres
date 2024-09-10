-- Consultas sobre una tabla

-- 1. Listado con el código de oficina y la ciudad
SELECT codigo_oficina, ciudad
FROM oficina;

-- 2. Listado con la ciudad y el teléfono de las oficinas de España
SELECT ciudad, telefono
FROM oficina
WHERE pais = 'España';

-- 3. Nombre, apellidos y email de empleados cuyo jefe tiene el código 7
SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_jefe = 7;

-- 4. Nombre del puesto, nombre, apellidos y email del jefe de la empresa
SELECT puesto, nombre, apellido1, apellido2, email
FROM empleado
WHERE puesto = 'Director General';

-- 5. Nombre, apellidos y puesto de empleados que no sean representantes de ventas
SELECT nombre, apellido1, apellido2, puesto
FROM empleado
WHERE puesto <> 'Representante Ventas';

-- 6. Nombre de todos los clientes españoles
SELECT nombre_cliente
FROM cliente
WHERE pais = 'Spain';

-- 7. Distintos estados por los que puede pasar un pedido
SELECT DISTINCT estado
FROM pedido;

-- 8. Código de cliente que realizó algún pago en 2008
-- Utilizando la función YEAR
SELECT DISTINCT codigo_cliente
FROM pago
WHERE EXTRACT(YEAR FROM fecha_pago) = 2008;

-- Utilizando la función DATE_FORMAT
-- no existe date format en postgresql

-- Sin utilizar funciones
SELECT DISTINCT codigo_cliente
FROM pago
WHERE fecha_pago BETWEEN '2008-01-01' AND '2008-12-31';

-- 9. Pedidos que no han sido entregados a tiempo
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega > fecha_esperada;

-- 10. Pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada
-- Utilizando la operación de resta de fechas
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega <= fecha_esperada - INTERVAL '2 days';

-- Utilizando la función DATEDIFF
-- date diff no está en postgresql

-- Con operador de suma/resta
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega <= fecha_esperada - INTERVAL '2 days';

-- 11. Pedidos rechazados en 2009
SELECT codigo_pedido
FROM pedido
WHERE estado = 'Rechazado' AND EXTRACT(YEAR FROM fecha_pedido) = 2009;

-- 12. Pedidos entregados en enero de cualquier año
SELECT codigo_pedido
FROM pedido
WHERE EXTRACT(MONTH FROM fecha_entrega) = 1;

-- 13. Pagos en el año 2008 mediante Paypal, ordenados de mayor a menor
SELECT *
FROM pago
WHERE EXTRACT(YEAR FROM fecha_pago) = 2008 AND forma_pago = 'PayPal'
ORDER BY total DESC;

-- 14. Formas de pago únicas en la tabla pago
SELECT DISTINCT forma_pago
FROM pago;

-- 15. Productos de la gama Ornamentales con más de 100 unidades en stock, ordenados por precio de venta
SELECT *
FROM producto
WHERE gama = 'Ornamentales' AND cantidad_en_stock > 100
ORDER BY precio_venta DESC;

-- 16. Clientes de Madrid cuyo representante de ventas tenga el código 11 o 30
SELECT nombre_cliente
FROM cliente
WHERE ciudad = 'Madrid' AND codigo_empleado_rep_ventas IN (11, 30);


-- Consultas multitabla (Composición interna)

-- 1. Nombre de cada cliente y nombre y apellido de su representante de ventas
SELECT c.nombre_cliente, e.nombre, e.apellido1
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 2. Nombre de los clientes que hayan realizado pagos y nombre de sus representantes de ventas
SELECT c.nombre_cliente, e.nombre, e.apellido1
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente;

-- 3. Nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas
SELECT c.nombre_cliente, e.nombre, e.apellido1
FROM cliente c
LEFT JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- 4. Nombre de los clientes que han hecho pagos y nombre de sus representantes junto con la ciudad de la oficina
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente;

-- 5. Nombre de los clientes que no han hecho pagos y nombre de sus representantes junto con la ciudad de la oficina
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente c
LEFT JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- 6. Dirección de las oficinas que tienen clientes en Fuenlabrada
select cliente.nombre_cliente, empleado.nombre, oficina.ciudad, oficina.linea_direccion1, cliente.ciudad
from pago
inner join cliente on pago.codigo_cliente = cliente.codigo_cliente
inner join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina on empleado.codigo_oficina = oficina.codigo_oficina
where cliente.ciudad = 'Fuenlabrada';

-- 7. Nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

-- 8. Nombre de los empleados junto con el nombre de su jefe y el nombre del jefe de su jefe
select emp.nombre as NombreEmpleado, jef.nombre as NombreJefe, jef2.nombre as NombreJefe2
from empleado emp
left join empleado jef on emp.codigo_jefe = jef.codigo_empleado
left join empleado jef2 on jef.codigo_jefe = jef2.codigo_empleado;

-- 9. Nombre de clientes a los que no se les ha entregado a tiempo un pedido
SELECT DISTINCT c.nombre_cliente
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada;

-- 10. Diferentes gamas de producto que ha comprado cada cliente
SELECT DISTINCT c.nombre_cliente, p.gama
FROM cliente c
INNER JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
INNER JOIN detalle_pedido dp ON pd.codigo_pedido = dp.codigo_pedido
INNER JOIN producto p ON dp.codigo_producto = p.codigo_producto;


-- Consultas multitabla (Composición externa)

-- 1. Clientes que no han realizado ningún pago
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- 2. Clientes que no han realizado ningún pedido
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_pedido IS NULL;

-- 3. Clientes que no han realizado ningún pago y los que no han realizado ningún pedido
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
WHERE p.codigo_cliente IS NULL AND pd.codigo_pedido IS NULL;

-- 4. Empleados que no tienen una oficina asociada
SELECT e.nombre, e.apellido1
FROM empleado e
WHERE e.codigo_oficina IS NULL;
-- no hay ningun empleado sin oficina

-- 5. Empleados que no tienen un cliente asociado
SELECT e.nombre, e.apellido1
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;

-- 6. Empleados sin cliente asociado junto con datos de la oficina
SELECT e.nombre, e.apellido1, o.linea_direccion1, o.ciudad
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;

-- 7. Clientes que no tienen pedido ni pago
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE p.codigo_pedido IS NULL AND pa.codigo_cliente IS NULL;