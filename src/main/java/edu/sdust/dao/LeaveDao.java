package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.i18n.Texts;
import edu.sdust.model.LeaveRequest;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.Year;
import java.util.ArrayList;
import java.util.List;

public class LeaveDao {

    public enum ReviewResult { DONE, NOT_FOUND, NOT_PENDING }

    public record NewLeave(String studentId, String leaveType, LocalDate startDate, LocalDate endDate,
                           String destination, String contactNumber, String reason,
                           String attachmentName, String attachmentPath) {
    }

    public record CreateResult(LeaveRequest request, String overlapRequestNo) {
    }

    public record Attachment(String studentId, String counselorId, String name, String path) {
    }

    public record Slip(LeaveRequest request, String counselorId, String major, String college) {
    }

    private static final String SELECT_SQL =
            "SELECT lr.id, lr.request_no, lr.student_id, u.name AS student_name, s.class_name, lr.leave_type, "
            + "lr.start_date, lr.end_date, lr.destination, lr.contact_number, lr.reason, lr.attachment_name, "
            + "lr.status, lr.submitted_at, r.name AS reviewer_name, lr.review_comment, lr.reviewed_at "
            + "FROM leave_requests lr "
            + "JOIN students s ON s.student_id = lr.student_id "
            + "JOIN users u ON u.id = lr.student_id "
            + "LEFT JOIN users r ON r.id = lr.reviewer_id ";

    private static final String ORDER_SQL = " ORDER BY lr.status = 'pending' DESC, lr.submitted_at DESC";

    private static final String LOCK_SQL =
            "SELECT lr.request_no, lr.leave_type, lr.status, lr.student_id "
            + "FROM leave_requests lr JOIN students s ON s.student_id = lr.student_id "
            + "WHERE lr.id = ? AND s.counselor_id = ? FOR UPDATE";

    public List<LeaveRequest> forCounselor(String counselorId) throws SQLException {
        return list(SELECT_SQL + "WHERE s.counselor_id = ?" + ORDER_SQL, counselorId);
    }

    public List<LeaveRequest> forStudent(String studentId) throws SQLException {
        return list(SELECT_SQL + "WHERE lr.student_id = ?" + ORDER_SQL, studentId);
    }

    private List<LeaveRequest> list(String sql, String id) throws SQLException {
        List<LeaveRequest> requests = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(read(rs));
                }
            }
        }
        return requests;
    }

    private static LeaveRequest read(ResultSet rs) throws SQLException {
        Timestamp reviewed = rs.getTimestamp("reviewed_at");
        return new LeaveRequest(
                rs.getInt("id"),
                rs.getString("request_no"),
                rs.getString("student_id"),
                rs.getString("student_name"),
                rs.getString("class_name"),
                rs.getString("leave_type"),
                rs.getDate("start_date").toLocalDate(),
                rs.getDate("end_date").toLocalDate(),
                rs.getString("destination"),
                rs.getString("contact_number"),
                rs.getString("reason"),
                rs.getString("attachment_name"),
                rs.getString("status"),
                rs.getTimestamp("submitted_at").toLocalDateTime(),
                rs.getString("reviewer_name"),
                rs.getString("review_comment"),
                reviewed == null ? null : reviewed.toLocalDateTime());
    }

    public CreateResult create(NewLeave leave) throws SQLException {
        try (Connection conn = Database.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT request_no FROM leave_requests WHERE student_id = ? AND status IN ('pending', 'approved') "
                        + "AND start_date <= ? AND end_date >= ? LIMIT 1 FOR UPDATE")) {
                    ps.setString(1, leave.studentId());
                    ps.setDate(2, Date.valueOf(leave.endDate()));
                    ps.setDate(3, Date.valueOf(leave.startDate()));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            conn.rollback();
                            String no = rs.getString("request_no");
                            return new CreateResult(null, no == null ? "" : no);
                        }
                    }
                }

                String prefix = "LR-" + Year.now() + "-";
                int next = 1;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT MAX(CAST(SUBSTRING(request_no, ?) AS UNSIGNED)) FROM leave_requests WHERE request_no LIKE ? FOR UPDATE")) {
                    ps.setInt(1, prefix.length() + 1);
                    ps.setString(2, prefix + "%");
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            next = rs.getInt(1) + 1;
                        }
                    }
                }
                String requestNo = prefix + String.format("%04d", next);

                int id;
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO leave_requests (request_no, student_id, leave_type, start_date, end_date, destination, "
                        + "contact_number, reason, attachment_name, attachment_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, requestNo);
                    ps.setString(2, leave.studentId());
                    ps.setString(3, leave.leaveType());
                    ps.setDate(4, Date.valueOf(leave.startDate()));
                    ps.setDate(5, Date.valueOf(leave.endDate()));
                    ps.setString(6, leave.destination());
                    ps.setString(7, leave.contactNumber());
                    ps.setString(8, leave.reason());
                    ps.setString(9, leave.attachmentName());
                    ps.setString(10, leave.attachmentPath());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        id = keys.getInt(1);
                    }
                }

                LeaveRequest created;
                try (PreparedStatement ps = conn.prepareStatement(SELECT_SQL + "WHERE lr.id = ?")) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        created = read(rs);
                    }
                }

                String counselorId = null;
                try (PreparedStatement ps = conn.prepareStatement("SELECT counselor_id FROM students WHERE student_id = ?")) {
                    ps.setString(1, leave.studentId());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            counselorId = rs.getString("counselor_id");
                        }
                    }
                }
                if (counselorId != null) {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO notifications (user_id, type, title, message, title_zh, message_zh, link) VALUES (?, 'leave', ?, ?, ?, ?, '/dashboard/counselor/leave')")) {
                        Texts en = Texts.forLanguage("en");
                        Texts zh = Texts.forLanguage("zh");
                        ps.setString(1, counselorId);
                        ps.setString(2, en.get("ntf.leave.new.title"));
                        ps.setString(3, Texts.fit(en.format("ntf.leave.new.msg", created.studentName(), requestNo,
                                en.get("ntf.leavetype." + leave.leaveType()), created.dateRangeText(en)), 255));
                        ps.setString(4, zh.get("ntf.leave.new.title"));
                        ps.setString(5, Texts.fit(zh.format("ntf.leave.new.msg", created.studentName(), requestNo,
                                zh.get("ntf.leavetype." + leave.leaveType()), created.dateRangeText(zh)), 255));
                        ps.executeUpdate();
                    }
                }

                conn.commit();
                return new CreateResult(created, null);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public ReviewResult cancel(int id, String studentId) throws SQLException {
        try (Connection conn = Database.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String status;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT status FROM leave_requests WHERE id = ? AND student_id = ? FOR UPDATE")) {
                    ps.setInt(1, id);
                    ps.setString(2, studentId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return ReviewResult.NOT_FOUND;
                        }
                        status = rs.getString("status");
                    }
                }
                if (!"pending".equals(status)) {
                    conn.rollback();
                    return ReviewResult.NOT_PENDING;
                }
                try (PreparedStatement ps = conn.prepareStatement("UPDATE leave_requests SET status = 'cancelled' WHERE id = ?")) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                conn.commit();
                return ReviewResult.DONE;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public Slip slip(int id) throws SQLException {
        String sql = SELECT_SQL.replace("FROM leave_requests lr ",
                ", s.counselor_id, m.name AS major_name, c.name AS college_name FROM leave_requests lr ")
                + "LEFT JOIN majors m ON m.id = s.major_id LEFT JOIN colleges c ON c.id = m.college_id WHERE lr.id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return new Slip(read(rs), rs.getString("counselor_id"), rs.getString("major_name"), rs.getString("college_name"));
            }
        }
    }

    public Attachment attachment(int id) throws SQLException {
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT lr.student_id, s.counselor_id, lr.attachment_name, lr.attachment_path "
                     + "FROM leave_requests lr JOIN students s ON s.student_id = lr.student_id WHERE lr.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || rs.getString("attachment_path") == null) {
                    return null;
                }
                return new Attachment(rs.getString("student_id"), rs.getString("counselor_id"),
                        rs.getString("attachment_name"), rs.getString("attachment_path"));
            }
        }
    }

    public ReviewResult review(int id, String counselorId, String counselorName, boolean approve, String comment) throws SQLException {
        try (Connection conn = Database.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String requestNo;
                String type;
                String studentId;
                try (PreparedStatement ps = conn.prepareStatement(LOCK_SQL)) {
                    ps.setInt(1, id);
                    ps.setString(2, counselorId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return ReviewResult.NOT_FOUND;
                        }
                        if (!"pending".equals(rs.getString("status"))) {
                            conn.rollback();
                            return ReviewResult.NOT_PENDING;
                        }
                        requestNo = rs.getString("request_no");
                        type = rs.getString("leave_type");
                        studentId = rs.getString("student_id");
                    }
                }

                String status = approve ? "approved" : "rejected";
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE leave_requests SET status = ?, reviewer_id = ?, review_comment = ?, reviewed_at = NOW() WHERE id = ?")) {
                    ps.setString(1, status);
                    ps.setString(2, counselorId);
                    ps.setString(3, comment == null || comment.isEmpty() ? null : comment);
                    ps.setInt(4, id);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO notifications (user_id, type, title, message, title_zh, message_zh, link) VALUES (?, 'leave', ?, ?, ?, ?, '/dashboard/leave')")) {
                    Texts en = Texts.forLanguage("en");
                    Texts zh = Texts.forLanguage("zh");
                    ps.setString(1, studentId);
                    ps.setString(2, en.get("ntf.leave." + status + ".title"));
                    ps.setString(3, Texts.fit(en.format("ntf.leave." + status + ".msg", en.get("ntf.leavetype." + type), requestNo, counselorName), 255));
                    ps.setString(4, zh.get("ntf.leave." + status + ".title"));
                    ps.setString(5, Texts.fit(zh.format("ntf.leave." + status + ".msg", zh.get("ntf.leavetype." + type), requestNo, counselorName), 255));
                    ps.executeUpdate();
                }

                conn.commit();
                return ReviewResult.DONE;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }
}
