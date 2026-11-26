package edu.sdust.web;

import edu.sdust.dao.NotificationDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/dashboard/notifications/read", "/dashboard/notifications/clear"},
        initParams = @WebInitParam(name = "roles", value = "student,teacher,counselor"))
public class NotificationServlet extends HttpServlet {

    private final NotificationDao notificationDao = new NotificationDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);

        if (!FormSupport.tokenMatches(req)) {
            FormSupport.reply(resp, 403, null, Texts.of(req).get("srv.badtoken"));
            return;
        }

        String id = FormSupport.value(req.getParameter("id"));
        boolean clear = req.getServletPath().endsWith("/clear");
        try {
            if (clear) {
                notificationDao.clearAll(user.getId());
            } else if (id.isEmpty()) {
                notificationDao.markAllRead(user.getId());
            } else {
                notificationDao.markRead(user.getId(), Integer.parseInt(id));
            }
        } catch (NumberFormatException e) {
            FormSupport.reply(resp, 400, null, Texts.of(req).get("srv.ntf.missing"));
            return;
        } catch (SQLException e) {
            log("Updating notifications failed", e);
            FormSupport.reply(resp, 503, null, Texts.of(req).get("srv.db.short"));
            return;
        }
        FormSupport.reply(resp, 200, null, clear ? "Notifications cleared." : "Marked as read.");
    }
}
