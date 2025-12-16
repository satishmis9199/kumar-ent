package com.kumarent.servlets.admins;

import com.kumarent.dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/salesReport")
public class SalesReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fromDate = req.getParameter("from");
        String toDate = req.getParameter("to");

        if (fromDate != null && toDate != null) {
            try {
                Date from = Date.valueOf(fromDate);
                Date to = Date.valueOf(toDate);

                int totalOrders = OrderDAO.countOrdersBetween(from, to);
                double revenue = OrderDAO.revenueBetween(from, to);

                double gst = revenue * 0.18;
                double cgst = gst / 2;
                double sgst = gst / 2;
                double netAmount = revenue - gst;

                req.setAttribute("totalOrders", totalOrders);
                req.setAttribute("revenue", revenue);
                req.setAttribute("gst", gst);
                req.setAttribute("cgst", cgst);
                req.setAttribute("sgst", sgst);
                req.setAttribute("netAmount", netAmount);

            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        req.getRequestDispatcher("/admin/salesReport.jsp")
           .forward(req, resp);
    }
}
