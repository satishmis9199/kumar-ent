package com.kumarent.util;

import com.kumarent.model.Order;
import com.kumarent.model.OrderItem;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.text.DecimalFormat;

public class InvoicePdfGenerator {

    private static final double GST_RATE = 0.18; // 18% GST
    private static final DecimalFormat df = new DecimalFormat("0.00");

    public static byte[] generateInvoice(Order order) throws Exception {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        Document doc = new Document(PageSize.A4, 36, 36, 36, 36);
        PdfWriter.getInstance(doc, baos);
        doc.open();

        // 🎨 COLORS
        Color primary = new Color(13, 110, 253);
        Color lightGray = new Color(245, 245, 245);
        Color success = new Color(25, 135, 84);

        // 🔤 FONTS
        Font shopFont = new Font(Font.HELVETICA, 18, Font.BOLD, primary);
        Font bold = new Font(Font.HELVETICA, 11, Font.BOLD);
        Font normal = new Font(Font.HELVETICA, 11);
        Font whiteBold = new Font(Font.HELVETICA, 11, Font.BOLD, Color.WHITE);

        // ===== HEADER =====
        Paragraph shop = new Paragraph("Kumar Ent Udyog & Traders", shopFont);
        shop.setAlignment(Element.ALIGN_CENTER);
        doc.add(shop);

        Paragraph gstLine = new Paragraph(
                "GSTIN: 09ABCDE1234F1Z5 | Phone: 7366948743",
                normal
        );
        gstLine.setAlignment(Element.ALIGN_CENTER);
        gstLine.setSpacingAfter(10);
        doc.add(gstLine);

        Paragraph invoiceTitle = new Paragraph("TAX INVOICE\n\n", bold);
        invoiceTitle.setAlignment(Element.ALIGN_CENTER);
        doc.add(invoiceTitle);

        // ===== CUSTOMER & ORDER INFO =====
        PdfPTable info = new PdfPTable(2);
        info.setWidthPercentage(100);
        info.setSpacingAfter(10);

        info.addCell(infoCell("Invoice No: INV-" + order.getId(), bold));
        info.addCell(infoCell("Order ID: " + order.getOrderUid(), normal));

        info.addCell(infoCell(
                "Bill To:\n" +
                order.getCustomerName() + "\n" +
                order.getCustomerContact() + "\n" +
                order.getAddress(),
                normal
        ));

        info.addCell(infoCell("Invoice Date: " + order.getCreatedAt(), normal));

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

        boolean alt = false;
        double taxableTotal = 0;
        double gstTotal = 0;
        double grandTotal = 0;

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
            table.addCell(cell("7207", bg)); // Default HSN
            table.addCell(cell(String.valueOf(it.getQuantity()), bg));
            table.addCell(cell("₹ " + df.format(it.getPriceEach()), bg));
            table.addCell(cell("₹ " + df.format(taxable), bg));
            table.addCell(cell("₹ " + df.format(gst), bg));
            table.addCell(cell("₹ " + df.format(total), bg));
        }

        doc.add(table);

        // ===== TOTALS =====
        PdfPTable totals = new PdfPTable(2);
        totals.setWidthPercentage(40);
        totals.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totals.setSpacingBefore(10);

        totals.addCell(totalCell("Taxable Value", taxableTotal, bold, lightGray));
        totals.addCell(totalCell("CGST (9%)", gstTotal / 2, normal, lightGray));
        totals.addCell(totalCell("SGST (9%)", gstTotal / 2, normal, lightGray));
        totals.addCell(totalCell("Total GST", gstTotal, bold, lightGray));
        totals.addCell(totalCell("Net Payable", grandTotal, bold, success));

        doc.add(totals);

        // ===== DECLARATION =====
        Paragraph declaration = new Paragraph(
                "\nDeclaration:\nWe declare that this invoice shows the actual " +
                "price of the goods described and that all particulars are true and correct.",
                normal
        );
        declaration.setSpacingBefore(20);
        doc.add(declaration);

        Paragraph sign = new Paragraph(
                "\nFor Kumar Ent Udyog & Traders\n\nAuthorised Signatory",
                bold
        );
        sign.setAlignment(Element.ALIGN_RIGHT);
        sign.setSpacingBefore(20);
        doc.add(sign);

        doc.close();
        return baos.toByteArray();
    }

    // ===== Helper Methods =====

    private static PdfPCell infoCell(String text, Font font) {
        PdfPCell c = new PdfPCell(new Phrase(text, font));
        c.setPadding(8);
        return c;
    }

    private static PdfPCell cell(String text, Color bg) {
        PdfPCell c = new PdfPCell(new Phrase(text));
        c.setBackgroundColor(bg);
        c.setPadding(6);
        c.setHorizontalAlignment(Element.ALIGN_CENTER);
        return c;
    }

    private static PdfPCell totalCell(String label, double value, Font f, Color bg) {
        PdfPCell c = new PdfPCell(
                new Phrase(label + " : ₹ " + df.format(value), f)
        );
        c.setBackgroundColor(bg);
        c.setPadding(8);
        c.setColspan(2);
        return c;
    }
}
