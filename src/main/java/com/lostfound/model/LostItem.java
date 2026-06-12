package com.lostfound.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model class representing a lost item report submitted by a user.
 */
public class LostItem {

    private int itemId;
    private int userId;
    private String reporterName;    // joined from users table
    private String reporterUSN;     // joined from users table

    private String itemName;
    private String category;
    private String description;
    private Date dateLost;
    private String location;
    private String imagePath;
    private String contactInfo;
    private String status;          // Active | Recovered | Closed
    private boolean isApproved;
    private Timestamp createdAt;

    // ─── Constructors ──────────────────────────────────────────────

    public LostItem() {}

    // ─── Getters & Setters ─────────────────────────────────────────

    public int getItemId()                   { return itemId; }
    public void setItemId(int itemId)        { this.itemId = itemId; }

    public int getUserId()                   { return userId; }
    public void setUserId(int userId)        { this.userId = userId; }

    public String getReporterName()                  { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }

    public String getReporterUSN()               { return reporterUSN; }
    public void setReporterUSN(String reporterUSN){ this.reporterUSN = reporterUSN; }

    public String getItemName()              { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getCategory()              { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription()                   { return description; }
    public void setDescription(String description)   { this.description = description; }

    public Date getDateLost()                { return dateLost; }
    public void setDateLost(Date dateLost)   { this.dateLost = dateLost; }

    public String getLocation()              { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getImagePath()             { return imagePath; }
    public void setImagePath(String imagePath){ this.imagePath = imagePath; }

    public String getContactInfo()                   { return contactInfo; }
    public void setContactInfo(String contactInfo)   { this.contactInfo = contactInfo; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public boolean isApproved()              { return isApproved; }
    public void setApproved(boolean approved){ isApproved = approved; }

    public Timestamp getCreatedAt()               { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    /**
     * Returns a Bootstrap badge CSS class based on item status.
     */
    public String getStatusBadgeClass() {
        switch (status) {
            case "Recovered": return "bg-success";
            case "Closed":    return "bg-secondary";
            default:          return "bg-danger";
        }
    }

    /**
     * Returns a category icon class (Font Awesome).
     */
    public String getCategoryIcon() {
        switch (category) {
            case "Electronics":  return "fa-laptop";
            case "Documents":    return "fa-id-card";
            case "Accessories":  return "fa-glasses";
            case "Stationery":   return "fa-pencil";
            case "Clothing":     return "fa-shirt";
            case "Keys":         return "fa-key";
            case "Wallet/Purse": return "fa-wallet";
            case "Books":        return "fa-book";
            default:             return "fa-box";
        }
    }

    @Override
    public String toString() {
        return "LostItem{itemId=" + itemId + ", itemName='" + itemName + "', status='" + status + "'}";
    }
}
