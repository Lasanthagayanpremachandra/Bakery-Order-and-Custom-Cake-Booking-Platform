package com.bakery.servlet;

import com.bakery.model.Customer;
import com.bakery.model.PremiumCustomer;
import com.bakery.model.RegularCustomer;
import com.bakery.service.CustomerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller Servlet for Customer Management.
 * Routes /customer/register, /customer/login, /customer/search, /customer/update, /customer/delete
 */
@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer/*"})
public class CustomerServlet extends HttpServlet {
    private CustomerService customerService;

    @Override
    public void init() {
        customerService = new CustomerService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        String servletPath = req.getServletPath();
        if ("/login".equalsIgnoreCase(servletPath)) path = "/login";
        else if ("/register".equalsIgnoreCase(servletPath)) path = "/register";
        else if ("/profile".equalsIgnoreCase(servletPath)) path = "/profile";
        if (path == null) path = "/";

        switch (path) {
            case "/login":
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                break;
            case "/register":
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                break;
            case "/profile":
                req.getRequestDispatcher("/customer-profile.jsp").forward(req, resp);
                break;
            case "/logout":
                HttpSession session = req.getSession(false);
                if (session != null) session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/index.jsp?msg=logged_out");
                break;
            case "/list":
            case "/search":
                String query = req.getParameter("q");
                List<Customer> customers;
                if (query != null && !query.trim().isEmpty()) {
                    Customer found = customerService.findCustomer(query.trim());
                    customers = (found != null) ? List.of(found) : List.of();
                } else {
                    customers = customerService.getAllCustomers();
                }
                req.setAttribute("customers", customers);
                req.getRequestDispatcher("/admin-customers.jsp").forward(req, resp);
                break;
            case "/delete":
                String deleteId = req.getParameter("id");
                if (deleteId != null) {
                    customerService.deleteCustomer(deleteId);
                }
                resp.sendRedirect(req.getContextPath() + "/customer/list?msg=deleted");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        String servletPath = req.getServletPath();
        if ("/login".equalsIgnoreCase(servletPath)) path = "/login";
        else if ("/register".equalsIgnoreCase(servletPath)) path = "/register";
        if (path == null) path = "/";

        switch (path) {
            case "/register": {
                String name = req.getParameter("name");
                String phone = req.getParameter("phone");
                String address = req.getParameter("address");
                String email = req.getParameter("email");
                String password = req.getParameter("password");
                String type = req.getParameter("type"); // REGULAR or PREMIUM

                try {
                    Customer c = customerService.registerCustomer(name, phone, address, email, password, type);
                    HttpSession session = req.getSession();
                    session.setAttribute("currentUser", c);
                    resp.sendRedirect(req.getContextPath() + "/index.jsp?msg=welcome");
                } catch (Exception e) {
                    req.setAttribute("error", e.getMessage());
                    req.getRequestDispatcher("/register.jsp").forward(req, resp);
                }
                break;
            }
            case "/login": {
                String email = req.getParameter("email");
                String password = req.getParameter("password");
                Customer c = customerService.validateLogin(email, password);
                if (c != null) {
                    HttpSession session = req.getSession();
                    session.setAttribute("currentUser", c);
                    resp.sendRedirect(req.getContextPath() + "/index.jsp?msg=login_success");
                } else {
                    req.setAttribute("error", "Invalid email/phone or password");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                }
                break;
            }
            case "/update": {
                HttpSession session = req.getSession();
                Customer current = (Customer) session.getAttribute("currentUser");
                String id = req.getParameter("id");
                if (current != null && (current.getId().equals(id) || "ADMIN".equals(session.getAttribute("staffRole")))) {
                    String name = req.getParameter("name");
                    String phone = req.getParameter("phone");
                    String address = req.getParameter("address");
                    String email = req.getParameter("email");
                    String password = req.getParameter("password");
                    String type = req.getParameter("type");

                    Customer updated;
                    if ("PREMIUM".equalsIgnoreCase(type)) {
                        updated = new PremiumCustomer(id, name, phone, address, email, 
                            (password != null && !password.isEmpty()) ? password : current.getPasswordHash());
                    } else {
                        updated = new RegularCustomer(id, name, phone, address, email, 
                            (password != null && !password.isEmpty()) ? password : current.getPasswordHash());
                    }
                    customerService.updateCustomer(updated);
                    session.setAttribute("currentUser", updated);
                    resp.sendRedirect(req.getContextPath() + "/customer/profile?msg=updated");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/customer/login");
                }
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
                break;
        }
    }
}
