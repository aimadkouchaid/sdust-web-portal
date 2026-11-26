package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.i18n.Texts;
import edu.sdust.model.Announcement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class AnnouncementDao {

    public record NewAnnouncement(String authorId, String category, String audience, List<Integer> classIds,
                                  String title, String summary, String body) {
    }

    public record Created(Announcement announcement, int notified) {
    }

    private static final String SELECT_SQL =
            "SELECT a.id, a.author_id, u.name AS author_name, u.role AS author_role, a.department, a.category, a.title, a.summary, a.body, "
            + "a.audience, a.published_at, "
            + "(SELECT GROUP_CONCAT(c.name ORDER BY c.name SEPARATOR ', ') FROM announcement_classes ac "
            + "JOIN course_classes cc ON cc.id = ac.class_id JOIN courses c ON c.id = cc.course_id "
            + "WHERE ac.announcement_id = a.id) AS class_names "
            + "FROM announcements a LEFT JOIN users u ON u.id = a.author_id ";

    public List<Announcement> forUser(String userId, String role) throws SQLException {
        return list(SELECT_SQL + "WHERE a.audience IN ('all', ?) "
                + "AND (NOT EXISTS (SELECT 1 FROM announcement_classes ac WHERE ac.announcement_id = a.id) "
                + "OR EXISTS (SELECT 1 FROM announcement_classes ac JOIN enrollments e ON e.class_id = ac.class_id "
                + "WHERE ac.announcement_id = a.id AND e.student_id = ?)) "
                + "AND NOT EXISTS (SELECT 1 FROM users au WHERE au.id = a.author_id AND au.role = 'counselor' "
                + "AND a.audience = 'student' "
                + "AND au.id <> COALESCE((SELECT s.counselor_id FROM students s WHERE s.student_id = ?), '')) "
                + "ORDER BY a.published_at DESC, a.id DESC LIMIT 200", role, userId, userId);
    }

    public List<Announcement> publicOnes() throws SQLException {
        return list(SELECT_SQL + "WHERE a.audience = 'all' ORDER BY a.published_at DESC, a.id DESC LIMIT 50");
    }

    public List<Announcement> byAuthor(String authorId) throws SQLException {
        return list(SELECT_SQL + "WHERE a.author_id = ? ORDER BY a.published_at DESC, a.id DESC", authorId);
    }

    public Created create(NewAnnouncement a) throws SQLException {
        try (Connection conn = Database.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String department = "Shandong University of Science and Technology";
                String authorName = "";
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT u.name, c.name FROM users u LEFT JOIN staff s ON s.staff_id = u.id "
                        + "LEFT JOIN colleges c ON c.id = s.college_id WHERE u.id = ?")) {
                    ps.setString(1, a.authorId());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            authorName = rs.getString(1);
                            if (rs.getString(2) != null) {
                                department = rs.getString(2);
                            }
                        }
                    }
                }

                int id;
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO announcements (author_id, department, category, title, summary, body, audience) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, a.authorId());
                    ps.setString(2, department);
                    ps.setString(3, a.category());
                    ps.setString(4, a.title());
                    ps.setString(5, a.summary());
                    ps.setString(6, a.body());
                    ps.setString(7, a.audience());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        id = keys.getInt(1);
                    }
                }

                if (!a.classIds().isEmpty()) {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO announcement_classes (announcement_id, class_id) VALUES (?, ?)")) {
                        for (int classId : a.classIds()) {
                            ps.setInt(1, id);
                            ps.setInt(2, classId);
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }

                Texts en = Texts.forLanguage("en");
                Texts zh = Texts.forLanguage("zh");
                String message = Texts.fit(en.format("ntf.ann.msg", authorName, a.title()), 255);
                String messageZh = Texts.fit(zh.format("ntf.ann.msg", authorName, a.title()), 255);
                String title = en.get("ntf.ann.title");
                String titleZh = zh.get("ntf.ann.title");
                int notified;
                if (!a.classIds().isEmpty()) {
                    String marks = String.join(", ", Collections.nCopies(a.classIds().size(), "?"));
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO notifications (user_id, type, title, message, title_zh, message_zh, link) "
                            + "SELECT DISTINCT e.student_id, 'announcement', ?, ?, ?, ?, '/dashboard/announcements' "
                            + "FROM enrollments e WHERE e.class_id IN (" + marks + ")")) {
                        ps.setString(1, title);
                        ps.setString(2, message);
                        ps.setString(3, titleZh);
                        ps.setString(4, messageZh);
                        for (int i = 0; i < a.classIds().size(); i++) {
                            ps.setInt(i + 5, a.classIds().get(i));
                        }
                        notified = ps.executeUpdate();
                    }
                } else if ("student".equals(a.audience())) {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO notifications (user_id, type, title, message, title_zh, message_zh, link) "
                            + "SELECT s.student_id, 'announcement', ?, ?, ?, ?, '/dashboard/announcements' "
                            + "FROM students s WHERE s.counselor_id = ?")) {
                        ps.setString(1, title);
                        ps.setString(2, message);
                        ps.setString(3, titleZh);
                        ps.setString(4, messageZh);
                        ps.setString(5, a.authorId());
                        notified = ps.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO notifications (user_id, type, title, message, title_zh, message_zh, link) "
                            + "SELECT u.id, 'announcement', ?, ?, ?, ?, CASE u.role "
                            + "WHEN 'student' THEN '/dashboard/announcements' "
                            + "WHEN 'teacher' THEN '/dashboard/teacher/announcements' "
                            + "ELSE '/dashboard/counselor/announcements' END "
                            + "FROM users u WHERE u.id <> ? AND (? = 'all' OR u.role = ?)")) {
                        ps.setString(1, title);
                        ps.setString(2, message);
                        ps.setString(3, titleZh);
                        ps.setString(4, messageZh);
                        ps.setString(5, a.authorId());
                        ps.setString(6, a.audience());
                        ps.setString(7, a.audience());
                        notified = ps.executeUpdate();
                    }
                }

                Announcement created;
                try (PreparedStatement ps = conn.prepareStatement(SELECT_SQL + "WHERE a.id = ?")) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        created = map(rs);
                    }
                }
                conn.commit();
                return new Created(created, notified);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public boolean remove(int id, String authorId) throws SQLException {
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM announcements WHERE id = ? AND author_id = ?")) {
            ps.setInt(1, id);
            ps.setString(2, authorId);
            return ps.executeUpdate() == 1;
        }
    }

    private List<Announcement> list(String sql, String... params) throws SQLException {
        List<Announcement> items = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setString(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(map(rs));
                }
            }
        }
        return items;
    }

    private static Announcement map(ResultSet rs) throws SQLException {
        return new Announcement(
                rs.getInt("id"),
                rs.getString("author_id"),
                rs.getString("author_name"),
                rs.getString("author_role"),
                rs.getString("department"),
                rs.getString("category"),
                rs.getString("title"),
                rs.getString("summary"),
                rs.getString("body"),
                rs.getString("audience"),
                rs.getString("class_names"),
                rs.getTimestamp("published_at").toLocalDateTime());
    }
}
