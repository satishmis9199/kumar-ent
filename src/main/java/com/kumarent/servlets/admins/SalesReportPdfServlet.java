package com.kumarent.servlets.admins;

import com.kumarent.dao.OrderDAO;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.awt.Color;
import java.io.IOException;

@WebServlet("/admin/salesReportPdf")
public class SalesReportPdfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            java.sql.Date from = java.sql.Date.valueOf(req.getParameter("from"));
            java.sql.Date to = java.sql.Date.valueOf(req.getParameter("to"));

            int totalOrders = OrderDAO.countOrdersBetween(from, to);
            double revenue = OrderDAO.revenueBetween(from, to);

            double gst = revenue * 0.18;
            double cgst = gst / 2;
            double sgst = gst / 2;

            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition",
                    "attachment; filename=Sales_Report.pdf");

            Document doc = new Document(PageSize.A4, 36, 36, 36, 36);
            PdfWriter.getInstance(doc, resp.getOutputStream());
            doc.open();

            /* ================= Fonts ================= */
            Font companyFont = new Font(Font.HELVETICA, 22, Font.BOLD);
            companyFont.setColor(new Color(33, 37, 41));

            Font titleFont = new Font(Font.HELVETICA, 14, Font.BOLD);
            titleFont.setColor(new Color(108, 117, 125));

            Font headerFont = new Font(Font.HELVETICA, 11, Font.BOLD);
            headerFont.setColor(Color.WHITE);

            Font valueFont = new Font(Font.HELVETICA, 11);
            valueFont.setColor(new Color(33, 37, 41));

            Font footerFont = new Font(Font.HELVETICA, 9, Font.ITALIC);
            footerFont.setColor(Color.GRAY);


            /* ================= Header ================= */
            Paragraph company = new Paragraph("Kumar Ent Udyog & Traders", companyFont);
            company.setAlignment(Element.ALIGN_CENTER);
            company.setSpacingAfter(5);
            doc.add(company);

            Paragraph title = new Paragraph("Sales Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(12);
            doc.add(title);

            Paragraph period = new Paragraph(
                    "Period: " + from + "  to  " + to,
                    valueFont
            );
            period.setAlignment(Element.ALIGN_CENTER);
            period.setSpacingAfter(20);
            doc.add(period);

            /* ================= Table ================= */
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(80);
            table.setWidths(new float[]{3, 2});
            table.setSpacingBefore(10);
            table.setSpacingAfter(20);

            PdfPCell header1 = new PdfPCell(new Phrase("Description", headerFont));
            PdfPCell header2 = new PdfPCell(new Phrase("Amount", headerFont));

            header1.setBackgroundColor(new Color(13, 110, 253)); // Bootstrap Blue
            header2.setBackgroundColor(new Color(13, 110, 253));
            header1.setPadding(10);
            header2.setPadding(10);
            header1.setHorizontalAlignment(Element.ALIGN_CENTER);
            header2.setHorizontalAlignment(Element.ALIGN_CENTER);
            header1.setBorderWidth(0);
            header2.setBorderWidth(0);

            table.addCell(header1);
            table.addCell(header2);

            addRow(table, "Total Orders", String.valueOf(totalOrders));
            addRow(table, "Total Revenue", "₹ " + String.format("%.2f", revenue));
            addRow(table, "CGST (9%)", "₹ " + String.format("%.2f", cgst));
            addRow(table, "SGST (9%)", "₹ " + String.format("%.2f", sgst));
            addRow(table, "Total GST (18%)", "₹ " + String.format("%.2f", gst));

            doc.add(table);

            /* ================= Footer ================= */
            Paragraph footer = new Paragraph(
                    "This is a system generated report.\n© Kumar Ent Udyog & Traders",
                    footerFont
            );
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(30);
            doc.add(footer);

            doc.close();

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /* ================= Utility Method ================= */
    private void addRow(PdfPTable table, String label, String value) {

        PdfPCell c1 = new PdfPCell(new Phrase(label));
        PdfPCell c2 = new PdfPCell(new Phrase(value));

        c1.setPadding(10);
        c2.setPadding(10);

        c1.setBorderColor(new Color(222, 226, 230));
        c2.setBorderColor(new Color(222, 226, 230));

        c1.setBackgroundColor(new Color(248, 249, 250)); // light gray
        c2.setHorizontalAlignment(Element.ALIGN_RIGHT);

        table.addCell(c1);
        table.addCell(c2);
    }
}
