package edu.sdust.web;

import edu.sdust.dao.TimetableDao;
import edu.sdust.model.TimetableCell;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebFilter({"/dashboard/timetable", "/dashboard/teacher/timetable"})
public class TimetableFilter extends HttpFilter {

    private final TimetableDao timetableDao = new TimetableDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User current && ("teacher".equals(current.getRole()) || "student".equals(current.getRole()))) {
            try {
                TimetableDao.Timetable timetable = timetableDao.forUser(current.getId(), current.getRole());
                Map<Integer, Integer> colors = new HashMap<>();
                Map<String, List<String>> weeks = new LinkedHashMap<>();
                for (TimetableDao.Session s : timetable.sessions()) {
                    weeks.computeIfAbsent(s.classId() + ":" + s.day() + ":" + s.startPeriod(), k -> new ArrayList<>())
                            .add(s.startWeek() == s.endWeek() ? String.valueOf(s.startWeek()) : s.startWeek() + "–" + s.endWeek());
                }
                List<TimetableCell> cells = new ArrayList<>();
                for (TimetableDao.Session s : timetable.sessions()) {
                    int color = colors.computeIfAbsent(s.classId(), id -> colors.size() % 6 + 1);
                    int slot = Math.min(5, (s.startPeriod() + 1) / 2);
                    int span = Math.max(1, Math.min(6 - slot, (s.endPeriod() - s.startPeriod() + 2) / 2));
                    List<String> all = weeks.get(s.classId() + ":" + s.day() + ":" + s.startPeriod());
                    cells.add(new TimetableCell(s.day(), slot, span, color, s.courseCode(), s.courseName(), s.location(),
                            s.students(), s.teacherName(), s.startWeek(), s.endWeek(), String.join(", ", all),
                            all.size() == 1 && !all.get(0).contains("–")));
                }
                req.setAttribute("timetable", timetable);
                req.setAttribute("cells", cells);
                req.setAttribute("classCount", colors.size());
            } catch (SQLException e) {
                getServletContext().log("Could not load the timetable", e);
                req.setAttribute("timetableError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
