<%@ page import="com.kumarent.dao.OrderDAO" %>
<%@ page import="com.kumarent.model.Order" %>
<%@ page import="com.kumarent.model.OrderItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // Try to obtain Order from request attribute (controller may have forwarded it)
  Order order = (Order) request.getAttribute("order");

  // If not present, and user provided orderUid via GET, try to fetch from DAO
  String uidParam = request.getParameter("orderUid");
  if (order == null && uidParam != null && !uidParam.trim().isEmpty()) {
      try {
          order = OrderDAO.findByOrderUid(uidParam.trim());
      } catch (Exception e) {
          // swallow; we'll treat as not found and show friendly message
          order = null;
      }
  }

  boolean userSearched = (uidParam != null && !uidParam.trim().isEmpty());
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Check Order Status - Kumar Ent</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body { background:#f6f8fb; font-family: system-ui, -apple-system, 'Segoe UI', Roboto; }
    .card-centered { max-width:980px; margin:28px auto; }
    .status-badge { display:inline-block; padding:6px 12px; border-radius:8px; font-weight:600; }
    .Pending { background:#fff3cd; color:#856404; }
    .Approved { background:#d1e7dd; color:#0f5132; }
    .Packed { background:#cff4fc; color:#055160; }
    .OutForDelivery { background:#e2e3ff; color:#3d3dff; }
    .Delivered { background:#c8f7d4; color:#0a6b2d; }
    .muted-small { color:#6b7280; font-size:.95rem; }
    .text-monospace { font-family: monospace, ui-monospace, 'SFMono-Regular'; }
  </style>
</head>
<body>

<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/">Kumar Ent</a>
    <div class="ms-auto d-none d-md-block">
      <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath() %>/shop.jsp">Shop</a>
      <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath() %>/cart.jsp">Cart</a>
    </div>
  </div>
</nav>

<div class="container card-centered">

  <!-- Search card -->
  <div class="card mb-4">
    <div class="card-body">
      <h5 class="card-title mb-2">Check Order Status</h5>
      <p class="muted-small mb-3">Enter your Order ID to see current status and details (e.g. <code>KUMTRAENT123456</code>).</p>

      <form action="" method="get" class="row g-2">
        <div class="col-sm-9">
          <input name="orderUid" class="form-control" placeholder="Enter Order ID" required
                 value="<%= (uidParam == null ? "" : uidParam) %>" />
        </div>
        <div class="col-sm-3 d-grid">
          <button class="btn btn-primary">Check</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Result area -->
  <%
    if (order != null) {
      String status = order.getStatus() == null ? "Pending" : order.getStatus();
      double total = 0;
      java.util.List<OrderItem> items = order.getItems();
      if (items != null) {
        for (OrderItem it : items) {
          total += it.getQuantity() * it.getPriceEach();
        }
      }
  %>

    <div class="card mb-4">
      <div class="card-body">
        <div class="d-flex justify-content-between align-items-start mb-2">
          <div>
            <h5 class="mb-1">Order <span class="text-monospace"><%= order.getOrderUid() %></span></h5>
            <div class="muted-small">Placed by <strong><%= order.getCustomerName() == null ? "-" : order.getCustomerName() %></strong>
              — <%= order.getCustomerContact() == null ? "-" : order.getCustomerContact() %></div>
          </div>

          <div class="text-end">
            <span class="status-badge <%= status.replace(" ", "") %>"><%= status %></span>
            <div class="muted-small mt-1">Total: <strong>₹ <%= String.format("%.2f", total) %></strong></div>
          </div>
        </div>

        <hr>

        <h6 class="mb-2">Items</h6>
        <div class="table-responsive mb-3">
          <table class="table table-sm align-middle">
            <thead class="table-light">
              <tr>
                <th>Item</th>
                <th style="width:90px">Qty</th>
                <th style="width:140px">Price</th>
                <th style="width:140px">Subtotal</th>
              </tr>
            </thead>
            <tbody>
              <%
                if (items != null && !items.isEmpty()) {
                  for (OrderItem it : items) {
                    double sub = it.getQuantity() * it.getPriceEach();
              %>
                <tr>
                  <td><%= it.getMaterialName() == null ? "-" : it.getMaterialName() %></td>
                  <td><%= it.getQuantity() %></td>
                  <td>₹ <%= String.format("%.2f", it.getPriceEach()) %></td>
                  <td>₹ <%= String.format("%.2f", sub) %></td>
                </tr>
              <%
                  } // end for
                } else {
              %>
                <tr>
                  <td colspan="4" class="text-muted">No items found for this order.</td>
                </tr>
              <%
                }
              %>
            </tbody>
          </table>
        </div>

        <div class="d-flex justify-content-between align-items-center">
          <div class="muted-small">Order placed on: <strong><%= order.getCreatedAt() == null ? "-" : order.getCreatedAt() %></strong></div>
          <div>
            <a class="btn btn-outline-primary btn-sm" href="<%= request.getContextPath() %>/shop.jsp">Continue Shopping</a>
            <a class="btn btn-secondary btn-sm" href="<%= request.getContextPath() %>/">Home</a>
          </div>
        </div>
      </div>
    </div>

  <%
    } else if (userSearched) {
  %>

    <div class="alert alert-warning">Order not found. Please check your Order ID and try again.</div>

  <%
    } // end display logic
  %>

</div>

</body>
</html>
