package edu.sdust.web;

import edu.sdust.dao.UserDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/dashboard/profile/password",
        initParams = @WebInitParam(name = "roles", value = "student,teacher,counselor"))
public class PasswordServlet extends HttpServlet {

    private static final int MAX_ATTEMPTS = 5;
    private static final long LOCK_MILLIS = 15 * 60 * 1000L;
    private static final String SESSION_FAILS = "passwordFails";
    private static final String SESSION_LOCKED = "passwordLockedUntil";

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute(LoginServlet.SESSION_USER);

        if (!FormSupport.tokenMatches(req)) {
            FormSupport.reply(resp, 403, null, Texts.of(req).get("srv.badtoken"));
            return;
        }

        Object lockedUntil = session.getAttribute(SESSION_LOCKED);
        if (lockedUntil instanceof Long && (Long) lockedUntil > System.currentTimeMillis()) {
            FormSupport.reply(resp, 429, null, Texts.of(req).get("srv.pass.locked"));
            return;
        }

        String current = FormSupport.value(req.getParameter("currentpass"));
        String next = FormSupport.value(req.getParameter("newpass"));
        String confirm = FormSupport.value(req.getParameter("confirmpass"));

        if (current.isEmpty()) {
            FormSupport.reply(resp, 400, "currentpass", Texts.of(req).get("js.pass.v.current"));
            return;
        }
        String problem = checkNew(next, current);
        if (problem != null) {
            FormSupport.reply(resp, 400, "newpass", Texts.of(req).get(problem));
            return;
        }
        if (confirm.isEmpty()) {
            FormSupport.reply(resp, 400, "confirmpass", Texts.of(req).get("js.pass.v.confirm"));
            return;
        }
        if (!confirm.equals(next)) {
            FormSupport.reply(resp, 400, "confirmpass", Texts.of(req).get("js.pass.v.match"));
            return;
        }

        try {
            if (current.length() > 64 || !userDao.passwordMatches(user.getId(), current)) {
                int fails = session.getAttribute(SESSION_FAILS) instanceof Integer ? (Integer) session.getAttribute(SESSION_FAILS) + 1 : 1;
                if (fails >= MAX_ATTEMPTS) {
                    session.setAttribute(SESSION_LOCKED, System.currentTimeMillis() + LOCK_MILLIS);
                    session.removeAttribute(SESSION_FAILS);
                    FormSupport.reply(resp, 429, null, Texts.of(req).get("srv.pass.locked"));
                } else {
                    session.setAttribute(SESSION_FAILS, fails);
                    FormSupport.reply(resp, 400, "currentpass", Texts.of(req).get("srv.pass.wrong"));
                }
                return;
            }
            userDao.updatePassword(user.getId(), next);
        } catch (SQLException e) {
            log("Password change failed because the database could not be reached", e);
            FormSupport.reply(resp, 503, null, Texts.of(req).get("srv.db"));
            return;
        }

        session.removeAttribute(SESSION_FAILS);
        session.removeAttribute(SESSION_LOCKED);
        req.changeSessionId();
        FormSupport.reply(resp, 200, null, Texts.of(req).get("srv.pass.changed"));
    }

    private static String checkNew(String next, String current) {
        if (next.isEmpty()) {
            return "js.pass.v.new";
        }
        if (next.length() < 8) {
            return "js.pass.v.short";
        }
        if (next.length() > 64) {
            return "js.pass.v.long";
        }
        if (!next.matches(".*[A-Za-z].*") || !next.matches(".*\\d.*")) {
            return "js.pass.v.mix";
        }
        if (next.equals(current)) {
            return "js.pass.v.same";
        }
        return null;
    }
}
