<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="com.lostfound.model.*,java.util.List" %>
<%
    com.lostfound.model.User loggedUser = (com.lostfound.model.User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    List<ClaimRequest> claims = (List<ClaimRequest>) request.getAttribute("claims");
    String itemIdParam        = (String) request.getAttribute("itemId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Claims — College Lost &amp; Found Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">
            <span class="brand-lost">Lost</span><span class="brand-and">&amp;</span><span class="brand-found">Found</span>
        </a>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/dashboard"   class="nav-link-custom">Dashboard</a>
            <a href="${pageContext.request.contextPath}/found-items" class="nav-link-custom">Found Items</a>
            <a href="${pageContext.request.contextPath}/logout"      class="nav-link-custom" style="color:#fca5a5;">Logout</a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <h1 class="h4 fw-800 mb-4">
        <i class="fa fa-file-circle-check me-2" style="color:var(--primary-light);"></i>My Claim Requests
    </h1>

    <% if (claims == null || claims.isEmpty()) { %>
    <div class="glass-card text-center py-5">
        <i class="fa fa-inbox fa-3x mb-3" style="color:var(--text-muted);"></i>
        <h4 class="fw-700">No Claim Requests</h4>
        <p class="text-secondary-custom">You haven't submitted any claims yet.</p>
        <a href="${pageContext.request.contextPath}/found-items" class="btn btn-primary-custom mt-2">
            Browse Found Items
        </a>
    </div>
    <% } else { %>
    <div class="row g-3">
        <% for (ClaimRequest cr : claims) { %>
        <div class="col-md-6 col-lg-4">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <h6 class="fw-700 mb-0"><%= cr.getFoundItemName() %></h6>
                    <span class="badge-custom badge-<%= "Pending".equals(cr.getStatus()) ? "pending" : "Approved".equals(cr.getStatus()) ? "found" : "lost" %>">
                        <%= cr.getStatus() %>
                    </span>
                </div>
                <p style="font-size:0.85rem;color:var(--text-secondary);"><%= cr.getProofDescription() %></p>
                <hr class="divider">
                <div style="font-size:0.78rem;color:var(--text-muted);">
                    Submitted: <%= cr.getCreatedAt() != null ? cr.getCreatedAt().toString().substring(0,10) : "—" %>
                </div>
                <% if (cr.getAdminNote() != null && !cr.getAdminNote().isEmpty()) { %>
                <div style="margin-top:0.5rem;font-size:0.82rem;color:var(--text-secondary);">
                    Note: <%= cr.getAdminNote() %>
                </div>
                <% } %>
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/item-detail?type=found&id=<%= cr.getFoundItemId() %>"
                       class="btn btn-sm btn-outline-custom w-100">View Item</a>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<footer class="footer-custom">
    <div class="container"><p>College Lost &amp; Found Portal &nbsp;·&nbsp; &copy; <%= java.time.Year.now() %></p></div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
