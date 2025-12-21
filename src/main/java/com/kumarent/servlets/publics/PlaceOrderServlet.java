package com.kumarent.servlets.publics;

import com.kumarent.dao.AdminDAO;
import com.kumarent.dao.OrderDAO;
import com.kumarent.model.CartItem;
import com.kumarent.model.Order;
import com.kumarent.model.OrderItem;
import com.kumarent.util.EmailUtil;
import com.kumarent.util.OrderIdGenerator;
import com.kumarent.util.InvoicePdfGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/placeOrder")
public class PlaceOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ✅ Logger
    private static final Logger LOGGER =
            Logger.getLogger(PlaceOrderServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        LOGGER.info("📥 PlaceOrder request received");

        HttpSession session = req.getSession(false);
        if (session == null) {
            LOGGER.warning("⚠ Session not found, redirecting to shop.jsp");
            resp.sendRedirect("shop.jsp");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            LOGGER.warning("⚠ Cart empty, redirecting to shop.jsp");
            resp.sendRedirect("shop.jsp");
            return;
        }

        // 🔹 Customer details
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String address = req.getParameter("address");

        LOGGER.info("👤 Customer details received: "
                + name + ", " + phone + ", " + email);

        String orderUid = OrderIdGenerator.generate();
        LOGGER.info("🆔 Generated Order UID: " + orderUid);

        Order order = new Order();
        order.setOrderUid(orderUid);
        order.setCustomerName(name);
        order.setCustomerContact(phone);
        order.setCustomerEmail(email);
        order.setAddress(address);
        order.setStatus("Pending");

        double total = 0;
        List<OrderItem> items = new ArrayList<>();

        LOGGER.info("🛒 Processing cart items");

        for (CartItem ci : cart) {
            OrderItem it = new OrderItem();
            it.setMaterialId(ci.getMaterialId());
            it.setMaterialName(ci.getName());
            it.setQuantity(ci.getQty());
            it.setPriceEach(ci.getPrice());
            items.add(it);

            total += ci.getPrice() * ci.getQty();

            LOGGER.fine("➕ Item added: "
                    + ci.getName()
                    + " x " + ci.getQty()
                    + " = ₹" + (ci.getPrice() * ci.getQty()));
        }

        order.setItems(items);
        order.setTotalAmount(total);

        LOGGER.info("💰 Order total calculated: ₹" + total);

        try {
            // 1️⃣ Save order
            LOGGER.info("💾 Saving order to database");
            int orderId = OrderDAO.saveOrder(order);
            LOGGER.info("✅ Order saved with DB ID: " + orderId);

            // 2️⃣ Notify Admin
            LOGGER.info("📧 Fetching admin email");
            String adminEmail = AdminDAO.getAdminEmail();

            String adminBody =
                    "New order received.\n\n" +
                    "Order ID: " + orderUid + "\n" +
                    "Customer: " + name + "\n" +
                    "Phone: " + phone + "\n" +
                    "Email: " + email + "\n" +
                    "Total: ₹" + total;

            LOGGER.info("📧 Sending admin notification email");
            EmailUtil.sendEmail(
                    adminEmail,
                    "New Order Received - " + orderUid,
                    adminBody
            );
            LOGGER.info("✅ Admin email sent");

            // 3️⃣ Generate Invoice PDF
            LOGGER.info("🧾 Generating invoice PDF");
            byte[] invoicePdf = InvoicePdfGenerator.generateInvoice(order);
            LOGGER.info("✅ Invoice PDF generated");

            // 4️⃣ Send customer email with invoice
            String userBody =
                    "Dear " + name + ",\n\n" +
                    "Thank you for shopping with Kumar Ent Udyog & Traders.\n\n" +
                    "Order ID: " + orderUid + "\n" +
                    "Total Amount: ₹" + total + "\n\n" +
                    "Your GST Invoice is attached with this email.\n\n" +
                    "You can track your order here:\n" +
                    "http://localhost:8080/kumar-ent/orderStatus.jsp\n\n" +
                    "Regards,\n" +
                    "Kumar Ent Udyog & Traders\n" +
                    "Satish Kumar Mishra";

            LOGGER.info("📨 Sending customer email with invoice");
            EmailUtil.sendEmailWithPdfBytes(
                    email,
                    "Invoice & Order Confirmation - " + orderUid,
                    userBody,
                    invoicePdf,
                    "Invoice_" + orderUid + ".pdf"
            );
            LOGGER.info("✅ Customer email sent successfully");

            // 5️⃣ Clear cart & success page
            session.removeAttribute("cart");
            LOGGER.info("🧹 Cart cleared from session");

            req.setAttribute("orderUid", orderUid);
            LOGGER.info("➡ Forwarding to orderSuccess.jsp");

            req.getRequestDispatcher("orderSuccess.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "❌ Error while placing order: " + orderUid, e);
            throw new ServletException(e);
        }
    }
}
