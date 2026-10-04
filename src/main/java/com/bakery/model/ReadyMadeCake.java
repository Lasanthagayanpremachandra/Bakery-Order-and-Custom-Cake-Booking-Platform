package com.bakery.model;

/**
 * Ready-made Cake product subclass.
 * Demonstrates Inheritance from Product.
 */
public class ReadyMadeCake extends Product {
    private String flavor;
    private int shelfLifeDays;

    public ReadyMadeCake() {
        super();
        setCategory("CAKE");
    }

    public ReadyMadeCake(String productId, String name, double price, int stock, String description, String imageUrl, String flavor, int shelfLifeDays) {
        super(productId, name, "CAKE", price, stock, description, imageUrl);
        this.flavor = flavor;
        this.shelfLifeDays = shelfLifeDays;
    }

    public String getFlavor() { return flavor; }
    public void setFlavor(String flavor) { this.flavor = flavor; }

    public int getShelfLifeDays() { return shelfLifeDays; }
    public void setShelfLifeDays(int shelfLifeDays) { this.shelfLifeDays = shelfLifeDays; }

    @Override
    public String getCategoryDetails() {
        return "Artisan Cake | Flavor: " + (flavor != null ? flavor : "Standard") + " | Shelf Life: " + shelfLifeDays + " days";
    }

    @Override
    public double calculateServingPrice(int servings) {
        // Cake price per portion
        return getPrice() * (servings <= 0 ? 1 : servings);
    }
}
