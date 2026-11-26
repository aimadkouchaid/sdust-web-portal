package edu.sdust.web;

import edu.sdust.dao.ExamDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.Exam;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

@WebServlet(urlPatterns = {"/dashboard/teacher/exams/save", "/dashboard/teacher/exams/remove"},
        initParams = @WebInitParam(name = "roles", value = "teacher"))
public class ExamServlet extends HttpServlet {

    private static final Set<String> TYPES = Set.of("midterm", "final", "makeup");
    private static final LocalTime EARLIEST = LocalTime.of(7, 0);
    private static final LocalTime LATEST = LocalTime.of(22, 0);

    private final ExamDao examDao = new ExamDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);

        if (!FormSupport.tokenMatches(req)) {
            FormSupport.reply(resp, 403, null, Texts.of(req).get("srv.badtoken"));
            return;
        }
        try {
            if (req.getServletPath().endsWith("/remove")) {
                remove(req, resp, user);
            } else {
                save(req, resp, user);
            }
        } catch (SQLException e) {
            log("Saving an exam failed because the database could not be reached", e);
            FormSupport.reply(resp, 503, null, Texts.of(req).get("srv.db"));
        }
    }

    private void save(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException, SQLException {
        String classRaw = FormSupport.value(req.getParameter("exclass"));
        String type = FormSupport.value(req.getParameter("extype"));
        String location = FormSupport.value(req.getParameter("exlocation")).trim();
        String notes = FormSupport.value(req.getParameter("exnotes")).trim();

        int classId;
        try {
            classId = Integer.parseInt(classRaw);
        } catch (NumberFormatException e) {
            FormSupport.reply(resp, 400, "exclass", Texts.of(req).get("js.exam.v.class"));
            return;
        }
        if (!TYPES.contains(type)) {
            FormSupport.reply(resp, 400, "extype", Texts.of(req).get("js.exam.v.type"));
            return;
        }
        LocalDate date = date(req.getParameter("exdate"));
        LocalDate today = LocalDate.now();
        if (date == null) {
            FormSupport.reply(resp, 400, "exdate", Texts.of(req).get("js.exam.v.date"));
            return;
        }
        if (date.isBefore(today)) {
            FormSupport.reply(resp, 400, "exdate", Texts.of(req).get("js.exam.v.datepast"));
            return;
        }
        if (date.isAfter(today.plusYears(1))) {
            FormSupport.reply(resp, 400, "exdate", Texts.of(req).get("js.exam.v.dateyear"));
            return;
        }
        LocalTime start = time(req.getParameter("exstart"));
        if (start == null) {
            FormSupport.reply(resp, 400, "exstart", Texts.of(req).get("js.exam.v.start"));
            return;
        }
        if (start.isBefore(EARLIEST) || start.isAfter(LATEST)) {
            FormSupport.reply(resp, 400, "exstart", Texts.of(req).get("js.exam.v.hours"));
            return;
        }
        LocalTime end = time(req.getParameter("exend"));
        if (end == null) {
            FormSupport.reply(resp, 400, "exend", Texts.of(req).get("js.exam.v.end"));
            return;
        }
        if (!end.isAfter(start)) {
            FormSupport.reply(resp, 400, "exend", Texts.of(req).get("js.exam.v.endbefore"));
            return;
        }
        if (end.isAfter(LATEST)) {
            FormSupport.reply(resp, 400, "exend", Texts.of(req).get("js.exam.v.hours"));
            return;
        }
        if (Duration.between(start, end).toMinutes() > 240) {
            FormSupport.reply(resp, 400, "exend", Texts.of(req).get("js.exam.v.long"));
            return;
        }
        if (date.equals(today) && !start.isAfter(LocalTime.now())) {
            FormSupport.reply(resp, 400, "exstart", Texts.of(req).get("srv.exam.start.passed"));
            return;
        }
        if (location.isEmpty()) {
            FormSupport.reply(resp, 400, "exlocation", Texts.of(req).get("js.exam.v.room"));
            return;
        }
        if (location.length() > 100) {
            FormSupport.reply(resp, 400, "exlocation", Texts.of(req).get("js.exam.v.roomlong"));
            return;
        }
        if (notes.length() > 500) {
            FormSupport.reply(resp, 400, "exnotes", Texts.of(req).get("js.exam.v.notes"));
            return;
        }

        ExamDao.Result result = examDao.create(new ExamDao.NewExam(classId, type, date, start, end, location, notes, user.getId()));
        if (result.problem() != null) {
            switch (result.problem()) {
                case NOT_YOUR_CLASS -> FormSupport.reply(resp, 400, "exclass", Texts.of(req).get("srv.exam.notyourclass"));
                case DUPLICATE -> FormSupport.reply(resp, 409, "extype", Texts.of(req).format("srv.exam.duplicate", Texts.of(req).get("exam.type." + type).toLowerCase(Texts.of(req).getLocale())));
                case ROOM_CLASH -> FormSupport.reply(resp, 409, "exlocation", Texts.of(req).format("srv.exam.roomclash", clash(req, result.detail())));
                default -> FormSupport.reply(resp, 409, "exstart", Texts.of(req).format("srv.exam.studentclash", clash(req, result.detail())));
            }
            return;
        }
        Exam exam = result.exam();
        Texts tx = Texts.of(req);
        FormSupport.reply(resp, 200, null, tx.format(exam.studentCount() == 1 ? "srv.exam.saved.one" : "srv.exam.saved.many",
                exam.typeText(tx).toLowerCase(tx.getLocale()), exam.courseName(), exam.studentCount()), fields(exam, tx));
    }

    private void remove(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException, SQLException {
        int id;
        try {
            id = Integer.parseInt(FormSupport.value(req.getParameter("id")));
        } catch (NumberFormatException e) {
            FormSupport.reply(resp, 404, null, Texts.of(req).get("srv.exam.missing"));
            return;
        }
        ExamDao.Result result = examDao.remove(id, user.getId());
        if (result.problem() == ExamDao.Problem.NOT_FOUND) {
            FormSupport.reply(resp, 404, null, Texts.of(req).get("srv.exam.notyours"));
        } else if (result.problem() == ExamDao.Problem.PAST) {
            FormSupport.reply(resp, 409, null, Texts.of(req).get("srv.exam.past"));
        } else {
            FormSupport.reply(resp, 200, null, Texts.of(req).get("srv.exam.removed"));
        }
    }

    private static String clash(HttpServletRequest req, String detail) {
        int bar = detail.lastIndexOf('|');
        Texts tx = Texts.of(req);
        return bar < 0 ? detail : detail.substring(0, bar) + " " + tx.get("exam.type." + detail.substring(bar + 1)).toLowerCase(tx.getLocale());
    }

    private static Map<String, String> fields(Exam e, Texts tx) {
        Map<String, String> map = new LinkedHashMap<>();
        map.put("id", String.valueOf(e.id()));
        map.put("type", e.examType());
        map.put("typeText", e.typeText(tx));
        map.put("course", e.courseName());
        map.put("code", e.courseCode());
        map.put("date", e.dateText(tx));
        map.put("time", e.timeText());
        map.put("month", e.monthText(tx));
        map.put("day", e.dayText());
        map.put("weekday", e.weekdayText(tx));
        map.put("when", e.whenText(tx));
        map.put("location", e.location());
        map.put("notes", e.notes() == null ? "" : e.notes());
        map.put("students", String.valueOf(e.studentCount()));
        map.put("sort", e.sortKey());
        return map;
    }

    private static LocalDate date(String value) {
        try {
            return value == null || value.isEmpty() ? null : LocalDate.parse(value);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private static LocalTime time(String value) {
        try {
            return value == null || value.isEmpty() ? null : LocalTime.parse(value);
        } catch (DateTimeParseException e) {
            return null;
        }
    }
}
