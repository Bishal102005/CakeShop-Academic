<%@page import="controller.AuthUtil, model.User" contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (AuthUtil.isAdminLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/view-orders");
        return;
    }

    User accountUser = AuthUtil.getLoggedInUser(request);
    if (accountUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String orderSuccess = request.getParameter("success");
    String avatarLetter = accountUser.getFullName() != null && !accountUser.getFullName().isEmpty()
            ? accountUser.getFullName().substring(0, 1).toUpperCase()
            : accountUser.getUsername().substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Account — Sweet Crumbs Bakery</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css?v=1.1">
</head>
<body data-page="home">

<div class="announcement-bar">
    <span>Artisan Pastry · Est. 2014</span>
    <span class="diamond">◆</span>
    <span>Your Sweet Crumbs Account</span>
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
            <div class="user-badge">
                <div class="user-avatar"><%= avatarLetter %></div>
                <div>
                    <div class="user-name"><%= accountUser.getFullName() %></div>
                    <div class="user-role">Customer</div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-primary"><span>Logout</span></a>
        </div>
    </div>
</header>

<main class="site-main">
    <div class="main-inner">
        <div class="content-shell">
            <nav class="site-nav">
                <a href="${pageContext.request.contextPath}/" class="nav-link"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12 12 3l9 9"/><path d="M5 10v10h14V10"/></svg><span>Home</span></a>
                <span class="nav-sep">◆</span>
                <a href="${pageContext.request.contextPath}/my-orders" class="nav-link"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="3" width="16" height="18" rx="2"/><path d="M8 8h8M8 12h8M8 16h5"/></svg><span>Order</span></a>
                <span class="nav-sep">◆</span>
                <a href="${pageContext.request.contextPath}/my-account" class="nav-link active"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/></svg><span>My Account</span></a>
                <div class="nav-greeting"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/></svg><span>Hand-crafted daily</span></div>
            </nav>

            <section class="page-section">
                <div class="page-stack">
                    <% if (orderSuccess != null && !orderSuccess.isEmpty()) { %>
                        <div style="background:#d1fae5;border:1px solid #a7f3d0;color:#065f46;padding:0.75rem 1rem;border-radius:var(--radius-lg);font-size:14px">
                            <%= orderSuccess %>
                        </div>
                    <% } %>
                    <header>
                        <div class="section-label"><span class="line"></span><span>My Account</span><span class="line"></span></div>
                        <h1 class="page-title font-display">Hello, <em><%= accountUser.getFullName() %></em></h1>
                        <p class="page-subtitle">Manage your profile details.</p>
                    </header>

                    <div class="card-grid" style="grid-template-columns:1fr">
                        <article class="cake-card" style="display:block">
                            <div class="cake-card-body">
                                <h3 class="cake-card-title font-display">Profile Details</h3>
                                <p class="cake-desc"><strong>Username:</strong> <%= accountUser.getUsername() %></p>
                                <p class="cake-desc"><strong>Email:</strong> <%= accountUser.getEmail() %></p>
                                <p class="cake-desc"><strong>Phone:</strong> <%= accountUser.getPhone() != null && !accountUser.getPhone().isEmpty() ? accountUser.getPhone() : "Not provided" %></p>
                                <div style="display:flex;gap:0.75rem;flex-wrap:wrap;margin-top:1rem">
                                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline">Continue Shopping</a>
                                    <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-primary">View My Orders</a>
                                </div>
                            </div>
                        </article>
                    </div>
                </div>
            </section>
        </div>
        <%@include file="footer.jsp" %>
    </div>
</main>

</body>
</html>
