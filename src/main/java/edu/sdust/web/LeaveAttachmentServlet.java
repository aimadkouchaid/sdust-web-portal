package edu.sdust.web;

import edu.sdust.dao.LeaveDao;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/dashboard/leave/attachment",
        initParams = @WebInitParam(name = "roles", value = "student,counselor"))
public class LeaveAttachmentServlet extends HttpServlet {

    private final LeaveDao leaveDao = new LeaveDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);

        LeaveDao.Attachment attachment;
        try {
            attachment = leaveDao.attachment(Integer.parseInt(FormSupport.value(req.getParameter("id"))));
        } catch (NumberFormatException e) {
            attachment = null;
        } catch (SQLException e) {
            log("Loading a leave attachment failed because the database could not be reached", e);
            resp.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            return;
        }

        boolean allowed = attachment != null
                && (user.getId().equals(attachment.studentId()) || user.getId().equals(attachment.counselorId()));
        Path path = allowed ? UploadStore.resolve(attachment.path()) : null;
        if (path == null || !Files.isRegularFile(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String type = getServletContext().getMimeType(attachment.name());
        resp.setContentType(type == null ? "application/octet-stream" : type);
        resp.setContentLengthLong(Files.size(path));
        resp.setHeader("X-Content-Type-Options", "nosniff");
        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''"
                + URLEncoder.encode(attachment.name(), StandardCharsets.UTF_8).replace("+", "%20"));
        Files.copy(path, resp.getOutputStream());
    }
}
