<%@page import="java.util.List,java.util.Map,controller.AuthUtil,controller.OrderDao" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Dashboard — Sweet Crumbs Bakery</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css?v=1.1">
  <style>

    /* ─────────────────────────────────────
       ADD CAKE CARD
    ───────────────────────────────────── */
    .add-cake-card {
      max-width: 680px;
      margin: 2rem auto;
      background: white;
      border: 1px solid var(--chocolate-100);
      border-radius: var(--radius-xl);
      overflow: hidden;
      box-shadow: var(--shadow-sm);
    }

    /* Header */
    .ack-header {
      background: var(--chocolate-900);
      padding: 1.75rem 2rem;
      display: flex;
      align-items: center;
      gap: 1rem;
      position: relative;
      overflow: hidden;
    }
    .ack-header::before {
      content: "";
      position: absolute;
      top: -3rem;
      right: -3rem;
      width: 9rem;
      height: 9rem;
      border-radius: 50%;
      background: rgba(201, 169, 97, 0.12);
    }
    .ack-header::after {
      content: "";
      position: absolute;
      bottom: -2rem;
      left: 40%;
      width: 6rem;
      height: 6rem;
      border-radius: 50%;
      background: rgba(201, 169, 97, 0.06);
    }
    .ack-header-icon {
      width: 3rem;
      height: 3rem;
      border-radius: 50%;
      background: rgba(201, 169, 97, 0.15);
      border: 1px solid rgba(201, 169, 97, 0.3);
      display: grid;
      place-items: center;
      flex-shrink: 0;
      font-size: 1.25rem;
      position: relative;
    }
    .ack-header-label {
      font-size: 10px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.3em;
      color: var(--gold-400);
      margin-bottom: 0.25rem;
    }
    .ack-header-title {
      font-family: "Playfair Display", Georgia, serif;
      font-size: 1.35rem;
      font-weight: 700;
      color: var(--cream-50);
      line-height: 1.2;
    }
    .ack-header-title em {
      font-style: italic;
      font-weight: 400;
      color: var(--gold-300);
    }

    /* Body */
    .ack-body {
      padding: 2rem;
    }

    /* Preview bar */
    .ack-preview {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      padding: 0.8rem 1rem;
      border-radius: var(--radius-lg);
      background: var(--cream-50);
      border: 1px solid var(--chocolate-100);
      margin-bottom: 1.75rem;
      min-height: 3rem;
      transition: background 0.3s, border-color 0.3s;
    }
    .ack-preview.active {
      background: var(--chocolate-900);
      border-color: var(--chocolate-900);
    }
    .ack-preview-dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: var(--chocolate-200);
      flex-shrink: 0;
      transition: background 0.3s;
    }
    .ack-preview.active .ack-preview-dot {
      background: var(--gold-400);
    }
    .ack-preview-name {
      font-family: "Playfair Display", Georgia, serif;
      font-size: 1rem;
      font-weight: 700;
      flex: 1;
      transition: color 0.3s;
    }
    .ack-preview.active .ack-preview-name {
      color: var(--cream-50) !important;
      font-style: normal !important;
    }
    .ack-preview-num {
      font-size: 10px;
      font-style: italic;
      padding: 0.2rem 0.6rem;
      border-radius: 9999px;
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.15);
      color: var(--gold-300);
      flex-shrink: 0;
    }
    .ack-preview-price {
      font-family: "Playfair Display", Georgia, serif;
      font-weight: 700;
      color: var(--gold-400);
      font-size: 0.95rem;
      flex-shrink: 0;
    }

    /* Section divider */
    .ack-section-label {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      font-size: 9px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.25em;
      color: var(--gold-600);
      margin: 1.75rem 0 1.25rem;
    }
    .ack-section-label::before,
    .ack-section-label::after {
      content: "";
      flex: 1;
      height: 1px;
      background: var(--chocolate-100);
    }

    /* Grid rows */
    .ack-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
    }
    @media (max-width: 520px) {
      .ack-row { grid-template-columns: 1fr; }
    }

    /* Form group */
    .ack-group {
      display: flex;
      flex-direction: column;
      margin-bottom: 1.25rem;
    }

    /* Label */
    .ack-label {
      font-size: 10px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.2em;
      color: var(--chocolate-500);
      margin-bottom: 0.4rem;
      display: flex;
      align-items: center;
      gap: 0.3rem;
    }
    .ack-req { color: var(--burgundy-500); }

    /* Hint text */
    .ack-hint {
      font-size: 10px;
      color: var(--chocolate-400);
      margin-top: 0.3rem;
      font-style: italic;
    }

    /* Inputs */
    .ack-input,
    .ack-textarea,
    .ack-select {
      width: 100%;
      padding: 0.7rem 1rem;
      background: var(--cream-50);
      border: 1px solid var(--chocolate-100);
      border-radius: var(--radius-lg);
      color: var(--chocolate-900);
      font-family: "Inter", sans-serif;
      font-size: 0.875rem;
      outline: none;
      transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
    }
    .ack-input:focus,
    .ack-textarea:focus,
    .ack-select:focus {
      background: white;
      border-color: var(--chocolate-900);
      box-shadow: 0 0 0 3px rgba(26, 15, 8, 0.06);
    }
    .ack-textarea {
      resize: vertical;
      min-height: 90px;
      line-height: 1.6;
    }

    /* Tag pills */
    .ack-tag-pills {
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
      margin-top: 0.5rem;
    }
    .ack-tag-pill {
      padding: 0.3rem 0.875rem;
      border-radius: 9999px;
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 0.05em;
      border: 1px solid var(--chocolate-100);
      cursor: pointer;
      background: var(--cream-100);
      color: var(--chocolate-600);
      transition: all 0.15s;
      user-select: none;
    }
    .ack-tag-pill:hover {
      border-color: var(--chocolate-400);
      color: var(--chocolate-900);
    }
    /* Selected states */
    .ack-tag-pill.selected {
      background: var(--chocolate-900);
      color: var(--gold-300);
      border-color: var(--chocolate-900);
    }
    .ack-tag-pill.ack-tag-bestseller.selected {
      background: var(--burgundy-600);
      color: var(--cream-50);
      border-color: var(--burgundy-600);
    }
    .ack-tag-pill.ack-tag-new.selected {
      background: #059669;
      color: white;
      border-color: #059669;
    }
    .ack-tag-pill.ack-tag-limited.selected {
      background: var(--gold-500);
      color: var(--chocolate-900);
      border-color: var(--gold-500);
    }
    .ack-tag-pill.ack-tag-seasonal.selected {
      background: #0284c7;
      color: white;
      border-color: #0284c7;
    }

    /* Ornament divider */
    .ack-ornament {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      color: var(--gold-500);
      margin: 1.5rem 0;
    }
    .ack-ornament::before,
    .ack-ornament::after {
      content: "";
      flex: 1;
      height: 1px;
      background: linear-gradient(90deg, transparent, var(--gold-400), transparent);
    }

    /* Submit button */
    .ack-submit {
      width: 100%;
      padding: 0.9rem 2rem;
      background: var(--chocolate-900);
      color: var(--cream-50);
      border: none;
      border-radius: 9999px;
      font-family: "Inter", sans-serif;
      font-size: 14px;
      font-weight: 600;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.75rem;
      transition: background 0.2s, box-shadow 0.2s, transform 0.1s;
    }
    .ack-submit:hover {
      background: var(--chocolate-800);
      box-shadow: var(--shadow-md);
    }
    .ack-submit:active {
      transform: scale(0.99);
    }
    .ack-submit-icon {
      width: 1.75rem;
      height: 1.75rem;
      border-radius: 50%;
      background: rgba(201, 169, 97, 0.2);
      display: grid;
      place-items: center;
      color: var(--gold-400);
      font-size: 0.9rem;
      flex-shrink: 0;
    }

    /* Alert banners */
    .ack-alert {
      display: flex;
      align-items: center;
      gap: 0.6rem;
      padding: 0.8rem 1rem;
      border-radius: var(--radius-lg);
      font-size: 0.875rem;
      margin-bottom: 1.5rem;
    }
    .ack-alert-success {
      background: #ecfdf5;
      border: 1px solid #a7f3d0;
      color: #065f46;
    }
    .ack-alert-error {
      background: var(--burgundy-50);
      border: 1px solid var(--burgundy-100);
      color: var(--burgundy-600);
    }

    /* Administrative Navigation Header Workspace */
    .ack-workspace-nav {
      background: var(--cream-50); 
      padding: 14px 18px; 
      border-radius: var(--radius-lg); 
      border: 1px solid var(--chocolate-100); 
      margin-bottom: 1.75rem; 
      display: flex; 
      justify-content: space-between; 
      align-items: center;
      font-family: 'Inter', sans-serif;
    }
    .ack-workspace-title {
      color: var(--chocolate-500); 
      font-size: 0.85rem; 
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.1em;
    }
    .ack-workspace-btn {
      background: var(--chocolate-900); 
      color: var(--gold-300) !important; 
      text-decoration: none; 
      padding: 8px 16px; 
      border-radius: var(--radius-md); 
      font-size: 0.8rem; 
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      border: 1px solid var(--chocolate-900);
      transition: all 0.2s;
    }
    .ack-workspace-btn:hover {
      background: var(--chocolate-800);
      color: var(--cream-50) !important;
    }

  </style>
</head>
<body data-page="admin">

<%
  String success = request.getParameter("success");
  String error = request.getParameter("error");
  String adminName = AuthUtil.getLoggedInAdmin(request);
  if (adminName == null) adminName = "admin";
  int orderCount = 0;
  Object ordersObj = request.getAttribute("ordersData");
  if (ordersObj instanceof List) {
      orderCount = ((List) ordersObj).size();
  }
  boolean hasCustomerOrders = orderCount > 0;
%>

<div class="announcement-bar"><span>Artisan Pastry · Est. 2014</span><span class="diamond">◆</span><span>Free Delivery on Orders over ₹1500</span></div>
<header class="site-header">
  <div class="header-inner">
    <a href="${pageContext.request.contextPath}/" class="brand-link">
      <div class="brand-logo-wrap"><div class="brand-logo"><svg class="icon-lg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3v3"/><circle cx="12" cy="3" r="0.5" fill="currentColor"/><path d="M5 11c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v3H5v-3Z"/><path d="M3 21v-5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v5"/><path d="M3 17h18"/></svg></div><div class="brand-dot"></div></div>
      <div><div class="brand-title font-display">Sweet Crumbs</div><div class="brand-subtitle">Artisan Bakery · Pastry</div></div>
    </a>
    <div class="header-info"><div class="header-info-item"><div class="header-info-label">Open Today</div><div class="header-info-value">8 AM – 9 PM</div></div><div class="header-divider"></div><div class="header-info-item"><div class="header-info-label">Call Us</div><div class="header-info-value">+91 98765 43210</div></div></div>
    <div class="header-actions">
      <div class="user-badge">
        <div class="user-avatar"><%= adminName != null ? adminName.substring(0, 1).toUpperCase() : "A" %></div>
        <div>
          <div class="user-name"><%= adminName != null ? adminName : "Admin" %></div>
          <div class="user-role">Administrator</div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-primary"><span>Logout</span></a>
    </div>
  </div>
</header>
<main class="site-main">
  <div class="main-inner">
    <div class="content-shell">
      <nav class="site-nav"><a href="${pageContext.request.contextPath}/" class="nav-link"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12 12 3l9 9"/><path d="M5 10v10h14V10"/></svg><span>Store</span></a><span class="nav-sep">◆</span><a href="${pageContext.request.contextPath}/view-orders" class="nav-link active"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="3" width="16" height="18" rx="2"/><path d="M8 8h8M8 12h8M8 16h5"/></svg><span>Dashboard</span></a><div class="nav-greeting"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/></svg><span>Administrator</span></div></nav>
      <section class="page-section" id="page-content">
        <div class="page-stack" style="gap:2rem">
          <% if (success != null && !success.isEmpty()) { %>
            <div style="background:#d1fae5;border:1px solid #a7f3d0;color:#065f46;padding:0.75rem 1rem;border-radius:var(--radius-lg);font-size:14px"><%= success %></div>
          <% } %>
          <% if (error != null && !error.isEmpty()) { %>
            <div style="background:#fee2e2;border:1px solid #fecaca;color:#991b1b;padding:0.75rem 1rem;border-radius:var(--radius-lg);font-size:14px"><%= error %></div>
          <% } %>
          <header>
            <div class="section-label"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3v3"/><circle cx="12" cy="3" r="0.5" fill="currentColor"/><path d="M5 11c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v3H5v-3Z"/><path d="M3 21v-5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v5"/><path d="M3 17h18"/></svg><span class="line"></span><span>Administrator</span><span class="line"></span></div>
            <h1 class="page-title font-display" style="font-size:clamp(1.75rem,4vw,3rem)">Welcome, <em><%= adminName %></em></h1>
            <p class="page-subtitle" style="margin-left:0">Manage customer orders and the cake menu.</p>
          </header>
          <section class="stats-grid">
            <div class="stat-card"><div class="stat-icon" style="background:var(--chocolate-900);color:var(--gold-400);">🛒</div><div class="price-label" style="margin-top:1rem">Active Orders</div><div class="metric-value font-display"><%= request.getAttribute("statActiveOrders") != null ? request.getAttribute("statActiveOrders") : 0 %></div><div class="text-xs text-muted">Awaiting fulfillment</div></div>
            <div class="stat-card"><div class="stat-icon" style="background:#059669;color:white">❤️</div><div class="price-label" style="margin-top:1rem">Delivered</div><div class="metric-value font-display"><%= request.getAttribute("statDelivered") != null ? request.getAttribute("statDelivered") : 0 %></div><div class="text-xs text-muted">Successfully shipped</div></div>
            <div class="stat-card"><div class="stat-icon" style="background:var(--burgundy-600);color:var(--cream-50)">📈</div><div class="price-label" style="margin-top:1rem">Revenue</div><div class="metric-value font-display">₹<%= request.getAttribute("statRevenue") != null ? String.format("%.2f", request.getAttribute("statRevenue") ) : "0.00" %></div><div class="text-xs text-muted">From completed orders</div></div>
            <div class="stat-card"><div class="stat-icon" style="background:var(--gold-500);color:var(--chocolate-900)">🎂</div><div class="price-label" style="margin-top:1rem">On Menu</div><div class="metric-value font-display"><%= request.getAttribute("statOnMenu") != null ? request.getAttribute("statOnMenu") : 0 %></div><div class="text-xs text-muted">Signature cakes</div></div>
          </section>
          <div class="admin-tabs">
            <button type="button" class="admin-tab <%= hasCustomerOrders ? "active" : "" %>" data-tab="orders">📝 Customer Orders <span class="tab-count"><%= orderCount %></span></button>
            <button type="button" class="admin-tab <%= !hasCustomerOrders ? "active" : "" %>" data-tab="cakes">🎂 Manage Cakes <span class="tab-count"><%= request.getAttribute("statOnMenu") != null ? request.getAttribute("statOnMenu") : 0 %></span></button>
          </div>
          <section>
            <div class="tab-panel" id="orders-panel" style="display:<%= hasCustomerOrders ? "block" : "none" %>;">
              <div class="table-card">
                <div class="table-header">
                  <div style="display:flex;align-items:center;gap:0.75rem"><div class="stat-icon" style="background:var(--burgundy-600);color:var(--cream-50);width:2.5rem;height:2.5rem">📝</div><div><div class="font-display" style="font-size:1.5rem;font-weight:700">All Orders</div><div class="text-xs text-muted">Change the status pill to update</div></div></div>
                  <div class="live-badge" style="margin:0">📡 sweetcrumbs.orders</div>
                </div>
                <div class="desktop-table data-table-wrap">
                  <table class="data-table">
                    <thead><tr><th>Order</th><th>Customer</th><th>Mobile</th><th>Address</th><th>Cake</th><th>Qty</th><th>Payment</th><th>Placed</th><th>Status</th></tr></thead>
                    <tbody>
                      <%
                        Object dataObj = request.getAttribute("ordersData");
                        List<?> ordersList = null;
                        if (dataObj instanceof List) {
                            ordersList = (List<?>) dataObj;
                        }

                        if (ordersList == null || ordersList.isEmpty()) {
                      %>
                              <tr><td colspan="9">No customer orders yet. Orders placed by customers will appear here.</td></tr>
                      <%
                        } else {
                            for (Object item : ordersList) {
                                Map<?, ?> row = (Map<?, ?>) item;
                                String currentStatus = OrderDao.normalizeStatus(String.valueOf(row.get("status")));
                                String statusClass = OrderDao.statusCssClass(currentStatus);
                      %>
                                  <tr>
                                    <td style="font-weight:700;color:var(--chocolate-900)"><%= row.get("id") %></td>
                                    <td><div class="font-display" style="font-weight:700"><%= row.get("customerName") %></div></td>
                                    <td class="text-xs text-muted"><%= row.get("customerPhone") %></td>
                                    <td class="text-xs text-muted"><%= row.get("customerAddress") %></td>
                                    <td><%= row.get("cakeName") %></td>
                                    <td><%= row.get("qty") != null ? row.get("qty") : 1 %></td>
                                    <td><span class="status-badge payment-paid">₹<%= row.get("cakePrice") %></span></td>
                                    <td class="text-xs text-muted"><%= row.get("deliveryDate") %></td>
                                    <td>
                                      <form method="POST" action="${pageContext.request.contextPath}/update-order-status" style="margin:0">
                                        <input type="hidden" name="order_id" value="<%= row.get("id") %>">
                                        <select name="status" class="status-badge <%= statusClass %>" onchange="this.form.submit()" style="cursor:pointer">
                                          <% for (String opt : OrderDao.VALID_STATUSES) { %>
                                            <option value="<%= opt %>" <%= opt.equals(currentStatus) ? "selected" : "" %>><%= opt %></option>
                                          <% } %>
                                        </select>
                                      </form>
                                    </td>
                                  </tr>
                      <%
                            }
                        }
                      %>
                    </tbody>
                  </table>
                </div>
                <div class="mobile-orders">
                  <%
                    if (ordersList != null && !ordersList.isEmpty()) {
                        for (Object item : ordersList) {
                            Map<?, ?> row = (Map<?, ?>) item;
                            String currentStatus = OrderDao.normalizeStatus(String.valueOf(row.get("status")));
                            String statusClass = OrderDao.statusCssClass(currentStatus);
                  %>
                          <div class="mobile-order-item">
                            <div class="mobile-order-row"><strong>Order</strong><span>#<%= row.get("id") %></span></div>
                            <div class="mobile-order-row"><strong>Customer</strong><span><%= row.get("customerName") %></span></div>
                            <div class="mobile-order-row"><strong>Mobile</strong><span><%= row.get("customerPhone") %></span></div>
                            <div class="mobile-order-row"><strong>Address</strong><span><%= row.get("customerAddress") %></span></div>
                            <div class="mobile-order-row"><strong>Cake</strong><span><%= row.get("cakeName") %></span></div>
                            <div class="mobile-order-row"><strong>Qty</strong><span><%= row.get("qty") != null ? row.get("qty") : 1 %></span></div>
                            <div class="mobile-order-row"><strong>Payment</strong><span>₹<%= row.get("cakePrice") %></span></div>
                            <div class="mobile-order-row"><strong>Placed</strong><span><%= row.get("deliveryDate") %></span></div>
                            <div class="mobile-order-row">
                              <strong>Status</strong>
                              <span>
                                <form method="POST" action="${pageContext.request.contextPath}/update-order-status" style="margin:0">
                                  <input type="hidden" name="order_id" value="<%= row.get("id") %>">
                                  <select name="status" class="status-badge <%= statusClass %>" onchange="this.form.submit()" style="cursor:pointer; font-family:inherit;">
                                    <% for (String opt : OrderDao.VALID_STATUSES) { %>
                                      <option value="<%= opt %>" <%= opt.equals(currentStatus) ? "selected" : "" %>><%= opt %></option>
                                    <% } %>
                                  </select>
                                </form>
                              </span>
                            </div>
                          </div>
                  <%
                        }
                    }
                  %>
                </div>
              </div>
            </div>
            <div class="tab-panel" id="cakes-panel" style='display:<%= hasCustomerOrders ? "none" : "block" %>;'>
              <div class="table-card">
                <div class="data-table-wrap" style="padding:1.5rem;">
                  <div class="ack-body" style="background:transparent;border:none;padding:0;box-shadow:none;">
  <div class="ack-header">
    <div class="ack-header-icon">🎂</div>
    <div>
      <div class="ack-header-label">Administrator · Menu</div>
      <div class="ack-header-title">Add New Cake to <em>Menu</em></div>
    </div>
  </div>

  <div class="ack-body">

  

    <% if (success != null && !success.isEmpty()) { %>
      <div class="ack-alert ack-alert-success">✔ <%= success %></div>
    <% } %>

    <% if (error != null && !error.isEmpty()) { %>
      <div class="ack-alert ack-alert-error">❌ <%= error %></div>
    <% } %>

    <div class="ack-preview" id="previewBar">
      <div class="ack-preview-dot"></div>
      <span class="ack-preview-name" id="previewName"
            style="color:var(--chocolate-400);font-style:italic">
        Cake name will appear here…
      </span>
    </div>

    <form method="POST" action="${pageContext.request.contextPath}/admin" enctype="multipart/form-data" id="addCakeForm">
      <input type="hidden" name="action" value="addCake">
      <input type="hidden" name="tag"    id="tagHidden" value="">
      <input type="hidden" name="cloudinary_url" id="cloudinaryUrl" value="">

      <div class="ack-section-label">◆ Identity</div>

      <div class="ack-group">
        <label class="ack-label">
          Cake Name <span class="ack-req">*</span>
        </label>
        <input class="ack-input" type="text" name="name" id="inpName"
               placeholder="e.g. Belgian Chocolate Cake"
               maxlength="100" required>
      </div>

      <div class="ack-row">
        <div class="ack-group">
          <label class="ack-label">
            Catalogue N° <span class="ack-req">*</span>
          </label>
          <input class="ack-input" type="text" name="number" id="inpNum"
                 placeholder="e.g. 04" maxlength="5" required>
          <span class="ack-hint">Displayed as N°04 on the cake card</span>
        </div>
        <div class="ack-group">
          <label class="ack-label">
            Flavour <span class="ack-req">*</span>
          </label>
          <input class="ack-input" type="text" name="code"
                 placeholder="e.g. LEMON" maxlength="10" required>
          <span class="ack-hint">Auto-uppercased on card corner</span>
        </div>
      </div>

      <div class="ack-section-label">◆ Pricing &amp; Rating</div>

      <div class="ack-row">
        <div class="ack-group">
          <label class="ack-label">
            Base Price (₹) <span class="ack-req">*</span>
          </label>
          <input class="ack-input" type="number" name="price" id="inpPrice"
                 placeholder="850" min="1" step="0.01" required>
        </div>
        <div class="ack-group">
          <label class="ack-label">
            Rating (1–5) <span class="ack-req">*</span>
          </label>
          <input class="ack-input" type="number" name="rating"
                 placeholder="4.8" min="1" max="5" step="0.1" required>
        </div>
      </div>

      <div class="ack-section-label">◆ Presentation</div>

      <div class="ack-group">
        <label class="ack-label">Badge / Tag</label>
        <div class="ack-tag-pills">
          <span class="ack-tag-pill ack-tag-none selected"
                onclick="selectTag(this,'')">— None —</span>
          <span class="ack-tag-pill ack-tag-bestseller"
                onclick="selectTag(this,'Bestseller')">★ Bestseller</span>
          <span class="ack-tag-pill ack-tag-new"
                onclick="selectTag(this,'New')">✦ New</span>
          <span class="ack-tag-pill ack-tag-limited"
                onclick="selectTag(this,'Limited')">◈ Limited</span>
          <span class="ack-tag-pill ack-tag-seasonal"
                onclick="selectTag(this,'Seasonal')">❄ Seasonal</span>
        </div>
      </div>

      <div class="ack-group">
        <label class="ack-label">Cake Image <span class="ack-req">*</span></label>
        <input class="ack-input" type="file" name="image_file" accept="image/*" required />
        <span class="ack-hint">Choose an image from your device</span>
      </div>

      <div class="ack-section-label">◆ Description &amp; Ingredients</div>

      <div class="ack-group">
        <label class="ack-label">
          Description <span class="ack-req">*</span>
        </label>
        <textarea class="ack-textarea" name="description"
                  placeholder="Write a short, enticing description of the cake…"
                  required></textarea>
      </div>

      <div class="ack-group">
        <label class="ack-label">Key Ingredients</label>
        <input class="ack-input" type="text" name="ingredients"
               placeholder="Lemon zest, Butter cream, Edible flowers">
        <span class="ack-hint">Comma-separated — rendered as tags on the cake card</span>
      </div>

      <div class="ack-ornament">◆</div>

      <button type="submit" class="ack-submit">
        <span class="ack-submit-icon">✦</span>
        <span>Add Cake to Menu</span>
      </button>

    </form>
    
    <br>
    <div style="text-align: center;">
        <a href="${pageContext.request.contextPath}/index.jsp" style="font-size: 13px; color: var(--chocolate-500); font-family: 'Inter', sans-serif; text-decoration: none; font-weight: 600;">→ Home </a>
    </div>
  </div>
            </div>
          </section>
          
      </section>
    </div>
    <%@include file="footer.jsp" %>
  </div>
</main>

<% boolean hasOrders = request.getAttribute("ordersData") != null; %>
<script>
  function selectTag(el, val) {
    document.querySelectorAll('.ack-tag-pill').forEach(function(p) { p.classList.remove('selected'); });
    el.classList.add('selected');
    document.getElementById('tagHidden').value = val;
  }

  var bar = document.getElementById('previewBar');
  var pName = document.getElementById('previewName');
  function updatePreview() {
    if (!bar || !pName) return;
    var n = document.getElementById('inpName').value.trim();
    var u = document.getElementById('inpNum').value.trim();
    var p = document.getElementById('inpPrice').value.trim();
    if (n || u || p) {
      bar.classList.add('active');
      pName.style.color = '';
      pName.style.fontStyle = '';
      pName.textContent = n || '—';
      var extra = document.getElementById('previewExtra');
      if (!extra) {
        extra = document.createElement('span');
        extra.id = 'previewExtra';
        extra.style.cssText = 'display:flex;align-items:center;gap:.5rem;flex-shrink:0';
        bar.appendChild(extra);
      }
      extra.innerHTML = (u ? '<span class="ack-preview-num">N\u00b0' + u + '</span>' : '') + (p ? '<span class="ack-preview-price">\u20b9' + parseInt(p).toLocaleString('en-IN') + '</span>' : '');
    } else {
      bar.classList.remove('active');
      pName.style.color = 'var(--chocolate-400)';
      pName.style.fontStyle = 'italic';
      pName.textContent = 'Cake name will appear here…';
      var ex = document.getElementById('previewExtra');
      if (ex) ex.remove();
    }
  }
  if (document.getElementById('inpName')) document.getElementById('inpName').addEventListener('input', updatePreview);
  if (document.getElementById('inpNum')) document.getElementById('inpNum').addEventListener('input', updatePreview);
  if (document.getElementById('inpPrice')) document.getElementById('inpPrice').addEventListener('input', updatePreview);

  function showTab(tabName) {
    document.querySelectorAll('.admin-tab').forEach(function(btn){ btn.classList.toggle('active', btn.dataset.tab === tabName); });
    document.querySelectorAll('.tab-panel').forEach(function(panel){ panel.style.display = (panel.id === tabName + '-panel') ? 'block' : 'none'; });
  }

  document.addEventListener('DOMContentLoaded', function() {
    var tabs = document.querySelectorAll('.admin-tab');
    tabs.forEach(function(button) {
      button.addEventListener('click', function(e) {
        e.preventDefault();
        showTab(button.dataset.tab);
      });
    });
    var defaultTab = <%= hasCustomerOrders ? "'orders'" : "'cakes'" %>;
    showTab(defaultTab);
  });

  // Cloudinary direct upload integration
  const CLOUDINARY_CLOUD_NAME = "<%= System.getenv("CLOUDINARY_CLOUD_NAME") != null ? System.getenv("CLOUDINARY_CLOUD_NAME") : "" %>";
  const CLOUDINARY_UPLOAD_PRESET = "<%= System.getenv("CLOUDINARY_UPLOAD_PRESET") != null ? System.getenv("CLOUDINARY_UPLOAD_PRESET") : "" %>";

  if (CLOUDINARY_CLOUD_NAME && CLOUDINARY_UPLOAD_PRESET) {
    const addForm = document.getElementById('addCakeForm');
    if (addForm) {
      addForm.addEventListener('submit', async function(e) {
        const fileInput = addForm.querySelector('input[type="file"]');
        if (fileInput && fileInput.files.length > 0) {
          e.preventDefault();
          const submitBtn = addForm.querySelector('button[type="submit"]');
          const originalText = submitBtn.innerHTML;
          submitBtn.disabled = true;
          submitBtn.innerHTML = '<span>Uploading image...</span>';

          const file = fileInput.files[0];
          const formData = new FormData();
          formData.append('file', file);
          formData.append('upload_preset', CLOUDINARY_UPLOAD_PRESET);

          try {
            const res = await fetch('https://api.cloudinary.com/v1_1/' + CLOUDINARY_CLOUD_NAME + '/image/upload', {
              method: 'POST',
              body: formData
            });
            if (!res.ok) throw new Error('Cloudinary response was not OK');
            const data = await res.json();
            document.getElementById('cloudinaryUrl').value = data.secure_url;
            fileInput.removeAttribute('name');
            addForm.submit();
          } catch(err) {
            alert('Cloudinary Upload Failed: ' + err.message);
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
          }
        }
      });
    }
  }
</script>

</body>
</html>
