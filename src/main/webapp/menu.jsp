<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Product" %>
<%@ page import="java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Product> products = (List<Product>) request.getAttribute("products");
    String activeCategory = (String) request.getAttribute("activeCategory");
    if (activeCategory == null) activeCategory = "ALL";
    String searchQuery = (String) request.getAttribute("searchQuery");
    if (searchQuery == null) searchQuery = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Haute Pâtisserie Collection | La Petite Patisserie</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Header Ribbon -->
        <div style="margin-bottom: 3rem; text-align: center;">
            <span class="hero-luxury-tag">
                <span>🥐</span>
                <span>Artisan Morning & Afternoon Oven Batches</span>
            </span>
            <h1 style="font-size: 3.2rem; margin-top: 0.5rem; margin-bottom: 0.5rem;">The Bakery Collection</h1>
            <p style="color: var(--c-cacao-muted); max-width: 600px; margin: 0 auto; font-size: 1.05rem;">
                Crafted daily with French cultured butter, organic unbleached grain, and time-honored artisanal fermentation.
            </p>
        </div>

        <!-- Filter & Search Controls -->
        <div style="display: flex; justify-content: space-between; align-items: center; gap: 1.5rem; flex-wrap: wrap; margin-bottom: 2.5rem; background: #FFFFFF; padding: 1rem 1.5rem; border-radius: var(--r-full); border: 1px solid var(--c-border); box-shadow: var(--shadow-subtle);">
            <div class="category-tabs-luxury" style="margin-bottom: 0;">
                <a href="<%= request.getContextPath() %>/product/list?category=ALL" class="tab-luxury-btn <%= "ALL".equalsIgnoreCase(activeCategory) ? "active" : "" %>">
                    🌟 All Creations
                </a>
                <a href="<%= request.getContextPath() %>/product/list?category=CAKE" class="tab-luxury-btn <%= "CAKE".equalsIgnoreCase(activeCategory) ? "active" : "" %>">
                    🍰 Ready Cakes
                </a>
                <a href="<%= request.getContextPath() %>/product/list?category=PASTRY" class="tab-luxury-btn <%= "PASTRY".equalsIgnoreCase(activeCategory) ? "active" : "" %>">
                    🥐 Viennoiserie
                </a>
                <a href="<%= request.getContextPath() %>/product/list?category=BREAD" class="tab-luxury-btn <%= "BREAD".equalsIgnoreCase(activeCategory) ? "active" : "" %>">
                    🥖 Sourdough & Hearth
                </a>
            </div>

            <form action="<%= request.getContextPath() %>/product/list" method="GET" style="display: flex; gap: 0.5rem; min-width: 320px;">
                <input type="hidden" name="category" value="<%= activeCategory %>">
                <input type="text" name="q" value="<%= searchQuery %>" placeholder="Search bakes, sourdough, tartlets..." class="form-control" style="background: var(--c-bg); border-radius: var(--r-full); padding-left: 1.2rem;">
                <button type="submit" class="btn btn-primary btn-sm" style="padding: 0 1.2rem;">Search</button>
            </form>
        </div>

        <!-- Products Grid -->
        <% if (products == null || products.isEmpty()) { %>
            <div style="text-align: center; padding: 5rem 1rem; background: #FFFFFF; border-radius: var(--r-lg); border: 1px dashed var(--c-border);">
                <span style="font-size: 3.5rem;">🔍</span>
                <h3 style="margin-top: 1rem; margin-bottom: 0.5rem; font-size: 1.8rem;">No artisan bakes match your query</h3>
                <p style="color: var(--c-cacao-muted); margin-bottom: 1.5rem;">Please check your search term or select another category.</p>
                <a href="<%= request.getContextPath() %>/product/list" class="btn btn-secondary">Reset Filters</a>
            </div>
        <% } else { %>
            <div class="cards-grid">
                <% for (Product p : products) { %>
                    <div class="patisserie-card">
                        <div class="card-visual-wrap">
                            <img src="<%= p.getImageUrl() != null && !p.getImageUrl().isEmpty() ? p.getImageUrl() : "https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=500&q=80" %>" alt="<%= p.getName() %>">
                            <span class="card-top-tag"><%= p.getCategory() %></span>
                        </div>
                        <div class="card-content">
                            <h3 class="card-item-title"><%= p.getName() %></h3>
                            <div class="card-item-meta"><%= p.getCategoryDetails() %></div>
                            <p class="card-item-desc"><%= p.getDescription() %></p>
                            
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; font-size: 0.8rem;">
                                <span class="badge <%= p.getStock() > 5 ? "badge-verified" : (p.getStock() > 0 ? "badge-gold" : "badge-soft") %>">
                                    <%= p.getStock() > 0 ? "✓ " + p.getStock() + " In Kitchen" : "Sold Out Today" %>
                                </span>
                            </div>

                            <div class="card-action-bar">
                                <span class="price-display">$<%= String.format("%.2f", p.getPrice()) %></span>
                                <% if (p.getStock() > 0) { %>
                                    <a href="<%= request.getContextPath() %>/order/add-cart?productId=<%= p.getProductId() %>&quantity=1" class="btn btn-primary btn-sm">
                                        🛒 Add to Basket
                                    </a>
                                <% } else { %>
                                    <button class="btn btn-secondary btn-sm" disabled style="opacity: 0.5;">Sold Out</button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
