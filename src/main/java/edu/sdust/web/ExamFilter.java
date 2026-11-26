package edu.sdust.web;

import edu.sdust.dao.ExamDao;
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

@WebFilter({"/dashboard/exams", "/dashboard/teacher/exams"})
public class ExamFilter extends HttpFilter {

    private final ExamDao examDao = new ExamDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User current) {
            try {
                if ("student".equals(current.getRole())) {
                    req.setAttribute("exams", examDao.forStudent(current.getId()));
                } else if ("teacher".equals(current.getRole())) {
                    req.setAttribute("exams", examDao.forTeacher(current.getId()));
                    req.setAttribute("classes", examDao.teacherClasses(current.getId()));
                }
            } catch (SQLException e) {
                getServletContext().log("Could not load exams", e);
                req.setAttribute("examsError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
