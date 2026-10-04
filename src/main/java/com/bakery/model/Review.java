package com.bakery.model;

/**
 * Base abstract class for Reviews and Feedback.
 * Demonstrates Encapsulation and Polymorphism in render displays.
 */
public abstract class Review {
    private String reviewId;
    private String productOrBookingId;
    private String customerId;
    private String customerName;
    private int rating; // 1 - 5 stars
    private String comment;
    private String reviewDate;
    private boolean approved;

    public Review() {
        this.approved = true; // default approved
    }

    public Review(String reviewId, String productOrBookingId, String customerId, String customerName, int rating, String comment, String reviewDate, boolean approved) {
        this.reviewId = reviewId;
        this.productOrBookingId = productOrBookingId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.approved = approved;
    }

    // Abstract methods showing Polymorphism
    public abstract String getBadgeHTML();
    public abstract String formatDisplay(boolean isAdminView);

    public String getReviewId() { return reviewId; }
    public void setReviewId(String reviewId) { this.reviewId = reviewId; }

    public String getProductOrBookingId() { return productOrBookingId; }
    public void setProductOrBookingId(String productOrBookingId) { this.productOrBookingId = productOrBookingId; }

    public String getCustomerId() { return customerId; }
    public void setCustomerId(String customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = Math.max(1, Math.min(5, rating)); }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public String getReviewDate() { return reviewDate; }
    public void setReviewDate(String reviewDate) { this.reviewDate = reviewDate; }

    public boolean isApproved() { return approved; }
    public void setApproved(boolean approved) { this.approved = approved; }

    // File format: reviewId|productOrBookingId|customerId|customerName|rating|comment|reviewDate|approved|type
    public String toFileString() {
        return String.join("|",
            reviewId != null ? reviewId : "",
            productOrBookingId != null ? productOrBookingId : "",
            customerId != null ? customerId : "",
            customerName != null ? customerName.replace("|", " ") : "Customer",
            String.valueOf(rating),
            comment != null ? comment.replace("|", " ").replace("\n", " ") : "",
            reviewDate != null ? reviewDate : "",
            String.valueOf(approved),
            this instanceof VerifiedPurchaseReview ? "VERIFIED" : "PUBLIC"
        );
    }
}
