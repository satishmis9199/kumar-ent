package com.kumarent.dao;

import com.kumarent.model.Order;
import com.kumarent.model.OrderItem;
import com.kumarent.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    public static int saveOrder(Order order) throws Exception {
        String sqlOrder = "INSERT INTO orders (order_uid, customer_name, customer_contact, customer_email, address, total_amount, status) VALUES (?,?,?,?,?,?,?)";
        String sqlItem = "INSERT INTO order_item (order_id, material_id, material_name, quantity, price_each) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement pst = c.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                pst.setString(1, order.getOrderUid());
                pst.setString(2, order.getCustomerName());
                pst.setString(3, order.getCustomerContact());
                pst.setString(4, order.getCustomerEmail());
                pst.setString(5, order.getAddress());
                pst.setDouble(6, order.getTotalAmount());
                pst.setString(7, order.getStatus());
                pst.executeUpdate();
                try (ResultSet rs = pst.getGeneratedKeys()) {
                    rs.next();
                    int orderId = rs.getInt(1);
                    try (PreparedStatement pstItem = c.prepareStatement(sqlItem)) {
                        for (OrderItem it : order.getItems()) {
                            pstItem.setInt(1, orderId);
                            pstItem.setInt(2, it.getMaterialId());
                            pstItem.setString(3, it.getMaterialName());
                            pstItem.setInt(4, it.getQuantity());
                            pstItem.setDouble(5, it.getPriceEach());
                            pstItem.addBatch();

                            // reduce stock
                            try (PreparedStatement pstUpd = c.prepareStatement("UPDATE material SET quantity = quantity - ? WHERE id = ?")) {
                                pstUpd.setInt(1, it.getQuantity());
                                pstUpd.setInt(2, it.getMaterialId());
                                pstUpd.executeUpdate();
                            }
                        }
                        pstItem.executeBatch();
                    }
                    c.commit();
                    return orderId;
                }
            } catch (Exception ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    public static Order findByOrderUid(String uid) throws Exception {
        String sql = "SELECT * FROM orders WHERE order_uid = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql)) {
            pst.setString(1, uid);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setOrderUid(rs.getString("order_uid"));
                    o.setCustomerName(rs.getString("customer_name"));
                    o.setCustomerContact(rs.getString("customer_contact"));
                    o.setCustomerEmail(rs.getString("customer_email"));
                    o.setAddress(rs.getString("address"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(rs.getString("status"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));

                    // load items
                    List<OrderItem> items = new ArrayList<>();
                    try (PreparedStatement pstItem = c.prepareStatement("SELECT * FROM order_item WHERE order_id = ?")) {
                        pstItem.setInt(1, o.getId());
                        try (ResultSet rs2 = pstItem.executeQuery()) {
                            while (rs2.next()) {
                                OrderItem it = new OrderItem();
                                it.setId(rs2.getInt("id"));
                                it.setOrderId(rs2.getInt("order_id"));
                                it.setMaterialId(rs2.getInt("material_id"));
                                it.setMaterialName(rs2.getString("material_name"));
                                it.setQuantity(rs2.getInt("quantity"));
                                it.setPriceEach(rs2.getDouble("price_each"));
                                items.add(it);
                            }
                        }
                    }
                    o.setItems(items);
                    return o;
                }
            }
        }
        return null;
    }

    public static List<Order> listAll() throws Exception {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setOrderUid(rs.getString("order_uid"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setCustomerContact(rs.getString("customer_contact"));
                o.setCustomerEmail(rs.getString("customer_email"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        }
        return list;
    }

    public static boolean updateStatusIfForward(String uid, String newStatus) throws Exception {
        Map<String,Integer> rank = new HashMap<>();
        rank.put("Pending",1);
        rank.put("Approved",2);
        rank.put("Packed",3);
        rank.put("OutForDelivery",4);
        rank.put("Delivered",5);

        try (Connection c = DBConnection.getConnection();
             PreparedStatement pst = c.prepareStatement("SELECT status FROM orders WHERE order_uid = ?")) {
            pst.setString(1, uid);
            try (ResultSet rs = pst.executeQuery()) {
                if (!rs.next()) return false;
                String current = rs.getString("status");
                int cr = rank.getOrDefault(current, 0);
                int nr = rank.getOrDefault(newStatus, 0);
                if (nr == cr + 1) {
                    try (PreparedStatement pUpdate = c.prepareStatement("UPDATE orders SET status = ? WHERE order_uid = ?")) {
                        pUpdate.setString(1, newStatus);
                        pUpdate.setString(2, uid);
                        pUpdate.executeUpdate();
                        return true;
                    }
                } else return false;
            }
        }
    }
}
