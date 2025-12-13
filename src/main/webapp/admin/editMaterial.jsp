<%@ page import="com.kumarent.dao.MaterialDAO" %>
<%@ page import="com.kumarent.model.Material" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String idParam = request.getParameter("id");
  Material m = null;
  if (idParam != null) {
      try {
          int id = Integer.parseInt(idParam);
          m = MaterialDAO.findById(id);
      } catch (Exception e) {
          m = null;
      }
  }
  if (m == null) {
      out.println("<div class='container py-4'><div class='alert alert-warning'>Material not found.</div></div>");
      return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Edit Material - Kumar Ent</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background: #f6f8fb; font-family: system-ui, -apple-system, "Segoe UI", Roboto, Arial; }
    .form-card { background:#fff; border-radius:12px; padding:20px; box-shadow:0 6px 18px rgba(2,6,23,.06); }
    .preview-box { width:100%; height:220px; background:#f3f4f6; display:flex; align-items:center; justify-content:center; border-radius:8px; overflow:hidden; }
    .preview-box img { max-width:100%; max-height:100%; object-fit:contain; display:block; }
    .muted { color:#6b7280; }
  </style>
</head>
<body>

<!-- header -->
<nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">Kumar Ent - Admin</a>
    <div class="ms-auto">
      <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath() %>/admin/viewMaterials.jsp">← Back to Materials</a>
    </div>
  </div>
</nav>

<div class="container" style="max-width:820px;">
  <div class="form-card">

    <h4 class="mb-3">✏️ Edit Material</h4>

    <form id="editForm" action="<%= request.getContextPath() %>/admin/updateMaterial" method="post" onsubmit="return confirmUpdate();">
      <input type="hidden" name="id" value="<%= m.getId() %>" />

      <div class="mb-3">
        <label class="form-label">Material Name</label>
        <input type="text" name="name" class="form-control" required
               value="<%= m.getName() == null ? "" : m.getName() %>" />
      </div>

      <div class="mb-3">
        <label class="form-label">Description <span class="muted small">(optional)</span></label>
        <textarea name="description" class="form-control" rows="3"><%= m.getDescription() == null ? "" : m.getDescription() %></textarea>
      </div>

      <div class="row g-3 mb-3">
        <div class="col-md-6">
          <label class="form-label">Price (₹)</label>
          <input type="number" name="price" class="form-control" step="0.01" min="0" required
                 value="<%= m.getPrice() %>"/>
        </div>

        <div class="col-md-6">
          <label class="form-label">Quantity</label>
          <input type="number" name="quantity" class="form-control" step="1" min="0" required
                 value="<%= m.getQuantity() %>"/>
        </div>
      </div>

      <div class="mb-3">
        <label class="form-label">Image URL <span class="muted small">(optional)</span></label>
        <input type="url" id="imagePath" name="imagePath" class="form-control" placeholder="https://..."
               value="<%= m.getImagePath()==null ? "" : m.getImagePath() %>"
               oninput="updatePreview()" />
      </div>

      <!-- live preview -->
      <div class="mb-3">
        <label class="form-label small text-muted">Image Preview</label>
        <div class="preview-box" id="previewBox">
          <img id="previewImg" src="<%= (m.getImagePath()==null || m.getImagePath().trim().isEmpty()) ? "https://via.placeholder.com/600x400?text=No+Image" : m.getImagePath() %>" alt="Preview">
        </div>
      </div>

      <div class="d-flex justify-content-end gap-2">
        <a class="btn btn-secondary" href="<%= request.getContextPath() %>/admin/viewMaterials.jsp">Cancel</a>
        <button type="submit" class="btn btn-primary">Update Material</button>
      </div>
    </form>

  </div>
</div>

<!-- footer -->
<footer class="text-center mt-4 mb-4 muted">
  <small>Kumar Enterprises © <%= java.time.Year.now() %></small>
</footer>

<script>
  function updatePreview(){
    const url = document.getElementById('imagePath').value.trim();
    const img = document.getElementById('previewImg');
    if(!url){
      img.src = 'https://via.placeholder.com/600x400?text=No+Image';
      return;
    }
    // quick sanity: try to set src; if it fails browser will show broken image icon
    img.src = url;
  }

  function confirmUpdate(){
    const price = parseFloat(document.querySelector('input[name="price"]').value);
    const qty = parseInt(document.querySelector('input[name="quantity"]').value, 10);
    if(isNaN(price) || price < 0){
      alert('Please enter a valid price (>= 0).');
      return false;
    }
    if(isNaN(qty) || qty < 0){
      alert('Please enter a valid quantity (>= 0).');
      return false;
    }
    return confirm('Are you sure you want to update this material?');
  }
</script>

</body>
</html>
