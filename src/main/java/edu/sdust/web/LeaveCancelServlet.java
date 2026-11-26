package edu.sdust.web;

import edu.sdust.dao.LeaveDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/dashboard/leave/cancel",
        initParams = @WebInitParam(name = "roles", value = "student"))
public class LeaveCancelServlet extends HttpServlet {

    private final LeaveDao leaveDao = new LeaveDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);

        if (!FormSupport.tokenMatches(req)) {
            FormSupport.reply(resp, 403, null, Texts.of(req).get("srv.badtoken"));
            return;
        }

        LeaveDao.ReviewResult result;
        try {
            result = leaveDao.cancel(Integer.parseInt(FormSupport.value(req.getParameter("id"))), user.getId());
        } catch (NumberFormatException e) {
            result = LeaveDao.ReviewResult.NOT_FOUND;
        } catch (SQLException e) {
            log("Cancelling a leave request failed because the database could not be reached", e);
            FormSupport.reply(resp, 503, null, Texts.of(req).get("srv.db"));
            return;
        }

        switch (result) {
            case NOT_FOUND -> FormSupport.reply(resp, 404, null, Texts.of(req).get("srv.leave.missing"));
            case NOT_PENDING -> FormSupport.reply(resp, 409, null, Texts.of(req).get("srv.cancel.notpending"));
            default -> FormSupport.reply(resp, 200, null, Texts.of(req).get("srv.cancel.done"));
        }
    }
}
