<%@ page import="com.kumarent.model.CartItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    java.util.List<CartItem> cart = (java.util.List<CartItem>) session.getAttribute("cart");
    double total = 0;
    if (cart != null) {
        for (CartItem it : cart) total += it.getPrice() * it.getQty();
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Checkout - Kumar Ent</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      background: #f6f8fb;
      font-family: system-ui, -apple-system, 'Segoe UI', Roboto;
    }
    .checkout-card {
      background: #fff;
      border-radius: 12px;
      padding: 28px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.06);
    }
    .summary-card {
      background: #ffffff;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 5px 18px rgba(0,0,0,0.07);
    }
    h3, h5 {
      font-weight: 700;
      color: #1e293b;
    }
    label.form-label {
      font-weight: 600;
      color: #334155;
    }
  </style>
</head>

<body>

<nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
  <div class="container">
    <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/shop.jsp">Kumar Ent</a>
    <a class="btn btn-outline-secondary btn-sm ms-auto" href="<%= request.getContextPath() %>/cart.jsp">← Back to Cart</a>
  </div>
</nav>

<div class="container mb-5" style="max-width: 900px;">

  <div class="row g-4">

    <!-- LEFT SIDE: FORM -->
    <div class="col-lg-7">
      <div class="checkout-card">

        <h3 class="mb-3">🧾 Checkout</h3>
        <p class="text-muted mb-4">
          Please provide your details to confirm the order.
        </p>

        <form action="placeOrder" method="post">

          <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input class="form-control" name="name" placeholder="Enter your full name" required />
          </div>

          <div class="mb-3">
            <label class="form-label">Phone</label>
            <input class="form-control" name="phone" placeholder="9876543210" required />
          </div>

          <div class="mb-3">
            <label class="form-label">Email</label>
            <input class="form-control" name="email" type="email" placeholder="example@gmail.com" required />
          </div>

          <div class="mb-3">
            <label class="form-label">Delivery Address</label>
            <textarea class="form-control" name="address" rows="3" placeholder="Full delivery address" required></textarea>
          </div>

          <button class="btn btn-primary w-100 py-2 fw-semibold">Place Order</button>
        </form>

      </div>
    </div>

    <!-- RIGHT SIDE: ORDER SUMMARY -->
    <div class="col-lg-5">
      <div class="summary-card">

        <h5 class="mb-3">🛒 Order Summary</h5>

        <% if (cart == null || cart.isEmpty()) { %>

          <p class="text-muted">Your cart is empty.</p>

        <% } else { %>

          <ul class="list-group mb-3">
            <% for (CartItem it : cart) { %>
              <li class="list-group-item d-flex justify-content-between">
                <span><%= it.getName() %> × <%= it.getQty() %></span>
                <strong>₹ <%= it.getPrice() * it.getQty() %></strong>
              </li>
            <% } %>
          </ul>

          <div class="d-flex justify-content-between">
            <span class="fw-semibold">Total:</span>
            <span class="fw-bold text-primary">₹ <%= total %></span>
          </div>

        <% } %>

      </div>
    </div>

  </div>
</div>

</body>
</html>
