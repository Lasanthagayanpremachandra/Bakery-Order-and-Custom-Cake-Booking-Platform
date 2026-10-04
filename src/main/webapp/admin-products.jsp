<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Product" %>
<%@ page import="java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Product> products = (List<Product>) request.getAttribute("products");
    int cakesCount = 0;
    int pastryCount = 0;
    int breadCount = 0;

    if (products != null) {
        for (Product p : products) {
            String c = p.getCategory();
            if ("CAKE".equalsIgnoreCase(c)) cakesCount++;
            else if ("PASTRY".equalsIgnoreCase(c)) pastryCount++;
            else if ("BREAD".equalsIgnoreCase(c)) breadCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product & Menu Inventory | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Top Title & Actions -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <span class="hero-badge">📦 Artisan Catalog & Stock Control</span>
                <h1 style="font-size: 2.3rem; margin-top: 0.4rem;">Product & Menu Inventory</h1>
                <p style="color: var(--c-cacao-muted);">
                    Persisting inventory, pricing, and OOP product hierarchies in <code>data/products.txt</code>.
                </p>
            </div>

            <div style="display: flex; gap: 0.8rem; align-items: center;">
                <a href="<%= request.getContextPath() %>/staff/dashboard" class="btn btn-secondary btn-sm">
                    &larr; Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/product/add" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 0.4rem;">
                    <span>+</span> Add New Bakery Product
                </a>
            </div>
        </div>

        <!-- Inventory KPI Badges -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.2rem; margin-bottom: 2.5rem;">
            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: var(--c-caramel); letter-spacing: 0.6px;">Total Catalog Items</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin-top: 0.2rem;">
                    <%= products != null ? products.size() : 0 %>
                </div>
            </div>

            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: var(--c-cacao-muted); letter-spacing: 0.6px;">🎂 Ready-Made Cakes</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin-top: 0.2rem;">
                    <%= cakesCount %>
                </div>
            </div>

            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: var(--c-cacao-muted); letter-spacing: 0.6px;">🥐 French Pastries</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin-top: 0.2rem;">
                    <%= pastryCount %>
                </div>
            </div>

            <div style="background: #FFFFFF; border: 1px solid var(--c-border); border-radius: var(--r-md); padding: 1.3rem; box-shadow: var(--shadow-subtle);">
                <div style="font-size: 0.76rem; text-transform: uppercase; font-weight: 800; color: var(--c-cacao-muted); letter-spacing: 0.6px;">🥖 Hearth Breads</div>
                <div style="font-size: 2rem; font-family: var(--font-heading); font-weight: 800; color: var(--c-cacao); margin-top: 0.2rem;">
                    <%= breadCount %>
                </div>
            </div>
        </div>

        <!-- Master Table -->
        <div class="bakery-table-wrap">
            <table class="bakery-table">
                <thead>
                    <tr>
                        <th>Item ID</th>
                        <th>Product Details</th>
                        <th>OOP Hierarchy & Subclass Details</th>
                        <th style="text-align: right;">Unit Price</th>
                        <th>Available Stock</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (products == null || products.isEmpty()) { %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 3rem; color: var(--c-cacao-muted);">
                                No products found in <code>data/products.txt</code>.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Product p : products) { %>
                            <tr>
                                <td>
                                    <strong style="font-family: monospace; color: var(--c-caramel); font-size: 0.9rem;">
                                        <%= p.getProductId() %>
                                    </strong>
                                </td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 0.8rem;">
                                        <% if (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty()) { %>
                                            <img src="<%= p.getImageUrl() %>" alt="<%= p.getName() %>" style="width: 44px; height: 44px; border-radius: var(--r-sm); object-fit: cover; border: 1px solid var(--c-border-light);">
                                        <% } %>
                                        <div>
                                            <strong style="font-size: 0.98rem; color: var(--c-cacao);"><%= p.getName() %></strong>
                                            <div>
                                                <span class="badge badge-soft" style="font-size: 0.72rem; margin-top: 0.2rem;">
                                                    <%= p.getCategory() %>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size: 0.86rem; font-weight: 600; color: var(--c-cacao-light);">
                                        <%= p.getCategoryDetails() %>
                                    </div>
                                    <div style="font-size: 0.78rem; color: var(--c-cacao-muted); max-width: 320px; line-height: 1.4; margin-top: 0.2rem;">
                                        <%= p.getDescription() %>
                                    </div>
                                </td>
                                <td style="text-align: right; font-weight: 800; font-size: 1.1rem; color: var(--c-cacao);">
                                    $<%= String.format("%.2f", p.getPrice()) %>
                                </td>
                                <td>
                                    <span style="font-weight: 700; font-size: 0.85rem; color: <%= p.getStock() > 5 ? "#047857" : (p.getStock() > 0 ? "#D97706" : "#DC2626") %>;">
                                        ● <%= p.getStock() %> available
                                    </span>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: inline-flex; gap: 0.4rem;">
                                        <a href="<%= request.getContextPath() %>/product/edit?id=<%= p.getProductId() %>" class="btn btn-secondary btn-sm" style="padding: 0.25rem 0.65rem; font-size: 0.78rem;">
                                            Edit
                                        </a>
                                        <a href="<%= request.getContextPath() %>/product/delete?id=<%= p.getProductId() %>" 
                                           onclick="return confirm('Discontinue and remove product <%= p.getName() %>?');"
                                           class="btn btn-outline btn-sm" style="padding: 0.25rem 0.65rem; font-size: 0.78rem; color: #DC2626; border-color: #FECACA;">
                                            Delete
                                        </a>
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
