package com.bakery.service;

import com.bakery.dao.PaymentFileDAO;
import com.bakery.model.CardPayment;
import com.bakery.model.CashPayment;
import com.bakery.model.Payment;
import com.bakery.model.PaymentMethod;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

/**
 * Service Layer for Payment & Billing Management.
 */
public class PaymentService {
    private final PaymentFileDAO paymentDAO;

    public PaymentService() {
        this.paymentDAO = new PaymentFileDAO();
    }

    public Payment generateInvoice(String refId, double amount, String methodType, boolean isDeposit) {
        return processPayment(refId, amount, methodType, isDeposit, null, null);
    }

    public Payment processPayment(String refId, double amount, String methodType, boolean isDeposit, String cardNumber, String cardHolder) {
        String pId = "INV-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

        PaymentMethod methodObj;
        if ("CARD".equalsIgnoreCase(methodType)) {
            String last4 = "8821";
            if (cardNumber != null) {
                String clean = cardNumber.replaceAll("[^0-9]", "");
                if (clean.length() >= 4) {
                    last4 = clean.substring(clean.length() - 4);
                }
            }
            methodObj = new CardPayment(last4, cardHolder != null && !cardHolder.trim().isEmpty() ? cardHolder.trim() : "Valued Patron");
        } else {
            methodObj = new CashPayment(amount, 0.0, "Sweetora Hedeniya Cashier");
        }

        String status = isDeposit ? "DEPOSIT_PAID" : ("CARD".equalsIgnoreCase(methodType) ? "PAID" : "PENDING_CASH");
        String details = methodObj.getTransactionDetails() + (isDeposit ? " (Advance 30% Kitchen Deposit)" : " (Full Order Settlement)");

        Payment payment = new Payment(pId, refId, amount, methodObj.getMethodName(), status, dateStr, details);
        boolean ok = paymentDAO.save(payment);
        return ok ? payment : null;
    }

    public boolean updatePayment(Payment payment) {
        if (payment == null) return false;
        return paymentDAO.save(payment);
    }

    public List<Payment> getHistory(String refId) {
        return paymentDAO.findByOrderOrBookingId(refId);
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.getAll();
    }

    public Payment getPayment(String paymentId) {
        return paymentDAO.findById(paymentId);
    }

    public boolean updateStatus(String paymentId, String status) {
        Payment p = paymentDAO.findById(paymentId);
        if (p != null) {
            p.setStatus(status);
            return paymentDAO.save(p);
        }
        return false;
    }

    public boolean voidPayment(String paymentId) {
        Payment p = paymentDAO.findById(paymentId);
        if (p != null) {
            p.setStatus("VOIDED");
            return paymentDAO.save(p);
        }
        return false;
    }

    public double applyDiscount(double amount, double discountPercent) {
        if (discountPercent <= 0) return amount;
        double discount = (amount * discountPercent) / 100.0;
        return Math.max(0.0, amount - discount);
    }

    public Payment recordDeposit(String bookingId, double depositAmount, String method) {
        return generateInvoice(bookingId, depositAmount, method, true);
    }
}
