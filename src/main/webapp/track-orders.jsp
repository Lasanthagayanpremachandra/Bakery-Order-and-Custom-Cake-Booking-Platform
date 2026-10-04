<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Order" %>
<%@ page import="com.bakery.model.CakeBooking" %>
<%@ page import="java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    @SuppressWarnings("unchecked")
    List<CakeBooking> bookings = (List<CakeBooking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live Order & Cake Tracker | La Petite Patisserie</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Visual Progression Timeline Header -->
        <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-lg); padding: 2.5rem 3rem; margin-bottom: 3.5rem; box-shadow: var(--shadow-subtle);">
            <div style="text-align: center; margin-bottom: 2rem;">
                <span class="hero-luxury-tag">
                    <span>📍</span>
                    <span>Haute Pâtisserie Kitchen Stage Monitor</span>
                </span>
                <h1 style="font-size: 2.5rem; margin-top: 0.3rem;">Order & Celebration Cake Status</h1>
                <p style="color: var(--c-cacao-muted); max-width: 580px; margin: 0 auto; font-size: 0.95rem;">
                    Follow your artisanal bake through each master stage: from flour weighing and slow oven bake to hand-sculpted sugar finishing.
                </p>
            </div>

            <!-- Visual Stage Pipeline -->
            <div class="timeline-bar">
                <div class="timeline-step completed">
                    <div class="step-node">✓</div>
                    <div class="step-title">1. Confirmed</div>
                </div>
                <div class="timeline-step active">
                    <div class="step-node">🔥</div>
                    <div class="step-title">2. In Oven / Baking</div>
                </div>
                <div class="timeline-step">
                    <div class="step-node">🎨</div>
                    <div class="step-title">3. Decorating Art</div>
                </div>
                <div class="timeline-step">
                    <div class="step-node">📦</div>
                    <div class="step-title">4. Ready / Boxed</div>
                </div>
                <div class="timeline-step">
                    <div class="step-node">🎉</div>
                    <div class="step-title">5. Handed Over</div>
                </div>
            </div>
        </div>

        <!-- Lookup bar -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h2 style="font-size: 2rem;">🎂 Custom Cake Atelier Bookings</h2>
                <p style="color: var(--c-cacao-muted); font-size: 0.9rem;">Made-to-order couture cakes and wedding centerpieces.</p>
            </div>

            <form action="<%= request.getContextPath() %>/order/track" method="GET" style="display: flex; gap: 0.5rem;">
                <input type="text" name="q" placeholder="Enter Reference # (e.g. CAKE-901)" class="form-control" style="background: #FFFFFF; min-width: 280px; border-radius: var(--r-full);">
                <button type="submit" class="btn btn-primary btn-sm">Find Order</button>
            </form>
        </div>

        <!-- Custom Cake Bookings Table -->
        <div class="bakery-table-wrap" style="margin-bottom: 4rem;">
            <table class="bakery-table">
                <thead>
                    <tr>
                        <th>Booking Reference</th>
                        <th>Patron</th>
                        <th>Architectural Specs</th>
                        <th>Celebration Occasion</th>
                        <th>Target Date</th>
                        <th>Stage Status</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (bookings == null || bookings.isEmpty()) { %>
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 3rem; color: var(--c-cacao-muted);">
                                No custom bookings found. <a href="<%= request.getContextPath() %>/booking/form" style="font-weight: 700; color: var(--c-caramel);">Reserve your kitchen slot now!</a>
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (CakeBooking b : bookings) { %>
                            <tr>
                                <td>
                                    <strong><%= b.getBookingId() %></strong>
                                    <div style="font-size: 0.76rem; color: var(--c-caramel); font-weight: 600;">Custom Atelier</div>
                                </td>
                                <td>
                                    <strong><%= b.getCustomerName() %></strong>
                                </td>
                                <td>
                                    <strong><%= b.getFlavour() %></strong>
                                    <div style="font-size: 0.8rem; color: var(--c-cacao-muted);"><%= b.getSize() %>, <%= b.getTiers() %> Tier(s) • <%= b.getDesign() %></div>
                                    <% if (b.getCustomMessage() != null && !b.getCustomMessage().isEmpty()) { %>
                                        <div style="font-size: 0.78rem; color: var(--c-caramel); font-style: italic;">Plaque: "<%= b.getCustomMessage() %>"</div>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="badge badge-soft"><%= b.getOccasion() %></span>
                                </td>
                                <td><strong><%= b.getRequiredDate() %></strong></td>
                                <td>
                                    <span class="status-pill status-<%= b.getStatus() %>">
                                        <%= b.getStatus() %>
                                    </span>
                                </td>
                                <td><strong style="font-size: 1.1rem;">$<%= String.format("%.2f", b.getTotalAmount()) %></strong></td>
                                <td>
                                    <div style="display: flex; gap: 0.5rem;">
                                        <a href="<%= request.getContextPath() %>/payment/invoice?refId=<%= b.getBookingId() %>" class="btn btn-secondary btn-sm" title="View Official Invoice">
                                            Invoice
                                        </a>
                                        <% if ("CONFIRMED".equalsIgnoreCase(b.getStatus())) { %>
                                            <a href="<%= request.getContextPath() %>/booking/cancel?bookingId=<%= b.getBookingId() %>" 
                                               onclick="return confirm('Cancel this custom cake booking?');" 
                                               class="btn btn-outline btn-sm" style="color: #DC2626; border-color: #FECACA;">
                                                Cancel
                                            </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Standard Orders Section -->
        <div>
            <div style="margin-bottom: 1.5rem;">
                <h2 style="font-size: 2rem;">🥐 Fresh Bakery Orders</h2>
                <p style="color: var(--c-cacao-muted); font-size: 0.9rem;">Counter pickup and scheduled daily courier deliveries.</p>
            </div>

            <div class="bakery-table-wrap">
                <table class="bakery-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Patron</th>
                            <th>Items Summary</th>
                            <th>Order Timestamp</th>
                            <th>Delivery Address</th>
                            <th>Kitchen Stage</th>
                            <th>Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (orders == null || orders.isEmpty()) { %>
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 2.5rem; color: var(--c-cacao-muted);">
                                    No standard bakery orders on record.
                                </td>
                            </tr>
                        <% } else { %>
                            <% for (Order o : orders) { %>
                                <tr>
                                    <td><strong><%= o.getOrderId() %></strong></td>
                                    <td><%= o.getCustomerName() %></td>
                                    <td>
                                        <div style="max-width: 260px; font-size: 0.85rem;">
                                            <%= o.getItems() != null && !o.getItems().isEmpty() ? o.getItems().size() + " artisan item(s)" : "Standard Order" %>
                                        </div>
                                    </td>
                                    <td><%= o.getOrderDate() %></td>
                                    <td><div style="max-width: 240px; font-size: 0.85rem;"><%= o.getDeliveryAddress() %></div></td>
                                    <td>
                                        <span class="status-pill status-<%= o.getStatus() %>">
                                            <%= o.getStatus() %>
                                        </span>
                                    </td>
                                    <td><strong>$<%= String.format("%.2f", o.getTotalAmount()) %></strong></td>
                                    <td>
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="<%= request.getContextPath() %>/payment/invoice?refId=<%= o.getOrderId() %>" class="btn btn-secondary btn-sm">
                                                Receipt
                                            </a>
                                            <% if (!"DELIVERED".equalsIgnoreCase(o.getStatus()) && !"CANCELLED".equalsIgnoreCase(o.getStatus())) { %>
                                                <a href="<%= request.getContextPath() %>/order/cancel?orderId=<%= o.getOrderId() %>" 
                                                   onclick="return confirm('Cancel this order?');"
                                                   class="btn btn-outline btn-sm" style="color: #DC2626; border-color: #FECACA;">
                                                    Cancel
                                                </a>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
