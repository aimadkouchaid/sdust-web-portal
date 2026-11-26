package edu.sdust.dao;

import edu.sdust.db.Database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class TimetableDao {

    public record Session(int classId, int day, int startPeriod, int endPeriod, int startWeek, int endWeek,
                          String location, String courseName, String courseCode, String teacherName, int students) {
    }

    public record Timetable(String semester, LocalDate startDate, int weeks, List<Session> sessions) {
    }

    public Timetable forUser(String userId, String role) throws SQLException {
        String filter = "teacher".equals(role)
                ? "cc.teacher_id = ?"
                : "cc.id IN (SELECT class_id FROM enrollments WHERE student_id = ?)";
        String sql = "SELECT cs.class_id, cs.day_of_week, cs.start_period, cs.end_period, cs.start_week, cs.end_week, cs.location, "
                + "c.name AS course_name, c.code AS course_code, u.name AS teacher_name, "
                + "(SELECT COUNT(*) FROM enrollments e WHERE e.class_id = cs.class_id) AS students "
                + "FROM class_sessions cs JOIN course_classes cc ON cc.id = cs.class_id "
                + "JOIN courses c ON c.id = cc.course_id JOIN users u ON u.id = cc.teacher_id "
                + "WHERE cc.semester = ? AND " + filter + " "
                + "ORDER BY cs.day_of_week, cs.start_period, cs.class_id, cs.start_week";
        try (Connection conn = Database.getConnection()) {
            String semester = null;
            try (PreparedStatement ps = conn.prepareStatement("SELECT MAX(semester) FROM course_classes");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    semester = rs.getString(1);
                }
            }
            LocalDate startDate = null;
            int weeks = 0;
            if (semester != null) {
                try (PreparedStatement ps = conn.prepareStatement("SELECT start_date, weeks FROM semesters WHERE name = ?")) {
                    ps.setString(1, semester);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            startDate = rs.getDate("start_date").toLocalDate();
                            weeks = rs.getInt("weeks");
                        }
                    }
                }
            }
            List<Session> sessions = new ArrayList<>();
            if (semester != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, semester);
                    ps.setString(2, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            sessions.add(new Session(
                                    rs.getInt("class_id"),
                                    rs.getInt("day_of_week"),
                                    rs.getInt("start_period"),
                                    rs.getInt("end_period"),
                                    rs.getInt("start_week"),
                                    rs.getInt("end_week"),
                                    rs.getString("location"),
                                    rs.getString("course_name"),
                                    rs.getString("course_code"),
                                    rs.getString("teacher_name"),
                                    rs.getInt("students")));
                        }
                    }
                }
            }
            return new Timetable(semester, startDate, weeks, sessions);
        }
    }
}
