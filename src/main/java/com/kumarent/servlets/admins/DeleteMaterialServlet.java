package com.kumarent.servlets.admins;

import com.kumarent.dao.MaterialDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/deleteMaterial")
public class DeleteMaterialServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idS = req.getParameter("id");
        if (idS == null || idS.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/viewMaterials.jsp?msg=invalid");
            return;
        }
        try {
            int id = Integer.parseInt(idS);
            MaterialDAO.delete(id);
            System.out.println("Material with :"+idS+"Deleted successfolly");
            resp.sendRedirect(req.getContextPath() + "/admin/viewMaterials.jsp?msg=deleted");
        } catch (NumberFormatException nfe) {
            resp.sendRedirect(req.getContextPath() + "/admin/viewMaterials.jsp?msg=invalid");
        } catch (Exception e) {
        	System.out.println(e.getMessage());
            throw new ServletException(e);
        }
    }
}
