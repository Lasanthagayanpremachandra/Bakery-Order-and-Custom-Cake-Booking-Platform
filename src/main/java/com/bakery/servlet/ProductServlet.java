package com.bakery.servlet;

import com.bakery.model.Bread;
import com.bakery.model.Pastry;
import com.bakery.model.Product;
import com.bakery.model.ReadyMadeCake;
import com.bakery.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller Servlet for Bakery Product & Menu Management.
 * Routes /product/list, /product/search, /product/add, /product/edit, /product/update, /product/delete
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/product/*"})
public class ProductServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/list";

        switch (path) {
            case "/list":
            case "/menu": {
                String cat = req.getParameter("category");
                String q = req.getParameter("q");
                List<Product> products = productService.searchProducts(q, cat, null, null);
                req.setAttribute("products", products);
                req.setAttribute("activeCategory", cat != null ? cat : "ALL");
                req.setAttribute("searchQuery", q != null ? q : "");
                req.getRequestDispatcher("/menu.jsp").forward(req, resp);
                break;
            }
            case "/admin-list": {
                List<Product> products = productService.getAllProducts();
                req.setAttribute("products", products);
                req.getRequestDispatcher("/admin-products.jsp").forward(req, resp);
                break;
            }
            case "/add": {
                req.getRequestDispatcher("/admin-product-form.jsp").forward(req, resp);
                break;
            }
            case "/edit": {
                String id = req.getParameter("id");
                Product p = productService.getProduct(id);
                req.setAttribute("product", p);
                req.getRequestDispatcher("/admin-product-form.jsp").forward(req, resp);
                break;
            }
            case "/delete": {
                String id = req.getParameter("id");
                if (id != null) {
                    productService.removeProduct(id);
                }
                resp.sendRedirect(req.getContextPath() + "/product/admin-list?msg=deleted");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/product/list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        if ("/save".equalsIgnoreCase(path) || "/add".equalsIgnoreCase(path) || "/update".equalsIgnoreCase(path)) {
            String id = req.getParameter("productId");
            String name = req.getParameter("name");
            String category = req.getParameter("category");
            double price = 0.0;
            int stock = 0;
            try { price = Double.parseDouble(req.getParameter("price")); } catch (Exception ignored) {}
            try { stock = Integer.parseInt(req.getParameter("stock")); } catch (Exception ignored) {}
            String description = req.getParameter("description");
            String imageUrl = req.getParameter("imageUrl");
            String extra1 = req.getParameter("extra1");
            String extra2 = req.getParameter("extra2");

            if (id != null && !id.trim().isEmpty()) {
                // Update existing
                Product p;
                if ("CAKE".equalsIgnoreCase(category)) {
                    int shelfLife = 5;
                    try { if (extra2 != null) shelfLife = Integer.parseInt(extra2); } catch (Exception ignored) {}
                    p = new ReadyMadeCake(id, name, price, stock, description, imageUrl, extra1, shelfLife);
                } else if ("PASTRY".equalsIgnoreCase(category)) {
                    boolean gf = Boolean.parseBoolean(extra2);
                    p = new Pastry(id, name, price, stock, description, imageUrl, extra1, gf);
                } else {
                    boolean sd = Boolean.parseBoolean(extra2);
                    p = new Bread(id, name, price, stock, description, imageUrl, extra1, sd);
                }
                productService.updateProduct(p);
            } else {
                // Create new
                productService.addProduct(name, category, price, stock, description, imageUrl, extra1, extra2);
            }
            resp.sendRedirect(req.getContextPath() + "/product/admin-list?msg=saved");
        } else {
            resp.sendRedirect(req.getContextPath() + "/product/list");
        }
    }
}
