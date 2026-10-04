package com.bakery.model;

/**
 * Custom Cake Booking model that extends Order.
 * Demonstrates Inheritance and Polymorphic pricing (size/tier/design-based pricing).
 */
public class CakeBooking extends Order {
    private String bookingId;
    private String flavour;
    private String size; // 1kg, 2kg, 3kg, 5kg
    private int tiers;   // 1, 2, 3
    private String design; // e.g. Vintage Floral, Fondant Art, Modern Minimalist, Chocolate Drip
    private String occasion; // Birthday, Wedding, Anniversary, Baby Shower, Other
    private String requiredDate;
    private String assignedBakerId;
    private String customMessage;

    public CakeBooking() {
        super();
        setStatus("CONFIRMED");
    }

    public CakeBooking(String bookingId, String customerId, String customerName, String flavour, String size, 
                       int tiers, String design, String occasion, String requiredDate, String status) {
        super(bookingId, customerId, customerName, 0.0, status, requiredDate, "Custom Pickup/Delivery");
        this.bookingId = bookingId;
        this.flavour = flavour;
        this.size = size;
        this.tiers = tiers;
        this.design = design;
        this.occasion = occasion;
        this.requiredDate = requiredDate;
        calculateOrderTotal(); // Compute price automatically
    }

    /**
     * Polymorphic custom cake price calculation:
     * Base price + Flavor premium + Size multiplier + Tier surcharge + Design intricacy
     */
    @Override
    public double calculateOrderTotal() {
        double base = 35.0; // Base artisan cake fee

        // Size tier calculation
        if ("2kg".equalsIgnoreCase(size)) base += 25.0;
        else if ("3kg".equalsIgnoreCase(size)) base += 50.0;
        else if ("5kg".equalsIgnoreCase(size)) base += 95.0;

        // Tier multiplier
        if (tiers == 2) base += 30.0;
        else if (tiers >= 3) base += 65.0;

        // Flavour pricing
        if (flavour != null) {
            String f = flavour.toLowerCase();
            if (f.contains("belgian") || f.contains("truffle") || f.contains("red velvet")) base += 15.0;
            else if (f.contains("matcha") || f.contains("pistachio")) base += 18.0;
            else if (f.contains("black forest") || f.contains("caramel")) base += 10.0;
        }

        // Design intricacy pricing
        if (design != null) {
            String d = design.toLowerCase();
            if (d.contains("fondant") || d.contains("sculpted")) base += 40.0;
            else if (d.contains("floral") || d.contains("sugar flower")) base += 30.0;
            else if (d.contains("gold leaf") || d.contains("vintage")) base += 25.0;
            else if (d.contains("drip") || d.contains("piped")) base += 15.0;
        }

        setTotalAmount(base);
        return base;
    }

    // Required 30% deposit calculation
    public double getRequiredDeposit() {
        return Math.round(getTotalAmount() * 0.30 * 100.0) / 100.0;
    }

    public String getBookingId() { return bookingId != null ? bookingId : getOrderId(); }
    public void setBookingId(String bookingId) { 
        this.bookingId = bookingId;
        setOrderId(bookingId);
    }

    public String getFlavour() { return flavour; }
    public void setFlavour(String flavour) { this.flavour = flavour; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public int getTiers() { return tiers; }
    public void setTiers(int tiers) { this.tiers = tiers; }

    public String getDesign() { return design; }
    public void setDesign(String design) { this.design = design; }

    public String getOccasion() { return occasion; }
    public void setOccasion(String occasion) { this.occasion = occasion; }

    public String getRequiredDate() { return requiredDate; }
    public void setRequiredDate(String requiredDate) { this.requiredDate = requiredDate; }

    public String getAssignedBakerId() { return assignedBakerId; }
    public void setAssignedBakerId(String assignedBakerId) { this.assignedBakerId = assignedBakerId; }

    public String getCustomMessage() { return customMessage; }
    public void setCustomMessage(String customMessage) { this.customMessage = customMessage; }

    // Serialization format: bookingId|customerId|customerName|flavour|size|tiers|design|occasion|requiredDate|status|totalAmount|assignedBakerId|customMessage
    public String toBookingFileString() {
        return String.join("|",
            getBookingId() != null ? getBookingId() : "",
            getCustomerId() != null ? getCustomerId() : "",
            getCustomerName() != null ? getCustomerName().replace("|", " ") : "",
            flavour != null ? flavour.replace("|", " ") : "",
            size != null ? size : "1kg",
            String.valueOf(tiers),
            design != null ? design.replace("|", " ") : "",
            occasion != null ? occasion.replace("|", " ") : "",
            requiredDate != null ? requiredDate : "",
            getStatus() != null ? getStatus() : "CONFIRMED",
            String.valueOf(getTotalAmount()),
            assignedBakerId != null ? assignedBakerId : "UNASSIGNED",
            customMessage != null ? customMessage.replace("|", " ") : ""
        );
    }
}
