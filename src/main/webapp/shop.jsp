<%@ page import="com.kumarent.dao.MaterialDAO" %>
<%@ page import="com.kumarent.model.Material" %>
<%@ page import="com.kumarent.dao.OfferDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Kumar Enterprises | Shop Materials</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body {
      background: #f4f6fb;
      padding-top: 90px;
      padding-bottom: 90px;
      font-family: "Segoe UI", system-ui, sans-serif;
    }

    /* NAVBAR */
    .navbar {
      background: #fff;
      box-shadow: 0 6px 20px rgba(0,0,0,.06);
    }

    /* HERO */
    .hero {
      background: linear-gradient(135deg,#0d6efd,#3b82f6);
      color: #fff;
      padding: 40px;
      border-radius: 18px;
      box-shadow: 0 18px 40px rgba(13,110,253,.35);
    }

    /* FILTER */
    .filter-box {
      background: #fff;
      padding: 20px;
      border-radius: 16px;
      box-shadow: 0 10px 30px rgba(0,0,0,.06);
    }

    /* PRODUCT CARD */
    .product-card {
      border: none;
      border-radius: 18px;
      background: #fff;
      box-shadow: 0 10px 28px rgba(0,0,0,.08);
      transition: all .3s ease;
    }

    .product-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 18px 46px rgba(0,0,0,.16);
    }

    .img-box {
      height: 200px;
      overflow: hidden;
      border-radius: 18px 18px 0 0;
      position: relative;
    }

    .img-box img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .badge-price {
      position: absolute;
      top: 12px;
      right: 12px;
      background: #0d6efd;
      color: #fff;
      padding: 6px 14px;
      border-radius: 999px;
      font-size: .9rem;
      font-weight: 600;
    }

    .out-overlay {
      position: absolute;
      inset: 0;
      background: rgba(255,255,255,.88);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.2rem;
      font-weight: 700;
      color: #dc3545;
    }

    /* DELIVERY */
    .delivery-card {
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 8px 22px rgba(0,0,0,.06);
    }

    /* FOOTER */
    footer {
      background: #fff;
      box-shadow: 0 -6px 20px rgba(0,0,0,.06);
    }
  </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar fixed-top navbar-expand-lg">
  <div class="container d-flex justify-content-between">
    <a class="navbar-brand fw-bold text-primary" href="#">
      <i class="bi bi-shop-window"></i> Kumar Ent
    </a>

    <div class="d-flex gap-2">
      <a class="btn btn-outline-primary rounded-pill" href="<%=request.getContextPath()%>/">
        <i class="bi bi-house-door"></i> Main Page
      </a>
      <a class="btn btn-outline-primary rounded-pill" href="<%=request.getContextPath()%>/cart.jsp">
        <i class="bi bi-cart3"></i> Cart
      </a>
    </div>
  </div>
</nav>

<div class="container">

  <!-- HERO -->
  <div class="hero text-center mb-4">
    <h2 class="fw-bold mb-2">KUMAR BRICK UDYOG AND TRADERS</h2>
    <p class="mb-0">Trusted supplier • Best prices • Fast delivery</p>
  </div>

  <!-- OFFER -->
  <%
    String offer = null;
    try { offer = OfferDAO.getActiveOffer(); } catch(Exception e){}
    if (offer != null) {
  %>
  <div class="alert alert-warning text-center fw-semibold rounded-pill shadow-sm">
    <i class="bi bi-megaphone-fill"></i> <%= offer %>
  </div>
  <% } %>

  <!-- FILTER -->
  <form method="get" class="filter-box row g-3 mb-4">
    <div class="col-md-4">
      <input class="form-control" name="search" placeholder="🔍 Search materials">
    </div>
    <div class="col-md-3">
      <select name="stock" class="form-select">
        <option value="">All Stock</option>
        <option value="in">In Stock Only</option>
      </select>
    </div>
    <div class="col-md-3">
      <select name="sort" class="form-select">
        <option value="">Sort</option>
        <option value="price_asc">Price: Low → High</option>
        <option value="price_desc">Price: High → Low</option>
      </select>
    </div>
    <div class="col-md-2 d-grid">
      <button class="btn btn-primary rounded-pill">Apply</button>
    </div>
  </form>

  <!-- DELIVERY CHECK -->
  <div class="delivery-card p-3 mb-4">
    <h6 class="fw-bold mb-2">🚚 Check Delivery Availability</h6>
    <form method="post" action="<%=request.getContextPath()%>/checkDelivery" class="d-flex gap-2 flex-wrap">
      <input class="form-control" name="pincode" placeholder="Enter pincode" required style="max-width:220px">
      <button class="btn btn-primary">Check</button>
    </form>
    <% String msg = (String) request.getAttribute("deliveryResult");
       if (msg != null) { %>
      <div class="mt-2 fw-semibold <%= msg.contains("available")?"text-success":"text-danger" %>">
        <%= msg %>
      </div>
    <% } %>
  </div>

  <!-- PRODUCTS -->
  <div class="row">
    <%
      try {
        java.util.List<Material> list =
          MaterialDAO.listFiltered(
            request.getParameter("search"),
            request.getParameter("stock"),
            request.getParameter("sort")
          );

        for (Material m : list) {
    %>
    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
      <div class="product-card h-100">
        <div class="img-box">
          <img src="<%= m.getImagePath()==null?"https://via.placeholder.com/400x250":m.getImagePath() %>">
          <span class="badge-price">₹ <%= m.getPrice() %></span>
          <% if (m.getQuantity()<=0) { %>
            <div class="out-overlay">Out of Stock</div>
          <% } %>
        </div>

        <div class="p-3 d-flex flex-column">
          <h6 class="fw-semibold mb-1"><%= m.getName() %></h6>
          <small class="text-muted mb-3">Available: <%= m.getQuantity() %></small>

          <form action="<%=request.getContextPath()%>/addToCart" method="post" class="mt-auto d-flex gap-2">
            <input type="hidden" name="materialId" value="<%= m.getId() %>">
            <input type="number" name="qty" value="1" min="1"
                   max="<%= m.getQuantity() %>" class="form-control" style="width:70px"
                   <%= m.getQuantity()<=0?"disabled":"" %>>
            <button class="btn btn-primary flex-fill rounded-pill"
                    <%= m.getQuantity()<=0?"disabled":"" %>>
              <i class="bi bi-cart-plus"></i> Add
            </button>
          </form>
        </div>
      </div>
    </div>
    <% } } catch(Exception e) { %>
      <div class="alert alert-danger"><%= e.getMessage() %></div>
    <% } %>
  </div>
</div>

<!-- FOOTER -->
<footer class="fixed-bottom text-center py-2">
  <small class="text-muted">© <%= java.time.Year.now() %> Kumar Enterprises</small>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
