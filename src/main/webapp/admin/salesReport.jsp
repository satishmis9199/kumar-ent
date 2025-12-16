<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<title>Sales Report</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container py-4" style="max-width:900px;">

<h3 class="fw-bold mb-4 text-center">Sales Report</h3>

<form class="row g-3 mb-4">
  <div class="col-md-4">
    <input type="date" name="from" class="form-control" required>
  </div>
  <div class="col-md-4">
    <input type="date" name="to" class="form-control" required>
  </div>
  <div class="col-md-4">
    <button class="btn btn-primary w-100">Generate Report</button>
  </div>
</form>

<c:if test="${not empty totalOrders}">
<div class="card shadow-sm">
  <div class="card-body">

    <table class="table table-bordered">
      <tr><th>Total Orders</th><td>${totalOrders}</td></tr>
      <tr><th>Total Revenue</th><td>₹ ${revenue}</td></tr>
      <tr><th>Net Amount</th><td>₹ ${netAmount}</td></tr>
      <tr><th>CGST (9%)</th><td>₹ ${cgst}</td></tr>
      <tr><th>SGST (9%)</th><td>₹ ${sgst}</td></tr>
      <tr class="fw-bold table-secondary">
        <th>Total GST</th><td>₹ ${gst}</td>
      </tr>
    </table>

    <a href="<%=request.getContextPath()%>/admin/salesReportPdf?from=${param.from}&to=${param.to}"
   class="btn btn-success">
   Download PDF
</a>
    

  </div>
</div>
</c:if>

</div>
</body>
</html>
