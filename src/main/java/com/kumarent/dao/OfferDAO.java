package com.kumarent.dao;

import com.kumarent.model.Offer;
import com.kumarent.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OfferDAO {

    /* Get active offer for shop.jsp */
    public static String getActiveOffer() throws Exception {
        String sql = "SELECT message FROM offer_notice WHERE active = true ORDER BY created_at DESC LIMIT 1";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            if (rs.next()) {
                return rs.getString("message");
            }
        }
        return null;
    }

    /* Add new offer (inactive old ones) */
    public static void addOffer(String message) throws Exception {
        deactivateAllOffers();

        String sql = "INSERT INTO offer_notice (message, active) VALUES (?, true)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {

            pst.setString(1, message);
            pst.executeUpdate();
        }
    }

    /* Disable all offers */
    public static void deactivateAllOffers() throws Exception {
        String sql = "UPDATE offer_notice SET active = false";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {
            pst.executeUpdate();
        }
    }

    /* Activate existing offer */
    public static void activateOffer(int id) throws Exception {
        deactivateAllOffers();

        String sql = "UPDATE offer_notice SET active = true WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {
            pst.setInt(1, id);
            pst.executeUpdate();
        }
    }

    /* List all offers (admin) */
    public static List<Offer> listAllOffers() throws Exception {
        List<Offer> list = new ArrayList<>();

        String sql = "SELECT * FROM offer_notice ORDER BY created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Offer o = new Offer();
                o.setId(rs.getInt("id"));
                o.setMessage(rs.getString("message"));
                o.setActive(rs.getBoolean("active"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        }
        return list;
    }
}
