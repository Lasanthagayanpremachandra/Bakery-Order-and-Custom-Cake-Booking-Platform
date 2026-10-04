package com.bakery.dao;

import com.bakery.model.Customer;
import com.bakery.model.PremiumCustomer;
import com.bakery.model.RegularCustomer;
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
 * File I/O Data Access Object for Customer Management.
 * Uses BufferedReader and BufferedWriter with customers.txt.
 */
public class CustomerFileDAO {
    private static final String FILE_NAME = "customers.txt";

    private Path getFilePath() {
        return FileUtil.getDataFilePath(FILE_NAME);
    }

    public synchronized List<Customer> getAll() {
        List<Customer> list = new ArrayList<>();
        Path path = getFilePath();
        if (!Files.exists(path)) return list;

        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] p = line.split("\\|", -1);
                if (p.length >= 7) {
                    String id = p[0];
                    String name = p[1];
                    String phone = p[2];
                    String address = p[3];
                    String email = p[4];
                    String passwordHash = p[5];
                    String type = p[6];

                    Customer c;
                    if ("PREMIUM".equalsIgnoreCase(type)) {
                        c = new PremiumCustomer(id, name, phone, address, email, passwordHash);
                    } else {
                        c = new RegularCustomer(id, name, phone, address, email, passwordHash);
                    }
                    list.add(c);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    public synchronized Customer findById(String id) {
        if (id == null) return null;
        for (Customer c : getAll()) {
            if (id.equalsIgnoreCase(c.getId())) return c;
        }
        return null;
    }

    public synchronized Customer findByEmail(String email) {
        if (email == null) return null;
        for (Customer c : getAll()) {
            if (email.equalsIgnoreCase(c.getEmail())) return c;
        }
        return null;
    }

    public synchronized Customer findByPhone(String phone) {
        if (phone == null) return null;
        for (Customer c : getAll()) {
            if (phone.equals(c.getPhone())) return c;
        }
        return null;
    }

    public synchronized boolean save(Customer customer) {
        if (customer == null) return false;
        List<Customer> all = getAll();
        boolean exists = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getId().equalsIgnoreCase(customer.getId())) {
                all.set(i, customer);
                exists = true;
                break;
            }
        }
        if (!exists) {
            all.add(customer);
        }
        return writeAll(all);
    }

    public synchronized boolean delete(String id) {
        if (id == null) return false;
        List<Customer> all = getAll();
        boolean removed = all.removeIf(c -> c.getId().equalsIgnoreCase(id));
        if (removed) {
            return writeAll(all);
        }
        return false;
    }

    private synchronized boolean writeAll(List<Customer> list) {
        Path path = getFilePath();
        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
            for (Customer c : list) {
                writer.write(c.toFileString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
