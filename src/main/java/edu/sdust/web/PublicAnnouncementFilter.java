package edu.sdust.web;

import edu.sdust.dao.AnnouncementDao;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebFilter("/news-announcements")
public class PublicAnnouncementFilter extends HttpFilter {

    private final AnnouncementDao announcementDao = new AnnouncementDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        try {
            req.setAttribute("announcements", announcementDao.publicOnes());
        } catch (SQLException e) {
            getServletContext().log("Could not load public announcements", e);
            req.setAttribute("announcementsError", true);
        }
        chain.doFilter(req, resp);
    }
}
