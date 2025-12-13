<%@ page import="com.kumarent.dao.OrderDAO" %>
<%@ page import="com.kumarent.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Orders - Admin</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body { background:#f6f8fb; font-family:system-ui,-apple-system,'Segoe UI',Roboto; }
    .panel {
      background:#fff;
      padding:20px;
      border-radius:12px;
      box-shadow:0 8px 22px rgba(0,0,0,0.06);
    }
    .status-badge {
      padding:4px 8px;
      font-size:0.85rem;
      border-radius:6px;
      font-weight:600;
    }
    .Pending { background:#fff3cd; color:#856404; }
    .Approved { background:#d1e7dd; color:#0f5132; }
    .Packed { background:#cff4fc; color:#055160; }
    .OutForDelivery { background:#e2e3ff; color:#3d3dff; }
    .Delivered { background:#c8f7d4; color:#0a6b2d; }
  </style>
</head>

<body>

<nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
  <div class="container">
    <a class="navbar-brand fw-bold">Kumar Ent - Admin</a>
    <div class="ms-auto">
      <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath() %>/admin/dashboard.jsp">Dashboard</a>
    </div>
  </div>
</nav>

<div class="container" style="max-width:1100px;">
  <div class="panel">

    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 class="fw-bold">Orders</h4>
      <span class="text-muted small">All customer orders with status tracking</span>
    </div>

    <div class="table-responsive">
      <table class="table table-hover align-middle">
        <thead class="table-dark">
          <tr>
            <th>Order UID</th>
            <th>Customer</th>
            <th>Total</th>
            <th>Status</th>
            <th style="width:200px;">Actions</th>
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
                  No orders available.
                </td>
              </tr>

        <% 
              } else {
                for (Order o : list) { 
        %>
          <tr>
            <td class="fw-semibold"><%= o.getOrderUid() %></td>

            <td>
              <strong><%= o.getCustomerName() %></strong><br>
              <span class="text-muted small"><%= o.getCustomerContact() %></span>
            </td>

            <td class="fw-semibold">₹ <%= String.format("%.2f", o.getTotalAmount()) %></td>

            <td>
              <span class="status-badge <%= o.getStatus().replace(" ", "") %>">
              
                <%= o.getStatus() %>
              </span>
            </td>

            <td>
              <a class="btn btn-sm btn-primary"
                 href="<%= request.getContextPath() %>/admin/viewOrderDetails.jsp?uid=<%= o.getOrderUid() %>">
                View
              </a>

              <a class="btn btn-sm btn-warning"
                 href="<%= request.getContextPath() %>/admin/updateStatus?uid=<%= o.getOrderUid() %>">
                Update Status
              </a>
            </td>
          </tr>
        <% 
                } // end for
              } // end else
            } catch (Exception e) { 
        %>
          <tr>
            <td colspan="5" class="text-danger">
              Error: <%= e.getMessage() %>
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
