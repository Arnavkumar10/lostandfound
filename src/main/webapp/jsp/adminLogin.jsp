<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login — College Lost &amp; Found Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="container py-5 d-flex align-items-center justify-content-center" style="min-height:100vh;">
    <div class="col-lg-4 col-md-6 col-sm-8">
        <div class="form-card fade-in-up">
            <!-- Header -->
            <div class="text-center mb-4">
                <div style="width:64px;height:64px;background:rgba(245,158,11,0.15);border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:1.8rem;margin:0 auto 1rem;border:1px solid rgba(245,158,11,0.2);">
                    🛡️
                </div>
                <h1 class="h4 fw-800 mb-1">Admin Portal</h1>
                <p class="text-secondary-custom" style="font-size:0.85rem;">Restricted access. Authorized personnel only.</p>
            </div>

            <!-- Alerts -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-custom alert-error-custom alert-dismissible fade show mb-4" role="alert">
                <i class="fa fa-shield-xmark me-2"></i><%= request.getAttribute("error") %>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/admin-login" method="post">
                <div class="mb-3">
                    <label class="form-label-custom" for="username">Admin Username</label>
                    <div style="position:relative;">
                        <i class="fa fa-user-shield" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text-muted);"></i>
                        <input type="text" id="username" name="username" class="form-control form-control-custom"
                               placeholder="admin" required style="padding-left:2.5rem;">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label-custom" for="password">Password</label>
                    <div style="position:relative;">
                        <i class="fa fa-lock" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text-muted);"></i>
                        <input type="password" id="password" name="password" class="form-control form-control-custom"
                               placeholder="Admin password" required style="padding-left:2.5rem;">
                        <button type="button" onclick="togglePwd()"
                                style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--text-muted);cursor:pointer;">
                            <i id="eyeIcon" class="fa fa-eye"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn w-100 py-3"
                        style="background:linear-gradient(135deg,#f59e0b,#d97706);color:#000;font-weight:700;border:none;border-radius:var(--radius-md);">
                    <i class="fa fa-shield me-2"></i>Access Admin Panel
                </button>
            </form>

            <hr class="divider">

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/login" style="font-size:0.85rem;color:var(--text-muted);">
                    <i class="fa fa-arrow-left me-1"></i>Back to Student Login
                </a>
            </div>

            <!-- Demo hint -->
            <div style="background:rgba(245,158,11,0.08);border:1px solid rgba(245,158,11,0.2);border-radius:10px;padding:0.9rem;margin-top:1.25rem;">
                <p style="font-size:0.78rem;color:var(--text-muted);margin:0;text-align:center;">
                    <i class="fa fa-info-circle me-1" style="color:#f59e0b;"></i>
                    <strong style="color:var(--text-secondary);">Demo Admin:</strong>
                    Username: <code style="color:#f59e0b;">admin</code> &nbsp;|&nbsp; Password: <code style="color:#f59e0b;">admin@123</code>
                </p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function togglePwd() {
    const f = document.getElementById('password');
    const i = document.getElementById('eyeIcon');
    if (f.type === 'password') { f.type = 'text'; i.classList.replace('fa-eye','fa-eye-slash'); }
    else { f.type = 'password'; i.classList.replace('fa-eye-slash','fa-eye'); }
}
</script>
</body>
</html>
