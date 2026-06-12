<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="com.lostfound.model.FoundItem, java.util.List" %>
<%
    List<FoundItem> items     = (List<FoundItem>) request.getAttribute("items");
    int   totalCount          = (int) request.getAttribute("totalCount");
    String keyword            = (String) request.getAttribute("keyword");
    String selectedCategory   = (String) request.getAttribute("category");
    boolean searching         = Boolean.TRUE.equals(request.getAttribute("searching"));
    if (keyword == null) keyword = "";
    if (selectedCategory == null) selectedCategory = "";

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    session.removeAttribute("flashSuccess");
    boolean isLoggedIn = session.getAttribute("loggedUser") != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Found Items — College Lost &amp; Found Portal</title>
    <meta name="description" content="Browse all found items submitted on campus. Claim your lost item today.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between flex-wrap gap-2">
        <a href="${pageContext.request.contextPath}/<%= isLoggedIn ? "dashboard" : "jsp/index.jsp" %>" class="navbar-brand">
            <span class="brand-lost">Lost</span><span class="brand-and">&amp;</span><span class="brand-found">Found</span>
        </a>
        <div class="d-flex align-items-center gap-2 flex-wrap">
            <a href="${pageContext.request.contextPath}/lost-items"  class="nav-link-custom">Lost Items</a>
            <a href="${pageContext.request.contextPath}/found-items" class="nav-link-custom active-nav">Found Items</a>
            <% if (isLoggedIn) { %>
            <a href="${pageContext.request.contextPath}/report-found" class="btn btn-sm btn-success-custom"><i class="fa fa-plus me-1"></i>Report Found</a>
            <a href="${pageContext.request.contextPath}/dashboard"    class="btn btn-sm btn-outline-custom">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout"       class="nav-link-custom" style="color:#fca5a5;">Logout</a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/login"    class="btn btn-sm btn-primary-custom">Sign In</a>
            <a href="${pageContext.request.contextPath}/register"  class="btn btn-sm btn-outline-custom">Register</a>
            <% } %>
        </div>
    </div>
</nav>

<div class="container py-4">

    <% if (flashSuccess != null) { %>
    <div class="alert alert-custom alert-success-custom alert-dismissible fade show mb-3" role="alert">
        <i class="fa fa-circle-check me-2"></i><%= flashSuccess %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Page Header -->
    <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-3">
        <div>
            <h1 class="h3 fw-800 mb-1">
                <i class="fa fa-hand-holding me-2" style="color:#6ee7b7;"></i>Found Items
            </h1>
            <p class="text-secondary-custom mb-0" style="font-size:0.88rem;">
                <%= searching ? "Search results" : "All available items" %>
                &nbsp;·&nbsp; <strong style="color:var(--text-primary);"><%= items != null ? items.size() : 0 %></strong>
                <%= items != null && items.size() == 1 ? "item" : "items" %>
            </p>
        </div>
        <% if (isLoggedIn) { %>
        <a href="${pageContext.request.contextPath}/report-found" class="btn btn-success-custom">
            <i class="fa fa-plus me-2"></i>Report Found Item
        </a>
        <% } %>
    </div>

    <!-- Search & Filter -->
    <form id="searchForm" action="${pageContext.request.contextPath}/found-items" method="get" class="mb-4">
        <div class="search-bar-wrap">
            <i class="fa fa-search ms-2" style="color:var(--text-muted);flex-shrink:0;"></i>
            <input type="text" name="keyword" placeholder="Search found items by name, description, location..."
                   value="<%= keyword %>" autocomplete="off">
            <select id="categoryFilter" name="category" style="background:rgba(255,255,255,0.07);border:1px solid var(--border-glass);border-radius:var(--radius-md);color:var(--text-secondary);padding:0.35rem 0.75rem;font-size:0.85rem;outline:none;cursor:pointer;">
                <option value="All" <%= selectedCategory.equals("All") || selectedCategory.isEmpty() ? "selected" : "" %>>All Categories</option>
                <option value="Electronics" <%= "Electronics".equals(selectedCategory) ? "selected":"" %>>Electronics</option>
                <option value="Documents"   <%= "Documents".equals(selectedCategory)   ? "selected":"" %>>Documents</option>
                <option value="Accessories" <%= "Accessories".equals(selectedCategory) ? "selected":"" %>>Accessories</option>
                <option value="Stationery"  <%= "Stationery".equals(selectedCategory)  ? "selected":"" %>>Stationery</option>
                <option value="Clothing"    <%= "Clothing".equals(selectedCategory)    ? "selected":"" %>>Clothing</option>
                <option value="Keys"        <%= "Keys".equals(selectedCategory)        ? "selected":"" %>>Keys</option>
                <option value="Wallet/Purse"<%= "Wallet/Purse".equals(selectedCategory)? "selected":"" %>>Wallet/Purse</option>
                <option value="Books"       <%= "Books".equals(selectedCategory)       ? "selected":"" %>>Books</option>
                <option value="Sports Equipment" <%= "Sports Equipment".equals(selectedCategory) ? "selected":"" %>>Sports Equipment</option>
                <option value="Other"       <%= "Other".equals(selectedCategory)       ? "selected":"" %>>Other</option>
            </select>
            <button type="submit" class="btn btn-success-custom" style="flex-shrink:0;padding:0.5rem 1.25rem;">Search</button>
            <% if (searching) { %>
            <a href="${pageContext.request.contextPath}/found-items" style="color:var(--text-muted);flex-shrink:0;padding:0 0.5rem;font-size:0.85rem;">
                <i class="fa fa-times"></i> Clear
            </a>
            <% } %>
        </div>
    </form>

    <!-- Item Grid -->
    <% if (items == null || items.isEmpty()) { %>
    <div class="glass-card text-center py-5">
        <i class="fa fa-box-open fa-3x mb-3" style="color:var(--text-muted);"></i>
        <h4 class="fw-700">No found items</h4>
        <p class="text-secondary-custom">
            <%= searching ? "Try different search terms." : "No found items have been submitted yet." %>
        </p>
        <% if (isLoggedIn) { %>
        <a href="${pageContext.request.contextPath}/report-found" class="btn btn-success-custom mt-2">
            <i class="fa fa-hand-holding me-2"></i>Report a Found Item
        </a>
        <% } %>
    </div>
    <% } else { %>
    <div class="row g-3">
        <% for (FoundItem item : items) { %>
        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="item-card">
                <div class="item-img-wrap">
                    <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= item.getImagePath() %>"
                         alt="<%= item.getItemName() %>" loading="lazy">
                    <% } else { %>
                    <div class="item-img-placeholder">
                        <i class="fa <%= item.getCategoryIcon() %>"></i>
                    </div>
                    <% } %>
                    <span class="badge-custom badge-<%= item.getStatus().equalsIgnoreCase("Available") ? "found" : item.getStatus().toLowerCase() %>"
                          style="position:absolute;top:10px;right:10px;">
                        <%= item.getStatus() %>
                    </span>
                </div>

                <div class="item-body">
                    <div class="item-title"><%= item.getItemName() %></div>
                    <div class="item-meta"><i class="fa fa-tag"></i><%= item.getCategory() %></div>
                    <div class="item-meta"><i class="fa fa-location-dot"></i><%= item.getLocation() %></div>
                    <div class="item-meta"><i class="fa fa-calendar"></i><%= item.getDateFound() %></div>
                    <% if (item.getDescription() != null && !item.getDescription().isEmpty()) { %>
                    <p class="item-desc mt-2"><%= item.getDescription() %></p>
                    <% } %>

                    <div class="item-footer">
                        <small style="color:var(--text-muted);font-size:0.75rem;">
                            by <%= item.getReporterName() != null ? item.getReporterName() : "Unknown" %>
                        </small>
                        <a href="${pageContext.request.contextPath}/item-detail?type=found&id=<%= item.getItemId() %>"
                           class="btn btn-sm btn-outline-custom" style="padding:0.2rem 0.75rem;font-size:0.8rem;">
                            <%= "Available".equals(item.getStatus()) && isLoggedIn ? "Claim →" : "Details →" %>
                        </a>
                    </div>
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
