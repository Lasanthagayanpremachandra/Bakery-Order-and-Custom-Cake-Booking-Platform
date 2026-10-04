<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Review" %>
<%@ page import="java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    int approvedCount = 0;
    double sumRating = 0;
    if (reviews != null) {
        for (Review r : reviews) {
            if (r.isApproved()) {
                approvedCount++;
                sumRating += r.getRating();
            }
        }
    }
    double avgRating = approvedCount > 0 ? (sumRating / approvedCount) : 5.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patron Stories & Reviews | La Petite Patisserie</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Top Banner -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.5rem; flex-wrap: wrap; gap: 1.5rem;">
            <div>
                <span class="hero-luxury-tag">
                    <span>⭐</span>
                    <span>Sweet Testimonials</span>
                </span>
                <h1 style="font-size: 2.6rem; margin-top: 0.4rem; line-height: 1.15;">Customer Stories & Reviews</h1>
                <p style="color: var(--c-cacao-muted); font-size: 1rem;">
                    Heartwarming feedback from custom wedding cake commissions and morning pastry patrons.
                </p>
            </div>

            <div style="display: flex; gap: 0.8rem; align-items: center;">
                <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 0.8rem 1.4rem; text-align: right; box-shadow: var(--shadow-subtle);">
                    <div style="font-size: 1.25rem; font-weight: 800; color: #D97706;">
                        <%= String.format("%.1f", avgRating) %> ★★★★★
                    </div>
                    <div style="font-size: 0.76rem; color: var(--c-cacao-muted);">
                        Based on <%= approvedCount %> verified patron reviews
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/review/form" class="btn btn-primary" style="padding: 0.8rem 1.4rem;">
                    ✍️ Write a Review
                </a>
            </div>
        </div>

        <!-- Reviews Grid -->
        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.8rem;">
            <% if (reviews == null || approvedCount == 0) { %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem; background: #FFFFFF; border-radius: var(--r-lg); border: 1px dashed var(--c-border);">
                    <span style="font-size: 3rem;">🍰</span>
                    <h3 style="margin-top: 1rem; margin-bottom: 0.5rem; font-size: 1.4rem;">No customer reviews yet</h3>
                    <p style="color: var(--c-cacao-muted); margin-bottom: 1.5rem;">Be the very first patron to share your taste impressions with us!</p>
                    <a href="<%= request.getContextPath() %>/review/form" class="btn btn-primary">Submit First Review</a>
                </div>
            <% } else { %>
                <% for (Review r : reviews) { %>
                    <% if (r.isApproved()) { %>
                        <div style="background: #FFFFFF; border-radius: var(--r-md); padding: 1.8rem; border: 1px solid var(--c-border); box-shadow: var(--shadow-subtle); display: flex; flex-direction: column; transition: var(--ease-smooth);">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                <div style="color: #F59E0B; font-size: 1.2rem; letter-spacing: 2px;">
                                    <% for (int i = 0; i < r.getRating(); i++) { %>★<% } %>
                                    <% for (int i = r.getRating(); i < 5; i++) { %>☆<% } %>
                                </div>
                                <div><%= r.getBadgeHTML() %></div>
                            </div>

                            <p style="font-style: italic; font-size: 0.96rem; color: var(--c-cacao); line-height: 1.65; flex: 1; margin-bottom: 1.4rem;">
                                &ldquo;<%= r.getComment() %>&rdquo;
                            </p>

                            <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-top: 1rem; border-top: 1px solid var(--c-border-light); font-size: 0.82rem; color: var(--c-cacao-muted);">
                                <div>
                                    <strong style="color: var(--c-cacao); font-size: 0.95rem; display: block;"><%= r.getCustomerName() %></strong>
                                    <span style="font-family: monospace; color: var(--c-caramel); font-size: 0.78rem;">Ref: <%= r.getProductOrBookingId() %></span>
                                </div>
                                <div style="font-size: 0.8rem;"><%= r.getReviewDate() %></div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            <% } %>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
