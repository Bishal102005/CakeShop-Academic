package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;

@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (AuthUtil.isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/view-orders");
            return;
        }

        if (!AuthUtil.requireUser(request, response)) {
            return;
        }

        User user = AuthUtil.getLoggedInUser(request);

        try {
            List<Map<String, Object>> orders = OrderDao.getOrdersForUser(user.getId());
            request.setAttribute("userOrders", orders);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Could not load your orders.");
        }

        request.getRequestDispatcher("my-orders.jsp").forward(request, response);
    }
}
