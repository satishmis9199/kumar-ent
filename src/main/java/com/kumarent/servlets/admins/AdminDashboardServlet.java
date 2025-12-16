package com.kumarent.servlets.admins;

import com.kumarent.dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setAttribute("totalOrders", OrderDAO.countAllOrders());
            req.setAttribute("pendingOrders", OrderDAO.countByStatus("Pending"));
            req.setAttribute("deliveredOrders", OrderDAO.countByStatus("Delivered"));
            req.setAttribute("totalRevenue", OrderDAO.totalRevenue());

            req.getRequestDispatcher("/admin/dashboard.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
