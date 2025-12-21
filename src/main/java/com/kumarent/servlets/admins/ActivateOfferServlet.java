package com.kumarent.servlets.admins;

import com.kumarent.dao.OfferDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/activateOffer")
public class ActivateOfferServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ✅ Logger
    private static final Logger LOGGER =
            Logger.getLogger(ActivateOfferServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        LOGGER.info("📥 ActivateOffer request received");

        try {
            String offerIdParam = req.getParameter("offerId");

            if (offerIdParam == null || offerIdParam.isEmpty()) {
                LOGGER.warning("⚠ offerId parameter missing");
                resp.sendRedirect(req.getContextPath() + "/admin/manageOffer.jsp");
                return;
            }

            int id = Integer.parseInt(offerIdParam);
            LOGGER.info("🔑 Activating offer with ID: " + id);

            OfferDAO.activateOffer(id);

            LOGGER.info("✅ Offer activated successfully. ID: " + id);

            String redirectUrl =
                    req.getContextPath() + "/admin/manageOffer.jsp";

            LOGGER.info("➡ Redirecting admin to: " + redirectUrl);
            resp.sendRedirect(redirectUrl);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE,
                    "❌ Invalid offerId value", e);
            throw new ServletException("Invalid offer ID", e);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "❌ Error while activating offer", e);
            throw new ServletException(e);
        }
    }
}