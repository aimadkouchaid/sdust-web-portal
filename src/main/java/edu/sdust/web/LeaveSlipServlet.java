package edu.sdust.web;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import edu.sdust.dao.LeaveDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.LeaveRequest;
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
import java.time.LocalDate;

@WebServlet(urlPatterns = "/dashboard/leave/slip",
        initParams = @WebInitParam(name = "roles", value = "student,counselor"))
public class LeaveSlipServlet extends HttpServlet {

    private final LeaveDao leaveDao = new LeaveDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);
        LeaveDao.Slip slip;
        try {
            slip = leaveDao.slip(Integer.parseInt(FormSupport.value(req.getParameter("id"))));
        } catch (NumberFormatException e) {
            slip = null;
        } catch (SQLException e) {
            log("Building a leave slip failed because the database could not be reached", e);
            resp.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            return;
        }
        boolean allowed = slip != null && "approved".equals(slip.request().status())
                && (user.getId().equals(slip.request().studentId()) || user.getId().equals(slip.counselorId()));
        if (!allowed) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        Texts tx = Texts.of(req);
        try {
            PdfSupport.send(resp, tx.format("pdf.slip.file", slip.request().requestNo()), build(tx, slip));
        } catch (DocumentException e) {
            throw new IOException(e);
        }
    }

    private static byte[] build(Texts tx, LeaveDao.Slip slip) throws DocumentException {
        LeaveRequest r = slip.request();
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4, 48, 48, 40, 40);
        PdfWriter.getInstance(doc, out);
        doc.addTitle(tx.get("pdf.slip.title") + " " + r.requestNo());
        doc.open();
        PdfSupport.header(doc, tx, tx.get("pdf.slip.title"), tx.format("pdf.slip.number", r.requestNo()));

        PdfPTable status = new PdfPTable(1);
        status.setWidthPercentage(100);
        PdfPCell badge = new PdfPCell(PdfSupport.bold(tx.get("pdf.slip.approved"), 13, PdfSupport.GREEN));
        badge.setBackgroundColor(new Color(0xE6, 0xF4, 0xEC));
        badge.setBorderColor(PdfSupport.GREEN);
        badge.setBorderWidth(0);
        badge.setBorderWidthLeft(4);
        badge.setPadding(10);
        status.addCell(badge);
        status.setSpacingAfter(18);
        doc.add(status);

        doc.add(section(tx.get("pdf.slip.student")));
        PdfPTable student = grid();
        pair(student, tx.get("leave.f.student"), r.studentName(), tx.get("leave.f.studentid"), r.studentId());
        pair(student, tx.get("leave.f.class"), r.className(), tx.get("profile.major"), slip.major());
        wide(student, tx.get("profile.college"), slip.college());
        doc.add(student);

        doc.add(section(tx.get("pdf.slip.leave")));
        PdfPTable leave = grid();
        pair(leave, tx.get("leave.f.type"), r.typeText(tx), tx.get("leave.f.duration"), r.durationText(tx));
        pair(leave, tx.get("leave.f.start"), r.startText(tx), tx.get("leave.f.end"), r.endText(tx));
        pair(leave, tx.get("leave.f.dest"), r.destination(), tx.get("leave.f.contact"), r.contactNumber());
        wide(leave, tx.get("leave.f.reason"), r.reason());
        wide(leave, tx.get("leave.f.submitted"), r.submittedText(tx));
        doc.add(leave);

        doc.add(section(tx.get("pdf.slip.approval")));
        PdfPTable approval = grid();
        pair(approval, tx.get("pdf.slip.approvedby"), r.reviewerName() == null ? tx.get("leave.counseloroffice") : r.reviewerName(),
                tx.get("pdf.slip.approvedon"), r.reviewedText(tx));
        if (r.reviewComment() != null && !r.reviewComment().isBlank()) {
            wide(approval, tx.get("review.comment"), r.reviewComment());
        }
        doc.add(approval);

        Paragraph note = new Paragraph(PdfSupport.text(tx.format("pdf.slip.note", r.requestNo(), tx.date(LocalDate.now())), 8.5f, PdfSupport.MUTED));
        note.setSpacingBefore(24);
        note.setLeading(13);
        doc.add(note);
        doc.close();
        return out.toByteArray();
    }

    private static Paragraph section(String title) {
        Paragraph p = new Paragraph(PdfSupport.bold(title, 11, PdfSupport.BLUE));
        p.setSpacingBefore(6);
        p.setSpacingAfter(6);
        return p;
    }

    private static PdfPTable grid() throws DocumentException {
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1.2f, 2.3f, 1.2f, 2.3f});
        table.setSpacingAfter(14);
        return table;
    }

    private static void pair(PdfPTable table, String label1, String value1, String label2, String value2) {
        table.addCell(label(label1));
        table.addCell(value(value1, 1));
        table.addCell(label(label2));
        table.addCell(value(value2, 1));
    }

    private static void wide(PdfPTable table, String label, String value) {
        table.addCell(label(label));
        table.addCell(value(value, 3));
    }

    private static PdfPCell label(String text) {
        PdfPCell cell = new PdfPCell(PdfSupport.text(text, 9, PdfSupport.MUTED));
        cell.setBackgroundColor(new Color(0xF7, 0xF9, 0xFC));
        cell.setBorderColor(PdfSupport.LINE);
        cell.setPadding(7);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        return cell;
    }

    private static PdfPCell value(String text, int colspan) {
        Phrase phrase = PdfSupport.text(text == null || text.isBlank() ? "—" : text, 10, PdfSupport.TEXT);
        PdfPCell cell = new PdfPCell(phrase);
        cell.setColspan(colspan);
        cell.setBorderColor(PdfSupport.LINE);
        cell.setPadding(7);
        cell.setLeading(0, 1.35f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        return cell;
    }
}
