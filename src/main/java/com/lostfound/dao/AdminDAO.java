package com.lostfound.dao;

import com.lostfound.model.Admin;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

/**
 * Data Access Object for the {@code admins} table.
 */
public class AdminDAO {

    /**
     * Authenticates an admin by username and password.
     *
     * @param username      admin username
     * @param plainPassword plaintext password
     * @return Admin object on success, null on failure
     */
    public Admin authenticate(String username, String plainPassword) {
        String sql = "SELECT * FROM admins WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                if (BCrypt.checkpw(plainPassword, storedHash)) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns a dashboard statistics map: totalLost, totalFound, recovered, totalUsers.
     */
    public int[] getDashboardStats() {
        // [0]=totalLost, [1]=totalFound, [2]=recovered, [3]=totalUsers, [4]=pendingClaims
        int[] stats = new int[5];
        String sql = "SELECT "
                   + "(SELECT COUNT(*) FROM lost_items  WHERE is_approved=1) AS total_lost, "
                   + "(SELECT COUNT(*) FROM found_items WHERE is_approved=1) AS total_found, "
                   + "(SELECT COUNT(*) FROM lost_items  WHERE status='Recovered') AS recovered, "
                   + "(SELECT COUNT(*) FROM users) AS total_users, "
                   + "(SELECT COUNT(*) FROM claim_requests WHERE status='Pending') AS pending_claims";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats[0] = rs.getInt("total_lost");
                stats[1] = rs.getInt("total_found");
                stats[2] = rs.getInt("recovered");
                stats[3] = rs.getInt("total_users");
                stats[4] = rs.getInt("pending_claims");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // ─── Mapper ────────────────────────────────────────────────────────────

    private Admin mapRow(ResultSet rs) throws SQLException {
        Admin a = new Admin();
        a.setAdminId(rs.getInt("admin_id"));
        a.setUsername(rs.getString("username"));
        a.setPasswordHash(rs.getString("password_hash"));
        a.setEmail(rs.getString("email"));
        a.setFullName(rs.getString("full_name"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}
