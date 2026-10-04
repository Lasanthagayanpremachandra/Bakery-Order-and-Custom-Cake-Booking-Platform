package com.bakery.model;

/**
 * Base abstract class representing bakery staff members.
 * Demonstrates Encapsulation and Abstraction for administrative vs regular operations.
 */
public abstract class Staff {
    private String staffId;
    private String name;
    private String role; // BAKER, DECORATOR, MANAGER
    private String speciality;
    private String shift; // MORNING, AFTERNOON, EVENING
    private String passwordHash;

    public Staff() {}

    public Staff(String staffId, String name, String role, String speciality, String shift, String passwordHash) {
        this.staffId = staffId;
        this.name = name;
        this.role = role;
        this.speciality = speciality;
        this.shift = shift;
        this.passwordHash = passwordHash;
    }

    // Abstraction: Permissions abstracted away from regular staff
    public abstract boolean hasAdminPrivileges();
    public abstract String getRoleTitle();

    public String getStaffId() { return staffId; }
    public void setStaffId(String staffId) { this.staffId = staffId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getSpeciality() { return speciality; }
    public void setSpeciality(String speciality) { this.speciality = speciality; }

    public String getShift() { return shift; }
    public void setShift(String shift) { this.shift = shift; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    // File format: staffId|name|role|speciality|shift|passwordHash
    public String toFileString() {
        return String.join("|",
            staffId != null ? staffId : "",
            name != null ? name.replace("|", " ") : "",
            role != null ? role : "STAFF",
            speciality != null ? speciality.replace("|", " ") : "General",
            shift != null ? shift : "MORNING",
            passwordHash != null ? passwordHash : ""
        );
    }
}
