<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CakeShop - Admin Orders</title>
   <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css?v=1.1">
  </head>
  <body data-page="admin">
    <div class="announcement-bar"><span>Artisan Pastry · Est. 2014</span><span class="diamond">◆</span><span>Free Delivery on Orders over ₹1500</span></div>
    <header class="site-header">
      <div class="header-inner">
        <a href="index.html" class="brand-link"><div class="brand-logo-wrap"><div class="brand-logo"><svg class="icon-lg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3v3"/><circle cx="12" cy="3" r="0.5" fill="currentColor"/><path d="M5 11c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v3H5v-3Z"/><path d="M3 21v-5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v5"/><path d="M3 17h18"/></svg></div><div class="brand-dot"></div></div><div><div class="brand-title font-display">Sweet Crumbs</div><div class="brand-subtitle">Artisan Bakery · Pastry</div></div></a>
        <div class="header-info"><div class="header-info-item"><div class="header-info-label">Open Today</div><div class="header-info-value">8 AM – 9 PM</div></div><div class="header-divider"></div><div class="header-info-item"><div class="header-info-label">Call Us</div><div class="header-info-value">+91 98765 43210</div></div></div>
        <div class="header-actions"><a href="${pageContext.request.contextPath}/admin" class="brand-link"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><path d="m10 17 5-5-5-5"/><path d="M15 12H3"/></svg><span>Sign In</span></a></div>
      </div>
    </header>

    <main class="site-main">
      <div class="main-inner">
        <div class="content-shell">
          <nav class="site-nav">
            <<a href="${pageContext.request.contextPath}/index.jsp">>Home</a>
            <span class="nav-sep">◆</span>
            <a href="products.html" class="nav-link">Our Cakes</a>
            <span class="nav-sep">◆</span>
            <a href="${pageContext.request.contextPath}/view-orders">Order</a>
            <div class="nav-greeting"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/></svg><span>Hand-crafted daily</span></div>
          </nav>

          <section class="page-section" id="page-content">
            <div class="page-stack">
              <header>
                <div class="section-label"><span class="line"></span><span>Administrator</span><span class="line"></span></div>
                <h1 class="page-title font-display">Customer Orders</h1>
                <p class="page-subtitle">Review recent orders and delivery dates.</p>
              </header>

              <%-- DEBUG SECTION: show DB/servlet error if present --%>
              <% if (request.getAttribute("errorMessage") != null) { %>
                <div style="color: red; padding: 20px; border: 1px solid red; margin-bottom: 20px;">
                    <h3>Database Error Detected:</h3>
                    <p><%= request.getAttribute("errorMessage") %></p>
                </div>
              <% } %>

              <div class="table-card">
                <div class="table-header">
                  <div style="display:flex;align-items:center;gap:0.75rem">
                    <div class="stat-icon" style="background:var(--burgundy-600);color:var(--cream-50);width:2.5rem;height:2.5rem">📝</div>
                    <div><div class="font-display" style="font-size:1.25rem;font-weight:700">Customer Orders</div><div class="text-xs text-muted">Latest orders from the site</div></div>
                  </div>
                  <div class="live-badge">📡 orders</div>
                </div>

                <div class="data-table-wrap">
                  <table class="data-table">
                    <thead>
                      <tr>
                        <th>Cake Name</th>
                        <th>Price</th>
                        <th>Customer Name</th>
                        <th>Phone</th>
                        <th>Delivery Date</th>
                      </tr>
                    </thead>
                    <tbody>
                      <%
                        Object dataObj = request.getAttribute("ordersData");
                        if (dataObj instanceof List) {
                            List<?> ordersList = (List<?>) dataObj;
                            if (ordersList.isEmpty()) {
                      %>
                              <tr><td colspan="5">No active orders found.</td></tr>
                      <%
                            } else {
                                for (Object item : ordersList) {
                                    Map<?, ?> row = (Map<?, ?>) item;
                      %>
                                  <tr>
                                    <td><%= row.get("cakeName") %></td>
                                    <td>₹<%= row.get("cakePrice") %></td>
                                    <td><%= row.get("customerName") %></td>
                                    <td><%= row.get("customerPhone") %></td>
                                    <td><%= row.get("deliveryDate") %></td>
                                  </tr>
                      <%
                                }
                            }
                        } else if (request.getAttribute("errorMessage") == null) {
                      %>
                          <tr><td colspan="5">Please access this page via the View Orders link.</td></tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              </div>

              <div class="ornament">◆</div>
              <p class="text-xs text-muted" style="text-align:center;font-style:italic;max-width:36rem;margin:0 auto">This JSP uses `ordersData` request attribute (List&lt;Map&gt;) provided by the servlet.</p>
            </div>
          </section>

        </div>
        <%@include file="footer.jsp" %>
      </div>
    </main>
  </body>
</html>