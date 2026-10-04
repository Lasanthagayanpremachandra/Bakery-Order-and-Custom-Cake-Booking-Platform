package com.bakery.service;

import com.bakery.dao.ProductFileDAO;
import com.bakery.model.Bread;
import com.bakery.model.Pastry;
import com.bakery.model.Product;
import com.bakery.model.ReadyMadeCake;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Service Layer for Bakery Product and Menu Management.
 */
public class ProductService {
    private final ProductFileDAO productDAO;

    public ProductService() {
        this.productDAO = new ProductFileDAO();
    }

    public Product addProduct(String name, String category, double price, int stock, String description, String imageUrl, String extra1, String extra2) {
        String id = "PROD-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        Product product;
        if ("CAKE".equalsIgnoreCase(category)) {
            int shelfLife = 5;
            try { if (extra2 != null && !extra2.isEmpty()) shelfLife = Integer.parseInt(extra2); } catch (Exception ignored) {}
            product = new ReadyMadeCake(id, name, price, stock, description, imageUrl, extra1 != null ? extra1 : "Vanilla", shelfLife);
        } else if ("PASTRY".equalsIgnoreCase(category)) {
            boolean gf = Boolean.parseBoolean(extra2);
            product = new Pastry(id, name, price, stock, description, imageUrl, extra1 != null ? extra1 : "Croissant", gf);
        } else if ("BREAD".equalsIgnoreCase(category)) {
            boolean sd = Boolean.parseBoolean(extra2);
            product = new Bread(id, name, price, stock, description, imageUrl, extra1 != null ? extra1 : "Multigrain", sd);
        } else {
            product = new ReadyMadeCake(id, name, price, stock, description, imageUrl, "Signature", 4);
        }

        boolean ok = productDAO.save(product);
        return ok ? product : null;
    }

    public boolean updateProduct(Product product) {
        if (product == null || product.getProductId() == null) return false;
        return productDAO.save(product);
    }

    public boolean removeProduct(String id) {
        return productDAO.delete(id);
    }

    public Product getProduct(String id) {
        return productDAO.findById(id);
    }

    public List<Product> getAllProducts() {
        return productDAO.getAll();
    }

    public List<Product> searchProducts(String query, String category, Double minPrice, Double maxPrice) {
        List<Product> all = productDAO.getAll();
        List<Product> matches = new ArrayList<>();

        for (Product p : all) {
            boolean match = true;
            if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
                if (!category.equalsIgnoreCase(p.getCategory())) {
                    match = false;
                }
            }
            if (match && query != null && !query.trim().isEmpty()) {
                String q = query.toLowerCase();
                boolean nameMatch = p.getName() != null && p.getName().toLowerCase().contains(q);
                boolean descMatch = p.getDescription() != null && p.getDescription().toLowerCase().contains(q);
                boolean catMatch = p.getCategory() != null && p.getCategory().toLowerCase().contains(q);
                if (!nameMatch && !descMatch && !catMatch) {
                    match = false;
                }
            }
            if (match && minPrice != null && p.getPrice() < minPrice) {
                match = false;
            }
            if (match && maxPrice != null && p.getPrice() > maxPrice) {
                match = false;
            }

            if (match) {
                matches.add(p);
            }
        }
        return matches;
    }

    public boolean checkStock(String productId, int requestedQty) {
        Product p = getProduct(productId);
        return p != null && p.getStock() >= requestedQty;
    }

    public boolean deductStock(String productId, int qty) {
        Product p = getProduct(productId);
        if (p != null && p.getStock() >= qty) {
            p.setStock(p.getStock() - qty);
            return productDAO.save(p);
        }
        return false;
    }
}
