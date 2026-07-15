package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin123";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if ("logout".equals(request.getParameter("action"))) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login?success=Signed+out+successfully");
            return;
        }

        if (AuthUtil.isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/view-orders");
            return;
        }

        if (AuthUtil.isUserLoggedIn(request)) {
            response.sendRedirect(resolveRedirect(request));
            return;
        }

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("admin".equals(role)) {
            if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {
                HttpSession session = request.getSession(true);
                session.removeAttribute(AuthUtil.SESSION_USER);
                session.setAttribute(AuthUtil.SESSION_ADMIN, username);
                response.sendRedirect(request.getContextPath() + "/view-orders");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login?role=admin&error=Invalid+admin+username+or+password");
            return;
        }

        try {
            User user = UserDao.findByUsername(username);
            if (user != null && user.getPassword().equals(password)) {
                HttpSession session = request.getSession(true);
                session.removeAttribute(AuthUtil.SESSION_ADMIN);
                session.setAttribute(AuthUtil.SESSION_USER, user);
                response.sendRedirect(resolveRedirect(request));
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=Database+error.+Run+sql/users_table.sql+first");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/login?error=Invalid+username+or+password"
                + appendRedirectParam(request));
    }

    private String appendRedirectParam(HttpServletRequest request) {
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.isEmpty()) {
            return "";
        }
        try {
            return "&redirect=" + java.net.URLEncoder.encode(redirect, "UTF-8");
        } catch (java.io.UnsupportedEncodingException e) {
            return "";
        }
    }

    private String resolveRedirect(HttpServletRequest request) {
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.isEmpty()) {
            return request.getContextPath() + "/";
        }
        if (redirect.contains("://") || redirect.startsWith("//")) {
            return request.getContextPath() + "/";
        }
        if (redirect.startsWith("/")) {
            return request.getContextPath() + redirect;
        }
        return request.getContextPath() + "/" + redirect;
    }
}
