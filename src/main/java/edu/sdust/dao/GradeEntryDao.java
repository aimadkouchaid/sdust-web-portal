package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.i18n.Texts;
import edu.sdust.model.GradeClass;
import edu.sdust.model.GradeEntryRow;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GradeEntryDao {

    public record Entry(int enrollmentId, BigDecimal score, String level) {
    }

    public record Saved(int enrollmentId, BigDecimal score, String level, BigDecimal gradePoint) {
    }

    public List<GradeClass> classes(String teacherId) throws SQLException {
        String sql = "SELECT cc.id, c.name, c.code, cc.semester, c.assessment, COUNT(e.id) AS students, "
                + "COALESCE(SUM(e.id IS NOT NULL AND e.score IS NULL), 0) AS ungraded, "
                + "AVG(e.score) AS avg_score, AVG(e.grade_point) AS avg_point "
                + "FROM course_classes cc JOIN courses c ON c.id = cc.course_id "
                + "LEFT JOIN enrollments e ON e.class_id = cc.id "
                + "WHERE cc.teacher_id = ? GROUP BY cc.id, c.name, c.code, cc.semester, c.assessment "
                + "ORDER BY cc.semester DESC, c.name";
        List<GradeClass> classes = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teacherId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    classes.add(new GradeClass(rs.getInt("id"), rs.getString("name"), rs.getString("code"),
                            rs.getString("semester"), rs.getString("assessment"), rs.getInt("students"), rs.getInt("ungraded"),
                            rs.getBigDecimal("avg_score"), rs.getBigDecimal("avg_point")));
                }
            }
        }
        return classes;
    }

    public List<GradeEntryRow> students(int classId) throws SQLException {
        String sql = "SELECT e.id, u.id AS student_id, u.name, s.class_name, e.score, e.grade_level, e.grade_point "
                + "FROM enrollments e JOIN users u ON u.id = e.student_id JOIN students s ON s.student_id = e.student_id "
                + "WHERE e.class_id = ? ORDER BY s.class_name, u.id";
        List<GradeEntryRow> rows = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new GradeEntryRow(rs.getInt("id"), rs.getString("student_id"), rs.getString("name"),
                            rs.getString("class_name"), rs.getBigDecimal("score"), rs.getString("grade_level"),
                            rs.getBigDecimal("grade_point")));
                }
            }
        }
        return rows;
    }

    public List<Saved> save(String teacherId, int classId, List<Entry> entries) throws SQLException {
        try (Connection conn = Database.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String course;
                String semester;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT c.name, cc.semester FROM course_classes cc JOIN courses c ON c.id = cc.course_id "
                        + "WHERE cc.id = ? AND cc.teacher_id = ? FOR UPDATE")) {
                    ps.setInt(1, classId);
                    ps.setString(2, teacherId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return null;
                        }
                        course = rs.getString(1);
                        semester = rs.getString(2);
                    }
                }
                List<Saved> saved = new ArrayList<>();
                try (PreparedStatement update = conn.prepareStatement(
                        "UPDATE enrollments SET score = ?, grade_level = ? WHERE id = ? AND class_id = ? AND score IS NULL");
                     PreparedStatement read = conn.prepareStatement(
                             "SELECT student_id, grade_point FROM enrollments WHERE id = ?");
                     PreparedStatement notify = conn.prepareStatement(
                             "INSERT INTO notifications (user_id, type, title, message, title_zh, message_zh, link) VALUES (?, 'grade', ?, ?, ?, ?, ?)")) {
                    Texts en = Texts.forLanguage("en");
                    Texts zh = Texts.forLanguage("zh");
                    for (Entry entry : entries) {
                        update.setBigDecimal(1, entry.score());
                        update.setString(2, entry.level());
                        update.setInt(3, entry.enrollmentId());
                        update.setInt(4, classId);
                        if (update.executeUpdate() != 1) {
                            continue;
                        }
                        read.setInt(1, entry.enrollmentId());
                        try (ResultSet rs = read.executeQuery()) {
                            rs.next();
                            saved.add(new Saved(entry.enrollmentId(), entry.score(), entry.level(), rs.getBigDecimal("grade_point")));
                            notify.setString(1, rs.getString("student_id"));
                            notify.setString(2, en.get("ntf.grade.title"));
                            notify.setString(3, Texts.fit(en.format("ntf.grade.msg", course, semester), 255));
                            notify.setString(4, zh.get("ntf.grade.title"));
                            notify.setString(5, Texts.fit(zh.format("ntf.grade.msg", course, semester), 255));
                            notify.setString(6, "/dashboard/grades");
                            notify.executeUpdate();
                        }
                    }
                }
                conn.commit();
                return saved;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }
}
