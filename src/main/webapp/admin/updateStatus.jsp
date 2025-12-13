<%@ page import="com.kumarent.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Order o = (Order) request.getAttribute("order");
    if (o == null) {
        response.sendRedirect(request.getContextPath() + "/admin/viewOrders.jsp");
        return;
    }

    String current = o.getStatus() == null ? "Pending" : o.getStatus();

    // canonical keys and friendly labels
    String[] keys = {"Pending","Approved","Packed","OutForDelivery","Delivered"};
    String[] labels = {"Pending","Approved","Packed","Out For Delivery","Delivered"};

    int currentIndex = -1;
    for (int i = 0; i < keys.length; i++) {
        if (keys[i].equalsIgnoreCase(current) || labels[i].equalsIgnoreCase(current)) {
            currentIndex = i;
            break;
        }
    }
    if (currentIndex < 0) currentIndex = 0;

    int nextIndex = currentIndex + 1;
    if (nextIndex >= keys.length) nextIndex = -1;
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Update Order Status</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .stepper { display:flex; gap:12px; align-items:center; flex-wrap:wrap; }
    .step { flex:1 1 140px; text-align:center; padding:12px; border-radius:10px; background:#f5f7fa; position:relative; }
    .step.completed { background:#e6f4ea; color:#0b7a3e; font-weight:600; }
    .step.current { background:#eef2ff; color:#0d6efd; font-weight:700; box-shadow:0 6px 18px rgba(13,110,253,.08); }
    .step.upcoming { background:#fff; color:#6c757d; }
  </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">Kumar Ent - Admin</a>
    <div class="ms-auto">
      <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath() %>/admin/viewOrders.jsp">← Back to Orders</a>
    </div>
  </div>
</nav>

<div class="container py-4">
  <% 
    String msg = (String) session.getAttribute("msg");
    String err = (String) session.getAttribute("error");
    if (msg != null) { %>
      <div class="alert alert-success"><%= msg %></div>
  <%
      session.removeAttribute("msg");
    }
    if (err != null) { %>
      <div class="alert alert-danger"><%= err %></div>
  <%
      session.removeAttribute("error");
    }
  %>

  <div class="mb-3">
    <h4 class="mb-1">Update Status — <small class="text-muted"><%= o.getOrderUid() %></small></h4>
    <p class="mb-0">Customer: <strong><%= o.getCustomerName() %></strong> | <%= o.getCustomerContact() %></p>
    <p class="mb-2">Current Status: <span class="badge bg-info text-dark"><%= labels[currentIndex] %></span></p>
  </div>

  <!-- Stepper -->
  <div class="stepper mb-4">
    <% for (int i = 0; i < keys.length; i++) {
         String cls = "step ";
         if (i < currentIndex) cls += "completed";
         else if (i == currentIndex) cls += "current";
         else cls += "upcoming";
    %>
      <div class="<%= cls %>">
        <div style="font-size:0.95rem;"><%= labels[i] %></div>
      </div>
    <% } %>
  </div>

  <% if (nextIndex == -1) { %>
    <div class="alert alert-secondary">This order is already <strong>Delivered</strong>. No further status updates are available.</div>
  <% } else { %>

    <form id="updateForm" method="post" action="<%= request.getContextPath() %>/admin/updateStatus">
      <input type="hidden" name="orderUid" value="<%= o.getOrderUid() %>" />

      <div class="mb-3">
        <label class="form-label">Move order forward to</label>
        <select name="newStatus" class="form-select" required>
          <% for (int i = 0; i < keys.length; i++) {
               boolean disabled = (i <= currentIndex);
               boolean selected = (i == nextIndex);
          %>
            <option value="<%= keys[i] %>" <%= disabled ? "disabled" : "" %> <%= selected ? "selected" : "" %>>
              <%= labels[i] %>
            </option>
          <% } %>
        </select>
        <div class="form-text">Previous statuses are disabled — orders can only move forward.</div>
      </div>

      <div class="mb-3">
        <label class="form-label">Optional Note (internal)</label>
        <input name="note" class="form-control" placeholder="Add an internal note for this status update (optional)">
      </div>

      <button type="submit" class="btn btn-primary">Update Status</button>
    </form>

  <% } %>

</div>

<footer class="text-center py-3 text-muted">Kumar Enterprises © <%= java.time.Year.now() %></footer>
</body>
</html>
