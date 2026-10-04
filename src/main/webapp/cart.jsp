<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Customer" %>
<%@ page import="com.bakery.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%
    Customer user = (Customer) session.getAttribute("currentUser");
    @SuppressWarnings("unchecked")
    List<OrderItem> cart = (List<OrderItem>) session.getAttribute("cart");

    double rawSubtotal = 0.0;
    if (cart != null) {
        for (OrderItem item : cart) {
            rawSubtotal += item.getSubtotal();
        }
    }

    double discount = 0.0;
    if (user != null) {
        discount = user.calculateLoyaltyDiscount(rawSubtotal);
    }
    double grandTotal = Math.max(0.0, rawSubtotal - discount);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Basket & Checkout | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Header Ribbon -->
        <div style="margin-bottom: 2.5rem;">
            <span class="hero-luxury-tag">
                <span>🧺</span>
                <span>Artisan Morning Basket</span>
            </span>
            <h1 style="font-size: 2.8rem; margin-top: 0.4rem;">Your Curated Bakery Basket</h1>
            <p style="color: var(--c-cacao-muted); font-size: 0.95rem;">Review your freshly packed morning pastries, artisan hearth loaves, and signature cakes.</p>
        </div>

        <% if (cart == null || cart.isEmpty()) { %>
            <div style="text-align: center; padding: 5rem 1rem; background: #FFFFFF; border-radius: var(--r-lg); border: 1px dashed var(--c-border); max-width: 700px; margin: 0 auto; box-shadow: var(--shadow-subtle);">
                <span style="font-size: 4rem; display: block; margin-bottom: 1rem;">🧺</span>
                <h3 style="font-size: 2rem; margin-bottom: 0.5rem;">Your Basket is Empty</h3>
                <p style="color: var(--c-cacao-muted); margin-bottom: 2rem; font-size: 1rem;">
                    Discover our French viennoiserie, slow-fermented sourdoughs, and artisan cakes.
                </p>
                <a href="<%= request.getContextPath() %>/product/list" class="btn btn-primary" style="padding: 0.9rem 2rem;">
                    🥐 Explore Artisan Menu &rarr;
                </a>
            </div>
        <% } else { %>
            <div style="display: grid; grid-template-columns: 1.7fr 1.3fr; gap: 2.5rem; align-items: flex-start;">
                <!-- Left: Line Items List -->
                <div class="form-panel" style="padding: 2rem;">
                    <h3 style="font-size: 1.4rem; margin-bottom: 1.5rem; border-bottom: 1.5px solid var(--c-border); padding-bottom: 0.8rem; display: flex; justify-content: space-between; align-items: center;">
                        <span>Basket Items</span>
                        <span class="badge badge-soft"><%= cart.size() %> Selection(s)</span>
                    </h3>

                    <div style="display: flex; flex-direction: column; gap: 1.2rem;">
                        <% for (OrderItem item : cart) { %>
                            <div style="display: flex; align-items: center; justify-content: space-between; padding: 1rem; background: var(--c-bg); border: 1px solid var(--c-border); border-radius: var(--r-sm); transition: var(--ease-smooth);">
                                <div style="display: flex; align-items: center; gap: 1rem;">
                                    <div style="width: 48px; height: 48px; border-radius: var(--r-sm); background: #FFFDF9; border: 1px solid var(--c-border); display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                                        🥐
                                    </div>
                                    <div>
                                        <h4 style="font-size: 1.15rem; color: var(--c-cacao);"><%= item.getProductName() %></h4>
                                        <div style="font-size: 0.78rem; color: var(--c-cacao-muted); font-family: monospace;">Ref: <%= item.getProductId() %></div>
                                        <div style="font-size: 0.82rem; color: var(--c-caramel); font-weight: 600; margin-top: 2px;">
                                            $<%= String.format("%.2f", item.getUnitPrice()) %> each × <%= item.getQuantity() %>
                                        </div>
                                    </div>
                                </div>

                                <div style="display: flex; align-items: center; gap: 1.5rem;">
                                    <span style="font-family: var(--font-heading); font-size: 1.4rem; font-weight: 700; color: var(--c-cacao);">
                                        $<%= String.format("%.2f", item.getSubtotal()) %>
                                    </span>
                                    <a href="<%= request.getContextPath() %>/order/remove-cart?productId=<%= item.getProductId() %>" 
                                       class="btn-logout" title="Remove item" style="width: 28px; height: 28px;">
                                        ✕
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <div style="margin-top: 1.5rem; text-align: right;">
                        <a href="<%= request.getContextPath() %>/product/list" class="btn btn-secondary btn-sm">
                            + Add More Bakery Items
                        </a>
                    </div>
                </div>

                <!-- Right: Checkout & Settlement Panel -->
                <form action="<%= request.getContextPath() %>/order/place" method="POST" class="form-panel" style="position: sticky; top: 90px;">
                    <h3 style="font-size: 1.4rem; margin-bottom: 1.5rem; border-bottom: 1.5px solid var(--c-border); padding-bottom: 0.8rem;">
                        Summary & Settlement
                    </h3>

                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.8rem; font-size: 0.95rem;">
                        <span style="color: var(--c-cacao-muted);">Items Subtotal:</span>
                        <strong style="font-size: 1.1rem;">$<%= String.format("%.2f", rawSubtotal) %></strong>
                    </div>

                    <% if (user != null) { %>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.8rem; font-size: 0.95rem; color: #15803D; background: #DCFCE7; padding: 0.6rem 0.9rem; border-radius: var(--r-sm); border: 1px solid #BBF7D0;">
                            <span>👑 <%= user.getMembershipBadge() %>:</span>
                            <strong>-$<%= String.format("%.2f", discount) %></strong>
                        </div>
                    <% } else { %>
                        <div style="background: var(--c-gold-subtle); border: 1px solid #FDE68A; padding: 0.8rem 1rem; border-radius: var(--r-sm); margin-bottom: 1.2rem; font-size: 0.82rem; color: #92400E;">
                            💡 Tip: <a href="<%= request.getContextPath() %>/customer/login" style="font-weight: 700; text-decoration: underline;">Sign in as Eleanor</a> to unlock <strong>12% Gold VIP discount</strong>!
                        </div>
                    <% } %>

                    <div style="display: flex; justify-content: space-between; align-items: baseline; margin: 1.2rem 0; padding-top: 1rem; border-top: 2px solid var(--c-border);">
                        <span style="font-size: 1.1rem; font-weight: 700; color: var(--c-cacao);">Payable Balance:</span>
                        <span style="font-family: var(--font-heading); font-size: 2.2rem; font-weight: 800; color: var(--c-caramel);">
                            $<%= String.format("%.2f", grandTotal) %>
                        </span>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Recipient Name</label>
                        <input type="text" name="customerName" class="form-control" value="<%= user != null ? user.getName() : "" %>" placeholder="e.g. Eleanor Vance" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Delivery Destination / Pickup Note</label>
                        <input type="text" name="deliveryAddress" class="form-control" value="<%= user != null && user.getAddress() != null ? user.getAddress() : "" %>" placeholder="e.g. 742 Evergreen Terrace, or Counter Pickup at 10 AM" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Payment Settlement Method</label>
                        <div class="payment-selector-grid" style="margin-bottom: 0;">
                            <label class="payment-method-card selected">
                                <input type="radio" name="paymentMethod" value="CARD" checked style="accent-color: var(--c-caramel);">
                                <div class="method-info">
                                    <strong>Credit / Debit Card</strong>
                                    <small>Instant authorization</small>
                                </div>
                            </label>
                            <label class="payment-method-card">
                                <input type="radio" name="paymentMethod" value="CASH" style="accent-color: var(--c-caramel);">
                                <div class="method-info">
                                    <strong>Cash on Hand</strong>
                                    <small>Counter / Courier</small>
                                </div>
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1.05rem; margin-top: 1rem;">
                        Confirm & Place Order &rarr;
                    </button>
                </form>
            </div>
        <% } %>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
