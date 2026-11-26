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
import java.time.LocalDateTime;
import java.util.Map;

@WebServlet(urlPatterns = "/dashboard/counselor/leave/review",
        initParams = @WebInitParam(name = "roles", value = "counselor"))
public class LeaveReviewServlet extends HttpServlet {

    private static final int MAX_COMMENT = 500;

    private final LeaveDao leaveDao = new LeaveDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);

        if (!FormSupport.tokenMatches(req)) {
            FormSupport.reply(resp, 403, null, Texts.of(req).get("srv.badtoken"));
            return;
        }

        String decision = FormSupport.value(req.getParameter("decision"));
        String comment = FormSupport.value(req.getParameter("comment")).trim();
        int id;
        try {
            id = Integer.parseInt(FormSupport.value(req.getParameter("id")));
        } catch (NumberFormatException e) {
            FormSupport.reply(resp, 400, null, Texts.of(req).get("srv.leave.missing"));
            return;
        }
        if (!"approve".equals(decision) && !"reject".equals(decision)) {
            FormSupport.reply(resp, 400, null, Texts.of(req).get("srv.review.decision"));
            return;
        }
        boolean approve = "approve".equals(decision);
        if (!approve && comment.isEmpty()) {
            FormSupport.reply(resp, 400, "comment", Texts.of(req).get("js.review.v.comment"));
            return;
        }
        if (comment.length() > MAX_COMMENT) {
            FormSupport.reply(resp, 400, "comment", Texts.of(req).format("srv.review.long", MAX_COMMENT));
            return;
        }

        LeaveDao.ReviewResult result;
        try {
            result = leaveDao.review(id, user.getId(), user.getName(), approve, comment);
        } catch (SQLException e) {
            log("Leave review failed because the database could not be reached", e);
            FormSupport.reply(resp, 503, null, Texts.of(req).get("srv.db"));
            return;
        }

        switch (result) {
            case NOT_FOUND -> FormSupport.reply(resp, 404, null, Texts.of(req).get("srv.review.notyours"));
            case NOT_PENDING -> FormSupport.reply(resp, 409, null, Texts.of(req).get("srv.review.notpending"));
            default -> {
                String status = approve ? "approved" : "rejected";
                FormSupport.reply(resp, 200, null, Texts.of(req).get("srv.review." + status), Map.of(
                        "status", status,
                        "statusText", Texts.of(req).get("leave.status." + status),
                        "reviewer", user.getName(),
                        "reviewed", Texts.of(req).date(LocalDateTime.now()),
                        "comment", comment));
            }
        }
    }
}
