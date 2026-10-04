<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.service.ProductService" %>
<%@ page import="com.bakery.model.Product" %>
<%@ page import="java.util.List" %>
<%
    ProductService productService = new ProductService();
    List<Product> featured = productService.getAllProducts();
    if (featured.size() > 4) {
        featured = featured.subList(0, 4);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sweetora | Haute Pâtisserie & Custom Cake Studio</title>
    <meta name="description" content="Artisan luxury bakery Sweetora offering handcrafted celebration cakes, French pastries, hearth sourdough loaves, and custom couture cake booking.">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Luxury Hero Section -->
        <section class="hero-luxury">
            <div class="hero-luxury-content">
                <span class="hero-luxury-tag">
                    <span>✨</span>
                    <span>Haute Pâtisserie & Pure French Butter Tradition</span>
                </span>
                <h1 class="hero-luxury-title">
                    Where Sweet Dreams Become <em>Edible Art</em>
                </h1>
                <p class="hero-luxury-desc">
                    Experience uncompromised baking craftsmanship. Indulge in slow-fermented hearth sourdough, delicate French viennoiserie, or co-design a made-to-order celebration cake with our master decorators.
                </p>
                <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                    <a href="<%= request.getContextPath() %>/booking/form" class="btn btn-primary">
                        🎨 Design Custom Cake
                    </a>
                    <a href="<%= request.getContextPath() %>/product/list" class="btn btn-secondary">
                        🥐 Explore Morning Bakes
                    </a>
                </div>
            </div>
            
            <div class="hero-visual-card">
                <div class="hero-img-frame">
                    <img src="https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=85" alt="Belgian Chocolate Ganache Cake">
                </div>
                <div class="floating-badge">
                    <span class="floating-badge-icon">👑</span>
                    <div style="text-align: left;">
                        <div style="font-weight: 700; font-size: 0.88rem; color: var(--c-cacao);">Voted Best Pâtisserie 2026</div>
                        <div style="font-size: 0.76rem; color: var(--c-cacao-muted);">⭐ 4.95/5 Rating • 1,200+ Reviews</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Feature Pillars -->
        <section class="features-grid">
            <div class="feature-box">
                <div class="feature-icon-circle">🎂</div>
                <h3 class="feature-title">Couture Custom Studio</h3>
                <p class="feature-text">
                    Select artisan sponge flavours, multi-tier architectural styling, and hand-sculpted sugar flowers with live instant price calculation.
                </p>
            </div>
            <div class="feature-box">
                <div class="feature-icon-circle">🥐</div>
                <h3 class="feature-title">Slow-Crafted Daily</h3>
                <p class="feature-text">
                    All-butter flaky croissants, pecan swirls, and 36-hour slow-fermented organic sourdough baked fresh three times daily.
                </p>
            </div>
            <div class="feature-box">
                <div class="feature-icon-circle">💳</div>
                <h3 class="feature-title">30% Advance Deposit</h3>
                <p class="feature-text">
                    Lock in wedding and milestone celebration cake bookings with an advance deposit; settle the balance on delivery day.
                </p>
            </div>
            <div class="feature-box">
                <div class="feature-icon-circle">👑</div>
                <h3 class="feature-title">Gold VIP Privilege</h3>
                <p class="feature-text">
                    VIP circle members enjoy guaranteed 12% savings, private kitchen booking consultations, and priority oven queue slots.
                </p>
            </div>
        </section>

        <!-- Featured Creations Section -->
        <section style="margin-bottom: 5rem;">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2.2rem; flex-wrap: wrap; gap: 1rem;">
                <div>
                    <span style="font-size: 0.82rem; font-weight: 700; color: var(--c-caramel); text-transform: uppercase; letter-spacing: 1.5px;">Master Baker's Showcase</span>
                    <h2 style="font-size: 2.6rem; margin-top: 0.2rem;">Today's Signature Bakes</h2>
                </div>
                <a href="<%= request.getContextPath() %>/product/list" class="btn btn-outline btn-sm">
                    View Complete Catalog &rarr;
                </a>
            </div>

            <div class="cards-grid">
                <% for (Product p : featured) { %>
                    <div class="patisserie-card">
                        <div class="card-visual-wrap">
                            <img src="<%= p.getImageUrl() != null && !p.getImageUrl().isEmpty() ? p.getImageUrl() : "https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=500&q=80" %>" alt="<%= p.getName() %>">
                            <span class="card-top-tag"><%= p.getCategory() %></span>
                        </div>
                        <div class="card-content">
                            <h3 class="card-item-title"><%= p.getName() %></h3>
                            <div class="card-item-meta"><%= p.getCategoryDetails() %></div>
                            <p class="card-item-desc"><%= p.getDescription() %></p>
                            
                            <div class="card-action-bar">
                                <span class="price-display">$<%= String.format("%.2f", p.getPrice()) %></span>
                                <a href="<%= request.getContextPath() %>/order/add-cart?productId=<%= p.getProductId() %>&quantity=1" class="btn btn-primary btn-sm">
                                    + Add to Cart
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </section>

        <!-- Milestone Callout -->
        <section style="background: linear-gradient(135deg, #221510 0%, #362017 100%); color: #FFF; border-radius: var(--r-lg); padding: 4rem; display: flex; align-items: center; justify-content: space-between; gap: 3rem; flex-wrap: wrap; box-shadow: var(--shadow-hover); position: relative; overflow: hidden;">
            <div style="max-width: 660px; position: relative; z-index: 2;">
                <span style="color: var(--c-honey); font-size: 0.85rem; font-weight: 700; text-transform: uppercase; letter-spacing: 2px; display: block; margin-bottom: 0.6rem;">Exclusive Kitchen Slots</span>
                <h2 style="color: #FFFFFF; font-size: 2.8rem; margin-bottom: 1rem; line-height: 1.15;">Reserve Your Custom Celebration Cake</h2>
                <p style="color: #DCCEC6; font-size: 1.05rem; line-height: 1.7;">
                    Weddings, milestone birthdays, and corporate galas. Our decorators limit custom bookings to 5 per date to ensure immaculate hand-piped detailing.
                </p>
            </div>
            <div style="position: relative; z-index: 2;">
                <a href="<%= request.getContextPath() %>/booking/form" class="btn btn-primary" style="padding: 1.1rem 2.4rem; font-size: 1.05rem;">
                    🎂 Launch Custom Cake Studio &rarr;
                </a>
            </div>
        </section>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
