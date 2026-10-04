<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Customer" %>
<%
    Customer user = (Customer) session.getAttribute("currentUser");
    String targetId = (String) request.getAttribute("targetId");
    if (targetId == null) targetId = request.getParameter("targetId");
    if (targetId == null || targetId.trim().isEmpty()) targetId = "PROD-CK01";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Share Your Feedback | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
    <style>
        .star-rating-interactive {
            display: flex;
            gap: 0.4rem;
            font-size: 2.2rem;
            cursor: pointer;
            color: #CBD5E1;
            margin: 0.4rem 0 1rem;
            user-select: none;
        }
        .star-rating-interactive span {
            transition: transform 0.2s ease, color 0.2s ease;
        }
        .star-rating-interactive span:hover {
            transform: scale(1.2);
        }
        .star-rating-interactive span.active {
            color: #F59E0B;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div style="max-width: 620px; margin: 1.5rem auto;">
            <div style="text-align: center; margin-bottom: 2rem;">
                <span class="hero-luxury-tag">
                    <span>⭐</span>
                    <span>Patron Feedback</span>
                </span>
                <h1 style="font-size: 2.4rem; margin-top: 0.4rem;">Share Your Experience</h1>
                <p style="color: var(--c-cacao-muted); font-size: 0.95rem;">
                    Your impressions inspire our master pastry chefs and cake decorators to reach new heights.
                </p>
            </div>

            <form action="<%= request.getContextPath() %>/review/submit" method="POST" class="form-panel">
                <div class="form-group">
                    <label class="form-label">Reviewing Product Code or Cake Booking Reference</label>
                    <input type="text" name="targetId" class="form-control" value="<%= targetId %>" placeholder="e.g. PROD-CK01 or CAKE-1001" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Your Name</label>
                    <input type="text" name="customerName" class="form-control" value="<%= user != null ? user.getName() : "" %>" placeholder="e.g. Kavindu Perera" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Star Rating Score</label>
                    <input type="hidden" name="rating" id="ratingInput" value="5">
                    <div class="star-rating-interactive" id="starPicker">
                        <span class="active" data-val="1">★</span>
                        <span class="active" data-val="2">★</span>
                        <span class="active" data-val="3">★</span>
                        <span class="active" data-val="4">★</span>
                        <span class="active" data-val="5">★</span>
                    </div>
                    <div id="ratingText" style="font-size: 0.85rem; font-weight: 700; color: #D97706;">
                        5 Stars &mdash; Exceptional artisan craftsmanship
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Your Review & Taste Impressions</label>
                    <textarea name="comment" class="form-control" rows="4" placeholder="Tell us about the texture, moistness, sponge layers, aroma, or celebration reactions..." required></textarea>
                </div>

                <div class="form-group" style="background: var(--c-bg-subtle); padding: 1rem 1.2rem; border-radius: var(--r-sm); border: 1px solid var(--c-border-light);">
                    <label style="display: flex; align-items: center; gap: 0.65rem; font-size: 0.88rem; cursor: pointer; color: var(--c-cacao);">
                        <input type="checkbox" name="isVerified" value="true" <%= user != null ? "checked" : "" %> style="width: 18px; height: 18px; accent-color: var(--c-caramel);">
                        <span>I confirm this review is based on an authentic bakery purchase or celebration cake booking.</span>
                    </label>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 2rem; padding-top: 1.2rem; border-top: 1px solid var(--c-border-light); flex-wrap: wrap; gap: 1rem;">
                    <a href="<%= request.getContextPath() %>/review/list" class="btn btn-secondary">&larr; Read Other Reviews</a>
                    <button type="submit" class="btn btn-primary" style="padding: 0.8rem 1.8rem;">
                        Publish Review &rarr;
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script>
        const stars = document.querySelectorAll('#starPicker span');
        const input = document.getElementById('ratingInput');
        const text = document.getElementById('ratingText');

        const labels = {
            1: '1 Star &mdash; Needs refinement',
            2: '2 Stars &mdash; Below our usual standard',
            3: '3 Stars &mdash; Good, standard bakery quality',
            4: '4 Stars &mdash; Very delicious and enjoyable',
            5: '5 Stars &mdash; Exceptional artisan craftsmanship'
        };

        stars.forEach(star => {
            star.addEventListener('click', function() {
                const val = parseInt(this.getAttribute('data-val'));
                input.value = val;
                text.innerHTML = labels[val];
                stars.forEach(s => {
                    const sVal = parseInt(s.getAttribute('data-val'));
                    if (sVal <= val) {
                        s.classList.add('active');
                    } else {
                        s.classList.remove('active');
                    }
                });
            });
        });
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
