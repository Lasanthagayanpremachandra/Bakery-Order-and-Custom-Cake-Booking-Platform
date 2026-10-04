package com.bakery.model;

/**
 * Represents a review written by a public visitor or customer.
 * Demonstrates Inheritance from Review.
 */
public class PublicReview extends Review {

    public PublicReview() {
        super();
    }

    public PublicReview(String reviewId, String productOrBookingId, String customerId, String customerName, int rating, String comment, String reviewDate, boolean approved) {
        super(reviewId, productOrBookingId, customerId, customerName, rating, comment, reviewDate, approved);
    }

    @Override
    public String getBadgeHTML() {
        return "<span class=\"badge badge-soft\">Public Reviewer</span>";
    }

    @Override
    public String formatDisplay(boolean isAdminView) {
        String base = getCustomerName() + " (Rating: " + getRating() + "/5): \"" + getComment() + "\"";
        if (isAdminView) {
            return "[PUBLIC REVIEW - ID: " + getReviewId() + " Status: " + (isApproved() ? "Approved" : "Pending") + "] " + base;
        }
        return base;
    }
}
