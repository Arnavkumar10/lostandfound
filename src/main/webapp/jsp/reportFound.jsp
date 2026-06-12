<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="com.lostfound.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Found Item — College Lost &amp; Found Portal</title>
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
            <a href="${pageContext.request.contextPath}/lost-items"  class="nav-link-custom">Lost Items</a>
            <a href="${pageContext.request.contextPath}/found-items" class="nav-link-custom">Found Items</a>
            <a href="${pageContext.request.contextPath}/logout"      class="nav-link-custom" style="color:#fca5a5;">Logout</a>
        </div>
    </div>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb" style="background:none;padding:0;font-size:0.85rem;">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" style="color:var(--text-muted);">Dashboard</a></li>
                    <li class="breadcrumb-item active" style="color:var(--text-secondary);">Report Found Item</li>
                </ol>
            </nav>

            <div class="form-card">
                <div class="mb-4">
                    <div class="d-flex align-items-center gap-3">
                        <div style="width:50px;height:50px;background:rgba(16,185,129,0.15);border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.4rem;">
                            🤝
                        </div>
                        <div>
                            <h1 class="h4 fw-800 mb-0">Report a Found Item</h1>
                            <p class="text-secondary-custom mb-0" style="font-size:0.88rem;">Help someone recover their lost belonging</p>
                        </div>
                    </div>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-custom alert-error-custom alert-dismissible fade show mb-4" role="alert">
                    <i class="fa fa-circle-xmark me-2"></i><%= request.getAttribute("error") %>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/report-found" method="post" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom" for="itemName">Item Name <span style="color:var(--danger);">*</span></label>
                            <input type="text" id="itemName" name="itemName" class="form-control form-control-custom"
                                   placeholder="e.g., Black Leather Wallet" required maxlength="100">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom" for="category">Category <span style="color:var(--danger);">*</span></label>
                            <select id="category" name="category" class="form-select form-select-custom" required>
                                <option value="">Select category</option>
                                <option>Electronics</option>
                                <option>Documents</option>
                                <option>Accessories</option>
                                <option>Stationery</option>
                                <option>Clothing</option>
                                <option>Keys</option>
                                <option>Wallet/Purse</option>
                                <option>Books</option>
                                <option>Sports Equipment</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom" for="description">Description</label>
                            <textarea id="description" name="description" class="form-control form-control-custom"
                                      rows="3" placeholder="Describe the item: color, brand, contents, any identifiable markings..."
                                      maxlength="500"></textarea>
                            <div class="text-end mt-1"><small id="descCounter" style="color:var(--text-muted);font-size:0.75rem;">0/500</small></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom" for="dateFound">Date Found <span style="color:var(--danger);">*</span></label>
                            <input type="date" id="dateFound" name="dateFound" class="form-control form-control-custom"
                                   max="<%= java.time.LocalDate.now() %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom" for="location">Where Found <span style="color:var(--danger);">*</span></label>
                            <input type="text" id="location" name="location" class="form-control form-control-custom"
                                   placeholder="e.g., Near Main Gate, Parking Lot B" required maxlength="200">
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom" for="contactInfo">Your Contact Details <span style="color:var(--danger);">*</span></label>
                            <input type="text" id="contactInfo" name="contactInfo" class="form-control form-control-custom"
                                   placeholder="Phone number or email — how owner can reach you" required maxlength="200"
                                   value="<%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "" %>">
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Item Photo (Optional)</label>
                            <div class="file-upload-area">
                                <input type="file" id="itemImage" name="itemImage" accept="image/*">
                                <div id="imagePlaceholder">
                                    <i class="fa fa-cloud-upload fa-2x mb-2" style="color:var(--text-muted);"></i>
                                    <p class="mb-1" style="color:var(--text-secondary);font-size:0.9rem;">
                                        Click or drag &amp; drop to upload an image
                                    </p>
                                    <p style="color:var(--text-muted);font-size:0.78rem;">PNG, JPG, JPEG, GIF up to 5MB</p>
                                </div>
                                <img id="imagePreview" src="" alt="Preview">
                            </div>
                        </div>

                        <!-- Note about storage -->
                        <div class="col-12">
                            <div style="background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.2);border-radius:10px;padding:0.85rem;">
                                <p style="font-size:0.82rem;color:var(--text-muted);margin:0;">
                                    <i class="fa fa-shield-alt me-1" style="color:#10b981;"></i>
                                    <strong style="color:var(--text-secondary);">Safe Handover:</strong>
                                    Keep the item in a safe place. The owner will contact you through the provided details.
                                    The admin team can also help facilitate secure handover.
                                </p>
                            </div>
                        </div>

                        <div class="col-12 d-flex gap-3 mt-2">
                            <button type="submit" class="btn btn-success-custom flex-grow-1 py-3">
                                <i class="fa fa-paper-plane me-2"></i>Submit Found Report
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-custom px-4 py-3">
                                Cancel
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
document.getElementById('dateFound').valueAsDate = new Date();
</script>
</body>
</html>
