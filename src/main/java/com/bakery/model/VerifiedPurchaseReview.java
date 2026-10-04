package com.bakery.model;

/**
 * Represents a review verified against a real order or custom cake booking.
 * Demonstrates Inheritance from Review and Polymorphic badge styling.
 */
public class VerifiedPurchaseReview extends Review {
    private String orderId;

    public VerifiedPurchaseReview() {
        super();
    }

    public VerifiedPurchaseReview(String reviewId, String productOrBookingId, String customerId, String customerName, 
                                  int rating, String comment, String reviewDate, boolean approved, String orderId) {
        super(reviewId, productOrBookingId, customerId, customerName, rating, comment, reviewDate, approved);
        this.orderId = orderId;
    }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    @Override
    public String getBadgeHTML() {
        return "<span class=\"badge badge-verified\"><i class=\"fas fa-check-circle\"></i> Verified Buyer</span>";
    }

    @Override
    public String formatDisplay(boolean isAdminView) {
        String base = getCustomerName() + " (Verified Buyer - " + getRating() + "/5): \"" + getComment() + "\"";
        if (isAdminView) {
            return "[VERIFIED ORDER #" + (orderId != null ? orderId : getProductOrBookingId()) + " - Status: " + 
                   (isApproved() ? "Live" : "Under Review") + "] " + base;
        }
        return base;
    }
}
