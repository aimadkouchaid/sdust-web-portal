package edu.sdust.web;

import edu.sdust.dao.AnnouncementDao;
import edu.sdust.dao.ExamDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.Announcement;
import edu.sdust.model.ClassOption;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(urlPatterns = {"/dashboard/announcements/post", "/dashboard/announcements/delete"},
        initParams = @WebInitParam(name = "roles", value = "teacher,counselor"))
public class AnnouncementServlet extends HttpServlet {

    private static final Set<String> COUNSELOR_AUDIENCES = Set.of("student", "teacher", "all");

    private final AnnouncementDao announcementDao = new AnnouncementDao();
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
            if (req.getServletPath().endsWith("/delete")) {
                delete(req, resp, user);
            } else {
                post(req, resp, user);
            }
        } catch (SQLException e) {
            log("Saving an announcement failed because the database could not be reached", e);
            FormSupport.reply(resp, 503, null, Texts.of(req).get("srv.db"));
        }
    }

    private void post(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException, SQLException {
        String category = FormSupport.value(req.getParameter("ancategory"));
        String audience = FormSupport.value(req.getParameter("anaudience"));
        String title = FormSupport.value(req.getParameter("antitle")).trim();
        String summary = FormSupport.value(req.getParameter("ansummary")).trim();
        String body = FormSupport.value(req.getParameter("anbody")).replace("\r\n", "\n").trim();

        if (!Announcement.isCategory(category)) {
            FormSupport.reply(resp, 400, "ancategory", Texts.of(req).get("js.an.v.category"));
            return;
        }
        List<Integer> classIds = new ArrayList<>();
        if ("teacher".equals(user.getRole())) {
            List<ClassOption> classes = examDao.teacherClasses(user.getId());
            if (classes.isEmpty()) {
                FormSupport.reply(resp, 400, "anaudience", Texts.of(req).get("srv.an.noclasses"));
                return;
            }
            for (ClassOption c : classes) {
                if ("mine".equals(audience) || String.valueOf(c.id()).equals(audience)) {
                    classIds.add(c.id());
                }
            }
            if (classIds.isEmpty()) {
                FormSupport.reply(resp, 400, "anaudience", Texts.of(req).get("srv.an.pickclass"));
                return;
            }
            audience = "student";
        } else if (!COUNSELOR_AUDIENCES.contains(audience)) {
            FormSupport.reply(resp, 400, "anaudience", Texts.of(req).get("js.an.v.audience"));
            return;
        }
        if (title.length() < 5) {
            FormSupport.reply(resp, 400, "antitle", Texts.of(req).get("js.an.v.titleshort"));
            return;
        }
        if (title.length() > 200) {
            FormSupport.reply(resp, 400, "antitle", Texts.of(req).get("js.an.v.titlelong"));
            return;
        }
        if (summary.length() < 10) {
            FormSupport.reply(resp, 400, "ansummary", Texts.of(req).get("js.an.v.summaryshort"));
            return;
        }
        if (summary.length() > 500) {
            FormSupport.reply(resp, 400, "ansummary", Texts.of(req).get("js.an.v.summarylong"));
            return;
        }
        if (body.length() < 10) {
            FormSupport.reply(resp, 400, "anbody", Texts.of(req).get("js.an.v.bodyshort"));
            return;
        }
        if (body.length() > 5000) {
            FormSupport.reply(resp, 400, "anbody", Texts.of(req).get("js.an.v.bodylong"));
            return;
        }

        AnnouncementDao.Created created = announcementDao.create(
                new AnnouncementDao.NewAnnouncement(user.getId(), category, audience, classIds, title, summary, body));
        Announcement a = created.announcement();
        int n = created.notified();
        Map<String, String> data = new LinkedHashMap<>();
        data.put("id", String.valueOf(a.id()));
        data.put("category", a.category());
        data.put("categoryText", a.categoryText(Texts.of(req)));
        data.put("audience", a.audience());
        data.put("audienceText", a.audienceText(Texts.of(req)));
        data.put("title", a.title());
        data.put("from", a.fromText());
        data.put("date", a.dateText(Texts.of(req)));
        data.put("iso", a.isoDate());
        data.put("summary", a.summary());
        data.put("body", a.body());
        FormSupport.reply(resp, 200, null, Texts.of(req).format(n == 1 ? "srv.an.published.one" : "srv.an.published.many", n), data);
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException, SQLException {
        int id;
        try {
            id = Integer.parseInt(FormSupport.value(req.getParameter("id")));
        } catch (NumberFormatException e) {
            FormSupport.reply(resp, 404, null, Texts.of(req).get("srv.an.missing"));
            return;
        }
        if (!announcementDao.remove(id, user.getId())) {
            FormSupport.reply(resp, 404, null, Texts.of(req).get("srv.an.notyours"));
            return;
        }
        FormSupport.reply(resp, 200, null, Texts.of(req).get("srv.an.deleted"));
    }
}
