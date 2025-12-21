<%@ page import="com.kumarent.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Order o = (Order) request.getAttribute("order");
    if (o == null) {
        response.sendRedirect(request.getContextPath() + "/admin/viewOrders.jsp");
        return;
    }

    String current = o.getStatus() == null ? "Pending" : o.getStatus();

    String[] keys   = {"Pending","Approved","Packed","OutForDelivery","Delivered"};
    String[] labels = {"Pending","Approved","Packed","Out For Delivery","Delivered"};

    int currentIndex = 0;
    for (int i = 0; i < keys.length; i++) {
        if (keys[i].equalsIgnoreCase(current) || labels[i].equalsIgnoreCase(current)) {
            currentIndex = i;
            break;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Update Order Status | Admin</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
body{
  background:linear-gradient(135deg,#eef2ff,#f8fafc);
  font-family:system-ui,-apple-system,"Segoe UI";
}

.glass-card{
  background:rgba(255,255,255,.94);
  backdrop-filter:blur(14px);
  border-radius:18px;
  box-shadow:0 30px 60px rgba(0,0,0,.12);
}

.stepper{
  display:flex;
  gap:14px;
  flex-wrap:wrap;
}
.step{
  flex:1 1 150px;
  padding:14px;
  border-radius:14px;
  text-align:center;
  font-weight:600;
}
.step.completed{
  background:#dcfce7;
  color:#166534;
}
.step.current{
  background:#e0e7ff;
  color:#1e40af;
  box-shadow:0 10px 25px rgba(37,99,235,.15);
}
.step.future{
  background:#f8fafc;
  color:#6b7280;
}

.badge-status{
  padding:6px 14px;
  border-radius:999px;
  font-weight:700;
  background:#0d6efd;
}
</style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar bg-white shadow-sm">
  <div class="container">
    <span class="navbar-brand fw-bold">
      <i class="bi bi-gear-fill"></i> Kumar Ent — Admin
    </span>
    <a href="<%=request.getContextPath()%>/admin/viewOrders.jsp"
       class="btn btn-outline-secondary btn-sm">
       ← Back to Orders
    </a>
  </div>
</nav>

<div class="container my-5" style="max-width:820px;">

  <% 
    String msg = (String) session.getAttribute("msg");
    String err = (String) session.getAttribute("error");
    if (msg != null) {
  %>
    <div class="alert alert-success"><%=msg%></div>
  <%
      session.removeAttribute("msg");
    }
    if (err != null) {
  %>
    <div class="alert alert-danger"><%=err%></div>
  <%
      session.removeAttribute("error");
    }
  %>

  <div class="glass-card p-4">

    <!-- HEADER -->
    <div class="mb-4">
      <h4 class="fw-bold mb-1">
        Update Order Status
      </h4>
      <div class="text-muted">
        Order ID: <strong><%=o.getOrderUid()%></strong>
      </div>
      <div class="text-muted">
        Customer: <strong><%=o.getCustomerName()%></strong> |
        <%=o.getCustomerContact()%>
      </div>
    </div>

    <!-- STEPPER -->
    <div class="stepper mb-4">
      <% for(int i=0;i<keys.length;i++){
           String cls="step ";
           if(i<currentIndex) cls+="completed";
           else if(i==currentIndex) cls+="current";
           else cls+="future";
      %>
        <div class="<%=cls%>">
          <%=labels[i]%>
        </div>
      <% } %>
    </div>

    <!-- FORM -->
    <form method="post" action="<%=request.getContextPath()%>/admin/updateStatus">
      <input type="hidden" name="orderUid" value="<%=o.getOrderUid()%>"/>

      <div class="mb-3">
        <label class="form-label fw-semibold">Change Status</label>
        <select name="newStatus" class="form-select form-select-lg" required>
          <option disabled selected>-- Select next status --</option>
          <% for(int i=0;i<keys.length;i++){
               boolean disabled = (i<=currentIndex);
          %>
            <option value="<%=keys[i]%>" <%=disabled?"disabled":""%>>
              <%=labels[i]%>
            </option>
          <% } %>
        </select>
        <div class="form-text">
          Previous stages are locked. You can move directly to any future stage.
        </div>
      </div>

      <div class="mb-3">
        <label class="form-label fw-semibold">Internal Note (optional)</label>
        <textarea class="form-control" rows="2"
          placeholder="Add note for internal tracking only"></textarea>
      </div>

      <div class="d-flex justify-content-end gap-2">
        <a href="<%=request.getContextPath()%>/admin/viewOrders.jsp"
           class="btn btn-outline-secondary">
           Cancel
        </a>
        <button class="btn btn-primary btn-lg">
          <i class="bi bi-check-circle"></i> Update Status
        </button>
      </div>

    </form>

  </div>
</div>

<footer class="text-center text-muted py-3">
  Kumar Enterprises © <%=java.time.Year.now()%>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
