package com.bakery.dao;

import com.bakery.model.Payment;
import com.bakery.util.FileUtil;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * File I/O Data Access Object for Payment & Billing Management.
 * Manages payments.txt recording invoices, cash/card transactions, and deposits.
 */
public class PaymentFileDAO {
    private static final String FILE_NAME = "payments.txt";

    private Path getFilePath() {
        return FileUtil.getDataFilePath(FILE_NAME);
    }

    public synchronized List<Payment> getAll() {
        List<Payment> list = new ArrayList<>();
        Path path = getFilePath();
        if (!Files.exists(path)) return list;

        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] p = line.split("\\|", -1);
                if (p.length >= 5) {
                    String pId = p[0];
                    String refId = p[1];
                    double amt = Double.parseDouble(p[2]);
                    String method = p[3];
                    String status = p[4];
                    String date = p.length >= 6 ? p[5] : "";
                    String details = p.length >= 7 ? p[6] : "";

                    Payment payment = new Payment(pId, refId, amt, method, status, date, details);
                    list.add(payment);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    public synchronized Payment findById(String paymentId) {
        if (paymentId == null) return null;
        for (Payment p : getAll()) {
            if (paymentId.equalsIgnoreCase(p.getPaymentId())) return p;
        }
        return null;
    }

    public synchronized List<Payment> findByOrderOrBookingId(String refId) {
        List<Payment> list = new ArrayList<>();
        if (refId == null) return list;
        for (Payment p : getAll()) {
            if (refId.equalsIgnoreCase(p.getOrderOrBookingId())) {
                list.add(p);
            }
        }
        return list;
    }

    public synchronized boolean save(Payment payment) {
        if (payment == null) return false;
        List<Payment> all = getAll();
        boolean exists = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getPaymentId().equalsIgnoreCase(payment.getPaymentId())) {
                all.set(i, payment);
                exists = true;
                break;
            }
        }
        if (!exists) {
            all.add(0, payment);
        }
        return writeAll(all);
    }

    public synchronized boolean delete(String paymentId) {
        if (paymentId == null) return false;
        List<Payment> all = getAll();
        boolean removed = all.removeIf(p -> p.getPaymentId().equalsIgnoreCase(paymentId));
        if (removed) {
            return writeAll(all);
        }
        return false;
    }

    private synchronized boolean writeAll(List<Payment> list) {
        Path path = getFilePath();
        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
            for (Payment p : list) {
                writer.write(p.toFileString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
