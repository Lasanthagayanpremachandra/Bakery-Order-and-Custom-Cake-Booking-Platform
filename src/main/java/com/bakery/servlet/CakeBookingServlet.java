package com.bakery.servlet;

import com.bakery.model.CakeBooking;
import com.bakery.model.Customer;
import com.bakery.model.Order;
import com.bakery.service.CakeBookingService;
import com.bakery.service.OrderService;
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
 * Controller Servlet for Custom Cake Bookings.
 * Routes /booking/create, /booking/status, /booking/update, /booking/cancel, /booking/queue
 */
@WebServlet(name = "CakeBookingServlet", urlPatterns = {"/booking/*"})
public class CakeBookingServlet extends HttpServlet {
    private CakeBookingService cakeBookingService;
    private OrderService orderService;

    @Override
    public void init() {
        cakeBookingService = new CakeBookingService();
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        String servletPath = req.getServletPath();
        if ("/custom-cake".equalsIgnoreCase(servletPath)) path = "/form";
        if (path == null) path = "/form";

        switch (path) {
            case "/form":
            case "/create": {
                req.getRequestDispatcher("/custom-cake-booking.jsp").forward(req, resp);
                break;
            }
            case "/status":
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
            case "/queue": {
                List<CakeBooking> active = cakeBookingService.getActiveBookings();
                req.setAttribute("bookings", active);
                req.getRequestDispatcher("/staff-production-queue.jsp").forward(req, resp);
                break;
            }
            case "/cancel": {
                String bookingId = req.getParameter("bookingId");
                if (bookingId != null) {
                    cakeBookingService.cancelBooking(bookingId);
                }
                resp.sendRedirect(req.getContextPath() + "/booking/track?msg=cancelled");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/booking/form");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        if ("/create".equalsIgnoreCase(path)) {
            HttpSession session = req.getSession();
            Customer current = (Customer) session.getAttribute("currentUser");

            String custId = current != null ? current.getId() : "GUEST-" + System.currentTimeMillis() % 10000;
            String custName = req.getParameter("customerName");
            if (custName == null || custName.trim().isEmpty()) {
                custName = current != null ? current.getName() : "Valued Customer";
            }
            String flavour = req.getParameter("flavour");
            String size = req.getParameter("size");
            int tiers = 1;
            try { tiers = Integer.parseInt(req.getParameter("tiers")); } catch (Exception ignored) {}
            String design = req.getParameter("design");
            String occasion = req.getParameter("occasion");
            String requiredDate = req.getParameter("requiredDate");
            String customMessage = req.getParameter("customMessage");
            String payDeposit = req.getParameter("payDeposit"); // "true" if paying 30% advance deposit

            try {
                CakeBooking booking = cakeBookingService.createBooking(custId, custName, flavour, size, tiers, design, occasion, requiredDate, customMessage);
                double amtToPay = "true".equalsIgnoreCase(payDeposit) ? booking.getRequiredDeposit() : booking.getTotalAmount();
                resp.sendRedirect(req.getContextPath() + "/payment/checkout?refId=" + booking.getBookingId() + "&amount=" + amtToPay + "&isDeposit=" + ("true".equalsIgnoreCase(payDeposit)));
            } catch (Exception e) {
                req.setAttribute("error", e.getMessage());
                req.getRequestDispatcher("/custom-cake-booking.jsp").forward(req, resp);
            }
        } else if ("/update-status".equalsIgnoreCase(path)) {
            String bookingId = req.getParameter("bookingId");
            String status = req.getParameter("status");
            cakeBookingService.updateStatus(bookingId, status);
            resp.sendRedirect(req.getContextPath() + "/booking/queue?msg=status_updated");
        } else if ("/assign".equalsIgnoreCase(path)) {
            String bookingId = req.getParameter("bookingId");
            String staffId = req.getParameter("staffId");
            cakeBookingService.assignBaker(bookingId, staffId);
            resp.sendRedirect(req.getContextPath() + "/booking/queue?msg=assigned");
        } else {
            resp.sendRedirect(req.getContextPath() + "/booking/form");
        }
    }
}
