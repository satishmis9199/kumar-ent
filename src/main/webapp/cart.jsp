<%@ page import="com.kumarent.model.CartItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Cart - Kumar Ent</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      background: #f5f7fa;
    }
    .cart-container {
      background: #ffffff;
      border-radius: 10px;
      padding: 25px;
      box-shadow: rgba(0,0,0,0.07) 0 4px 18px;
    }
    .table thead {
      background: #f0f2f5;
    }
    .table tbody tr:hover {
      background: #fafafa;
    }
  </style>
</head>

<body>

<div class="container py-4">

  <!-- Top Bar -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <a href="shop.jsp" class="btn btn-outline-secondary btn-sm">← Back to Shop</a>
    <h3 class="fw-bold mb-0">🛒 Your Cart</h3>
    <div></div>
  </div>

  <div class="cart-container">

    <% 
      java.util.List<CartItem> cart = (java.util.List<CartItem>) session.getAttribute("cart");

      if (cart == null || cart.isEmpty()) { 
    %>

      <div class="alert alert-info text-center py-3 fs-5">
        Your cart is empty. <a href="shop.jsp" class="fw-bold">Go shopping</a>
      </div>

    <% 
      } else { 
        double total = 0; 
    %>

      <table class="table table-bordered align-middle">
        <thead class="text-center">
          <tr>
            <th style="width:35%">Item</th>
            <th style="width:10%">Qty</th>
            <th style="width:15%">Price</th>
            <th style="width:20%">Subtotal</th>
            <th style="width:10%">Action</th>
          </tr>
        </thead>

        <tbody>
        <% 
          for (CartItem it : cart) { 
            double sub = it.getQty() * it.getPrice(); 
            total += sub; 
        %>
          <tr>
            <td><strong><%= it.getName() %></strong></td>
            <td class="text-center"><%= it.getQty() %></td>
            <td>₹ <%= String.format("%.2f", it.getPrice()) %></td>
            <td>₹ <%= String.format("%.2f", sub) %></td>

            <td class="text-center">
              <form action="cartAction" method="post">
                <input type="hidden" name="action" value="remove" />
                <input type="hidden" name="materialId" value="<%= it.getMaterialId() %>" />
                <button class="btn btn-sm btn-danger">Remove</button>
              </form>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>

      <div class="d-flex justify-content-between align-items-center mt-3">
        <h4 class="fw-bold">Total: ₹ <%= String.format("%.2f", total) %></h4>
        <a class="btn btn-success btn-lg" href="orderForm.jsp">Proceed to Checkout →</a>
      </div>

    <% } %>

  </div>
</div>

</body>
</html>
