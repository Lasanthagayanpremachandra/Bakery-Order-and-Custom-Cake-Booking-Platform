package com.bakery.servlet;

import com.bakery.model.CakeBooking;
import com.bakery.model.Customer;
import com.bakery.model.Order;
import com.bakery.model.Payment;
import com.bakery.service.CakeBookingService;
import com.bakery.service.OrderService;
import com.bakery.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller Servlet for Payment & Billing Management.
 * Routes /payment/checkout, /payment/generate, /payment/invoice, /payment/history, /payment/update, /payment/delete
 */
@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment/*"})
public class PaymentServlet extends HttpServlet {
    private PaymentService paymentService;
    private OrderService orderService;
    private CakeBookingService cakeBookingService;

    @Override
    public void init() {
        paymentService = new PaymentService();
        orderService = new OrderService();
        cakeBookingService = new CakeBookingService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        String servletPath = req.getServletPath();
        if ("/checkout".equalsIgnoreCase(servletPath)) path = "/checkout";
        else if ("/invoice".equalsIgnoreCase(servletPath)) path = "/invoice";
        if (path == null) path = "/history";

        switch (path) {
            case "/checkout": {
                String refId = req.getParameter("refId");
                double amount = 0.0;
                try { amount = Double.parseDouble(req.getParameter("amount")); } catch (Exception ignored) {}
                boolean isDeposit = "true".equalsIgnoreCase(req.getParameter("isDeposit"));
                String method = req.getParameter("method");
                if (method == null || method.trim().isEmpty()) {
                    method = "CARD";
                }

                // If amount is 0, fetch it dynamically from order or booking
                if (amount <= 0.0 && refId != null) {
                    if (refId.startsWith("ORD-")) {
                        Order o = orderService.getOrder(refId);
                        if (o != null) amount = o.getTotalAmount();
                    } else if (refId.startsWith("CAKE-")) {
                        CakeBooking b = cakeBookingService.getBooking(refId);
                        if (b != null) amount = isDeposit ? b.getRequiredDeposit() : b.getTotalAmount();
                    }
                }

                req.setAttribute("refId", refId);
                req.setAttribute("amount", amount);
                req.setAttribute("isDeposit", isDeposit);
                req.setAttribute("selectedMethod", method);
                req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
                break;
            }
            case "/invoice": {
                String refId = req.getParameter("refId");
                String method = req.getParameter("method");
                boolean isDeposit = "true".equalsIgnoreCase(req.getParameter("isDeposit"));

                // Calculate or fetch amount from order or booking
                double amt = 0.0;
                String custName = "Valued Patron";
                if (refId != null && refId.startsWith("ORD-")) {
                    Order o = orderService.getOrder(refId);
                    if (o != null) {
                        amt = o.getTotalAmount();
                        custName = o.getCustomerName();
                    }
                } else if (refId != null && refId.startsWith("CAKE-")) {
                    CakeBooking b = cakeBookingService.getBooking(refId);
                    if (b != null) {
                        amt = isDeposit ? b.getRequiredDeposit() : b.getTotalAmount();
                        custName = b.getCustomerName();
                    }
                }

                // Check if payment already exists
                List<Payment> existing = (refId != null) ? paymentService.getHistory(refId) : List.of();
                Payment payment;
                if (!existing.isEmpty()) {
                    payment = existing.get(0);
                } else {
                    payment = paymentService.generateInvoice(refId != null ? refId : "REF-GUEST", amt, method != null ? method : "CARD", isDeposit);
                }

                req.setAttribute("payment", payment);
                req.setAttribute("customerName", custName);
                req.getRequestDispatcher("/invoice.jsp").forward(req, resp);
                break;
            }
            case "/history": {
                String refId = req.getParameter("refId");
                List<Payment> list;
                if (refId != null && !refId.trim().isEmpty()) {
                    list = paymentService.getHistory(refId);
                } else {
                    list = paymentService.getAllPayments();
                }
                req.setAttribute("payments", list);
                req.getRequestDispatcher("/payment-history.jsp").forward(req, resp);
                break;
            }
            case "/delete": {
                String id = req.getParameter("id");
                if (id != null) {
                    paymentService.voidPayment(id);
                }
                resp.sendRedirect(req.getContextPath() + "/payment/history?msg=voided");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/payment/history");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        if ("/process".equalsIgnoreCase(path)) {
            String refId = req.getParameter("refId");
            double amount = 0.0;
            try { amount = Double.parseDouble(req.getParameter("amount")); } catch (Exception ignored) {}
            String method = req.getParameter("method");
            if (method == null || method.trim().isEmpty()) method = "CARD";
            boolean isDeposit = "true".equalsIgnoreCase(req.getParameter("isDeposit"));

            String cardHolder = req.getParameter("cardHolder");
            String cardNumber = req.getParameter("cardNumber");

            // Process payment and record invoice
            Payment p = paymentService.processPayment(refId, amount, method, isDeposit, cardNumber, cardHolder);

            // Update order or cake booking status to CONFIRMED
            if (refId != null && refId.startsWith("ORD-")) {
                Order o = orderService.getOrder(refId);
                if (o != null && "PENDING".equalsIgnoreCase(o.getStatus())) {
                    orderService.updateStatus(refId, "CONFIRMED");
                }
            } else if (refId != null && refId.startsWith("CAKE-")) {
                CakeBooking b = cakeBookingService.getBooking(refId);
                if (b != null && "PENDING".equalsIgnoreCase(b.getStatus())) {
                    cakeBookingService.updateStatus(refId, "CONFIRMED");
                }
            }

            resp.sendRedirect(req.getContextPath() + "/payment/invoice?refId=" + (refId != null ? refId : "") + "&method=" + method + "&isDeposit=" + isDeposit + "&msg=payment_confirmed");
        } else if ("/update-status".equalsIgnoreCase(path)) {
            String id = req.getParameter("paymentId");
            String status = req.getParameter("status");
            paymentService.updateStatus(id, status);
            resp.sendRedirect(req.getContextPath() + "/payment/history?msg=status_updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/payment/history");
        }
    }
}
