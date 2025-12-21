package com.kumarent.servlets.admins;
import com.kumarent.dao.MaterialDAO;
import com.kumarent.util.ExcelUtil;
import com.mysql.cj.x.protobuf.MysqlxNotice.Warning.Level;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

import java.io.InputStream;
import java.util.logging.Logger;
@WebServlet("/admin/uploadMaterialExcel")
@MultipartConfig
public class UploadMaterialExcelServlet extends HttpServlet {

	 private static final Logger LOGGER =
	            Logger.getLogger(AdminLoginServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException {

        try {
            Part filePart = req.getPart("excelFile");

            if (filePart == null || filePart.getSize() == 0) {
                resp.sendRedirect("uploadMaterialExcel.jsp?error=NoFile");
                return;
            }

            try (InputStream is = filePart.getInputStream();
                 Workbook workbook = WorkbookFactory.create(is)) {

                Sheet sheet = workbook.getSheetAt(0);

                int inserted = 0;
                int skipped = 0;

                for (int i = 1; i <= sheet.getLastRowNum(); i++) {

                    Row row = sheet.getRow(i);
                    if (row == null) {
                        skipped++;
                        continue;
                    }

                    String name =
                        ExcelUtil.getString(row.getCell(0));

                    if (name == null || name.isEmpty()) {
                        skipped++;
                        continue; // 🔥 NAME IS MANDATORY
                    }

                    String desc =
                        ExcelUtil.getString(row.getCell(1));

                    double price =
                        ExcelUtil.getDouble(row.getCell(2));

                    int qty =
                        ExcelUtil.getInt(row.getCell(3));

                    String imagePath =
                        ExcelUtil.getString(row.getCell(4));

                    MaterialDAO.upsertMaterial(
                            name, desc, price, qty, imagePath
                    );

                    inserted++;
                }

                LOGGER.info("Excel import completed. Inserted=" +
                        inserted + ", Skipped=" + skipped);
            }

            resp.sendRedirect(
                    "viewMaterials.jsp?success=imported");

        } catch (Exception e) {
            LOGGER.info(
                    "Excel material upload failed");
            throw new ServletException(e);
        }
    }
}
