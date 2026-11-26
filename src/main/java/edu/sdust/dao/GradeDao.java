package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.model.GradeRow;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GradeDao {

    public List<GradeRow> forStudent(String studentId) throws SQLException {
        String sql = "SELECT cc.semester, c.code, c.name, col.name AS college, c.credits, c.hours, c.nature, c.attribute, "
                + "c.assessment, e.exam_nature, e.score, e.grade_level, e.grade_point "
                + "FROM enrollments e JOIN course_classes cc ON cc.id = e.class_id JOIN courses c ON c.id = cc.course_id "
                + "LEFT JOIN colleges col ON col.id = c.college_id "
                + "WHERE e.student_id = ? ORDER BY cc.semester DESC, c.code";
        List<GradeRow> rows = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int hours = rs.getInt("hours");
                    Integer hoursValue = rs.wasNull() ? null : hours;
                    rows.add(new GradeRow(
                            rs.getString("semester"),
                            rs.getString("code"),
                            rs.getString("name"),
                            rs.getString("college"),
                            rs.getBigDecimal("credits"),
                            hoursValue,
                            rs.getString("nature"),
                            rs.getString("attribute"),
                            rs.getString("assessment"),
                            rs.getString("exam_nature"),
                            rs.getBigDecimal("score"),
                            rs.getString("grade_level"),
                            rs.getBigDecimal("grade_point")));
                }
            }
        }
        return rows;
    }
}
