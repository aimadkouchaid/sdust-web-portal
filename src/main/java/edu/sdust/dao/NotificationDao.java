package edu.sdust.dao;

import edu.sdust.db.Database;
import edu.sdust.model.Notification;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDao {

    public List<Notification> forUser(String userId, int limit) throws SQLException {
        String sql = "SELECT id, type, title, message, title_zh, message_zh, link, is_read, created_at FROM notifications "
                + "WHERE user_id = ? ORDER BY created_at DESC, id DESC LIMIT ?";
        List<Notification> list = new ArrayList<>();
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Notification(
                            rs.getInt("id"),
                            rs.getString("type"),
                            rs.getString("title"),
                            rs.getString("message"),
                            rs.getString("title_zh"),
                            rs.getString("message_zh"),
                            rs.getString("link"),
                            rs.getBoolean("is_read"),
                            rs.getTimestamp("created_at").toLocalDateTime()));
                }
            }
        }
        return list;
    }

    public void markRead(String userId, int id) throws SQLException {
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?")) {
            ps.setInt(1, id);
            ps.setString(2, userId);
            ps.executeUpdate();
        }
    }

    public void clearAll(String userId) throws SQLException {
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM notifications WHERE user_id = ?")) {
            ps.setString(1, userId);
            ps.executeUpdate();
        }
    }

    public void markAllRead(String userId) throws SQLException {
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE")) {
            ps.setString(1, userId);
            ps.executeUpdate();
        }
    }
}
