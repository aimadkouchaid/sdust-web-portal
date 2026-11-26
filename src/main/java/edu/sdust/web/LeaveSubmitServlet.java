package edu.sdust.web;

import edu.sdust.dao.LeaveDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.LeaveRequest;
import edu.sdust.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = "/dashboard/leave/submit",
        initParams = @WebInitParam(name = "roles", value = "student"))
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = LeaveSubmitServlet.MAX_FILE, maxRequestSize = LeaveSubmitServlet.MAX_FILE + 1024 * 1024)
public class LeaveSubmitServlet extends HttpServlet {

    static final long MAX_FILE = 5L * 1024 * 1024;

    private static final Set<String> TYPES = Set.of("sick", "personal", "emergency", "officialactivity");
    private static final Set<String> EXTENSIONS = Set.of("pdf", "jpg", "jpeg", "png", "doc", "docx");
    private static final Pattern PHONE = Pattern.compile("1[3-9]\\d{9}");
    private static final int MAX_DAYS = 30;
    private static final int PAST_DAYS = 7;

    private final LeaveDao leaveDao = new LeaveDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);

        Part file;
        try {
            file = req.getPart("att");
        } catch (IllegalStateException e) {
            FormSupport.reply(resp, 400, "att", Texts.of(req).get("js.leave.v.filesize"));
            return;
        }

        if (!FormSupport.tokenMatches(req)) {
            FormSupport.reply(resp, 403, null, Texts.of(req).get("srv.badtoken"));
            return;
        }

        String type = FormSupport.value(req.getParameter("leavetype"));
        String startRaw = FormSupport.value(req.getParameter("startdate"));
        String endRaw = FormSupport.value(req.getParameter("enddate"));
        String destination = FormSupport.value(req.getParameter("dest")).trim();
        String rawPhone = FormSupport.value(req.getParameter("contactnum")).trim();
        String phone = rawPhone.replaceAll("[\\s-]", "").replaceFirst("^\\+?86", "");
        String reason = FormSupport.value(req.getParameter("reason")).trim();

        if (!TYPES.contains(type)) {
            FormSupport.reply(resp, 400, "leavetype", Texts.of(req).get("js.leave.v.type"));
            return;
        }
        LocalDate today = LocalDate.now();
        LocalDate start = parse(startRaw);
        if (start == null) {
            FormSupport.reply(resp, 400, "startdate", Texts.of(req).get("js.leave.v.start"));
            return;
        }
        if (start.isBefore(today.minusDays(PAST_DAYS))) {
            FormSupport.reply(resp, 400, "startdate", Texts.of(req).format("srv.leave.startpast", PAST_DAYS));
            return;
        }
        if (start.isAfter(today.plusYears(1))) {
            FormSupport.reply(resp, 400, "startdate", Texts.of(req).get("js.leave.v.startyear"));
            return;
        }
        LocalDate end = parse(endRaw);
        if (end == null) {
            FormSupport.reply(resp, 400, "enddate", Texts.of(req).get("js.leave.v.end"));
            return;
        }
        if (end.isBefore(start)) {
            FormSupport.reply(resp, 400, "enddate", Texts.of(req).get("js.leave.v.endbefore"));
            return;
        }
        if (ChronoUnit.DAYS.between(start, end) + 1 > MAX_DAYS) {
            FormSupport.reply(resp, 400, "enddate", Texts.of(req).format("srv.leave.long", MAX_DAYS));
            return;
        }
        if (destination.isEmpty()) {
            FormSupport.reply(resp, 400, "dest", Texts.of(req).get("js.leave.v.dest"));
            return;
        }
        if (destination.length() > 100) {
            FormSupport.reply(resp, 400, "dest", Texts.of(req).get("js.leave.v.destlong"));
            return;
        }
        if (rawPhone.isEmpty()) {
            FormSupport.reply(resp, 400, "contactnum", Texts.of(req).get("js.leave.v.contact"));
            return;
        }
        if (!PHONE.matcher(phone).matches()) {
            FormSupport.reply(resp, 400, "contactnum", Texts.of(req).get("js.phone.invalid"));
            return;
        }
        if (reason.length() < 10) {
            FormSupport.reply(resp, 400, "reason", Texts.of(req).get(reason.isEmpty() ? "js.leave.v.reason" : "js.leave.v.reasonshort"));
            return;
        }
        if (reason.length() > 1000) {
            FormSupport.reply(resp, 400, "reason", Texts.of(req).get("js.leave.v.reasonlong"));
            return;
        }

        String attachmentName = null;
        String extension = null;
        if (file != null && file.getSize() > 0) {
            attachmentName = cleanName(file.getSubmittedFileName());
            int dot = attachmentName.lastIndexOf('.');
            extension = dot < 0 ? "" : attachmentName.substring(dot + 1).toLowerCase(Locale.ROOT);
            if (!EXTENSIONS.contains(extension)) {
                FormSupport.reply(resp, 400, "att", Texts.of(req).get("js.leave.v.filetype"));
                return;
            }
        }

        String stored = null;
        try {
            if (attachmentName != null) {
                stored = UploadStore.save("leave", file, extension);
            }
            LeaveDao.CreateResult result = leaveDao.create(new LeaveDao.NewLeave(user.getId(), type, start, end,
                    destination, phone, reason, attachmentName, stored));
            if (result.request() == null) {
                UploadStore.delete(stored);
                String no = result.overlapRequestNo();
                FormSupport.reply(resp, 409, "startdate", no.isEmpty() ? Texts.of(req).get("srv.leave.overlap") : Texts.of(req).format("srv.leave.overlapno", no));
                return;
            }
            FormSupport.reply(resp, 200, null, Texts.of(req).format("srv.leave.sent", result.request().requestNo()), fields(result.request(), Texts.of(req)));
        } catch (SQLException e) {
            UploadStore.delete(stored);
            log("Leave request failed because the database could not be reached", e);
            FormSupport.reply(resp, 503, null, Texts.of(req).get("srv.db"));
        } catch (IOException e) {
            UploadStore.delete(stored);
            log("Leave attachment could not be saved", e);
            FormSupport.reply(resp, 500, "att", Texts.of(req).get("srv.leave.attsave"));
        }
    }

    private static Map<String, String> fields(LeaveRequest r, Texts tx) {
        Map<String, String> map = new LinkedHashMap<>();
        map.put("id", String.valueOf(r.id()));
        map.put("requestNo", r.requestNo());
        map.put("status", r.status());
        map.put("statusText", r.statusText(tx));
        map.put("typeText", r.typeText(tx));
        map.put("dateRange", r.dateRangeText(tx));
        map.put("duration", r.durationText(tx));
        map.put("submitted", r.submittedText(tx));
        map.put("submittedIso", r.submittedIso());
        map.put("start", r.startText(tx));
        map.put("end", r.endText(tx));
        map.put("destination", r.destination());
        map.put("contact", r.contactNumber());
        map.put("reason", r.reason());
        map.put("attachment", r.attachmentName() == null ? "" : r.attachmentName());
        return map;
    }

    private static LocalDate parse(String value) {
        try {
            return value.isEmpty() ? null : LocalDate.parse(value);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private static String cleanName(String submitted) {
        String name = submitted == null ? "attachment" : submitted;
        name = name.substring(Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\')) + 1);
        name = name.replaceAll("[\\p{Cntrl}\"<>|:*?]", "_").trim();
        if (name.isEmpty()) {
            name = "attachment";
        }
        if (name.length() > 100) {
            int dot = name.lastIndexOf('.');
            String ext = dot < 0 ? "" : name.substring(dot);
            name = name.substring(0, 100 - ext.length()) + ext;
        }
        return name;
    }
}
