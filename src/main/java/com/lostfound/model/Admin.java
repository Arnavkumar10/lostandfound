package com.lostfound.model;

import java.sql.Timestamp;

/**
 * Model class representing an admin account.
 */
public class Admin {

    private int adminId;
    private String username;
    private String passwordHash;
    private String email;
    private String fullName;
    private Timestamp createdAt;

    // ─── Constructors ──────────────────────────────────────────────

    public Admin() {}

    public Admin(int adminId, String username, String email, String fullName, Timestamp createdAt) {
        this.adminId = adminId;
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.createdAt = createdAt;
    }

    // ─── Getters & Setters ─────────────────────────────────────────

    public int getAdminId()                  { return adminId; }
    public void setAdminId(int adminId)      { this.adminId = adminId; }

    public String getUsername()              { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash()                  { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getEmail()                 { return email; }
    public void setEmail(String email)       { this.email = email; }

    public String getFullName()              { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Timestamp getCreatedAt()               { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Admin{adminId=" + adminId + ", username='" + username + "'}";
    }
}
