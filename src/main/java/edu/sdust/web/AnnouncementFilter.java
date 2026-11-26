package edu.sdust.web;

import edu.sdust.dao.AnnouncementDao;
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

@WebFilter({"/dashboard/announcements", "/dashboard/teacher/announcements", "/dashboard/counselor/announcements"})
public class AnnouncementFilter extends HttpFilter {

    private final AnnouncementDao announcementDao = new AnnouncementDao();
    private final ExamDao examDao = new ExamDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User current) {
            try {
                req.setAttribute("announcements", announcementDao.forUser(current.getId(), current.getRole()));
                if (!"student".equals(current.getRole())) {
                    req.setAttribute("mine", announcementDao.byAuthor(current.getId()));
                }
                if ("teacher".equals(current.getRole())) {
                    req.setAttribute("classes", examDao.teacherClasses(current.getId()));
                }
            } catch (SQLException e) {
                getServletContext().log("Could not load announcements", e);
                req.setAttribute("announcementsError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
