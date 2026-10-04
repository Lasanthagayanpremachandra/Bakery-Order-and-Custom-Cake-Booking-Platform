package com.bakery.model;

/**
 * Baker staff member responsible for baking sponges, breads, and oven management.
 */
public class Baker extends Staff {

    public Baker() {
        super();
        setRole("BAKER");
    }

    public Baker(String staffId, String name, String speciality, String shift, String passwordHash) {
        super(staffId, name, "BAKER", speciality, shift, passwordHash);
    }

    @Override
    public boolean hasAdminPrivileges() {
        return false;
    }

    @Override
    public String getRoleTitle() {
        return "Master Baker (" + getSpeciality() + ")";
    }
}
