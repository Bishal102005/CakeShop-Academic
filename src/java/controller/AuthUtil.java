package controller;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

public final class AuthUtil {

    public static final String SESSION_ADMIN = "adminUser";
    public static final String SESSION_USER = "loggedInUser";

    private AuthUtil() {
    }

    public static boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute(SESSION_ADMIN) != null;
    }

    public static boolean isUserLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute(SESSION_USER) != null;
    }

    public static User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute(SESSION_USER);
        return value instanceof User ? (User) value : null;
    }

    public static String getLoggedInAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute(SESSION_ADMIN);
        return value != null ? String.valueOf(value) : null;
    }

    public static boolean requireAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login?role=admin&error=Please+sign+in+to+access+the+admin+panel");
            return false;
        }
        return true;
    }

    public static boolean requireUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isUserLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login?error=Please+sign+in+to+view+your+account");
            return false;
        }
        return true;
    }
}
