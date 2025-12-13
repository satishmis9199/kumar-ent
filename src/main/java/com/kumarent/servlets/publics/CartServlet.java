package com.kumarent.servlets.publics;

import com.kumarent.model.CartItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/cartAction")
public class CartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) { resp.sendRedirect("shop.jsp"); return; }

        if ("remove".equals(action)) {
            int materialId = Integer.parseInt(req.getParameter("materialId"));
            cart.removeIf(it -> it.getMaterialId() == materialId);
        } else if ("update".equals(action)) {
            int materialId = Integer.parseInt(req.getParameter("materialId"));
            int qty = Integer.parseInt(req.getParameter("qty"));
            for (CartItem it : cart) {
                if (it.getMaterialId() == materialId) { it.setQty(qty); break; }
            }
        }
        resp.sendRedirect("cart.jsp");
    }
}
