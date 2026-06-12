package com.lostfound.dao;

import com.lostfound.model.FoundItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the {@code found_items} table.
 */
public class FoundItemDAO {

    // ─── Create ────────────────────────────────────────────────────────────

    /**
     * Inserts a new found item record and returns its generated ID.
     *
     * @param item the FoundItem to save
     * @return generated item_id, or -1 on failure
     */
    public int addFoundItem(FoundItem item) {
        String sql = "INSERT INTO found_items "
                   + "(user_id, item_name, category, description, date_found, location, image_path, contact_info) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt   (1, item.getUserId());
            ps.setString(2, item.getItemName());
            ps.setString(3, item.getCategory());
            ps.setString(4, item.getDescription());
            ps.setDate  (5, item.getDateFound());
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
     * Returns all approved found items, newest first.
     */
    public List<FoundItem> getAllFoundItems() {
        return queryItems("SELECT fi.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
                        + "FROM found_items fi JOIN users u ON fi.user_id = u.user_id "
                        + "WHERE fi.is_approved = 1 ORDER BY fi.created_at DESC", null);
    }

    /**
     * Returns found items matching search keyword and/or category.
     */
    public List<FoundItem> searchFoundItems(String keyword, String category) {
        StringBuilder sql = new StringBuilder(
            "SELECT fi.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
          + "FROM found_items fi JOIN users u ON fi.user_id = u.user_id "
          + "WHERE fi.is_approved = 1 ");

        List<String> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (fi.item_name LIKE ? OR fi.description LIKE ? OR fi.location LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (category != null && !category.trim().isEmpty() && !category.equals("All")) {
            sql.append("AND fi.category = ? ");
            params.add(category.trim());
        }
        sql.append("ORDER BY fi.created_at DESC");

        return queryItems(sql.toString(), params);
    }

    /**
     * Returns a single found item by its primary key.
     */
    public FoundItem getFoundItemById(int itemId) {
        String sql = "SELECT fi.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
                   + "FROM found_items fi JOIN users u ON fi.user_id = u.user_id "
                   + "WHERE fi.item_id = ?";
        List<FoundItem> results = queryItemsWithIntParam(sql, itemId);
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Returns all found items submitted by a specific user.
     */
    public List<FoundItem> getFoundItemsByUser(int userId) {
        String sql = "SELECT fi.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
                   + "FROM found_items fi JOIN users u ON fi.user_id = u.user_id "
                   + "WHERE fi.user_id = ? ORDER BY fi.created_at DESC";
        return queryItemsWithIntParam(sql, userId);
    }

    /**
     * Returns all found items including unapproved — for admin use.
     */
    public List<FoundItem> getAllFoundItemsAdmin() {
        return queryItems("SELECT fi.*, u.full_name AS reporter_name, u.usn AS reporter_usn "
                        + "FROM found_items fi JOIN users u ON fi.user_id = u.user_id "
                        + "ORDER BY fi.created_at DESC", null);
    }

    /**
     * Returns the count of available (unclaimed) found items.
     */
    public int getAvailableFoundCount() {
        return getCount("SELECT COUNT(*) FROM found_items WHERE status='Available' AND is_approved=1");
    }

    /**
     * Returns total count of all found items.
     */
    public int getTotalFoundCount() {
        return getCount("SELECT COUNT(*) FROM found_items WHERE is_approved=1");
    }

    // ─── Update ────────────────────────────────────────────────────────────

    /**
     * Updates the status of a found item (Available / Claimed / Closed).
     */
    public boolean updateStatus(int itemId, String status) {
        String sql = "UPDATE found_items SET status = ? WHERE item_id = ?";
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
     * Approves or rejects a found item post (admin action).
     */
    public boolean setApproval(int itemId, boolean approved) {
        String sql = "UPDATE found_items SET is_approved = ? WHERE item_id = ?";
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
     * Deletes a found item record by ID.
     */
    public boolean deleteFoundItem(int itemId) {
        String sql = "DELETE FROM found_items WHERE item_id = ?";
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

    private List<FoundItem> queryItems(String sql, List<String> params) {
        List<FoundItem> items = new ArrayList<>();
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

    private List<FoundItem> queryItemsWithIntParam(String sql, int param) {
        List<FoundItem> items = new ArrayList<>();
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

    /** Maps a ResultSet row to a FoundItem object. */
    private FoundItem mapRow(ResultSet rs) throws SQLException {
        FoundItem item = new FoundItem();
        item.setItemId(rs.getInt("item_id"));
        item.setUserId(rs.getInt("user_id"));
        item.setItemName(rs.getString("item_name"));
        item.setCategory(rs.getString("category"));
        item.setDescription(rs.getString("description"));
        item.setDateFound(rs.getDate("date_found"));
        item.setLocation(rs.getString("location"));
        item.setImagePath(rs.getString("image_path"));
        item.setContactInfo(rs.getString("contact_info"));
        item.setStatus(rs.getString("status"));
        item.setApproved(rs.getBoolean("is_approved"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        try { item.setReporterName(rs.getString("reporter_name")); } catch (SQLException ignored) {}
        try { item.setReporterUSN(rs.getString("reporter_usn"));  } catch (SQLException ignored) {}
        return item;
    }
}
