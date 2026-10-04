<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Product" %>
<%@ page import="com.bakery.model.ReadyMadeCake" %>
<%@ page import="com.bakery.model.Pastry" %>
<%@ page import="com.bakery.model.Bread" %>
<%
    Product prod = (Product) request.getAttribute("product");
    boolean isEdit = (prod != null);
    String cat = isEdit ? prod.getCategory() : "CAKE";
    String extra1 = "";
    String extra2 = "";
    if (prod instanceof ReadyMadeCake) {
        ReadyMadeCake c = (ReadyMadeCake) prod;
        extra1 = c.getFlavor();
        extra2 = String.valueOf(c.getShelfLifeDays());
    } else if (prod instanceof Pastry) {
        Pastry p = (Pastry) prod;
        extra1 = p.getPastryType();
        extra2 = String.valueOf(p.isGlutenFree());
    } else if (prod instanceof Bread) {
        Bread b = (Bread) prod;
        extra1 = b.getGrainType();
        extra2 = String.valueOf(b.isSourdough());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Product" : "Add Product" %> | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <div style="max-width: 720px; margin: 0 auto;">
            <div style="margin-bottom: 2rem;">
                <span class="hero-badge">📦 Catalog Management</span>
                <h1 style="font-size: 2.3rem; margin-top: 0.4rem;">
                    <%= isEdit ? "Edit Bakery Product" : "Create New Bakery Product" %>
                </h1>
                <p style="color: var(--c-cacao-muted);">
                    Data persisted directly to flat file storage in <code>data/products.txt</code>.
                </p>
            </div>

            <form action="<%= request.getContextPath() %>/product/save" method="POST" class="form-panel">
                <input type="hidden" name="productId" value="<%= isEdit ? prod.getProductId() : "" %>">

                <div class="form-group">
                    <label class="form-label">Artisan Product Name</label>
                    <input type="text" name="name" class="form-control" value="<%= isEdit ? prod.getName() : "" %>" placeholder="e.g. Belgian Dark Chocolate Ganache Gateau" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem;">
                    <div class="form-group">
                        <label class="form-label">Product Category</label>
                        <select name="category" class="form-control" id="catSelector" onchange="updateSubclassLabels(this.value)" required>
                            <option value="CAKE" <%= "CAKE".equalsIgnoreCase(cat) ? "selected" : "" %>>🎂 Ready-Made Celebration Cake</option>
                            <option value="PASTRY" <%= "PASTRY".equalsIgnoreCase(cat) ? "selected" : "" %>>🥐 Fresh Artisan Pastry</option>
                            <option value="BREAD" <%= "BREAD".equalsIgnoreCase(cat) ? "selected" : "" %>>🥖 Hearth Sourdough Bread</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Unit Price (Rs.)</label>
                        <input type="number" step="0.01" name="price" class="form-control" value="<%= isEdit ? prod.getPrice() : "15.00" %>" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem;">
                    <div class="form-group">
                        <label class="form-label">Stock Quantity in Kitchen</label>
                        <input type="number" name="stock" class="form-control" value="<%= isEdit ? prod.getStock() : "10" %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Image URL / Visual Asset</label>
                        <input type="text" name="imageUrl" class="form-control" value="<%= isEdit ? prod.getImageUrl() : "" %>" placeholder="https://images.unsplash.com/...">
                    </div>
                </div>

                <!-- Subclass Specific Fields (OOP Inheritance Demonstration) -->
                <div style="background: var(--c-bg-subtle); padding: 1.5rem; border-radius: var(--r-sm); margin-bottom: 1.5rem; border: 1.5px solid var(--c-border);">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                        <strong style="font-size: 0.92rem; color: var(--c-cacao); text-transform: uppercase; letter-spacing: 0.6px;">
                            OOP Subclass Attributes (Polymorphic Serialization)
                        </strong>
                        <span class="badge badge-gold" id="oopBadge">ReadyMadeCake</span>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" id="extra1Label">Flavor Profile</label>
                            <input type="text" name="extra1" id="extra1Input" class="form-control" value="<%= extra1 %>" placeholder="e.g. Belgian Chocolate or Croissant">
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" id="extra2Label">Shelf Life Days / Gluten-Free</label>
                            <input type="text" name="extra2" id="extra2Input" class="form-control" value="<%= extra2 %>" placeholder="e.g. 5 or true/false">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Product Description & Tasting Notes</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Describe the aroma, texture, layering, and crust..."><%= isEdit ? prod.getDescription() : "" %></textarea>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--c-border-light);">
                    <a href="<%= request.getContextPath() %>/product/admin-list" class="btn btn-secondary">&larr; Return to Inventory</a>
                    <button type="submit" class="btn btn-primary" style="padding: 0.8rem 1.8rem;">
                        <%= isEdit ? "Update Catalog Entry" : "Save to Products Catalog" %>
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script>
        function updateSubclassLabels(cat) {
            const l1 = document.getElementById('extra1Label');
            const l2 = document.getElementById('extra2Label');
            const i1 = document.getElementById('extra1Input');
            const i2 = document.getElementById('extra2Input');
            const badge = document.getElementById('oopBadge');

            if (cat === 'CAKE') {
                badge.textContent = 'ReadyMadeCake (extends Product)';
                l1.textContent = 'Cake Flavor Profile';
                i1.placeholder = 'e.g. Bourbon Vanilla, Dark Truffle';
                l2.textContent = 'Shelf Life (Days)';
                i2.placeholder = 'e.g. 5';
            } else if (cat === 'PASTRY') {
                badge.textContent = 'Pastry (extends Product)';
                l1.textContent = 'Pastry Lamination Type';
                i1.placeholder = 'e.g. Croissant, Danish, Brioche';
                l2.textContent = 'Is Gluten-Free? (true / false)';
                i2.placeholder = 'true or false';
            } else if (cat === 'BREAD') {
                badge.textContent = 'Bread (extends Product)';
                l1.textContent = 'Grain Flour Blend';
                i1.placeholder = 'e.g. Stoneground Whole Rye';
                l2.textContent = 'Natural Wild Sourdough? (true / false)';
                i2.placeholder = 'true or false';
            }
        }
        updateSubclassLabels(document.getElementById('catSelector').value);
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
