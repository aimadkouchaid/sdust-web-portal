package edu.sdust.web;

import edu.sdust.dao.UserDao;
import edu.sdust.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;
import java.util.Set;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    public static final String SESSION_USER = "user";
    public static final String SESSION_NEXT = "next";

    private static final String VIEW = "/WEB-INF/views/public/login.jsp";
    private static final Set<String> ROLES = Set.of("student", "teacher", "counselor");
    private static final String BAD_CREDENTIALS = "login.error.credentials";

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute(SESSION_USER) != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        String role = normalizeRole(req.getParameter("role"));
        req.setAttribute("role", role);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String userId = trim(req.getParameter("userid"));
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        String role = normalizeRole(req.getParameter("loginas"));

        req.setAttribute("userid", userId);
        req.setAttribute("role", role);

        String error = validate(userId, password, role);
        if (error != null) {
            fail(req, resp, error);
            return;
        }
        if (!looksLikeId(userId, role) || password.length() > 64) {
            fail(req, resp, BAD_CREDENTIALS);
            return;
        }

        Optional<User> found;
        try {
            found = userDao.authenticate(userId, password);
        } catch (SQLException e) {
            log("Login failed because the database could not be reached", e);
            fail(req, resp, "login.error.database");
            return;
        }

        if (found.isEmpty() || !found.get().getRole().equals(role)) {
            fail(req, resp, BAD_CREDENTIALS);
            return;
        }

        User user = found.get();

        String next = null;
        HttpSession old = req.getSession(false);
        if (old != null) {
            Object saved = old.getAttribute(SESSION_NEXT);
            next = saved instanceof String ? (String) saved : null;
            old.invalidate();
        }
        HttpSession session = req.getSession(true);
        session.setAttribute(SESSION_USER, user);

        String dashboard = req.getContextPath() + "/dashboard";
        resp.sendRedirect(next != null && next.startsWith(dashboard) ? next : dashboard);
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String message) throws ServletException, IOException {
        req.setAttribute("error", message);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private static String validate(String userId, String password, String role) {
        if (role == null) {
            return "login.error.role";
        }
        String idLabel = "student".equals(role) ? "student" : "staff";
        if (userId.isEmpty() && password.isEmpty()) {
            return "login.error.missing." + idLabel;
        }
        if (userId.isEmpty()) {
            return "login.error.id." + idLabel;
        }
        if (password.isEmpty()) {
            return "login.error.password";
        }
        return null;
    }

    private static boolean looksLikeId(String userId, String role) {
        return "student".equals(role) ? userId.matches("\\d{12}") : userId.matches("[A-Za-z0-9]{4,20}");
    }

    private static String normalizeRole(String value) {
        if (value == null) {
            return null;
        }
        String role = value.trim().toLowerCase();
        return ROLES.contains(role) ? role : null;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
