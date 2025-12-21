package com.kumarent.servlets.publics;

import com.kumarent.dao.DeliveryDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/checkDelivery")
public class CheckDeliveryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int pincode = Integer.parseInt(req.getParameter("pincode"));
            String result = DeliveryDAO.checkDelivery(pincode);

            req.setAttribute("deliveryResult", result);
            req.getRequestDispatcher("shop.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("deliveryResult", "Invalid pincode");
            req.getRequestDispatcher("shop.jsp").forward(req, resp);
        }
    }
}
