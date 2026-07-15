package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/update-order-status")
public class UpdateOrderStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.requireAdmin(request, response)) {
            return;
        }

        String orderIdStr = request.getParameter("order_id");
        String status = request.getParameter("status");

        if (orderIdStr == null || !OrderDao.isValidStatus(status)) {
            response.sendRedirect(request.getContextPath() + "/view-orders?error=Invalid+order+or+status");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            if (!OrderDao.updateOrderStatus(orderId, status)) {
                response.sendRedirect(request.getContextPath() + "/view-orders?error=Order+not+found");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/view-orders?success=Order+status+updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view-orders?error=Could+not+update+status.+Run+sql/order_status.sql");
        }
    }
}
