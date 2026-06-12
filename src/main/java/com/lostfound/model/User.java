package com.lostfound.model;

import java.sql.Timestamp;

/**
 * Model class representing a registered student/staff user.
 */
public class User {

    private int userId;
    private String usn;          // University Seat Number / Roll Number
    private String fullName;
    private String email;
    private String phone;
    private String department;
    private String passwordHash;
    private boolean isActive;
    private Timestamp createdAt;

    // ─── Constructors ──────────────────────────────────────────────

    public User() {}

    public User(int userId, String usn, String fullName, String email,
                String phone, String department, boolean isActive, Timestamp createdAt) {
        this.userId = userId;
        this.usn = usn;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.department = department;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // ─── Getters & Setters ─────────────────────────────────────────

    public int getUserId()                   { return userId; }
    public void setUserId(int userId)        { this.userId = userId; }

    public String getUsn()                   { return usn; }
    public void setUsn(String usn)           { this.usn = usn; }

    public String getFullName()              { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail()                 { return email; }
    public void setEmail(String email)       { this.email = email; }

    public String getPhone()                 { return phone; }
    public void setPhone(String phone)       { this.phone = phone; }

    public String getDepartment()                    { return department; }
    public void setDepartment(String department)     { this.department = department; }

    public String getPasswordHash()                  { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public boolean isActive()                { return isActive; }
    public void setActive(boolean active)    { isActive = active; }

    public Timestamp getCreatedAt()              { return createdAt; }
    public void setCreatedAt(Timestamp createdAt){ this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", usn='" + usn + "', fullName='" + fullName + "'}";
    }
}
