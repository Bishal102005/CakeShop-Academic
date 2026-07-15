<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="controller.AuthUtil, controller.CakeDao, model.User, model.Cake"%>
<%
    boolean isAdmin = AuthUtil.isAdminLoggedIn(request);
    User currentUser = AuthUtil.getLoggedInUser(request);
    String adminName = AuthUtil.getLoggedInAdmin(request);
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    String cakeIdParam = request.getParameter("id");
    String cakeNameParam = request.getParameter("name");
    String cakePriceParam = request.getParameter("price");

    if (cakeIdParam == null && cakeNameParam == null && cakePriceParam == null) {
        if (isAdmin) {
            response.sendRedirect(request.getContextPath() + "/view-orders");
        } else if (currentUser != null) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        } else {
            response.sendRedirect(request.getContextPath() + "/login?error=Please+sign+in+to+view+your+orders");
        }
        return;
    }

    Cake cake = null;
    try {
        if (cakeIdParam != null && !cakeIdParam.isEmpty()) {
            cake = CakeDao.findById(Integer.parseInt(cakeIdParam));
        } else if (cakeNameParam != null && !cakeNameParam.isEmpty()) {
            cake = CakeDao.findByName(cakeNameParam);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (isAdmin) {
        if (cake == null) {
            response.sendRedirect(request.getContextPath() + "/?error=Cake+not+found");
            return;
        }
    } else if (currentUser == null) {
        String redirect = "order.jsp?";
        if (cakeIdParam != null && !cakeIdParam.isEmpty()) {
            redirect += "id=" + java.net.URLEncoder.encode(cakeIdParam, "UTF-8");
        } else {
            redirect += "name=" + java.net.URLEncoder.encode(cakeNameParam != null ? cakeNameParam : "", "UTF-8")
                    + "&price=" + java.net.URLEncoder.encode(cakePriceParam != null ? cakePriceParam : "0", "UTF-8");
        }
        response.sendRedirect(request.getContextPath() + "/login?error=Please+sign+in+to+place+an+order&redirect="
                + java.net.URLEncoder.encode(redirect, "UTF-8"));
        return;
    }

    String cakeName = cake != null ? cake.getName() : cakeNameParam;
    String cakePrice = cake != null ? String.valueOf((int) cake.getPrice()) : cakePriceParam;
    if (cakeName == null) cakeName = "Selected Artisanal Cake";
    if (cakePrice == null) cakePrice = "0";

    String defaultName = currentUser != null ? currentUser.getFullName() : "";
    String defaultPhone = currentUser != null && currentUser.getPhone() != null ? currentUser.getPhone() : "";
    String avatarLetter = "";
    if (isAdmin) {
        avatarLetter = adminName != null && !adminName.isEmpty()
                ? adminName.substring(0, 1).toUpperCase()
                : "A";
    } else if (currentUser != null) {
        avatarLetter = currentUser.getFullName() != null && !currentUser.getFullName().isEmpty()
                ? currentUser.getFullName().substring(0, 1).toUpperCase()
                : currentUser.getUsername().substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isAdmin ? "Cake Details" : "Secure Checkout" %> — Sweet Crumbs Bakery</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css?v=1.1">
</head>
<body data-page="order" style="background: #fbf9f6; min-height: 100vh; padding: 2rem 1rem;">
    <div class="announcement-bar">
      <span>Artisan Pastry · Est. 2014</span>
      <span class="diamond">◆</span>
      <span>Free Delivery on Orders over ₹1500</span>
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
              <div class="user-avatar"><%= avatarLetter %></div>
              <div>
                <div class="user-name"><%= adminName != null ? adminName : "Admin" %></div>
                <div class="user-role">Administrator</div>
              </div>
            </div>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-primary"><span>Logout</span></a>
          <% } else if (currentUser != null) { %>
            <div class="user-badge">
              <div class="user-avatar"><%= avatarLetter %></div>
              <div>
                <div class="user-name"><%= currentUser.getFullName() %></div>
                <div class="user-role">Customer</div>
              </div>
            </div>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-primary"><span>Logout</span></a>
          <% } else { %>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary"><span>Login</span></a>
          <% } %>
        </div>
      </div>
    </header>

    <% if (isAdmin && cake != null) { %>
    <div style="max-width: 900px; margin: 0 auto; background: #fff; border-radius: 16px; box-shadow: 0 10px 30px rgba(74,51,25,0.05); overflow: hidden; border: 1px solid rgba(74,51,25,0.05);">
        <div style="background: #23160c; padding: 2rem; color: #fff; text-align: center;">
            <div style="font-size: 0.8rem; letter-spacing: 0.2em; text-transform: uppercase; color: #d4af37; margin-bottom: 0.5rem;">Cake Catalogue</div>
            <h2 style="font-family: serif; font-size: 2rem; font-weight: normal; margin: 0;">Cake Details</h2>
        </div>

        <% if (success != null && !success.isEmpty()) { %>
            <div style="background:#d1fae5;border-bottom:1px solid #a7f3d0;color:#065f46;padding:0.9rem 1.25rem;font-size:14px;"><%= success %></div>
        <% } %>
        <% if (error != null && !error.isEmpty()) { %>
            <div style="background:#fee2e2;border-bottom:1px solid #fecaca;color:#991b1b;padding:0.9rem 1.25rem;font-size:14px;"><%= error %></div>
        <% } %>

        <div class="cake-detail-grid">
            <div class="cake-detail-image" style="background: #fbf9f6; min-height: 320px;">
                 <img src="<%= (cake.getImageFile() != null && (cake.getImageFile().startsWith("http://") || cake.getImageFile().startsWith("https://"))) ? cake.getImageFile() : request.getContextPath() + "/assets/" + cake.getImageFile() %>" alt="<%= cake.getName() %>" style="width: 100%; height: 100%; min-height: 320px; object-fit: cover; display: block;">
            </div>
            <div class="cake-detail-content" style="padding: 2rem;">
                <div style="display: flex; gap: 0.5rem; flex-wrap: wrap; margin-bottom: 1rem;">
                    <span style="background: #23160c; color: #d4af37; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; font-weight: bold;">N°<%= cake.getNumber() %></span>
                    <% if (cake.getTag() != null && !cake.getTag().trim().isEmpty() && !"None".equals(cake.getTag())) { %>
                        <span style="background: #f3ebe3; color: #4a3319; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; font-weight: bold;"><%= cake.getTag() %></span>
                    <% } %>
                    <span style="background: #f3ebe3; color: #8c7662; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; font-weight: bold;"><%= cake.getCode() %></span>
                </div>

                <h3 style="font-family: serif; font-size: 1.75rem; color: #23160c; margin: 0 0 0.5rem;"><%= cake.getName() %></h3>
                <div style="color: #c9a961; font-weight: bold; margin-bottom: 1rem;">★ <%= cake.getRating() %></div>
                <p style="color: #5c4a38; line-height: 1.7; margin-bottom: 1.5rem;"><%= cake.getDescription() != null ? cake.getDescription() : "" %></p>

                <div style="margin-bottom: 1.5rem;">
                    <div style="font-size: 0.75rem; font-weight: bold; text-transform: uppercase; color: #8c7662; margin-bottom: 0.5rem; letter-spacing: 0.05em;">Key Ingredients</div>
                    <div style="display: flex; flex-wrap: wrap; gap: 0.5rem;">
                        <% if (cake.getIngredients() != null && !cake.getIngredients().isEmpty()) {
                               for (String item : cake.getIngredients().split(",")) { %>
                            <span style="background: #fbf9f6; border: 1px solid #e1d7cc; color: #4a3319; padding: 0.35rem 0.75rem; border-radius: 999px; font-size: 0.85rem;"><%= item.trim() %></span>
                        <%     }
                           } %>
                    </div>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 1rem; border-top: 1px solid #eee;">
                    <div>
                        <div style="font-size: 0.75rem; color: #8c7662; text-transform: uppercase; letter-spacing: 0.05em;">1 lb Base</div>
                        <div style="font-family: serif; font-size: 1.75rem; color: #4a3319; font-weight: bold;">₹<%= (int) cake.getPrice() %></div>
                    </div>
                </div>
            </div>
        </div>

        <div style="padding: 2rem; border-top: 1px solid #eee;">
            <details open>
                <summary style="cursor:pointer;font-weight:700;color:#23160c;font-family:serif;font-size:1.35rem;margin-bottom:1rem;">Edit Cake</summary>
                <form method="POST" action="${pageContext.request.contextPath}/admin" enctype="multipart/form-data" id="editCakeForm" style="display:grid;gap:1rem;">
                    <input type="hidden" name="action" value="updateCake">
                    <input type="hidden" name="id" value="<%= cake.getId() %>">
                    <input type="hidden" name="existing_image_file" value="<%= cake.getImageFile() != null ? cake.getImageFile() : "" %>">
                    <input type="hidden" name="cloudinary_url" id="cloudinaryUrl" value="">

                    <div style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:1rem;">
                        <div>
                            <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Cake Name *</label>
                            <input type="text" name="name" value="<%= cake.getName() != null ? cake.getName() : "" %>" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;" required>
                        </div>
                        <div>
                            <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Catalogue No. *</label>
                            <input type="text" name="number" value="<%= cake.getNumber() != null ? cake.getNumber() : "" %>" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;" required>
                        </div>
                    </div>

                    <div style="display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:1rem;">
                        <div>
                            <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Flavour Code *</label>
                            <input type="text" name="code" value="<%= cake.getCode() != null ? cake.getCode() : "" %>" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;" required>
                        </div>
                        <div>
                            <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Price *</label>
                            <input type="number" name="price" value="<%= cake.getPrice() %>" min="1" step="0.01" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;" required>
                        </div>
                        <div>
                            <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Rating *</label>
                            <input type="number" name="rating" value="<%= cake.getRating() %>" min="1" max="5" step="0.1" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;" required>
                        </div>
                    </div>

                    <div style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:1rem;">
                        <div>
                            <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Badge / Tag</label>
                            <select name="tag" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;">
                                <option value="" <%= cake.getTag() == null || cake.getTag().isEmpty() || "None".equals(cake.getTag()) ? "selected" : "" %>>None</option>
                                <option value="Bestseller" <%= "Bestseller".equals(cake.getTag()) ? "selected" : "" %>>Bestseller</option>
                                <option value="New" <%= "New".equals(cake.getTag()) ? "selected" : "" %>>New</option>
                                <option value="Limited" <%= "Limited".equals(cake.getTag()) ? "selected" : "" %>>Limited</option>
                                <option value="Seasonal" <%= "Seasonal".equals(cake.getTag()) ? "selected" : "" %>>Seasonal</option>
                            </select>
                        </div>
                        <div>
                            <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Replace Image</label>
                            <input type="file" name="image_file" accept="image/*" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;">
                        </div>
                    </div>

                    <div>
                        <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Description *</label>
                        <textarea name="description" rows="4" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;resize:vertical;" required><%= cake.getDescription() != null ? cake.getDescription() : "" %></textarea>
                    </div>

                    <div>
                        <label style="display:block;font-weight:600;margin-bottom:0.4rem;color:#4a3319;font-size:0.85rem;">Key Ingredients</label>
                        <input type="text" name="ingredients" value="<%= cake.getIngredients() != null ? cake.getIngredients() : "" %>" style="width:100%;padding:10px;border:1px solid #e1d7cc;border-radius:6px;background:#fffcf9;">
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm" style="width:fit-content;">Save Cake Changes</button>
                </form>
            </details>
        </div>

        <div style="padding: 1.5rem 2rem; background: #fbf9f6; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <a href="${pageContext.request.contextPath}/" style="color: #8c7662; font-size: 0.9rem; text-decoration: underline; font-weight: 500;">← Back to Showcase Menu</a>
            <div style="display:flex;gap:0.75rem;align-items:center;flex-wrap:wrap;">
                <form method="POST" action="${pageContext.request.contextPath}/admin" onsubmit="return confirm('Delete this cake from the menu?');" style="margin:0;">
                    <input type="hidden" name="action" value="deleteCake">
                    <input type="hidden" name="id" value="<%= cake.getId() %>">
                    <button type="submit" class="btn btn-burgundy btn-sm">Delete Cake</button>
                </form>
                <a href="${pageContext.request.contextPath}/view-orders" class="btn btn-outline btn-sm" style="text-decoration: none;">Add New Cake</a>
                <a href="${pageContext.request.contextPath}/view-orders" class="btn btn-primary btn-sm" style="text-decoration: none;">Admin Console</a>
            </div>
        </div>
    </div>
    <% } else { %>
    <div style="max-width: 600px; margin: 0 auto; background: #fff; border-radius: 16px; box-shadow: 0 10px 30px rgba(74,51,25,0.05); overflow: hidden; border: 1px solid rgba(74,51,25,0.05);">
        
        <div style="background: #23160c; padding: 2.5rem 2rem; color: #fff; text-align: center; position: relative;">
            <div style="font-size: 0.8rem; letter-spacing: 0.2em; text-transform: uppercase; color: #d4af37; margin-bottom: 0.5rem;">Gourmet Confections Checkout</div>
            <h2 style="font-family: serif; font-size: 2rem; font-weight: normal; margin: 0;">Place Your Order</h2>
            <div style="position: absolute; bottom: -10px; left: 50%; transform: translateX(-50%); width: 20px; height: 20px; background: #fff; rotate: 45deg;"></div>
        </div>

        <form method="POST" action="SubmitOrderServlet" style="padding: 2.5rem 2rem;">
            
            <div style="background: #fbf9f6; padding: 1.25rem; border-radius: 8px; border: 1px dashed #e1d7cc; margin-bottom: 2rem;">
                <div style="font-size: 0.75rem; font-weight: bold; text-transform: uppercase; color: #8c7662; margin-bottom: 0.5rem; letter-spacing: 0.05em;">Selected Masterpiece</div>
                
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-family: serif; font-size: 1.25rem; color: #23160c; font-weight: bold;"><%= cakeName %></span>
                    <span style="font-family: serif; font-size: 1.25rem; color: #8c7662; font-weight: bold;">₹<%= cakePrice %></span>
                </div>
                
                <input type="hidden" name="ordered_cake_name" value="<%= cakeName %>" />
                <input type="hidden" name="ordered_cake_price" value="<%= cakePrice %>" />
            </div>

            <div style="display: flex; align-items: center; text-align: center; margin-bottom: 1.5rem;">
                <div style="flex: 1; height: 1px; background: #eee;"></div>
                <span style="padding: 0 10px; font-size: 0.75rem; font-weight: bold; letter-spacing: 0.1em; color: #8c7662; text-transform: uppercase;">◆ Customer Particulars ◆</span>
                <div style="flex: 1; height: 1px; background: #eee;"></div>
            </div>

            <div style="margin-bottom: 1.25rem;">
                <label style="display: block; font-weight: 600; margin-bottom: 0.4rem; color: #4a3319; font-size: 0.9rem;">Your Full Name *</label>
                <input type="text" name="customer_name" value="<%= defaultName %>" placeholder="e.g. Rony Das" style="width: 100%; padding: 10px; border: 1px solid #e1d7cc; border-radius: 6px; font-family: inherit; background: #fffcf9;" required />
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.25rem;">
                <div>
                    <label style="display: block; font-weight: 600; margin-bottom: 0.4rem; color: #4a3319; font-size: 0.9rem;">Contact Number *</label>
                    <input type="tel" name="customer_phone" value="<%= defaultPhone %>" placeholder="e.g. +91 98765..." style="width: 100%; padding: 10px; border: 1px solid #e1d7cc; border-radius: 6px; font-family: inherit; background: #fffcf9;" required />
                </div>
                <div>
                    <label style="display: block; font-weight: 600; margin-bottom: 0.4rem; color: #4a3319; font-size: 0.9rem;">Delivery Date *</label>
                    <input type="date" name="delivery_date" style="width: 100%; padding: 10px; border: 1px solid #e1d7cc; border-radius: 6px; font-family: inherit; background: #fffcf9;" required />
                </div>
            </div>

            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-weight: 600; margin-bottom: 0.4rem; color: #4a3319; font-size: 0.9rem;">Complete Delivery Address *</label>
                <textarea name="customer_address" rows="3" placeholder="Apartment/House No, Street, Landmark, Pincode" style="width: 100%; padding: 10px; border: 1px solid #e1d7cc; border-radius: 6px; font-family: inherit; background: #fffcf9; resize: vertical;" required></textarea>
            </div>

            <button type="submit" style="width: 100%; padding: 14px; background: #4a3319; color: #fff; border: none; border-radius: 6px; font-weight: bold; font-size: 1rem; cursor: pointer; transition: background 0.2s; box-shadow: 0 4px 12px rgba(74,51,25,0.15);">
                Confirm Order (Cash on Delivery)
            </button>
            
            <div style="text-align: center; margin-top: 1.5rem;">
                <a href="${pageContext.request.contextPath}/" style="color: #8c7662; font-size: 0.9rem; text-decoration: underline; font-weight: 500;">← Cancel & Return to Showcase Menu</a>
            </div>
        </form>
    </div>
    <% } %>

    <script>
      // Cloudinary direct upload integration
      const CLOUDINARY_CLOUD_NAME = "<%= System.getenv("CLOUDINARY_CLOUD_NAME") != null ? System.getenv("CLOUDINARY_CLOUD_NAME") : "" %>";
      const CLOUDINARY_UPLOAD_PRESET = "<%= System.getenv("CLOUDINARY_UPLOAD_PRESET") != null ? System.getenv("CLOUDINARY_UPLOAD_PRESET") : "" %>";

      if (CLOUDINARY_CLOUD_NAME && CLOUDINARY_UPLOAD_PRESET) {
        const editForm = document.getElementById('editCakeForm');
        if (editForm) {
          editForm.addEventListener('submit', async function(e) {
            const fileInput = editForm.querySelector('input[type="file"]');
            if (fileInput && fileInput.files.length > 0) {
              e.preventDefault();
              const submitBtn = editForm.querySelector('button[type="submit"]');
              const originalText = submitBtn.innerHTML;
              submitBtn.disabled = true;
              submitBtn.innerHTML = 'Uploading image...';

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
                editForm.querySelector('#cloudinaryUrl').value = data.secure_url;
                fileInput.removeAttribute('name');
                editForm.submit();
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
    <%@include file="footer.jsp" %>
</body>
</html>
