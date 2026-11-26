package edu.sdust.web;

import edu.sdust.dao.GradeEntryDao;
import edu.sdust.model.GradeClass;
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
import java.util.List;

@WebFilter("/dashboard/teacher/grades")
public class GradeEntryFilter extends HttpFilter {

    private final GradeEntryDao gradeEntryDao = new GradeEntryDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User current && "teacher".equals(current.getRole())) {
            try {
                List<GradeClass> classes = gradeEntryDao.classes(current.getId());
                GradeClass chosen = null;
                String param = req.getParameter("class");
                for (GradeClass c : classes) {
                    if (String.valueOf(c.id()).equals(param)) {
                        chosen = c;
                    }
                }
                if (chosen == null) {
                    chosen = classes.stream().filter(c -> c.ungraded() > 0).findFirst()
                            .orElse(classes.isEmpty() ? null : classes.get(0));
                }
                req.setAttribute("classes", classes);
                req.setAttribute("chosen", chosen);
                if (chosen != null) {
                    req.setAttribute("rows", gradeEntryDao.students(chosen.id()));
                }
            } catch (SQLException e) {
                getServletContext().log("Could not load grade entry", e);
                req.setAttribute("entryError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
