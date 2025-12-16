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

@WebServlet("/placeOrder")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("shop.jsp");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect("shop.jsp");
            return;
        }

        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String address = req.getParameter("address");

        String orderUid = OrderIdGenerator.generate();

        Order order = new Order();
        order.setOrderUid(orderUid);
        order.setCustomerName(name);
        order.setCustomerContact(phone);
        order.setCustomerEmail(email);
        order.setAddress(address);
        order.setStatus("Pending");

        double total = 0;
        List<OrderItem> items = new ArrayList<>();

        for (CartItem ci : cart) {
            OrderItem it = new OrderItem();
            it.setMaterialId(ci.getMaterialId());
            it.setMaterialName(ci.getName());
            it.setQuantity(ci.getQty());
            it.setPriceEach(ci.getPrice());
            items.add(it);
            total += ci.getPrice() * ci.getQty();
        }

        order.setItems(items);
        order.setTotalAmount(total);

        try {
            // 1️⃣ Save order
            int orderId = OrderDAO.saveOrder(order);
            System.out.println("Order placed with ID: " + orderId);

            // 2️⃣ Notify Admin (simple email)
            String adminEmail = AdminDAO.getAdminEmail();
            String adminBody =
                    "New order received.\n\n" +
                    "Order ID: " + orderUid + "\n" +
                    "Customer: " + name + "\n" +
                    "Phone: " + phone + "\n" +
                    "Email: " + email + "\n" +
                    "Total: ₹" + total;

            EmailUtil.sendEmail(
                    adminEmail,
                    "New Order Received - " + orderUid,
                    adminBody
            );

            // 3️⃣ Generate Invoice PDF (IN MEMORY)
            byte[] invoicePdf = InvoicePdfGenerator.generateInvoice(order);

            // 4️⃣ Send customer email WITH INVOICE ATTACHED
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

            EmailUtil.sendEmailWithPdfBytes(
                    email,
                    "Invoice & Order Confirmation - " + orderUid,
                    userBody,
                    invoicePdf,
                    "Invoice_" + orderUid + ".pdf"
            );

            // 5️⃣ Clear cart & forward to success page
            session.removeAttribute("cart");
            req.setAttribute("orderUid", orderUid);
            req.getRequestDispatcher("orderSuccess.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
