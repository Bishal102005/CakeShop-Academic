<%@page import="controller.AuthUtil, model.User, controller.OrderDao, java.util.List, java.util.Map" contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (AuthUtil.isAdminLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/view-orders");
        return;
    }

    User currentUser = AuthUtil.getLoggedInUser(request);
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?error=Please+sign+in+to+view+your+orders");
        return;
    }

    List<Map<String, Object>> orders = (List<Map<String, Object>>) request.getAttribute("userOrders");
    String orderSuccess = request.getParameter("success");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String avatarLetter = currentUser.getFullName() != null && !currentUser.getFullName().isEmpty()
            ? currentUser.getFullName().substring(0, 1).toUpperCase()
            : currentUser.getUsername().substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Orders — Sweet Crumbs Bakery</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css?v=1.1">
</head>
<body data-page="home">

<div class="announcement-bar">
    <span>Artisan Pastry · Est. 2014</span>
    <span class="diamond">◆</span>
    <span>Your Order History</span>
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
                    <div class="user-name"><%= currentUser.getFullName() %></div>
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
                <a href="${pageContext.request.contextPath}/my-orders" class="nav-link active"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="3" width="16" height="18" rx="2"/><path d="M8 8h8M8 12h8M8 16h5"/></svg><span>Order</span></a>
                <span class="nav-sep">◆</span>
                <a href="${pageContext.request.contextPath}/my-account" class="nav-link"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/></svg><span>My Account</span></a>
                <div class="nav-greeting"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/></svg><span>Hand-crafted daily</span></div>
            </nav>

            <section class="page-section">
                <div class="page-stack">
                    <% if (orderSuccess != null && !orderSuccess.isEmpty()) { %>
                        <div style="background:#d1fae5;border:1px solid #a7f3d0;color:#065f46;padding:0.75rem 1rem;border-radius:var(--radius-lg);font-size:14px">
                            <%= orderSuccess %>
                        </div>
                    <% } %>
                    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                        <div style="background:#fee2e2;border:1px solid #fecaca;color:#991b1b;padding:0.75rem 1rem;border-radius:var(--radius-lg);font-size:14px">
                            <%= errorMessage %>
                        </div>
                    <% } %>

                    <header>
                        <div class="section-label"><span class="line"></span><span>Order History</span><span class="line"></span></div>
                        <h1 class="page-title font-display">My <em>Orders</em></h1>
                        <p class="page-subtitle">All cakes you have ordered from Sweet Crumbs.</p>
                    </header>

                    <% if (orders == null || orders.isEmpty()) { %>
                        <div class="empty-state">
                            <p class="text-muted">You have not placed any orders yet.</p>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-primary" style="margin-top:1rem">Browse Cakes</a>
                        </div>
                    <% } else { %>
                        <div class="table-card">
                            <div class="desktop-table data-table-wrap">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Order #</th>
                                            <th>Cake</th>
                                            <th>Price</th>
                                            <th>Delivery Date</th>
                                            <th>Address</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Map<String, Object> order : orders) {
                                            String orderStatus = OrderDao.normalizeStatus(String.valueOf(order.get("status")));
                                            String statusClass = OrderDao.statusCssClass(orderStatus);
                                        %>
                                            <tr>
                                                <td>#<%= order.get("id") %></td>
                                                <td><%= order.get("cakeName") %></td>
                                                <td>₹<%= (int) Math.round((Double) order.get("cakePrice")) %></td>
                                                <td><%= order.get("deliveryDate") %></td>
                                                <td><%= order.get("customerAddress") %></td>
                                                <td><span class="status-badge <%= statusClass %>"><%= orderStatus %></span></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <div class="mobile-orders">
                                <% for (Map<String, Object> order : orders) {
                                    String orderStatus = OrderDao.normalizeStatus(String.valueOf(order.get("status")));
                                    String statusClass = OrderDao.statusCssClass(orderStatus);
                                %>
                                    <div class="mobile-order-item">
                                        <div class="mobile-order-row"><strong>Order #</strong> <span>#<%= order.get("id") %></span></div>
                                        <div class="mobile-order-row"><strong>Cake</strong> <span><%= order.get("cakeName") %></span></div>
                                        <div class="mobile-order-row"><strong>Price</strong> <span>₹<%= (int) Math.round((Double) order.get("cakePrice")) %></span></div>
                                        <div class="mobile-order-row"><strong>Delivery</strong> <span><%= order.get("deliveryDate") %></span></div>
                                        <div class="mobile-order-row"><strong>Address</strong> <span><%= order.get("customerAddress") %></span></div>
                                        <div class="mobile-order-row"><strong>Status</strong> <span class="status-badge <%= statusClass %>"><%= orderStatus %></span></div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            </section>
        </div>
        <%@include file="footer.jsp" %>
    </div>
</main>

</body>
</html>
