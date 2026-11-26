package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.i18n.Texts;
import edu.sdust.model.ClassOption;
import edu.sdust.model.Exam;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class ExamDao {

    public record NewExam(int classId, String examType, LocalDate date, LocalTime start, LocalTime end,
                          String location, String notes, String teacherId) {
    }

    public enum Problem { NOT_YOUR_CLASS, DUPLICATE, ROOM_CLASH, STUDENT_CLASH, PAST, NOT_FOUND }

    public record Result(Exam exam, Problem problem, String detail) {
    }

    private static final String SELECT_SQL =
            "SELECT e.id, e.class_id, c.name AS course_name, c.code AS course_code, cc.semester, u.name AS teacher_name, "
            + "e.exam_type, e.exam_date, e.start_time, e.end_time, e.location, e.notes, "
            + "(SELECT COUNT(*) FROM enrollments en WHERE en.class_id = e.class_id) AS student_count "
            + "FROM exams e "
            + "JOIN course_classes cc ON cc.id = e.class_id "
            + "JOIN courses c ON c.id = cc.course_id "
            + "JOIN users u ON u.id = cc.teacher_id ";

    private static final String ORDER_SQL = " ORDER BY e.exam_date, e.start_time";

    public List<Exam> forStudent(String studentId) throws SQLException {
        return list(SELECT_SQL + "WHERE e.class_id IN (SELECT class_id FROM enrollments WHERE student_id = ?)" + ORDER_SQL, studentId);
    }

    public List<Exam> forTeacher(String teacherId) throws SQLException {
        return list(SELECT_SQL + "WHERE cc.teacher_id = ?" + ORDER_SQL, teacherId);
    }

    public List<ClassOption> teacherClasses(String teacherId) throws SQLException {
        String sql = "SELECT cc.id, c.name, c.code, COUNT(en.id) AS students "
                + "FROM course_classes cc JOIN courses c ON c.id = cc.course_id "
                + "LEFT JOIN enrollments en ON en.class_id = cc.id "
                + "WHERE cc.teacher_id = ? AND cc.semester = (SELECT MAX(semester) FROM course_classes) "
                + "GROUP BY cc.id, c.name, c.code ORDER BY c.name";
        List<ClassOption> options = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teacherId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    options.add(new ClassOption(rs.getInt("id"), rs.getString("name"), rs.getString("code"), rs.getInt("students")));
                }
            }
        }
        return options;
    }

    private List<Exam> list(String sql, String id) throws SQLException {
        List<Exam> exams = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    exams.add(read(rs));
                }
            }
        }
        return exams;
    }

    private static Exam read(ResultSet rs) throws SQLException {
        return new Exam(
                rs.getInt("id"),
                rs.getInt("class_id"),
                rs.getString("course_name"),
                rs.getString("course_code"),
                rs.getString("semester"),
                rs.getString("teacher_name"),
                rs.getString("exam_type"),
                rs.getDate("exam_date").toLocalDate(),
                rs.getTime("start_time").toLocalTime(),
                rs.getTime("end_time").toLocalTime(),
                rs.getString("location"),
                rs.getString("notes"),
                rs.getInt("student_count"));
    }

    public Result create(NewExam exam) throws SQLException {
        try (Connection conn = Database.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT id FROM course_classes WHERE id = ? AND teacher_id = ? "
                        + "AND semester = (SELECT MAX(semester) FROM course_classes x) FOR UPDATE")) {
                    ps.setInt(1, exam.classId());
                    ps.setString(2, exam.teacherId());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return new Result(null, Problem.NOT_YOUR_CLASS, null);
                        }
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM exams WHERE class_id = ? AND exam_type = ?")) {
                    ps.setInt(1, exam.classId());
                    ps.setString(2, exam.examType());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            conn.rollback();
                            return new Result(null, Problem.DUPLICATE, null);
                        }
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT c.name, e.exam_type FROM exams e JOIN course_classes cc ON cc.id = e.class_id "
                        + "JOIN courses c ON c.id = cc.course_id "
                        + "WHERE e.location = ? AND e.exam_date = ? AND e.start_time < ? AND e.end_time > ? LIMIT 1")) {
                    ps.setString(1, exam.location());
                    ps.setDate(2, Date.valueOf(exam.date()));
                    ps.setTime(3, Time.valueOf(exam.end()));
                    ps.setTime(4, Time.valueOf(exam.start()));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            conn.rollback();
                            return new Result(null, Problem.ROOM_CLASH, rs.getString(1) + "|" + rs.getString(2));
                        }
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT c.name, e.exam_type FROM exams e "
                        + "JOIN course_classes cc ON cc.id = e.class_id JOIN courses c ON c.id = cc.course_id "
                        + "JOIN enrollments other ON other.class_id = e.class_id "
                        + "JOIN enrollments mine ON mine.student_id = other.student_id AND mine.class_id = ? "
                        + "WHERE e.exam_date = ? AND e.start_time < ? AND e.end_time > ? LIMIT 1")) {
                    ps.setInt(1, exam.classId());
                    ps.setDate(2, Date.valueOf(exam.date()));
                    ps.setTime(3, Time.valueOf(exam.end()));
                    ps.setTime(4, Time.valueOf(exam.start()));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            conn.rollback();
                            return new Result(null, Problem.STUDENT_CLASH, rs.getString(1) + "|" + rs.getString(2));
                        }
                    }
                }

                int id;
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO exams (class_id, exam_type, exam_date, start_time, end_time, location, notes, created_by) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, exam.classId());
                    ps.setString(2, exam.examType());
                    ps.setDate(3, Date.valueOf(exam.date()));
                    ps.setTime(4, Time.valueOf(exam.start()));
                    ps.setTime(5, Time.valueOf(exam.end()));
                    ps.setString(6, exam.location());
                    ps.setString(7, exam.notes() == null || exam.notes().isEmpty() ? null : exam.notes());
                    ps.setString(8, exam.teacherId());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        id = keys.getInt(1);
                    }
                }

                Exam created = find(conn, id);
                notifyStudents(conn, created.classId(), "ntf.exam.scheduled", created);
                conn.commit();
                return new Result(created, null, null);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public Result remove(int id, String teacherId) throws SQLException {
        try (Connection conn = Database.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Exam exam;
                try (PreparedStatement ps = conn.prepareStatement(SELECT_SQL + "WHERE e.id = ? AND cc.teacher_id = ? FOR UPDATE")) {
                    ps.setInt(1, id);
                    ps.setString(2, teacherId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return new Result(null, Problem.NOT_FOUND, null);
                        }
                        exam = read(rs);
                    }
                }
                if (exam.past()) {
                    conn.rollback();
                    return new Result(null, Problem.PAST, null);
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM exams WHERE id = ?")) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                notifyStudents(conn, exam.classId(), "ntf.exam.cancelled", exam);
                conn.commit();
                return new Result(exam, null, null);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private static Exam find(Connection conn, int id) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(SELECT_SQL + "WHERE e.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return read(rs);
            }
        }
    }

    private static void notifyStudents(Connection conn, int classId, String key, Exam exam) throws SQLException {
        Texts en = Texts.forLanguage("en");
        Texts zh = Texts.forLanguage("zh");
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO notifications (user_id, type, title, message, title_zh, message_zh, link) "
                + "SELECT student_id, 'exam', ?, ?, ?, ?, '/dashboard/exams' FROM enrollments WHERE class_id = ?")) {
            ps.setString(1, en.get(key + ".title"));
            ps.setString(2, Texts.fit(en.format(key + ".msg", exam.summary(en)), 255));
            ps.setString(3, zh.get(key + ".title"));
            ps.setString(4, Texts.fit(zh.format(key + ".msg", exam.summary(zh)), 255));
            ps.setInt(5, classId);
            ps.executeUpdate();
        }
    }
}
