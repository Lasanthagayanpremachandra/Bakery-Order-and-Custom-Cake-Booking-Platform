<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="bakery-footer">
    <div class="footer-grid">
        <div class="footer-col">
            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.9rem;">
                <img src="<%= request.getContextPath() %>/images/sweetora-logo.png" alt="Sweetora Logo" style="width: 44px; height: 44px; border-radius: 50%; object-fit: cover; border: 2px solid #F3C68F; box-shadow: 0 4px 10px rgba(0,0,0,0.2);">
                <h4 style="margin: 0; font-family: 'Cormorant Garamond', Georgia, serif; font-size: 1.55rem; color: #FFFFFF; font-weight: 700;">Sweetora</h4>
            </div>
            <p>Crafting artisanal memories with authentic pastry techniques, slow-fermented hearth breads, and custom couture cakes designed for your most precious moments.</p>
            <p style="margin-top: 1rem; color: #E28743;"><strong>Open Daily:</strong> 7:00 AM – 9:00 PM</p>
        </div>
        <div class="footer-col">
            <h4>Explore Menu</h4>
            <ul>
                <li><a href="<%= request.getContextPath() %>/product/list?category=CAKE">Ready-Made Cakes</a></li>
                <li><a href="<%= request.getContextPath() %>/product/list?category=PASTRY">French Pastries</a></li>
                <li><a href="<%= request.getContextPath() %>/product/list?category=BREAD">Sourdough & Loaves</a></li>
                <li><a href="<%= request.getContextPath() %>/booking/form">Custom Cake Studio</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Customer Care</h4>
            <ul>
                <li><a href="<%= request.getContextPath() %>/order/track">Track Order / Booking</a></li>
                <li><a href="<%= request.getContextPath() %>/payment/history">Billing & Invoices</a></li>
                <li><a href="<%= request.getContextPath() %>/review/list">Customer Feedback</a></li>
                <li><a href="<%= request.getContextPath() %>/customer/profile">My Account</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Staff & Admin</h4>
            <ul>
                <li><a href="<%= request.getContextPath() %>/staff/login">Staff Login</a></li>
                <li><a href="<%= request.getContextPath() %>/staff/queue">Kitchen Production Queue</a></li>
                <li><a href="<%= request.getContextPath() %>/staff/dashboard">Management Portal</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <span>&copy; 2026 Sweetora & Cake Studio. SE1020 OOP Final Project.</span>
        <span>Built with Java Jakarta Servlets, OOP Principles & Artisan Design</span>
    </div>
</footer>
<script src="<%= request.getContextPath() %>/js/bakery-app.js"></script>
