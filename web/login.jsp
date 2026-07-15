<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sign In — Sweet Crumbs Bakery</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css?v=1.1">
</head>
<body data-page="login">

<%
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String activeTab = request.getParameter("tab");
    String activeRole = request.getParameter("role");
    if (activeTab == null || activeTab.isEmpty()) {
        activeTab = "signin";
    }
    if (activeRole == null || activeRole.isEmpty()) {
        activeRole = "user";
    }
    boolean showSignup = "signup".equals(activeTab);
    boolean showAdmin = "admin".equals(activeRole);
    String redirect = request.getParameter("redirect");
%>

<div class="announcement-bar">
    <span>Artisan Pastry · Est. 2014</span>
    <span class="diamond">◆</span>
    <span>Welcome Back</span>
</div>

<header class="site-header">
    <div class="header-inner">
        <a href="${pageContext.request.contextPath}/" class="brand-link">
            <div class="brand-logo-wrap">
                <div class="brand-logo">
                    <svg class="icon-lg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3v3"/><circle cx="12" cy="3" r="0.5" fill="currentColor"/><path d="M5 11c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v3H5v-3Z"/><path d="M3 21v-5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v5"/><path d="M3 17h18"/></svg>
                </div>
                <div class="brand-dot"></div>
            </div>
            <div>
                <div class="brand-title font-display">Sweet Crumbs</div>
                <div class="brand-subtitle">Artisan Bakery · Pastry</div>
            </div>
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline"><span>Back to Store</span></a>
        </div>
    </div>
</header>

<main class="site-main">
    <div class="main-inner">
        <div class="content-shell">
            <section class="page-section">
                <div class="login-grid" style="max-width:960px;margin:2rem auto">

                    <div class="login-panel">
                        <div class="login-brand-card">
                            <div class="badge-pill" style="margin-bottom:1rem;background:rgba(201,169,97,0.15);border:1px solid rgba(201,169,97,0.3)">
                                <span style="color:var(--gold-300)">Sweet Crumbs Club</span>
                            </div>
                            <h1 class="page-title font-display" style="color:var(--cream-50);font-size:2.25rem;margin-bottom:1rem">
                                Sign in &amp; <em style="color:var(--gold-300)">order</em>
                            </h1>
                            <p style="color:var(--chocolate-200);line-height:1.7;max-width:22rem">
                                Create an account to track orders, save your details at checkout, and enjoy a smoother bakery experience.
                            </p>
                        </div>
                    </div>

                    <div class="login-card">
                        <div class="tab-switcher">
                            <button type="button" class="tab-btn <%= !showSignup ? "active" : "" %>" id="tab-signin" data-tab="signin">Sign In</button>
                            <button type="button" class="tab-btn <%= showSignup ? "active active-signup" : "" %>" id="tab-signup" data-tab="signup">Sign Up</button>
                        </div>

                        <% if (error != null && !error.isEmpty()) { %>
                            <div style="background:#fee2e2;border:1px solid #fecaca;color:#991b1b;padding:0.75rem 1rem;border-radius:var(--radius-lg);margin:1rem 1rem 0;font-size:14px">
                                <%= error %>
                            </div>
                        <% } %>
                        <% if (success != null && !success.isEmpty()) { %>
                            <div style="background:#d1fae5;border:1px solid #a7f3d0;color:#065f46;padding:0.75rem 1rem;border-radius:var(--radius-lg);margin:1rem 1rem 0;font-size:14px">
                                <%= success %>
                            </div>
                        <% } %>

                        <form method="POST" action="${pageContext.request.contextPath}/login" class="login-form <%= showSignup ? "hidden" : "" %>" id="signin-form">
                            <% if (redirect != null && !redirect.isEmpty()) { %>
                                <input type="hidden" name="redirect" value="<%= redirect %>">
                            <% } %>
                            <div class="form-group">
                                <label class="form-label">Account Type</label>
                                <div class="role-switcher">
                                    <button type="button" class="tab-btn role-btn <%= !showAdmin ? "active" : "" %>" data-role="user">Customer</button>
                                    <button type="button" class="tab-btn role-btn <%= showAdmin ? "active active-admin" : "" %>" data-role="admin">Admin</button>
                                </div>
                                <input type="hidden" name="role" id="login-role" value="<%= showAdmin ? "admin" : "user" %>">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="signin-username">Username</label>
                                <input type="text" id="signin-username" name="username" class="form-input" placeholder="Enter your username" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="signin-password">Password</label>
                                <input type="password" id="signin-password" name="password" class="form-input" placeholder="Enter password" required>
                            </div>

                            <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;margin-top:0.5rem">
                                Sign In
                            </button>
                        </form>

                        <form method="POST" action="${pageContext.request.contextPath}/register" class="login-form <%= !showSignup ? "hidden" : "" %>" id="signup-form">
                            <div class="form-group">
                                <label class="form-label" for="full_name">Full Name *</label>
                                <input type="text" id="full_name" name="full_name" class="form-input" placeholder="e.g. Rony Das" required>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="signup-username">Username *</label>
                                    <input type="text" id="signup-username" name="username" class="form-input" placeholder="Choose a username" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="phone">Phone</label>
                                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="+91 98765...">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="email">Email *</label>
                                <input type="email" id="email" name="email" class="form-input" placeholder="you@example.com" required>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="signup-password">Password *</label>
                                    <input type="password" id="signup-password" name="password" class="form-input" placeholder="Create password" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="confirm_password">Confirm *</label>
                                    <input type="password" id="confirm_password" name="confirm_password" class="form-input" placeholder="Repeat password" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-burgundy" style="width:100%;justify-content:center;margin-top:0.5rem">
                                Create Account
                            </button>
                        </form>
                    </div>

                </div>
            </section>
        </div>
        <%@include file="footer.jsp" %>
    </div>
</main>

<script>
(function () {
    var signinForm = document.getElementById('signin-form');
    var signupForm = document.getElementById('signup-form');
    var loginRole = document.getElementById('login-role');
    var tabSignin = document.getElementById('tab-signin');
    var tabSignup = document.getElementById('tab-signup');

    function showTab(tab) {
        var isSignin = tab === 'signin';
        signinForm.classList.toggle('hidden', !isSignin);
        signupForm.classList.toggle('hidden', isSignin);
        tabSignin.classList.toggle('active', isSignin);
        tabSignup.classList.toggle('active', !isSignin);
        tabSignup.classList.toggle('active-signup', !isSignin);
    }

    tabSignin.addEventListener('click', function () { showTab('signin'); });
    tabSignup.addEventListener('click', function () { showTab('signup'); });

    document.querySelectorAll('.role-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var role = btn.getAttribute('data-role');
            loginRole.value = role;
            document.querySelectorAll('.role-btn').forEach(function (other) {
                other.classList.remove('active', 'active-admin');
            });
            btn.classList.add('active');
            if (role === 'admin') {
                btn.classList.add('active-admin');
            }
        });
    });
})();
</script>

</body>
</html>
