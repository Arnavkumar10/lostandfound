<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — College Lost &amp; Found Portal</title>
    <meta name="description" content="Create your student account for the College Lost and Found Portal.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="${pageContext.request.contextPath}/jsp/index.jsp" class="navbar-brand">
            <span class="brand-lost">Lost</span><span class="brand-and">&amp;</span><span class="brand-found">Found</span>
        </a>
        <a href="${pageContext.request.contextPath}/login" class="nav-link-custom">
            Already have an account? <strong style="color:var(--primary-light);">Sign In</strong>
        </a>
    </div>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-xl-6">
            <div class="form-card fade-in-up">
                <!-- Header -->
                <div class="text-center mb-4">
                    <div style="width:64px;height:64px;background:rgba(99,102,241,0.15);border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:1.8rem;margin:0 auto 1rem;">
                        🎓
                    </div>
                    <h1 class="h3 fw-800 mb-1">Create Your Account</h1>
                    <p class="text-secondary-custom" style="font-size:0.9rem;">Join the campus Lost &amp; Found community</p>
                </div>

                <!-- Error / Success Messages -->
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

                <!-- Registration Form -->
                <form action="${pageContext.request.contextPath}/register" method="post" novalidate>

                    <div class="row g-3">
                        <!-- USN -->
                        <div class="col-md-6">
                            <label class="form-label-custom" for="usn">USN / Roll Number <span style="color:var(--danger);">*</span></label>
                            <input type="text" id="usn" name="usn" class="form-control form-control-custom"
                                   placeholder="e.g., 1RV20CS001" required maxlength="20"
                                   style="text-transform:uppercase;">
                        </div>
                        <!-- Full Name -->
                        <div class="col-md-6">
                            <label class="form-label-custom" for="fullName">Full Name <span style="color:var(--danger);">*</span></label>
                            <input type="text" id="fullName" name="fullName" class="form-control form-control-custom"
                                   placeholder="Your full name" required maxlength="100">
                        </div>
                        <!-- Email -->
                        <div class="col-md-6">
                            <label class="form-label-custom" for="email">Email Address <span style="color:var(--danger);">*</span></label>
                            <input type="email" id="email" name="email" class="form-control form-control-custom"
                                   placeholder="yourname@college.edu" required>
                        </div>
                        <!-- Phone -->
                        <div class="col-md-6">
                            <label class="form-label-custom" for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-control form-control-custom"
                                   placeholder="10-digit mobile number" maxlength="15">
                        </div>
                        <!-- Department -->
                        <div class="col-12">
                            <label class="form-label-custom" for="department">Department</label>
                            <select id="department" name="department" class="form-select form-select-custom">
                                <option value="">Select your department</option>
                                <option>Computer Science</option>
                                <option>Electronics</option>
                                <option>Mechanical</option>
                                <option>Civil</option>
                                <option>Information Science</option>
                                <option>Electrical</option>
                                <option>Chemical</option>
                                <option>Biotechnology</option>
                                <option>Mathematics</option>
                                <option>Physics</option>
                                <option>Management</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <!-- Password -->
                        <div class="col-md-6">
                            <label class="form-label-custom" for="password">Password <span style="color:var(--danger);">*</span></label>
                            <div style="position:relative;">
                                <input type="password" id="password" name="password" class="form-control form-control-custom"
                                       placeholder="Min. 6 characters" required minlength="6">
                                <button type="button" onclick="togglePwd('password','eyePwd')"
                                        style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--text-muted);cursor:pointer;">
                                    <i id="eyePwd" class="fa fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <!-- Confirm Password -->
                        <div class="col-md-6">
                            <label class="form-label-custom" for="confirmPassword">Confirm Password <span style="color:var(--danger);">*</span></label>
                            <div style="position:relative;">
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control form-control-custom"
                                       placeholder="Repeat password" required>
                                <button type="button" onclick="togglePwd('confirmPassword','eyeConfirm')"
                                        style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--text-muted);cursor:pointer;">
                                    <i id="eyeConfirm" class="fa fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Password strength hint -->
                        <div class="col-12">
                            <div id="pwdStrength" style="height:4px;background:var(--border-glass);border-radius:2px;overflow:hidden;">
                                <div id="pwdStrengthBar" style="height:100%;width:0;transition:width 0.3s,background 0.3s;border-radius:2px;"></div>
                            </div>
                            <p id="pwdHint" style="font-size:0.78rem;color:var(--text-muted);margin-top:4px;"></p>
                        </div>

                        <!-- Submit -->
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary-custom w-100 py-3 mt-2" style="font-size:1rem;">
                                <i class="fa fa-user-plus me-2"></i>Create Account
                            </button>
                        </div>
                    </div>
                </form>

                <div class="text-center mt-3">
                    <p class="text-secondary-custom" style="font-size:0.88rem;">
                        Already have an account?
                        <a href="${pageContext.request.contextPath}/login" style="color:var(--primary-light);font-weight:600;">Sign in here</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function togglePwd(fieldId, iconId) {
    const f = document.getElementById(fieldId);
    const i = document.getElementById(iconId);
    if (f.type === 'password') { f.type = 'text';     i.classList.replace('fa-eye','fa-eye-slash'); }
    else                       { f.type = 'password'; i.classList.replace('fa-eye-slash','fa-eye'); }
}

// Password strength meter
document.getElementById('password').addEventListener('input', function () {
    const v = this.value;
    const bar = document.getElementById('pwdStrengthBar');
    const hint = document.getElementById('pwdHint');
    let strength = 0;
    if (v.length >= 6)  strength++;
    if (v.length >= 10) strength++;
    if (/[A-Z]/.test(v)) strength++;
    if (/[0-9]/.test(v)) strength++;
    if (/[^A-Za-z0-9]/.test(v)) strength++;

    const levels = [
        { w:'20%',  bg:'#ef4444', text:'Very Weak' },
        { w:'40%',  bg:'#f97316', text:'Weak' },
        { w:'60%',  bg:'#f59e0b', text:'Fair' },
        { w:'80%',  bg:'#22c55e', text:'Strong' },
        { w:'100%', bg:'#10b981', text:'Very Strong' },
    ];
    const lv = levels[Math.min(strength - 1, 4)] || { w:'0%', bg:'transparent', text:'' };
    bar.style.width = v.length ? lv.w : '0%';
    bar.style.background = lv.bg;
    hint.textContent = v.length ? lv.text : '';
    hint.style.color = lv.bg;
});
</script>
</body>
</html>
