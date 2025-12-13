<%@ page import="com.kumarent.dao.MaterialDAO" %>
<%@ page import="com.kumarent.model.Material" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Shop - Kumar Ent</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      background: #f5f7fa;
    }
    .card {
      border: none;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: rgba(0,0,0,0.05) 0 4px 12px;
      transition: all .25s ease-in-out;
    }
    .card:hover {
      transform: translateY(-6px);
      box-shadow: rgba(0,0,0,0.15) 0 8px 24px;
    }
    .img-container {
      height: 200px;
      overflow: hidden;
    }
    .img-container img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .badge-stock {
      font-size: 0.75rem;
      background: #e9ecef;
      color: #6c757d;
    }
    .out-overlay {
      position: absolute;
      inset: 0;
      background: rgba(255,255,255,0.7);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.1rem;
      font-weight: bold;
      color: red;
    }

    /* Footer styling */
    .footer {
      background: #ffffff;
      padding: 20px 0;
      margin-top: 40px;
      box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
    }
    .footer a {
      text-decoration: none;
      color: #6c757d;
    }
    .footer a:hover {
      color: #0d6efd;
    }
  </style>
</head>

<body>

<!-- HEADER / NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">Kumar Ent</a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item">
          <a class="nav-link active fw-semibold" href="index.jsp">Shop</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="<%= request.getContextPath() %>/cart.jsp">Cart</a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- MAIN CONTENT -->
<div class="container py-4">

  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold">🛒 Available Materials</h2>
    <a class="btn btn-outline-primary" href="<%= request.getContextPath() %>/cart.jsp">View Cart</a>
  </div>

  <div class="row">
    <%
      try {
        java.util.List<Material> list = MaterialDAO.listAll();

        if (list == null || list.isEmpty()) {
    %>

      <div class="col-12">
        <div class="alert alert-info text-center py-3 fs-5">
          No materials available right now. Please check back later.
        </div>
      </div>

    <% } else { 
         for (Material m : list) { %>

      <div class="col-md-4 col-lg-3 mb-4">
        <div class="card h-100 position-relative">

          <div class="img-container">
            <img src="<%= m.getImagePath() == null ? 
                        "https://via.placeholder.com/400x200?text=No+Image" 
                        : m.getImagePath() %>">
            <% if (m.getQuantity() <= 0) { %>
              <div class="out-overlay">Out of Stock</div>
            <% } %>
          </div>

          <div class="card-body d-flex flex-column">

            <div class="d-flex justify-content-between align-items-start">
              <h5 class="card-title fw-semibold"><%= m.getName() %></h5>
              <span class="badge badge-stock">ID: <%= m.getId() %></span>
            </div>

            <p class="text-muted mb-2">Price: 
              <span class="fw-bold text-dark">₹ <%= m.getPrice() %></span>
            </p>

            <p class="small text-secondary">Available: <%= m.getQuantity() %></p>

            <form action="<%= request.getContextPath() %>/addToCart" method="post" class="mt-auto d-flex">
              <input type="hidden" name="materialId" value="<%= m.getId() %>">
              <input type="number" name="qty" value="1" 
                     min="1" max="<%= m.getQuantity() %>" 
                     class="form-control me-2" style="width:80px;">

              <button class="btn btn-primary w-100"
                      <%= m.getQuantity() <= 0 ? "disabled" : "" %>>
                <%= m.getQuantity() <= 0 ? "Out of Stock" : "Add to Cart" %>
              </button>
            </form>

          </div>
        </div>
      </div>

    <% } } } catch (Exception e) { %>

      <div class="col-12">
        <div class="alert alert-danger">Error: <%= e.getMessage() %></div>
      </div>

    <% } %>
  </div>

</div>

<!-- FOOTER -->
<footer class="footer text-center">
  <div class="container">
    <p class="mb-1 fw-semibold">Kumar Enterprises © <%= java.time.Year.now() %></p>
    <p class="mb-0 small text-muted">
      <a href="#">Privacy Policy</a> • 
      <a href="#">Terms</a> • 
      <a href="#">Support</a>
    </p>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
