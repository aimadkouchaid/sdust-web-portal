package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.model.GradeEntryRow;
import edu.sdust.model.TeacherCourse;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CourseDao {

    public List<TeacherCourse> forTeacher(String teacherId) throws SQLException {
        try (Connection conn = Database.getConnection()) {
            Map<String, List<String>> weeks = new LinkedHashMap<>();
            Map<String, int[]> meetingKeys = new LinkedHashMap<>();
            Map<String, String> meetingRooms = new HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT cs.class_id, cs.day_of_week, cs.start_period, cs.end_period, cs.start_week, cs.end_week, cs.location "
                    + "FROM class_sessions cs JOIN course_classes cc ON cc.id = cs.class_id WHERE cc.teacher_id = ? "
                    + "ORDER BY cs.class_id, cs.day_of_week, cs.start_period, cs.start_week")) {
                ps.setString(1, teacherId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int classId = rs.getInt(1);
                        String key = classId + ":" + rs.getInt(2) + ":" + rs.getInt(3) + ":" + rs.getInt(4) + ":" + rs.getString(7);
                        meetingKeys.putIfAbsent(key, new int[]{classId, rs.getInt(2), rs.getInt(3), rs.getInt(4)});
                        meetingRooms.putIfAbsent(key, rs.getString(7));
                        int start = rs.getInt(5);
                        int end = rs.getInt(6);
                        weeks.computeIfAbsent(key, k -> new ArrayList<>()).add(start == end ? String.valueOf(start) : start + "–" + end);
                    }
                }
            }
            Map<Integer, List<TeacherCourse.Meeting>> meetings = new HashMap<>();
            for (Map.Entry<String, int[]> e : meetingKeys.entrySet()) {
                int[] m = e.getValue();
                List<String> w = weeks.get(e.getKey());
                meetings.computeIfAbsent(m[0], k -> new ArrayList<>()).add(new TeacherCourse.Meeting(m[1], m[2], m[3],
                        meetingRooms.get(e.getKey()), String.join(", ", w), w.size() == 1 && !w.get(0).contains("–")));
            }

            Map<Integer, List<TeacherCourse.CourseExam>> exams = new HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT e.class_id, e.exam_type, e.exam_date, e.start_time, e.end_time, e.location FROM exams e "
                    + "JOIN course_classes cc ON cc.id = e.class_id WHERE cc.teacher_id = ? ORDER BY e.exam_date, e.start_time")) {
                ps.setString(1, teacherId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        exams.computeIfAbsent(rs.getInt(1), k -> new ArrayList<>()).add(new TeacherCourse.CourseExam(
                                rs.getString(2), rs.getDate(3).toLocalDate(), rs.getTime(4).toLocalTime(),
                                rs.getTime(5).toLocalTime(), rs.getString(6)));
                    }
                }
            }

            Map<Integer, List<GradeEntryRow>> rosters = new HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT e.class_id, e.id, u.id AS student_id, u.name, s.class_name, e.score, e.grade_level, e.grade_point "
                    + "FROM enrollments e JOIN course_classes cc ON cc.id = e.class_id JOIN users u ON u.id = e.student_id "
                    + "JOIN students s ON s.student_id = e.student_id WHERE cc.teacher_id = ? ORDER BY e.class_id, s.class_name, u.id")) {
                ps.setString(1, teacherId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        rosters.computeIfAbsent(rs.getInt(1), k -> new ArrayList<>()).add(new GradeEntryRow(rs.getInt(2),
                                rs.getString(3), rs.getString(4), rs.getString(5), rs.getBigDecimal(6), rs.getString(7), rs.getBigDecimal(8)));
                    }
                }
            }

            List<TeacherCourse> courses = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT cc.id, c.name, c.code, cc.semester, cc.semester = (SELECT MAX(semester) FROM course_classes) AS current, "
                    + "c.credits, c.hours, c.nature, c.assessment, COUNT(e.id) AS students, COUNT(e.score) AS graded, "
                    + "AVG(e.score) AS avg_score, AVG(e.grade_point) AS avg_point "
                    + "FROM course_classes cc JOIN courses c ON c.id = cc.course_id LEFT JOIN enrollments e ON e.class_id = cc.id "
                    + "WHERE cc.teacher_id = ? GROUP BY cc.id, c.name, c.code, cc.semester, c.credits, c.hours, c.nature, c.assessment "
                    + "ORDER BY cc.semester DESC, c.name")) {
                ps.setString(1, teacherId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        int hours = rs.getInt("hours");
                        Integer hoursValue = rs.wasNull() ? null : hours;
                        courses.add(new TeacherCourse(id, rs.getString("name"), rs.getString("code"), rs.getString("semester"),
                                rs.getBoolean("current"), rs.getBigDecimal("credits"), hoursValue, rs.getString("nature"),
                                rs.getString("assessment"), rs.getInt("students"), rs.getInt("graded"),
                                rs.getBigDecimal("avg_score"), rs.getBigDecimal("avg_point"),
                                meetings.getOrDefault(id, List.of()), exams.getOrDefault(id, List.of()),
                                rosters.getOrDefault(id, List.of())));
                    }
                }
            }
            return courses;
        }
    }
}
