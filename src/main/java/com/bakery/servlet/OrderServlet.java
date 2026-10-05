package com.bakery.servlet;

import com.bakery.model.CakeBooking;
import com.bakery.model.Customer;
import com.bakery.model.Order;
import com.bakery.model.OrderItem;
import com.bakery.model.Product;
import com.bakery.service.CakeBookingService;
import com.bakery.service.OrderService;
import com.bakery.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller Servlet for Standard Bakery Orders and Cart.
 * Routes /order/cart, /order/add-cart, /order/place, /order/track, /order/update, /order/cancel
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order/*", "/cart", "/track"})
public class OrderServlet extends HttpServlet {
    private OrderService orderService;
    private ProductService productService;
    private CakeBookingService cakeBookingService;

    @Override
    public void init() {
        orderService = new OrderService();
        productService = new ProductService();
        cakeBookingService = new CakeBookingService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        String servletPath = req.getServletPath();

        // Support root /track and /cart shortcuts
        if ("/track".equalsIgnoreCase(servletPath)) {
            path = "/track";
        } else if ("/cart".equalsIgnoreCase(servletPath)) {
            path = "/cart";
        }

        if (path == null) path = "/cart";

        switch (path) {
            case "/cart": {
                req.getRequestDispatcher("/cart.jsp").forward(req, resp);
                break;
            }
            case "/add-cart": {
                String pId = req.getParameter("productId");
                int qty = 1;
                try { qty = Integer.parseInt(req.getParameter("quantity")); } catch (Exception ignored) {}

                Product p = productService.getProduct(pId);
                if (p != null) {
                    HttpSession session = req.getSession();
                    List<OrderItem> cart = getCartFromSession(session);
                    boolean found = false;
                    for (OrderItem item : cart) {
                        if (item.getProductId().equalsIgnoreCase(pId)) {
                            item.setQuantity(item.getQuantity() + qty);
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        cart.add(new OrderItem(p.getProductId(), p.getName(), qty, p.getPrice()));
                    }
                    session.setAttribute("cart", cart);
                }
                resp.sendRedirect(req.getContextPath() + "/order/cart?msg=added");
                break;
            }
            case "/remove-cart": {
                String pId = req.getParameter("productId");
                HttpSession session = req.getSession();
                List<OrderItem> cart = getCartFromSession(session);
                cart.removeIf(item -> item.getProductId().equalsIgnoreCase(pId));
                session.setAttribute("cart", cart);
                resp.sendRedirect(req.getContextPath() + "/order/cart?msg=removed");
                break;
            }
            case "/track": {
                HttpSession session = req.getSession();
                Customer current = (Customer) session.getAttribute("currentUser");
                String q = req.getParameter("q");

                List<Order> orders = new ArrayList<>();
                List<CakeBooking> bookings = new ArrayList<>();

                if (q != null && !q.trim().isEmpty()) {
                    String query = q.trim();
                    String lowerQ = query.toLowerCase();

                    // 1. Direct ID lookups
                    Order singleOrder = orderService.getOrder(query);
                    if (singleOrder != null) {
                        orders.add(singleOrder);
                    }
                    CakeBooking singleBooking = cakeBookingService.getBooking(query);
                    if (singleBooking != null) {
                        bookings.add(singleBooking);
                    }

                    // 2. Comprehensive search across orders
                    for (Order o : orderService.getAllOrders()) {
                        if (!orders.contains(o)) {
                            boolean idMatch = o.getOrderId() != null && o.getOrderId().toLowerCase().contains(lowerQ);
                            boolean nameMatch = o.getCustomerName() != null && o.getCustomerName().toLowerCase().contains(lowerQ);
                            boolean custIdMatch = o.getCustomerId() != null && o.getCustomerId().toLowerCase().contains(lowerQ);
                            boolean addrMatch = o.getDeliveryAddress() != null && o.getDeliveryAddress().toLowerCase().contains(lowerQ);
                            if (idMatch || nameMatch || custIdMatch || addrMatch) {
                                orders.add(o);
                            }
                        }
                    }

                    // 3. Comprehensive search across cake bookings
                    for (CakeBooking b : cakeBookingService.getAllBookings()) {
                        if (!bookings.contains(b)) {
                            boolean idMatch = b.getBookingId() != null && b.getBookingId().toLowerCase().contains(lowerQ);
                            boolean nameMatch = b.getCustomerName() != null && b.getCustomerName().toLowerCase().contains(lowerQ);
                            boolean custIdMatch = b.getCustomerId() != null && b.getCustomerId().toLowerCase().contains(lowerQ);
                            boolean flavMatch = b.getFlavour() != null && b.getFlavour().toLowerCase().contains(lowerQ);
                            boolean occMatch = b.getOccasion() != null && b.getOccasion().toLowerCase().contains(lowerQ);
                            if (idMatch || nameMatch || custIdMatch || flavMatch || occMatch) {
                                bookings.add(b);
                            }
                        }
                    }
                } else if (current != null) {
                    orders = orderService.getCustomerOrders(current.getId());
                    bookings = cakeBookingService.getCustomerBookings(current.getId());
                } else {
                    orders = orderService.getAllOrders();
                    bookings = cakeBookingService.getAllBookings();
                }

                req.setAttribute("orders", orders);
                req.setAttribute("bookings", bookings);
                req.setAttribute("searchQuery", q != null ? q.trim() : "");
                req.getRequestDispatcher("/track-orders.jsp").forward(req, resp);
                break;
            }
            case "/cancel": {
                String orderId = req.getParameter("orderId");
                if (orderId != null) {
                    orderService.cancelOrder(orderId);
                }
                resp.sendRedirect(req.getContextPath() + "/order/track?msg=cancelled");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/order/cart");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        String servletPath = req.getServletPath();
        if ("/cart".equalsIgnoreCase(servletPath) && path == null) path = "/place";
        if (path == null) path = "/";

        if ("/place".equalsIgnoreCase(path)) {
            HttpSession session = req.getSession();
            List<OrderItem> cart = getCartFromSession(session);
            if (cart.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/order/cart?error=empty");
                return;
            }

            Customer current = (Customer) session.getAttribute("currentUser");
            String custId = current != null ? current.getId() : "GUEST-" + System.currentTimeMillis() % 10000;
            String custName = req.getParameter("customerName");
            if (custName == null || custName.trim().isEmpty()) {
                custName = current != null ? current.getName() : "Valued Patron";
            }
            String deliveryAddress = req.getParameter("deliveryAddress");
            String paymentMethod = req.getParameter("paymentMethod");
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                paymentMethod = "CARD";
            }

            try {
                Order order = orderService.placeOrder(custId, custName, deliveryAddress, cart);
                // Clear shopping cart
                session.removeAttribute("cart");
                // Forward to payment checkout so customer can enter details and authorize
                resp.sendRedirect(req.getContextPath() + "/payment/checkout?refId=" + order.getOrderId() + "&amount=" + order.getTotalAmount() + "&method=" + paymentMethod);
            } catch (Exception e) {
                req.setAttribute("error", e.getMessage());
                req.getRequestDispatcher("/cart.jsp").forward(req, resp);
            }
        } else if ("/update-status".equalsIgnoreCase(path)) {
            String orderId = req.getParameter("orderId");
            String status = req.getParameter("status");
            orderService.updateStatus(orderId, status);
            resp.sendRedirect(req.getContextPath() + "/staff/queue?msg=status_updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/order/cart");
        }
    }

    @SuppressWarnings("unchecked")
    private List<OrderItem> getCartFromSession(HttpSession session) {
        List<OrderItem> cart = (List<OrderItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }
}
