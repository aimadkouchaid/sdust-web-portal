package edu.sdust.web;

import edu.sdust.dao.StudentDao;
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

@WebFilter("/dashboard/counselor/students")
public class CounselorStudentsFilter extends HttpFilter {

    private final StudentDao studentDao = new StudentDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User current && "counselor".equals(current.getRole())) {
            try {
                req.setAttribute("students", studentDao.forCounselor(current.getId()));
            } catch (SQLException e) {
                getServletContext().log("Could not load the counselor's students", e);
                req.setAttribute("studentsError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
