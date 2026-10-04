package com.bakery.model;

/**
 * Concrete implementation for Cash-on-Delivery or Cash-at-Counter payments.
 * Demonstrates Polymorphism implementing PaymentMethod.
 */
public class CashPayment implements PaymentMethod {
    private double tenderedAmount;
    private double changeDue;
    private String collectedBy;

    public CashPayment() {}

    public CashPayment(double tenderedAmount, double changeDue, String collectedBy) {
        this.tenderedAmount = tenderedAmount;
        this.changeDue = changeDue;
        this.collectedBy = collectedBy;
    }

    @Override
    public boolean processPayment(double amount, String reference) {
        // Cash payment is verified on pickup/delivery
        return true;
    }

    @Override
    public String getMethodName() {
        return "CASH";
    }

    @Override
    public String getTransactionDetails() {
        return "Cash on Hand / Counter Settlement. Collected by: " + (collectedBy != null ? collectedBy : "Bakery Staff");
    }

    public double getTenderedAmount() { return tenderedAmount; }
    public void setTenderedAmount(double tenderedAmount) { this.tenderedAmount = tenderedAmount; }

    public double getChangeDue() { return changeDue; }
    public void setChangeDue(double changeDue) { this.changeDue = changeDue; }

    public String getCollectedBy() { return collectedBy; }
    public void setCollectedBy(String collectedBy) { this.collectedBy = collectedBy; }
}
