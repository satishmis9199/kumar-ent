package com.kumarent.servlets.admins;

import com.kumarent.dao.MaterialDAO;
import com.kumarent.model.Material;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/updateMaterial")
public class UpdateMaterialServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // optional: forward to edit page if someone visits via GET
        req.getRequestDispatcher("/admin/editMaterial.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("id");
        String name = (req.getParameter("name") == null) ? "" : req.getParameter("name").trim();
        String desc = (req.getParameter("description") == null) ? "" : req.getParameter("description").trim();
        String priceStr = req.getParameter("price");
        String qtyStr = req.getParameter("quantity");
        String imagePath = (req.getParameter("imagePath") == null) ? "" : req.getParameter("imagePath").trim();

        // basic validation
        if (idStr == null || idStr.isEmpty()) {
            req.setAttribute("error", "Missing material id.");
            req.getRequestDispatcher("/admin/editMaterial.jsp").forward(req, resp);
            return;
        }

        int id;
        double price;
        int qty;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException nfe) {
            req.setAttribute("error", "Invalid material id.");
            req.getRequestDispatcher("/admin/editMaterial.jsp?id=" + idStr).forward(req, resp);
            return;
        }

        try {
            price = Double.parseDouble((priceStr == null || priceStr.isEmpty()) ? "0" : priceStr);
            if (price < 0) throw new NumberFormatException("negative");
        } catch (NumberFormatException nfe) {
            req.setAttribute("error", "Please enter a valid non-negative price.");
            req.getRequestDispatcher("/admin/editMaterial.jsp?id=" + id).forward(req, resp);
            return;
        }

        try {
            qty = Integer.parseInt((qtyStr == null || qtyStr.isEmpty()) ? "0" : qtyStr);
            if (qty < 0) throw new NumberFormatException("negative");
        } catch (NumberFormatException nfe) {
            req.setAttribute("error", "Please enter a valid non-negative quantity.");
            req.getRequestDispatcher("/admin/editMaterial.jsp?id=" + id).forward(req, resp);
            return;
        }

        if (name.isEmpty()) {
            req.setAttribute("error", "Name cannot be empty.");
            req.getRequestDispatcher("/admin/editMaterial.jsp?id=" + id).forward(req, resp);
            return;
        }

        Material m = new Material();
        m.setId(id);
        m.setName(name);
        m.setDescription(desc);
        m.setPrice(price);
        m.setQuantity(qty);
        m.setImagePath(imagePath.isEmpty() ? null : imagePath);

        try {
        	System.out.println("Material wwith name :"+m.getName()+"has successfully updated");
            MaterialDAO.update(m);
            resp.sendRedirect(req.getContextPath() + "/admin/viewMaterials.jsp?msg=updated");
        } catch (Exception e) {
            // log stack trace (use logger in real app)
        	System.out.println("cannot be updated: "+e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Server error while updating material: " + e.getMessage());
            req.getRequestDispatcher("/admin/editMaterial.jsp?id=" + id).forward(req, resp);
        }
    }
}
