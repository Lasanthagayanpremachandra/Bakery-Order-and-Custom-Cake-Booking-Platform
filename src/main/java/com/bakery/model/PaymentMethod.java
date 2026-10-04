package com.bakery.model;

/**
 * Abstraction for payment processing methods.
 * Hides processing intricacies behind a unified interface.
 */
public interface PaymentMethod {
    boolean processPayment(double amount, String reference);
    String getMethodName();
    String getTransactionDetails();
}
