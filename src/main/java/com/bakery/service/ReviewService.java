package com.bakery.service;

import com.bakery.dao.ReviewFileDAO;
import com.bakery.model.PublicReview;
import com.bakery.model.Review;
import com.bakery.model.VerifiedPurchaseReview;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

/**
 * Service Layer for Feedback and Review Management.
 */
public class ReviewService {
    private final ReviewFileDAO reviewDAO;

    public ReviewService() {
        this.reviewDAO = new ReviewFileDAO();
    }

    public Review submitReview(String targetId, String customerId, String customerName, int rating, String comment, boolean isVerified) {
        String id = "REV-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        Review review;
        if (isVerified) {
            review = new VerifiedPurchaseReview(id, targetId, customerId, customerName, rating, comment, dateStr, true, targetId);
        } else {
            review = new PublicReview(id, targetId, customerId, customerName, rating, comment, dateStr, true);
        }

        boolean ok = reviewDAO.save(review);
        return ok ? review : null;
    }

    public List<Review> getReviewsForItem(String targetId) {
        return reviewDAO.findByTargetId(targetId);
    }

    public List<Review> getAllReviews() {
        return reviewDAO.getAll();
    }

    public Review getReview(String reviewId) {
        return reviewDAO.findById(reviewId);
    }

    public boolean editReview(String reviewId, int newRating, String newComment) {
        Review r = reviewDAO.findById(reviewId);
        if (r != null) {
            r.setRating(newRating);
            r.setComment(newComment);
            return reviewDAO.save(r);
        }
        return false;
    }

    public boolean deleteReview(String reviewId) {
        return reviewDAO.delete(reviewId);
    }

    public boolean moderate(String reviewId, boolean approve) {
        Review r = reviewDAO.findById(reviewId);
        if (r != null) {
            r.setApproved(approve);
            return reviewDAO.save(r);
        }
        return false;
    }
}
