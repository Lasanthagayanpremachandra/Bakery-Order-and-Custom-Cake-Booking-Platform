package com.bakery.model;

/**
 * Represents a Regular Customer.
 * Applies standard baseline discount (no discount or 2% for orders over $50).
 */
public class RegularCustomer extends Customer {

    public RegularCustomer() {
        super();
        setType("REGULAR");
    }

    public RegularCustomer(String id, String name, String phone, String address, String email, String passwordHash) {
        super(id, name, phone, address, email, passwordHash, "REGULAR");
    }

    @Override
    public double calculateLoyaltyDiscount(double orderTotal) {
        if (orderTotal >= 60.0) {
            return orderTotal * 0.05; // 5% discount for orders >= $60
        }
        return 0.0;
    }

    @Override
    public String getMembershipBadge() {
        return "Regular Member";
    }
}
