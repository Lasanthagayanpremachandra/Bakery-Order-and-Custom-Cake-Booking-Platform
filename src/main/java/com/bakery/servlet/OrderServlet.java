package com.bakery.servlet;

import com.bakery.model.Customer;
import com.bakery.model.Order;
import com.bakery.model.OrderItem;
import com.bakery.model.Product;
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
@WebServlet(name = "OrderServlet", urlPatterns = {"/order/*"})
public class OrderServlet extends HttpServlet {
    private OrderService orderService;
    private ProductService productService;

    @Override
    public void init() {
        orderService = new OrderService();
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
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
                List<Order> orders;
                if (q != null && !q.trim().isEmpty()) {
                    Order single = orderService.getOrder(q.trim());
                    orders = (single != null) ? List.of(single) : List.of();
                } else if (current != null) {
                    orders = orderService.getCustomerOrders(current.getId());
                } else {
                    orders = orderService.getAllOrders();
                }
                req.setAttribute("orders", orders);
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
                custName = current != null ? current.getName() : "Valued Customer";
            }
            String deliveryAddress = req.getParameter("deliveryAddress");
            String paymentMethod = req.getParameter("paymentMethod");

            try {
                Order order = orderService.placeOrder(custId, custName, deliveryAddress, cart);
                // Clear cart
                session.removeAttribute("cart");
                // Forward to payment checkout or invoice
                resp.sendRedirect(req.getContextPath() + "/payment/invoice?refId=" + order.getOrderId() + "&method=" + (paymentMethod != null ? paymentMethod : "CASH"));
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
