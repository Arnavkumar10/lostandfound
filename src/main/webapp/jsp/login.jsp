<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — College Lost &amp; Found Portal</title>
    <meta name="description" content="Sign in to the College Lost and Found Portal with your USN and password.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="${pageContext.request.contextPath}/jsp/index.jsp" class="navbar-brand">
            <span class="brand-lost">Lost</span><span class="brand-and">&amp;</span><span class="brand-found">Found</span>
        </a>
        <a href="${pageContext.request.contextPath}/register" class="nav-link-custom">
            New here? <strong style="color:var(--primary-light);">Create Account</strong>
        </a>
    </div>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-5 col-xl-4">
            <div class="form-card fade-in-up">
                <!-- Header -->
                <div class="text-center mb-4">
                    <div style="width:64px;height:64px;background:rgba(99,102,241,0.15);border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:1.8rem;margin:0 auto 1rem;">
                        🔐
                    </div>
                    <h1 class="h3 fw-800 mb-1">Welcome Back!</h1>
                    <p class="text-secondary-custom" style="font-size:0.9rem;">Sign in to your portal account</p>
                </div>

                <!-- Alerts -->
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-custom alert-error-custom alert-dismissible fade show mb-4" role="alert">
                    <i class="fa fa-circle-xmark me-2"></i><%= request.getAttribute("error") %>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-custom alert-success-custom alert-dismissible fade show mb-4" role="alert">
                    <i class="fa fa-circle-check me-2"></i><%= request.getAttribute("success") %>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <!-- Login Form -->
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="mb-3">
                        <label class="form-label-custom" for="usn">USN / Roll Number</label>
                        <div style="position:relative;">
                            <i class="fa fa-id-badge" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text-muted);"></i>
                            <input type="text" id="usn" name="usn" class="form-control form-control-custom"
                                   placeholder="e.g., 1RV20CS001" required style="padding-left:2.5rem;text-transform:uppercase;">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label-custom" for="password">Password</label>
                        <div style="position:relative;">
                            <i class="fa fa-lock" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text-muted);"></i>
                            <input type="password" id="password" name="password" class="form-control form-control-custom"
                                   placeholder="Your password" required style="padding-left:2.5rem;">
                            <button type="button" onclick="togglePwd()"
                                    style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--text-muted);cursor:pointer;">
                                <i id="eyeIcon" class="fa fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary-custom w-100 py-3" id="loginBtn" style="font-size:1rem;">
                        <i class="fa fa-sign-in-alt me-2"></i>Sign In
                    </button>
                </form>

                <hr class="divider">

                <div class="text-center">
                    <p class="text-secondary-custom mb-2" style="font-size:0.88rem;">
                        Don't have an account?
                        <a href="${pageContext.request.contextPath}/register" style="color:var(--primary-light);font-weight:600;">Register now</a>
                    </p>
                    <p style="font-size:0.82rem;color:var(--text-muted);">
                        Are you an admin?
                        <a href="${pageContext.request.contextPath}/admin-login" style="color:var(--text-muted);">Admin login →</a>
                    </p>
                </div>

                <!-- Demo credentials hint -->
                <div style="background:rgba(99,102,241,0.08);border:1px solid rgba(99,102,241,0.2);border-radius:10px;padding:0.9rem;margin-top:1.25rem;">
                    <p style="font-size:0.78rem;color:var(--text-muted);margin:0;text-align:center;">
                        <i class="fa fa-info-circle me-1" style="color:var(--primary-light);"></i>
                        <strong style="color:var(--text-secondary);">Demo Student:</strong> USN: <code style="color:var(--primary-light);">1RV20CS001</code>
                        &nbsp;|&nbsp; Password: <code style="color:var(--primary-light);">student@123</code>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function togglePwd() {
    const f = document.getElementById('password');
    const i = document.getElementById('eyeIcon');
    if (f.type === 'password') { f.type = 'text'; i.classList.replace('fa-eye','fa-eye-slash'); }
    else { f.type = 'password'; i.classList.replace('fa-eye-slash','fa-eye'); }
}
// Loading spinner on submit
document.querySelector('form').addEventListener('submit', function() {
    const btn = document.getElementById('loginBtn');
    btn.innerHTML = '<i class="fa fa-spinner fa-spin me-2"></i>Signing in...';
    btn.disabled = true;
});
</script>
</body>
</html>
