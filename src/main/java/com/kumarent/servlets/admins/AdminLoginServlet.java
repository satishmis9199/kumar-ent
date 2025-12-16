package com.kumarent.servlets.admins;

import com.kumarent.dao.AdminDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    // Show login page when someone visits /admin/login via browser (GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // forward to login.jsp (place under /src/main/webapp/admin/login.jsp)
        req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
    }

    // Handle login submission (POST)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");
        try {
            boolean ok = AdminDAO.validate(user, pass);
            if (ok) {
//            	System.out.println("Admin with username has succcessfully loged in ",+req.getSession());
                HttpSession session = req.getSession();
                session.setAttribute("adminUser", user);
                System.out.println("Admin with username has succcessfully loged in "+user+req.getSession());
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
            	System.out.println("Invalid Ceredentials");
                req.setAttribute("error", "Invalid credentials");
                req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
