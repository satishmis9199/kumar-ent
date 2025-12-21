package com.kumarent.servlets.admins;

import com.kumarent.dao.MaterialDAO;
import com.kumarent.model.Material;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/exportMaterialExcel")
public class ExportMaterialExcelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Material> materials = MaterialDAO.listAll();

            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Materials");

            // ✅ Header row
            Row header = sheet.createRow(0);
            String[] columns = {
                "Name", "Description", "Price", "Quantity", "Image Path"
            };

            for (int i = 0; i < columns.length; i++) {
                header.createCell(i).setCellValue(columns[i]);
            }

            // ✅ Data rows
            int rowNum = 1;
            for (Material m : materials) {
                Row row = sheet.createRow(rowNum++);

                row.createCell(0).setCellValue(m.getName());
                row.createCell(1).setCellValue(m.getDescription());
                row.createCell(2).setCellValue(m.getPrice());
                row.createCell(3).setCellValue(m.getQuantity());
                row.createCell(4).setCellValue(m.getImagePath());
            }

            // Auto-size columns
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // ✅ Response headers (DOWNLOAD)
            resp.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            );
            resp.setHeader(
                "Content-Disposition",
                "attachment; filename=KUMARMATERIAL.xlsx"
            );
            req.getSession().setAttribute("EXPORT_SUCCESS", true);


            workbook.write(resp.getOutputStream());
            workbook.close();

        } catch (Exception e) {
            throw new ServletException("Failed to export material excel", e);
        }
        
    }
}
