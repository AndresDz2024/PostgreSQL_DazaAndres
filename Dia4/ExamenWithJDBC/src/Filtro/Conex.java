package Filtro;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import javax.swing.JOptionPane;

public class Conex {
    private Connection con;

    public Connection establecerConexion() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("Config.properties")) {
            if (input == null) {
                throw new IllegalStateException("Archivo Config.properties no encontrado");
            }

            // Cargar las propiedades del archivo Config.properties
            props.load(input);

            // Obtener los parámetros de conexión
            String url = props.getProperty("Url");
            String user = props.getProperty("User");
            String password = props.getProperty("Password");

            if (url == null || user == null || password == null) {
                throw new IllegalStateException("Una o más propiedades de conexión no están definidas");
            }

            // Cargar la clase del driver de PostgreSQL
            Class.forName("org.postgresql.Driver");

            // Establecer la conexión
            con = DriverManager.getConnection(url, user, password);
            System.out.println("Conexión a PostgreSQL establecida exitosamente.");
        } catch (IOException | ClassNotFoundException | SQLException | IllegalStateException e) {
            System.err.println("Error en la conexión: " + e.getMessage());
            JOptionPane.showMessageDialog(null, "Error en la conexión: " + e.toString());
        }
        return con;
    }
}
