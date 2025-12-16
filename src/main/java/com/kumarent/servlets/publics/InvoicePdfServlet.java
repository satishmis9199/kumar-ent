package com.kumarent.servlets.publics;

import com.kumarent.dao.OrderDAO;
import com.kumarent.model.Order;
import com.kumarent.model.OrderItem;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import javax.servlet.ServletException;


import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.awt.Color;
import java.io.IOException;
import java.text.DecimalFormat;

@WebServlet("/invoicePdf")
public class InvoicePdfServlet extends HttpServlet {

    private static final double GST_RATE = 0.18; // 18%
    private static final DecimalFormat df = new DecimalFormat("0.00");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orderUid = req.getParameter("orderUid");

        try {
            Order order = OrderDAO.findByOrderUid(orderUid);
            if (order == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }

            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition",
                    "attachment; filename=GST_Invoice_" + orderUid + ".pdf");

            Document doc = new Document(PageSize.A4, 36, 36, 36, 36);
            PdfWriter.getInstance(doc, resp.getOutputStream());
            doc.open();

            // 🎨 Colors
            Color primary = new Color(13, 110, 253);
            Color lightGray = new Color(245, 245, 245);
            Color success = new Color(25, 135, 84);

            // 🔤 Fonts
            Font shopFont = new Font(Font.HELVETICA, 18, Font.BOLD, primary);
            Font bold = new Font(Font.HELVETICA, 11, Font.BOLD);
            Font normal = new Font(Font.HELVETICA, 11);
            Font whiteBold = new Font(Font.HELVETICA, 11, Font.BOLD, Color.WHITE);

            // ===== HEADER =====
            Paragraph shop = new Paragraph("Kumar Ent Udyog & Traders", shopFont);
            shop.setAlignment(Element.ALIGN_CENTER);
            doc.add(shop);

            Paragraph gstInfo = new Paragraph(
                    "GSTIN: 09ABCDE1234F1Z5 | Mobile: 7366948743",
                    normal
            );
            gstInfo.setAlignment(Element.ALIGN_CENTER);
            gstInfo.setSpacingAfter(10);
            doc.add(gstInfo);

            // ===== INVOICE INFO =====
            PdfPTable info = new PdfPTable(2);
            info.setWidthPercentage(100);
            info.setSpacingAfter(10);

            info.addCell(infoCell("Invoice No: INV-" + order.getId(), bold));
            info.addCell(infoCell("Invoice Date: " + order.getCreatedAt(), normal));

            info.addCell(infoCell("Bill To:\n" +
                    order.getCustomerName() + "\n" +
                    order.getCustomerContact() + "\n" +
                    order.getAddress(), normal));

            info.addCell(infoCell("Place of Supply: Darbhanga", normal));

            doc.add(info);

            // ===== ITEMS TABLE =====
            PdfPTable table = new PdfPTable(7);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{3, 1.2f, 1, 1, 1.2f, 1.2f, 1.5f});

            String[] headers = {
                    "Material",
                    "HSN",
                    "Qty",
                    "Rate",
                    "Taxable",
                    "GST (18%)",
                    "Total"
            };

            for (String h : headers) {
                PdfPCell hc = new PdfPCell(new Phrase(h, whiteBold));
                hc.setBackgroundColor(primary);
                hc.setPadding(6);
                hc.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(hc);
            }

            double taxableTotal = 0;
            double gstTotal = 0;
            double grandTotal = 0;
            boolean alt = false;

            for (OrderItem it : order.getItems()) {
                Color bg = alt ? lightGray : Color.WHITE;
                alt = !alt;

                double taxable = it.getPriceEach() * it.getQuantity();
                double gst = taxable * GST_RATE;
                double total = taxable + gst;

                taxableTotal += taxable;
                gstTotal += gst;
                grandTotal += total;

                table.addCell(cell(it.getMaterialName(), bg));
                table.addCell(cell("7207", bg));
                table.addCell(cell(String.valueOf(it.getQuantity()), bg));
                table.addCell(cell("₹ " + df.format(it.getPriceEach()), bg));
                table.addCell(cell("₹ " + df.format(taxable), bg));
                table.addCell(cell("₹ " + df.format(gst), bg));
                table.addCell(cell("₹ " + df.format(total), bg));
            }

            doc.add(table);

            // ===== TOTAL SUMMARY =====
            PdfPTable totals = new PdfPTable(2);
            totals.setWidthPercentage(40);
            totals.setHorizontalAlignment(Element.ALIGN_RIGHT);
            totals.setSpacingBefore(10);

            totals.addCell(totalCell("Taxable Value", df.format(taxableTotal), bold, lightGray));
            totals.addCell(totalCell("CGST (9%)", df.format(gstTotal / 2), normal, lightGray));
            totals.addCell(totalCell("SGST (9%)", df.format(gstTotal / 2), normal, lightGray));
            totals.addCell(totalCell("Total GST", df.format(gstTotal), bold, lightGray));
            totals.addCell(totalCell("Net Payable", df.format(grandTotal), bold, success));

            doc.add(totals);

            // ===== DECLARATION =====
            Paragraph decl = new Paragraph(
                    "\nDeclaration:\nWe declare that this invoice shows the actual price " +
                    "of the goods described and that all particulars are true and correct.",
                    normal
            );
            decl.setSpacingBefore(20);
            doc.add(decl);

            Paragraph sign = new Paragraph(
                    "\nFor Kumar Ent Udyog & Traders\n\nAuthorised Signatory",
                    bold
            );
            sign.setAlignment(Element.ALIGN_RIGHT);
            sign.setSpacingBefore(20);
            doc.add(sign);

            doc.close();

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ===== Helpers =====
    private PdfPCell infoCell(String text, Font f) {
        PdfPCell c = new PdfPCell(new Phrase(text, f));
        c.setPadding(8);
        return c;
    }

    private PdfPCell cell(String text, Color bg) {
        PdfPCell c = new PdfPCell(new Phrase(text));
        c.setBackgroundColor(bg);
        c.setPadding(6);
        c.setHorizontalAlignment(Element.ALIGN_CENTER);
        return c;
    }

    private PdfPCell totalCell(String label, String value, Font f, Color bg) {
        PdfPCell c = new PdfPCell(
                new Phrase(label + " : ₹ " + value, f)
        );
        c.setBackgroundColor(bg);
        c.setPadding(8);
        c.setColspan(2);
        return c;
    }
}
