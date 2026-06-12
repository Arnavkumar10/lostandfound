<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="com.lostfound.model.*,java.util.List" %>
<%
    String type        = (String) request.getAttribute("type");
    LostItem  lostItem  = "lost".equals(type)  ? (LostItem)  request.getAttribute("item") : null;
    FoundItem foundItem = "found".equals(type) ? (FoundItem) request.getAttribute("item") : null;
    List<ClaimRequest> claims = (List<ClaimRequest>) request.getAttribute("claims");
    Boolean hasClaimed = (Boolean) request.getAttribute("hasClaimed");
    Boolean isOwner    = (Boolean) request.getAttribute("isOwner");

    com.lostfound.model.User loggedUser = (com.lostfound.model.User) session.getAttribute("loggedUser");
    boolean isLoggedIn  = loggedUser != null;
    boolean isFoundType = "found".equals(type);

    String itemName      = isFoundType ? foundItem.getItemName()    : lostItem.getItemName();
    String category      = isFoundType ? foundItem.getCategory()    : lostItem.getCategory();
    String description   = isFoundType ? foundItem.getDescription() : lostItem.getDescription();
    String location      = isFoundType ? foundItem.getLocation()    : lostItem.getLocation();
    String contact       = isFoundType ? foundItem.getContactInfo() : lostItem.getContactInfo();
    String status        = isFoundType ? foundItem.getStatus()      : lostItem.getStatus();
    String imagePath     = isFoundType ? foundItem.getImagePath()   : lostItem.getImagePath();
    String reporterName  = isFoundType ? foundItem.getReporterName(): lostItem.getReporterName();
    String date          = isFoundType ? foundItem.getDateFound().toString() : lostItem.getDateLost().toString();
    int itemId           = isFoundType ? foundItem.getItemId()      : lostItem.getItemId();
    String categoryIcon  = isFoundType ? foundItem.getCategoryIcon(): lostItem.getCategoryIcon();

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
    <title><%= itemName %> — College Lost &amp; Found Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="${pageContext.request.contextPath}/<%= isLoggedIn ? "dashboard" : "jsp/index.jsp" %>" class="navbar-brand">
            <span class="brand-lost">Lost</span><span class="brand-and">&amp;</span><span class="brand-found">Found</span>
        </a>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/lost-items"  class="nav-link-custom">Lost Items</a>
            <a href="${pageContext.request.contextPath}/found-items" class="nav-link-custom">Found Items</a>
            <% if (isLoggedIn) { %>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-sm btn-outline-custom">Dashboard</a>
            <% } %>
        </div>
    </div>
</nav>

<div class="container py-4">

    <% if (flashSuccess != null) { %>
    <div class="alert alert-custom alert-success-custom alert-dismissible fade show mb-3">
        <i class="fa fa-circle-check me-2"></i><%= flashSuccess %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if (flashError != null) { %>
    <div class="alert alert-custom alert-error-custom alert-dismissible fade show mb-3">
        <i class="fa fa-circle-xmark me-2"></i><%= flashError %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb" style="background:none;padding:0;font-size:0.85rem;">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/<%= isFoundType ? "found-items" : "lost-items" %>"
                   style="color:var(--text-muted);"><%= isFoundType ? "Found Items" : "Lost Items" %></a>
            </li>
            <li class="breadcrumb-item active" style="color:var(--text-secondary);"><%= itemName %></li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- ── LEFT: Item Details ─────────────────────────────────── -->
        <div class="col-lg-8">
            <div class="glass-card">
                <!-- Image -->
                <div style="border-radius:var(--radius-md);overflow:hidden;margin-bottom:1.5rem;background:linear-gradient(135deg,#1e1e3a,#2a2a4a);min-height:280px;display:flex;align-items:center;justify-content:center;">
                    <% if (imagePath != null && !imagePath.isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= imagePath %>"
                         alt="<%= itemName %>" style="width:100%;max-height:400px;object-fit:contain;">
                    <% } else { %>
                    <div style="text-align:center;padding:3rem;">
                        <i class="fa <%= categoryIcon %> fa-5x" style="color:var(--text-muted);opacity:0.4;"></i>
                        <p style="color:var(--text-muted);margin-top:1rem;font-size:0.85rem;">No image provided</p>
                    </div>
                    <% } %>
                </div>

                <!-- Title & Status -->
                <div class="d-flex align-items-start justify-content-between gap-3 mb-3 flex-wrap">
                    <div>
                        <h1 class="h3 fw-800 mb-1"><%= itemName %></h1>
                        <div class="d-flex align-items-center gap-2 flex-wrap">
                            <span class="badge-custom badge-<%= isFoundType ? "found" : "lost" %>">
                                <i class="fa fa-<%= isFoundType ? "hand-holding" : "search" %> me-1"></i>
                                <%= isFoundType ? "Found Item" : "Lost Item" %>
                            </span>
                            <span class="badge-custom badge-<%= status.equalsIgnoreCase("Available") ? "found" : status.toLowerCase() %>">
                                <%= status %>
                            </span>
                            <span style="color:var(--text-muted);font-size:0.8rem;">
                                <i class="fa fa-tag me-1"></i><%= category %>
                            </span>
                        </div>
                    </div>
                </div>

                <hr class="divider">

                <!-- Meta Grid -->
                <div class="row g-3 mb-4">
                    <div class="col-sm-6">
                        <div style="background:var(--bg-glass);border:1px solid var(--border-glass);border-radius:var(--radius-md);padding:1rem;">
                            <div style="font-size:0.75rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.3rem;">
                                <i class="fa fa-location-dot me-1"></i><%= isFoundType ? "Found At" : "Last Seen At" %>
                            </div>
                            <div style="font-weight:600;"><%= location %></div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div style="background:var(--bg-glass);border:1px solid var(--border-glass);border-radius:var(--radius-md);padding:1rem;">
                            <div style="font-size:0.75rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.3rem;">
                                <i class="fa fa-calendar me-1"></i><%= isFoundType ? "Date Found" : "Date Lost" %>
                            </div>
                            <div style="font-weight:600;"><%= date %></div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div style="background:var(--bg-glass);border:1px solid var(--border-glass);border-radius:var(--radius-md);padding:1rem;">
                            <div style="font-size:0.75rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.3rem;">
                                <i class="fa fa-user me-1"></i>Reported By
                            </div>
                            <div style="font-weight:600;"><%= reporterName != null ? reporterName : "Unknown" %></div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div style="background:var(--bg-glass);border:1px solid var(--border-glass);border-radius:var(--radius-md);padding:1rem;">
                            <div style="font-size:0.75rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.3rem;">
                                <i class="fa fa-phone me-1"></i>Contact
                            </div>
                            <div style="font-weight:600;"><%= contact %></div>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <% if (description != null && !description.isEmpty()) { %>
                <div>
                    <h6 class="fw-700 mb-2" style="color:var(--text-secondary);font-size:0.85rem;text-transform:uppercase;letter-spacing:0.05em;">
                        Description
                    </h6>
                    <p style="color:var(--text-secondary);line-height:1.7;"><%= description %></p>
                </div>
                <% } %>

                <!-- ── Claim Requests (for found items, owner view) ─────── -->
                <% if (isFoundType && isOwner != null && isOwner && claims != null && !claims.isEmpty()) { %>
                <hr class="divider">
                <h5 class="fw-700 mb-3">Claim Requests (<%= claims.size() %>)</h5>
                <% for (ClaimRequest cr : claims) { %>
                <div style="background:var(--bg-glass);border:1px solid var(--border-glass);border-radius:var(--radius-md);padding:1rem;margin-bottom:0.75rem;">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-2">
                        <div>
                            <div style="font-weight:600;"><%= cr.getClaimantName() %></div>
                            <div style="font-size:0.78rem;color:var(--text-muted);">USN: <%= cr.getClaimantUSN() %> &nbsp;·&nbsp; <%= cr.getCreatedAt() != null ? cr.getCreatedAt().toString().substring(0,10) : "" %></div>
                        </div>
                        <span class="badge-custom badge-<%= cr.getStatus().equals("Pending") ? "pending" : cr.getStatus().equals("Approved") ? "found" : "lost" %>">
                            <%= cr.getStatus() %>
                        </span>
                    </div>
                    <p style="font-size:0.88rem;color:var(--text-secondary);margin-bottom:0.75rem;"><%= cr.getProofDescription() %></p>
                    <% if ("Pending".equals(cr.getStatus())) { %>
                    <div class="d-flex gap-2">
                        <form action="${pageContext.request.contextPath}/claim" method="post" class="d-inline">
                            <input type="hidden" name="action"    value="resolve">
                            <input type="hidden" name="claimId"   value="<%= cr.getClaimId() %>">
                            <input type="hidden" name="status"    value="Approved">
                            <input type="hidden" name="adminNote" value="Approved by item finder.">
                            <button type="submit" class="btn btn-sm btn-success-custom">
                                <i class="fa fa-check me-1"></i>Approve
                            </button>
                        </form>
                        <form action="${pageContext.request.contextPath}/claim" method="post" class="d-inline">
                            <input type="hidden" name="action"    value="resolve">
                            <input type="hidden" name="claimId"   value="<%= cr.getClaimId() %>">
                            <input type="hidden" name="status"    value="Rejected">
                            <input type="hidden" name="adminNote" value="Rejected by item finder.">
                            <button type="submit" class="btn btn-sm btn-danger-custom">
                                <i class="fa fa-times me-1"></i>Reject
                            </button>
                        </form>
                    </div>
                    <% } %>
                </div>
                <% } %>
                <% } %>
            </div>
        </div>

        <!-- ── RIGHT: Actions ────────────────────────────────────── -->
        <div class="col-lg-4">
            <div class="glass-card" style="position:sticky;top:80px;">
                <h5 class="fw-700 mb-4">Actions</h5>

                <% if (isFoundType) { %>
                    <% if ("Available".equals(status)) { %>
                        <% if (!isLoggedIn) { %>
                        <p class="text-secondary-custom" style="font-size:0.9rem;">
                            <a href="${pageContext.request.contextPath}/login" style="color:var(--primary-light);">Sign in</a>
                            to claim this item.
                        </p>
                        <% } else if (isOwner != null && isOwner) { %>
                        <div style="background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.2);border-radius:var(--radius-md);padding:0.85rem;margin-bottom:1rem;">
                            <p style="font-size:0.85rem;color:#fcd34d;margin:0;">
                                <i class="fa fa-info-circle me-1"></i>This is your item. Review claim requests below.
                            </p>
                        </div>
                        <% } else if (hasClaimed != null && hasClaimed) { %>
                        <div style="background:rgba(99,102,241,0.1);border:1px solid rgba(99,102,241,0.2);border-radius:var(--radius-md);padding:0.85rem;margin-bottom:1rem;">
                            <p style="font-size:0.85rem;color:var(--primary-light);margin:0;">
                                <i class="fa fa-clock me-1"></i>You've already submitted a claim. Awaiting review.
                            </p>
                        </div>
                        <% } else { %>
                        <!-- Claim Form -->
                        <p style="font-size:0.88rem;color:var(--text-secondary);margin-bottom:1rem;">
                            Think this is yours? Submit a claim with proof of ownership.
                        </p>
                        <form action="${pageContext.request.contextPath}/claim" method="post">
                            <input type="hidden" name="action"      value="submit">
                            <input type="hidden" name="foundItemId" value="<%= itemId %>">
                            <div class="mb-3">
                                <label class="form-label-custom" for="proofDescription">
                                    Proof of Ownership <span style="color:var(--danger);">*</span>
                                </label>
                                <textarea id="proofDescription" name="proofDescription"
                                          class="form-control form-control-custom" rows="4"
                                          placeholder="Describe how you can prove this is yours. E.g.: name on first page, specific markings, contents, purchase receipt details..."
                                          required maxlength="1000"></textarea>
                                <div class="text-end mt-1"><small id="proofCounter" style="color:var(--text-muted);font-size:0.75rem;">0/1000</small></div>
                            </div>
                            <button type="submit" class="btn btn-primary-custom w-100">
                                <i class="fa fa-paper-plane me-2"></i>Submit Claim
                            </button>
                        </form>
                        <% } %>
                    <% } else { %>
                    <div style="background:rgba(100,116,139,0.1);border:1px solid rgba(100,116,139,0.2);border-radius:var(--radius-md);padding:0.85rem;">
                        <p style="font-size:0.85rem;color:var(--text-secondary);margin:0;">
                            This item has already been <%= status.equalsIgnoreCase("Claimed") ? "claimed" : "closed" %>.
                        </p>
                    </div>
                    <% } %>
                <% } else { %>
                    <!-- Lost item — contact reporter -->
                    <p style="font-size:0.88rem;color:var(--text-secondary);margin-bottom:1rem;">
                        <i class="fa fa-exclamation-circle me-1" style="color:#fcd34d;"></i>
                        Found this item? Please contact the owner directly:
                    </p>
                    <div style="background:rgba(245,158,11,0.08);border:1px solid rgba(245,158,11,0.2);border-radius:var(--radius-md);padding:1rem;margin-bottom:1rem;">
                        <strong style="font-size:0.85rem;color:var(--text-secondary);">Contact:</strong>
                        <div style="color:var(--text-primary);font-weight:600;margin-top:0.25rem;word-break:break-all;"><%= contact %></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/lost-items" class="btn btn-outline-custom w-100">
                        <i class="fa fa-arrow-left me-2"></i>Back to Lost Items
                    </a>
                <% } %>

                <hr class="divider">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/<%= isFoundType ? "found-items" : "lost-items" %>"
                       class="btn btn-outline-custom">
                        <i class="fa fa-arrow-left me-2"></i>Back to <%= isFoundType ? "Found" : "Lost" %> Items
                    </a>
                    <% if (isLoggedIn) { %>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-custom">
                        <i class="fa fa-home me-2"></i>Dashboard
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer-custom">
    <div class="container"><p>College Lost &amp; Found Portal &nbsp;·&nbsp; &copy; <%= java.time.Year.now() %></p></div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
