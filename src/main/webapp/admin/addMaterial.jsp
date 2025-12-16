<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Add Material</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      background: #f5f7fa;
    }
    .form-card {
      background: #ffffff;
      border-radius: 12px;
      padding: 25px;
      box-shadow: rgba(0,0,0,0.07) 0 4px 16px;
    }
    .form-label {
      font-weight: 600;
      margin-bottom: 4px;
    }
  </style>
</head>

<body>

<div class="container py-4" style="max-width:760px;">

  <!-- Back Button -->
  <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-outline-secondary btn-sm mb-3">← Back to Dashboard</a>

  <div class="form-card">

    <h3 class="fw-bold mb-3">➕ Add New Material</h3>

    <form method="post" action="<%= request.getContextPath() %>/admin/addMaterial" enctype="multipart/form-data">

      <div class="mb-3">
        <label class="form-label">Material Name</label>
        <input class="form-control" name="name" placeholder="Enter material name" required />
      </div>

      <div class="mb-3">
        <label class="form-label">Description</label>
        <textarea class="form-control" name="description" placeholder="Enter material description"></textarea>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label">Price (₹)</label>
          <input class="form-control" name="price" type="number" step="0.01" placeholder="0.00" required />
        </div>

        <div class="col-md-6 mb-3">
          <label class="form-label">Quantity</label>
          <input class="form-control" name="quantity" type="number" placeholder="0" required />
        </div>
      </div>

      <div class="mb-3">
        <label class="form-label">Upload Image</label>
        <input class="form-control" name="image" type="file" />
      </div>

      <div class="text-end">
        <button class="btn btn-primary btn-lg">Add Material</button>
      </div>

    </form>
  </div>
</div>

</body>
</html>
