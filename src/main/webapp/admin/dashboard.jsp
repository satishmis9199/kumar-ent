<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Admin Dashboard | Kumar Ent</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #eef2ff, #f8fafc);
      font-family: 'Segoe UI', system-ui, -apple-system;
    }

    /* Navbar */
    .navbar {
      background: rgba(255,255,255,.95);
      backdrop-filter: blur(8px);
      box-shadow: 0 8px 25px rgba(0,0,0,.05);
    }

    /* Glass Card */
    .glass-card {
      background: rgba(255,255,255,0.85);
      backdrop-filter: blur(12px);
      border-radius: 18px;
      padding: 24px;
      text-align: center;
      box-shadow: 0 18px 45px rgba(0,0,0,0.08);
      transition: all .3s ease;
      height: 100%;
    }

    .glass-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 30px 65px rgba(0,0,0,0.14);
    }

    /* KPI */
    .kpi-icon {
      font-size: 40px;
      margin-bottom: 12px;
    }
    .kpi-orders { color:#2563eb; }
    .kpi-pending { color:#f59e0b; }
    .kpi-done { color:#16a34a; }
    .kpi-revenue { color:#7c3aed; }

    /* Actions */
    .action-icon {
      font-size: 36px;
      margin-bottom: 10px;
      color:#0d6efd;
    }

    .section-title {
      font-weight: 800;
      letter-spacing: .4px;
    }

    a.dashboard-link {
      text-decoration: none;
      color: inherit;
    }
  </style>
</head>

<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar navbar-expand-lg sticky-top">
  <div class="container">
    <span class="navbar-brand fw-bold">
      <i class="bi bi-shield-lock"></i> Kumar Ent – Admin
    </span>

    <a href="<%=request.getContextPath()%>/admin/logout"
       class="btn btn-outline-danger btn-sm rounded-pill">
      <i class="bi bi-box-arrow-right"></i> Logout
    </a>
  </div>
</nav>

<!-- ================= MAIN ================= -->
<div class="container py-4" style="max-width:1100px;">

  <h3 class="section-title mb-4 text-center">
    Dashboard Overview
  </h3>

  <!-- ================= KPI ================= -->
  <div class="row g-4 mb-5">

    <div class="col-md-3">
      <div class="glass-card">
        <div class="kpi-icon kpi-orders"><i class="bi bi-box-seam"></i></div>
        <h3 class="fw-bold">${totalOrders}</h3>
        <p class="text-muted mb-0">Total Orders</p>
      </div>
    </div>

    <div class="col-md-3">
      <div class="glass-card">
        <div class="kpi-icon kpi-pending"><i class="bi bi-hourglass-split"></i></div>
        <h3 class="fw-bold">${pendingOrders}</h3>
        <p class="text-muted mb-0">Pending Orders</p>
      </div>
    </div>

    <div class="col-md-3">
      <div class="glass-card">
        <div class="kpi-icon kpi-done"><i class="bi bi-check-circle"></i></div>
        <h3 class="fw-bold">${deliveredOrders}</h3>
        <p class="text-muted mb-0">Delivered</p>
      </div>
    </div>

    <div class="col-md-3">
      <div class="glass-card">
        <div class="kpi-icon kpi-revenue"><i class="bi bi-currency-rupee"></i></div>
        <h3 class="fw-bold">₹ ${totalRevenue}</h3>
        <p class="text-muted mb-0">Revenue</p>
      </div>
    </div>

  </div>

  <!-- ================= ACTIONS ================= -->
  <h4 class="section-title mb-3">Admin Actions</h4>

  <div class="row g-4">

    <div class="col-md-3">
      <a class="dashboard-link" href="<%= request.getContextPath() %>/admin/addMaterial.jsp">
        <div class="glass-card">
          <div class="action-icon"><i class="bi bi-plus-circle"></i></div>
          <h6 class="fw-semibold">Add Material</h6>
          <small class="text-muted">Create new products</small>
        </div>
      </a>
    </div>

    <div class="col-md-3">
      <a class="dashboard-link" href="<%= request.getContextPath() %>/admin/viewMaterials.jsp">
        <div class="glass-card">
          <div class="action-icon"><i class="bi bi-boxes"></i></div>
          <h6 class="fw-semibold">View Materials</h6>
          <small class="text-muted">Inventory control</small>
        </div>
      </a>
    </div>

    <div class="col-md-3">
      <a class="dashboard-link" href="<%=request.getContextPath()%>/admin/manageOffer.jsp">
        <div class="glass-card">
          <div class="action-icon"><i class="bi bi-megaphone"></i></div>
          <h6 class="fw-semibold">Manage Offers</h6>
          <small class="text-muted">Activate / Disable offers</small>
        </div>
      </a>
    </div>

    <div class="col-md-3">
      <a class="dashboard-link" href="<%= request.getContextPath() %>/admin/viewOrders.jsp">
        <div class="glass-card">
          <div class="action-icon"><i class="bi bi-receipt"></i></div>
          <h6 class="fw-semibold">Manage Orders</h6>
          <small class="text-muted">Status & invoices</small>
        </div>
      </a>
    </div>

    <div class="col-md-3">
      <a class="dashboard-link" href="<%= request.getContextPath() %>/admin/salesReport">
        <div class="glass-card">
          <div class="action-icon"><i class="bi bi-graph-up-arrow"></i></div>
          <h6 class="fw-semibold">Sales Report</h6>
          <small class="text-muted">GST & revenue</small>
        </div>
      </a>
    </div>

  </div>

</div>

</body>
</html>
