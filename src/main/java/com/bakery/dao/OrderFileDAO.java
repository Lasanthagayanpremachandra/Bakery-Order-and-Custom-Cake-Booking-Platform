package com.bakery.dao;

import com.bakery.model.Order;
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
 * File I/O Data Access Object for Standard Bakery Orders.
 * Persists orders to orders.txt.
 */
public class OrderFileDAO {
    private static final String FILE_NAME = "orders.txt";

    private Path getFilePath() {
        return FileUtil.getDataFilePath(FILE_NAME);
    }

    public synchronized List<Order> getAll() {
        List<Order> list = new ArrayList<>();
        Path path = getFilePath();
        if (!Files.exists(path)) return list;

        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] p = line.split("\\|", -1);
                if (p.length >= 6) {
                    String orderId = p[0];
                    String customerId = p[1];
                    String customerName = p[2];
                    double total = Double.parseDouble(p[3]);
                    String status = p[4];
                    String orderDate = p[5];
                    String address = p.length >= 7 ? p[6] : "";
                    String itemsData = p.length >= 8 ? p[7] : "";

                    Order order = new Order(orderId, customerId, customerName, total, status, orderDate, address);
                    order.setItemsFromSerialized(itemsData);
                    list.add(order);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    public synchronized Order findById(String orderId) {
        if (orderId == null) return null;
        for (Order o : getAll()) {
            if (orderId.equalsIgnoreCase(o.getOrderId())) return o;
        }
        return null;
    }

    public synchronized List<Order> findByCustomerId(String customerId) {
        List<Order> result = new ArrayList<>();
        if (customerId == null) return result;
        for (Order o : getAll()) {
            if (customerId.equalsIgnoreCase(o.getCustomerId())) {
                result.add(o);
            }
        }
        return result;
    }

    public synchronized boolean save(Order order) {
        if (order == null) return false;
        List<Order> all = getAll();
        boolean exists = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getOrderId().equalsIgnoreCase(order.getOrderId())) {
                all.set(i, order);
                exists = true;
                break;
            }
        }
        if (!exists) {
            all.add(0, order); // add to top of list
        }
        return writeAll(all);
    }

    public synchronized boolean updateStatus(String orderId, String newStatus) {
        Order o = findById(orderId);
        if (o != null) {
            o.setStatus(newStatus);
            return save(o);
        }
        return false;
    }

    public synchronized boolean delete(String orderId) {
        if (orderId == null) return false;
        List<Order> all = getAll();
        boolean removed = all.removeIf(o -> o.getOrderId().equalsIgnoreCase(orderId));
        if (removed) {
            return writeAll(all);
        }
        return false;
    }

    private synchronized boolean writeAll(List<Order> list) {
        Path path = getFilePath();
        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
            for (Order o : list) {
                writer.write(o.toFileString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
