package com.bakery.service;

import com.bakery.dao.OrderFileDAO;
import com.bakery.model.Order;
import com.bakery.model.OrderItem;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

/**
 * Service Layer for standard product orders.
 */
public class OrderService {
    private final OrderFileDAO orderDAO;
    private final ProductService productService;

    public OrderService() {
        this.orderDAO = new OrderFileDAO();
        this.productService = new ProductService();
    }

    public Order placeOrder(String customerId, String customerName, String deliveryAddress, List<OrderItem> items) {
        if (items == null || items.isEmpty()) {
            throw new IllegalArgumentException("Cart cannot be empty.");
        }

        // Deduct inventory stock
        for (OrderItem item : items) {
            productService.deductStock(item.getProductId(), item.getQuantity());
        }

        String orderId = "ORD-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

        Order order = new Order(orderId, customerId, customerName, 0.0, "CONFIRMED", dateStr, deliveryAddress);
        for (OrderItem item : items) {
            order.addItem(item);
        }

        boolean saved = orderDAO.save(order);
        return saved ? order : null;
    }

    public Order getOrder(String orderId) {
        return orderDAO.findById(orderId);
    }

    public List<Order> getCustomerOrders(String customerId) {
        return orderDAO.findByCustomerId(customerId);
    }

    public List<Order> getAllOrders() {
        return orderDAO.getAll();
    }

    public boolean updateStatus(String orderId, String newStatus) {
        return orderDAO.updateStatus(orderId, newStatus);
    }

    public boolean cancelOrder(String orderId) {
        Order o = getOrder(orderId);
        if (o != null && !"DELIVERED".equalsIgnoreCase(o.getStatus())) {
            o.setStatus("CANCELLED");
            return orderDAO.save(o);
        }
        return false;
    }
}
