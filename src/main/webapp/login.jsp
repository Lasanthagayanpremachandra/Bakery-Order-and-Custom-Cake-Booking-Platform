<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Sign In | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div style="max-width: 500px; margin: 2.5rem auto;">
            <div style="text-align: center; margin-bottom: 2rem;">
                <span class="hero-luxury-tag">
                    <span>👑</span>
                    <span>Patron Circle Authentication</span>
                </span>
                <h1 style="font-size: 2.5rem; margin-top: 0.4rem;">Customer Sign In</h1>
                <p style="color: var(--c-cacao-muted); font-size: 0.95rem;">Access your custom cake atelier, saved deliveries & VIP savings.</p>
            </div>

            <% if (error != null) { %>
                <div class="alert alert-error">
                    ⚠️ <%= error %>
                </div>
            <% } %>

            <!-- 1-Click Instant Demo Login Banner -->
            <div style="background: linear-gradient(135deg, #FFFDF8 0%, #FDF4E5 100%); border: 1.5px dashed var(--c-caramel); border-radius: var(--r-md); padding: 1.2rem 1.4rem; margin-bottom: 1.8rem; box-shadow: var(--shadow-subtle);">
                <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.6rem;">
                    <span style="font-size: 1.1rem;">⚡</span>
                    <strong style="color: var(--c-cacao); font-size: 0.88rem; text-transform: uppercase; letter-spacing: 0.8px;">1-Click Instant Demo Login</strong>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.8rem;">
                    <button type="button" onclick="instantLogin('eleanor@bakery.com', 'pass123')" class="btn btn-secondary btn-sm" style="border-color: #E2B779; background: #FFFFFF; font-size: 0.8rem; padding: 0.5rem 0.7rem; justify-content: flex-start; text-align: left;">
                        👑 <strong>Kavindu (Gold VIP)</strong>
                    </button>
                    <button type="button" onclick="instantLogin('marcus@example.com', 'pass123')" class="btn btn-secondary btn-sm" style="border-color: #E2B779; background: #FFFFFF; font-size: 0.8rem; padding: 0.5rem 0.7rem; justify-content: flex-start; text-align: left;">
                        👤 <strong>Kasun (Regular)</strong>
                    </button>
                </div>
            </div>

            <form id="customerLoginForm" action="<%= request.getContextPath() %>/customer/login" method="POST" class="form-panel">
                <div class="form-group">
                    <label class="form-label">Email Address, Member ID, or Phone</label>
                    <input type="text" name="email" id="loginEmail" class="form-control" placeholder="kavindu@sweetora.com" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Account Password</label>
                    <input type="password" name="password" id="loginPass" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.9rem; font-size: 1.05rem; margin-top: 0.5rem;">
                    Sign In to Account &rarr;
                </button>

                <div style="margin-top: 1.8rem; padding-top: 1.2rem; border-top: 1px solid var(--c-border-light); font-size: 0.9rem; text-align: center; color: var(--c-cacao-muted);">
                    New to Sweetora? 
                    <a href="<%= request.getContextPath() %>/customer/register" style="font-weight: 700; color: var(--c-caramel);">Register as a Member</a>
                </div>
            </form>
        </div>
    </main>

    <script>
        function instantLogin(email, pass) {
            document.getElementById('loginEmail').value = email;
            document.getElementById('loginPass').value = pass;
            document.getElementById('customerLoginForm').submit();
        }
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
