<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@page import="controller.AuthUtil, model.User" %>
    <% if (request.getAttribute("cakeMenu")==null) { request.getRequestDispatcher("/admin").forward(request, response);
      return; } User currentUser=AuthUtil.getLoggedInUser(request); String
      welcomeMessage=request.getParameter("success"); boolean isAdmin=AuthUtil.isAdminLoggedIn(request); String
      adminName=AuthUtil.getLoggedInAdmin(request); String avatarLetter="" ; if (currentUser !=null) {
      avatarLetter=currentUser.getFullName() !=null && !currentUser.getFullName().isEmpty() ?
      currentUser.getFullName().substring(0, 1).toUpperCase() : currentUser.getUsername().substring(0, 1).toUpperCase();
      } %>
      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Sweet Crumbs Bakery — Artisan Cakes & Pastries</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css?v=1.1">
      </head>

      <body data-page="home">

        <div class="announcement-bar">
          <span>Artisan Pastry · Est. 2026</span>
          <span class="diamond">◆</span>
          <span>Free Delivery on Orders over ₹1500</span>
        </div>

        <header class="site-header">
          <div class="header-inner">
            <a href="${pageContext.request.contextPath}/" class="brand-link">
              <div class="brand-logo-wrap">
                <div class="brand-logo">
                  <svg class="icon-lg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 3v3" />
                    <circle cx="12" cy="3" r="0.5" fill="currentColor" />
                    <path d="M5 11c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v3H5v-3Z" />
                    <path d="M3 21v-5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v5" />
                    <path d="M3 17h18" />
                  </svg>
                </div>
                <div class="brand-dot"></div>
              </div>
              <div>
                <div class="brand-title font-display">Sweet Crumbs</div>
                <div class="brand-subtitle">Artisan Bakery · Pastry</div>
              </div>
            </a>
            <div class="header-info">
              <div class="header-info-item">
                <div class="header-info-label">Open Today</div>
                <div class="header-info-value">8 AM – 9 PM</div>
              </div>
              <div class="header-divider"></div>
              <div class="header-info-item">
                <div class="header-info-label">Call Us</div>
                <div class="header-info-value">+91 98765 43210</div>
              </div>
            </div>
            <div class="header-actions">
              <% if (isAdmin) { %>
                <div class="user-badge">
                  <div class="user-avatar">
                    <%= adminName !=null ? adminName.substring(0, 1).toUpperCase() : "A" %>
                  </div>
                  <div>
                    <div class="user-name">
                      <%= adminName !=null ? adminName : "Admin" %>
                    </div>
                    <div class="user-role">Administrator</div>
                  </div>
                </div>
                <a href="${pageContext.request.contextPath}/login?action=logout"
                  class="btn btn-primary"><span>Logout</span></a>
                <% } else if (currentUser !=null) { %>
                  <div class="user-badge">
                    <div class="user-avatar">
                      <%= avatarLetter %>
                    </div>
                    <div>
                      <div class="user-name">
                        <%= currentUser.getFullName() %>
                      </div>
                      <div class="user-role">Customer</div>
                    </div>
                  </div>
                  <a href="${pageContext.request.contextPath}/login?action=logout"
                    class="btn btn-primary"><span>Logout</span></a>
                  <% } else { %>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary"><span>Login</span></a>
                    <% } %>
            </div>
          </div>
        </header>

        <main class="site-main">
          <div class="main-inner">
            <div class="content-shell">

              <nav class="site-nav">
                <a href="${pageContext.request.contextPath}/" class="nav-link active"><svg class="icon-sm"
                    viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 12 12 3l9 9" />
                    <path d="M5 10v10h14V10" />
                  </svg><span>Home</span></a>
                <% if (isAdmin) { %>
                  <span class="nav-sep">◆</span>
                  <a href="${pageContext.request.contextPath}/view-orders" class="nav-link"><svg class="icon-sm"
                      viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="4" y="3" width="16" height="18" rx="2" />
                      <path d="M8 8h8M8 12h8M8 16h5" />
                    </svg><span>Admin Console</span></a>
                  <% } else { %>
                    <span class="nav-sep">◆</span>
                    <a href="${pageContext.request.contextPath}/my-orders" class="nav-link"><svg class="icon-sm"
                        viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="4" y="3" width="16" height="18" rx="2" />
                        <path d="M8 8h8M8 12h8M8 16h5" />
                      </svg><span>Order</span></a>
                    <% if (currentUser !=null) { %><span class="nav-sep">◆</span>
                      <a href="${pageContext.request.contextPath}/my-account" class="nav-link"><svg class="icon-sm"
                          viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <circle cx="12" cy="8" r="4" />
                          <path d="M4 21c0-4 4-6 8-6s8 2 8 6" />
                        </svg><span>My Account</span></a>
                      <% } %>
                        <% } %>
                          <div class="nav-greeting"><svg class="icon-sm" viewBox="0 0 24 24" fill="none"
                              stroke="currentColor" stroke-width="2">
                              <circle cx="12" cy="8" r="4" />
                              <path d="M4 21c0-4 4-6 8-6s8 2 8 6" />
                            </svg><span>Hand-crafted daily</span></div>
              </nav>

              <section class="page-section" id="page-content">
                <div class="page-stack">
                  <% if (welcomeMessage !=null && !welcomeMessage.isEmpty()) { %>
                    <div
                      style="background:#d1fae5;border:1px solid #a7f3d0;color:#065f46;padding:0.75rem 1rem;border-radius:var(--radius-lg);font-size:14px">
                      <%= welcomeMessage %>
                    </div>
                    <% } %>

                      <section class="hero-grid">
                        <div class="animate-float-in">
                          <div class="badge-pill"><span>The Pinnacle of French Craft</span></div>
                          <h1 class="hero-title font-display">Baked with<br><em>devotion</em>, layered<br>in absolute
                            <u>luxury</u>.</h1>
                          <p class="hero-text">We focus entirely on signature creations. Each morning, our master
                            patissiers fold premium ingredients into flawless centerpieces.</p>
                        </div>
                        <div class="hero-visual animate-float-in">
                          <div class="hero-frame">
                            <div class="hero-image-wrap">
                              <img src="${pageContext.request.contextPath}/assets/hero-cake.jpg"
                                alt="Signature masterpiece">
                            </div>
                          </div>
                        </div>
                      </section>

                      <section>
                        <div class="page-header mb-6">
                          <div class="section-label"><span class="line"></span><span>Curated Masterpieces</span><span
                              class="line"></span></div>
                          <h2 class="page-title font-display">The Signature <em>Menu</em></h2>
                          <p class="page-subtitle">Executed precisely to definitive, world-class perfection.</p>
                        </div>

                        <div class="card-grid" id="home-cakes">

                          <%@page import="java.util.List, model.Cake" %>
                            <% List<Cake> menu = (List<Cake>) request.getAttribute("cakeMenu");

                                if (menu == null || menu.isEmpty()) {
                                %>
                                <div
                                  style="grid-column: 1 / -1; text-align: center; padding: 4rem 2rem; color: var(--chocolate-400); font-style: italic; background: var(--cream-50); border: 1px dashed var(--chocolate-100); border-radius: var(--radius-xl);">
                                  Our pastry kitchen is preparing today's signature menu. Please check back soon!
                                </div>
                                <% } else { for (Cake c : menu) { %>
                                  <article class="cake-card">
                                    <div class="cake-card-image">
                                       <img src="<%= (c.getImageFile() != null && (c.getImageFile().startsWith("http://") || c.getImageFile().startsWith("https://"))) ? c.getImageFile() : request.getContextPath() + "/assets/" + c.getImageFile() %>"
                                         alt="<%= c.getName() %>" loading="lazy">
                                      <div class="cake-card-overlay"></div>
                                      <div class="cake-card-badges">
                                        <span class="cake-number">N°<%= c.getNumber() %></span>
                                        <% if(c.getTag() !=null && !c.getTag().trim().isEmpty() &&
                                          !"None".equals(c.getTag())) { %>
                                          <span class="cake-tag">
                                            <%= c.getTag() %>
                                          </span>
                                          <% } %>
                                      </div>
                                      <span class="cake-code">
                                        <%= c.getCode() %>
                                      </span>
                                    </div>

                                    <div class="cake-card-body">
                                      <div class="cake-card-header">
                                        <h3 class="cake-card-title font-display">
                                          <%= c.getName() %>
                                        </h3>
                                        <div class="cake-rating">★ <%= c.getRating() %>
                                        </div>
                                      </div>
                                      <p class="cake-desc">
                                        <%= c.getDescription() %>
                                      </p>

                                      <div class="ingredient-list">
                                        <div class="ingredient-label">Key Ingredients</div>
                                        <div class="ingredient-tags">
                                          <% if(c.getIngredients() !=null && !c.getIngredients().isEmpty()) { String[]
                                            items=c.getIngredients().split(","); for(String item : items) { %>
                                            <span class="ingredient-tag">
                                              <%= item.trim() %>
                                            </span>
                                            <% } } %>
                                        </div>
                                      </div>

                                      <div class="cake-card-footer">
                                        <div>
                                          <div class="price-label">1 lb Base</div>
                                          <div class="price-value font-display">₹<%= (int)c.getPrice() %>
                                          </div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/order.jsp?id=<%= c.getId() %>"
                                          class="btn btn-primary btn-sm"
                                          style="text-align: center; text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                          <%= isAdmin ? "Details" : "Buy" %>
                                        </a>
                                      </div>
                                    </div>
                                  </article>
                                  <% } } %>
                        </div>
                      </section>

                </div>
              </section>
              <section class="philosophy-box">
                <div class="philosophy-glow"></div>
                <div class="philosophy-grid">
                  <div>
                    <div class="badge-pill" style="margin-bottom:0.75rem">The Art of Layering</div>
                    <h2 class="page-title font-display" style="font-size:2rem;margin-top:0">Our Uncompromising
                      <em>Standards</em></h2>
                    <p class="text-muted text-sm mt-4">True artisan baking allows no shortcuts. From sourcing
                      single-origin cocoa beans to timed thermal deliveries, every variable is carefully orchestrated.
                    </p>
                  </div>
                  <div class="step-grid">
                    <div class="step-card">
                      <div class="step-icon"><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                          stroke-width="2">
                          <path
                            d="M12 3c-2 0-3 1.5-3 3 0 .4.1.7.2 1A4 4 0 0 0 5 11h14a4 4 0 0 0-4.2-4c.1-.3.2-.6.2-1 0-1.5-1-3-3-3Z" />
                          <path d="M6 11l1.5 9h9L18 11" />
                        </svg></div>
                      <h3 class="step-title font-display">1. Premium Sourcing</h3>
                      <p class="step-desc">We exclusively import Callebaut dark chocolate and genuine Madagascar bourbon
                        vanilla pods.</p>
                    </div>
                    <div class="step-card">
                      <div class="step-icon"><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                          stroke-width="2">
                          <path d="M21 12a9 9 0 1 1-9-9 4 4 0 0 0 4 4 4 4 0 0 0 4 4 4 4 0 0 0 1 1Z" />
                          <circle cx="9" cy="10" r="0.8" fill="currentColor" />
                          <circle cx="14" cy="14" r="0.8" fill="currentColor" />
                          <circle cx="9" cy="16" r="0.8" fill="currentColor" />
                        </svg></div>
                      <h3 class="step-title font-display">2. Precision Craft</h3>
                      <p class="step-desc">Sponges are baked inside controlled steam ovens ensuring a perfectly moist,
                        cloud-like crumb.</p>
                    </div>
                    <div class="step-card">
                      <div class="step-icon"><svg class="icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                          stroke-width="2">
                          <path
                            d="M20.8 5.6a5.5 5.5 0 0 0-7.8 0L12 6.6l-1-1a5.5 5.5 0 0 0-7.8 7.8l1 1L12 22l7.8-7.8 1-1a5.5 5.5 0 0 0 0-7.6Z" />
                        </svg></div>
                      <h3 class="step-title font-display">3. White Glove Transit</h3>
                      <p class="step-desc">Cakes are dispatched inside insulated, shock-absorbing custom courier
                        containers.</p>
                    </div>
                  </div>
                </div>
              </section>


            </div>
            </section>
          </div>
          </div>
          <section class="quote-section">
            <div class="badge-pill" style="justify-content:center;margin-bottom:1rem"><svg class="icon-sm"
                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path
                  d="M12 3v4M12 17v4M3 12h4M17 12h4M5.6 5.6l2.8 2.8M15.6 15.6l2.8 2.8M5.6 18.4l2.8-2.8M15.6 8.4l2.8-2.8" />
              </svg> Celebrated Worldwide</div>
            <h2 class="quote-text font-display">"Sweet Crumbs has redefined the custom cake experience. By offering just
              three flawless options, they guarantee absolute freshness and uncompromised luxury."</h2>
            <div class="quote-sources"><span>— Enjoys Pastry</span><span class="text-gold">◆</span><span>— Le Cordon
                Digest</span><span class="text-gold">◆</span><span>— Gourmet Monthly</span></div>
          </section>
          <%@include file="footer.jsp" %>
            </div>
        </main>
      </body>

      </html>