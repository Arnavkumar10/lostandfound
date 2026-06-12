<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="com.lostfound.model.*,java.util.List" %>
<%
    com.lostfound.model.Admin loggedAdmin = (com.lostfound.model.Admin) session.getAttribute("loggedAdmin");
    if (loggedAdmin == null) { response.sendRedirect(request.getContextPath() + "/admin-login"); return; }

    String activeTab   = (String) request.getAttribute("activeTab");
    if (activeTab == null) activeTab = "dashboard";

    // Dashboard stats
    Integer statTotalLost     = (Integer) request.getAttribute("statTotalLost");
    Integer statTotalFound    = (Integer) request.getAttribute("statTotalFound");
    Integer statRecovered     = (Integer) request.getAttribute("statRecovered");
    Integer statTotalUsers    = (Integer) request.getAttribute("statTotalUsers");
    Integer statPendingClaims = (Integer) request.getAttribute("statPendingClaims");

    // Tab data
    List<User>         users      = (List<User>)         request.getAttribute("users");
    List<LostItem>     lostItems  = (List<LostItem>)     request.getAttribute("lostItems");
    List<FoundItem>    foundItems = (List<FoundItem>)    request.getAttribute("foundItems");
    List<ClaimRequest> claims     = (List<ClaimRequest>) request.getAttribute("claims");
    List<LostItem>     recentLost  = (List<LostItem>)    request.getAttribute("recentLost");
    List<FoundItem>    recentFound = (List<FoundItem>)   request.getAttribute("recentFound");

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    session.removeAttribute("flashSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel — College Lost &amp; Found Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <div class="navbar-brand">
            <span class="brand-lost">Lost</span><span class="brand-and">&amp;</span><span class="brand-found">Found</span>
            <span style="background:rgba(245,158,11,0.15);color:#fcd34d;padding:0.2rem 0.6rem;border-radius:6px;font-size:0.7rem;font-weight:700;margin-left:8px;border:1px solid rgba(245,158,11,0.3);">ADMIN</span>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span style="color:var(--text-muted);font-size:0.85rem;"><i class="fa fa-user-shield me-1"></i><%= loggedAdmin.getFullName() %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-custom" style="color:#fca5a5;border-color:rgba(239,68,68,0.3);">
                <i class="fa fa-sign-out-alt me-1"></i>Logout
            </a>
        </div>
    </div>
</nav>

<div class="container-fluid py-4" style="max-width:1400px;">

    <% if (flashSuccess != null) { %>
    <div class="alert alert-custom alert-success-custom alert-dismissible fade show mb-3">
        <i class="fa fa-circle-check me-2"></i><%= flashSuccess %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="row g-4">
        <!-- ── SIDEBAR ─────────────────────────────────────────── -->
        <div class="col-lg-2 col-md-3">
            <div class="admin-sidebar">
                <div style="font-size:0.72rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.08em;margin-bottom:1rem;padding:0 0.5rem;">
                    Navigation
                </div>
                <a href="${pageContext.request.contextPath}/admin?tab=dashboard"
                   class="admin-nav-item <%= "dashboard".equals(activeTab) ? "active" : "" %>">
                    <i class="fa fa-chart-line"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin?tab=users"
                   class="admin-nav-item <%= "users".equals(activeTab) ? "active" : "" %>">
                    <i class="fa fa-users"></i>Users
                </a>
                <a href="${pageContext.request.contextPath}/admin?tab=lost"
                   class="admin-nav-item <%= "lost".equals(activeTab) ? "active" : "" %>">
                    <i class="fa fa-search"></i>Lost Items
                </a>
                <a href="${pageContext.request.contextPath}/admin?tab=found"
                   class="admin-nav-item <%= "found".equals(activeTab) ? "active" : "" %>">
                    <i class="fa fa-hand-holding"></i>Found Items
                </a>
                <a href="${pageContext.request.contextPath}/admin?tab=claims"
                   class="admin-nav-item <%= "claims".equals(activeTab) ? "active" : "" %>">
                    <i class="fa fa-file-circle-check"></i>Claims
                </a>
                <hr class="divider" style="margin:0.75rem 0;">
                <a href="${pageContext.request.contextPath}/logout" class="admin-nav-item" style="color:#fca5a5;">
                    <i class="fa fa-sign-out-alt"></i>Logout
                </a>
            </div>
        </div>

        <!-- ── MAIN CONTENT ───────────────────────────────────── -->
        <div class="col-lg-10 col-md-9">

            <!-- ════════════════════════════════════════════════
                 TAB: DASHBOARD
            ════════════════════════════════════════════════ -->
            <% if ("dashboard".equals(activeTab)) { %>
            <div class="d-flex align-items-center justify-content-between mb-4">
                <h1 class="h4 fw-800 mb-0">Admin Dashboard</h1>
                <span style="color:var(--text-muted);font-size:0.85rem;">Welcome, <%= loggedAdmin.getFullName() %></span>
            </div>

            <!-- Stats Grid -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-2-4">
                    <div class="stat-card stat-lost">
                        <div class="stat-icon" style="background:rgba(239,68,68,0.15);">
                            <i class="fa fa-search" style="color:#ef4444;"></i>
                        </div>
                        <div class="stat-value" style="color:#fca5a5;"><%= statTotalLost != null ? statTotalLost : 0 %></div>
                        <div class="stat-label">Total Lost</div>
                    </div>
                </div>
                <div class="col-6 col-md-2-4">
                    <div class="stat-card stat-found">
                        <div class="stat-icon" style="background:rgba(16,185,129,0.15);">
                            <i class="fa fa-hand-holding" style="color:#10b981;"></i>
                        </div>
                        <div class="stat-value" style="color:#6ee7b7;"><%= statTotalFound != null ? statTotalFound : 0 %></div>
                        <div class="stat-label">Total Found</div>
                    </div>
                </div>
                <div class="col-6 col-md-2-4">
                    <div class="stat-card stat-recover">
                        <div class="stat-icon" style="background:rgba(99,102,241,0.15);">
                            <i class="fa fa-check-circle" style="color:#6366f1;"></i>
                        </div>
                        <div class="stat-value" style="color:#a5b4fc;"><%= statRecovered != null ? statRecovered : 0 %></div>
                        <div class="stat-label">Recovered</div>
                    </div>
                </div>
                <div class="col-6 col-md-2-4">
                    <div class="stat-card stat-claims">
                        <div class="stat-icon" style="background:rgba(245,158,11,0.15);">
                            <i class="fa fa-users" style="color:#f59e0b;"></i>
                        </div>
                        <div class="stat-value" style="color:#fcd34d;"><%= statTotalUsers != null ? statTotalUsers : 0 %></div>
                        <div class="stat-label">Users</div>
                    </div>
                </div>
                <div class="col-6 col-md-2-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(6,182,212,0.15);">
                            <i class="fa fa-bell" style="color:#06b6d4;"></i>
                        </div>
                        <div class="stat-value" style="color:#67e8f9;"><%= statPendingClaims != null ? statPendingClaims : 0 %></div>
                        <div class="stat-label">Pending Claims</div>
                    </div>
                </div>
            </div>

            <!-- Recent Items -->
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="glass-card">
                        <div class="section-header">
                            <div class="section-title"><span class="section-title-line" style="background:linear-gradient(#ef4444,#dc2626);"></span>Recent Lost Reports</div>
                            <a href="${pageContext.request.contextPath}/admin?tab=lost" style="font-size:0.8rem;color:var(--text-muted);">View all →</a>
                        </div>
                        <% if (recentLost != null && !recentLost.isEmpty()) {
                            for (LostItem li : recentLost) { %>
                        <div class="d-flex align-items-center justify-content-between py-2" style="border-bottom:1px solid var(--border-glass);">
                            <div>
                                <div style="font-weight:600;font-size:0.9rem;"><%= li.getItemName() %></div>
                                <div style="font-size:0.76rem;color:var(--text-muted);"><%= li.getCategory() %> · <%= li.getLocation() %></div>
                            </div>
                            <span class="badge-custom badge-<%= li.getStatus().toLowerCase() %>"><%= li.getStatus() %></span>
                        </div>
                        <%  }
                           } else { %>
                        <p class="text-secondary-custom" style="font-size:0.88rem;padding:1rem 0;margin:0;">No reports yet.</p>
                        <% } %>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="glass-card">
                        <div class="section-header">
                            <div class="section-title"><span class="section-title-line" style="background:linear-gradient(#10b981,#059669);"></span>Recent Found Reports</div>
                            <a href="${pageContext.request.contextPath}/admin?tab=found" style="font-size:0.8rem;color:var(--text-muted);">View all →</a>
                        </div>
                        <% if (recentFound != null && !recentFound.isEmpty()) {
                            for (FoundItem fi : recentFound) { %>
                        <div class="d-flex align-items-center justify-content-between py-2" style="border-bottom:1px solid var(--border-glass);">
                            <div>
                                <div style="font-weight:600;font-size:0.9rem;"><%= fi.getItemName() %></div>
                                <div style="font-size:0.76rem;color:var(--text-muted);"><%= fi.getCategory() %> · <%= fi.getLocation() %></div>
                            </div>
                            <span class="badge-custom badge-<%= fi.getStatus().equalsIgnoreCase("Available") ? "found" : fi.getStatus().toLowerCase() %>"><%= fi.getStatus() %></span>
                        </div>
                        <%  }
                           } else { %>
                        <p class="text-secondary-custom" style="font-size:0.88rem;padding:1rem 0;margin:0;">No reports yet.</p>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- ════════════════════════════════════════════════
                 TAB: USERS
            ════════════════════════════════════════════════ -->
            <% } else if ("users".equals(activeTab)) { %>
            <h1 class="h4 fw-800 mb-4">Manage Users <span style="color:var(--text-muted);font-size:0.9rem;font-weight:400;">(<%= users != null ? users.size() : 0 %> total)</span></h1>
            <div class="glass-card">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr><th>#</th><th>USN</th><th>Name</th><th>Email</th><th>Dept</th><th>Status</th><th>Joined</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                        <% if (users != null) { int n = 1; for (User u : users) { %>
                        <tr>
                            <td style="color:var(--text-muted);"><%= n++ %></td>
                            <td><code style="color:var(--primary-light);"><%= u.getUsn() %></code></td>
                            <td><strong><%= u.getFullName() %></strong></td>
                            <td style="color:var(--text-secondary);font-size:0.85rem;"><%= u.getEmail() %></td>
                            <td><%= u.getDepartment() != null ? u.getDepartment() : "—" %></td>
                            <td>
                                <span class="badge-custom <%= u.isActive() ? "badge-found" : "badge-closed" %>">
                                    <%= u.isActive() ? "Active" : "Disabled" %>
                                </span>
                            </td>
                            <td style="font-size:0.8rem;color:var(--text-muted);">
                                <%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0,10) : "—" %>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline">
                                    <input type="hidden" name="action"  value="toggleUser">
                                    <input type="hidden" name="userId"  value="<%= u.getUserId() %>">
                                    <input type="hidden" name="active"  value="<%= !u.isActive() %>">
                                    <button type="submit" class="btn btn-sm"
                                            style="padding:0.2rem 0.6rem;border-radius:6px;border:1px solid var(--border-glass);background:var(--bg-glass);color:var(--text-secondary);font-size:0.78rem;">
                                        <%= u.isActive() ? "Disable" : "Enable" %>
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline"
                                      onsubmit="return confirm('Delete user <%= u.getFullName() %>? This cannot be undone.')">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-sm ms-1"
                                            style="padding:0.2rem 0.6rem;border-radius:6px;border:1px solid rgba(239,68,68,0.3);background:rgba(239,68,68,0.1);color:#fca5a5;font-size:0.78rem;">
                                        Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ════════════════════════════════════════════════
                 TAB: LOST ITEMS
            ════════════════════════════════════════════════ -->
            <% } else if ("lost".equals(activeTab)) { %>
            <h1 class="h4 fw-800 mb-4">Manage Lost Items <span style="color:var(--text-muted);font-size:0.9rem;font-weight:400;">(<%= lostItems != null ? lostItems.size() : 0 %> total)</span></h1>
            <div class="glass-card">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr><th>#</th><th>Item</th><th>Reporter</th><th>Location</th><th>Date</th><th>Status</th><th>Approved</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                        <% if (lostItems != null) { int n = 1; for (LostItem li : lostItems) { %>
                        <tr>
                            <td style="color:var(--text-muted);"><%= n++ %></td>
                            <td>
                                <strong><%= li.getItemName() %></strong><br>
                                <small style="color:var(--text-muted);"><%= li.getCategory() %></small>
                            </td>
                            <td style="font-size:0.85rem;"><%= li.getReporterName() != null ? li.getReporterName() : "—" %></td>
                            <td style="font-size:0.85rem;"><%= li.getLocation() %></td>
                            <td style="font-size:0.8rem;color:var(--text-muted);"><%= li.getDateLost() %></td>
                            <td><span class="badge-custom badge-<%= li.getStatus().toLowerCase() %>"><%= li.getStatus() %></span></td>
                            <td>
                                <span class="badge-custom <%= li.isApproved() ? "badge-found" : "badge-pending" %>">
                                    <%= li.isApproved() ? "Yes" : "No" %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-1 flex-wrap">
                                <a href="${pageContext.request.contextPath}/item-detail?type=lost&id=<%= li.getItemId() %>"
                                   class="btn btn-sm" style="padding:0.2rem 0.5rem;font-size:0.75rem;background:var(--bg-glass);border:1px solid var(--border-glass);color:var(--text-secondary);border-radius:6px;">
                                    View
                                </a>
                                <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline">
                                    <input type="hidden" name="action"   value="approveLost">
                                    <input type="hidden" name="itemId"   value="<%= li.getItemId() %>">
                                    <input type="hidden" name="approved" value="<%= !li.isApproved() %>">
                                    <button type="submit" class="btn btn-sm"
                                            style="padding:0.2rem 0.5rem;font-size:0.75rem;background:<%= li.isApproved() ? "rgba(100,116,139,0.15)" : "rgba(16,185,129,0.15)" %>;border:1px solid <%= li.isApproved() ? "rgba(100,116,139,0.3)" : "rgba(16,185,129,0.3)" %>;color:<%= li.isApproved() ? "#94a3b8" : "#6ee7b7" %>;border-radius:6px;">
                                        <%= li.isApproved() ? "Unapprove" : "Approve" %>
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline"
                                      onsubmit="return confirm('Delete this lost item record?')">
                                    <input type="hidden" name="action" value="deleteLost">
                                    <input type="hidden" name="itemId" value="<%= li.getItemId() %>">
                                    <button type="submit" class="btn btn-sm"
                                            style="padding:0.2rem 0.5rem;font-size:0.75rem;background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);color:#fca5a5;border-radius:6px;">
                                        Del
                                    </button>
                                </form>
                                </div>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ════════════════════════════════════════════════
                 TAB: FOUND ITEMS
            ════════════════════════════════════════════════ -->
            <% } else if ("found".equals(activeTab)) { %>
            <h1 class="h4 fw-800 mb-4">Manage Found Items <span style="color:var(--text-muted);font-size:0.9rem;font-weight:400;">(<%= foundItems != null ? foundItems.size() : 0 %> total)</span></h1>
            <div class="glass-card">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr><th>#</th><th>Item</th><th>Reporter</th><th>Location</th><th>Date</th><th>Status</th><th>Approved</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                        <% if (foundItems != null) { int n = 1; for (FoundItem fi : foundItems) { %>
                        <tr>
                            <td style="color:var(--text-muted);"><%= n++ %></td>
                            <td>
                                <strong><%= fi.getItemName() %></strong><br>
                                <small style="color:var(--text-muted);"><%= fi.getCategory() %></small>
                            </td>
                            <td style="font-size:0.85rem;"><%= fi.getReporterName() != null ? fi.getReporterName() : "—" %></td>
                            <td style="font-size:0.85rem;"><%= fi.getLocation() %></td>
                            <td style="font-size:0.8rem;color:var(--text-muted);"><%= fi.getDateFound() %></td>
                            <td><span class="badge-custom badge-<%= fi.getStatus().equalsIgnoreCase("Available") ? "found" : fi.getStatus().toLowerCase() %>"><%= fi.getStatus() %></span></td>
                            <td>
                                <span class="badge-custom <%= fi.isApproved() ? "badge-found" : "badge-pending" %>">
                                    <%= fi.isApproved() ? "Yes" : "No" %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-1 flex-wrap">
                                <a href="${pageContext.request.contextPath}/item-detail?type=found&id=<%= fi.getItemId() %>"
                                   class="btn btn-sm" style="padding:0.2rem 0.5rem;font-size:0.75rem;background:var(--bg-glass);border:1px solid var(--border-glass);color:var(--text-secondary);border-radius:6px;">
                                    View
                                </a>
                                <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline">
                                    <input type="hidden" name="action"   value="approveFound">
                                    <input type="hidden" name="itemId"   value="<%= fi.getItemId() %>">
                                    <input type="hidden" name="approved" value="<%= !fi.isApproved() %>">
                                    <button type="submit" class="btn btn-sm"
                                            style="padding:0.2rem 0.5rem;font-size:0.75rem;background:<%= fi.isApproved() ? "rgba(100,116,139,0.15)" : "rgba(16,185,129,0.15)" %>;border:1px solid <%= fi.isApproved() ? "rgba(100,116,139,0.3)" : "rgba(16,185,129,0.3)" %>;color:<%= fi.isApproved() ? "#94a3b8" : "#6ee7b7" %>;border-radius:6px;">
                                        <%= fi.isApproved() ? "Unapprove" : "Approve" %>
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline"
                                      onsubmit="return confirm('Delete this found item record?')">
                                    <input type="hidden" name="action" value="deleteFound">
                                    <input type="hidden" name="itemId" value="<%= fi.getItemId() %>">
                                    <button type="submit" class="btn btn-sm"
                                            style="padding:0.2rem 0.5rem;font-size:0.75rem;background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);color:#fca5a5;border-radius:6px;">
                                        Del
                                    </button>
                                </form>
                                </div>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ════════════════════════════════════════════════
                 TAB: CLAIMS
            ════════════════════════════════════════════════ -->
            <% } else if ("claims".equals(activeTab)) { %>
            <h1 class="h4 fw-800 mb-4">Manage Claims <span style="color:var(--text-muted);font-size:0.9rem;font-weight:400;">(<%= claims != null ? claims.size() : 0 %> total)</span></h1>
            <div class="glass-card">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr><th>#</th><th>Found Item</th><th>Claimant</th><th>USN</th><th>Proof</th><th>Status</th><th>Date</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                        <% if (claims != null) { int n = 1; for (ClaimRequest cr : claims) { %>
                        <tr>
                            <td style="color:var(--text-muted);"><%= n++ %></td>
                            <td><strong><%= cr.getFoundItemName() %></strong></td>
                            <td><%= cr.getClaimantName() %></td>
                            <td><code style="color:var(--primary-light);font-size:0.78rem;"><%= cr.getClaimantUSN() %></code></td>
                            <td style="max-width:180px;">
                                <span style="font-size:0.8rem;color:var(--text-secondary);" title="<%= cr.getProofDescription() %>">
                                    <%= cr.getProofDescription().length() > 60 ? cr.getProofDescription().substring(0,60) + "…" : cr.getProofDescription() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge-custom badge-<%= cr.getStatus().equals("Pending") ? "pending" : cr.getStatus().equals("Approved") ? "found" : "lost" %>">
                                    <%= cr.getStatus() %>
                                </span>
                            </td>
                            <td style="font-size:0.78rem;color:var(--text-muted);">
                                <%= cr.getCreatedAt() != null ? cr.getCreatedAt().toString().substring(0,10) : "—" %>
                            </td>
                            <td>
                                <% if ("Pending".equals(cr.getStatus())) { %>
                                <div class="d-flex gap-1 flex-wrap">
                                    <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline">
                                        <input type="hidden" name="action"    value="resolveClaim">
                                        <input type="hidden" name="claimId"   value="<%= cr.getClaimId() %>">
                                        <input type="hidden" name="status"    value="Approved">
                                        <input type="hidden" name="adminNote" value="Approved by admin.">
                                        <button type="submit" class="btn btn-sm"
                                                style="padding:0.2rem 0.5rem;font-size:0.75rem;background:rgba(16,185,129,0.15);border:1px solid rgba(16,185,129,0.3);color:#6ee7b7;border-radius:6px;">
                                            Approve
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline">
                                        <input type="hidden" name="action"    value="resolveClaim">
                                        <input type="hidden" name="claimId"   value="<%= cr.getClaimId() %>">
                                        <input type="hidden" name="status"    value="Rejected">
                                        <input type="hidden" name="adminNote" value="Rejected by admin.">
                                        <button type="submit" class="btn btn-sm"
                                                style="padding:0.2rem 0.5rem;font-size:0.75rem;background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);color:#fca5a5;border-radius:6px;">
                                            Reject
                                        </button>
                                    </form>
                                </div>
                                <% } else { %>
                                <span style="color:var(--text-muted);font-size:0.8rem;"><%= cr.getAdminNote() != null ? cr.getAdminNote() : "—" %></span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } %>

        </div><!-- end main content -->
    </div><!-- end row -->
</div><!-- end container -->

<footer class="footer-custom" style="margin-top:2rem;">
    <div class="container">
        <p>College Lost &amp; Found Portal — Admin Panel &nbsp;·&nbsp; &copy; <%= java.time.Year.now() %></p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
