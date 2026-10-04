package com.bakery.model;

/**
 * Base abstract class representing a Customer in the Bakery platform.
 * Demonstrates Encapsulation (private fields with accessors) and Abstraction.
 */
public abstract class Customer {
    private String id;
    private String name;
    private String phone;
    private String address;
    private String email;
    private String passwordHash;
    private String type; // REGULAR or PREMIUM

    public Customer() {}

    public Customer(String id, String name, String phone, String address, String email, String passwordHash, String type) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.address = address;
        this.email = email;
        this.passwordHash = passwordHash;
        this.type = type;
    }

    // Abstract method demonstrating Polymorphism in subclasses
    public abstract double calculateLoyaltyDiscount(double orderTotal);

    public abstract String getMembershipBadge();

    // Getters and Setters (Encapsulation)
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    // Serialization helper for flat-file persistence
    public String toFileString() {
        return String.join("|", 
            id != null ? id : "",
            name != null ? name : "",
            phone != null ? phone : "",
            address != null ? address : "",
            email != null ? email : "",
            passwordHash != null ? passwordHash : "",
            type != null ? type : "REGULAR"
        );
    }
}
