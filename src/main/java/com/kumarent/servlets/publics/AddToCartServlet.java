package com.kumarent.servlets.publics;

import com.kumarent.dao.MaterialDAO;
import com.kumarent.model.CartItem;
import com.kumarent.model.Material;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int materialId = Integer.parseInt(req.getParameter("materialId"));
        int qty = Integer.parseInt(req.getParameter("qty"));
        try {
            Material m = MaterialDAO.findById(materialId);
            if (m == null) { resp.sendRedirect("shop.jsp"); return; }

            HttpSession session = req.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) { cart = new ArrayList<>(); session.setAttribute("cart", cart); }

            boolean found = false;
            for (CartItem it : cart) {
                if (it.getMaterialId() == materialId) {
                    it.setQty(it.getQty() + qty);
                    found = true; break;
                }
            }
            if (!found) cart.add(new CartItem(materialId, m.getName(), qty, m.getPrice()));
            if(found) {
            	System.out.println("added in a cart");
            }
            resp.sendRedirect("cart.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
