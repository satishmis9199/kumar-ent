<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin Login - Kumar Enterprises</title>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #eef2ff, #f8fafc);
      font-family: 'Segoe UI', sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding-top: 80px;
    }

    /* ===== HEADER ===== */
    .header-bar {
      position: fixed;
      top: 0;
      width: 100%;
      background: linear-gradient(135deg, #4f46e5, #6366f1);
      color: #ffffff;
      padding: 12px 0;
      z-index: 1000;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .header-title {
      font-weight: 700;
      font-size: 1.1rem;
    }

    .header-subtitle {
      font-size: 0.85rem;
      opacity: 0.9;
    }

    /* ===== LOGIN CARD ===== */
    .login-card {
      background: #ffffff;
      padding: 30px;
      border-radius: 14px;
      width: 100%;
      max-width: 420px;
      box-shadow: 0 8px 28px rgba(0,0,0,0.1);
      animation: fadeIn .4s ease-in-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(12px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .form-label {
      font-weight: 600;
    }

    .icon-input {
      position: relative;
    }

    .icon-input i {
      position: absolute;
      top: 50%;
      left: 12px;
      transform: translateY(-50%);
      font-size: 1.1rem;
      color: #6c757d;
    }

    .icon-input input {
      padding-left: 40px;
    }

    footer {
      text-align: center;
      margin-top: 18px;
      font-size: 0.85rem;
      color: #6c757d;
    }
  </style>
</head>

<body>

<!-- ===== HEADER ===== -->
<header class="header-bar">
  <div class="container d-flex justify-content-between align-items-center px-3">

    <div>
      <div class="header-title">
        <i class="bi bi-building"></i> Kumar Enterprises
      </div>
      <div class="header-subtitle">
        Secure Admin Panel
      </div>
    </div>

    <a href="<%= request.getContextPath() %>" 
       class="btn btn-outline-light btn-sm">
      <i class="bi bi-house-door"></i> Home
    </a>

  </div>
</header>

<!-- ===== LOGIN CARD ===== -->
<div class="login-card">

  <h4 class="text-center fw-bold mb-4">
    <i class="bi bi-shield-lock"></i> Admin Login
  </h4>

  <!-- Error Message -->
  <%
    String err = request.getParameter("error");
    if (err != null) {
  %>
    <div class="alert alert-danger py-2 text-center mb-3">
      Invalid username or password
    </div>
  <% } %>

  <!-- Login Form -->
  <form method="post" action="<%= request.getContextPath() %>/admin/login">

    <div class="mb-3 icon-input">
      <label class="form-label">Username</label>
      <i class="bi bi-person"></i>
      <input class="form-control"
             name="username"
             placeholder="Enter admin username"
             required />
    </div>

    <div class="mb-3 icon-input">
      <label class="form-label">Password</label>
      <i class="bi bi-lock"></i>
      <input class="form-control"
             type="password"
             name="password"
             placeholder="Enter password"
             required />
    </div>

    <button class="btn btn-primary w-100 mt-2">
      <i class="bi bi-box-arrow-in-right"></i> Login
    </button>

    <footer>
      © <%= java.time.Year.now() %> Kumar Enterprises — Admin Panel
    </footer>

  </form>
</div>

</body>
</html>
