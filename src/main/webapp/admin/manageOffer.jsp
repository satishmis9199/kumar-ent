<%@ page import="java.util.List" %>
<%@ page import="com.kumarent.dao.OfferDAO" %>
<%@ page import="com.kumarent.model.Offer" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
  <title>Manage Offers</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">

  <h3 class="fw-bold mb-4">🎯 Offer Management</h3>

  <!-- ADD NEW OFFER -->
  <div class="card mb-4">
    <div class="card-body">
      <form action="<%=request.getContextPath()%>/admin/saveOffer" method="post">
        <label class="fw-semibold">New Offer</label>
        <input type="text" name="message" class="form-control mb-2" required>
        <button class="btn btn-primary">Publish New Offer</button>
      </form>
    </div>
  </div>

  <!-- OFFER LIST -->
  <div class="card">
    <div class="card-body">

      <h5 class="fw-bold mb-3">Offer History</h5>

      <table class="table table-bordered align-middle">
        <thead class="table-light">
          <tr>
            <th>Message</th>
            <th>Status</th>
            <th width="160">Action</th>
          </tr>
        </thead>
        <tbody>

        <%
          List<Offer> offers = OfferDAO.listAllOffers();
          for (Offer o : offers) {
        %>
          <tr>
            <td><%= o.getMessage() %></td>

            <td>
              <% if (o.isActive()) { %>
                <span class="badge bg-success">ACTIVE</span>
              <% } else { %>
                <span class="badge bg-secondary">INACTIVE</span>
              <% } %>
            </td>

            <td>
              <% if (!o.isActive()) { %>
                <form action="<%=request.getContextPath()%>/admin/activateOffer" method="post">
                  <input type="hidden" name="offerId" value="<%= o.getId() %>">
                  <button class="btn btn-sm btn-outline-primary">
                    Activate
                  </button>
                </form>
              <% } else { %>
                <span class="text-muted">—</span>
              <% } %>
            </td>
          </tr>
        <% } %>

        </tbody>
      </table>

    </div>
  </div>

</div>

</body>
</html>
