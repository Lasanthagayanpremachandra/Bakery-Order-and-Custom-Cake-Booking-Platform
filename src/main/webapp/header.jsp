<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Customer" %>
<%@ page import="com.bakery.model.Staff" %>
<%@ page import="com.bakery.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%
    Customer currentUser = (Customer) session.getAttribute("currentUser");
    Staff staffUser = (Staff) session.getAttribute("staffUser");
    @SuppressWarnings("unchecked")
    List<OrderItem> headerCart = (List<OrderItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (headerCart != null) {
        for (OrderItem item : headerCart) cartCount += item.getQuantity();
    }
%>

<!-- Bulletproof Critical Floating Capsule Navigation Styles -->
<style>
/* Reset for Nav elements */
.bakery-floating-nav-wrapper *,
.bakery-floating-nav-wrapper *::before,
.bakery-floating-nav-wrapper *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

/* Announcement Strip */
.top-announcement {
    background: linear-gradient(90deg, #1C0F0A 0%, #2E170E 50%, #1C0F0A 100%);
    color: #F8EFEA;
    font-size: 0.78rem;
    padding: 0.45rem 1.5rem;
    letter-spacing: 0.35px;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}
.top-announcement-inner {
    max-width: 1400px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 0.6rem;
}
.announcement-left {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
.announcement-dot { opacity: 0.4; }
.announcement-right {
    display: flex;
    align-items: center;
    gap: 0.8rem;
}
.announcement-sep { opacity: 0.3; }
.announcement-link {
    color: #FFD188;
    text-decoration: none;
    font-weight: 600;
}
.announcement-link:hover {
    color: #FFE6BA;
    text-decoration: underline;
}

/* Floating Capsule Island Wrapper */
.bakery-floating-nav-wrapper {
    position: sticky;
    top: 12px;
    z-index: 1100;
    width: 100%;
    padding: 0 1.25rem;
    pointer-events: none;
}

.bakery-nav-capsule {
    pointer-events: auto;
    max-width: 1360px;
    margin: 0 auto;
    height: 66px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
    border: 1.5px solid rgba(228, 214, 198, 0.9);
    border-radius: 9999px;
    padding: 0 1.5rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
    box-shadow: 0 10px 32px rgba(34, 21, 16, 0.09), 0 2px 6px rgba(0, 0, 0, 0.03);
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
}

.bakery-nav-capsule:hover {
    box-shadow: 0 14px 40px rgba(34, 21, 16, 0.12), 0 2px 6px rgba(0, 0, 0, 0.04);
    border-color: rgba(212, 175, 55, 0.5);
}

/* Brand Emblem & Wordmark (Zone 1) */
.capsule-brand {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    text-decoration: none;
    flex-shrink: 0;
}

.capsule-emblem {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 3px 10px rgba(223, 131, 26, 0.25);
    transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
    flex-shrink: 0;
    overflow: hidden;
    background: #FFF;
    border: 2px solid #F3C68F;
}

.capsule-emblem img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

.capsule-brand:hover .capsule-emblem {
    transform: rotate(-8deg) scale(1.08);
}

.capsule-text-block {
    display: flex;
    flex-direction: column;
}

.capsule-brand-title {
    font-family: 'Cormorant Garamond', Georgia, serif;
    font-size: 1.45rem;
    font-weight: 700;
    line-height: 1.1;
    color: #221510;
    letter-spacing: -0.2px;
    white-space: nowrap;
}

.capsule-brand-subtitle {
    font-size: 0.6rem;
    text-transform: uppercase;
    letter-spacing: 1.6px;
    font-weight: 800;
    color: #C87A1E;
    white-space: nowrap;
    margin-top: 1px;
}

/* Center Navigation Links (Zone 2) */
.capsule-menu-center {
    display: flex;
    align-items: center;
}

.capsule-nav-list {
    display: flex;
    align-items: center;
    gap: 0.35rem;
    list-style: none;
    margin: 0;
    padding: 0;
}

.capsule-nav-link {
    color: #4A332A;
    font-weight: 600;
    font-size: 0.88rem;
    padding: 0.5rem 0.9rem;
    border-radius: 9999px;
    text-decoration: none;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    white-space: nowrap;
    line-height: 1;
}

.capsule-nav-link:hover {
    color: #C87A1E;
    background: rgba(200, 122, 30, 0.08);
}

.capsule-link-featured {
    background: linear-gradient(135deg, #FFF7EB 0%, #FEEBD4 100%);
    color: #92400E !important;
    border: 1px solid rgba(223, 131, 26, 0.3);
    font-weight: 700;
    box-shadow: 0 2px 6px rgba(223, 131, 26, 0.08);
}

.capsule-link-featured:hover {
    background: linear-gradient(135deg, #FEEBD4 0%, #FED8AD 100%);
    box-shadow: 0 4px 12px rgba(223, 131, 26, 0.18);
    transform: translateY(-1px);
}

.capsule-radar-dot {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #10B981;
    display: inline-block;
    box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.2);
    animation: live-radar 2s infinite;
}

@keyframes live-radar {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.2); opacity: 0.7; }
}

/* Mega Dropdown */
.capsule-dropdown-parent {
    position: relative;
}

.capsule-chevron {
    font-size: 0.65rem;
    transition: transform 0.25s ease;
    display: inline-block;
}

.capsule-dropdown-parent:hover .capsule-chevron {
    transform: rotate(180deg);
}

.capsule-dropdown-popover {
    display: none !important;
    position: absolute;
    top: 100%;
    left: 50%;
    transform: translateX(-50%) translateY(10px);
    width: 290px;
    background: #FFFFFF;
    border-radius: 16px;
    border: 1px solid #E8DCCF;
    padding: 0.75rem;
    box-shadow: 0 16px 36px rgba(34, 21, 16, 0.14);
    z-index: 1200;
}

.capsule-dropdown-parent:hover .capsule-dropdown-popover {
    display: block !important;
}

.capsule-dropdown-item {
    display: flex;
    align-items: center;
    gap: 0.85rem;
    padding: 0.7rem 0.85rem;
    border-radius: 10px;
    text-decoration: none;
    color: #221510;
    transition: background 0.2s ease;
}

.capsule-dropdown-item:hover {
    background: #F3ECE2;
}

.dropdown-item-icon {
    font-size: 1.35rem;
    width: 36px;
    height: 36px;
    background: #FFFDF9;
    border: 1px solid #E8DCCF;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.dropdown-item-info strong {
    display: block;
    font-size: 0.86rem;
    color: #221510;
}

.dropdown-item-info small {
    display: block;
    font-size: 0.74rem;
    color: #796155;
}

/* Zone 3: Right Actions */
.capsule-actions-right {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    flex-shrink: 0;
}

/* ⚡ Demo Switcher */
.capsule-demo-wrapper {
    position: relative;
}

.btn-capsule-demo {
    background: linear-gradient(135deg, #FEF3C7 0%, #FDE68A 100%);
    color: #92400E;
    border: 1.5px solid #FCD34D;
    font-size: 0.8rem;
    font-weight: 700;
    height: 38px;
    padding: 0 0.9rem;
    border-radius: 9999px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    transition: all 0.2s ease;
    box-shadow: 0 2px 6px rgba(245, 158, 11, 0.15);
    white-space: nowrap;
}

.btn-capsule-demo:hover {
    background: linear-gradient(135deg, #FDE68A 0%, #FBBF24 100%);
    transform: translateY(-1px);
    box-shadow: 0 4px 10px rgba(245, 158, 11, 0.25);
}

.capsule-demo-popover {
    display: none !important;
    position: absolute;
    top: 100%;
    right: 0;
    margin-top: 12px;
    width: 320px;
    background: #FFFFFF;
    border: 1px solid #E8DCCF;
    border-radius: 16px;
    padding: 0.85rem;
    box-shadow: 0 16px 40px rgba(34, 21, 16, 0.16);
    z-index: 1300;
}

.capsule-demo-popover.active {
    display: block !important;
}

.demo-popover-head {
    padding-bottom: 0.6rem;
    border-bottom: 1px solid #F2E9DE;
    margin-bottom: 0.5rem;
}

.demo-popover-head strong {
    font-size: 0.82rem;
    color: #221510;
    display: block;
}

.demo-popover-head small {
    font-size: 0.73rem;
    color: #796155;
}

.demo-popover-section-tag {
    font-size: 0.68rem;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    font-weight: 800;
    color: #C87A1E;
    padding: 0.35rem 0.4rem 0.2rem;
}

.demo-popover-row {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.55rem 0.65rem;
    border-radius: 10px;
    text-decoration: none;
    color: #221510;
    transition: background 0.2s ease;
    margin-bottom: 0.2rem;
}

.demo-popover-row:hover {
    background: #FFF8EE;
}

.demo-row-avatar {
    font-size: 1.15rem;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: #FAF4EB;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid #E8DCCF;
    flex-shrink: 0;
}

.demo-popover-row strong {
    font-size: 0.84rem;
    display: block;
    line-height: 1.2;
}

.demo-popover-row small {
    font-size: 0.72rem;
    color: #796155;
}

/* Cart Button */
.capsule-cart-btn {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: #FFFFFF;
    border: 1px solid #E8DCCF;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #221510;
    text-decoration: none;
    position: relative;
    transition: all 0.2s ease;
    box-shadow: 0 2px 6px rgba(0,0,0,0.04);
}

.capsule-cart-btn:hover {
    border-color: #C87A1E;
    background: #FFFDF9;
    transform: translateY(-1px);
}

.cart-icon { font-size: 1.05rem; }

.cart-count-badge {
    position: absolute;
    top: -4px;
    right: -4px;
    background: #C2414C;
    color: #FFFFFF;
    font-size: 0.68rem;
    font-weight: 700;
    min-width: 18px;
    height: 18px;
    border-radius: 9999px;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid #FFFFFF;
}

/* User Account Badge */
.capsule-user-badge {
    display: flex;
    align-items: center;
    gap: 0.35rem;
    background: #FFFFFF;
    border: 1px solid #E8DCCF;
    border-radius: 9999px;
    padding: 0.18rem 0.35rem 0.18rem 0.22rem;
    height: 38px;
}

.capsule-user-link {
    display: flex;
    align-items: center;
    gap: 0.45rem;
    text-decoration: none;
    padding: 0.1rem 0.5rem 0.1rem 0.2rem;
    font-size: 0.82rem;
    font-weight: 700;
    color: #221510;
}

.user-avatar-initial {
    width: 26px;
    height: 26px;
    border-radius: 50%;
    background: #C87A1E;
    color: #FFFFFF;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.74rem;
    font-weight: 800;
}

.capsule-user-link.is-vip-gold .user-avatar-initial {
    background: linear-gradient(135deg, #F59E0B 0%, #D97706 100%);
    box-shadow: 0 2px 6px rgba(217, 119, 6, 0.4);
}

.btn-capsule-logout {
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: #F3ECE2;
    color: #796155;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.65rem;
    text-decoration: none;
    transition: background 0.2s ease;
}

.btn-capsule-logout:hover {
    background: #FEE2E2;
    color: #991B1B;
}

/* Auth Buttons */
.capsule-auth-group {
    display: flex;
    align-items: center;
    gap: 0.35rem;
}

.btn-capsule-signin {
    padding: 0 0.85rem;
    border-radius: 9999px;
    font-size: 0.84rem;
    font-weight: 600;
    color: #221510;
    text-decoration: none;
    transition: all 0.2s ease;
    height: 38px;
    display: inline-flex;
    align-items: center;
}

.btn-capsule-signin:hover {
    background: #F3ECE2;
    color: #C87A1E;
}

.btn-capsule-join {
    background: linear-gradient(135deg, #DF831A 0%, #C46E0E 100%);
    color: #FFFFFF;
    padding: 0 1.1rem;
    border-radius: 9999px;
    font-size: 0.84rem;
    font-weight: 700;
    text-decoration: none;
    height: 38px;
    display: inline-flex;
    align-items: center;
    box-shadow: 0 2px 8px rgba(200, 122, 30, 0.28);
    transition: all 0.2s ease;
}

.btn-capsule-join:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(196, 110, 14, 0.35);
}

/* Staff Button */
.btn-capsule-staff {
    font-size: 0.74rem;
    color: #796155;
    text-decoration: none;
    padding: 0 0.8rem;
    height: 36px;
    border-radius: 9999px;
    border: 1px dashed #E8DCCF;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
}

.btn-capsule-staff:hover {
    border-color: #221510;
    color: #221510;
}

.btn-capsule-staff.active {
    background: #221510;
    color: #FFFFFF;
    border: none;
    font-weight: 700;
}

/* Mobile Hamburger Button */
.btn-capsule-hamburger {
    display: none;
    flex-direction: column;
    justify-content: space-between;
    width: 26px;
    height: 18px;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0;
    margin-left: 0.3rem;
}

.btn-capsule-hamburger span {
    width: 100%;
    height: 2.2px;
    background: #221510;
    border-radius: 2px;
    transition: all 0.2s ease;
}

/* Mobile Drawer Overlay */
.mobile-drawer-backdrop {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(34, 21, 16, 0.5);
    backdrop-filter: blur(4px);
    z-index: 1400;
}

.mobile-drawer-backdrop.open {
    display: block;
}

.mobile-nav-drawer {
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    width: 320px;
    max-width: 85vw;
    background: #FFFFFF;
    z-index: 1500;
    box-shadow: -10px 0 40px rgba(0,0,0,0.2);
    transform: translateX(100%);
    transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1);
    display: flex;
    flex-direction: column;
    overflow-y: auto;
}

.mobile-nav-drawer.open {
    transform: translateX(0);
}

.mobile-drawer-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 1.2rem 1.4rem;
    border-bottom: 1px solid #E8DCCF;
}

.btn-drawer-close {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid #E8DCCF;
    background: #F3ECE2;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 1rem;
    color: #221510;
}

.mobile-drawer-content {
    padding: 1.4rem;
    flex: 1;
}

.mobile-menu-links {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
}

.mobile-nav-link {
    display: block;
    padding: 0.75rem 0.9rem;
    border-radius: 10px;
    color: #221510;
    font-weight: 600;
    font-size: 0.95rem;
    text-decoration: none;
    transition: background 0.2s ease;
}

.mobile-nav-link:hover {
    background: #F3ECE2;
    color: #C87A1E;
}

.mobile-nav-sublink {
    display: block;
    padding: 0.4rem 0.9rem 0.4rem 2rem;
    font-size: 0.85rem;
    color: #796155;
    text-decoration: none;
}

.mobile-nav-sublink:hover {
    color: #C87A1E;
}

/* Breakpoint for Mobile Nav */
@media (max-width: 1180px) {
    .capsule-menu-center {
        display: none;
    }
    .btn-capsule-hamburger {
        display: flex;
    }
}
</style>

<!-- Top Boutique Announcement Banner -->
<div class="top-announcement">
    <div class="top-announcement-inner">
        <div class="announcement-left">
            <span>🥖 Fresh oven batches baked every sunrise</span>
            <span class="announcement-dot">•</span>
            <span>Gold VIP Patrons receive <strong style="color: #FFD188;">12% OFF</strong> everything!</span>
        </div>
        <div class="announcement-right">
            <span>📞 Customer Care & Orders: +94 76 749 4866</span>
            <span class="announcement-sep">|</span>
            <a href="<%= request.getContextPath() %>/booking/form" class="announcement-link">Reserve Custom Cake &rarr;</a>
        </div>
    </div>
</div>

<!-- Floating Haute Pâtisserie Capsule Navigation Island -->
<header class="bakery-floating-nav-wrapper">
    <nav class="bakery-nav-capsule">
        <!-- Zone 1: Brand Emblem & Wordmark -->
        <a href="<%= request.getContextPath() %>/index.jsp" class="capsule-brand">
            <div class="capsule-emblem">
                <img src="<%= request.getContextPath() %>/images/sweetora-logo.png" alt="Sweetora Logo">
            </div>
            <div class="capsule-text-block">
                <span class="capsule-brand-title">Sweetora</span>
                <span class="capsule-brand-subtitle">CAKES &bull; DESSERTS &bull; SWEETER MOMENTS</span>
            </div>
        </a>

        <!-- Zone 2: Primary Center Navigation Links -->
        <div class="capsule-menu-center">
            <ul class="capsule-nav-list">
                <li>
                    <a href="<%= request.getContextPath() %>/index.jsp" class="capsule-nav-link">Home</a>
                </li>

                <!-- Artisan Menu Mega-Dropdown -->
                <li class="capsule-dropdown-parent">
                    <a href="<%= request.getContextPath() %>/product/list" class="capsule-nav-link">
                        <span>Artisan Menu</span>
                        <span class="capsule-chevron">▾</span>
                    </a>
                    <div class="capsule-dropdown-popover">
                        <a href="<%= request.getContextPath() %>/product/list?category=ALL" class="capsule-dropdown-item">
                            <span class="dropdown-item-icon">🌟</span>
                            <div class="dropdown-item-info">
                                <strong>All Collections</strong>
                                <small>Explore all handcrafted treats</small>
                            </div>
                        </a>
                        <a href="<%= request.getContextPath() %>/product/list?category=CAKE" class="capsule-dropdown-item">
                            <span class="dropdown-item-icon">🍰</span>
                            <div class="dropdown-item-info">
                                <strong>Celebration Cakes</strong>
                                <small>Belgian ganache, vanilla & red velvet</small>
                            </div>
                        </a>
                        <a href="<%= request.getContextPath() %>/product/list?category=PASTRY" class="capsule-dropdown-item">
                            <span class="dropdown-item-icon">🥐</span>
                            <div class="dropdown-item-info">
                                <strong>French Pastries</strong>
                                <small>All-butter croissants, danish & tarts</small>
                            </div>
                        </a>
                        <a href="<%= request.getContextPath() %>/product/list?category=BREAD" class="capsule-dropdown-item">
                            <span class="dropdown-item-icon">🥖</span>
                            <div class="dropdown-item-info">
                                <strong>Hearth Sourdough</strong>
                                <small>Slow-fermented artisan loaves</small>
                            </div>
                        </a>
                    </div>
                </li>

                <li>
                    <a href="<%= request.getContextPath() %>/booking/form" class="capsule-nav-link capsule-link-featured">
                        <span>✨ Custom Cake Studio</span>
                    </a>
                </li>

                <li>
                    <a href="<%= request.getContextPath() %>/order/track" class="capsule-nav-link">
                        <span class="capsule-radar-dot"></span>
                        <span>Live Tracker</span>
                    </a>
                </li>

                <li>
                    <a href="<%= request.getContextPath() %>/review/list" class="capsule-nav-link">
                        <span>Patron Reviews</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Zone 3: Interactive Right-Side Tools & Personas -->
        <div class="capsule-actions-right">
            <!-- ⚡ Quick 1-Click Demo Accounts Switcher -->
            <div class="capsule-demo-wrapper">
                <button type="button" class="btn-capsule-demo" onclick="toggleDemoDropdown(event)" title="1-Click Demo Logins">
                    <span>⚡ Demo Login</span>
                    <span style="font-size: 0.65rem;">▾</span>
                </button>

                <div id="demoDropdownMenu" class="capsule-demo-popover">
                    <div class="demo-popover-head">
                        <strong>⚡ 1-Click Instant Demo Access</strong>
                        <small>Switch personas instantly without typing credentials</small>
                    </div>

                    <div class="demo-popover-section-tag">Patron Personas</div>
                    <a href="javascript:void(0)" onclick="demoFastLoginCustomer('eleanor@bakery.com', 'pass123')" class="demo-popover-row">
                        <span class="demo-row-avatar">👑</span>
                        <div>
                            <strong>Kavindu Perera (Gold VIP)</strong>
                            <small>Automatic 12% OFF • kavindu@sweetora.com</small>
                        </div>
                    </a>
                    <a href="javascript:void(0)" onclick="demoFastLoginCustomer('marcus@example.com', 'pass123')" class="demo-popover-row">
                        <span class="demo-row-avatar">👤</span>
                        <div>
                            <strong>Kasun Silva (Regular)</strong>
                            <small>Standard Patron • kasun@sweetora.com</small>
                        </div>
                    </a>

                    <div class="demo-popover-section-tag" style="margin-top: 0.5rem;">Bakery Brigade Personas</div>
                    <a href="javascript:void(0)" onclick="demoFastLoginStaff('STF-001', 'admin123')" class="demo-popover-row">
                        <span class="demo-row-avatar">⚙️</span>
                        <div>
                            <strong>Chef Jacques Pierre (Manager)</strong>
                            <small>Executive Admin Console • STF-001</small>
                        </div>
                    </a>
                    <a href="javascript:void(0)" onclick="demoFastLoginStaff('STF-002', 'staff123')" class="demo-popover-row">
                        <span class="demo-row-avatar">🎨</span>
                        <div>
                            <strong>Giselle Dupont (Decorator)</strong>
                            <small>Cake Decorating Queue • STF-002</small>
                        </div>
                    </a>
                    <a href="javascript:void(0)" onclick="demoFastLoginStaff('STF-003', 'staff123')" class="demo-popover-row">
                        <span class="demo-row-avatar">🥣</span>
                        <div>
                            <strong>Mateo Rossi (Master Baker)</strong>
                            <small>Ovens & Breads Board • STF-003</small>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Shopping Basket Cart Button -->
            <a href="<%= request.getContextPath() %>/order/cart" class="capsule-cart-btn" title="View Shopping Basket">
                <span class="cart-icon">🛒</span>
                <span class="cart-count-badge"><%= cartCount %></span>
            </a>

            <!-- Authentication Controls -->
            <% if (currentUser != null) { %>
                <div class="capsule-user-badge">
                    <a href="<%= request.getContextPath() %>/customer/profile" class="capsule-user-link <%= "PREMIUM".equalsIgnoreCase(currentUser.getType()) ? "is-vip-gold" : "" %>" title="Manage Patron Profile">
                        <span class="user-avatar-initial"><%= currentUser.getName().substring(0, 1) %></span>
                        <span class="user-name-label"><%= currentUser.getName() %></span>
                    </a>
                    <a href="<%= request.getContextPath() %>/customer/logout" class="btn-capsule-logout" title="Sign Out">✕</a>
                </div>
            <% } else { %>
                <div class="capsule-auth-group">
                    <a href="<%= request.getContextPath() %>/customer/login" class="btn-capsule-signin">Sign In</a>
                    <a href="<%= request.getContextPath() %>/customer/register" class="btn-capsule-join">Join VIP</a>
                </div>
            <% } %>

            <!-- Staff Portal -->
            <% if (staffUser != null) { %>
                <a href="<%= request.getContextPath() %>/staff/dashboard" class="btn-capsule-staff active" title="Management Console">
                    ⚙️ <%= staffUser.getRole() %>
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/staff/login" class="btn-capsule-staff" title="Kitchen Brigade & Staff Login">
                    Staff
                </a>
            <% } %>

            <!-- Mobile Hamburger Button (screens <= 1180px) -->
            <button type="button" class="btn-capsule-hamburger" onclick="toggleMobileDrawer()" aria-label="Toggle Navigation Menu">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </nav>
</header>

<!-- Mobile Navigation Drawer & Backdrop -->
<div id="mobileDrawerBackdrop" class="mobile-drawer-backdrop" onclick="closeMobileDrawer()"></div>
<aside id="mobileNavDrawer" class="mobile-nav-drawer" aria-label="Mobile Navigation">
    <div class="mobile-drawer-header">
        <div class="capsule-brand">
            <div class="capsule-emblem">
                <img src="<%= request.getContextPath() %>/images/sweetora-logo.png" alt="Sweetora Logo">
            </div>
            <div class="capsule-text-block">
                <span class="capsule-brand-title">Sweetora</span>
                <span class="capsule-brand-subtitle">CAKES &bull; DESSERTS &bull; SWEETER MOMENTS</span>
            </div>
        </div>
        <button type="button" class="btn-drawer-close" onclick="closeMobileDrawer()">✕</button>
    </div>

    <div class="mobile-drawer-content">
        <% if (currentUser != null) { %>
            <div style="background: #F3ECE2; padding: 1rem; border-radius: 10px; margin-bottom: 1.2rem; display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <strong style="font-size: 0.95rem; color: #221510;"><%= currentUser.getName() %></strong>
                    <div style="font-size: 0.78rem; color: #C87A1E; font-weight: 700;">
                        <%= "PREMIUM".equalsIgnoreCase(currentUser.getType()) ? "👑 Gold VIP (12% Off)" : "Artisan Patron" %>
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/customer/logout" style="padding: 0.3rem 0.8rem; border-radius: 9999px; font-size: 0.78rem; border: 1px solid #E8DCCF; text-decoration: none; color: #221510;">Sign Out</a>
            </div>
        <% } else { %>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.6rem; margin-bottom: 1.2rem;">
                <a href="<%= request.getContextPath() %>/customer/login" style="text-align: center; padding: 0.6rem; border-radius: 9999px; background: #F3ECE2; color: #221510; text-decoration: none; font-weight: 600; font-size: 0.85rem;">Sign In</a>
                <a href="<%= request.getContextPath() %>/customer/register" style="text-align: center; padding: 0.6rem; border-radius: 9999px; background: #C87A1E; color: #FFFFFF; text-decoration: none; font-weight: 700; font-size: 0.85rem;">Join VIP</a>
            </div>
        <% } %>

        <nav class="mobile-menu-links">
            <a href="<%= request.getContextPath() %>/index.jsp" class="mobile-nav-link">🏠 Home</a>
            <a href="<%= request.getContextPath() %>/product/list" class="mobile-nav-link">🥐 Artisan Menu (All Bakes)</a>
            <a href="<%= request.getContextPath() %>/product/list?category=CAKE" class="mobile-nav-sublink">&bull; Celebration Cakes</a>
            <a href="<%= request.getContextPath() %>/product/list?category=PASTRY" class="mobile-nav-sublink">&bull; French Pastries</a>
            <a href="<%= request.getContextPath() %>/product/list?category=BREAD" class="mobile-nav-sublink">&bull; Hearth Sourdough</a>
            <a href="<%= request.getContextPath() %>/booking/form" class="mobile-nav-link" style="color: #C87A1E; font-weight: 700;">✨ Custom Cake Studio</a>
            <a href="<%= request.getContextPath() %>/order/track" class="mobile-nav-link">📦 Live Order Tracker</a>
            <a href="<%= request.getContextPath() %>/review/list" class="mobile-nav-link">⭐ Patron Reviews</a>
            <a href="<%= request.getContextPath() %>/staff/dashboard" class="mobile-nav-link">⚙️ Staff & Kitchen Console</a>
        </nav>
    </div>
</aside>

<!-- Hidden Fast Login Forms for Instant Demo Switcher -->
<form id="fastCustomerLoginForm" action="<%= request.getContextPath() %>/customer/login" method="POST" style="display: none;">
    <input type="hidden" name="email" id="fastCustomerEmail">
    <input type="hidden" name="password" id="fastCustomerPassword">
</form>

<form id="fastStaffLoginForm" action="<%= request.getContextPath() %>/staff/login" method="POST" style="display: none;">
    <input type="hidden" name="username" id="fastStaffUsername">
    <input type="hidden" name="password" id="fastStaffPassword">
</form>

<script>
    function toggleDemoDropdown(event) {
        event.stopPropagation();
        const menu = document.getElementById('demoDropdownMenu');
        if (menu.style.display === 'block') {
            menu.style.display = 'none';
        } else {
            menu.style.display = 'block';
        }
    }

    document.addEventListener('click', (e) => {
        const menu = document.getElementById('demoDropdownMenu');
        if (menu && !menu.contains(e.target)) {
            menu.style.display = 'none';
        }
    });

    function toggleMobileDrawer() {
        document.getElementById('mobileNavDrawer').classList.toggle('open');
        document.getElementById('mobileDrawerBackdrop').classList.toggle('open');
    }

    function closeMobileDrawer() {
        document.getElementById('mobileNavDrawer').classList.remove('open');
        document.getElementById('mobileDrawerBackdrop').classList.remove('open');
    }

    function demoFastLoginCustomer(email, pass) {
        document.getElementById('fastCustomerEmail').value = email;
        document.getElementById('fastCustomerPassword').value = pass;
        document.getElementById('fastCustomerLoginForm').submit();
    }

    function demoFastLoginStaff(username, pass) {
        document.getElementById('fastStaffUsername').value = username;
        document.getElementById('fastStaffPassword').value = pass;
        document.getElementById('fastStaffLoginForm').submit();
    }
</script>

<%-- Flash alert notification --%>
<%
    String msg = request.getParameter("msg");
    if (msg != null && !msg.trim().isEmpty()) {
%>
    <div style="max-width: 1280px; margin: 1rem auto 0; padding: 0 1.5rem;">
        <div style="background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; padding: 0.85rem 1.2rem; border-radius: 10px; font-size: 0.9rem;">
            ✨ Action completed successfully: <strong><%= msg.replace("_", " ") %></strong>
        </div>
    </div>
<% } %>
