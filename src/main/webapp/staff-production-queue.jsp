<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.CakeBooking" %>
<%@ page import="com.bakery.model.Order" %>
<%@ page import="com.bakery.model.Staff" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    @SuppressWarnings("unchecked")
    List<CakeBooking> bookings = (List<CakeBooking>) request.getAttribute("bookings");
    if (bookings == null) bookings = new ArrayList<>();
    @SuppressWarnings("unchecked")
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) orders = new ArrayList<>();
    @SuppressWarnings("unchecked")
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    if (staffList == null) staffList = new ArrayList<>();

    // Group bookings by status for Kanban Board
    List<CakeBooking> confirmedList = new ArrayList<>();
    List<CakeBooking> bakingList = new ArrayList<>();
    List<CakeBooking> decoratingList = new ArrayList<>();
    List<CakeBooking> readyList = new ArrayList<>();
    List<CakeBooking> deliveredList = new ArrayList<>();

    for (CakeBooking b : bookings) {
        String st = b.getStatus() != null ? b.getStatus().toUpperCase() : "CONFIRMED";
        if ("CONFIRMED".equals(st)) confirmedList.add(b);
        else if ("BAKING".equals(st)) bakingList.add(b);
        else if ("DECORATING".equals(st)) decoratingList.add(b);
        else if ("READY".equals(st)) readyList.add(b);
        else if ("DELIVERED".equals(st)) deliveredList.add(b);
        else confirmedList.add(b);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kitchen Live Production Queue | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
    <style>
        .kanban-board {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-bottom: 3.5rem;
            overflow-x: auto;
            padding-bottom: 0.5rem;
        }
        @media (max-width: 1100px) {
            .kanban-board { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 650px) {
            .kanban-board { grid-template-columns: 1fr; }
        }
        .kanban-col {
            background: #FDFBF8;
            border: 1.5px solid var(--c-border);
            border-radius: var(--r-md);
            padding: 1.2rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            min-height: 480px;
        }
        .kanban-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 0.8rem;
            border-bottom: 2px solid var(--c-border);
        }
        .col-badge {
            font-size: 0.76rem;
            font-weight: 800;
            padding: 0.2rem 0.6rem;
            border-radius: var(--r-full);
            background: var(--c-bg-subtle);
            color: var(--c-cacao);
        }
        .k-item-card {
            background: #FFFFFF;
            border: 1px solid var(--c-border);
            border-radius: var(--r-sm);
            padding: 1.1rem;
            box-shadow: var(--shadow-subtle);
            transition: var(--ease-smooth);
            display: flex;
            flex-direction: column;
            gap: 0.6rem;
        }
        .k-item-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-card);
            border-color: var(--c-caramel);
        }
        .k-action-btn {
            padding: 0.35rem 0.65rem;
            font-size: 0.78rem;
            font-weight: 700;
            border-radius: var(--r-sm);
            border: none;
            cursor: pointer;
            transition: var(--ease-smooth);
            width: 100%;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Top Title Bar -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.5rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <span class="hero-badge">🧑‍🍳 Kitchen Workload & Flow</span>
                <h1 style="font-size: 2.3rem; margin-top: 0.4rem;">Kitchen Production Queue</h1>
                <p style="color: var(--c-cacao-muted);">
                    Real-time status progression for master bakers and artisan decorators.
                </p>
            </div>

            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= request.getContextPath() %>/staff/dashboard" class="btn btn-secondary btn-sm">
                    &larr; Management Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/staff/workload" class="btn btn-outline btn-sm">
                    Staff Shift Roster
                </a>
            </div>
        </div>

        <!-- Section 1: Live Interactive Kanban Board for Custom Cakes -->
        <div style="margin-bottom: 1rem; display: flex; justify-content: space-between; align-items: baseline;">
            <h2 style="font-size: 1.6rem;">🎂 Custom Cake Kanban Pipeline</h2>
            <span style="font-size: 0.85rem; color: var(--c-cacao-muted);"><%= bookings.size() %> Total Registered Cake Work Orders</span>
        </div>

        <div class="kanban-board">
            <!-- Col 1: Confirmed -->
            <div class="kanban-col">
                <div class="kanban-header">
                    <span style="font-weight: 700; font-size: 0.95rem; color: #3730A3;">📋 1. Confirmed</span>
                    <span class="col-badge"><%= confirmedList.size() %></span>
                </div>
                <% if (confirmedList.isEmpty()) { %>
                    <div style="font-size: 0.82rem; color: var(--c-cacao-muted); text-align: center; margin-top: 2rem;">No orders awaiting prep</div>
                <% } else { %>
                    <% for (CakeBooking b : confirmedList) { %>
                        <div class="k-item-card">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.75rem; font-weight: 800; font-family: monospace; color: var(--c-caramel);"><%= b.getBookingId() %></span>
                                <span style="font-size: 0.75rem; color: var(--c-cacao-muted);"><%= b.getRequiredDate() %></span>
                            </div>
                            <strong style="font-size: 0.95rem; color: var(--c-cacao);"><%= b.getCustomerName() %></strong>
                            <div style="font-size: 0.82rem; color: var(--c-cacao-muted);">
                                <%= b.getFlavour() %> &bull; <%= b.getTiers() %> Tier (<%= b.getSize() %>)
                            </div>
                            <div style="font-size: 0.8rem; background: var(--c-bg-subtle); padding: 0.35rem 0.6rem; border-radius: 4px;">
                                <strong>Theme:</strong> <%= b.getDesign() %>
                            </div>
                            <% if (b.getCustomMessage() != null && !b.getCustomMessage().trim().isEmpty()) { %>
                                <div style="font-size: 0.78rem; font-style: italic; color: var(--c-caramel);">
                                    "<%= b.getCustomMessage() %>"
                                </div>
                            <% } %>
                            
                            <!-- Advance to BAKING -->
                            <form action="<%= request.getContextPath() %>/booking/update-status" method="POST" style="margin-top: 0.4rem;">
                                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                <input type="hidden" name="status" value="BAKING">
                                <button type="submit" class="k-action-btn" style="background: #FEF3C7; color: #92400E; border: 1px solid #FDE68A;">
                                    Start Baking Sponges &rarr;
                                </button>
                            </form>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <!-- Col 2: Baking -->
            <div class="kanban-col">
                <div class="kanban-header">
                    <span style="font-weight: 700; font-size: 0.95rem; color: #92400E;">🥣 2. In Oven / Baking</span>
                    <span class="col-badge"><%= bakingList.size() %></span>
                </div>
                <% if (bakingList.isEmpty()) { %>
                    <div style="font-size: 0.82rem; color: var(--c-cacao-muted); text-align: center; margin-top: 2rem;">No sponges in ovens</div>
                <% } else { %>
                    <% for (CakeBooking b : bakingList) { %>
                        <div class="k-item-card" style="border-left: 3px solid #E59837;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.75rem; font-weight: 800; font-family: monospace; color: var(--c-caramel);"><%= b.getBookingId() %></span>
                                <span style="font-size: 0.75rem; color: var(--c-cacao-muted);"><%= b.getRequiredDate() %></span>
                            </div>
                            <strong style="font-size: 0.95rem; color: var(--c-cacao);"><%= b.getCustomerName() %></strong>
                            <div style="font-size: 0.82rem; color: var(--c-cacao-muted);">
                                <%= b.getFlavour() %> &bull; <%= b.getTiers() %> Tier (<%= b.getSize() %>)
                            </div>
                            <div style="font-size: 0.8rem; background: var(--c-bg-subtle); padding: 0.35rem 0.6rem; border-radius: 4px;">
                                <strong>Occasion:</strong> <%= b.getOccasion() %>
                            </div>
                            <!-- Advance to DECORATING -->
                            <form action="<%= request.getContextPath() %>/booking/update-status" method="POST" style="margin-top: 0.4rem;">
                                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                <input type="hidden" name="status" value="DECORATING">
                                <button type="submit" class="k-action-btn" style="background: #F5E8FF; color: #6B21A8; border: 1px solid #E9D5FF;">
                                    Move to Decorating Art &rarr;
                                </button>
                            </form>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <!-- Col 3: Decorating -->
            <div class="kanban-col">
                <div class="kanban-header">
                    <span style="font-weight: 700; font-size: 0.95rem; color: #6B21A8;">🎨 3. Decorating & Icing</span>
                    <span class="col-badge"><%= decoratingList.size() %></span>
                </div>
                <% if (decoratingList.isEmpty()) { %>
                    <div style="font-size: 0.82rem; color: var(--c-cacao-muted); text-align: center; margin-top: 2rem;">No cakes in icing station</div>
                <% } else { %>
                    <% for (CakeBooking b : decoratingList) { %>
                        <div class="k-item-card" style="border-left: 3px solid #A855F7;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.75rem; font-weight: 800; font-family: monospace; color: var(--c-caramel);"><%= b.getBookingId() %></span>
                                <span style="font-size: 0.75rem; color: var(--c-cacao-muted);"><%= b.getRequiredDate() %></span>
                            </div>
                            <strong style="font-size: 0.95rem; color: var(--c-cacao);"><%= b.getCustomerName() %></strong>
                            <div style="font-size: 0.82rem; color: var(--c-cacao-muted);">
                                <%= b.getFlavour() %> &bull; <%= b.getDesign() %>
                            </div>
                            <% if (b.getCustomMessage() != null && !b.getCustomMessage().trim().isEmpty()) { %>
                                <div style="font-size: 0.8rem; background: #FAF5EE; padding: 0.4rem; border-radius: 4px; color: var(--c-cacao);">
                                    🖊️ Inscription: <em>"<%= b.getCustomMessage() %>"</em>
                                </div>
                            <% } %>
                            <!-- Advance to READY -->
                            <form action="<%= request.getContextPath() %>/booking/update-status" method="POST" style="margin-top: 0.4rem;">
                                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                <input type="hidden" name="status" value="READY">
                                <button type="submit" class="k-action-btn" style="background: #DCFCE7; color: #166534; border: 1px solid #BBF7D0;">
                                    Mark Ready for Patron &rarr;
                                </button>
                            </form>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <!-- Col 4: Ready for Pickup -->
            <div class="kanban-col">
                <div class="kanban-header">
                    <span style="font-weight: 700; font-size: 0.95rem; color: #166534;">✅ 4. Ready for Collection</span>
                    <span class="col-badge"><%= readyList.size() %></span>
                </div>
                <% if (readyList.isEmpty()) { %>
                    <div style="font-size: 0.82rem; color: var(--c-cacao-muted); text-align: center; margin-top: 2rem;">No cakes in pickup chillers</div>
                <% } else { %>
                    <% for (CakeBooking b : readyList) { %>
                        <div class="k-item-card" style="border-left: 3px solid #10B981;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.75rem; font-weight: 800; font-family: monospace; color: var(--c-caramel);"><%= b.getBookingId() %></span>
                                <span class="badge badge-verified" style="font-size: 0.7rem;">READY</span>
                            </div>
                            <strong style="font-size: 0.95rem; color: var(--c-cacao);"><%= b.getCustomerName() %></strong>
                            <div style="font-size: 0.82rem; color: var(--c-cacao-muted);">
                                <%= b.getFlavour() %> &bull; <%= b.getTiers() %> Tier
                            </div>
                            <div style="font-size: 0.82rem; color: #166534; font-weight: 600;">
                                Chiller Ready &bull; Date: <%= b.getRequiredDate() %>
                            </div>
                            <!-- Advance to DELIVERED -->
                            <form action="<%= request.getContextPath() %>/booking/update-status" method="POST" style="margin-top: 0.4rem;">
                                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                <input type="hidden" name="status" value="DELIVERED">
                                <button type="submit" class="k-action-btn" style="background: #E0E7FF; color: #312E81; border: 1px solid #C7D2FE;">
                                    Complete Pickup Handover
                                </button>
                            </form>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>

        <!-- Section 2: Detailed Management Table (Assignment + Status Overrides) -->
        <div style="margin-bottom: 3.5rem;">
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.2rem;">
                <h2 style="font-size: 1.6rem;">📋 Master Cake Work Orders Registry</h2>
                <span class="badge badge-gold"><%= bookings.size() %> Total Records</span>
            </div>

            <div class="bakery-table-wrap">
                <table class="bakery-table">
                    <thead>
                        <tr>
                            <th>Booking Ref</th>
                            <th>Customer & Occasion</th>
                            <th>Flavour & Size</th>
                            <th>Design Theme & Inscription</th>
                            <th>Target Date</th>
                            <th>Stage</th>
                            <th>Baker / Decorator</th>
                            <th>Manual Override</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (bookings.isEmpty()) { %>
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 2.5rem; color: var(--c-cacao-muted);">
                                    🎉 Kitchen queue is clear! No registered custom cakes.
                                </td>
                            </tr>
                        <% } else { %>
                            <% for (CakeBooking b : bookings) { %>
                                <tr>
                                    <td>
                                        <strong style="font-family: monospace; color: var(--c-caramel); font-size: 0.92rem;">
                                            <%= b.getBookingId() %>
                                        </strong>
                                    </td>
                                    <td>
                                        <strong><%= b.getCustomerName() %></strong>
                                        <div style="font-size: 0.78rem; color: var(--c-caramel); font-weight: 600;"><%= b.getOccasion() %></div>
                                    </td>
                                    <td>
                                        <%= b.getFlavour() %>
                                        <div style="font-size: 0.78rem; color: var(--c-cacao-muted);"><%= b.getSize() %>, <%= b.getTiers() %> Tier(s)</div>
                                    </td>
                                    <td>
                                        <strong><%= b.getDesign() %></strong>
                                        <% if (b.getCustomMessage() != null && !b.getCustomMessage().trim().isEmpty()) { %>
                                            <div style="font-size: 0.78rem; color: var(--c-cacao-muted); font-style: italic;">
                                                "<%= b.getCustomMessage() %>"
                                            </div>
                                        <% } %>
                                    </td>
                                    <td><strong><%= b.getRequiredDate() %></strong></td>
                                    <td>
                                        <span class="status-pill status-<%= b.getStatus() %>">
                                            <%= b.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <form action="<%= request.getContextPath() %>/booking/assign" method="POST" style="display: flex; gap: 0.3rem;">
                                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                            <select name="staffId" class="form-control" style="padding: 0.3rem 0.5rem; font-size: 0.8rem; min-width: 120px;">
                                                <option value="UNASSIGNED">Unassigned</option>
                                                <% for (Staff s : staffList) { %>
                                                    <option value="<%= s.getStaffId() %>" <%= s.getStaffId().equals(b.getAssignedBakerId()) ? "selected" : "" %>>
                                                        <%= s.getName() %> (<%= s.getRole() %>)
                                                    </option>
                                                <% } %>
                                            </select>
                                            <button type="submit" class="btn btn-secondary btn-sm" style="padding: 0.25rem 0.5rem; font-size: 0.78rem;">Save</button>
                                        </form>
                                    </td>
                                    <td>
                                        <form action="<%= request.getContextPath() %>/booking/update-status" method="POST" style="display: flex; gap: 0.3rem;">
                                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                            <select name="status" class="form-control" style="padding: 0.3rem 0.5rem; font-size: 0.8rem; min-width: 125px;">
                                                <option value="CONFIRMED" <%= "CONFIRMED".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>1. Confirmed</option>
                                                <option value="BAKING" <%= "BAKING".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>2. Baking Sponges</option>
                                                <option value="DECORATING" <%= "DECORATING".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>3. Decorating Art</option>
                                                <option value="READY" <%= "READY".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>4. Ready for Pickup</option>
                                                <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>5. Delivered</option>
                                                <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                            </select>
                                            <button type="submit" class="btn btn-primary btn-sm" style="padding: 0.25rem 0.6rem; font-size: 0.78rem;">Update</button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Section 3: Standard Bread & Pastry Orders Queue -->
        <div>
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.2rem;">
                <h2 style="font-size: 1.6rem;">🥐 Standard Bakery Orders Fulfillment</h2>
                <span class="badge badge-soft"><%= orders.size() %> Total Placed</span>
            </div>

            <div class="bakery-table-wrap">
                <table class="bakery-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer Name</th>
                            <th>Items Serialized</th>
                            <th>Placed At</th>
                            <th>Current Status</th>
                            <th>Update Fulfillment Stage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (orders.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 2.5rem; color: var(--c-cacao-muted);">
                                    No standard bakery orders in queue.
                                </td>
                            </tr>
                        <% } else { %>
                            <% for (Order o : orders) { %>
                                <tr>
                                    <td>
                                        <strong style="font-family: monospace; color: var(--c-caramel);">
                                            <%= o.getOrderId() %>
                                        </strong>
                                    </td>
                                    <td><strong><%= o.getCustomerName() %></strong></td>
                                    <td>
                                        <div style="font-size: 0.85rem; line-height: 1.5;"><%= o.getItemsSerialized().replace(";", " &bull; ") %></div>
                                    </td>
                                    <td style="font-size: 0.85rem;"><%= o.getOrderDate() %></td>
                                    <td>
                                        <span class="status-pill status-<%= o.getStatus() %>">
                                            <%= o.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <form action="<%= request.getContextPath() %>/order/update-status" method="POST" style="display: flex; gap: 0.4rem;">
                                            <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                            <select name="status" class="form-control" style="padding: 0.3rem 0.5rem; font-size: 0.82rem; min-width: 130px;">
                                                <option value="CONFIRMED" <%= "CONFIRMED".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                                <option value="BAKING" <%= "BAKING".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>In Oven Baking</option>
                                                <option value="READY" <%= "READY".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>Packed & Ready</option>
                                                <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>Delivered / Collected</option>
                                                <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                            </select>
                                            <button type="submit" class="btn btn-primary btn-sm" style="padding: 0.25rem 0.6rem; font-size: 0.78rem;">Update</button>
                                        </form>
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
