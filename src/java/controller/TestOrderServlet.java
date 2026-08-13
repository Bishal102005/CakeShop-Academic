package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;

@WebServlet("/test-order")
public class TestOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><body><h1>Test Order Servlet</h1>");

        try {
            System.out.println("\n=== TEST ORDER SERVLET CALLED ===");
            
            User user = AuthUtil.getLoggedInUser(request);
            System.out.println("User: " + (user != null ? user.getUsername() : "null"));
            
            if (!AuthUtil.isUserLoggedIn(request)) {
                out.println("<p style='color:red;'>ERROR: User not logged in!</p>");
                System.out.println("ERROR: User not logged in!");
                return;
            }

            String cakeName = request.getParameter("ordered_cake_name");
            String priceStr = request.getParameter("ordered_cake_price");
            String customerName = request.getParameter("customer_name");
            String customerPhone = request.getParameter("customer_phone");
            String deliveryDate = request.getParameter("delivery_date");
            String customerAddress = request.getParameter("customer_address");

            out.println("<p>Cake: " + cakeName + "</p>");
            out.println("<p>Price: " + priceStr + "</p>");
            out.println("<p>Customer: " + customerName + "</p>");
            out.println("<p>Phone: " + customerPhone + "</p>");
            out.println("<p>Delivery Date: " + deliveryDate + "</p>");
            out.println("<p>Address: " + customerAddress + "</p>");

            System.out.println("Cake: " + cakeName);
            System.out.println("Price: " + priceStr);
            System.out.println("Customer: " + customerName);
            System.out.println("Phone: " + customerPhone);
            System.out.println("Delivery Date: " + deliveryDate);
            System.out.println("Address: " + customerAddress);

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
                        System.err.println("[TestOrderServlet] Warning: Could not parse delivery date '" + deliveryDate + "'");
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
                ps.setString(7, "Received");
                ps.setInt(8, user.getId());

                int rows = ps.executeUpdate();
                System.out.println("Insert successful! Rows: " + rows);
                out.println("<p style='color:green;'><b>SUCCESS! Order inserted: " + rows + " row(s)</b></p>");
            }

        } catch (Exception e) {
            System.err.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            out.println("<p style='color:red;'><b>ERROR: " + e.getMessage() + "</b></p>");
        }
        
        out.println("</body></html>");
        System.out.println("=== TEST ORDER SERVLET END ===\n");
    }
}
