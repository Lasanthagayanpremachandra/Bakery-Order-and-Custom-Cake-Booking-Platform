<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Customer" %>
<%
    Customer user = (Customer) session.getAttribute("currentUser");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Custom Cake Studio | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div style="margin-bottom: 2.5rem; text-align: center;">
            <span class="hero-luxury-tag">
                <span>🎨</span>
                <span>Haute Couture Made-To-Order Cake Studio</span>
            </span>
            <h1 style="font-size: 3rem; margin-top: 0.5rem; margin-bottom: 0.5rem;">The Custom Cake Atelier</h1>
            <p style="color: var(--c-cacao-muted); max-width: 650px; margin: 0 auto;">
                Co-design your culinary masterpiece. Watch the interactive visual preview update in real-time as you tailor sponges, tier architecture, and sugar art.
            </p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-error" style="max-width: 1100px; margin: 0 auto 2rem;">
                ⚠️ <%= error %>
            </div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1.3fr 0.9fr; gap: 3rem; align-items: flex-start; max-width: 1180px; margin: 0 auto;">
            <!-- Form Column -->
            <form id="customCakeForm" action="<%= request.getContextPath() %>/booking/create" method="POST" class="form-panel">
                <h3 style="font-size: 1.5rem; margin-bottom: 1.5rem; border-bottom: 1px solid var(--c-border); padding-bottom: 0.8rem;">
                    1. Architecture & Flavour Profile
                </h3>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                    <div class="form-group">
                        <label class="form-label">Artisan Sponge & Filling Flavour</label>
                        <select name="flavour" class="form-control" required>
                            <option value="Belgian Truffle" selected>Belgian Chocolate Truffle (+Rs. 15)</option>
                            <option value="Madagascan Vanilla Bean">Madagascan Bourbon Vanilla Bean</option>
                            <option value="Red Velvet Supreme">Red Velvet & Whipped Cream Cheese (+Rs. 15)</option>
                            <option value="Matcha Pistachio Cream">Uji Matcha & Roasted Pistachio (+Rs. 18)</option>
                            <option value="Salted Caramel Praline">Salted Butter Caramel & Praline (+Rs. 10)</option>
                            <option value="Black Forest Kirsch">Black Forest Morello Cherry (+Rs. 10)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Cake Size & Serving Capacity</label>
                        <select name="size" class="form-control" required>
                            <option value="1kg">1kg (Serves 6 - 8)</option>
                            <option value="2kg" selected>2kg (Serves 12 - 16) (+Rs. 25)</option>
                            <option value="3kg">3kg (Serves 22 - 28) (+Rs. 50)</option>
                            <option value="5kg">5kg Grand Gala (Serves 40+) (+Rs. 95)</option>
                        </select>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                    <div class="form-group">
                        <label class="form-label">Number of Tiers</label>
                        <select name="tiers" class="form-control" required>
                            <option value="1">1 Single Artisan Tier</option>
                            <option value="2" selected>2 Grand Architectural Tiers (+Rs. 30)</option>
                            <option value="3">3 Royal Couture Tiers (+Rs. 65)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Artisan Finish & Design Style</label>
                        <select name="design" class="form-control" required>
                            <option value="Vintage Floral & Gold Leaf" selected>Vintage Floral & 24K Gold Leaf (+Rs. 30)</option>
                            <option value="Custom Sculpted Fondant Art">Sculpted Fondant Art (+Rs. 40)</option>
                            <option value="Chocolate Drip & Fresh Berries">Gourmet Chocolate Drip & Berries (+Rs. 15)</option>
                            <option value="Modern Sculpted Waves">Modern Sculpted Waves</option>
                            <option value="Rustic Textured Buttercream">Rustic Swiss Buttercream</option>
                        </select>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                    <div class="form-group">
                        <label class="form-label">Celebration Occasion</label>
                        <select name="occasion" class="form-control" required>
                            <option value="Birthday">Birthday Celebration</option>
                            <option value="Wedding" selected>Wedding Centerpiece</option>
                            <option value="Anniversary">Romantic Anniversary</option>
                            <option value="Baby Shower">Baby Shower / Gender Reveal</option>
                            <option value="Graduation">Academic Graduation</option>
                            <option value="Corporate Celebration">Executive Gala</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Required Delivery / Pickup Date</label>
                        <input type="date" name="requiredDate" class="form-control" required min="2026-09-16" value="2026-09-24">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Piped Inscription / Cake Plaque Message</label>
                    <input type="text" name="customMessage" class="form-control" placeholder="e.g. Happy 25th Birthday Kavindu!" value="Happy Birthday Kavindu!">
                </div>

                <h3 style="font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1.5rem; border-bottom: 1px solid var(--c-border); padding-bottom: 0.8rem;">
                    2. Patron Contact & Deposit Option
                </h3>

                <div class="form-group">
                    <label class="form-label">Patron Full Name</label>
                    <input type="text" name="customerName" class="form-control" value="<%= user != null ? user.getName() : "" %>" placeholder="e.g. Kavindu Perera" required>
                </div>

                <div class="form-group" style="background: var(--c-gold-subtle); border: 1px solid #FDE68A; padding: 1.2rem; border-radius: var(--r-sm);">
                    <label style="display: flex; align-items: flex-start; gap: 0.8rem; cursor: pointer;">
                        <input type="checkbox" name="payDeposit" value="true" checked style="width: 20px; height: 20px; accent-color: var(--c-caramel); margin-top: 2px;">
                        <div>
                            <strong style="color: var(--c-cacao); font-size: 0.95rem; display: block;">Pay 30% Advance Deposit to Lock Kitchen Slot</strong>
                            <span style="font-size: 0.85rem; color: var(--c-cacao-muted);">Remaining balance settled upon cake collection or final delivery hand-off.</span>
                        </div>
                    </label>
                </div>

                <div style="text-align: right; margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1.05rem;">
                        Confirm Custom Cake & Proceed to Settlement &rarr;
                    </button>
                </div>
            </form>

            <!-- Sticky Visual Preview Stage Column -->
            <div class="cake-visual-stage">
                <span class="badge badge-gold" style="margin-bottom: 1rem;">
                    ✨ Real-Time Visual Atelier
                </span>
                
                <div class="cake-canvas-wrap" id="cakeVisualCanvas">
                    <!-- Rendered dynamically by bakery-app.js -->
                </div>

                <div id="visualInscriptionBadge" class="badge badge-soft" style="margin-bottom: 1.5rem; font-style: italic; font-size: 0.85rem;">
                    Piped Plaque: "Forever in Love"
                </div>

                <!-- Pricing Callout -->
                <div style="background: #FFFDF9; border: 2px dashed var(--c-border); border-radius: var(--r-md); padding: 1.5rem; margin-top: 1rem;">
                    <div style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1.5px; color: var(--c-cacao-muted); font-weight: 700;">
                        Custom Cake Total
                    </div>
                    <div id="estimatedPrice" style="font-family: var(--font-heading); font-size: 2.6rem; font-weight: 700; color: var(--c-cacao); margin: 0.3rem 0;">
                        Rs. 105.00
                    </div>
                    <div style="font-size: 0.9rem; color: var(--c-caramel); font-weight: 700;">
                        30% Advance Deposit: <span id="depositPrice">Rs. 31.50</span>
                    </div>
                </div>

                <div style="font-size: 0.78rem; color: var(--c-cacao-muted); margin-top: 1rem;">
                    🔒 Handcrafted in an approved sterile kitchen with strictly limited daily batch slots.
                </div>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
