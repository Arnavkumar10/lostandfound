<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Lost & Found Portal — Find What Matters</title>
    <meta name="description" content="College Lost and Found Portal — Report lost items, find what you've lost, and help return belongings to their owners.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- ══════════════════════════════════════════════════════════════
     NAVBAR
═══════════════════════════════════════════════════════════════ -->
<nav class="navbar-custom">
    <div class="container">
        <div class="d-flex align-items-center justify-content-between w-100">
            <a href="${pageContext.request.contextPath}/jsp/index.jsp" class="navbar-brand">
                <span class="brand-lost">Lost</span>
                <span class="brand-and">&amp;</span>
                <span class="brand-found">Found</span>
                <span style="color: var(--text-muted); font-size:0.7rem; font-weight:400; margin-left:6px;">PORTAL</span>
            </a>
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/lost-items" class="nav-link-custom">Lost Items</a>
                <a href="${pageContext.request.contextPath}/found-items" class="nav-link-custom">Found Items</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary-custom ms-2">Sign In</a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-sm btn-outline-custom">Register</a>
            </div>
        </div>
    </div>
</nav>

<!-- ══════════════════════════════════════════════════════════════
     HERO SECTION
═══════════════════════════════════════════════════════════════ -->
<section class="hero-section">
    <div class="container">
        <div class="fade-in-up">
            <span style="background:rgba(99,102,241,0.15);color:var(--primary-light);padding:0.35rem 1rem;border-radius:20px;font-size:0.82rem;font-weight:600;letter-spacing:0.06em;border:1px solid rgba(99,102,241,0.25);">
                🎓 COLLEGE CAMPUS PORTAL
            </span>
        </div>
        <h1 class="hero-title fade-in-up fade-in-up-delay-1 mt-3">
            Lost Something on Campus?<br>
            <span class="gradient-text">We Help You Find It.</span>
        </h1>
        <p class="hero-subtitle fade-in-up fade-in-up-delay-2">
            A community-driven platform for students and staff to report lost items,
            submit found items, and reconnect belongings with their rightful owners.
        </p>
        <div class="d-flex gap-3 justify-content-center flex-wrap fade-in-up fade-in-up-delay-3">
            <a href="${pageContext.request.contextPath}/report-lost" class="btn btn-danger-custom">
                <i class="fa fa-exclamation-triangle me-2"></i>Report Lost Item
            </a>
            <a href="${pageContext.request.contextPath}/report-found" class="btn btn-success-custom">
                <i class="fa fa-hand-holding me-2"></i>Report Found Item
            </a>
            <a href="${pageContext.request.contextPath}/lost-items" class="btn btn-outline-custom">
                <i class="fa fa-search me-2"></i>Browse All Items
            </a>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════════════════════════════
     STATS SECTION
═══════════════════════════════════════════════════════════════ -->
<section class="py-4">
    <div class="container">
        <div class="row g-3 justify-content-center">
            <div class="col-6 col-md-3">
                <div class="stat-card stat-lost text-center">
                    <div class="stat-icon mx-auto mb-2" style="background:rgba(239,68,68,0.15);">
                        <i class="fa fa-search" style="color:#ef4444;"></i>
                    </div>
                    <div class="stat-value" style="color:#fca5a5;" id="counterLost">0</div>
                    <div class="stat-label">Items Lost</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card stat-found text-center">
                    <div class="stat-icon mx-auto mb-2" style="background:rgba(16,185,129,0.15);">
                        <i class="fa fa-hand-holding" style="color:#10b981;"></i>
                    </div>
                    <div class="stat-value" style="color:#6ee7b7;" id="counterFound">0</div>
                    <div class="stat-label">Items Found</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card stat-recover text-center">
                    <div class="stat-icon mx-auto mb-2" style="background:rgba(99,102,241,0.15);">
                        <i class="fa fa-check-circle" style="color:#6366f1;"></i>
                    </div>
                    <div class="stat-value" style="color:#a5b4fc;" id="counterRecovered">0</div>
                    <div class="stat-label">Recovered</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card stat-claims text-center">
                    <div class="stat-icon mx-auto mb-2" style="background:rgba(245,158,11,0.15);">
                        <i class="fa fa-users" style="color:#f59e0b;"></i>
                    </div>
                    <div class="stat-value" style="color:#fcd34d;">500+</div>
                    <div class="stat-label">Students Helped</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════════════════════════════
     HOW IT WORKS
═══════════════════════════════════════════════════════════════ -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-800" style="font-size:2rem;">How It <span class="gradient-text">Works</span></h2>
            <p class="text-secondary-custom mt-2">Three simple steps to reunite with your belongings</p>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="glass-card text-center h-100">
                    <div style="width:64px;height:64px;background:rgba(239,68,68,0.15);border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:1.8rem;margin:0 auto 1.25rem;">
                        📝
                    </div>
                    <h4 class="fw-700 mb-2">1. Report</h4>
                    <p class="text-secondary-custom" style="font-size:0.92rem;">
                        Lost something? Submit a report with description, location, and contact details.
                        Found something? Report it so the owner can claim it.
                    </p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card text-center h-100">
                    <div style="width:64px;height:64px;background:rgba(99,102,241,0.15);border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:1.8rem;margin:0 auto 1.25rem;">
                        🔍
                    </div>
                    <h4 class="fw-700 mb-2">2. Search</h4>
                    <p class="text-secondary-custom" style="font-size:0.92rem;">
                        Browse listings, search by category or location, and filter to find matches
                        for lost items in the portal.
                    </p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card text-center h-100">
                    <div style="width:64px;height:64px;background:rgba(16,185,129,0.15);border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:1.8rem;margin:0 auto 1.25rem;">
                        🤝
                    </div>
                    <h4 class="fw-700 mb-2">3. Recover</h4>
                    <p class="text-secondary-custom" style="font-size:0.92rem;">
                        Submit a claim with proof of ownership. The finder reviews and approves it.
                        Item status updates to Recovered!
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════════════════════════════
     CTA SECTION
═══════════════════════════════════════════════════════════════ -->
<section class="py-5">
    <div class="container">
        <div class="glass-card text-center" style="padding:3rem;background:linear-gradient(135deg,rgba(99,102,241,0.1),rgba(245,158,11,0.05));border-color:rgba(99,102,241,0.2);">
            <h2 class="fw-800 mb-3" style="font-size:2rem;">Ready to Get Started?</h2>
            <p class="text-secondary-custom mb-4" style="max-width:500px;margin-inline:auto;">
                Create your account with your USN and start reporting or finding items today.
            </p>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-custom btn-lg">
                <i class="fa fa-user-plus me-2"></i>Create Free Account
            </a>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════════════════════════════
     FOOTER
═══════════════════════════════════════════════════════════════ -->
<footer class="footer-custom">
    <div class="container">
        <p>
            <strong style="color:var(--text-secondary);">College Lost &amp; Found Portal</strong>
            &nbsp;·&nbsp; Built with Java EE, JSP &amp; MySQL
            &nbsp;·&nbsp; &copy; <%= java.time.Year.now() %>
        </p>
        <p class="mt-1">
            <a href="${pageContext.request.contextPath}/admin-login" style="color:var(--text-muted);font-size:0.8rem;">Admin Panel</a>
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
// Animated counters
function animateCounter(id, target, duration) {
    const el = document.getElementById(id);
    if (!el) return;
    let start = 0;
    const step = target / (duration / 16);
    const timer = setInterval(() => {
        start = Math.min(start + step, target);
        el.textContent = Math.floor(start);
        if (start >= target) clearInterval(timer);
    }, 16);
}
window.addEventListener('load', () => {
    // These could be loaded dynamically; hardcoded for landing page demo
    animateCounter('counterLost',      12, 1200);
    animateCounter('counterFound',     9,  1000);
    animateCounter('counterRecovered', 7,  900);
});
</script>
</body>
</html>
