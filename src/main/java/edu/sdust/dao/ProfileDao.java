package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.model.Profile;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

public class ProfileDao {

    private static final String STUDENT_SQL =
            "SELECT u.name, u.gender, c.name AS college, m.name AS major, s.class_name, s.enrollment_year, s.campus, "
            + "cu.name AS counselor "
            + "FROM users u "
            + "JOIN students s ON s.student_id = u.id "
            + "JOIN majors m ON m.id = s.major_id "
            + "JOIN colleges c ON c.id = m.college_id "
            + "LEFT JOIN users cu ON cu.id = s.counselor_id "
            + "WHERE u.id = ?";

    private static final String STAFF_SQL =
            "SELECT u.name, u.gender, c.name AS college, st.title, st.office "
            + "FROM users u "
            + "LEFT JOIN staff st ON st.staff_id = u.id "
            + "LEFT JOIN colleges c ON c.id = st.college_id "
            + "WHERE u.id = ?";

    public Optional<Profile> find(String id, String role) throws SQLException {
        boolean student = "student".equals(role);
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(student ? STUDENT_SQL : STAFF_SQL)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return Optional.empty();
                }
                String gender = capitalize(rs.getString("gender"));
                if (student) {
                    int year = rs.getInt("enrollment_year");
                    Integer enrollmentYear = rs.wasNull() ? null : year;
                    return Optional.of(new Profile(rs.getString("name"), gender, rs.getString("college"),
                            rs.getString("major"), rs.getString("class_name"), enrollmentYear,
                            rs.getString("campus"), rs.getString("counselor"), null, null));
                }
                return Optional.of(new Profile(rs.getString("name"), gender, rs.getString("college"),
                        null, null, null, null, null, rs.getString("title"), rs.getString("office")));
            }
        }
    }

    private static String capitalize(String value) {
        return value == null || value.isEmpty() ? value : Character.toUpperCase(value.charAt(0)) + value.substring(1);
    }
}
