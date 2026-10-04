package com.bakery.model;

/**
 * Concrete implementation for Credit / Debit Card & Online Payments.
 * Demonstrates Polymorphism implementing PaymentMethod.
 */
public class CardPayment implements PaymentMethod {
    private String cardNumberMasked;
    private String cardHolderName;
    private String transactionRef;

    public CardPayment() {}

    public CardPayment(String cardNumber, String cardHolderName) {
        this.cardHolderName = cardHolderName;
        if (cardNumber != null && cardNumber.length() >= 4) {
            this.cardNumberMasked = "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
        } else {
            this.cardNumberMasked = "**** **** **** 8823";
        }
        this.transactionRef = "TXN-" + System.currentTimeMillis();
    }

    @Override
    public boolean processPayment(double amount, String reference) {
        // Simulate immediate card verification & authorization
        return amount > 0;
    }

    @Override
    public String getMethodName() {
        return "CARD";
    }

    @Override
    public String getTransactionDetails() {
        return "Card Payment (" + (cardNumberMasked != null ? cardNumberMasked : "Masked") + ") Auth: " + transactionRef;
    }

    public String getCardNumberMasked() { return cardNumberMasked; }
    public void setCardNumberMasked(String cardNumberMasked) { this.cardNumberMasked = cardNumberMasked; }

    public String getCardHolderName() { return cardHolderName; }
    public void setCardHolderName(String cardHolderName) { this.cardHolderName = cardHolderName; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }
}
