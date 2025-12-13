package com.kumarent.servlets.publics;

import com.kumarent.dao.OrderDAO;
import com.kumarent.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/checkOrder")
public class CheckOrderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderUid = req.getParameter("orderUid");
        if (orderUid == null || orderUid.trim().isEmpty()) {
            req.getRequestDispatcher("orderStatus.jsp").forward(req, resp);
            return;
        }
        try {
            Order o = OrderDAO.findByOrderUid(orderUid.trim());
            if (o == null) {
                req.setAttribute("found", false);
            } else {
                req.setAttribute("found", true);
                req.setAttribute("order", o);
            }
            req.getRequestDispatcher("orderStatus.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
