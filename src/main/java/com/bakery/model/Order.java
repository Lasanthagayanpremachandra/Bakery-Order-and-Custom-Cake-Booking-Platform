package com.bakery.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Base Order class representing a standard product order.
 * Demonstrates Encapsulation and Polymorphic price calculations.
 */
public class Order {
    private String orderId;
    private String customerId;
    private String customerName;
    private double totalAmount;
    private String status; // PENDING, CONFIRMED, BAKING, DECORATING, READY, DELIVERED, CANCELLED
    private String orderDate;
    private String deliveryAddress;
    private List<OrderItem> items = new ArrayList<>();

    public Order() {
        this.status = "PENDING";
    }

    public Order(String orderId, String customerId, String customerName, double totalAmount, String status, String orderDate, String deliveryAddress) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
        this.deliveryAddress = deliveryAddress;
    }

    public void addItem(OrderItem item) {
        items.add(item);
        recalculateTotal();
    }

    /**
     * Polymorphic price calculation method.
     * Standard orders calculate total as the sum of line items.
     */
    public double calculateOrderTotal() {
        double sum = 0.0;
        for (OrderItem item : items) {
            sum += item.getSubtotal();
        }
        this.totalAmount = sum;
        return sum;
    }

    public void recalculateTotal() {
        calculateOrderTotal();
    }

    // Getters and Setters
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getCustomerId() { return customerId; }
    public void setCustomerId(String customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { 
        this.items = items; 
        recalculateTotal();
    }

    public String getItemsSerialized() {
        List<String> serialized = new ArrayList<>();
        for (OrderItem item : items) {
            serialized.add(item.toItemString());
        }
        return String.join(";", serialized);
    }

    public void setItemsFromSerialized(String data) {
        items.clear();
        if (data != null && !data.trim().isEmpty()) {
            String[] rawItems = data.split(";");
            for (String raw : rawItems) {
                OrderItem item = OrderItem.fromItemString(raw);
                if (item != null) items.add(item);
            }
        }
    }

    // Flat file format: orderId|customerId|customerName|totalAmount|status|orderDate|deliveryAddress|items
    public String toFileString() {
        return String.join("|",
            orderId != null ? orderId : "",
            customerId != null ? customerId : "",
            customerName != null ? customerName : "",
            String.valueOf(totalAmount),
            status != null ? status : "PENDING",
            orderDate != null ? orderDate : "",
            deliveryAddress != null ? deliveryAddress.replace("|", " ") : "",
            getItemsSerialized()
        );
    }
}
