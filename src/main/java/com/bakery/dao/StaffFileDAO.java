package com.bakery.dao;

import com.bakery.model.Baker;
import com.bakery.model.CakeDecorator;
import com.bakery.model.Manager;
import com.bakery.model.Staff;
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
 * File I/O Data Access Object for Staff Management.
 * Manages staff.txt supporting Baker, Decorator, and Manager roles.
 */
public class StaffFileDAO {
    private static final String FILE_NAME = "staff.txt";

    private Path getFilePath() {
        return FileUtil.getDataFilePath(FILE_NAME);
    }

    public synchronized List<Staff> getAll() {
        List<Staff> list = new ArrayList<>();
        Path path = getFilePath();
        if (!Files.exists(path)) return list;

        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] p = line.split("\\|", -1);
                if (p.length >= 5) {
                    String id = p[0];
                    String name = p[1];
                    String role = p[2].toUpperCase();
                    String spec = p[3];
                    String shift = p[4];
                    String pass = p.length >= 6 ? p[5] : "";

                    Staff s;
                    if ("MANAGER".equals(role) || "ADMIN".equals(role)) {
                        s = new Manager(id, name, spec, shift, pass);
                    } else if ("DECORATOR".equals(role)) {
                        s = new CakeDecorator(id, name, spec, shift, pass);
                    } else {
                        s = new Baker(id, name, spec, shift, pass);
                    }
                    list.add(s);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    public synchronized Staff findById(String staffId) {
        if (staffId == null) return null;
        for (Staff s : getAll()) {
            if (staffId.equalsIgnoreCase(s.getStaffId())) return s;
        }
        return null;
    }

    public synchronized boolean save(Staff staff) {
        if (staff == null) return false;
        List<Staff> all = getAll();
        boolean exists = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getStaffId().equalsIgnoreCase(staff.getStaffId())) {
                all.set(i, staff);
                exists = true;
                break;
            }
        }
        if (!exists) {
            all.add(staff);
        }
        return writeAll(all);
    }

    public synchronized boolean delete(String staffId) {
        if (staffId == null) return false;
        List<Staff> all = getAll();
        boolean removed = all.removeIf(s -> s.getStaffId().equalsIgnoreCase(staffId));
        if (removed) {
            return writeAll(all);
        }
        return false;
    }

    private synchronized boolean writeAll(List<Staff> list) {
        Path path = getFilePath();
        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
            for (Staff s : list) {
                writer.write(s.toFileString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
