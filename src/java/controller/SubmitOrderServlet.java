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

        if (AuthUtil.isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/view-orders");
            return;
        }

        if (!AuthUtil.isUserLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login?error=Please+sign+in+to+place+an+order");
            return;
        }

        User user = AuthUtil.getLoggedInUser(request);
        String sql = "INSERT INTO orders (cake_name, cake_price, customer_name, customer_phone, delivery_date, customer_address, order_status, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, request.getParameter("ordered_cake_name"));

            String priceStr = request.getParameter("ordered_cake_price");
            ps.setDouble(2, (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0.0);

            ps.setString(3, request.getParameter("customer_name"));
            ps.setString(4, request.getParameter("customer_phone"));
            ps.setString(5, request.getParameter("delivery_date"));
            ps.setString(6, request.getParameter("customer_address"));
            ps.setString(7, OrderDao.DEFAULT_STATUS);
            ps.setInt(8, user.getId());

            ps.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/my-orders?success=Order+placed+successfully");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=Could+not+place+order.+Please+try+again");
        }
    }
}
