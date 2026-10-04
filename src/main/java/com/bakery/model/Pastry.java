package com.bakery.model;

/**
 * Pastry product subclass.
 * Demonstrates Inheritance from Product.
 */
public class Pastry extends Product {
    private String pastryType; // e.g. Croissant, Danish, Tart, Puff
    private boolean isGlutenFree;

    public Pastry() {
        super();
        setCategory("PASTRY");
    }

    public Pastry(String productId, String name, double price, int stock, String description, String imageUrl, String pastryType, boolean isGlutenFree) {
        super(productId, name, "PASTRY", price, stock, description, imageUrl);
        this.pastryType = pastryType;
        this.isGlutenFree = isGlutenFree;
    }

    public String getPastryType() { return pastryType; }
    public void setPastryType(String pastryType) { this.pastryType = pastryType; }

    public boolean isGlutenFree() { return isGlutenFree; }
    public void setGlutenFree(boolean glutenFree) { isGlutenFree = glutenFree; }

    @Override
    public String getCategoryDetails() {
        return "Fresh Pastry | Type: " + (pastryType != null ? pastryType : "Flaky") + (isGlutenFree ? " (Gluten-Free)" : "");
    }

    @Override
    public double calculateServingPrice(int servings) {
        return getPrice() * servings;
    }
}
