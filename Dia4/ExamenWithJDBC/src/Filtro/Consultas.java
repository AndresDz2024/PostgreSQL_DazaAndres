/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Filtro;

/**
 *
 * @author DZ
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Consultas {

    // 1. Listar Vehículos Disponibles
    public static void listarVehiculosDisponibles(Connection conn) {
        String query = "SELECT marca, modelo, precio FROM Vehiculo;";
        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("Marca: " + rs.getString("marca") + ", Modelo: " + rs.getString("modelo") + ", Precio: " + rs.getInt("precio"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 2. Clientes con Compras Recientes
    public static void clientesConComprasRecientes(Connection conn) {
        String query = "SELECT p.nombre, p.apellido, v.marca, v.modelo, ve.fecha " +
                "FROM Cliente c " +
                "JOIN Persona p ON c.id_persona = p.id " +
                "JOIN Ventas ve ON c.id = ve.id_cliente " +
                "JOIN Ventas_Vehiculos vv ON ve.id = vv.id_venta " +
                "JOIN Vehiculo v ON vv.id_vehiculo = v.id " +
                "WHERE ve.fecha > CURRENT_DATE - INTERVAL '30 days';";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("Cliente: " + rs.getString("nombre") + " " + rs.getString("apellido") + 
                                   ", Vehículo: " + rs.getString("marca") + " " + rs.getString("modelo") +
                                   ", Fecha de compra: " + rs.getDate("fecha"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 3. Historial de Servicios por Vehículo
    public static void historialServiciosPorVehiculo(Connection conn, int idVehiculo) {
        String query = "SELECT hs.fecha, e.nombre, e.apellido " +
                "FROM Historial_Servicio hs " +
                "JOIN Empleado em ON hs.id_empleado = em.id " +
                "JOIN Persona e ON em.id_persona = e.id " +
                "WHERE hs.id_vehiculo = ?;";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, idVehiculo);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                System.out.println("Fecha: " + rs.getDate("fecha") + ", Empleado: " + rs.getString("nombre") + " " + rs.getString("apellido"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 4. Listar Proveedores de Piezas Utilizados
    public static void listarProveedoresDePiezas(Connection conn) {
        String query = "SELECT DISTINCT p.nombre, p.apellido " +
                "FROM Proveedor pr " +
                "JOIN Persona p ON pr.id_persona = p.id " +
                "JOIN Historial_Servicio hs ON pr.id = hs.id_proveedor;";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("Proveedor: " + rs.getString("nombre") + " " + rs.getString("apellido"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 5. Rendimiento del Personal de Ventas
    public static void rendimientoPersonalVentas(Connection conn) {
        String query = "SELECT e.id, p.nombre, p.apellido, SUM(v.costo) AS total_ventas " +
                "FROM Empleado e " +
                "JOIN Persona p ON e.id_persona = p.id " +
                "JOIN Ventas v ON e.id = v.id_empleado " +
                "WHERE e.id_departamento IN (SELECT id FROM Departamento_Ventas) " +
                "GROUP BY e.id, p.nombre, p.apellido;";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                System.out.println("Empleado: " + rs.getString("nombre") + " " + rs.getString("apellido") + 
                                   ", Total Ventas: " + rs.getInt("total_ventas"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 6. Servicios Realizados por un Empleado
    public static void serviciosPorEmpleado(Connection conn, int idEmpleado) {
        String query = "SELECT hs.fecha, v.marca, v.modelo " +
                       "FROM Historial_Servicio hs " +
                       "JOIN Vehiculo v ON hs.id_vehiculo = v.id " +
                       "WHERE hs.id_empleado = ?;";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, idEmpleado);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                System.out.println("Fecha: " + rs.getDate("fecha") + ", Vehículo: " + rs.getString("marca") + " " + rs.getString("modelo"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 7. Clientes Potenciales y Vehículos de Interés
    public static void clientesPotencialesYVehiculos(Connection conn) {
        String query = "SELECT c.id, p.nombre, p.apellido, v.marca, v.modelo " +
                       "FROM Cliente_Potencial cp " +
                       "JOIN Cliente c ON cp.id_cliente = c.id " +
                       "JOIN Persona p ON c.id_persona = p.id " +
                       "JOIN Vehiculo v ON cp.id_vehiculo = v.id;";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("Cliente Potencial: " + rs.getString("nombre") + " " + rs.getString("apellido") +
                                   ", Vehículo de Interés: " + rs.getString("marca") + " " + rs.getString("modelo"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 8. Empleados del Departamento de Servicio
    public static void empleadosDepartamentoServicio(Connection conn) {
        String query = "SELECT p.nombre, p.apellido, e.rol, e.fecha_contratacion " +
                       "FROM Empleado e " +
                       "JOIN Persona p ON e.id_persona = p.id " +
                       "WHERE e.id_departamento IN (SELECT id FROM Departamento_Servicio);";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("Empleado: " + rs.getString("nombre") + " " + rs.getString("apellido") + 
                                   ", Rol: " + rs.getString("rol") + 
                                   ", Fecha de Contratación: " + rs.getDate("fecha_contratacion"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 9. Vehículos Vendidos en un Rango de Precios
    public static void vehiculosVendidosEnRangoDePrecios(Connection conn, int precioMin, int precioMax) {
        String query = "SELECT v.marca, v.modelo, ve.costo, ve.fecha " +
                       "FROM Ventas ve " +
                       "JOIN Ventas_Vehiculos vv ON ve.id = vv.id_venta " +
                       "JOIN Vehiculo v ON vv.id_vehiculo = v.id " +
                       "WHERE ve.costo BETWEEN ? AND ?;";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, precioMin);
            stmt.setInt(2, precioMax);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                System.out.println("Vehículo: " + rs.getString("marca") + " " + rs.getString("modelo") + 
                                   ", Precio de Venta: " + rs.getInt("costo") + 
                                   ", Fecha de Venta: " + rs.getDate("fecha"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    // 10. Clientes con Múltiples Compras
    public static void clientesConMultiplesCompras(Connection conn) {
        String query = "SELECT p.nombre, p.apellido, COUNT(ve.id) AS compras " +
                       "FROM Cliente c " +
                       "JOIN Persona p ON c.id_persona = p.id " +
                       "JOIN Ventas ve ON c.id = ve.id_cliente " +
                       "GROUP BY p.nombre, p.apellido " +
                       "HAVING COUNT(ve.id) > 1;";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("Cliente: " + rs.getString("nombre") + " " + rs.getString("apellido") + 
                                   ", Compras: " + rs.getInt("compras"));
            }
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }
}
