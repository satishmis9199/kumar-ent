package com.kumarent.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL Driver Loaded");
        } catch (Exception e) {
            throw new RuntimeException("❌ Driver not found", e);
        }
    }

    public static Connection getConnection() {
        try {
            String railwayUrl = System.getenv("MYSQL_URL");

            if (railwayUrl == null) {
                throw new RuntimeException("❌ MYSQL_URL not found");
            }

            // 🔥 IMPORTANT FIX
            String jdbcUrl = railwayUrl.replace("mysql://", "jdbc:mysql://")
                    + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

            Connection con = DriverManager.getConnection(jdbcUrl);
            System.out.println("✅ Connected to Railway MySQL");
            return con;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("❌ Database connection failed");
        }
    }
}
