<%@ page import="com.kumarent.dao.OrderDAO" %>
<%@ page import="com.kumarent.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Admin Orders</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #eef2ff, #f8fafc);
      font-family: 'Segoe UI', system-ui, -apple-system;
    }

    .page-title {
      font-weight: 800;
      letter-spacing: .4px;
    }

    .panel {
      background: #fff;
      border-radius: 16px;
      padding: 25px;
      box-shadow: 0 15px 40px rgba(0,0,0,0.08);
    }

    table thead {
      background: #111827;
      color: #fff;
    }

    table th {
      font-weight: 600;
      font-size: .9rem;
      text-transform: uppercase;
      letter-spacing: .6px;
    }

    table td {
      vertical-align: middle;
    }

    .status-pill {
      padding: 6px 12px;
      border-radius: 999px;
      font-size: .75rem;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .Pending { background:#fff3cd; color:#856404; }
    .Approved { background:#d1e7dd; color:#0f5132; }
    .Packed { background:#cff4fc; color:#055160; }
    .OutForDelivery { background:#e2e3ff; color:#3d3dff; }
    .Delivered { background:#c8f7d4; color:#0a6b2d; }

    .action-btns .btn {
      margin: 2px;
    }

    .invoice-btn {
      background: linear-gradient(135deg, #f59e0b, #f97316);
      color: #fff;
      border: none;
    }

    .invoice-btn:hover {
      opacity: .9;
      color: #fff;
    }
  </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
  <div class="container">
    <span class="navbar-brand fw-bold">Kumar Ent – Admin Panel</span>
    <a href="<%=request.getContextPath()%>/admin/dashboard"
       class="btn btn-outline-dark btn-sm">
      <i class="bi bi-speedometer2"></i> Dashboard
    </a>
  </div>
</nav>

<!-- MAIN -->
<div class="container" style="max-width:1200px;">
  <div class="panel">

    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h3 class="page-title mb-0">Customer Orders</h3>
        <small class="text-muted">Track, manage & invoice all orders</small>
      </div>
      <span class="badge bg-dark p-2">LIVE DATA</span>
    </div>

    <div class="table-responsive">
      <table class="table table-hover align-middle">
        <thead>
          <tr>
            <th>Order ID</th>
            <th>Customer</th>
            <th>Total</th>
            <th>Status</th>
            <th class="text-center">Actions</th>
          </tr>
        </thead>

        <tbody>
        <%
          try {
            java.util.List<Order> list = OrderDAO.listAll();
            if (list == null || list.isEmpty()) {
        %>
          <tr>
            <td colspan="5" class="text-center text-muted py-4">
              <i class="bi bi-inbox fs-2 d-block mb-2"></i>
              No orders found
            </td>
          </tr>
        <%
            } else {
              for (Order o : list) {
        %>
          <tr>
            <td class="fw-bold text-primary"><%= o.getOrderUid() %></td>

            <td>
              <div class="fw-semibold"><%= o.getCustomerName() %></div>
              <div class="text-muted small"><%= o.getCustomerContact() %></div>
            </td>

            <td class="fw-bold">₹ <%= String.format("%.2f", o.getTotalAmount()) %></td>

            <td>
              <span class="status-pill <%= o.getStatus().replace(" ", "") %>">
                <i class="bi bi-circle-fill"></i>
                <%= o.getStatus() %>
              </span>
            </td>

            <td class="text-center action-btns">
              <a class="btn btn-sm btn-outline-primary"
                 href="<%= request.getContextPath() %>/admin/viewOrderDetails.jsp?uid=<%= o.getOrderUid() %>">
                <i class="bi bi-eye"></i>
              </a>

              <a class="btn btn-sm btn-outline-warning"
                 href="<%= request.getContextPath() %>/admin/updateStatus?uid=<%= o.getOrderUid() %>">
                <i class="bi bi-arrow-repeat"></i>
              </a>

              <a class="btn btn-sm invoice-btn"
                 href="<%= request.getContextPath() %>/invoicePdf?orderUid=<%= o.getOrderUid() %>">
                <i class="bi bi-file-earmark-pdf"></i>
              </a>
            </td>
          </tr>
        <%
              }
            }
          } catch (Exception e) {
        %>
          <tr>
            <td colspan="5" class="text-danger text-center">
              Error loading orders
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
