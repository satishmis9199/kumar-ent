package com.kumarent.servlets.admins;

import com.kumarent.dao.OfferDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/activateOffer")
public class ActivateOfferServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(req.getParameter("offerId"));
            OfferDAO.activateOffer(id);

            resp.sendRedirect(req.getContextPath() + "/admin/manageOffer.jsp");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
