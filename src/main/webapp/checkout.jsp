<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Customer" %>
<%
    String refId = (String) request.getAttribute("refId");
    if (refId == null) refId = request.getParameter("refId");
    Double amount = (Double) request.getAttribute("amount");
    if (amount == null) {
        try { amount = Double.parseDouble(request.getParameter("amount")); } catch (Exception ignored) {}
    }
    if (amount == null) amount = 0.0;
    Boolean isDeposit = (Boolean) request.getAttribute("isDeposit");
    if (isDeposit == null) {
        isDeposit = "true".equalsIgnoreCase(request.getParameter("isDeposit"));
    }
    String selectedMethod = (String) request.getAttribute("selectedMethod");
    if (selectedMethod == null) selectedMethod = request.getParameter("method");
    if (selectedMethod == null || selectedMethod.trim().isEmpty()) selectedMethod = "CARD";

    Customer activeUser = (Customer) session.getAttribute("currentUser");
    String defaultHolder = activeUser != null ? activeUser.getName() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enter Payment Details & Confirm Order | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div style="max-width: 640px; margin: 2.5rem auto;">
            <!-- Header -->
            <div style="text-align: center; margin-bottom: 2rem;">
                <span class="hero-luxury-tag">
                    <span>💳</span>
                    <span>Sweetora Encrypted Settlement Gateway</span>
                </span>
                <h1 style="font-size: 2.4rem; margin-top: 0.4rem;">Enter Payment Details</h1>
                <p style="color: var(--c-cacao-muted); font-size: 0.95rem;">
                    Confirming order for: <strong style="color: var(--c-cacao);"><%= refId != null ? refId : "Order Reference" %></strong>
                </p>
            </div>

            <form action="<%= request.getContextPath() %>/payment/process" method="POST" class="form-panel" id="paymentForm">
                <input type="hidden" name="refId" value="<%= refId != null ? refId : "" %>">
                <input type="hidden" name="amount" value="<%= amount %>">
                <input type="hidden" name="isDeposit" value="<%= isDeposit %>">

                <!-- Amount Display Ribbon -->
                <div style="background: linear-gradient(135deg, #FFFDF9 0%, #FAF2E6 100%); border: 2px dashed var(--c-caramel); border-radius: var(--r-md); padding: 1.5rem; text-align: center; margin-bottom: 2rem;">
                    <span style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1.5px; color: var(--c-cacao-muted); font-weight: 700;">
                        <%= isDeposit ? "Advance 30% Kitchen Booking Deposit" : "Total Order Balance Payable" %>
                    </span>
                    <div style="font-family: var(--font-heading); font-size: 2.8rem; font-weight: 800; color: var(--c-caramel); margin: 0.2rem 0;">
                        Rs. <%= String.format("%.2f", amount) %>
                    </div>
                    <% if (isDeposit) { %>
                        <span class="badge badge-verified" style="margin-top: 0.4rem;">
                            ✓ Remaining 70% balance payable upon cake pickup/handover
                        </span>
                    <% } %>
                </div>

                <!-- Payment Method Toggle -->
                <div class="form-group">
                    <label class="form-label">Select Payment Method</label>
                    <div class="payment-selector-grid">
                        <label class="payment-method-card <%= !"CASH".equalsIgnoreCase(selectedMethod) ? "selected" : "" %>" id="cardOptionCard" onclick="selectPaymentMethod('CARD')">
                            <input type="radio" name="method" id="radioCard" value="CARD" <%= !"CASH".equalsIgnoreCase(selectedMethod) ? "checked" : "" %> style="accent-color: var(--c-caramel);">
                            <div class="method-info">
                                <strong>Credit / Debit Card</strong>
                                <small>Instant bank authorization</small>
                            </div>
                        </label>
                        <label class="payment-method-card <%= "CASH".equalsIgnoreCase(selectedMethod) ? "selected" : "" %>" id="cashOptionCard" onclick="selectPaymentMethod('CASH')">
                            <input type="radio" name="method" id="radioCash" value="CASH" <%= "CASH".equalsIgnoreCase(selectedMethod) ? "checked" : "" %> style="accent-color: var(--c-caramel);">
                            <div class="method-info">
                                <strong>Cash on Delivery / Counter</strong>
                                <small>Pay at Hedeniya bakery counter</small>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Live Interactive Credit Card Visualizer -->
                <div id="cardSection" style="<%= "CASH".equalsIgnoreCase(selectedMethod) ? "display: none;" : "display: block;" %>">
                    <div class="credit-card-preview" style="margin-bottom: 1.8rem;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div class="card-sim-chip"></div>
                            <span style="font-size: 1.15rem; font-weight: 700; opacity: 0.9;">Sweetora Pay</span>
                        </div>

                        <div class="card-sim-number" id="previewCardNum">•••• •••• •••• ••••</div>

                        <div class="card-sim-footer">
                            <div>
                                <span style="font-size: 0.65rem; opacity: 0.7; display: block; letter-spacing: 0.8px;">CARDHOLDER NAME</span>
                                <span class="card-sim-holder" id="previewHolder"><%= !defaultHolder.isEmpty() ? defaultHolder.toUpperCase() : "YOUR NAME" %></span>
                            </div>
                            <div>
                                <span style="font-size: 0.65rem; opacity: 0.7; display: block; letter-spacing: 0.8px;">EXPIRES</span>
                                <span id="previewExpiry" style="font-weight: 700;">MM/YY</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Name on Card <span style="color: #DC2626;">*</span></label>
                        <input type="text" name="cardHolder" id="inputHolder" class="form-control" value="<%= defaultHolder %>" placeholder="e.g. Kavindu Perera" oninput="updateCardVisual()" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Card Number <span style="color: #DC2626;">*</span></label>
                        <input type="text" name="cardNumber" id="inputCardNum" class="form-control" value="" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatAndPreviewCardNumber(this)" required autocomplete="cc-number">
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label class="form-label">Expiration (MM/YY) <span style="color: #DC2626;">*</span></label>
                            <input type="text" name="cardExpiry" id="inputExpiry" class="form-control" value="" placeholder="MM/YY" maxlength="5" oninput="formatAndPreviewExpiry(this)" required autocomplete="cc-exp">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Security CVC <span style="color: #DC2626;">*</span></label>
                            <input type="password" name="cardCvv" id="inputCvv" class="form-control" value="" placeholder="•••" maxlength="4" required autocomplete="cc-csc">
                        </div>
                    </div>
                </div>

                <div id="cashSection" style="<%= !"CASH".equalsIgnoreCase(selectedMethod) ? "display: none;" : "display: block;" %>" class="alert alert-info">
                    💵 <strong>Cash Settlement Selected:</strong> Payment will be settled and confirmed by the cashier when your cake or artisan bakes are handed over at the Sweetora bakery counter in Hedeniya, Kandy.
                </div>

                <button type="submit" id="submitPayBtn" class="btn btn-primary" style="width: 100%; padding: 1.1rem; font-size: 1.1rem; margin-top: 1rem; cursor: pointer;">
                    Confirm Order & Pay Rs. <%= String.format("%.2f", amount) %> &rarr;
                </button>
            </form>
        </div>
    </main>

    <script>
        function selectPaymentMethod(method) {
            const cardSec = document.getElementById('cardSection');
            const cashSec = document.getElementById('cashSection');
            const cardCard = document.getElementById('cardOptionCard');
            const cashCard = document.getElementById('cashOptionCard');
            const radioCard = document.getElementById('radioCard');
            const radioCash = document.getElementById('radioCash');
            const holder = document.getElementById('inputHolder');
            const cardNum = document.getElementById('inputCardNum');
            const expiry = document.getElementById('inputExpiry');
            const cvv = document.getElementById('inputCvv');
            const submitBtn = document.getElementById('submitPayBtn');

            if (method === 'CARD') {
                radioCard.checked = true;
                cardSec.style.display = 'block';
                cashSec.style.display = 'none';
                cardCard.classList.add('selected');
                cashCard.classList.remove('selected');
                holder.required = true;
                cardNum.required = true;
                expiry.required = true;
                cvv.required = true;
                submitBtn.innerHTML = 'Confirm Order & Pay Rs. <%= String.format("%.2f", amount) %> &rarr;';
            } else {
                radioCash.checked = true;
                cardSec.style.display = 'none';
                cashSec.style.display = 'block';
                cashCard.classList.add('selected');
                cardCard.classList.remove('selected');
                holder.required = false;
                cardNum.required = false;
                expiry.required = false;
                cvv.required = false;
                submitBtn.innerHTML = 'Confirm Order with Cash Settlement &rarr;';
            }
        }

        function formatAndPreviewCardNumber(input) {
            let val = input.value.replace(/\D/g, '');
            if (val.length > 16) val = val.substring(0, 16);
            let formatted = val.match(/.{1,4}/g)?.join(' ') || val;
            input.value = formatted;
            
            const preview = document.getElementById('previewCardNum');
            if (formatted.length > 0) {
                preview.textContent = formatted;
            } else {
                preview.textContent = '•••• •••• •••• ••••';
            }
        }

        function formatAndPreviewExpiry(input) {
            let val = input.value.replace(/\D/g, '');
            if (val.length > 4) val = val.substring(0, 4);
            if (val.length >= 3) {
                val = val.substring(0, 2) + '/' + val.substring(2);
            }
            input.value = val;

            const preview = document.getElementById('previewExpiry');
            preview.textContent = val.length > 0 ? val : 'MM/YY';
        }

        function updateCardVisual() {
            const holder = document.getElementById('inputHolder').value;
            document.getElementById('previewHolder').textContent = holder.trim() ? holder.toUpperCase() : 'YOUR NAME';
        }

        // Initialize view based on preselection
        document.addEventListener('DOMContentLoaded', () => {
            selectPaymentMethod('<%= selectedMethod %>');
        });
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
