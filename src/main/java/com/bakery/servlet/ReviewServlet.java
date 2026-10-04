package com.bakery.servlet;

import com.bakery.model.Customer;
import com.bakery.model.Review;
import com.bakery.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller Servlet for Feedback and Review Management.
 * Routes /review/submit, /review/list, /review/update, /review/delete, /review/moderate
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review/*"})
public class ReviewServlet extends HttpServlet {
    private ReviewService reviewService;

    @Override
    public void init() {
        reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/list";

        switch (path) {
            case "/form": {
                req.setAttribute("targetId", req.getParameter("targetId"));
                req.getRequestDispatcher("/submit-review.jsp").forward(req, resp);
                break;
            }
            case "/list": {
                String targetId = req.getParameter("targetId");
                List<Review> list;
                if (targetId != null && !targetId.trim().isEmpty()) {
                    list = reviewService.getReviewsForItem(targetId);
                } else {
                    list = reviewService.getAllReviews();
                }
                req.setAttribute("reviews", list);
                req.getRequestDispatcher("/reviews.jsp").forward(req, resp);
                break;
            }
            case "/moderate": {
                List<Review> list = reviewService.getAllReviews();
                req.setAttribute("reviews", list);
                req.getRequestDispatcher("/admin-reviews.jsp").forward(req, resp);
                break;
            }
            case "/delete": {
                String id = req.getParameter("id");
                if (id != null) {
                    reviewService.deleteReview(id);
                }
                resp.sendRedirect(req.getContextPath() + "/review/moderate?msg=deleted");
                break;
            }
            case "/toggle": {
                String id = req.getParameter("id");
                boolean approve = Boolean.parseBoolean(req.getParameter("approve"));
                if (id != null) {
                    reviewService.moderate(id, approve);
                }
                resp.sendRedirect(req.getContextPath() + "/review/moderate?msg=updated");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/review/list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        if ("/submit".equalsIgnoreCase(path)) {
            HttpSession session = req.getSession();
            Customer current = (Customer) session.getAttribute("currentUser");

            String targetId = req.getParameter("targetId");
            if (targetId == null || targetId.isEmpty()) targetId = "GENERAL";

            String custId = current != null ? current.getId() : "GUEST";
            String custName = req.getParameter("customerName");
            if (custName == null || custName.trim().isEmpty()) {
                custName = current != null ? current.getName() : "Happy Guest";
            }
            int rating = 5;
            try { rating = Integer.parseInt(req.getParameter("rating")); } catch (Exception ignored) {}
            String comment = req.getParameter("comment");
            boolean isVerified = "true".equalsIgnoreCase(req.getParameter("isVerified")) || current != null;

            reviewService.submitReview(targetId, custId, custName, rating, comment, isVerified);
            resp.sendRedirect(req.getContextPath() + "/review/list?msg=review_submitted");
        } else if ("/edit".equalsIgnoreCase(path)) {
            String id = req.getParameter("reviewId");
            int rating = 5;
            try { rating = Integer.parseInt(req.getParameter("rating")); } catch (Exception ignored) {}
            String comment = req.getParameter("comment");
            reviewService.editReview(id, rating, comment);
            resp.sendRedirect(req.getContextPath() + "/review/list?msg=edited");
        } else {
            resp.sendRedirect(req.getContextPath() + "/review/list");
        }
    }
}
