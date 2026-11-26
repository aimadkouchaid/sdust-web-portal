package edu.sdust.web;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import edu.sdust.dao.TimetableDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = "/dashboard/timetable/download",
        initParams = @WebInitParam(name = "roles", value = "student,teacher"))
public class TimetablePdfServlet extends HttpServlet {

    private static final String[][] TIMES = {{"08:00", "09:40"}, {"10:10", "11:50"}, {"14:00", "15:40"}, {"16:00", "17:40"}, {"19:00", "20:40"}};
    private static final String[] PERIODS = {"1–2", "3–4", "5–6", "7–8", "9–10"};
    private static final Color[][] COLORS = {
            {new Color(0x00, 0x4A, 0x9F), new Color(0xE8, 0xF0, 0xFA)},
            {new Color(0x2F, 0x85, 0x5A), new Color(0xE6, 0xF4, 0xEC)},
            {new Color(0xB7, 0x79, 0x1F), new Color(0xFD, 0xF3, 0xE1)},
            {new Color(0x6B, 0x46, 0xC1), new Color(0xF0, 0xEA, 0xFB)},
            {new Color(0x2C, 0x7A, 0x7B), new Color(0xE3, 0xF4, 0xF4)},
            {new Color(0xB8, 0x32, 0x80), new Color(0xFD, 0xE8, 0xF1)}};

    private final TimetableDao timetableDao = new TimetableDao();

    private record Entry(TimetableDao.Session first, List<String> weeks, int span) {
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);
        Texts tx = Texts.of(req);
        TimetableDao.Timetable timetable;
        try {
            timetable = timetableDao.forUser(user.getId(), user.getRole());
        } catch (SQLException e) {
            log("Building the timetable PDF failed because the database could not be reached", e);
            resp.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            return;
        }
        String semester = timetable.semester() == null ? "" : timetable.semester();
        try {
            PdfSupport.send(resp, tx.format("pdf.tt.file", semester), build(tx, user, semester, timetable.sessions()));
        } catch (DocumentException e) {
            throw new IOException(e);
        }
    }

    private byte[] build(Texts tx, User user, String semester, List<TimetableDao.Session> sessions) throws DocumentException {
        Map<String, Entry> cells = new LinkedHashMap<>();
        Map<Integer, Color[]> colors = new HashMap<>();
        for (TimetableDao.Session s : sessions) {
            colors.computeIfAbsent(s.classId(), id -> COLORS[colors.size() % COLORS.length]);
            int slot = (s.startPeriod() + 1) / 2;
            int span = Math.max(1, Math.min(6 - slot, (s.endPeriod() - s.startPeriod() + 2) / 2));
            String key = s.day() + ":" + slot + ":" + s.classId();
            Entry entry = cells.computeIfAbsent(key, k -> new Entry(s, new ArrayList<>(), span));
            entry.weeks().add(s.startWeek() == s.endWeek() ? String.valueOf(s.startWeek()) : s.startWeek() + "–" + s.endWeek());
        }

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4.rotate(), 28, 28, 26, 26);
        PdfWriter.getInstance(doc, out);
        doc.addTitle(tx.format("pdf.tt.title", semester));
        doc.open();
        String who = tx.format("teacher".equals(user.getRole()) ? "pdf.tt.teacher" : "pdf.tt.student", user.getName(), user.getId());
        PdfSupport.header(doc, tx, tx.format("pdf.tt.title", semester), who);

        PdfPTable table = new PdfPTable(8);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1.15f, 2.2f, 2.2f, 2.2f, 2.2f, 2.2f, 1.3f, 1.3f});
        table.setHeaderRows(1);
        table.addCell(headCell(tx.get("tt.time")));
        for (int day = 1; day <= 7; day++) {
            table.addCell(headCell(tx.get("tt.day." + day)));
        }

        boolean[][] taken = new boolean[7][8];
        for (int slot = 1; slot <= 5; slot++) {
            PdfPCell time = new PdfPCell();
            time.addElement(new Paragraph(PdfSupport.bold(TIMES[slot - 1][0], 10, PdfSupport.BLUE)));
            time.addElement(new Paragraph(PdfSupport.text(TIMES[slot - 1][1], 8.5f, PdfSupport.MUTED)));
            time.addElement(new Paragraph(PdfSupport.text(tx.format("tt.periods", PERIODS[slot - 1]), 7.5f, PdfSupport.MUTED)));
            time.setBorderColor(PdfSupport.LINE);
            time.setPadding(6);
            time.setMinimumHeight(84);
            time.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(time);
            for (int day = 1; day <= 7; day++) {
                if (taken[slot][day]) {
                    continue;
                }
                final int d = day;
                final int sl = slot;
                List<Entry> here = cells.values().stream()
                        .filter(e -> e.first().day() == d && (e.first().startPeriod() + 1) / 2 == sl)
                        .collect(Collectors.toList());
                int span = here.stream().mapToInt(Entry::span).max().orElse(1);
                for (int k = 1; k < span; k++) {
                    taken[slot + k][day] = true;
                }
                table.addCell(sessionCell(tx, user, here, colors, span));
            }
        }
        doc.add(table);
        doc.close();
        return out.toByteArray();
    }

    private static PdfPCell headCell(String label) {
        PdfPCell cell = new PdfPCell(PdfSupport.bold(label, 9, PdfSupport.WHITE));
        cell.setBackgroundColor(PdfSupport.BLUE);
        cell.setBorderColor(PdfSupport.BLUE);
        cell.setPadding(6);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        return cell;
    }

    private static PdfPCell sessionCell(Texts tx, User user, List<Entry> entries, Map<Integer, Color[]> colors, int span) {
        PdfPCell cell = new PdfPCell();
        cell.setRowspan(span);
        cell.setBorderColor(PdfSupport.LINE);
        cell.setPadding(5);
        if (entries.isEmpty()) {
            return cell;
        }
        Color[] color = colors.get(entries.get(0).first().classId());
        cell.setBackgroundColor(color[1]);
        cell.setBorderWidthLeft(3);
        cell.setBorderColorLeft(color[0]);
        boolean teacher = "teacher".equals(user.getRole());
        for (int i = 0; i < entries.size(); i++) {
            TimetableDao.Session s = entries.get(i).first();
            List<String> weeks = entries.get(i).weeks();
            Paragraph code = new Paragraph(PdfSupport.bold(s.courseCode(), 7, color[0]));
            if (i > 0) {
                code.setSpacingBefore(6);
            }
            cell.addElement(code);
            Paragraph name = new Paragraph(PdfSupport.bold(s.courseName(), 8.5f, PdfSupport.TEXT));
            name.setLeading(10.5f);
            cell.addElement(name);
            cell.addElement(line(s.location()));
            if (!teacher) {
                cell.addElement(line(s.teacherName()));
            }
            String weekText = weeks.size() == 1 && !weeks.get(0).contains("–")
                    ? tx.format("tt.week1", weeks.get(0))
                    : tx.format("tt.weeks", String.join(", ", weeks));
            cell.addElement(new Paragraph(PdfSupport.text(weekText, 7, PdfSupport.MUTED)));
        }
        return cell;
    }

    private static Paragraph line(String value) {
        Paragraph p = new Paragraph(PdfSupport.text(value, 7.5f, PdfSupport.TEXT));
        p.setLeading(9.5f);
        return p;
    }
}
