package com.bakery.dao;

import com.bakery.model.CakeBooking;
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
 * File I/O Data Access Object for Custom Cake Bookings.
 * Persists bookings to cake_bookings.txt with status tracking.
 */
public class CakeBookingFileDAO {
    private static final String FILE_NAME = "cake_bookings.txt";

    private Path getFilePath() {
        return FileUtil.getDataFilePath(FILE_NAME);
    }

    public synchronized List<CakeBooking> getAll() {
        List<CakeBooking> list = new ArrayList<>();
        Path path = getFilePath();
        if (!Files.exists(path)) return list;

        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] p = line.split("\\|", -1);
                if (p.length >= 10) {
                    String bId = p[0];
                    String cId = p[1];
                    String cName = p[2];
                    String flavour = p[3];
                    String size = p[4];
                    int tiers = 1;
                    try { tiers = Integer.parseInt(p[5]); } catch (Exception ignored) {}
                    String design = p[6];
                    String occasion = p[7];
                    String date = p[8];
                    String status = p[9];

                    CakeBooking booking = new CakeBooking(bId, cId, cName, flavour, size, tiers, design, occasion, date, status);
                    if (p.length >= 11 && !p[10].isEmpty()) {
                        try { booking.setTotalAmount(Double.parseDouble(p[10])); } catch (Exception ignored) {}
                    }
                    if (p.length >= 12) {
                        booking.setAssignedBakerId(p[11]);
                    }
                    if (p.length >= 13) {
                        booking.setCustomMessage(p[12]);
                    }
                    list.add(booking);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    public synchronized CakeBooking findById(String bookingId) {
        if (bookingId == null) return null;
        for (CakeBooking b : getAll()) {
            if (bookingId.equalsIgnoreCase(b.getBookingId())) return b;
        }
        return null;
    }

    public synchronized List<CakeBooking> findByCustomerId(String customerId) {
        List<CakeBooking> result = new ArrayList<>();
        if (customerId == null) return result;
        for (CakeBooking b : getAll()) {
            if (customerId.equalsIgnoreCase(b.getCustomerId())) {
                result.add(b);
            }
        }
        return result;
    }

    public synchronized boolean save(CakeBooking booking) {
        if (booking == null) return false;
        List<CakeBooking> all = getAll();
        boolean exists = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getBookingId().equalsIgnoreCase(booking.getBookingId())) {
                all.set(i, booking);
                exists = true;
                break;
            }
        }
        if (!exists) {
            all.add(0, booking); // top of list
        }
        return writeAll(all);
    }

    public synchronized boolean updateStatus(String bookingId, String newStatus) {
        CakeBooking b = findById(bookingId);
        if (b != null) {
            b.setStatus(newStatus);
            return save(b);
        }
        return false;
    }

    public synchronized boolean assignBaker(String bookingId, String staffId) {
        CakeBooking b = findById(bookingId);
        if (b != null) {
            b.setAssignedBakerId(staffId);
            return save(b);
        }
        return false;
    }

    public synchronized boolean delete(String bookingId) {
        if (bookingId == null) return false;
        List<CakeBooking> all = getAll();
        boolean removed = all.removeIf(b -> b.getBookingId().equalsIgnoreCase(bookingId));
        if (removed) {
            return writeAll(all);
        }
        return false;
    }

    private synchronized boolean writeAll(List<CakeBooking> list) {
        Path path = getFilePath();
        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
            for (CakeBooking b : list) {
                writer.write(b.toBookingFileString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
