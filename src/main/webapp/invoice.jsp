<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Payment" %>
<%
    Payment payment = (Payment) request.getAttribute("payment");
    String customerName = (String) request.getAttribute("customerName");
    if (customerName == null || customerName.trim().isEmpty()) {
        customerName = "Valued Patron";
    }
    double amount = (payment != null) ? payment.getAmount() : 0.0;
    String invoiceId = (payment != null) ? payment.getPaymentId() : "INV-7710";
    String orderRef = (payment != null) ? payment.getOrderOrBookingId() : "REF-001";
    String payMethod = (payment != null) ? payment.getMethod() : "CARD";
    String payDate = (payment != null) ? payment.getPaymentDate() : "2026-09-17";
    String payStatus = (payment != null) ? payment.getStatus() : "PAID";
    String details = (payment != null && payment.getDetails() != null) ? payment.getDetails() : "Official Settlement for Artisan Bakery Order";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Official Bakery Receipt & Invoice | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
    <style>
        @media print {
            .bakery-floating-nav-wrapper, .bakery-header-sticky, .top-announcement, .bakery-footer, .no-print {
                display: none !important;
            }
            body {
                background: #FFFFFF !important;
                color: #000000 !important;
            }
            .invoice-container {
                box-shadow: none !important;
                border: 1px solid #CCC !important;
                padding: 1.5rem !important;
                margin: 0 !important;
            }
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container" style="max-width: 860px;">
        <div class="no-print" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= request.getContextPath() %>/order/track" class="btn btn-secondary btn-sm">
                    &larr; Track Orders
                </a>
                <a href="<%= request.getContextPath() %>/menu" class="btn btn-outline btn-sm">
                    🥐 Continue Shopping
                </a>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <button onclick="window.print()" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 0.4rem;">
                    🖨️ Print Official Receipt
                </button>
            </div>
        </div>

        <div class="invoice-container">
            <!-- Gold Authenticity Seal -->
            <div class="invoice-gold-seal">
                <span style="font-size: 1.1rem; margin-bottom: 2px;">★</span>
                <span>OFFICIAL</span>
                <span>RECEIPT</span>
            </div>

            <!-- Invoice Header -->
            <div class="invoice-header">
                <div>
                    <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem;">
                        <img src="<%= request.getContextPath() %>/images/sweetora-logo.png" alt="Sweetora Logo" style="width: 44px; height: 44px; border-radius: 50%; object-fit: cover; border: 2px solid #F3C68F;">
                        <span style="font-family: var(--font-heading); font-size: 2.2rem; font-weight: 800; color: var(--c-cacao);">
                            Sweetora
                        </span>
                    </div>
                    <div style="font-size: 0.88rem; color: var(--c-cacao-muted); line-height: 1.6;">
                        Cakes • Desserts • Sweeter Moments<br>
                        Hedeniya, Kandy, Sri Lanka<br>
                        Tel: +94 76 749 4866 &bull; billing@sweetora.com<br>
                        Tax Registration: #SW-7494-LKR
                    </div>
                </div>
                <div style="text-align: right; padding-right: 70px;">
                    <span class="status-pill status-<%= payStatus %>" style="font-size: 0.82rem; margin-bottom: 0.6rem;">
                        <%= payStatus %>
                    </span>
                    <div style="font-size: 0.95rem; font-weight: 700; color: var(--c-cacao);">
                        <%= invoiceId %>
                    </div>
                    <div style="font-size: 0.82rem; color: var(--c-cacao-muted); margin-top: 0.2rem;">
                        Issued: <strong><%= payDate %></strong>
                    </div>
                </div>
            </div>

            <!-- Bill To and Summary -->
            <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 2rem; margin-bottom: 2.5rem; background: var(--c-bg-subtle); padding: 1.5rem; border-radius: var(--r-md); border: 1px solid var(--c-border-light);">
                <div>
                    <span style="font-size: 0.76rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.8px; color: var(--c-caramel);">Billed To Patron</span>
                    <div style="font-size: 1.25rem; font-weight: 700; color: var(--c-cacao); margin: 0.2rem 0;">
                        <%= customerName %>
                    </div>
                    <div style="font-size: 0.85rem; color: var(--c-cacao-muted);">
                        Verified Member & Patron of Sweetora
                    </div>
                </div>
                <div>
                    <span style="font-size: 0.76rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.8px; color: var(--c-caramel);">Payment Details</span>
                    <div style="font-size: 0.88rem; color: var(--c-cacao); margin-top: 0.3rem; line-height: 1.6;">
                        <strong>Reference:</strong> <%= orderRef %><br>
                        <strong>Settlement Method:</strong> <%= payMethod %><br>
                        <strong>Transaction Time:</strong> <%= payDate %> &bull; Authenticated
                    </div>
                </div>
            </div>

            <!-- Line Items Table -->
            <div class="bakery-table-wrap" style="margin-bottom: 2rem;">
                <table class="bakery-table">
                    <thead>
                        <tr>
                            <th style="width: 55%;">Description & Service Detail</th>
                            <th style="width: 25%;">Order Reference</th>
                            <th style="width: 20%; text-align: right;">Amount Paid</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <strong style="font-size: 1rem; color: var(--c-cacao); display: block; margin-bottom: 0.3rem;">
                                    Artisan Bakery / Custom Cake Settlement
                                </strong>
                                <div style="font-size: 0.84rem; color: var(--c-cacao-muted); line-height: 1.5;">
                                    <%= details %>
                                </div>
                            </td>
                            <td>
                                <span class="badge badge-soft" style="font-family: monospace; font-size: 0.85rem; font-weight: 700;">
                                    <%= orderRef %>
                                </span>
                            </td>
                            <td style="text-align: right; font-size: 1.15rem; font-weight: 800; color: var(--c-cacao);">
                                Rs. <%= String.format("%.2f", amount) %>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Financial Total Summary -->
            <div style="display: flex; justify-content: flex-end; margin-bottom: 2.5rem;">
                <div style="width: 320px; background: var(--c-cream); border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.4rem;">
                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; color: var(--c-cacao-muted); margin-bottom: 0.6rem;">
                        <span>Subtotal Processed:</span>
                        <span>Rs. <%= String.format("%.2f", amount) %></span>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; color: var(--c-cacao-muted); margin-bottom: 0.8rem;">
                        <span>Taxes & GST (Included):</span>
                        <span>Rs. 0.00</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: baseline; border-top: 2px solid var(--c-border); padding-top: 0.8rem;">
                        <span style="font-weight: 700; color: var(--c-cacao); font-size: 1.05rem;">Total Settled:</span>
                        <span style="font-family: var(--font-heading); font-size: 1.85rem; font-weight: 800; color: var(--c-caramel);">
                            Rs. <%= String.format("%.2f", amount) %>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Artisan Footer Quality Seal -->
            <div style="text-align: center; border-top: 1px dashed var(--c-border); padding-top: 1.8rem;">
                <div style="font-family: var(--font-heading); font-size: 1.3rem; font-weight: 700; color: var(--c-cacao); margin-bottom: 0.3rem;">
                    Merci Beaucoup for Patronizing Our Bakery!
                </div>
                <div style="font-size: 0.86rem; color: var(--c-cacao-muted); max-width: 520px; margin: 0 auto; line-height: 1.6;">
                    Every treat is handcrafted from single-origin French butter, organic Madagascan vanilla, and unbleached stoneground flour. 
                    Please retain this official receipt for order pickup or event coordination.
                </div>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
