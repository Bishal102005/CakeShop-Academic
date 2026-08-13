package controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;
import java.util.Map;

public final class DbUtil {

    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;
    private static final Map<String, String> ENV_MAP = new HashMap<>();

    static {
        try {
            File envFile = findDotEnvFile();
            if (envFile != null && envFile.exists()) {
                try (BufferedReader reader = new BufferedReader(new FileReader(envFile))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        if (line.isEmpty() || line.startsWith("#")) {
                            continue;
                        }
                        int idx = line.indexOf('=');
                        if (idx > 0) {
                            String key = line.substring(0, idx).trim();
                            String val = line.substring(idx + 1).trim();
                            ENV_MAP.put(key, val);
                        }
                    }
                }
            }
        } catch (Exception ignored) {
        }

        String dbUrl = System.getenv("DB_URL");
        if (dbUrl == null) dbUrl = ENV_MAP.get("DB_URL");
        if (dbUrl == null) dbUrl = "jdbc:postgresql://localhost:5432/postgres?sslmode=disable";
        URL = dbUrl;

        String dbUser = System.getenv("DB_USER");
        if (dbUser == null) dbUser = ENV_MAP.get("DB_USER");
        if (dbUser == null) dbUser = "postgres";
        USER = dbUser;

        String dbPassword = System.getenv("DB_PASSWORD");
        if (dbPassword == null) dbPassword = ENV_MAP.get("DB_PASSWORD");
        if (dbPassword == null) dbPassword = "postgres";
        PASSWORD = dbPassword;

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBC Driver not found.");
        }
    }

    private DbUtil() {
    }

    public static String getEnv(String key) {
        String val = System.getenv(key);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        return ENV_MAP.get(key);
    }

    private static File findDotEnvFile() {
        // Check current directory
        File f = new File(".env");
        System.err.println("[DbUtil] Checking .env in current dir: " + f.getAbsolutePath() + " -> exists: " + f.exists());
        if (f.exists()) {
            return f;
        }
        
        // Check WEB-INF
        File webInf = new File("WEB-INF/.env");
        System.err.println("[DbUtil] Checking .env in WEB-INF: " + webInf.getAbsolutePath() + " -> exists: " + webInf.exists());
        if (webInf.exists()) {
            return webInf;
        }
        
        // Check parent directories
        File parent = new File("..").getAbsoluteFile();
        for (int i = 0; i < 4; i++) {
            File possible = new File(parent, ".env");
            System.err.println("[DbUtil] Checking .env in parent[" + i + "]: " + possible.getAbsolutePath() + " -> exists: " + possible.exists());
            if (possible.exists()) {
                return possible;
            }
            parent = parent.getParentFile();
            if (parent == null) {
                break;
            }
        }
        
        System.err.println("[DbUtil] .env file not found, using defaults");
        return null;
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
