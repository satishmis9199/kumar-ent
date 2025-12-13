package com.kumarent.servlets.admins;

import com.kumarent.dao.OrderDAO;
import com.kumarent.dao.AdminDAO;
import com.kumarent.model.Order;
import com.kumarent.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/updateStatus")
public class UpdateStatusServlet extends HttpServlet {

    // Show form (GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uid = req.getParameter("uid");
        if (uid == null || uid.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Missing order id");
            resp.sendRedirect(req.getContextPath() + "/admin/viewOrders.jsp");
            return;
        }
        try {
            Order o = OrderDAO.findByOrderUid(uid.trim());
            if (o == null) {
                req.getSession().setAttribute("error", "Order not found: " + uid);
                resp.sendRedirect(req.getContextPath() + "/admin/viewOrders.jsp");
                return;
            }
            req.setAttribute("order", o);
            req.getRequestDispatcher("/admin/updateStatus.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // Apply status update (POST)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uid = req.getParameter("orderUid");
        String newStatusSubmitted = req.getParameter("newStatus"); // expected to be canonical key

        if (uid == null || uid.trim().isEmpty() || newStatusSubmitted == null || newStatusSubmitted.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Invalid request");
            resp.sendRedirect(req.getContextPath() + "/admin/viewOrders.jsp");
            return;
        }

        uid = uid.trim();
        newStatusSubmitted = newStatusSubmitted.trim();

        // canonical arrays (must match DAO expectations)
        String[] keys = {"Pending","Approved","Packed","OutForDelivery","Delivered"};
        String[] labels = {"Pending","Approved","Packed","Out For Delivery","Delivered"};

        try {
            // load current order from DB (source of truth)
            Order currentOrder = OrderDAO.findByOrderUid(uid);
            if (currentOrder == null) {
                req.getSession().setAttribute("error", "Order not found: " + uid);
                resp.sendRedirect(req.getContextPath() + "/admin/viewOrders.jsp");
                return;
            }

            String current = currentOrder.getStatus() == null ? "Pending" : currentOrder.getStatus();

            // find current index by matching against keys or labels (case-insensitive)
            int currentIndex = -1;
            for (int i = 0; i < keys.length; i++) {
                if (keys[i].equalsIgnoreCase(current) || labels[i].equalsIgnoreCase(current)) {
                    currentIndex = i;
                    break;
                }
            }
            if (currentIndex < 0) currentIndex = 0;

            int nextIndex = currentIndex + 1;
            if (nextIndex >= keys.length) {
                req.getSession().setAttribute("error", "Order is already in final status.");
                resp.sendRedirect(req.getContextPath() + "/admin/viewOrders.jsp");
                return;
            }

            String expectedNextKey = keys[nextIndex];     // canonical key to set
            String expectedNextLabel = labels[nextIndex]; // friendly label

            // Accept either canonical key or friendly label from form (normalized)
            String submittedNormalized = newStatusSubmitted.replaceAll("\\s+","").toLowerCase();
            String expectedKeyNormalized = expectedNextKey.replaceAll("\\s+","").toLowerCase();
            String expectedLabelNormalized = expectedNextLabel.replaceAll("\\s+","").toLowerCase();

            if (!(submittedNormalized.equals(expectedKeyNormalized) || submittedNormalized.equals(expectedLabelNormalized))) {
                req.getSession().setAttribute("error", "Invalid status requested. Allowed next status: " + expectedNextLabel);
                resp.sendRedirect(req.getContextPath() + "/admin/viewOrders.jsp");
                return;
            }

            // Call DAO with canonical key
            boolean ok = OrderDAO.updateStatusIfForward(uid, expectedNextKey);

            if (!ok) {
                // helpful debug logging
                System.err.println("UpdateStatusServlet: DAO refused update for uid=" + uid
                        + " current=" + current + " expectedNextKey=" + expectedNextKey
                        + " submitted=" + newStatusSubmitted);
                req.getSession().setAttribute("error", "Invalid status transition or order not found.");
                resp.sendRedirect(req.getContextPath() + "/admin/viewOrders.jsp");
                return;
            }

            // Notify customer if email exists (non-blocking)
            try {
                Order updated = OrderDAO.findByOrderUid(uid);
                if (updated != null && updated.getCustomerEmail() != null && !updated.getCustomerEmail().trim().isEmpty()) {
                    String body = "Hello " + (updated.getCustomerName() == null ? "" : updated.getCustomerName()) + ",\n\n"
                            + "Your order " + uid + " status has been updated to: " + expectedNextLabel + ".\n\n"
                            + "Thanks,\nKumar Ent Udyog & Traders";
                    try { EmailUtil.sendEmail(updated.getCustomerEmail(), "Order Status Updated - " + uid, body); }
                    catch (Exception ex) { ex.printStackTrace(); /* swallow email errors */ }
                }
            } catch (Exception ex) { ex.printStackTrace(); }

            // Notify admin email (non-blocking)
            try {
                String adminEmail = AdminDAO.getAdminEmail();
                if (adminEmail != null && !adminEmail.trim().isEmpty()) {
                    String adminBody = "Order " + uid + " status changed to: " + expectedNextLabel;
                    try { EmailUtil.sendEmail(adminEmail, "Order Status Changed - " + uid, adminBody); }
                    catch (Exception ex) { ex.printStackTrace(); }
                }
            } catch (Exception ex) { /* ignore */ }

            req.getSession().setAttribute("msg", "Status updated to: " + expectedNextLabel);
            resp.sendRedirect(req.getContextPath() + "/admin/viewOrders.jsp");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
