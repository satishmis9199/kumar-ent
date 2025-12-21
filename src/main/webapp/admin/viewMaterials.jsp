<%@ page import="com.kumarent.dao.MaterialDAO" %>
<%@ page import="com.kumarent.model.Material" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String success = request.getParameter("success");

    Boolean exportSuccess =
        (Boolean) session.getAttribute("EXPORT_SUCCESS");
    if (exportSuccess != null) {
        session.removeAttribute("EXPORT_SUCCESS");
    }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Materials | Admin</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #eef2ff, #f8fafc);
      font-family: system-ui, -apple-system, "Segoe UI";
      color:#111827;
    }

    .glass-panel {
      background: rgba(255,255,255,0.95);
      border-radius: 18px;
      padding: 26px;
      box-shadow: 0 25px 60px rgba(0,0,0,.12);
    }

    .page-title {
      font-weight: 800;
      letter-spacing: .3px;
    }

    table thead th {
      background:#111827;
      color:#fff;
      font-size:.75rem;
      text-transform:uppercase;
      letter-spacing:.6px;
    }

    .thumb {
      width: 70px;
      height: 50px;
      object-fit: cover;
      border-radius: 8px;
      border: 1px solid #e5e7eb;
    }

    .stock-pill {
      padding: 4px 12px;
      border-radius: 999px;
      font-size: .75rem;
      font-weight: 700;
      white-space: nowrap;
    }

    .stock-low {
      background:#fee2e2;
      color:#991b1b;
    }

    .stock-ok {
      background:#dcfce7;
      color:#166534;
    }
  </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar bg-white shadow-sm mb-4">
  <div class="container">
    <span class="navbar-brand fw-bold">
      <i class="bi bi-box-seam"></i> Kumar Ent – Admin
    </span>

    <a href="<%= request.getContextPath() %>/admin/dashboard"
       class="btn btn-outline-dark btn-sm">
      <i class="bi bi-speedometer2"></i> Dashboard
    </a>
  </div>
</nav>

<!-- TOAST NOTIFICATIONS -->
<div class="toast-container position-fixed top-0 end-0 p-3">

  <% if ("imported".equals(success)) { %>
  <div class="toast show text-bg-success">
    <div class="toast-header">
      <strong class="me-auto">Success</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
    </div>
    <div class="toast-body">
      Materials imported successfully from Excel.
    </div>
  </div>
  <% } %>

  <% if (exportSuccess != null && exportSuccess) { %>
  <div class="toast show text-bg-primary">
    <div class="toast-header">
      <strong class="me-auto">Export</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
    </div>
    <div class="toast-body">
      Excel export started successfully.
    </div>
  </div>
  <% } %>

</div>

<!-- MAIN -->
<div class="container" style="max-width:1200px;">
  <div class="glass-panel">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-3">
      <div>
        <h3 class="page-title mb-1">Materials</h3>
        <small class="text-muted">
          Manage product catalog, pricing & stock
        </small>
      </div>

      <div class="d-flex gap-2 flex-wrap">
        <a href="<%= request.getContextPath() %>/admin/addMaterial.jsp"
           class="btn btn-primary">
          <i class="bi bi-plus-circle"></i> Add
        </a>

        <a href="<%= request.getContextPath() %>/admin/manageMaterial.jsp"
           class="btn btn-warning">
          <i class="bi bi-file-earmark-excel"></i> Import
        </a>

        <form method="get"
              action="<%= request.getContextPath() %>/admin/exportMaterialExcel">
          <button class="btn btn-success">
            <i class="bi bi-download"></i> Export
          </button>
        </form>
      </div>
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
            <td colspan="6" class="text-center text-muted py-5">
              <i class="bi bi-inbox fs-1 d-block mb-2"></i>
              No materials found
            </td>
          </tr>
        <%
            } else {
              int i = 1;
              for (Material m : list) {

                String img =
                  (m.getImagePath() == null || m.getImagePath().isBlank())
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

            <td class="fw-bold">
              ₹ <%= String.format("%.2f", m.getPrice()) %>
            </td>

            <td>
              <span class="stock-pill <%= lowStock ? "stock-low" : "stock-ok" %>">
                <%= lowStock ? "Low Stock" : "In Stock" %>
                ( <%= m.getQuantity() %> )
              </span>
            </td>

            <td class="text-center">
              <a class="btn btn-sm btn-outline-primary"
                 href="<%= request.getContextPath() %>/admin/editMaterial.jsp?id=<%= m.getId() %>">
                <i class="bi bi-pencil"></i>
              </a>

              <form action="<%= request.getContextPath() %>/admin/deleteMaterial"
                    method="post"
                    style="display:inline;"
                    onsubmit="return confirm('Delete this material?');">
                <input type="hidden" name="id" value="<%= m.getId() %>">
                <button class="btn btn-sm btn-outline-danger">
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
            <td colspan="6" class="text-center text-danger">
              Failed to load materials
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>

  </div>
</div>

<!-- SCRIPTS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
  // Auto hide toasts
  setTimeout(() => {
    document.querySelectorAll('.toast').forEach(t => {
      bootstrap.Toast.getOrCreateInstance(t).hide();
    });
  }, 3500);

  // Clean URL
  if (window.location.search.includes("success")) {
    history.replaceState({}, document.title, location.pathname);
  }
</script>

</body>
</html>
