package com.kumarent.dao;

import com.kumarent.util.DBConnection;
import java.sql.*;

public class DeliveryDAO {

    public static String checkDelivery(int pincode) throws Exception {
        String sql = "SELECT serviceable, delivery_time FROM delivery_pincode WHERE pincode=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, pincode);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                boolean ok = rs.getBoolean("serviceable");
                if (ok) {
                    return "Delivery available in " + rs.getString("delivery_time");
                } else {
                    return "Not serviceable in your area";
                }
            }
        }
        return "Not serviceable in your area";
    }
}
