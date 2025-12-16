package com.kumarent.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection connection;

    static {
        try {
            // ✅ MySQL Driver load
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL Driver Loaded Successfully");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("❌ MySQL Driver NOT FOUND", e);
        }
    }

    public static Connection getConnection() {
        if (connection != null) {
            return connection;
        }

        try {
            // ✅ Railway environment variables
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String db   = System.getenv("MYSQLDATABASE");
            String user = System.getenv("MYSQLUSER");
            String pass = System.getenv("MYSQLPASSWORD");

            String url = "jdbc:mysql://" + host + ":" + port + "/" + db
                    + "?useSSL=false"
                    + "&allowPublicKeyRetrieval=true"
                    + "&serverTimezone=UTC";

            connection = DriverManager.getConnection(url, user, pass);
            System.out.println("✅ Connected to Railway MySQL");

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("❌ Database connection failed");
        }

        return connection;
    }
}
