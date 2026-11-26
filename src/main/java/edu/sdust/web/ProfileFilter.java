package edu.sdust.web;

import edu.sdust.dao.ProfileDao;
import edu.sdust.dao.UserDao;
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

@WebFilter("/dashboard/profile")
public class ProfileFilter extends HttpFilter {

    private final UserDao userDao = new UserDao();
    private final ProfileDao profileDao = new ProfileDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User) {
            User current = (User) user;
            try {
                req.setAttribute("profile", profileDao.find(current.getId(), current.getRole()).orElse(null));
            } catch (SQLException e) {
                getServletContext().log("Could not load profile", e);
                req.setAttribute("profileError", true);
            }
            try {
                req.setAttribute("contact", userDao.findContact(current.getId()));
            } catch (SQLException e) {
                getServletContext().log("Could not load contact info", e);
                req.setAttribute("contactError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
