package com.bakery.model;

/**
 * Represents a Premium Loyalty Customer.
 * Receives guaranteed 12% discount on all bakery products and custom cake orders.
 */
public class PremiumCustomer extends Customer {

    public PremiumCustomer() {
        super();
        setType("PREMIUM");
    }

    public PremiumCustomer(String id, String name, String phone, String address, String email, String passwordHash) {
        super(id, name, phone, address, email, passwordHash, "PREMIUM");
    }

    @Override
    public double calculateLoyaltyDiscount(double orderTotal) {
        return orderTotal * 0.12; // 12% loyalty discount
    }

    @Override
    public String getMembershipBadge() {
        return "Gold VIP Member (12% OFF)";
    }
}
