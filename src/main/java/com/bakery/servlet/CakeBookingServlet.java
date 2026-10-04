package com.bakery.servlet;

import com.bakery.model.CakeBooking;
import com.bakery.model.Customer;
import com.bakery.service.CakeBookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller Servlet for Custom Cake Bookings.
 * Routes /booking/create, /booking/status, /booking/update, /booking/cancel, /booking/queue
 */
@WebServlet(name = "CakeBookingServlet", urlPatterns = {"/booking/*"})
public class CakeBookingServlet extends HttpServlet {
    private CakeBookingService cakeBookingService;

    @Override
    public void init() {
        cakeBookingService = new CakeBookingService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
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
                List<CakeBooking> bookings;
                if (q != null && !q.trim().isEmpty()) {
                    CakeBooking b = cakeBookingService.getBooking(q.trim());
                    bookings = (b != null) ? List.of(b) : List.of();
                } else if (current != null) {
                    bookings = cakeBookingService.getCustomerBookings(current.getId());
                } else {
                    bookings = cakeBookingService.getAllBookings();
                }
                req.setAttribute("bookings", bookings);
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
