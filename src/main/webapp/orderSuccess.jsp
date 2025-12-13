<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Order Placed Successfully</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #ecfeff, #f8fafc);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', sans-serif;
    }

    .success-card {
      background: #ffffff;
      border-radius: 16px;
      padding: 30px;
      max-width: 480px;
      width: 100%;
      box-shadow: 0 10px 30px rgba(0,0,0,0.12);
      animation: fadeIn 0.4s ease-in-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(12px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .success-icon {
      font-size: 3.5rem;
      color: #22c55e;
    }

    .order-id-box {
      background: #f1f5f9;
      border-radius: 10px;
      padding: 12px;
      font-weight: 600;
      letter-spacing: 0.5px;
    }

    .btn-home {
      border-radius: 10px;
    }
  </style>
</head>

<body>

<div class="success-card text-center">

  <div class="success-icon mb-3">
    <i class="bi bi-check-circle-fill"></i>
  </div>

  <h4 class="fw-bold text-success mb-2">
    Order Placed Successfully!
  </h4>

  <p class="text-muted mb-3">
    Thank you for your purchase. Your order has been received and is being processed.
  </p>

  <div class="order-id-box mb-3">
    Order ID: <span class="text-primary">
      <%= request.getAttribute("orderUid") %>
    </span>
  </div>

  <p class="small text-muted mb-4">
    A confirmation email has been sent to your registered email address.  
    Please keep your Order ID for future reference.
  </p>
  <p>Order ID: <strong><%= request.getAttribute("orderUid") %></strong></p>

<a class="btn btn-success"
   href="<%= request.getContextPath() + request.getAttribute("invoicePath") %>"
   target="_blank">
   Download Invoice
</a>
  

  <div class="d-grid gap-2">
    <a href="index.jsp" class="btn btn-primary btn-home">
      <i class="bi bi-house-door"></i> Back to Home
    </a>

    <a href="trackOrder.jsp" class="btn btn-outline-secondary btn-home">
      <i class="bi bi-search"></i> Track Order
    </a>
  </div>

</div>

</body>
</html>
