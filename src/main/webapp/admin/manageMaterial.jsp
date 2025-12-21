<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Upload Material Excel</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      background: #f5f7fa;
    }
    .form-card {
      background: #ffffff;
      border-radius: 12px;
      padding: 28px;
      box-shadow: rgba(0,0,0,0.07) 0 4px 16px;
    }
    .form-label {
      font-weight: 600;
    }
  </style>
</head>

<body>

<div class="container py-5" style="max-width:650px;">

  <!-- Back -->
  <a href="<%= request.getContextPath() %>/admin/dashboard"
     class="btn btn-outline-secondary btn-sm mb-3">← Back to Dashboard</a>

  <div class="form-card">

    <h3 class="fw-bold mb-3">📤 Upload Materials (Excel)</h3>

    <p class="text-muted mb-4">
      Upload an Excel (.xlsx) file to bulk insert materials into database.
    </p>

    <form method="post"
          action="<%= request.getContextPath() %>/admin/uploadMaterialExcel"
          enctype="multipart/form-data">

      <div class="mb-3">
        <label class="form-label">Select Excel File</label>
        <input type="file"
               class="form-control"
               name="excelFile"
               accept=".xlsx"
               required>
      </div>

      <div class="alert alert-info small">
        <strong>Excel Columns Order:</strong><br>
        name | description | price | quantity | image_path
      </div>

      <div class="text-end">
        <button class="btn btn-success btn-lg">
          Upload & Import
        </button>
      </div>

    </form>

  </div>
</div>

</body>
</html>
