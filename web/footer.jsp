<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@page import="controller.AuthUtil" %>
    <% boolean isFooterAdmin=AuthUtil.isAdminLoggedIn(request); boolean isFooterUser=AuthUtil.getLoggedInUser(request)
      !=null; %>
      <footer class="site-footer">
        <div class="footer-grid">
          <div class="footer-brand">
            <h3 class="footer-brand-title font-display">Sweet Crumbs <em>Bakery</em></h3>
            <p class="footer-about-text">
              Established in 2026, Sweet Crumbs Bakery is dedicated to the art of fine French patisserie and bespoke
              confections. Every masterpiece is handcrafted daily using imported single-origin chocolate, pure
              Madagascar vanilla, and locally-sourced organic dairy to ensure absolute luxury in every bite.
            </p>
          </div>
          <div class="footer-section footer-developer">
            <h4 class="footer-col-title">Developer</h4>
            <ul class="footer-links">
              <li>Bishal Saha</li>
              <li>Debansu Ghosh</li>
              <li>Ayushi Singh</li>
              <li>Baitanik Chaterjee</li>
              <li>Debanjan Sengupta</li>
              <li>Brishti Mondal</li>
            </ul>
          </div>
          <div class="footer-section footer-navigation">
            <h4 class="footer-col-title">Navigation</h4>
            <ul class="footer-links">
              <li><a href="${pageContext.request.contextPath}/">Home Showcase</a></li>
              <% if (isFooterAdmin) { %>
                <li><a href="${pageContext.request.contextPath}/view-orders">Admin Console</a></li>
                <% } else { %>
                  <li><a href="${pageContext.request.contextPath}/my-orders">Order History</a></li>
                  <% if (isFooterUser) { %>
                    <li><a href="${pageContext.request.contextPath}/my-account">My Profile</a></li>
                    <% } else { %>
                      <li><a href="${pageContext.request.contextPath}/login">Customer Portal</a></li>
                      <% } %>
                        <% } %>
            </ul>
          </div>
          <div class="footer-section footer-salon">
            <h4 class="footer-col-title">Our Salon</h4>
            <ul class="footer-info">
              <li><strong>Hours:</strong> Daily 8 AM – 9 PM</li>
              <li><strong>Phone:</strong> +91 98765 43210</li>
              <li><strong>Address:</strong> EM 4/1, Techno More, Sector V, Kolkata, WB</li>
            </ul>
          </div>
        </div>
        <div class="footer-bottom">
          <div class="ornament">◆</div>
          <p class="footer-copy">© 2026 Sweet Crumbs Bakery</p>
          <p class="footer-note">· Baked with love ·</p>
        </div>
      </footer>