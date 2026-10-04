<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patron Circle Registration | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div style="max-width: 580px; margin: 2rem auto;">
            <div style="text-align: center; margin-bottom: 2rem;">
                <span class="hero-luxury-tag">
                    <span>✨</span>
                    <span>Become an Artisan Patron</span>
                </span>
                <h1 style="font-size: 2.5rem; margin-top: 0.4rem; line-height: 1.15;">Join Our Bakery Circle</h1>
                <p style="color: var(--c-cacao-muted); font-size: 0.95rem;">
                    Unlock bespoke cake consultations, birthday celebration reminders, and exclusive VIP member savings.
                </p>
            </div>

            <% if (error != null) { %>
                <div style="background: #FEE2E2; color: #991B1B; border: 1px solid #FCA5A5; padding: 0.9rem 1.2rem; border-radius: var(--r-sm); margin-bottom: 1.5rem; font-size: 0.9rem;">
                    ⚠️ <%= error %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/customer/register" method="POST" class="form-panel">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g. Clara Oswald" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem;">
                    <div class="form-group">
                        <label class="form-label">Phone Number</label>
                        <input type="tel" name="phone" class="form-control" placeholder="+1 (555) 234-5678" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control" placeholder="clara@example.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Delivery Address</label>
                    <input type="text" name="address" class="form-control" placeholder="742 Evergreen Terrace, Springfield" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Create Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Select Membership Tier</label>
                    <select name="type" class="form-control" style="font-weight: 600;">
                        <option value="PREMIUM" selected>👑 Gold VIP Member (Instant 12% OFF Everything)</option>
                        <option value="REGULAR">Regular Patron (Standard Access + 5% on orders over $60)</option>
                    </select>
                </div>

                <div style="background: var(--c-bg-subtle); padding: 1rem 1.2rem; border-radius: var(--r-sm); border: 1px solid var(--c-border-light); margin-bottom: 1.5rem; font-size: 0.85rem; color: var(--c-cacao-muted);">
                    👑 <strong>VIP Privilege Guarantee:</strong> Gold members receive priority custom cake sculpting slots and 12% off all artisanal loaves, pastries, and gateaux.
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.9rem; font-size: 1.05rem;">
                    Complete Registration &rarr;
                </button>

                <div style="margin-top: 1.8rem; padding-top: 1.2rem; border-top: 1px solid var(--c-border-light); font-size: 0.9rem; text-align: center; color: var(--c-cacao-muted);">
                    Already registered? 
                    <a href="<%= request.getContextPath() %>/customer/login" style="font-weight: 700; color: var(--c-caramel);">Sign in here</a>
                </div>
            </form>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
