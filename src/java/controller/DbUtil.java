package controller;

import java.sql.Connection;
import java.sql.DriverManager;

public final class DbUtil {

    private static final String URL = System.getenv("DB_URL") != null 
            ? System.getenv("DB_URL") 
            : "jdbc:postgresql://localhost:5432/postgres?sslmode=disable";
    private static final String USER = System.getenv("DB_USER") != null 
            ? System.getenv("DB_USER") 
            : "postgres";
    private static final String PASSWORD = System.getenv("DB_PASSWORD") != null 
            ? System.getenv("DB_PASSWORD") 
            : "postgres";

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBC Driver not found.");
        }
    }

    private DbUtil() {
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
