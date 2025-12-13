<%@ page import="com.kumarent.dao.MaterialDAO" %>
<%@ page import="com.kumarent.model.Material" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Materials</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    :root {
      --card-bg: #ffffff;
      --page-bg: #f6f8fb;
      --muted: #6b7280;
    }
    body { background: var(--page-bg); font-family: system-ui, -apple-system, 'Segoe UI', Roboto, Arial; color: #111827; }
    .panel {
      background: var(--card-bg);
      border-radius: 12px;
      padding: 18px;
      box-shadow: 0 8px 24px rgba(2,6,23,0.06);
    }
    .table thead th { border-bottom: 0; background: #f3f6fb; }
    .thumb { width:64px; height:44px; object-fit:cover; border-radius:6px; border:1px solid #eef2f7; }
    .muted-small { color: var(--muted); font-size: .95rem; }
    .action-btns .btn { margin-right:6px; }
    .no-data { padding:30px 0; color:var(--muted); text-align:center; }
    .title-row { gap: 0.75rem; align-items:center; }
    @media (max-width: 768px) {
      .title-row { flex-direction:column; align-items:stretch; gap:.5rem; }
      .action-btns { display:flex; gap:.5rem; justify-content:flex-end; }
    }
  </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-4">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">Kumar Ent - Admin</a>
    <div class="ms-auto d-none d-md-block">
      <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath() %>/admin/dashboard.jsp">Dashboard</a>
    </div>
  </div>
</nav>

<div class="container" style="max-width:1100px;">
  <div class="panel">

    <div class="d-flex justify-content-between align-items-center mb-3 title-row">
      <div>
        <h5 class="mb-0">Materials</h5>
        <div class="muted-small">Manage catalog items</div>
      </div>

      <div class="action-btns d-flex align-items-center">
        <a class="btn btn-success btn-sm" href="<%= request.getContextPath() %>/admin/addMaterial.jsp">+ Add Material</a>
      </div>
    </div>

    <div class="table-responsive">
      <table class="table align-middle table-hover">
        <thead class="table-light">
          <tr>
            <th style="width:6%">#</th>
            <th style="width:8%">Thumb</th>
            <th>Name</th>
            <th style="width:12%">Price</th>
            <th style="width:10%">Qty</th>
            <th style="width:18%">Actions</th>
          </tr>
        </thead>

        <tbody>
        <%
          try {
              java.util.List<Material> list = MaterialDAO.listAll();

              if (list == null || list.isEmpty()) {
        %>
                <tr>
                  <td colspan="6" class="no-data">
                    No materials found. <a href="<%= request.getContextPath() %>/admin/addMaterial.jsp" class="fw-semibold">Add a material</a>
                  </td>
                </tr>
        <%
              } else {
                int idx = 1;
                for (Material m : list) {
                  String img = (m.getImagePath() == null || m.getImagePath().trim().isEmpty())
                               ? "https://via.placeholder.com/300x200?text=No+Image" : m.getImagePath();
        %>
          <tr>
            <td><%= idx++ %></td>
            <td>
              <img src="<%= img %>" alt="thumb" class="thumb">
            </td>
            <td>
              <div class="fw-semibold"><%= m.getName() %></div>
              <div class="muted-small">ID: <%= m.getId() %></div>
            </td>
            <td class="fw-semibold">₹ <%= String.format("%.2f", m.getPrice()) %></td>
            <td><%= m.getQuantity() %></td>
            <td>
              <a class="btn btn-sm btn-primary" href="<%= request.getContextPath() %>/admin/editMaterial.jsp?id=<%= m.getId() %>">Edit</a>

              <form action="<%= request.getContextPath() %>/admin/deleteMaterial" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= m.getId() %>" />
                <button class="btn btn-sm btn-danger" type="submit">Delete</button>
              </form>
            </td>
          </tr>
        <%
                } // end for
              } // end else
          } catch (Exception e) {
              out.println("<tr><td colspan='6' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
          }
        %>
        </tbody>
      </table>
    </div>

  </div>
</div>

</body>
</html>
F