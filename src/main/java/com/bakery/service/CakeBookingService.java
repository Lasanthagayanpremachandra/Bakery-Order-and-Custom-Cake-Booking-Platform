package com.bakery.service;

import com.bakery.dao.CakeBookingFileDAO;
import com.bakery.model.CakeBooking;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Service Layer for Custom Cake Bookings.
 * Implements ProductionSlotChecker abstraction to manage kitchen capacity.
 */
public class CakeBookingService extends ProductionSlotChecker {
    private static final int MAX_SLOTS_PER_DAY = 5;
    private final CakeBookingFileDAO bookingDAO;

    public CakeBookingService() {
        this.bookingDAO = new CakeBookingFileDAO();
    }

    /**
     * Concrete implementation of the abstract method from ProductionSlotChecker.
     * Enforces slot limits per date.
     */
    @Override
    public boolean checkSlotAvailability(String requiredDate, int cakeTiers) {
        if (requiredDate == null || requiredDate.trim().isEmpty()) return false;
        int usedSlots = 0;
        List<CakeBooking> all = bookingDAO.getAll();
        for (CakeBooking b : all) {
            if (requiredDate.equals(b.getRequiredDate()) && !"CANCELLED".equalsIgnoreCase(b.getStatus())) {
                usedSlots += (b.getTiers() > 1 ? 2 : 1);
            }
        }
        int needed = cakeTiers > 1 ? 2 : 1;
        return (usedSlots + needed) <= MAX_SLOTS_PER_DAY;
    }

    @Override
    public int getRemainingSlots(String requiredDate) {
        if (requiredDate == null) return MAX_SLOTS_PER_DAY;
        int usedSlots = 0;
        for (CakeBooking b : bookingDAO.getAll()) {
            if (requiredDate.equals(b.getRequiredDate()) && !"CANCELLED".equalsIgnoreCase(b.getStatus())) {
                usedSlots += (b.getTiers() > 1 ? 2 : 1);
            }
        }
        return Math.max(0, MAX_SLOTS_PER_DAY - usedSlots);
    }

    public CakeBooking createBooking(String customerId, String customerName, String flavour, 
                                     String size, int tiers, String design, String occasion, 
                                     String requiredDate, String customMessage) {
        if (!checkSlotAvailability(requiredDate, tiers)) {
            throw new IllegalStateException("Kitchen capacity full for " + requiredDate + ". Please choose another date.");
        }

        String bookingId = "CAKE-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        CakeBooking booking = new CakeBooking(bookingId, customerId, customerName, flavour, size, tiers, design, occasion, requiredDate, "CONFIRMED");
        booking.setCustomMessage(customMessage);
        booking.calculateOrderTotal(); // Polymorphic price calculation

        boolean saved = bookingDAO.save(booking);
        return saved ? booking : null;
    }

    public List<CakeBooking> getActiveBookings() {
        List<CakeBooking> active = new ArrayList<>();
        for (CakeBooking b : bookingDAO.getAll()) {
            if (!"DELIVERED".equalsIgnoreCase(b.getStatus()) && !"CANCELLED".equalsIgnoreCase(b.getStatus())) {
                active.add(b);
            }
        }
        return active;
    }

    public List<CakeBooking> getAllBookings() {
        return bookingDAO.getAll();
    }

    public CakeBooking getBooking(String bookingId) {
        return bookingDAO.findById(bookingId);
    }

    public List<CakeBooking> getCustomerBookings(String customerId) {
        return bookingDAO.findByCustomerId(customerId);
    }

    public boolean updateStatus(String bookingId, String newStatus) {
        return bookingDAO.updateStatus(bookingId, newStatus);
    }

    public boolean cancelBooking(String bookingId) {
        CakeBooking b = getBooking(bookingId);
        if (b != null && !"DELIVERED".equalsIgnoreCase(b.getStatus())) {
            b.setStatus("CANCELLED");
            return bookingDAO.save(b);
        }
        return false;
    }

    public boolean assignBaker(String bookingId, String staffId) {
        return bookingDAO.assignBaker(bookingId, staffId);
    }

    public double calculatePrice(CakeBooking booking) {
        if (booking == null) return 0.0;
        return booking.calculateOrderTotal();
    }
}
