package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/my-account")
public class MyAccountServlet extends HttpServlet {

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

        request.getRequestDispatcher("my-account.jsp").forward(request, response);
    }
}
