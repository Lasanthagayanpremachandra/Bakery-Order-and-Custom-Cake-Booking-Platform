package com.bakery.model;

/**
 * Cake Decorator staff member responsible for icing, fondant, and finishing touches.
 */
public class CakeDecorator extends Staff {

    public CakeDecorator() {
        super();
        setRole("DECORATOR");
    }

    public CakeDecorator(String staffId, String name, String speciality, String shift, String passwordHash) {
        super(staffId, name, "DECORATOR", speciality, shift, passwordHash);
    }

    @Override
    public boolean hasAdminPrivileges() {
        return false;
    }

    @Override
    public String getRoleTitle() {
        return "Cake Decorator (" + getSpeciality() + ")";
    }
}
