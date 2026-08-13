package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;

@WebServlet("/SubmitOrderServlet")
public class SubmitOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[SubmitOrderServlet] === ORDER SUBMISSION START ===");

        if (AuthUtil.isAdminLoggedIn(request)) {
            System.out.println("[SubmitOrderServlet] Admin detected, redirecting to view-orders");
            response.sendRedirect(request.getContextPath() + "/view-orders");
            return;
        }

        if (!AuthUtil.isUserLoggedIn(request)) {
            System.out.println("[SubmitOrderServlet] User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login?error=Please+sign+in+to+place+an+order");
            return;
        }

        User user = AuthUtil.getLoggedInUser(request);
        System.out.println("[SubmitOrderServlet] User: " + user.getUsername() + " (ID: " + user.getId() + ")");
        
        String cakeName = request.getParameter("ordered_cake_name");
        String priceStr = request.getParameter("ordered_cake_price");
        String customerName = request.getParameter("customer_name");
        String customerPhone = request.getParameter("customer_phone");
        String deliveryDate = request.getParameter("delivery_date");
        String customerAddress = request.getParameter("customer_address");
        
        System.out.println("[SubmitOrderServlet] Cake: " + cakeName);
        System.out.println("[SubmitOrderServlet] Price: " + priceStr);
        System.out.println("[SubmitOrderServlet] Customer: " + customerName);
        System.out.println("[SubmitOrderServlet] Phone: " + customerPhone);
        System.out.println("[SubmitOrderServlet] Delivery Date: " + deliveryDate);
        System.out.println("[SubmitOrderServlet] Address: " + customerAddress);
        
        String sql = "INSERT INTO orders (cake_name, cake_price, customer_name, customer_phone, delivery_date, customer_address, order_status, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            double price = 0.0;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    String cleanPrice = priceStr.replaceAll("[^0-9.]", "");
                    price = cleanPrice.isEmpty() ? 0.0 : Double.parseDouble(cleanPrice);
                } catch (Exception ignored) {
                }
            }

            java.sql.Date parsedDate = null;
            if (deliveryDate != null && !deliveryDate.trim().isEmpty()) {
                try {
                    parsedDate = java.sql.Date.valueOf(deliveryDate.trim());
                } catch (Exception ex) {
                    System.err.println("[SubmitOrderServlet] Warning: Could not parse delivery date '" + deliveryDate + "'");
                }
            }

            ps.setString(1, cakeName);
            ps.setDouble(2, price);
            ps.setString(3, customerName);
            ps.setString(4, customerPhone);
            if (parsedDate != null) {
                ps.setDate(5, parsedDate);
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }
            ps.setString(6, customerAddress);
            ps.setString(7, OrderDao.DEFAULT_STATUS);
            ps.setInt(8, user.getId());

            System.out.println("[SubmitOrderServlet] Executing insert: " + sql);
            int rows = ps.executeUpdate();
            System.out.println("[SubmitOrderServlet] Insert successful! Rows affected: " + rows);
            
            response.sendRedirect(request.getContextPath() + "/my-orders?success=Order+placed+successfully");

        } catch (Exception e) {
            System.err.println("[SubmitOrderServlet] ERROR: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            e.printStackTrace();
            String errorMsg = e.getMessage() != null ? e.getMessage() : "Database error";
            response.sendRedirect(request.getContextPath() + "/order.jsp?error=Order+failed:+" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
        
        System.out.println("[SubmitOrderServlet] === ORDER SUBMISSION END ===");
    }
}
