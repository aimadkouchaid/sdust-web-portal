package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.model.Contact;
import edu.sdust.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

public class UserDao {

    private static final String DUMMY_HASH = BCrypt.hashpw("dummy-password", BCrypt.gensalt(10));

    public Optional<User> authenticate(String id, String password) throws SQLException {
        String sql = "SELECT id, password_hash, role, name FROM users WHERE id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    BCrypt.checkpw(password, DUMMY_HASH);
                    return Optional.empty();
                }
                if (!matches(password, rs.getString("password_hash"))) {
                    return Optional.empty();
                }
                return Optional.of(new User(
                        rs.getString("id"),
                        rs.getString("role"),
                        rs.getString("name")));
            }
        }
    }

    public boolean passwordMatches(String id, String password) throws SQLException {
        String sql = "SELECT password_hash FROM users WHERE id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && matches(password, rs.getString("password_hash"));
            }
        }
    }

    public void updatePassword(String id, String password) throws SQLException {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(password, BCrypt.gensalt(10)));
            ps.setString(2, id);
            ps.executeUpdate();
        }
    }

    public Contact findContact(String id) throws SQLException {
        String sql = "SELECT email, phone FROM users WHERE id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? new Contact(rs.getString("email"), rs.getString("phone")) : new Contact(null, null);
            }
        }
    }

    public void updateContact(String id, Contact contact) throws SQLException {
        String sql = "UPDATE users SET email = ?, phone = ? WHERE id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contact.email());
            ps.setString(2, contact.phone());
            ps.setString(3, id);
            ps.executeUpdate();
        }
    }

    private static boolean matches(String password, String hash) {
        try {
            return BCrypt.checkpw(password, hash);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}
