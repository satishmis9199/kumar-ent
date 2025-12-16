<%@ page import="com.kumarent.dao.MaterialDAO" %>
<%@ page import="com.kumarent.model.Material" %>
<%@ page import="com.kumarent.dao.OfferDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Shop | Kumar Enterprises</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body {
      background: #f4f6f9;
      padding-top: 80px;
      padding-bottom: 80px;
      font-family: "Segoe UI", system-ui, sans-serif;
    }

    /* Navbar */
    .navbar {
      background: #ffffff;
      box-shadow: 0 4px 20px rgba(0,0,0,.05);
    }

    /* Card */
    .product-card {
      border: none;
      border-radius: 16px;
      background: #ffffff;
      box-shadow: 0 8px 26px rgba(0,0,0,0.06);
      transition: all .25s ease;
    }
    .product-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 14px 38px rgba(0,0,0,0.12);
    }

    .img-box {
      height: 200px;
      overflow: hidden;
      border-radius: 16px 16px 0 0;
      position: relative;
    }

    .img-box img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .badge-price {
      position: absolute;
      top: 10px;
      right: 10px;
      background: #0d6efd;
      color: #fff;
      padding: 6px 10px;
      border-radius: 20px;
      font-size: 0.9rem;
      font-weight: 600;
    }

    .out-overlay {
      position: absolute;
      inset: 0;
      background: rgba(255,255,255,.85);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.2rem;
      font-weight: 600;
      color: #dc3545;
    }

    /* Filters */
    .filter-box {
      background: #ffffff;
      padding: 20px;
      border-radius: 14px;
      box-shadow: 0 6px 18px rgba(0,0,0,.05);
    }

    /* Footer */
    .footer {
      background: #ffffff;
      box-shadow: 0 -4px 18px rgba(0,0,0,.05);
    }
  </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar fixed-top navbar-expand-lg">
  <div class="container">
    <a class="navbar-brand fw-bold text-primary" href="#">
      <i class="bi bi-shop-window"></i> Kumar Ent
    </a>

    <a class="btn btn-outline-primary rounded-pill"
       href="<%=request.getContextPath()%>/cart.jsp">
      <i class="bi bi-cart3"></i> View Cart
    </a>
  </div>
</nav>

<!-- OFFER -->
<%
  String offerMsg = null;
  try {
    offerMsg = OfferDAO.getActiveOffer();
  } catch (Exception e) {}
%>

<% if (offerMsg != null) { %>
  <div class="container mt-3">
    <div class="alert alert-warning text-center fw-semibold shadow-sm rounded-pill">
      <i class="bi bi-megaphone-fill"></i> <%= offerMsg %>
    </div>
  </div>
<% } %>

<div class="container">

  <!-- TITLE -->
  <div class="mb-4 text-center">
    <h2 class="fw-bold">Shop Materials</h2>
    <p class="text-muted">Quality products at the best prices</p>
  </div>

  <!-- FILTERS -->
  <form method="get" action="shop.jsp" class="filter-box row g-3 mb-4">
    <div class="col-md-4">
      <input type="text" name="search" class="form-control"
             placeholder="🔍 Search materials..."
             value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
    </div>

    <div class="col-md-3">
      <select name="stock" class="form-select">
        <option value="">All Stock</option>
        <option value="in" <%= "in".equals(request.getParameter("stock")) ? "selected" : "" %>>
          In Stock Only
        </option>
      </select>
    </div>

    <div class="col-md-3">
      <select name="sort" class="form-select">
        <option value="">Sort</option>
        <option value="price_asc" <%= "price_asc".equals(request.getParameter("sort")) ? "selected" : "" %>>
          Price: Low → High
        </option>
        <option value="price_desc" <%= "price_desc".equals(request.getParameter("sort")) ? "selected" : "" %>>
          Price: High → Low
        </option>
      </select>
    </div>

    <div class="col-md-2 d-grid">
      <button class="btn btn-primary rounded-pill">
        Apply
      </button>
    </div>
  </form>

  <!-- PRODUCTS -->
  <div class="row">
    <%
      try {
        String search = request.getParameter("search");
        String stock  = request.getParameter("stock");
        String sort   = request.getParameter("sort");

        java.util.List<Material> list =
                MaterialDAO.listFiltered(search, stock, sort);

        if (list.isEmpty()) {
    %>
      <div class="alert alert-info text-center rounded-pill">
        No materials found.
      </div>
    <%
        } else {
          for (Material m : list) {
    %>

    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
      <div class="product-card h-100">

        <div class="img-box">
          <img src="<%= m.getImagePath() == null ?
            "https://via.placeholder.com/400x200" : m.getImagePath() %>">

          <span class="badge-price">₹ <%= m.getPrice() %></span>

          <% if (m.getQuantity() <= 0) { %>
            <div class="out-overlay">Out of Stock</div>
          <% } %>
        </div>

        <div class="p-3 d-flex flex-column">
          <h6 class="fw-semibold mb-1"><%= m.getName() %></h6>
          <small class="text-muted mb-3">
            Available: <%= m.getQuantity() %>
          </small>

          <form action="<%=request.getContextPath()%>/addToCart"
                method="post" class="mt-auto d-flex gap-2">
            <input type="hidden" name="materialId" value="<%= m.getId() %>">

            <input type="number"
                   name="qty"
                   value="1"
                   min="1"
                   max="<%= m.getQuantity() %>"
                   class="form-control"
                   style="width:75px"
                   <%= m.getQuantity() <= 0 ? "disabled" : "" %>>

            <button class="btn btn-primary flex-fill rounded-pill"
                    <%= m.getQuantity() <= 0 ? "disabled" : "" %>>
              <i class="bi bi-cart-plus"></i>
            </button>
          </form>
        </div>

      </div>
    </div>

    <%
          }
        }
      } catch (Exception e) {
    %>
      <div class="alert alert-danger"><%= e.getMessage() %></div>
    <% } %>
  </div>
</div>

<!-- FOOTER -->
<footer class="footer fixed-bottom text-center py-2">
  <small class="text-muted">
    © <%= java.time.Year.now() %> Kumar Enterprises
  </small>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
