package com.bakery.servlet;

import com.bakery.model.Baker;
import com.bakery.model.CakeDecorator;
import com.bakery.model.Manager;
import com.bakery.model.Staff;
import com.bakery.service.CakeBookingService;
import com.bakery.service.OrderService;
import com.bakery.service.PaymentService;
import com.bakery.service.ProductService;
import com.bakery.service.StaffService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller Servlet for Baker/Decorator & Admin Management.
 * Routes /staff/login, /staff/dashboard, /staff/list, /staff/register, /staff/update, /staff/delete
 */
@WebServlet(name = "StaffServlet", urlPatterns = {"/staff/*"})
public class StaffServlet extends HttpServlet {
    private StaffService staffService;
    private CakeBookingService cakeBookingService;
    private OrderService orderService;
    private ProductService productService;
    private PaymentService paymentService;

    @Override
    public void init() {
        staffService = new StaffService();
        cakeBookingService = new CakeBookingService();
        orderService = new OrderService();
        productService = new ProductService();
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        String servletPath = req.getServletPath();
        if ("/admin".equalsIgnoreCase(servletPath)) path = "/dashboard";
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/login": {
                req.getRequestDispatcher("/staff-login.jsp").forward(req, resp);
                break;
            }
            case "/logout": {
                HttpSession session = req.getSession(false);
                if (session != null) {
                    session.removeAttribute("staffUser");
                    session.removeAttribute("staffRole");
                }
                resp.sendRedirect(req.getContextPath() + "/staff/login?msg=logged_out");
                break;
            }
            case "/dashboard": {
                req.setAttribute("activeBookingsCount", cakeBookingService.getActiveBookings().size());
                req.setAttribute("allOrdersCount", orderService.getAllOrders().size());
                req.setAttribute("allProductsCount", productService.getAllProducts().size());
                req.setAttribute("staffMembers", staffService.listStaff());
                req.setAttribute("recentPayments", paymentService.getAllPayments());
                req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, resp);
                break;
            }
            case "/list":
            case "/workload": {
                List<Staff> staffList = staffService.listStaff();
                req.setAttribute("staffList", staffList);
                req.getRequestDispatcher("/admin-staff.jsp").forward(req, resp);
                break;
            }
            case "/queue": {
                req.setAttribute("bookings", cakeBookingService.getActiveBookings());
                req.setAttribute("orders", orderService.getAllOrders());
                req.setAttribute("staffList", staffService.listStaff());
                req.getRequestDispatcher("/staff-production-queue.jsp").forward(req, resp);
                break;
            }
            case "/delete": {
                String id = req.getParameter("id");
                if (id != null) {
                    staffService.removeStaff(id);
                }
                resp.sendRedirect(req.getContextPath() + "/staff/list?msg=deleted");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/login": {
                String name = req.getParameter("username");
                String pass = req.getParameter("password");
                Staff s = staffService.validateLogin(name, pass);
                if (s != null) {
                    HttpSession session = req.getSession();
                    session.setAttribute("staffUser", s);
                    session.setAttribute("staffRole", s.getRole());
                    resp.sendRedirect(req.getContextPath() + "/staff/dashboard");
                } else {
                    req.setAttribute("error", "Invalid staff credentials.");
                    req.getRequestDispatcher("/staff-login.jsp").forward(req, resp);
                }
                break;
            }
            case "/register": {
                String name = req.getParameter("name");
                String role = req.getParameter("role");
                String spec = req.getParameter("speciality");
                String shift = req.getParameter("shift");
                String password = req.getParameter("password");

                staffService.registerStaff(name, role, spec, shift, password);
                resp.sendRedirect(req.getContextPath() + "/staff/list?msg=staff_added");
                break;
            }
            case "/update": {
                String id = req.getParameter("staffId");
                String name = req.getParameter("name");
                String role = req.getParameter("role");
                String spec = req.getParameter("speciality");
                String shift = req.getParameter("shift");
                String pass = req.getParameter("password");

                Staff current = staffService.findStaff(id);
                String passToSave = (pass != null && !pass.isEmpty()) ? pass : (current != null ? current.getPasswordHash() : "1234");

                Staff updated;
                if ("MANAGER".equalsIgnoreCase(role)) {
                    updated = new Manager(id, name, spec, shift, passToSave);
                } else if ("DECORATOR".equalsIgnoreCase(role)) {
                    updated = new CakeDecorator(id, name, spec, shift, passToSave);
                } else {
                    updated = new Baker(id, name, spec, shift, passToSave);
                }
                staffService.updateStaff(updated);
                resp.sendRedirect(req.getContextPath() + "/staff/list?msg=staff_updated");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/dashboard");
                break;
        }
    }
}
