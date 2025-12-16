package com.kumarent.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL Driver Loaded");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static Connection getConnection() {
        try {
            String url = System.getenv("MYSQL_URL");

            if (url == null) {
                throw new RuntimeException("❌ MYSQL_URL not found");
            }

            Connection con = DriverManager.getConnection(url);
            System.out.println("✅ Connected to Railway MySQL");
            return con;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("❌ Database connection failed");
        }
    }
}
