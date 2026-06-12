<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="com.lostfound.model.*,com.lostfound.model.LostItem,com.lostfound.model.FoundItem,java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    List<LostItem>     myLostItems    = (List<LostItem>)     request.getAttribute("myLostItems");
    List<FoundItem>    myFoundItems   = (List<FoundItem>)    request.getAttribute("myFoundItems");
    List<com.lostfound.model.ClaimRequest> myClaims = (List<com.lostfound.model.ClaimRequest>) request.getAttribute("myClaims");
    List<LostItem>     recentLost     = (List<LostItem>)     request.getAttribute("recentLostItems");
    List<FoundItem>    recentFound    = (List<FoundItem>)    request.getAttribute("recentFoundItems");

    int totalLost      = (int) request.getAttribute("totalLost");
    int totalFound     = (int) request.getAttribute("totalFound");
    int totalRecovered = (int) request.getAttribute("totalRecovered");
    int pendingClaims  = (int) request.getAttribute("pendingClaims");

    // Flash messages
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    session.removeAttribute("flashSuccess");
    session.removeAttribute("flashError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — College Lost &amp; Found Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between flex-wrap gap-2">
        <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">
            <span class="brand-lost">Lost</span><span class="brand-and">&amp;</span><span class="brand-found">Found</span>
        </a>
        <div class="d-flex align-items-center gap-2 flex-wrap">
            <a href="${pageContext.request.contextPath}/lost-items"  class="nav-link-custom"><i class="fa fa-search me-1"></i>Lost Items</a>
            <a href="${pageContext.request.contextPath}/found-items" class="nav-link-custom"><i class="fa fa-hand-holding me-1"></i>Found Items</a>
            <a href="${pageContext.request.contextPath}/report-lost"  class="btn btn-sm btn-danger-custom"><i class="fa fa-plus me-1"></i>Report Lost</a>
            <a href="${pageContext.request.contextPath}/report-found" class="btn btn-sm btn-success-custom"><i class="fa fa-plus me-1"></i>Report Found</a>
            <div class="dropdown">
                <button class="btn btn-sm btn-outline-custom dropdown-toggle" data-bs-toggle="dropdown">
                    <i class="fa fa-user-circle me-1"></i><%= loggedUser.getFullName().split(" ")[0] %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" style="background:var(--bg-card);border:1px solid var(--border-glass);">
                    <li><span class="dropdown-item-text" style="color:var(--text-muted);font-size:0.8rem;"><%= loggedUser.getUsn() %></span></li>
                    <li><hr class="dropdown-divider" style="border-color:var(--border-glass);"></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard" style="color:var(--text-secondary);">My Dashboard</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout" style="color:#fca5a5;">Sign Out</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container py-4">

    <!-- Flash Messages -->
    <% if (flashSuccess != null) { %>
    <div class="alert alert-custom alert-success-custom alert-dismissible fade show" role="alert">
        <i class="fa fa-circle-check me-2"></i><%= flashSuccess %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if (flashError != null) { %>
    <div class="alert alert-custom alert-error-custom alert-dismissible fade show" role="alert">
        <i class="fa fa-circle-xmark me-2"></i><%= flashError %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Welcome Header -->
    <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-3">
        <div>
            <h1 class="h3 fw-800 mb-1">Welcome back, <%= loggedUser.getFullName().split(" ")[0] %>! 👋</h1>
            <p class="text-secondary-custom mb-0" style="font-size:0.9rem;">
                <i class="fa fa-id-badge me-1"></i><%= loggedUser.getUsn() %>
                &nbsp;·&nbsp;
                <i class="fa fa-building me-1"></i><%= loggedUser.getDepartment() != null ? loggedUser.getDepartment() : "N/A" %>
            </p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/report-lost"  class="btn btn-danger-custom">
                <i class="fa fa-plus me-1"></i>Report Lost
            </a>
            <a href="${pageContext.request.contextPath}/report-found" class="btn btn-success-custom">
                <i class="fa fa-plus me-1"></i>Report Found
            </a>
        </div>
    </div>

    <!-- ── STATS ────────────────────────────────────────────────── -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-card stat-lost">
                <div class="stat-icon" style="background:rgba(239,68,68,0.15);">
                    <i class="fa fa-search" style="color:#ef4444;"></i>
                </div>
                <div class="stat-value" style="color:#fca5a5;"><%= totalLost %></div>
                <div class="stat-label">Total Lost</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card stat-found">
                <div class="stat-icon" style="background:rgba(16,185,129,0.15);">
                    <i class="fa fa-hand-holding" style="color:#10b981;"></i>
                </div>
                <div class="stat-value" style="color:#6ee7b7;"><%= totalFound %></div>
                <div class="stat-label">Total Found</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card stat-recover">
                <div class="stat-icon" style="background:rgba(99,102,241,0.15);">
                    <i class="fa fa-check-circle" style="color:#6366f1;"></i>
                </div>
                <div class="stat-value" style="color:#a5b4fc;"><%= totalRecovered %></div>
                <div class="stat-label">Recovered</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card stat-claims">
                <div class="stat-icon" style="background:rgba(245,158,11,0.15);">
                    <i class="fa fa-bell" style="color:#f59e0b;"></i>
                </div>
                <div class="stat-value" style="color:#fcd34d;"><%= pendingClaims %></div>
                <div class="stat-label">Pending Claims</div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- ── LEFT COLUMN: My Items ─────────────────────────────── -->
        <div class="col-lg-7">

            <!-- My Lost Reports -->
            <div class="glass-card mb-4">
                <div class="section-header">
                    <div class="section-title">
                        <span class="section-title-line" style="background:linear-gradient(#ef4444,#dc2626);"></span>
                        My Lost Reports
                    </div>
                    <a href="${pageContext.request.contextPath}/report-lost" class="btn btn-sm btn-danger-custom">
                        <i class="fa fa-plus me-1"></i>New
                    </a>
                </div>

                <% if (myLostItems == null || myLostItems.isEmpty()) { %>
                <div class="text-center py-4">
                    <i class="fa fa-search-minus fa-2x mb-2" style="color:var(--text-muted);"></i>
                    <p class="text-secondary-custom mb-0" style="font-size:0.9rem;">No lost item reports yet.</p>
                </div>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>Item</th><th>Location</th><th>Date</th><th>Status</th><th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (LostItem li : myLostItems) { %>
                        <tr>
                            <td><strong><%= li.getItemName() %></strong><br>
                                <small style="color:var(--text-muted);"><%= li.getCategory() %></small></td>
                            <td><%= li.getLocation() %></td>
                            <td><%= li.getDateLost() %></td>
                            <td><span class="badge-custom badge-<%= li.getStatus().toLowerCase() %>"><%= li.getStatus() %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/item-detail?type=lost&id=<%= li.getItemId() %>"
                                   class="btn btn-sm btn-outline-custom" style="padding:0.2rem 0.6rem;">View</a>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>

            <!-- My Found Reports -->
            <div class="glass-card">
                <div class="section-header">
                    <div class="section-title">
                        <span class="section-title-line" style="background:linear-gradient(#10b981,#059669);"></span>
                        My Found Reports
                    </div>
                    <a href="${pageContext.request.contextPath}/report-found" class="btn btn-sm btn-success-custom">
                        <i class="fa fa-plus me-1"></i>New
                    </a>
                </div>

                <% if (myFoundItems == null || myFoundItems.isEmpty()) { %>
                <div class="text-center py-4">
                    <i class="fa fa-box-open fa-2x mb-2" style="color:var(--text-muted);"></i>
                    <p class="text-secondary-custom mb-0" style="font-size:0.9rem;">No found item reports yet.</p>
                </div>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr><th>Item</th><th>Location</th><th>Date</th><th>Status</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                        <% for (FoundItem fi : myFoundItems) { %>
                        <tr>
                            <td><strong><%= fi.getItemName() %></strong><br>
                                <small style="color:var(--text-muted);"><%= fi.getCategory() %></small></td>
                            <td><%= fi.getLocation() %></td>
                            <td><%= fi.getDateFound() %></td>
                            <td><span class="badge-custom badge-<%= fi.getStatus().equalsIgnoreCase("Available") ? "found" : fi.getStatus().toLowerCase() %>"><%= fi.getStatus() %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/item-detail?type=found&id=<%= fi.getItemId() %>"
                                   class="btn btn-sm btn-outline-custom" style="padding:0.2rem 0.6rem;">View</a>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>

        <!-- ── RIGHT COLUMN: Claims & Quick Actions ──────────────── -->
        <div class="col-lg-5">

            <!-- My Claim Requests -->
            <div class="glass-card mb-4">
                <div class="section-title mb-3">
                    <span class="section-title-line" style="background:linear-gradient(#f59e0b,#d97706);"></span>
                    My Claim Requests
                </div>

                <% if (myClaims == null || myClaims.isEmpty()) { %>
                <div class="text-center py-3">
                    <i class="fa fa-file-circle-question fa-2x mb-2" style="color:var(--text-muted);"></i>
                    <p class="text-secondary-custom mb-0" style="font-size:0.88rem;">No claims submitted yet.</p>
                </div>
                <% } else {
                    for (com.lostfound.model.ClaimRequest cr : myClaims) { %>
                <div style="background:var(--bg-glass);border:1px solid var(--border-glass);border-radius:var(--radius-md);padding:0.85rem;margin-bottom:0.6rem;">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div style="font-weight:600;font-size:0.9rem;"><%= cr.getFoundItemName() %></div>
                            <div style="font-size:0.78rem;color:var(--text-muted);">Submitted: <%= cr.getCreatedAt() != null ? cr.getCreatedAt().toString().substring(0,10) : "" %></div>
                        </div>
                        <span class="badge-custom <%= cr.getStatusBadgeClass().replace("bg-","badge-").replace("warning text-dark","pending") %>">
                            <%= cr.getStatus() %>
                        </span>
                    </div>
                    <% if (cr.getAdminNote() != null && !cr.getAdminNote().isEmpty()) { %>
                    <div style="font-size:0.78rem;color:var(--text-secondary);margin-top:0.4rem;padding-top:0.4rem;border-top:1px solid var(--border-glass);">
                        Note: <%= cr.getAdminNote() %>
                    </div>
                    <% } %>
                </div>
                <%  }
                   } %>
            </div>

            <!-- Quick Links -->
            <div class="glass-card">
                <div class="section-title mb-3">
                    <span class="section-title-line"></span>Quick Links
                </div>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/lost-items" class="btn btn-outline-custom text-start">
                        <i class="fa fa-search me-2" style="color:#fca5a5;"></i>Browse Lost Items
                    </a>
                    <a href="${pageContext.request.contextPath}/found-items" class="btn btn-outline-custom text-start">
                        <i class="fa fa-hand-holding me-2" style="color:#6ee7b7;"></i>Browse Found Items
                    </a>
                    <a href="${pageContext.request.contextPath}/report-lost" class="btn btn-outline-custom text-start">
                        <i class="fa fa-plus me-2" style="color:#fca5a5;"></i>Report a Lost Item
                    </a>
                    <a href="${pageContext.request.contextPath}/report-found" class="btn btn-outline-custom text-start">
                        <i class="fa fa-plus me-2" style="color:#6ee7b7;"></i>Report a Found Item
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-custom text-start">
                        <i class="fa fa-sign-out-alt me-2" style="color:#fca5a5;"></i>Sign Out
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer-custom">
    <div class="container">
        <p>College Lost &amp; Found Portal &nbsp;·&nbsp; &copy; <%= java.time.Year.now() %></p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
