package com.bakery.dao;

import com.bakery.model.PublicReview;
import com.bakery.model.Review;
import com.bakery.model.VerifiedPurchaseReview;
import com.bakery.util.FileUtil;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * File I/O Data Access Object for Customer Feedback & Reviews.
 * Manages reviews.txt with support for Public and Verified Purchase reviews.
 */
public class ReviewFileDAO {
    private static final String FILE_NAME = "reviews.txt";

    private Path getFilePath() {
        return FileUtil.getDataFilePath(FILE_NAME);
    }

    public synchronized List<Review> getAll() {
        List<Review> list = new ArrayList<>();
        Path path = getFilePath();
        if (!Files.exists(path)) return list;

        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] p = line.split("\\|", -1);
                if (p.length >= 6) {
                    String rId = p[0];
                    String targetId = p[1];
                    String cId = p[2];
                    String cName = p[3];
                    int rating = 5;
                    try { rating = Integer.parseInt(p[4]); } catch (Exception ignored) {}
                    String comment = p[5];
                    String date = p.length >= 7 ? p[6] : "";
                    boolean approved = true;
                    if (p.length >= 8 && !p[7].isEmpty()) {
                        approved = Boolean.parseBoolean(p[7]);
                    }
                    String type = p.length >= 9 ? p[8] : "PUBLIC";

                    Review rev;
                    if ("VERIFIED".equalsIgnoreCase(type)) {
                        rev = new VerifiedPurchaseReview(rId, targetId, cId, cName, rating, comment, date, approved, targetId);
                    } else {
                        rev = new PublicReview(rId, targetId, cId, cName, rating, comment, date, approved);
                    }
                    list.add(rev);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    public synchronized Review findById(String reviewId) {
        if (reviewId == null) return null;
        for (Review r : getAll()) {
            if (reviewId.equalsIgnoreCase(r.getReviewId())) return r;
        }
        return null;
    }

    public synchronized List<Review> findByTargetId(String targetId) {
        List<Review> result = new ArrayList<>();
        if (targetId == null) return result;
        for (Review r : getAll()) {
            if (targetId.equalsIgnoreCase(r.getProductOrBookingId())) {
                result.add(r);
            }
        }
        return result;
    }

    public synchronized boolean save(Review review) {
        if (review == null) return false;
        List<Review> all = getAll();
        boolean exists = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getReviewId().equalsIgnoreCase(review.getReviewId())) {
                all.set(i, review);
                exists = true;
                break;
            }
        }
        if (!exists) {
            all.add(0, review);
        }
        return writeAll(all);
    }

    public synchronized boolean delete(String reviewId) {
        if (reviewId == null) return false;
        List<Review> all = getAll();
        boolean removed = all.removeIf(r -> r.getReviewId().equalsIgnoreCase(reviewId));
        if (removed) {
            return writeAll(all);
        }
        return false;
    }

    private synchronized boolean writeAll(List<Review> list) {
        Path path = getFilePath();
        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
            for (Review r : list) {
                writer.write(r.toFileString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
