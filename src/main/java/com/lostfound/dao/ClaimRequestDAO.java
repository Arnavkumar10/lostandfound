package com.lostfound.dao;

import com.lostfound.model.ClaimRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the {@code claim_requests} table.
 * Handles creation, retrieval, and resolution of item claim requests.
 */
public class ClaimRequestDAO {

    // ─── Create ────────────────────────────────────────────────────────────

    /**
     * Submits a new claim request.
     *
     * @param claim the ClaimRequest to persist
     * @return true if saved successfully
     */
    public boolean submitClaim(ClaimRequest claim) {
        String sql = "INSERT INTO claim_requests (found_item_id, claimant_user_id, proof_description) "
                   + "VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt   (1, claim.getFoundItemId());
            ps.setInt   (2, claim.getClaimantUserId());
            ps.setString(3, claim.getProofDescription());

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            // Unique constraint violation = already claimed by this user
            if (e.getErrorCode() == 1062) return false;
            e.printStackTrace();
            return false;
        }
    }

    // ─── Read ──────────────────────────────────────────────────────────────

    /**
     * Returns all claim requests for a specific found item.
     */
    public List<ClaimRequest> getClaimsForItem(int foundItemId) {
        String sql = "SELECT cr.*, fi.item_name AS found_item_name, "
                   + "u.full_name AS claimant_name, u.usn AS claimant_usn "
                   + "FROM claim_requests cr "
                   + "JOIN found_items fi ON cr.found_item_id = fi.item_id "
                   + "JOIN users u ON cr.claimant_user_id = u.user_id "
                   + "WHERE cr.found_item_id = ? ORDER BY cr.created_at DESC";
        return queryWithInt(sql, foundItemId);
    }

    /**
     * Returns all claim requests submitted by a specific user.
     */
    public List<ClaimRequest> getClaimsByUser(int userId) {
        String sql = "SELECT cr.*, fi.item_name AS found_item_name, "
                   + "u.full_name AS claimant_name, u.usn AS claimant_usn "
                   + "FROM claim_requests cr "
                   + "JOIN found_items fi ON cr.found_item_id = fi.item_id "
                   + "JOIN users u ON cr.claimant_user_id = u.user_id "
                   + "WHERE cr.claimant_user_id = ? ORDER BY cr.created_at DESC";
        return queryWithInt(sql, userId);
    }

    /**
     * Returns all claim requests — for admin use.
     */
    public List<ClaimRequest> getAllClaims() {
        String sql = "SELECT cr.*, fi.item_name AS found_item_name, "
                   + "u.full_name AS claimant_name, u.usn AS claimant_usn "
                   + "FROM claim_requests cr "
                   + "JOIN found_items fi ON cr.found_item_id = fi.item_id "
                   + "JOIN users u ON cr.claimant_user_id = u.user_id "
                   + "ORDER BY cr.created_at DESC";
        List<ClaimRequest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Returns a single claim request by its ID.
     */
    public ClaimRequest getClaimById(int claimId) {
        String sql = "SELECT cr.*, fi.item_name AS found_item_name, "
                   + "u.full_name AS claimant_name, u.usn AS claimant_usn "
                   + "FROM claim_requests cr "
                   + "JOIN found_items fi ON cr.found_item_id = fi.item_id "
                   + "JOIN users u ON cr.claimant_user_id = u.user_id "
                   + "WHERE cr.claim_id = ?";
        List<ClaimRequest> r = queryWithInt(sql, claimId);
        return r.isEmpty() ? null : r.get(0);
    }

    /**
     * Checks whether a specific user has already claimed a found item.
     */
    public boolean hasClaimed(int foundItemId, int userId) {
        String sql = "SELECT COUNT(*) FROM claim_requests "
                   + "WHERE found_item_id = ? AND claimant_user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foundItemId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns count of pending claims.
     */
    public int getPendingClaimCount() {
        String sql = "SELECT COUNT(*) FROM claim_requests WHERE status='Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ─── Update ────────────────────────────────────────────────────────────

    /**
     * Resolves a claim request by approving or rejecting it.
     * If approved, the corresponding found item's status is updated to "Claimed".
     *
     * @param claimId   the claim to resolve
     * @param status    "Approved" or "Rejected"
     * @param adminNote an optional note from the admin/finder
     * @return true if resolved successfully
     */
    public boolean resolveClaim(int claimId, String status, String adminNote) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // Update claim status
            String updateClaim = "UPDATE claim_requests SET status = ?, admin_note = ? WHERE claim_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateClaim)) {
                ps.setString(1, status);
                ps.setString(2, adminNote);
                ps.setInt(3, claimId);
                ps.executeUpdate();
            }

            // If approved, mark the found item as Claimed
            if ("Approved".equals(status)) {
                String getFoundItemId = "SELECT found_item_id FROM claim_requests WHERE claim_id = ?";
                int foundItemId;
                try (PreparedStatement ps = conn.prepareStatement(getFoundItemId)) {
                    ps.setInt(1, claimId);
                    ResultSet rs = ps.executeQuery();
                    if (!rs.next()) { conn.rollback(); return false; }
                    foundItemId = rs.getInt(1);
                }

                String updateFoundItem = "UPDATE found_items SET status = 'Claimed' WHERE item_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateFoundItem)) {
                    ps.setInt(1, foundItemId);
                    ps.executeUpdate();
                }

                // Reject all other pending claims for this item
                String rejectOthers = "UPDATE claim_requests SET status='Rejected' "
                                    + "WHERE found_item_id = ? AND claim_id != ? AND status='Pending'";
                try (PreparedStatement ps = conn.prepareStatement(rejectOthers)) {
                    ps.setInt(1, foundItemId);
                    ps.setInt(2, claimId);
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    // ─── Helpers ───────────────────────────────────────────────────────────

    private List<ClaimRequest> queryWithInt(String sql, int param) {
        List<ClaimRequest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Maps a ResultSet row to a ClaimRequest object. */
    private ClaimRequest mapRow(ResultSet rs) throws SQLException {
        ClaimRequest cr = new ClaimRequest();
        cr.setClaimId(rs.getInt("claim_id"));
        cr.setFoundItemId(rs.getInt("found_item_id"));
        cr.setClaimantUserId(rs.getInt("claimant_user_id"));
        cr.setProofDescription(rs.getString("proof_description"));
        cr.setStatus(rs.getString("status"));
        cr.setAdminNote(rs.getString("admin_note"));
        cr.setCreatedAt(rs.getTimestamp("created_at"));
        cr.setUpdatedAt(rs.getTimestamp("updated_at"));
        try { cr.setFoundItemName(rs.getString("found_item_name")); } catch (SQLException ignored) {}
        try { cr.setClaimantName(rs.getString("claimant_name"));    } catch (SQLException ignored) {}
        try { cr.setClaimantUSN(rs.getString("claimant_usn"));      } catch (SQLException ignored) {}
        return cr;
    }
}
