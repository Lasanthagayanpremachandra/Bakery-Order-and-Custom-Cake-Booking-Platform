package com.bakery.service;

/**
 * Abstraction for checking bakery production slot and baker availability
 * before custom cake bookings are confirmed.
 */
public abstract class ProductionSlotChecker {

    /**
     * Abstract method to check availability for a given date and production load.
     * Concrete implementations verify max daily capacity and baker shifts.
     */
    public abstract boolean checkSlotAvailability(String requiredDate, int cakeTiers);

    public abstract int getRemainingSlots(String requiredDate);
}
