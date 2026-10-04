<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff & Baker Portal | La Petite Patisserie</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div style="max-width: 500px; margin: 2.5rem auto;">
            <div style="text-align: center; margin-bottom: 2rem;">
                <span class="hero-luxury-tag">
                    <span>🔐</span>
                    <span>Kitchen Staff & Executive Portal</span>
                </span>
                <h1 style="font-size: 2.5rem; margin-top: 0.4rem;">Staff Access</h1>
                <p style="color: var(--c-cacao-muted); font-size: 0.95rem;">Administrative console, kitchen production board & oven queues.</p>
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
                    <strong style="color: var(--c-cacao); font-size: 0.88rem; text-transform: uppercase; letter-spacing: 0.8px;">1-Click Instant Staff Login</strong>
                </div>
                <div style="display: grid; grid-template-columns: 1fr; gap: 0.6rem;">
                    <button type="button" onclick="instantStaffLogin('STF-001', 'admin123')" class="btn btn-secondary btn-sm" style="border-color: #E2B779; background: #FFFFFF; font-size: 0.82rem; padding: 0.55rem 0.8rem; justify-content: flex-start; text-align: left;">
                        ⚙️ <strong>Manager / Admin (Chef Jacques Pierre)</strong>
                    </button>
                    <button type="button" onclick="instantStaffLogin('STF-002', 'staff123')" class="btn btn-secondary btn-sm" style="border-color: #E2B779; background: #FFFFFF; font-size: 0.82rem; padding: 0.55rem 0.8rem; justify-content: flex-start; text-align: left;">
                        🎨 <strong>Cake Decorator (Giselle Dupont)</strong>
                    </button>
                    <button type="button" onclick="instantStaffLogin('STF-003', 'staff123')" class="btn btn-secondary btn-sm" style="border-color: #E2B779; background: #FFFFFF; font-size: 0.82rem; padding: 0.55rem 0.8rem; justify-content: flex-start; text-align: left;">
                        🧑‍🍳 <strong>Master Baker (Mateo Rossi)</strong>
                    </button>
                </div>
            </div>

            <form id="staffLoginForm" action="<%= request.getContextPath() %>/staff/login" method="POST" class="form-panel">
                <div class="form-group">
                    <label class="form-label">Staff Member ID or Name</label>
                    <input type="text" name="username" id="staffUserField" class="form-control" placeholder="STF-001" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Staff Access Password</label>
                    <input type="password" name="password" id="staffPassField" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.9rem; font-size: 1.05rem; margin-top: 0.5rem;">
                    Authenticate to Console &rarr;
                </button>
            </form>
        </div>
    </main>

    <script>
        function instantStaffLogin(user, pass) {
            document.getElementById('staffUserField').value = user;
            document.getElementById('staffPassField').value = pass;
            document.getElementById('staffLoginForm').submit();
        }
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
