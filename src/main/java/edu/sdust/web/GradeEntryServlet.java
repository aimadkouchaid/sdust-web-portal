package edu.sdust.web;

import edu.sdust.dao.GradeEntryDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.GradeClass;
import edu.sdust.model.GradeSummary;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = "/dashboard/teacher/grades/save",
        initParams = @WebInitParam(name = "roles", value = "teacher"))
public class GradeEntryServlet extends HttpServlet {

    private static final Map<String, BigDecimal> LEVELS = Map.of(
            "excellent", new BigDecimal("95"),
            "good", new BigDecimal("85"),
            "medium", new BigDecimal("75"),
            "pass", new BigDecimal("65"),
            "fail", BigDecimal.ZERO);

    private final GradeEntryDao gradeEntryDao = new GradeEntryDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);
        Texts tx = Texts.of(req);
        if (!FormSupport.tokenMatches(req)) {
            FormSupport.reply(resp, 403, null, tx.get("srv.badtoken"));
            return;
        }
        int classId;
        try {
            classId = Integer.parseInt(FormSupport.value(req.getParameter("class")));
        } catch (NumberFormatException e) {
            FormSupport.reply(resp, 404, null, tx.get("srv.ge.notyours"));
            return;
        }

        List<GradeEntryDao.Entry> entries = new ArrayList<>();
        Enumeration<String> names = req.getParameterNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            if (!name.startsWith("score-")) {
                continue;
            }
            int id;
            try {
                id = Integer.parseInt(name.substring(6));
            } catch (NumberFormatException e) {
                continue;
            }
            String raw = FormSupport.value(req.getParameter(name)).trim();
            String level = FormSupport.value(req.getParameter("level-" + id)).trim();
            if (!level.isEmpty()) {
                if (!LEVELS.containsKey(level)) {
                    FormSupport.reply(resp, 400, name, tx.get("js.ge.v.level"));
                    return;
                }
                entries.add(new GradeEntryDao.Entry(id, LEVELS.get(level), level));
                continue;
            }
            if (raw.isEmpty()) {
                continue;
            }
            BigDecimal score;
            try {
                score = new BigDecimal(raw);
            } catch (NumberFormatException e) {
                FormSupport.reply(resp, 400, name, tx.get("js.ge.v.number"));
                return;
            }
            if (score.signum() < 0 || score.compareTo(BigDecimal.valueOf(100)) > 0 || score.scale() > 1) {
                FormSupport.reply(resp, 400, name, tx.get("js.ge.v.number"));
                return;
            }
            entries.add(new GradeEntryDao.Entry(id, score, null));
        }
        if (entries.isEmpty()) {
            FormSupport.reply(resp, 400, null, tx.get("js.ge.v.none"));
            return;
        }

        List<GradeEntryDao.Saved> saved;
        try {
            saved = gradeEntryDao.save(user.getId(), classId, entries);
        } catch (SQLException e) {
            if ("45000".equals(e.getSQLState())) {
                FormSupport.reply(resp, 409, null, tx.get("srv.ge.final"));
                return;
            }
            log("Saving grades failed because the database could not be reached", e);
            FormSupport.reply(resp, 503, null, tx.get("srv.db"));
            return;
        }
        if (saved == null) {
            FormSupport.reply(resp, 404, null, tx.get("srv.ge.notyours"));
            return;
        }
        if (saved.isEmpty()) {
            FormSupport.reply(resp, 409, null, tx.get("srv.ge.final"));
            return;
        }
        Map<String, String> data = new LinkedHashMap<>();
        StringBuilder ids = new StringBuilder();
        for (GradeEntryDao.Saved s : saved) {
            if (ids.length() > 0) {
                ids.append(',');
            }
            ids.append(s.enrollmentId());
            data.put("score-" + s.enrollmentId(), s.level() != null ? tx.get("gr.level." + s.level()) : GradeSummary.number(s.score()));
            data.put("point-" + s.enrollmentId(), GradeSummary.point(s.gradePoint()));
        }
        data.put("saved", ids.toString());
        try {
            for (GradeClass c : gradeEntryDao.classes(user.getId())) {
                if (c.id() == classId) {
                    data.put("avgScore", c.avgScoreText());
                    data.put("avgPoint", c.avgPointText());
                    data.put("graded", c.graded() + " / " + c.students());
                }
            }
        } catch (SQLException e) {
            log("Reloading the class averages failed", e);
        }
        int skipped = entries.size() - saved.size();
        String message = tx.format(saved.size() == 1 ? "srv.ge.saved.one" : "srv.ge.saved.many", saved.size());
        if (skipped > 0) {
            message += " " + tx.format("srv.ge.skipped", skipped);
        }
        FormSupport.reply(resp, 200, null, message, data);
    }
}
