package controller;

import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = trim(request.getParameter("full_name"));
        String username = trim(request.getParameter("username"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (fullName.isEmpty() || username.isEmpty() || email.isEmpty()
                || password == null || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login?tab=signup&error=Please+fill+in+all+required+fields");
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/login?tab=signup&error=Passwords+do+not+match");
            return;
        }

        try {
            if (UserDao.findByUsername(username) != null) {
                response.sendRedirect(request.getContextPath() + "/login?tab=signup&error=Username+already+taken");
                return;
            }

            if (UserDao.findByEmail(email) != null) {
                response.sendRedirect(request.getContextPath() + "/login?tab=signup&error=Email+already+registered");
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            user.setFullName(fullName);
            user.setPhone(phone);

            if (!UserDao.createUser(user)) {
                response.sendRedirect(request.getContextPath() + "/login?tab=signup&error=Could+not+create+account");
                return;
            }

            User saved = UserDao.findByUsername(username);
            HttpSession session = request.getSession(true);
            session.removeAttribute(AuthUtil.SESSION_ADMIN);
            session.setAttribute(AuthUtil.SESSION_USER, saved);

            response.sendRedirect(request.getContextPath() + "/?success=Welcome+to+Sweet+Crumbs");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?tab=signup&error=Database+error.+Run+sql/users_table.sql+first");
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
