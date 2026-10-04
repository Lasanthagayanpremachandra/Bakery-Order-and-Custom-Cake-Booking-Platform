package com.bakery.model;

/**
 * Bread product subclass.
 * Demonstrates Inheritance from Product.
 */
public class Bread extends Product {
    private String grainType; // e.g. Sourdough, Multigrain, Whole Wheat, Rye
    private boolean isSourdough;

    public Bread() {
        super();
        setCategory("BREAD");
    }

    public Bread(String productId, String name, double price, int stock, String description, String imageUrl, String grainType, boolean isSourdough) {
        super(productId, name, "BREAD", price, stock, description, imageUrl);
        this.grainType = grainType;
        this.isSourdough = isSourdough;
    }

    public String getGrainType() { return grainType; }
    public void setGrainType(String grainType) { this.grainType = grainType; }

    public boolean isSourdough() { return isSourdough; }
    public void setSourdough(boolean sourdough) { isSourdough = sourdough; }

    @Override
    public String getCategoryDetails() {
        return "Artisan Loaf | Grain: " + (grainType != null ? grainType : "Wheat") + (isSourdough ? " (Natural Starter)" : "");
    }

    @Override
    public double calculateServingPrice(int servings) {
        return getPrice() * servings;
    }
}
