<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin Dashboard</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      background: #f5f7fa;
      font-family: 'Segoe UI', sans-serif;
    }

    .dash-card {
      background: #ffffff;
      border-radius: 12px;
      padding: 25px;
      text-align: center;
      box-shadow: rgba(0,0,0,0.06) 0 4px 16px;
      transition: all .25s ease;
      cursor: pointer;
    }

    .dash-card:hover {
      transform: translateY(-6px);
      box-shadow: rgba(0,0,0,0.15) 0 10px 24px;
    }

    .dash-icon {
      font-size: 40px;
      margin-bottom: 10px;
      color: #0d6efd;
    }
    
    /* Style for the centered, full-width Logout button */
    .logout-btn-container {
        padding-top: 30px; /* Add some space above the button */
        max-width: 900px;
        margin: auto; /* Center the container */
    }
  </style>
</head>

<body>

<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <span class="navbar-brand fw-bold">Kumar Ent - Admin Panel</span>
    <a href="<%=request.getContextPath()%>/admin/logout" class="btn btn-outline-danger btn-sm d-none d-md-block">
        <i class="bi bi-box-arrow-right"></i> Logout
    </a>
  </div>
</nav>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<div class="container py-4" style="max-width: 900px;">

  <h3 class="fw-bold mb-4 text-center">Admin Dashboard</h3>

  <div class="row g-4">

    <div class="col-md-4">
      <a href="<%= request.getContextPath() %>/admin/addMaterial.jsp" class="text-decoration-none text-dark">
        <div class="dash-card">
          <div class="dash-icon">➕</div>
          <h5 class="fw-semibold">Add Material</h5>
          <p class="text-muted small mb-0">Create new items for the shop</p>
        </div>
      </a>
    </div>

    <div class="col-md-4">
      <a href="<%= request.getContextPath() %>/admin/viewMaterials.jsp" class="text-decoration-none text-dark">
        <div class="dash-card">
          <div class="dash-icon">📦</div>
          <h5 class="fw-semibold">View Materials</h5>
          <p class="text-muted small mb-0">Manage available inventory</p>
        </div>
      </a>
    </div>

    <div class="col-md-4">
      <a href="<%= request.getContextPath() %>/admin/viewOrders.jsp" class="text-decoration-none text-dark">
        <div class="dash-card">
          <div class="dash-icon">🧾</div>
          <h5 class="fw-semibold">View Orders</h5>
          <p class="text-muted small mb-0">View & track customer orders</p>
        </div>
      </a>
    </div>




</div> </body>
</html>