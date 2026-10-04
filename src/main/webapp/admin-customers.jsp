<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Customer" %>
<%@ page import="java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    int vipCount = 0;
    if (customers != null) {
        for (Customer c : customers) {
            if ("PREMIUM".equalsIgnoreCase(c.getType())) vipCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Directory (Admin) | La Petite Patisserie</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <span class="hero-badge">👥 Customer Relationship Management</span>
                <h1 style="font-size: 2.3rem; margin-top: 0.4rem;">Patron Directory</h1>
                <p style="color: var(--c-cacao-muted);">
                    Registered members, loyalty tier privileges, and contact destinations in <code>data/customers.txt</code>.
                </p>
            </div>

            <div style="display: flex; gap: 0.8rem; align-items: center; flex-wrap: wrap;">
                <form action="<%= request.getContextPath() %>/customer/search" method="GET" style="display: flex; gap: 0.5rem;">
                    <input type="text" name="q" placeholder="Search name, phone, email..." class="form-control" style="background: #FFFFFF; min-width: 250px; padding: 0.55rem 1rem;">
                    <button type="submit" class="btn btn-primary btn-sm">Search</button>
                    <a href="<%= request.getContextPath() %>/customer/list" class="btn btn-secondary btn-sm">Reset</a>
                </form>
                <a href="<%= request.getContextPath() %>/staff/dashboard" class="btn btn-outline btn-sm">
                    &larr; Dashboard
                </a>
            </div>
        </div>

        <!-- KPI Strip -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1.25rem; margin-bottom: 2.5rem;">
            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: var(--c-caramel); letter-spacing: 0.6px;">Total Registered Patrons</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin-top: 0.2rem;">
                    <%= customers != null ? customers.size() : 0 %>
                </div>
            </div>

            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: #92400E; letter-spacing: 0.6px;">👑 Gold VIP Members</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: #B45309; margin-top: 0.2rem;">
                    <%= vipCount %>
                </div>
                <div style="font-size: 0.8rem; color: var(--c-cacao-muted); margin-top: 0.2rem;">Active 12% privilege tier</div>
            </div>
        </div>

        <!-- Directory Table -->
        <div class="bakery-table-wrap">
            <table class="bakery-table">
                <thead>
                    <tr>
                        <th>Patron ID</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Email Address</th>
                        <th>Delivery Destination</th>
                        <th>Membership Privilege Tier</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (customers == null || customers.isEmpty()) { %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 3rem; color: var(--c-cacao-muted);">
                                No customer records found.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Customer c : customers) { %>
                            <tr>
                                <td>
                                    <strong style="font-family: monospace; color: var(--c-caramel); font-size: 0.88rem;">
                                        <%= c.getId() %>
                                    </strong>
                                </td>
                                <td>
                                    <strong style="font-size: 0.95rem; color: var(--c-cacao);"><%= c.getName() %></strong>
                                </td>
                                <td><%= c.getPhone() %></td>
                                <td><%= c.getEmail() %></td>
                                <td>
                                    <div style="max-width: 220px; font-size: 0.85rem; color: var(--c-cacao-muted); line-height: 1.4;">
                                        <%= c.getAddress() %>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge <%= "PREMIUM".equalsIgnoreCase(c.getType()) ? "badge-gold" : "badge-soft" %>">
                                        <%= c.getMembershipBadge() %>
                                    </span>
                                </td>
                                <td style="text-align: right;">
                                    <a href="<%= request.getContextPath() %>/customer/delete?id=<%= c.getId() %>" 
                                       onclick="return confirm('Permanently remove customer <%= c.getName() %> (<%= c.getId() %>)?');" 
                                       class="btn btn-outline btn-sm" style="padding: 0.25rem 0.6rem; font-size: 0.76rem; color: #DC2626; border-color: #FECACA;">
                                        Delete
                                    </a>
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
