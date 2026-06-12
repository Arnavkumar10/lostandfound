package com.lostfound.dao;

import com.lostfound.model.LostItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the {@code lost_items} table.
 */
public class LostItemDAO {

    // ─── Create ────────────────────────────────────────────────────────────

    /**
     * Inserts a new lost item record and returns its generated ID.
     *
     * @param item the LostItem to save
     * @return generated item_id, or -1 on failure
     */
    public int addLostItem(LostItem item) {
        String sql = "INSERT INTO lost_items "
                   + "(user_id, item_name, category, description, date_lost, location, image_path, contact_info) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt   (1, item.getUserId());
            ps.setString(2, item.getItemName());
            ps.setString(3, item.getCategory());
            ps.setString(4, item.getDescription());
            ps.setDate  (5, item.getDateLost());
            ps.setString(6, item.getLocation());
            ps.setString(7, item.getImagePath());
            ps.setString(8, item.getContactInfo());

            int rows = ps.executeUpdate();
            if (rows == 1) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ─── Read ──────────────────────────────────────────────────────────────

    /**
     * Returns all approved lost items, newest first.
     */
    public List<LostItem> getAllLostItems() {
        return queryItems("SELECT li.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
                        + "FROM lost_items li JOIN users u ON li.user_id = u.user_id "
                        + "WHERE li.is_approved = 1 ORDER BY li.created_at DESC", null);
    }

    /**
     * Returns lost items matching a search keyword (name, category, location).
     */
    public List<LostItem> searchLostItems(String keyword, String category) {
        StringBuilder sql = new StringBuilder(
            "SELECT li.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
          + "FROM lost_items li JOIN users u ON li.user_id = u.user_id "
          + "WHERE li.is_approved = 1 ");

        List<String> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (li.item_name LIKE ? OR li.description LIKE ? OR li.location LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (category != null && !category.trim().isEmpty() && !category.equals("All")) {
            sql.append("AND li.category = ? ");
            params.add(category.trim());
        }
        sql.append("ORDER BY li.created_at DESC");

        return queryItems(sql.toString(), params);
    }

    /**
     * Returns a single lost item by its primary key.
     */
    public LostItem getLostItemById(int itemId) {
        String sql = "SELECT li.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
                   + "FROM lost_items li JOIN users u ON li.user_id = u.user_id "
                   + "WHERE li.item_id = ?";
        List<LostItem> results = queryItemsWithIntParam(sql, itemId);
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Returns all lost items submitted by a specific user.
     */
    public List<LostItem> getLostItemsByUser(int userId) {
        String sql = "SELECT li.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
                   + "FROM lost_items li JOIN users u ON li.user_id = u.user_id "
                   + "WHERE li.user_id = ? ORDER BY li.created_at DESC";
        return queryItemsWithIntParam(sql, userId);
    }

    /**
     * Returns all lost items (including unapproved) — for admin use.
     */
    public List<LostItem> getAllLostItemsAdmin() {
        return queryItems("SELECT li.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
                        + "FROM lost_items li JOIN users u ON li.user_id = u.user_id "
                        + "ORDER BY li.created_at DESC", null);
    }

    /**
     * Returns count of active (not recovered/closed) lost items.
     */
    public int getActiveLostCount() {
        return getCount("SELECT COUNT(*) FROM lost_items WHERE status='Active' AND is_approved=1");
    }

    /**
     * Returns total count of lost items.
     */
    public int getTotalLostCount() {
        return getCount("SELECT COUNT(*) FROM lost_items WHERE is_approved=1");
    }

    /**
     * Returns count of recovered lost items.
     */
    public int getRecoveredCount() {
        return getCount("SELECT COUNT(*) FROM lost_items WHERE status='Recovered'");
    }

    // ─── Update ────────────────────────────────────────────────────────────

    /**
     * Updates the status of a lost item (Active / Recovered / Closed).
     */
    public boolean updateStatus(int itemId, String status) {
        String sql = "UPDATE lost_items SET status = ? WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, itemId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Approves or rejects a lost item post (admin action).
     */
    public boolean setApproval(int itemId, boolean approved) {
        String sql = "UPDATE lost_items SET is_approved = ? WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, approved);
            ps.setInt(2, itemId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Delete ────────────────────────────────────────────────────────────

    /**
     * Deletes a lost item record by ID.
     */
    public boolean deleteLostItem(int itemId) {
        String sql = "DELETE FROM lost_items WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Helpers ───────────────────────────────────────────────────────────

    private List<LostItem> queryItems(String sql, List<String> params) {
        List<LostItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (params != null) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setString(i + 1, params.get(i));
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) items.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    private List<LostItem> queryItemsWithIntParam(String sql, int param) {
        List<LostItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) items.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    private int getCount(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Maps a ResultSet row to a LostItem object. */
    private LostItem mapRow(ResultSet rs) throws SQLException {
        LostItem item = new LostItem();
        item.setItemId(rs.getInt("item_id"));
        item.setUserId(rs.getInt("user_id"));
        item.setItemName(rs.getString("item_name"));
        item.setCategory(rs.getString("category"));
        item.setDescription(rs.getString("description"));
        item.setDateLost(rs.getDate("date_lost"));
        item.setLocation(rs.getString("location"));
        item.setImagePath(rs.getString("image_path"));
        item.setContactInfo(rs.getString("contact_info"));
        item.setStatus(rs.getString("status"));
        item.setApproved(rs.getBoolean("is_approved"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        // Joined fields (may be null in some queries)
        try { item.setReporterName(rs.getString("reporter_name")); } catch (SQLException ignored) {}
        try { item.setReporterUSN(rs.getString("reporter_usn"));  } catch (SQLException ignored) {}
        return item;
    }
}
