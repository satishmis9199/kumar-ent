package com.kumarent.dao;

import com.kumarent.model.Material;
import com.kumarent.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MaterialDAO {

    /* ================= LIST ALL ================= */
    public static List<Material> listAll() throws Exception {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM material ORDER BY created_at DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    /* ================= SEARCH / FILTER / SORT ================= */
    public static List<Material> listFiltered(
            String search, String stock, String sort) throws Exception {

        List<Material> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM material WHERE 1=1");

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        if ("in".equals(stock)) {
            sql.append(" AND quantity > 0");
        }

        if ("price_asc".equals(sort)) {
            sql.append(" ORDER BY price ASC");
        } else if ("price_desc".equals(sort)) {
            sql.append(" ORDER BY price DESC");
        } else {
            sql.append(" ORDER BY created_at DESC");
        }

        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql.toString())) {

            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                pst.setString(idx++, "%" + search + "%");
            }

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    
    
    public static void upsertMaterial(
            String name,
            String description,
            double price,
            int quantity,
            String imagePath) throws Exception {

        String checkSql = "SELECT id FROM material WHERE name = ?";
        String insertSql =
            "INSERT INTO material (name, description, price, quantity, image_path) " +
            "VALUES (?, ?, ?, ?, ?)";

        String updateSql =
            "UPDATE material SET description=?, price=?, quantity=?, image_path=? " +
            "WHERE name=?";

        try (Connection con = DBConnection.getConnection()) {

            // Check existing
            PreparedStatement psCheck = con.prepareStatement(checkSql);
            psCheck.setString(1, name);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // 🔁 UPDATE
                PreparedStatement psUpdate = con.prepareStatement(updateSql);
                psUpdate.setString(1, description);
                psUpdate.setDouble(2, price);
                psUpdate.setInt(3, quantity);
                psUpdate.setString(4, imagePath);
                psUpdate.setString(5, name);
                psUpdate.executeUpdate();

            } else {
                // ➕ INSERT
                PreparedStatement psInsert = con.prepareStatement(insertSql);
                psInsert.setString(1, name);
                psInsert.setString(2, description);
                psInsert.setDouble(3, price);
                psInsert.setInt(4, quantity);
                psInsert.setString(5, imagePath);
                psInsert.executeUpdate();
            }
        }
    }

    
    /* ================= FIND BY ID ================= */
    public static Material findById(int id) throws Exception {
        String sql = "SELECT * FROM material WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {

            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    /* ================= INSERT ================= */
    public static void insert(Material m) throws Exception {
        String sql =
            "INSERT INTO material (name, description, price, quantity, image_path) VALUES (?,?,?,?,?)";

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

    /* ================= UPDATE ================= */
    public static void update(Material m) throws Exception {
        String sql =
            "UPDATE material SET name=?, description=?, price=?, quantity=?, image_path=? WHERE id=?";

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

    /* ================= DELETE ================= */
    public static void delete(int id) throws Exception {
        String sql = "DELETE FROM material WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {

            pst.setInt(1, id);
            pst.executeUpdate();
        }
    }

    /* ================= COMMON MAPPER ================= */
    private static Material mapRow(ResultSet rs) throws Exception {
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
