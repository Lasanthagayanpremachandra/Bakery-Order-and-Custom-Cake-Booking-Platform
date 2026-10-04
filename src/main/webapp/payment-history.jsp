<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Payment" %>
<%@ page import="java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    double totalRevenue = 0.0;
    int activeCount = 0;
    int voidCount = 0;

    if (payments != null) {
        for (Payment p : payments) {
            if (!"VOIDED".equalsIgnoreCase(p.getStatus())) {
                totalRevenue += p.getAmount();
                activeCount++;
            } else {
                voidCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment & Billing History | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <span class="hero-badge">📜 Financial Ledger & Auditing</span>
                <h1 style="font-size: 2.3rem; margin-top: 0.4rem;">Billing & Invoices History</h1>
                <p style="color: var(--c-cacao-muted);">
                    All recorded invoices, advance deposits, and settlement transactions in <code>data/payments.txt</code>.
                </p>
            </div>

            <div style="display: flex; gap: 0.8rem; align-items: center; flex-wrap: wrap;">
                <form action="<%= request.getContextPath() %>/payment/history" method="GET" style="display: flex; gap: 0.5rem;">
                    <input type="text" name="refId" placeholder="Filter by Order/Booking ID..." class="form-control" style="background: #FFFFFF; min-width: 240px; padding: 0.55rem 1rem;">
                    <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                    <a href="<%= request.getContextPath() %>/payment/history" class="btn btn-secondary btn-sm">Reset</a>
                </form>
                <a href="<%= request.getContextPath() %>/staff/dashboard" class="btn btn-outline btn-sm">
                    &larr; Dashboard
                </a>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1.25rem; margin-bottom: 2.5rem;">
            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.4rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: #059669; letter-spacing: 0.6px;">Total Settled Revenue</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: #065F46; margin-top: 0.3rem;">
                    $<%= String.format("%.2f", totalRevenue) %>
                </div>
                <div style="font-size: 0.8rem; color: var(--c-cacao-muted); margin-top: 0.2rem;"><%= activeCount %> valid transactions</div>
            </div>

            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.4rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: var(--c-caramel); letter-spacing: 0.6px;">Total Records</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin-top: 0.3rem;">
                    <%= payments != null ? payments.size() : 0 %>
                </div>
                <div style="font-size: 0.8rem; color: var(--c-cacao-muted); margin-top: 0.2rem;">All recorded payment slips</div>
            </div>

            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.4rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: var(--c-cacao-muted); letter-spacing: 0.6px;">Voided Transactions</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: #991B1B; margin-top: 0.3rem;">
                    <%= voidCount %>
                </div>
                <div style="font-size: 0.8rem; color: var(--c-cacao-muted); margin-top: 0.2rem;">Cancelled or refunded slips</div>
            </div>
        </div>

        <!-- Master Table -->
        <div class="bakery-table-wrap">
            <table class="bakery-table">
                <thead>
                    <tr>
                        <th>Invoice ID</th>
                        <th>Order / Booking Ref</th>
                        <th>Date & Time</th>
                        <th>Payment Method</th>
                        <th>Transaction Description</th>
                        <th style="text-align: right;">Amount</th>
                        <th>Status</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (payments == null || payments.isEmpty()) { %>
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 3rem; color: var(--c-cacao-muted);">
                                No payment records located in system ledger.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Payment p : payments) { %>
                            <tr>
                                <td>
                                    <strong style="font-family: monospace; color: var(--c-cacao);"><%= p.getPaymentId() %></strong>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/payment/invoice?refId=<%= p.getOrderOrBookingId() %>&amt=<%= p.getAmount() %>" style="font-weight: 700; color: var(--c-caramel); font-family: monospace;">
                                        <%= p.getOrderOrBookingId() %>
                                    </a>
                                </td>
                                <td style="font-size: 0.85rem;"><%= p.getPaymentDate() %></td>
                                <td>
                                    <span class="badge badge-gold"><%= p.getMethod() %></span>
                                </td>
                                <td>
                                    <div style="max-width: 260px; font-size: 0.84rem; color: var(--c-cacao-muted); line-height: 1.4;">
                                        <%= p.getDetails() != null ? p.getDetails() : "Artisan Order Payment" %>
                                    </div>
                                </td>
                                <td style="text-align: right; font-weight: 800; font-size: 1.05rem; color: var(--c-cacao);">
                                    $<%= String.format("%.2f", p.getAmount()) %>
                                </td>
                                <td>
                                    <span class="status-pill status-<%= p.getStatus() %>">
                                        <%= p.getStatus() %>
                                    </span>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: inline-flex; gap: 0.4rem;">
                                        <a href="<%= request.getContextPath() %>/payment/invoice?refId=<%= p.getOrderOrBookingId() %>&amt=<%= p.getAmount() %>" class="btn btn-secondary btn-sm" style="padding: 0.25rem 0.6rem; font-size: 0.78rem;">
                                            Receipt
                                        </a>
                                        <% if (!"VOIDED".equalsIgnoreCase(p.getStatus())) { %>
                                            <a href="<%= request.getContextPath() %>/payment/delete?id=<%= p.getPaymentId() %>" 
                                               onclick="return confirm('Void this payment transaction slip?');" 
                                               class="btn btn-outline btn-sm" style="padding: 0.25rem 0.6rem; font-size: 0.78rem; color: #DC2626; border-color: #FECACA;">
                                                Void
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
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
