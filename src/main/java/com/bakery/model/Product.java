package com.bakery.model;

/**
 * Base abstract class for bakery products.
 * Demonstrates Encapsulation and Polymorphism.
 */
public abstract class Product {
    private String productId;
    private String name;
    private String category; // CAKE, PASTRY, BREAD, DESSERT
    private double price;
    private int stock;
    private String description;
    private String imageUrl;

    public Product() {}

    public Product(String productId, String name, String category, double price, int stock, String description, String imageUrl) {
        this.productId = productId;
        this.name = name;
        this.category = category;
        this.price = price;
        this.stock = stock;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    // Abstract method showing Polymorphism in subclasses
    public abstract String getCategoryDetails();
    public abstract double calculateServingPrice(int servings);

    // Encapsulation: Getters and Setters
    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String toFileString() {
        return String.join("|",
            productId != null ? productId : "",
            name != null ? name.replace("|", " ") : "",
            category != null ? category : "OTHER",
            String.valueOf(price),
            String.valueOf(stock),
            description != null ? description.replace("|", " ") : "",
            imageUrl != null ? imageUrl : ""
        );
    }
}
