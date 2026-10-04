package com.bakery.model;

/**
 * Payment model representing recorded transactions and invoices.
 * Encapsulates financial and payment status information.
 */
public class Payment {
    private String paymentId;
    private String orderOrBookingId;
    private double amount;
    private String method; // CASH, CARD, ONLINE
    private String status; // PAID, DEPOSIT_PAID, PENDING, REFUNDED
    private String paymentDate;
    private String details;

    public Payment() {
        this.status = "PENDING";
    }

    public Payment(String paymentId, String orderOrBookingId, double amount, String method, String status, String paymentDate, String details) {
        this.paymentId = paymentId;
        this.orderOrBookingId = orderOrBookingId;
        this.amount = amount;
        this.method = method;
        this.status = status;
        this.paymentDate = paymentDate;
        this.details = details;
    }

    public String getPaymentId() { return paymentId; }
    public void setPaymentId(String paymentId) { this.paymentId = paymentId; }

    public String getOrderOrBookingId() { return orderOrBookingId; }
    public void setOrderOrBookingId(String orderOrBookingId) { this.orderOrBookingId = orderOrBookingId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentDate() { return paymentDate; }
    public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    // File format: paymentId|orderOrBookingId|amount|method|status|paymentDate|details
    public String toFileString() {
        return String.join("|",
            paymentId != null ? paymentId : "",
            orderOrBookingId != null ? orderOrBookingId : "",
            String.valueOf(amount),
            method != null ? method : "CASH",
            status != null ? status : "PENDING",
            paymentDate != null ? paymentDate : "",
            details != null ? details.replace("|", " ") : ""
        );
    }
}
