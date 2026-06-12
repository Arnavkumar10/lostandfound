package com.lostfound.model;

import java.sql.Timestamp;

/**
 * Model class representing a claim request made by a user for a found item.
 */
public class ClaimRequest {

    private int claimId;
    private int foundItemId;
    private int claimantUserId;

    // Joined fields for display
    private String foundItemName;
    private String claimantName;
    private String claimantUSN;

    private String proofDescription;
    private String status;          // Pending | Approved | Rejected
    private String adminNote;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // ─── Constructors ──────────────────────────────────────────────

    public ClaimRequest() {}

    // ─── Getters & Setters ─────────────────────────────────────────

    public int getClaimId()                  { return claimId; }
    public void setClaimId(int claimId)      { this.claimId = claimId; }

    public int getFoundItemId()              { return foundItemId; }
    public void setFoundItemId(int foundItemId){ this.foundItemId = foundItemId; }

    public int getClaimantUserId()                       { return claimantUserId; }
    public void setClaimantUserId(int claimantUserId)    { this.claimantUserId = claimantUserId; }

    public String getFoundItemName()                     { return foundItemName; }
    public void setFoundItemName(String foundItemName)   { this.foundItemName = foundItemName; }

    public String getClaimantName()                  { return claimantName; }
    public void setClaimantName(String claimantName) { this.claimantName = claimantName; }

    public String getClaimantUSN()               { return claimantUSN; }
    public void setClaimantUSN(String claimantUSN){ this.claimantUSN = claimantUSN; }

    public String getProofDescription()                      { return proofDescription; }
    public void setProofDescription(String proofDescription) { this.proofDescription = proofDescription; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public String getAdminNote()             { return adminNote; }
    public void setAdminNote(String adminNote){ this.adminNote = adminNote; }

    public Timestamp getCreatedAt()               { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt()               { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    /**
     * Returns Bootstrap badge CSS class based on claim status.
     */
    public String getStatusBadgeClass() {
        switch (status) {
            case "Approved": return "bg-success";
            case "Rejected": return "bg-danger";
            default:         return "bg-warning text-dark";
        }
    }

    @Override
    public String toString() {
        return "ClaimRequest{claimId=" + claimId + ", foundItemId=" + foundItemId
                + ", status='" + status + "'}";
    }
}
