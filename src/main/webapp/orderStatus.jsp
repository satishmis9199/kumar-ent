<%@ page import="com.kumarent.dao.OrderDAO" %>
<%@ page import="com.kumarent.model.Order" %>
<%@ page import="com.kumarent.model.OrderItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  Order order = (Order) request.getAttribute("order");

  String uidParam = request.getParameter("orderUid");
  if (order == null && uidParam != null && !uidParam.trim().isEmpty()) {
      try {
          order = OrderDAO.findByOrderUid(uidParam.trim());
      } catch (Exception e) {
          order = null;
      }
  }
  boolean userSearched = (uidParam != null && !uidParam.trim().isEmpty());
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Track Order | Kumar Enterprises</title>

  <!-- Bootstrap + Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg,#eef2ff,#f8fafc);
      font-family: system-ui,-apple-system,"Segoe UI";
      color:#111827;
    }

    .glass-card {
      background: rgba(255,255,255,.92);
      backdrop-filter: blur(16px);
      border-radius: 18px;
      box-shadow: 0 30px 60px rgba(0,0,0,.12);
    }

    .status-pill {
      padding: 6px 14px;
      border-radius: 999px;
      font-weight: 700;
      font-size: .85rem;
    }
    .Pending { background:#fff3cd;color:#856404; }
    .Approved { background:#d1e7dd;color:#0f5132; }
    .Packed { background:#cff4fc;color:#055160; }
    .OutForDelivery { background:#e2e3ff;color:#3730a3; }
    .Delivered { background:#dcfce7;color:#166534; }

    .order-id {
      font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
      background:#f1f5f9;
      padding:4px 10px;
      border-radius:8px;
      font-size:.9rem;
    }

    .muted { color:#6b7280;font-size:.95rem; }
  </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <span class="navbar-brand fw-bold">
      <i class="bi bi-truck"></i> Kumar Enterprises
    </span>

    <div class="ms-auto">
      <a href="<%=request.getContextPath()%>/shop.jsp" class="btn btn-outline-secondary btn-sm me-2">
        <i class="bi bi-shop"></i> Shop
      </a>
      <a href="<%=request.getContextPath()%>/cart.jsp" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-cart"></i> Cart
      </a>
    </div>
  </div>
</nav>

<div class="container my-5" style="max-width:1100px;">

  <!-- SEARCH CARD -->
  <div class="glass-card p-4 mb-4">
    <h4 class="fw-bold mb-1">📦 Track Your Order</h4>
    <p class="muted mb-3">
      Enter your Order ID to check live status & item details.
    </p>

    <form method="get" class="row g-2">
      <div class="col-md-9">
        <input class="form-control form-control-lg"
               name="orderUid"
               placeholder="e.g. KUMTRAENT123456"
               value="<%= uidParam == null ? "" : uidParam %>"
               required>
      </div>
      <div class="col-md-3 d-grid">
        <button class="btn btn-primary btn-lg">
          <i class="bi bi-search"></i> Track Order
        </button>
      </div>
    </form>
  </div>

  <!-- RESULT -->
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

  <div class="glass-card p-4 mb-4">

    <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-3">
      <div>
        <h5 class="fw-bold mb-1">
          Order <span class="order-id"><%=order.getOrderUid()%></span>
        </h5>
        <div class="muted">
          👤 <%=order.getCustomerName()%> |
          📞 <%=order.getCustomerContact()%>
        </div>
      </div>

      <div class="text-end">
        <span class="status-pill <%=status.replace(" ","")%>">
          <%=status%>
        </span>
        <div class="fw-bold mt-2 fs-5">
          ₹ <%=String.format("%.2f", total)%>
        </div>
      </div>
    </div>

    <hr>

    <!-- ITEMS -->
    <h6 class="fw-bold mb-2">🧾 Order Items</h6>
    <div class="table-responsive">
      <table class="table table-hover align-middle">
        <thead class="table-light">
          <tr>
            <th>Material</th>
            <th width="80">Qty</th>
            <th width="120">Price</th>
            <th width="140">Subtotal</th>
          </tr>
        </thead>
        <tbody>
        <%
          if (items != null && !items.isEmpty()) {
            for (OrderItem it : items) {
              double sub = it.getQuantity() * it.getPriceEach();
        %>
          <tr>
            <td><%=it.getMaterialName()%></td>
            <td><%=it.getQuantity()%></td>
            <td>₹ <%=String.format("%.2f", it.getPriceEach())%></td>
            <td class="fw-semibold">₹ <%=String.format("%.2f", sub)%></td>
          </tr>
        <%
            }
          } else {
        %>
          <tr>
            <td colspan="4" class="text-muted text-center">
              No items found for this order.
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-2">
      <div class="muted">
        🕒 Order placed on: <strong><%=order.getCreatedAt()%></strong>
      </div>
      <div>
        <a href="<%=request.getContextPath()%>/shop.jsp" class="btn btn-outline-primary btn-sm">
          Continue Shopping
        </a>
        <a href="<%=request.getContextPath()%>/" class="btn btn-secondary btn-sm">
          Home
        </a>
      </div>
    </div>
  </div>

  <%
    } else if (userSearched) {
  %>

  <div class="alert alert-danger glass-card p-3">
    ❌ Order not found. Please check your Order ID and try again.
  </div>

  <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
