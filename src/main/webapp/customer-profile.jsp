<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Customer" %>
<%
    Customer user = (Customer) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/customer/login");
        return;
    }
    boolean isGoldVip = "PREMIUM".equalsIgnoreCase(user.getType());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Patron Profile & VIP Pass | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
    <style>
        .profile-container {
            max-width: 760px;
            margin: 0 auto;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div class="profile-container">
            <div style="margin-bottom: 2rem;">
                <span class="hero-badge">👤 Patron Dashboard</span>
                <h1 style="font-size: 2.3rem; margin-top: 0.4rem;">Customer Profile & Rewards</h1>
                <p style="color: var(--c-cacao-muted);">
                    Manage your contact details, delivery destination, and patron membership tier.
                </p>
            </div>

            <!-- Digital Membership Pass -->
            <div class="vip-pass-card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2rem;">
                    <div>
                        <div style="font-size: 0.76rem; text-transform: uppercase; letter-spacing: 1.5px; color: #D4AF37; font-weight: 800;">
                            Patron Privilege Card
                        </div>
                        <div style="font-family: var(--font-heading); font-size: 1.8rem; font-weight: 700; color: #FFFFFF; margin-top: 0.2rem;">
                            <%= isGoldVip ? "👑 Gold VIP Privilege Member" : "⭐ Regular Artisan Patron" %>
                        </div>
                    </div>
                    <span class="badge <%= isGoldVip ? "badge-gold" : "badge-soft" %>" style="font-size: 0.85rem; padding: 0.4rem 0.9rem;">
                        <%= isGoldVip ? "12% SAVINGS ACTIVE" : "STANDARD TIER" %>
                    </span>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                    <div>
                        <div style="font-size: 0.72rem; text-transform: uppercase; color: #D9C5B8; letter-spacing: 0.8px;">Patron Name</div>
                        <div style="font-size: 1.25rem; font-weight: 700; color: #FFFFFF; font-family: var(--font-heading);"><%= user.getName() %></div>
                        <div style="font-size: 0.8rem; color: #D4AF37; margin-top: 0.2rem;">ID: <%= user.getId() %></div>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-size: 0.72rem; text-transform: uppercase; color: #D9C5B8; letter-spacing: 0.8px;">Bakery Perks</div>
                        <div style="font-size: 0.88rem; color: #FFFFFF; font-weight: 600;">
                            <%= isGoldVip ? "Free Priority Custom Consultation + 12% Off" : "Standard Loyalty Points" %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Profile Details Form -->
            <form action="<%= request.getContextPath() %>/customer/update" method="POST" class="form-panel">
                <input type="hidden" name="id" value="<%= user.getId() %>">

                <div style="display: flex; align-items: center; justify-content: space-between; background: var(--c-bg-subtle); padding: 1.2rem 1.5rem; border-radius: var(--r-sm); margin-bottom: 1.8rem; border: 1px solid var(--c-border);">
                    <div>
                        <span style="font-size: 0.78rem; text-transform: uppercase; font-weight: 800; color: var(--c-caramel); letter-spacing: 0.6px;">
                            Membership Tier Setting
                        </span>
                        <div style="font-size: 1.15rem; font-weight: 700; color: var(--c-cacao); margin-top: 0.2rem;">
                            <%= user.getMembershipBadge() %>
                        </div>
                    </div>
                    <div style="min-width: 200px;">
                        <select name="type" class="form-control" style="background: #FFF; font-weight: 600;">
                            <option value="REGULAR" <%= "REGULAR".equalsIgnoreCase(user.getType()) ? "selected" : "" %>>Regular Member</option>
                            <option value="PREMIUM" <%= "PREMIUM".equalsIgnoreCase(user.getType()) ? "selected" : "" %>>👑 Gold VIP (12% OFF)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Full Patron Name</label>
                    <input type="text" name="name" class="form-control" value="<%= user.getName() %>" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem;">
                    <div class="form-group">
                        <label class="form-label">Primary Telephone</label>
                        <input type="tel" name="phone" class="form-control" value="<%= user.getPhone() %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control" value="<%= user.getEmail() %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Delivery Destination / Street Address</label>
                    <input type="text" name="address" class="form-control" value="<%= user.getAddress() %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label">New Account Password (leave blank to keep current)</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••">
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 2.2rem; padding-top: 1.5rem; border-top: 1px solid var(--c-border-light); flex-wrap: wrap; gap: 1rem;">
                    <a href="<%= request.getContextPath() %>/order/track" class="btn btn-secondary">
                        📦 View My Active Orders
                    </a>
                    <button type="submit" class="btn btn-primary" style="padding: 0.8rem 1.8rem;">
                        Save Profile Updates
                    </button>
                </div>
            </form>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
