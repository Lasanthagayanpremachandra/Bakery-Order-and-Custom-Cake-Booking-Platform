package com.bakery.model;

/**
 * Represents an individual line item within an Order.
 */
public class OrderItem {
    private String productId;
    private String productName;
    private int quantity;
    private double unitPrice;

    public OrderItem() {}

    public OrderItem(String productId, String productName, int quantity, double unitPrice) {
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public double getSubtotal() {
        return quantity * unitPrice;
    }

    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    // Serialization helper: productId:qty:unitPrice
    public String toItemString() {
        return productId + ":" + quantity + ":" + unitPrice + ":" + productName.replace(":", " ");
    }

    public static OrderItem fromItemString(String str) {
        if (str == null || str.trim().isEmpty()) return null;
        String[] parts = str.split(":");
        if (parts.length >= 3) {
            String pId = parts[0];
            int qty = Integer.parseInt(parts[1]);
            double price = Double.parseDouble(parts[2]);
            String name = parts.length >= 4 ? parts[3] : "Bakery Item";
            return new OrderItem(pId, name, qty, price);
        }
        return null;
    }
}
