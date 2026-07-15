package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/view-orders")
public class ViewOrdersServlet extends HttpServlet {

   private Connection getConnection() throws Exception {
       return DbUtil.getConnection();
   }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.requireAdmin(request, response)) {
            return;
        }

        List<Map<String, Object>> orderList = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_id DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                orderList.add(OrderDao.mapOrderRow(rs));
            }
                // DEBUG: This prints to your NetBeans Output console
                System.out.println("DEBUG: ViewOrdersServlet found " + orderList.size() + " orders.");
                // compute simple stats
                int deliveredCount = 0;
                double revenue = 0.0;
                for (Map<String, Object> row : orderList) {
                    String status = String.valueOf(row.get("status"));
                    if ("Delivered".equals(status)) {
                        deliveredCount++;
                    }
                    Object priceObj = row.get("cakePrice");
                    if ("Delivered".equals(status) && priceObj instanceof Number) {
                        revenue += ((Number) priceObj).doubleValue();
                    } else if ("Delivered".equals(status)) {
                        try {
                            revenue += Double.parseDouble(String.valueOf(priceObj));
                        } catch (Exception ex) {
                        }
                    }
                }
                request.setAttribute("statActiveOrders", orderList.size());
                request.setAttribute("statDelivered", deliveredCount);
                request.setAttribute("statRevenue", revenue);
            
        } catch (Exception e) {
    e.printStackTrace();
    request.setAttribute("errorMessage", "Error: " + e.getMessage());
}
        
        // This name "ordersData" MUST match the JSP attribute request
        request.setAttribute("ordersData", orderList);
        // Also fetch cake menu count for "On Menu"
        try (Connection conn2 = getConnection();
             Statement s2 = conn2.createStatement();
             ResultSet rs2 = s2.executeQuery("SELECT COUNT(*) AS cnt FROM cakes")) {
            if (rs2.next()) {
                request.setAttribute("statOnMenu", rs2.getInt("cnt"));
            } else {
                request.setAttribute("statOnMenu", 0);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("statOnMenu", 0);
        }

        // Forward to the combined admin page so orders appear inside the admin tabs
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}