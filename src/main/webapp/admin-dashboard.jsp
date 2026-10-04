<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Staff" %>
<%@ page import="com.bakery.model.Payment" %>
<%@ page import="java.util.List" %>
<%
    Staff staff = (Staff) session.getAttribute("staffUser");
    Integer activeBookings = (Integer) request.getAttribute("activeBookingsCount");
    if (activeBookings == null) activeBookings = 0;
    Integer allOrders = (Integer) request.getAttribute("allOrdersCount");
    if (allOrders == null) allOrders = 0;
    Integer allProducts = (Integer) request.getAttribute("allProductsCount");
    if (allProducts == null) allProducts = 0;
    @SuppressWarnings("unchecked")
    List<Staff> staffMembers = (List<Staff>) request.getAttribute("staffMembers");
    @SuppressWarnings("unchecked")
    List<Payment> recentPayments = (List<Payment>) request.getAttribute("recentPayments");

    double totalRevenue = 0.0;
    int paidCount = 0;
    if (recentPayments != null) {
        for (Payment p : recentPayments) {
            if (!"VOIDED".equalsIgnoreCase(p.getStatus())) {
                totalRevenue += p.getAmount();
                paidCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Executive Operations Dashboard | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
    <style>
        .metric-card-lux {
            background: #FFFFFF;
            border-radius: var(--r-md);
            padding: 1.8rem;
            border: 1px solid var(--c-border);
            box-shadow: var(--shadow-subtle);
            position: relative;
            overflow: hidden;
            transition: var(--ease-smooth);
        }
        .metric-card-lux:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-card);
            border-color: var(--c-honey);
        }
        .metric-card-lux::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
        }
        .m-amber::after { background: linear-gradient(90deg, #E59837, #DF831A); }
        .m-choco::after { background: linear-gradient(90deg, #4A2B20, #221510); }
        .m-green::after { background: linear-gradient(90deg, #10B981, #059669); }
        .m-rose::after  { background: linear-gradient(90deg, #F43F5E, #C2414C); }

        .module-tile {
            background: #FFFFFF;
            border-radius: var(--r-md);
            padding: 1.8rem;
            border: 1px solid var(--c-border);
            box-shadow: var(--shadow-subtle);
            display: flex;
            flex-direction: column;
            text-decoration: none;
            color: inherit;
            transition: var(--ease-smooth);
        }
        .module-tile:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
            border-color: var(--c-caramel);
        }
        .module-tile:hover .module-icon {
            transform: scale(1.1);
        }
        .module-icon {
            width: 52px;
            height: 52px;
            border-radius: var(--r-sm);
            background: var(--c-bg-subtle);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.7rem;
            margin-bottom: 1.2rem;
            transition: var(--ease-smooth);
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Dashboard Top Banner -->
        <div style="background: linear-gradient(135deg, #2D1810 0%, #432418 50%, #20100A 100%); border-radius: var(--r-lg); padding: 2.5rem 3rem; color: #FFFFFF; margin-bottom: 2.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1.5rem; box-shadow: var(--shadow-card); border: 1px solid rgba(255,255,255,0.1);">
            <div>
                <div style="display: inline-flex; align-items: center; gap: 0.5rem; background: rgba(255,255,255,0.12); padding: 0.35rem 0.9rem; border-radius: var(--r-full); font-size: 0.8rem; font-weight: 700; color: #FFD188; margin-bottom: 0.8rem;">
                    ⚙️ Central Management Console
                </div>
                <h1 style="font-size: 2.4rem; color: #FFFFFF; line-height: 1.15; margin-bottom: 0.4rem;">
                    Artisan Kitchen & Store Operations
                </h1>
                <p style="color: #D9C5B8; font-size: 0.95rem;">
                    Active Staff Session: <strong><%= staff != null ? staff.getName() : "Administrator" %></strong> 
                    &bull; <span style="color: #FFD188; font-weight: 600;"><%= staff != null ? staff.getRoleTitle() : "General Manager" %></span>
                </p>
            </div>

            <div style="display: flex; gap: 0.85rem; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/staff/queue" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.8rem 1.4rem;">
                    🧑‍🍳 Kitchen Production Board
                </a>
                <a href="<%= request.getContextPath() %>/staff/logout" class="btn btn-outline" style="color: #FFF; border-color: rgba(255,255,255,0.3); padding: 0.8rem 1.4rem;">
                    Sign Out
                </a>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(230px, 1fr)); gap: 1.5rem; margin-bottom: 3.5rem;">
            <!-- Custom Cake Bookings -->
            <div class="metric-card-lux m-amber">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <span style="font-size: 0.78rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.6px; color: var(--c-caramel);">
                        Custom Cake Bookings
                    </span>
                    <span style="font-size: 1.4rem;">🎂</span>
                </div>
                <div style="font-size: 2.6rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin: 0.4rem 0 0.2rem;">
                    <%= activeBookings %>
                </div>
                <div style="font-size: 0.82rem; color: var(--c-cacao-muted); display: flex; align-items: center; gap: 0.4rem;">
                    <span style="color: #166534; font-weight: 700;">● Active</span> In kitchen decorating pipeline
                </div>
            </div>

            <!-- Standard Menu Orders -->
            <div class="metric-card-lux m-choco">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <span style="font-size: 0.78rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.6px; color: var(--c-cacao-muted);">
                        Menu Orders Processed
                    </span>
                    <span style="font-size: 1.4rem;">🥐</span>
                </div>
                <div style="font-size: 2.6rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin: 0.4rem 0 0.2rem;">
                    <%= allOrders %>
                </div>
                <div style="font-size: 0.82rem; color: var(--c-cacao-muted);">
                    All recorded orders in orders.txt
                </div>
            </div>

            <!-- Active Products -->
            <div class="metric-card-lux m-rose">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <span style="font-size: 0.78rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.6px; color: var(--c-rose);">
                        Catalog Bakes & Pastries
                    </span>
                    <span style="font-size: 1.4rem;">🥖</span>
                </div>
                <div style="font-size: 2.6rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin: 0.4rem 0 0.2rem;">
                    <%= allProducts %>
                </div>
                <div style="font-size: 0.82rem; color: var(--c-cacao-muted);">
                    Cakes, pastries, fresh sourdough
                </div>
            </div>

            <!-- Total Revenue -->
            <div class="metric-card-lux m-green">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <span style="font-size: 0.78rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.6px; color: #059669;">
                        Settled Bakery Revenue
                    </span>
                    <span style="font-size: 1.4rem;">💳</span>
                </div>
                <div style="font-size: 2.6rem; font-family: var(--font-heading); font-weight: 800; color: #065F46; margin: 0.4rem 0 0.2rem;">
                    $<%= String.format("%.2f", totalRevenue) %>
                </div>
                <div style="font-size: 0.82rem; color: var(--c-cacao-muted);">
                    <%= paidCount %> paid settlements in payments.txt
                </div>
            </div>
        </div>

        <!-- System Management Modules Hub -->
        <div style="margin-bottom: 3.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 1.6rem;">
                <h2 style="font-size: 1.8rem;">Architecture & Management Modules</h2>
                <span style="font-size: 0.88rem; color: var(--c-cacao-muted);">Complete SE1020 6-Component Architecture</span>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); gap: 1.6rem;">
                <!-- Product & Menu -->
                <a href="<%= request.getContextPath() %>/product/admin-list" class="module-tile">
                    <div class="module-icon">🥐</div>
                    <h3 style="font-size: 1.25rem; margin-bottom: 0.4rem;">Product & Menu Management</h3>
                    <p style="font-size: 0.86rem; color: var(--c-cacao-muted); line-height: 1.6; margin-bottom: 1rem; flex: 1;">
                        Create artisan catalog entries, update pricing, toggle dietary tags, and control inventory.
                    </p>
                    <span style="color: var(--c-caramel); font-size: 0.85rem; font-weight: 700;">Open Catalog Editor &rarr;</span>
                </a>

                <!-- Customer Management -->
                <a href="<%= request.getContextPath() %>/customer/list" class="module-tile">
                    <div class="module-icon">👥</div>
                    <h3 style="font-size: 1.25rem; margin-bottom: 0.4rem;">Customer Management</h3>
                    <p style="font-size: 0.86rem; color: var(--c-cacao-muted); line-height: 1.6; margin-bottom: 1rem; flex: 1;">
                        Manage patron directories, inspect Gold VIP status (12% OFF), and manage member accounts.
                    </p>
                    <span style="color: var(--c-caramel); font-size: 0.85rem; font-weight: 700;">View Customer Directory &rarr;</span>
                </a>

                <!-- Staff & Workload -->
                <a href="<%= request.getContextPath() %>/staff/workload" class="module-tile">
                    <div class="module-icon">🧑‍🍳</div>
                    <h3 style="font-size: 1.25rem; margin-bottom: 0.4rem;">Staff & Workload Panel</h3>
                    <p style="font-size: 0.86rem; color: var(--c-cacao-muted); line-height: 1.6; margin-bottom: 1rem; flex: 1;">
                        Monitor head bakers, decorators, shift assignments (Morning/Evening), and kitchen capacity.
                    </p>
                    <span style="color: var(--c-caramel); font-size: 0.85rem; font-weight: 700;">View Staff Roster &rarr;</span>
                </a>

                <!-- Kitchen Pipeline -->
                <a href="<%= request.getContextPath() %>/staff/queue" class="module-tile">
                    <div class="module-icon">🎂</div>
                    <h3 style="font-size: 1.25rem; margin-bottom: 0.4rem;">Kitchen Production Queue</h3>
                    <p style="font-size: 0.86rem; color: var(--c-cacao-muted); line-height: 1.6; margin-bottom: 1rem; flex: 1;">
                        Advance work stages: Confirmed &rarr; Baking &rarr; Decorating &rarr; Ready for Collection.
                    </p>
                    <span style="color: var(--c-caramel); font-size: 0.85rem; font-weight: 700;">Open Live Production Queue &rarr;</span>
                </a>

                <!-- Billing & Invoices -->
                <a href="<%= request.getContextPath() %>/payment/history" class="module-tile">
                    <div class="module-icon">📜</div>
                    <h3 style="font-size: 1.25rem; margin-bottom: 0.4rem;">Payment & Billing Ledger</h3>
                    <p style="font-size: 0.86rem; color: var(--c-cacao-muted); line-height: 1.6; margin-bottom: 1rem; flex: 1;">
                        Audit transaction logs, generate customer invoices, review 30% advance deposits, and void settlements.
                    </p>
                    <span style="color: var(--c-caramel); font-size: 0.85rem; font-weight: 700;">Open Financial Ledger &rarr;</span>
                </a>

                <!-- Feedback & Reviews -->
                <a href="<%= request.getContextPath() %>/review/moderate" class="module-tile">
                    <div class="module-icon">⭐</div>
                    <h3 style="font-size: 1.25rem; margin-bottom: 0.4rem;">Feedback & Reviews Moderation</h3>
                    <p style="font-size: 0.86rem; color: var(--c-cacao-muted); line-height: 1.6; margin-bottom: 1rem; flex: 1;">
                        Curate public testimonials, verify rating scores, and moderate community reviews.
                    </p>
                    <span style="color: var(--c-caramel); font-size: 0.85rem; font-weight: 700;">Moderate Reviews &rarr;</span>
                </a>
            </div>
        </div>

        <!-- Recent Financial Transactions Snapshot -->
        <div style="margin-bottom: 3rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.2rem;">
                <h2 style="font-size: 1.6rem;">Recent Financial Settlements</h2>
                <a href="<%= request.getContextPath() %>/payment/history" class="btn btn-secondary btn-sm">
                    View Full Payment Ledger &rarr;
                </a>
            </div>

            <div class="bakery-table-wrap">
                <table class="bakery-table">
                    <thead>
                        <tr>
                            <th>Payment ID</th>
                            <th>Order / Booking Ref</th>
                            <th>Date</th>
                            <th>Method</th>
                            <th>Details</th>
                            <th style="text-align: right;">Amount</th>
                            <th>Status</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentPayments == null || recentPayments.isEmpty()) { %>
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 2.5rem; color: var(--c-cacao-muted);">
                                    No financial transactions recorded yet.
                                </td>
                            </tr>
                        <% } else { %>
                            <% 
                                int displayLimit = Math.min(recentPayments.size(), 6);
                                for (int i = 0; i < displayLimit; i++) { 
                                    Payment p = recentPayments.get(i);
                            %>
                                <tr>
                                    <td><strong><%= p.getPaymentId() %></strong></td>
                                    <td>
                                        <span class="badge badge-soft" style="font-family: monospace; font-weight: 700;">
                                            <%= p.getOrderOrBookingId() %>
                                        </span>
                                    </td>
                                    <td style="font-size: 0.85rem;"><%= p.getPaymentDate() %></td>
                                    <td>
                                        <span class="badge badge-gold"><%= p.getMethod() %></span>
                                    </td>
                                    <td style="font-size: 0.85rem; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        <%= p.getDetails() != null ? p.getDetails() : "Settlement" %>
                                    </td>
                                    <td style="text-align: right; font-weight: 700; font-size: 1.05rem; color: var(--c-cacao);">
                                        $<%= String.format("%.2f", p.getAmount()) %>
                                    </td>
                                    <td>
                                        <span class="status-pill status-<%= p.getStatus() %>">
                                            <%= p.getStatus() %>
                                        </span>
                                    </td>
                                    <td style="text-align: right;">
                                        <a href="<%= request.getContextPath() %>/payment/invoice?refId=<%= p.getOrderOrBookingId() %>&amt=<%= p.getAmount() %>" class="btn btn-outline btn-sm" style="padding: 0.25rem 0.65rem; font-size: 0.78rem;">
                                            Receipt
                                        </a>
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
