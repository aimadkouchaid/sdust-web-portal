package edu.sdust.web;

import edu.sdust.dao.GradeDao;
import edu.sdust.model.GradeRow;
import edu.sdust.model.GradeSummary;
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
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@WebFilter("/dashboard/grades")
public class GradesFilter extends HttpFilter {

    private final GradeDao gradeDao = new GradeDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User current && "student".equals(current.getRole())) {
            try {
                List<GradeRow> all = gradeDao.forStudent(current.getId());
                Set<String> semesters = new LinkedHashSet<>();
                String latestGraded = null;
                for (GradeRow row : all) {
                    semesters.add(row.semester());
                    if (latestGraded == null && row.graded()) {
                        latestGraded = row.semester();
                    }
                }
                String chosen = req.getParameter("semester");
                if (chosen == null || !semesters.contains(chosen)) {
                    chosen = latestGraded != null ? latestGraded : semesters.stream().findFirst().orElse(null);
                }
                List<GradeRow> rows = new ArrayList<>();
                for (GradeRow row : all) {
                    if (row.semester().equals(chosen) && row.graded()) {
                        rows.add(row);
                    }
                }
                req.setAttribute("semesters", new ArrayList<>(semesters));
                req.setAttribute("semester", chosen);
                req.setAttribute("grades", rows);
                req.setAttribute("summary", GradeSummary.of(rows));
                req.setAttribute("overall", GradeSummary.of(all));
            } catch (SQLException e) {
                getServletContext().log("Could not load grades", e);
                req.setAttribute("gradesError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
