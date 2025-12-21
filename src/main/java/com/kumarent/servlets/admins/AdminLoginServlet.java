package com.kumarent.servlets.admins;

import com.kumarent.dao.AdminDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ✅ Logger
    private static final Logger LOGGER =
            Logger.getLogger(AdminLoginServlet.class.getName());

    // ===============================
    // SHOW LOGIN PAGE
    // ===============================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        LOGGER.info("📥 Admin login page requested");
        req.getRequestDispatcher("/admin/login.jsp")
           .forward(req, resp);
    }

    // ===============================
    // HANDLE LOGIN
    // ===============================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        LOGGER.info("🔐 Admin login attempt for username: " + user);

        // 🔎 Basic validation
        if (user == null || pass == null
                || user.isBlank() || pass.isBlank()) {

            LOGGER.warning("⚠ Empty username or password submitted");

            req.setAttribute("error", "Username and password are required");
            req.getRequestDispatcher("/admin/login.jsp")
               .forward(req, resp);
            return;
        }

        try {
            boolean ok = AdminDAO.validate(user, pass);

            if (ok) {
                HttpSession session = req.getSession(true);

                // 🔐 Session security
                session.invalidate();
                session = req.getSession(true);

                session.setAttribute("adminUser", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                LOGGER.info("✅ Admin login successful: " + user);
                LOGGER.info("➡ Redirecting to admin dashboard");

                resp.sendRedirect(
                        req.getContextPath() + "/admin/dashboard");

            } else {
                LOGGER.warning("❌ Invalid admin credentials for: " + user);

                req.setAttribute("error", "Invalid credentials");
                req.getRequestDispatcher("/admin/login.jsp")
                   .forward(req, resp);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "❌ Error during admin login for user: " + user, e);
            throw new ServletException(e);
        }
    }
}
