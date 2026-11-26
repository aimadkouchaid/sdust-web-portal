package edu.sdust.web;

import edu.sdust.dao.NotificationDao;
import edu.sdust.model.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebFilter("/dashboard/*")
public class NotificationFilter extends HttpFilter {

    private static final int LIMIT = 20;

    private final NotificationDao notificationDao = new NotificationDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        String role = user instanceof User ? ((User) user).getRole() : null;
        if ("GET".equals(req.getMethod()) && role != null) {
            try {
                req.setAttribute("notifications", notificationDao.forUser(((User) user).getId(), LIMIT));
            } catch (SQLException e) {
                getServletContext().log("Could not load notifications", e);
                req.setAttribute("notificationsError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
