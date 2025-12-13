<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Kumar Ent Udyog & Traders</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background: linear-gradient(135deg,#eef2ff,#f8fafc);
      font-family: system-ui, -apple-system, 'Segoe UI', Roboto, Arial;
      min-height:100vh;
      display:flex;
      flex-direction:column;
    }
    .hero-card {
      background:#fff;
      border-radius:12px;
      padding:36px;
      box-shadow:0 10px 30px rgba(2,6,23,0.08);
      max-width:920px;
      margin:auto;
      text-align:center;
    }
    .lead { color:#475569; }
    footer { margin-top:40px; padding:18px 0; background:#fff; box-shadow:0 -4px 18px rgba(2,6,23,0.04); }
  </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/">Kumar Ent</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu" aria-controls="navMenu" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navMenu">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/shop.jsp">Shop</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/orderStatus.jsp">Order Status</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/cart.jsp">Cart</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/admin/login.jsp">Admin</a></li>
      </ul>
    </div>
  </div>
</nav>

<main class="container py-5" role="main">
  <div class="hero-card">
    <h1 class="mb-2">Kumar Ent Udyog &amp; Traders</h1>
    <p class="lead mb-4">Building materials ordering — simple, fast & reliable</p>

    <div class="d-flex justify-content-center flex-wrap gap-3">
      <a class="btn btn-primary btn-lg" href="<%= request.getContextPath() %>/shop.jsp" role="button" aria-label="Order Materials">🧱 Order Materials</a>
      <a class="btn btn-outline-secondary btn-lg" href="<%= request.getContextPath() %>/orderStatus.jsp" role="button" aria-label="Check Order Status">📦 Check Order Status</a>
      <a class="btn btn-dark btn-lg" href="<%= request.getContextPath() %>/admin/login.jsp" role="button" aria-label="Admin Login">🔐 Admin Login</a>
    </div>

    <p class="muted-small mt-4" style="color:#6b7280;">Have questions? Call us or visit the shop — contact details on the footer.</p>
  </div>
</main>

<footer class="text-center">
  <div class="container">
    <p class="mb-1 fw-semibold">Kumar Enterprises © <%= java.time.Year.now() %></p>
    <p class="small text-muted mb-0">Asi, Darbhanga • Phone: 7366948743 • Email: support@kumarent.com</p>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
