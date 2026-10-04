package com.bakery.model;

/**
 * Manager / Administrator staff member.
 * Demonstrates Abstraction by fulfilling admin-level privileges.
 */
public class Manager extends Staff {

    public Manager() {
        super();
        setRole("MANAGER");
    }

    public Manager(String staffId, String name, String speciality, String shift, String passwordHash) {
        super(staffId, name, "MANAGER", speciality, shift, passwordHash);
    }

    @Override
    public boolean hasAdminPrivileges() {
        return true;
    }

    @Override
    public String getRoleTitle() {
        return "Bakery Manager & Administrator";
    }
}
