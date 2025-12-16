<%@ page import="com.kumarent.dao.MaterialDAO" %>
<%@ page import="com.kumarent.model.Material" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Materials | Admin</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #eef2ff, #f8fafc);
      font-family: system-ui, -apple-system, 'Segoe UI';
      color: #111827;
    }

    .glass-panel {
      background: rgba(255,255,255,0.9);
      backdrop-filter: blur(12px);
      border-radius: 16px;
      padding: 22px;
      box-shadow: 0 25px 55px rgba(0,0,0,0.1);
    }

    .page-title {
      font-weight: 800;
      letter-spacing: .3px;
    }

    table thead th {
      background: #111827;
      color: #fff;
      position: sticky;
      top: 0;
      z-index: 1;
      font-size: .85rem;
      text-transform: uppercase;
      letter-spacing: .5px;
    }

    table td {
      vertical-align: middle;
    }

    .thumb {
      width: 70px;
      height: 50px;
      object-fit: cover;
      border-radius: 8px;
      border: 1px solid #e5e7eb;
    }

    .stock-pill {
      padding: 4px 10px;
      border-radius: 999px;
      font-size: .75rem;
      font-weight: 700;
      display: inline-block;
    }

    .stock-low { background:#fee2e2; color:#991b1b; }
    .stock-ok { background:#dcfce7; color:#166534; }

    .action-btns .btn {
      margin-right: 4px;
    }
  </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
  <div class="container">
    <span class="navbar-brand fw-bold">Kumar Ent – Admin Panel</span>
    <a href="<%= request.getContextPath() %>/admin/dashboard"
       class="btn btn-outline-dark btn-sm">
      <i class="bi bi-speedometer2"></i> Dashboard
    </a>
  </div>
</nav>

<!-- MAIN -->
<div class="container" style="max-width:1200px;">
  <div class="glass-panel">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
      <div>
        <h3 class="page-title mb-0">Materials</h3>
        <small class="text-muted">Manage product catalog & inventory</small>
      </div>

      <a href="<%= request.getContextPath() %>/admin/addMaterial.jsp"
         class="btn btn-success">
        <i class="bi bi-plus-circle"></i> Add Material
      </a>
    </div>

    <!-- TABLE -->
    <div class="table-responsive">
      <table class="table table-hover align-middle">
        <thead>
          <tr>
            <th>#</th>
            <th>Image</th>
            <th>Material</th>
            <th>Price</th>
            <th>Stock</th>
            <th class="text-center">Actions</th>
          </tr>
        </thead>

        <tbody>
        <%
          try {
            java.util.List<Material> list = MaterialDAO.listAll();
            if (list == null || list.isEmpty()) {
        %>
          <tr>
            <td colspan="6" class="text-center text-muted py-4">
              <i class="bi bi-inbox fs-2 d-block mb-2"></i>
              No materials found
            </td>
          </tr>
        <%
            } else {
              int i = 1;
              for (Material m : list) {
                String img = (m.getImagePath() == null || m.getImagePath().isBlank())
                             ? "https://via.placeholder.com/300x200?text=No+Image"
                             : m.getImagePath();
                boolean lowStock = m.getQuantity() < 10;
        %>
          <tr>
            <td class="fw-semibold"><%= i++ %></td>

            <td>
              <img src="<%= img %>" class="thumb" alt="material">
            </td>

            <td>
              <div class="fw-semibold"><%= m.getName() %></div>
              <div class="text-muted small">ID: <%= m.getId() %></div>
            </td>

            <td class="fw-bold">₹ <%= String.format("%.2f", m.getPrice()) %></td>

            <td>
              <span class="stock-pill <%= lowStock ? "stock-low" : "stock-ok" %>">
                <%= lowStock ? "Low Stock" : "In Stock" %> ( <%= m.getQuantity() %> )
              </span>
            </td>

            <td class="text-center action-btns">
              <a class="btn btn-sm btn-outline-primary"
                 href="<%= request.getContextPath() %>/admin/editMaterial.jsp?id=<%= m.getId() %>">
                <i class="bi bi-pencil"></i>
              </a>

              <form action="<%= request.getContextPath() %>/admin/deleteMaterial"
                    method="post"
                    style="display:inline;"
                    onsubmit="return confirm('Are you sure you want to delete this material?');">
                <input type="hidden" name="id" value="<%= m.getId() %>">
                <button class="btn btn-sm btn-outline-danger" type="submit">
                  <i class="bi bi-trash"></i>
                </button>
              </form>
            </td>
          </tr>
        <%
              }
            }
          } catch (Exception e) {
        %>
          <tr>
            <td colspan="6" class="text-danger text-center">
              Error loading materials
            </td>
          </tr>
        <% } %>
        </tbody>

      </table>
    </div>

  </div>
</div>

</body>
</html>
