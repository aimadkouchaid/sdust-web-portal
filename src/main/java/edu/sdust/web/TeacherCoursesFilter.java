package edu.sdust.web;

import edu.sdust.dao.CourseDao;
import edu.sdust.model.TeacherCourse;
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

@WebFilter("/dashboard/teacher/courses")
public class TeacherCoursesFilter extends HttpFilter {

    private final CourseDao courseDao = new CourseDao();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);
        if (user instanceof User current && "teacher".equals(current.getRole())) {
            try {
                List<TeacherCourse> courses = courseDao.forTeacher(current.getId());
                int classes = 0;
                int students = 0;
                int ungraded = 0;
                for (TeacherCourse c : courses) {
                    if (c.current()) {
                        classes++;
                        students += c.students();
                    }
                    ungraded += c.students() - c.graded();
                }
                req.setAttribute("courses", courses);
                req.setAttribute("currentClasses", classes);
                req.setAttribute("currentStudents", students);
                req.setAttribute("ungraded", ungraded);
            } catch (SQLException e) {
                getServletContext().log("Could not load the teacher's courses", e);
                req.setAttribute("coursesError", true);
            }
        }
        chain.doFilter(req, resp);
    }
}
