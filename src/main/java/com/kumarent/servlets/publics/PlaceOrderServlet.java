package com.kumarent.servlets.publics;

import com.kumarent.dao.AdminDAO;
import com.kumarent.dao.OrderDAO;
import com.kumarent.model.CartItem;
import com.kumarent.model.Order;
import com.kumarent.model.OrderItem;
import com.kumarent.util.EmailUtil;
import com.kumarent.util.OrderIdGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/placeOrder")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect("shop.jsp"); return; }
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) { resp.sendRedirect("shop.jsp"); return; }

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
            int orderId = OrderDAO.saveOrder(order);
            String adminEmail = AdminDAO.getAdminEmail();
            String adminBody = "New order received.\nOrder ID: " + orderUid + "\nCustomer: " + name + "\nPhone: " + phone + "\nEmail: " + email + "\nTotal: ₹" + total;
            EmailUtil.sendEmail(adminEmail, "New Order: " + orderUid, adminBody);
            System.out.println("order placed with order id: "+orderId);
            String userBody = "Dear " + name + ",\n\nYour order has been placed successfully.\nOrder ID: " + orderUid + "\nTotal: ₹" + total + "\nYou can check status at: http://localhost:8080/kumar-ent/orderStatus.jsp\n\nThanks, Kumar Ent Udyog & Traders\\nSatish Kumar Mishra";
            EmailUtil.sendEmail(email, "Order Confirmation - " + orderUid, userBody);

            session.removeAttribute("cart");
            req.setAttribute("orderUid", orderUid);
            req.getRequestDispatcher("orderSuccess.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
