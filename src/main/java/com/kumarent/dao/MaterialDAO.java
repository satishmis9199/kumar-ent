package com.kumarent.dao;

import com.kumarent.model.Material;
import com.kumarent.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MaterialDAO {
    public static List<Material> listAll() throws Exception {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM material ORDER BY created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Material m = new Material();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setDescription(rs.getString("description"));
                m.setPrice(rs.getDouble("price"));
                m.setQuantity(rs.getInt("quantity"));
                m.setImagePath(rs.getString("image_path"));
                list.add(m);
            }
        }
        return list;
    }

    public static Material findById(int id) throws Exception {
        String sql = "SELECT * FROM material WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {
            pst.setInt(1, id);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    Material m = new Material();
                    m.setId(rs.getInt("id"));
                    m.setName(rs.getString("name"));
                    m.setDescription(rs.getString("description"));
                    m.setPrice(rs.getDouble("price"));
                    m.setQuantity(rs.getInt("quantity"));
                    m.setImagePath(rs.getString("image_path"));
                    return m;
                }
            }
        }
        return null;
    }

    public static void insert(Material m) throws Exception {
        String sql = "INSERT INTO material (name, description, price, quantity, image_path) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {
            pst.setString(1, m.getName());
            pst.setString(2, m.getDescription());
            pst.setDouble(3, m.getPrice());
            pst.setInt(4, m.getQuantity());
            pst.setString(5, m.getImagePath());
            pst.executeUpdate();
        }
    }

    public static void update(Material m) throws Exception {
        String sql = "UPDATE material SET name=?, description=?, price=?, quantity=?, image_path=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {
            pst.setString(1, m.getName());
            pst.setString(2, m.getDescription());
            pst.setDouble(3, m.getPrice());
            pst.setInt(4, m.getQuantity());
            pst.setString(5, m.getImagePath());
            pst.setInt(6, m.getId());
            pst.executeUpdate();
        }
    }

    public static void delete(int id) throws Exception {
        String sql = "DELETE FROM material WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {
            pst.setInt(1, id);
            pst.executeUpdate();
        }
    }
}
