package com.bakery.dao;

import com.bakery.model.Bread;
import com.bakery.model.Pastry;
import com.bakery.model.Product;
import com.bakery.model.ReadyMadeCake;
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
 * File I/O Data Access Object for Bakery Product & Menu Management.
 * Manages products.txt with polymorphism support for Cakes, Pastries, and Breads.
 */
public class ProductFileDAO {
    private static final String FILE_NAME = "products.txt";

    private Path getFilePath() {
        return FileUtil.getDataFilePath(FILE_NAME);
    }

    public synchronized List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        Path path = getFilePath();
        if (!Files.exists(path)) return list;

        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] p = line.split("\\|", -1);
                if (p.length >= 5) {
                    String id = p[0];
                    String name = p[1];
                    String cat = p[2].toUpperCase();
                    double price = Double.parseDouble(p[3]);
                    int stock = Integer.parseInt(p[4]);
                    String desc = p.length >= 6 ? p[5] : "";
                    String img = p.length >= 7 ? p[6] : "";
                    String extra1 = p.length >= 8 ? p[7] : "";
                    String extra2 = p.length >= 9 ? p[8] : "";

                    Product prod;
                    if ("CAKE".equalsIgnoreCase(cat)) {
                        int shelfLife = 5;
                        try { if (!extra2.isEmpty()) shelfLife = Integer.parseInt(extra2); } catch (Exception ignored) {}
                        prod = new ReadyMadeCake(id, name, price, stock, desc, img, extra1.isEmpty() ? "Artisan Vanilla" : extra1, shelfLife);
                    } else if ("PASTRY".equalsIgnoreCase(cat)) {
                        boolean gf = Boolean.parseBoolean(extra2);
                        prod = new Pastry(id, name, price, stock, desc, img, extra1.isEmpty() ? "Butter Puff" : extra1, gf);
                    } else if ("BREAD".equalsIgnoreCase(cat)) {
                        boolean sourdough = Boolean.parseBoolean(extra2);
                        prod = new Bread(id, name, price, stock, desc, img, extra1.isEmpty() ? "Artisan Flour" : extra1, sourdough);
                    } else {
                        // Default cake fallback
                        prod = new ReadyMadeCake(id, name, price, stock, desc, img, "Signature", 4);
                    }
                    list.add(prod);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    public synchronized Product findById(String id) {
        if (id == null) return null;
        for (Product p : getAll()) {
            if (id.equalsIgnoreCase(p.getProductId())) return p;
        }
        return null;
    }

    public synchronized boolean save(Product product) {
        if (product == null) return false;
        List<Product> all = getAll();
        boolean exists = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getProductId().equalsIgnoreCase(product.getProductId())) {
                all.set(i, product);
                exists = true;
                break;
            }
        }
        if (!exists) {
            all.add(product);
        }
        return writeAll(all);
    }

    public synchronized boolean delete(String id) {
        if (id == null) return false;
        List<Product> all = getAll();
        boolean removed = all.removeIf(p -> p.getProductId().equalsIgnoreCase(id));
        if (removed) {
            return writeAll(all);
        }
        return false;
    }

    private synchronized boolean writeAll(List<Product> list) {
        Path path = getFilePath();
        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
            for (Product p : list) {
                String extra1 = "";
                String extra2 = "";
                if (p instanceof ReadyMadeCake) {
                    ReadyMadeCake c = (ReadyMadeCake) p;
                    extra1 = c.getFlavor();
                    extra2 = String.valueOf(c.getShelfLifeDays());
                } else if (p instanceof Pastry) {
                    Pastry pa = (Pastry) p;
                    extra1 = pa.getPastryType();
                    extra2 = String.valueOf(pa.isGlutenFree());
                } else if (p instanceof Bread) {
                    Bread b = (Bread) p;
                    extra1 = b.getGrainType();
                    extra2 = String.valueOf(b.isSourdough());
                }
                String line = String.join("|",
                    p.getProductId(),
                    p.getName().replace("|", " "),
                    p.getCategory(),
                    String.valueOf(p.getPrice()),
                    String.valueOf(p.getStock()),
                    p.getDescription() != null ? p.getDescription().replace("|", " ") : "",
                    p.getImageUrl() != null ? p.getImageUrl() : "",
                    extra1 != null ? extra1.replace("|", " ") : "",
                    extra2
                );
                writer.write(line);
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
