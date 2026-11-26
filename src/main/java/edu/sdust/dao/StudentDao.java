package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.model.CounselorStudent;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDao {

    public List<CounselorStudent> forCounselor(String counselorId) throws SQLException {
        String sql = "SELECT u.id, u.name, u.gender, u.email, u.phone, m.name AS major, s.class_name, s.enrollment_year, s.campus, "
                + "(SELECT SUM(c.credits * e.grade_point) / NULLIF(SUM(c.credits), 0) FROM enrollments e "
                + "JOIN course_classes cc ON cc.id = e.class_id JOIN courses c ON c.id = cc.course_id "
                + "WHERE e.student_id = s.student_id AND e.grade_point IS NOT NULL) AS gpa, "
                + "(SELECT SUM(c.credits) FROM enrollments e "
                + "JOIN course_classes cc ON cc.id = e.class_id JOIN courses c ON c.id = cc.course_id "
                + "WHERE e.student_id = s.student_id AND e.grade_point > 0) AS credits, "
                + "(SELECT COUNT(*) FROM leave_requests l WHERE l.student_id = s.student_id AND l.status = 'pending') AS pending, "
                + "(SELECT MAX(l.end_date) FROM leave_requests l WHERE l.student_id = s.student_id AND l.status = 'approved' "
                + "AND CURDATE() BETWEEN l.start_date AND l.end_date) AS on_leave_until "
                + "FROM students s JOIN users u ON u.id = s.student_id LEFT JOIN majors m ON m.id = s.major_id "
                + "WHERE s.counselor_id = ? ORDER BY s.class_name, u.name";
        List<CounselorStudent> students = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, counselorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int year = rs.getInt("enrollment_year");
                    Integer enrollmentYear = rs.wasNull() ? null : year;
                    Date leave = rs.getDate("on_leave_until");
                    students.add(new CounselorStudent(
                            rs.getString("id"),
                            rs.getString("name"),
                            rs.getString("gender"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("major"),
                            rs.getString("class_name"),
                            enrollmentYear,
                            rs.getString("campus"),
                            rs.getBigDecimal("gpa"),
                            rs.getBigDecimal("credits"),
                            rs.getInt("pending"),
                            leave == null ? null : leave.toLocalDate()));
                }
            }
        }
        return students;
    }
}
