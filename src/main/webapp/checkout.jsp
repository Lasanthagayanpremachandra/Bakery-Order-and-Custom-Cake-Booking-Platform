<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String refId = (String) request.getAttribute("refId");
    Double amount = (Double) request.getAttribute("amount");
    if (amount == null) amount = 0.0;
    Boolean isDeposit = (Boolean) request.getAttribute("isDeposit");
    if (isDeposit == null) isDeposit = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Haute Pâtisserie Settlement | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div style="max-width: 620px; margin: 2rem auto;">
            <!-- Header -->
            <div style="text-align: center; margin-bottom: 2rem;">
                <span class="hero-luxury-tag">
                    <span>💳</span>
                    <span>Secure Encrypted Payment Gateway</span>
                </span>
                <h1 style="font-size: 2.6rem; margin-top: 0.4rem;">Payment Settlement</h1>
                <p style="color: var(--c-cacao-muted); font-size: 0.95rem;">
                    Settling Order / Cake Atelier Reference: <strong style="color: var(--c-cacao);"><%= refId %></strong>
                </p>
            </div>

            <form action="<%= request.getContextPath() %>/payment/process" method="POST" class="form-panel">
                <input type="hidden" name="refId" value="<%= refId %>">
                <input type="hidden" name="amount" value="<%= amount %>">
                <input type="hidden" name="isDeposit" value="<%= isDeposit %>">

                <!-- Amount Display Ribbon -->
                <div style="background: linear-gradient(135deg, #FFFDF9 0%, #FAF2E6 100%); border: 2px dashed var(--c-caramel); border-radius: var(--r-md); padding: 1.5rem; text-align: center; margin-bottom: 2rem;">
                    <span style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1.5px; color: var(--c-cacao-muted); font-weight: 700;">
                        <%= isDeposit ? "Advance 30% Kitchen Booking Deposit" : "Total Settlement Due" %>
                    </span>
                    <div style="font-family: var(--font-heading); font-size: 2.8rem; font-weight: 800; color: var(--c-caramel); margin: 0.2rem 0;">
                        Rs. <%= String.format("%.2f", amount) %>
                    </div>
                    <% if (isDeposit) { %>
                        <span class="badge badge-verified" style="margin-top: 0.4rem;">
                            ✓ Balance payable upon cake delivery or collection
                        </span>
                    <% } %>
                </div>

                <!-- Payment Method Toggle -->
                <div class="form-group">
                    <label class="form-label">Choose Settlement Method</label>
                    <div class="payment-selector-grid">
                        <label class="payment-method-card" id="cardOptionCard" onclick="selectPaymentMethod('CARD')">
                            <input type="radio" name="method" value="CARD" checked style="accent-color: var(--c-caramel);">
                            <div class="method-info">
                                <strong>Credit / Debit Card</strong>
                                <small>Instant secure settlement</small>
                            </div>
                        </label>
                        <label class="payment-method-card" id="cashOptionCard" onclick="selectPaymentMethod('CASH')">
                            <input type="radio" name="method" value="CASH" style="accent-color: var(--c-caramel);">
                            <div class="method-info">
                                <strong>Cash on Hand</strong>
                                <small>Counter pickup settlement</small>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Live Interactive Credit Card Visualizer -->
                <div id="cardSection">
                    <div class="credit-card-preview">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div class="card-sim-chip"></div>
                            <span style="font-size: 1.2rem; opacity: 0.8;">🎂 Sweetora VIP</span>
                        </div>

                        <div class="card-sim-number" id="previewCardNum">4242 •••• •••• 4242</div>

                        <div class="card-sim-footer">
                            <div>
                                <span style="font-size: 0.65rem; opacity: 0.7; display: block;">CARDHOLDER</span>
                                <span class="card-sim-holder" id="previewHolder">KAVINDU PERERA</span>
                            </div>
                            <div>
                                <span style="font-size: 0.65rem; opacity: 0.7; display: block;">EXPIRES</span>
                                <span id="previewExpiry" style="font-weight: 700;">08/28</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Name on Card</label>
                        <input type="text" name="cardHolder" id="inputHolder" class="form-control" value="Kavindu Perera" placeholder="Cardholder full name" oninput="updateCardVisual()">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Card Number</label>
                        <input type="text" name="cardNumber" id="inputCardNum" class="form-control" value="4242 8821 9931 4242" placeholder="4242 •••• •••• ••••" oninput="updateCardVisual()">
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label class="form-label">Expiration (MM/YY)</label>
                            <input type="text" name="cardExpiry" id="inputExpiry" class="form-control" value="08/28" placeholder="MM/YY" oninput="updateCardVisual()">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Security CVC</label>
                            <input type="password" name="cardCvv" class="form-control" value="882" placeholder="•••">
                        </div>
                    </div>
                </div>

                <div id="cashSection" style="display: none;" class="alert alert-info">
                    💵 <strong>Cash Settlement Selected:</strong> Payment will be received and recorded by the cashier when your cake or artisan bakes are handed over at the bakery counter.
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1.1rem; margin-top: 1rem;">
                    Confirm & Authorize Settlement of Rs. <%= String.format("%.2f", amount) %> &rarr;
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

            if (method === 'CARD') {
                cardSec.style.display = 'block';
                cashSec.style.display = 'none';
                cardCard.classList.add('selected');
                cashCard.classList.remove('selected');
            } else {
                cardSec.style.display = 'none';
                cashSec.style.display = 'block';
                cashCard.classList.add('selected');
                cardCard.classList.remove('selected');
            }
        }

        function updateCardVisual() {
            const holder = document.getElementById('inputHolder').value;
            const num = document.getElementById('inputCardNum').value;
            const exp = document.getElementById('inputExpiry').value;

            document.getElementById('previewHolder').textContent = holder.trim() ? holder.toUpperCase() : 'VALUED PATRON';
            document.getElementById('previewCardNum').textContent = num.trim() ? num : '4242 •••• •••• 4242';
            document.getElementById('previewExpiry').textContent = exp.trim() ? exp : '08/28';
        }
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
