<%@ page import="com.kumarent.dao.OrderDAO" %>
<%@ page import="com.kumarent.model.Order" %>
<%@ page import="com.kumarent.model.OrderItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String uid = request.getParameter("uid");
  Order o = OrderDAO.findByOrderUid(uid);
  double total = 0;
  for (OrderItem it : o.getItems()) {
      total += it.getQuantity() * it.getPriceEach();
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Order Details - Admin</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body { background:#f6f8fb; }
    .card-panel {
      background: #fff;
      border-radius: 12px;
      padding: 22px;
      box-shadow: 0 8px 20px rgba(2,6,23,0.06);
    }
    .status-badge {
      font-size: 0.9rem;
      padding: 5px 10px;
      border-radius: 6px;
    }
    .status-Pending { background:#fff3cd; color:#856404; }
    .status-Approved { background:#d1e7dd; color:#0f5132; }
    .status-Packed { background:#cff4fc; color:#055160; }
    .status-OutForDelivery { background:#e2e3ff; color:#3d3dff; }
    .status-Delivered { background:#d1e7dd; color:#0f5132; font-weight:600; }
  </style>
</head>

<body>

<nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">Kumar Ent - Admin</a>
    <div class="ms-auto">
      <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath() %>/admin/viewOrders.jsp">← Back to Orders</a>
    </div>
  </div>
</nav>

<div class="container" style="max-width:900px;">
  <div class="card-panel">

    <h4 class="fw-bold mb-1">Order <%= o.getOrderUid() %></h4>
    <p class="mb-1">
      Customer: <strong><%= o.getCustomerName() %></strong>  
      (<%= o.getCustomerContact() %>)
    </p>

    <p class="mb-3">
      Status: 
      <span class="status-badge status-<%= o.getStatus().replace(" ","") %>">
        <%= o.getStatus() %>
      </span>
    </p>

    <h5 class="fw-semibold mt-4">Order Items</h5>

    <div class="table-responsive mt-2">
      <table class="table table-bordered align-middle">
        <thead class="table-light">
          <tr>
            <th>Item</th>
            <th style="width:120px;">Qty</th>
            <th style="width:150px;">Price Each</th>
            <th style="width:150px;">Subtotal</th>
          </tr>
        </thead>

        <tbody>
          <% for (OrderItem it : o.getItems()) { 
               double sub = it.getQuantity() * it.getPriceEach();
          %>
            <tr>
              <td><%= it.getMaterialName() %></td>
              <td><%= it.getQuantity() %></td>
              <td>₹ <%= String.format("%.2f", it.getPriceEach()) %></td>
              <td>₹ <%= String.format("%.2f", sub) %></td>
            </tr>
          <% } %>
        </tbody>
      </table>
    </div>

    <div class="d-flex justify-content-between mt-3">
      <h5 class="fw-bold">Total Amount:</h5>
      <h5 class="fw-bold">₹ <%= String.format("%.2f", total) %></h5>
    </div>

    <div class="mt-4">
      <a class="btn btn-secondary" href="<%= request.getContextPath() %>/admin/viewOrders.jsp">Back</a>
    </div>

  </div>
</div>

</body>
</html>
