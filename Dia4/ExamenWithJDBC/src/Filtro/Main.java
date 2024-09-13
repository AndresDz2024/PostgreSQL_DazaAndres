/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Filtro;
import java.sql.Connection;
import java.util.InputMismatchException;
import java.util.Scanner;

/**
 *
 * @author DZ
 */
public class Main {
    
    public static void main(String[] args) {
        Conex conexion = new Conex();
        Connection conn = conexion.establecerConexion();

        if (conn != null) {
            System.out.println("Conectado a la base de datos PostgreSQL.");
            Main m = new Main();
            m.mostrarMenu(conn);
            
        } else {
            System.out.println("No se pudo conectar a la base de datos PostgreSQL.");
        }
    }
    
    Scanner scanner = new Scanner(System.in);
    int option = 0;
    
    private int leerOpcion() {
        int option = 0;
        while (true) {
            try {
                option = scanner.nextInt(); 
                scanner.nextLine(); // Limpiar el buffer del scanner
                break; // Salir del bucle si la entrada es válida
            } catch (InputMismatchException e) {
                System.out.println("Entrada no válida. Por favor, ingrese un número entero.");
                scanner.nextLine(); // Limpiar el buffer del scanner
            }
        }
        return option;
    }
    
    public void mostrarMenu(Connection conn) {
        Scanner scanner = new Scanner(System.in);
        do {
            System.out.println("\nSeleccione una opción de consulta:");
            System.out.println("1. Listar Vehículos Disponibles");
            System.out.println("2. Clientes con Compras Recientes");
            System.out.println("3. Historial de Servicios por Vehículo");
            System.out.println("4. Proveedores de Piezas Utilizados");
            System.out.println("5. Rendimiento del Personal de Ventas");
            System.out.println("6. Servicios Realizados por un Empleado");
            System.out.println("7. Clientes Potenciales y Vehículos de Interés");
            System.out.println("8. Empleados del Departamento de Servicio");
            System.out.println("9. Vehículos Vendidos en un Rango de Precios");
            System.out.println("10. Clientes con Múltiples Compras");
            System.out.println("11. Salir");
            System.out.println("Ingrese su elección: ");
            option = leerOpcion();
            
            switch (option) {
                case 1:
                    System.out.println("siuuu");
                    Consultas.listarVehiculosDisponibles(conn);
                    break;
                case 2:
                    Consultas.clientesConComprasRecientes(conn);
                    break;
                case 3:
                    System.out.print("Ingrese el ID del vehículo: ");
                    int idVehiculo = scanner.nextInt();
                    Consultas.historialServiciosPorVehiculo(conn, idVehiculo);
                    break;
                case 4:
                    Consultas.listarProveedoresDePiezas(conn);
                    break;
                case 5:
                    Consultas.rendimientoPersonalVentas(conn);
                    break;
                case 6:
                    System.out.print("Ingrese el ID del empleado: ");
                    int idEmpleado = scanner.nextInt();
                    Consultas.serviciosPorEmpleado(conn, idEmpleado);
                    break;
                case 7:
                    Consultas.clientesPotencialesYVehiculos(conn);
                    break;
                case 8:
                    Consultas.empleadosDepartamentoServicio(conn);
                    break;
                case 9:
                    System.out.print("Ingrese el precio mínimo: ");
                    int precioMin = scanner.nextInt();
                    System.out.print("Ingrese el precio máximo: ");
                    int precioMax = scanner.nextInt();
                    Consultas.vehiculosVendidosEnRangoDePrecios(conn, precioMin, precioMax);
                    break;
                case 10:
                    Consultas.clientesConMultiplesCompras(conn);
                    break;
                case 11:
                    System.out.println("Saliendo del programa...");
                    break;
                default:
                    System.out.println("Opción no válida, por favor intente de nuevo.");
                    break;
            }

        } while (option != 11);

        scanner.close();
    }
    
}