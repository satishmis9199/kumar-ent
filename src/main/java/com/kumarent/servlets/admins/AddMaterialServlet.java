package com.kumarent.servlets.admins;

import com.kumarent.dao.MaterialDAO;
import com.kumarent.model.Material;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/admin/addMaterial")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024,            // 5MB
        maxRequestSize = 10 * 1024 * 1024)        // 10MB
public class AddMaterialServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // show the add form
        req.getRequestDispatcher("/admin/addMaterial.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // note: ensure form uses enctype="multipart/form-data"
        req.setCharacterEncoding("UTF-8");

        String name = req.getParameter("name");
        String description = req.getParameter("description");
        double price = 0;
        int qty = 0;
        try {
            price = Double.parseDouble(req.getParameter("price"));
        } catch (Exception ex) { /* leave 0 or handle error */ }
        try {
            qty = Integer.parseInt(req.getParameter("quantity"));
        } catch (Exception ex) { /* leave 0 or handle error */ }

        Part filePart = null;
        try {
            filePart = req.getPart("image");
        } catch (Exception ex) {
            filePart = null;
        }

        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            String submitted = filePart.getSubmittedFileName();
            if (submitted != null) {
                String ext = "";
                int idx = submitted.lastIndexOf('.');
                if (idx > 0 && idx < submitted.length() - 1) {
                    ext = submitted.substring(idx);
                }
                fileName = System.currentTimeMillis() + ext;
                String uploadPath = req.getServletContext().getRealPath("/assets/images");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
            }
        }

        Material m = new Material();
        m.setName(name);
        m.setDescription(description);
        m.setPrice(price);
        m.setQuantity(qty);
        m.setImagePath(fileName == null ? null : (req.getContextPath() + "/assets/images/" + fileName));

        try {
        	System.out.println("Mateerial has been added with name :"+m.getName());
            MaterialDAO.insert(m);
            resp.sendRedirect(req.getContextPath() + "/admin/viewMaterials.jsp?msg=Added");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
