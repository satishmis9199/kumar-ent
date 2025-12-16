package com.kumarent.servlets.admins;

import com.kumarent.dao.OfferDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/disableOffer")
public class DisableOfferServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            OfferDAO.deactivateAllOffers();
            resp.sendRedirect(req.getContextPath() + "/admin/manageOffer.jsp?success=disabled");

        } catch (Exception e) {
            throw new ServletException("Error while disabling offer", e);
        }
    }
}
