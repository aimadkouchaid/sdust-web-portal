package edu.sdust.web;

import edu.sdust.dao.LeaveDao;
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

@WebFilter("/dashboard/counselor/leave")
public class CounselorLeaveFilter extends HttpFilter {

    private final LeaveDao leaveDao = new LeaveDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User && "counselor".equals(((User) user).getRole())) {
            try {
                req.setAttribute("requests", leaveDao.forCounselor(((User) user).getId()));
            } catch (SQLException e) {
                getServletContext().log("Could not load leave requests", e);
                req.setAttribute("requestsError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
