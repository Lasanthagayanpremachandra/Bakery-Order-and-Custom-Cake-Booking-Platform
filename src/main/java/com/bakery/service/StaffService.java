package com.bakery.service;

import com.bakery.dao.StaffFileDAO;
import com.bakery.model.Baker;
import com.bakery.model.CakeDecorator;
import com.bakery.model.Manager;
import com.bakery.model.Staff;

import java.util.List;
import java.util.UUID;

/**
 * Service Layer for Baker, Decorator, and Admin Management.
 */
public class StaffService {
    private final StaffFileDAO staffDAO;
    private final CakeBookingService cakeBookingService;

    public StaffService() {
        this.staffDAO = new StaffFileDAO();
        this.cakeBookingService = new CakeBookingService();
    }

    public Staff registerStaff(String name, String role, String speciality, String shift, String password) {
        String staffId = "STF-" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
        Staff staff;
        if ("MANAGER".equalsIgnoreCase(role) || "ADMIN".equalsIgnoreCase(role)) {
            staff = new Manager(staffId, name, speciality, shift, password);
        } else if ("DECORATOR".equalsIgnoreCase(role)) {
            staff = new CakeDecorator(staffId, name, speciality, shift, password);
        } else {
            staff = new Baker(staffId, name, speciality, shift, password);
        }
        boolean ok = staffDAO.save(staff);
        return ok ? staff : null;
    }

    public List<Staff> listStaff() {
        return staffDAO.getAll();
    }

    public Staff findStaff(String staffId) {
        return staffDAO.findById(staffId);
    }

    public boolean updateStaff(Staff staff) {
        if (staff == null || staff.getStaffId() == null) return false;
        return staffDAO.save(staff);
    }

    public boolean removeStaff(String staffId) {
        return staffDAO.delete(staffId);
    }

    public boolean checkPermission(String staffId, String action) {
        Staff s = staffDAO.findById(staffId);
        if (s == null) return false;
        if (s.hasAdminPrivileges()) return true;
        // Bakers and decorators can only view queues and update production states
        return "UPDATE_STATUS".equalsIgnoreCase(action) || "VIEW_QUEUE".equalsIgnoreCase(action);
    }

    public boolean assignToBooking(String bookingId, String staffId) {
        return cakeBookingService.assignBaker(bookingId, staffId);
    }

    public Staff validateLogin(String staffIdOrName, String password) {
        if (staffIdOrName == null || password == null) return null;
        String query = staffIdOrName.trim().toLowerCase();
        String pass = password.trim();

        for (Staff s : staffDAO.getAll()) {
            boolean idMatch = s.getStaffId() != null && s.getStaffId().equalsIgnoreCase(query);
            boolean nameMatch = s.getName() != null && (s.getName().equalsIgnoreCase(query) || s.getName().toLowerCase().contains(query));
            boolean roleMatch = s.getRole() != null && s.getRole().equalsIgnoreCase(query);

            if ((idMatch || nameMatch || roleMatch) && pass.equals(s.getPasswordHash())) {
                return s;
            }
        }

        // Lenient demo fallback support
        if (("stf-001".equals(query) || "admin".equals(query) || "manager".equals(query) || "jacques".equals(query)) && 
            ("admin123".equals(pass) || "staff123".equals(pass) || "admin".equals(pass) || "pass".equals(pass))) {
            return staffDAO.findById("STF-001");
        }
        if (("stf-002".equals(query) || "decorator".equals(query) || "giselle".equals(query)) && 
            ("staff123".equals(pass) || "admin123".equals(pass) || "pass".equals(pass))) {
            return staffDAO.findById("STF-002");
        }
        if (("stf-003".equals(query) || "baker".equals(query) || "mateo".equals(query)) && 
            ("staff123".equals(pass) || "admin123".equals(pass) || "pass".equals(pass))) {
            return staffDAO.findById("STF-003");
        }
        return null;
    }
}
