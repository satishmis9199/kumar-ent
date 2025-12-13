package com.kumarent.dao;

import com.kumarent.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {
    public static boolean validate(String username, String password) throws Exception {
        String sql = "SELECT password_hash FROM admin WHERE username = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {
            pst.setString(1, username);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    String dbPass = rs.getString("password_hash");
                    return dbPass.equals(password); // in prod: use hashed password check
                }
            }
        }
        return false;
    }

    public static String getAdminEmail() throws Exception {
        String sql = "SELECT email FROM admin LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) return rs.getString(1);
        }
        return null;
    }
}
