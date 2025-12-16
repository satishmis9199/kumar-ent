package com.kumarent.servlets.admins;

import com.kumarent.dao.OfferDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/saveOffer")
public class SaveOfferServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String message = req.getParameter("message");

            if (message == null || message.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/manageOffer.jsp?error=empty");
                return;
            }

            OfferDAO.deactivateAllOffers();
            OfferDAO.addOffer(message.trim());

            resp.sendRedirect(req.getContextPath() + "/admin/manageOffer.jsp?success=added");

        } catch (Exception e) {
            throw new ServletException("Error while saving offer", e);
        }
    }
}
