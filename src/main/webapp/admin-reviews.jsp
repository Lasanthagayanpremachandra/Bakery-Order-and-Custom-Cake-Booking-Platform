<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Review" %>
<%@ page import="java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    int liveCount = 0;
    int hiddenCount = 0;
    if (reviews != null) {
        for (Review r : reviews) {
            if (r.isApproved()) liveCount++;
            else hiddenCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Moderation Panel | La Petite Patisserie</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <span class="hero-badge">⭐ Quality Control & Moderation</span>
                <h1 style="font-size: 2.3rem; margin-top: 0.4rem;">Feedback Moderation Panel</h1>
                <p style="color: var(--c-cacao-muted);">
                    Curate public testimonials, verify ratings, and audit feedback in <code>data/reviews.txt</code>.
                </p>
            </div>

            <div style="display: flex; gap: 0.8rem;">
                <a href="<%= request.getContextPath() %>/staff/dashboard" class="btn btn-secondary btn-sm">
                    &larr; Admin Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/review/list" class="btn btn-outline btn-sm">
                    Public Reviews Page &rarr;
                </a>
            </div>
        </div>

        <!-- KPI Badges -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.25rem; margin-bottom: 2.5rem;">
            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: #059669; letter-spacing: 0.6px;">Approved & Live</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: #065F46; margin-top: 0.2rem;">
                    <%= liveCount %>
                </div>
            </div>

            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: #DC2626; letter-spacing: 0.6px;">Pending / Hidden</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: #991B1B; margin-top: 0.2rem;">
                    <%= hiddenCount %>
                </div>
            </div>

            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: var(--c-caramel); letter-spacing: 0.6px;">Total Submissions</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin-top: 0.2rem;">
                    <%= reviews != null ? reviews.size() : 0 %>
                </div>
            </div>
        </div>

        <!-- Moderation Table -->
        <div class="bakery-table-wrap">
            <table class="bakery-table">
                <thead>
                    <tr>
                        <th>Review ID</th>
                        <th>Target Item</th>
                        <th>Patron Name</th>
                        <th>Rating</th>
                        <th>Feedback & OOP Polymorphic Representation</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th style="text-align: right;">Moderation Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (reviews == null || reviews.isEmpty()) { %>
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 3rem; color: var(--c-cacao-muted);">
                                No customer reviews submitted yet.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Review r : reviews) { %>
                            <tr>
                                <td>
                                    <strong style="font-family: monospace; color: var(--c-caramel); font-size: 0.88rem;">
                                        <%= r.getReviewId() %>
                                    </strong>
                                </td>
                                <td>
                                    <span class="badge badge-soft" style="font-family: monospace; font-size: 0.8rem;">
                                        <%= r.getProductOrBookingId() %>
                                    </span>
                                </td>
                                <td>
                                    <strong style="color: var(--c-cacao);"><%= r.getCustomerName() %></strong>
                                    <div><%= r.getBadgeHTML() %></div>
                                </td>
                                <td>
                                    <span style="color: #D97706; font-weight: 700; font-size: 0.95rem;">
                                        <%= r.getRating() %> / 5 ★
                                    </span>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem; max-width: 320px; line-height: 1.45; color: var(--c-cacao-light);">
                                        <%= r.formatDisplay(true) %>
                                    </div>
                                </td>
                                <td style="font-size: 0.85rem;"><%= r.getReviewDate() %></td>
                                <td>
                                    <% if (r.isApproved()) { %>
                                        <span class="badge badge-verified">Live (Approved)</span>
                                    <% } else { %>
                                        <span class="badge" style="background: #FEE2E2; color: #991B1B;">Hidden</span>
                                    <% } %>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: inline-flex; gap: 0.4rem;">
                                        <a href="<%= request.getContextPath() %>/review/toggle?id=<%= r.getReviewId() %>&approve=<%= !r.isApproved() %>" 
                                           class="btn btn-secondary btn-sm" style="padding: 0.25rem 0.6rem; font-size: 0.78rem;">
                                            <%= r.isApproved() ? "Hide" : "Approve" %>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/review/delete?id=<%= r.getReviewId() %>" 
                                           onclick="return confirm('Permanently delete review <%= r.getReviewId() %>?');" 
                                           class="btn btn-outline btn-sm" style="padding: 0.25rem 0.6rem; font-size: 0.78rem; color: #DC2626; border-color: #FECACA;">
                                            Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
