# 🍰 Sweetora – Bakery Order and Custom Cake Booking Platform

> **Haute Pâtisserie & Custom Cake Studio**  
> *SE1020 Object-Oriented Programming (OOP) Final Project*  
> **Location:** Hedeniya, Kandy, Sri Lanka | **Hotline:** +94 76 749 4866 | **Currency:** Sri Lankan Rupees (Rs.)

---

## 🌟 Overview

**Sweetora** is an enterprise-grade web application built in Java designed for artisan bakeries and luxury cake ateliers. The platform enables customers to explore handcrafted bakes, custom-build multi-tier celebration cakes with live interactive visualization, pay deposits, and track their cake’s journey through the kitchen. It also equips bakery staff and kitchen managers with a live Kanban pipeline, recipe inventory controls, and financial reporting.

The system is constructed strictly adhering to **Object-Oriented Programming (OOP)** principles and follows the **Model-View-Controller (MVC)** architectural pattern combined with the **Data Access Object (DAO)** pattern using file-based persistence for zero database configuration requirements.

---

## 📸 Key Features

### 🛍️ Customer Portal
* **Artisan Catalog & Menu**: Browse by category—*Celebration Cakes*, *French Viennoiserie*, and *Hearth Sourdough*. Live kitchen stock indicators and dietary tags (e.g. Organic Stoneground, Gluten-Free).
* **✨ Interactive Custom Cake Studio**:
  * Real-time visual canvas layer preview dynamically updating as flavors, tiers, and decorations change.
  * Choose artisan sponge & fillings (Belgian Truffle, Madagascan Vanilla, Red Velvet, Matcha Pistachio, etc.).
  * Multi-tier architectural options (1, 2, or 3 royal tiers) with custom weight options (1kg to 5kg Grand Gala).
  * Design finishes (Vintage Floral & 24K Gold Leaf, Sculpted Fondant Art, Gourmet Chocolate Drip & Berries).
  * Custom cake plaque inscription.
  * Instant price calculation with optional **30% Advance Deposit** option to lock kitchen slots.
* **Shopping Basket & VIP Discounts**:
  * Polymorphic customer discounting: Gold VIP members automatically receive **12% OFF** all orders.
* **Settlement & Checkout**:
  * Interactive live Credit/Debit card simulation with real-time card visualizer.
  * Cash on Delivery / Counter pickup payment option.
* **Order & Celebration Cake Tracker**:
  * 5-stage kitchen progression timeline (*Confirmed &rarr; In Oven / Baking &rarr; Artisan Decorating &rarr; Quality Inspection & Packaging &rarr; Out for Delivery / Ready for Pickup*).
* **Official Invoice & Receipt Generator**:
  * Printable receipt formatted with transaction ID, tax breakdown, billing information, and official bakery seal.
* **Customer Reviews & Feedback**:
  * Verified purchase and public community reviews with 5-star interactive rating.

---

### ⚙️ Bakery Staff & Management Portal
* **Role-Based Authentication**:
  * **Manager**: Full operational dashboard, revenue totals, product CRUD, staff management, and review moderation.
  * **Baker**: Dedicated oven & dough queue.
  * **Cake Decorator**: Custom cake styling, sugar flower and fondant finishing queue.
* **Executive Operations Dashboard**:
  * Real-time KPI summary (Total Settled Revenue in Rs., Active Orders, Custom Cake Pipeline count, Low Stock alerts).
  * Recent settlements tally.
* **Live Kitchen Production Kanban Queue**:
  * Drag-and-drop / 1-click status transitions across stages (*Confirmed &rarr; Baking &rarr; Decorating &rarr; Ready &rarr; Delivered*).
* **Menu & Product Inventory Management**:
  * Add, edit, update prices, manage stock levels, and upload product images.
* **Patron Directory**:
  * View customer profiles, tier classifications, contact info, and lifetime purchase history.

---

## 🏗️ Architecture & OOP Implementation

The application is structured into clearly separated layers:

```
src/main/java/com/bakery/
├── model/        # Domain entities applying OOP principles
├── dao/          # Data Access Objects (Plaintext file persistence)
├── service/      # Business logic, validations, pricing, and slots
├── servlet/      # Web Controllers (Jakarta Servlets)
└── util/         # Embedded Tomcat runner and utilities
```

### 🧬 Core OOP Principles

| Principle | Implementation Details |
| :--- | :--- |
| **Inheritance** | • `Product` &rarr; `ReadyMadeCake`, `Pastry`, `Bread`<br>• `Customer` &rarr; `RegularCustomer`, `PremiumCustomer`<br>• `Staff` &rarr; `Manager`, `Baker`, `CakeDecorator`<br>• `Payment` &rarr; `CardPayment`, `CashPayment`<br>• `Review` &rarr; `VerifiedPurchaseReview`, `PublicReview` |
| **Polymorphism** | • Polymorphic `calculateDiscount()` in `Customer` hierarchy applies distinct discount algorithms (12% for Gold VIP, 5% for regular large orders).<br>• Polymorphic `processPayment()` in `Payment` hierarchy.<br>• Polymorphic product descriptions and category details. |
| **Encapsulation** | • All models utilize `private` fields with strict validation checks inside getters/setters.<br>• Protects sensitive internal state such as balances, stock amounts, and passwords. |
| **Abstraction** | • Separation of presentation (JSPs) from controllers (`HttpServlet`) and persistence (`DAO`).<br>• Abstract classes provide base templates while subclasses supply specialized implementations. |

---

## 🗄️ Persistence Layer (File-Based Storage)

All application data is cleanly managed in the `data/` directory using human-readable, pipe-delimited records:

| File | Description |
| :--- | :--- |
| `data/products.txt` | Ready-made cakes, artisan bread, and pastries catalog. |
| `data/cake_bookings.txt` | Custom multi-tier celebration cake reservations and pipeline stages. |
| `data/orders.txt` | Standard bakery item orders, delivery notes, and items list. |
| `data/customers.txt` | Patron profiles, addresses, VIP status, and credentials. |
| `data/staff.txt` | Bakery brigade accounts, assigned shift times, and operational roles. |
| `data/payments.txt` | Settled financial transactions, payment methods, and timestamps. |
| `data/reviews.txt` | Star ratings, customer comments, and verified badge flags. |

---

## 🚀 Getting Started

### Prerequisites
* **Java Development Kit (JDK)**: Version 17 or higher (tested on OpenJDK 21 / 23).
* **Apache Maven**: Version 3.8 or higher.
* Operating System: macOS, Linux, or Windows.

### 🏃 Quick Start (One Command)

Simply run the provided startup script in your terminal:

```bash
chmod +x run.sh
./run.sh
```

Or execute directly with Maven:

```bash
mvn clean compile exec:java
```

The embedded Apache Tomcat server will automatically compile and launch on port **8085**.

---

## 🌐 URLs & Access Endpoints

| Portal | URL | Description |
| :--- | :--- | :--- |
| **Storefront Homepage** | [http://localhost:8085/](http://localhost:8085/) | Main landing page & master showcase |
| **Artisan Menu** | [http://localhost:8085/product/list](http://localhost:8085/product/list) | Complete catalog with category filters |
| **Custom Cake Studio** | [http://localhost:8085/booking/form](http://localhost:8085/booking/form) | Interactive 3D/2D tier designer |
| **Shopping Basket** | [http://localhost:8085/order/cart](http://localhost:8085/order/cart) | Cart summary & checkout |
| **Live Order Tracker** | [http://localhost:8085/order/track](http://localhost:8085/order/track) | Real-time 5-stage kitchen monitor |
| **Patron Sign In** | [http://localhost:8085/customer/login](http://localhost:8085/customer/login) | Customer login with 1-click demo access |
| **Staff & Baker Login** | [http://localhost:8085/staff/login](http://localhost:8085/staff/login) | Brigade management portal |
| **Executive Dashboard** | [http://localhost:8085/staff/dashboard](http://localhost:8085/staff/dashboard) | Management metrics & KPI reports |
| **Kitchen Kanban Queue** | [http://localhost:8085/staff/queue](http://localhost:8085/staff/queue) | Live production workflow board |

---

## 🔑 Demo Login Credentials

The platform features an instant **1-Click Demo Login** switcher in the top navigation bar. You can also log in manually using the following accounts:

### 👑 Patron Accounts
| Name | Email / ID | Password | Tier |
| :--- | :--- | :--- | :--- |
| **Kavindu Perera** | `eleanor@bakery.com` *(or `kavindu@sweetora.com`)* | `pass123` | **Gold VIP (12% Off Everything)** |
| **Kasun Silva** | `marcus@example.com` *(or `kasun@sweetora.com`)* | `pass123` | **Regular Patron** |

### 👨‍🍳 Bakery Brigade Accounts
| Name | Staff ID | Role | Password | Access Area |
| :--- | :--- | :--- | :--- | :--- |
| **Chef Jacques Pierre** | `STF-001` | **Manager** | `admin123` | Full Admin Console & KPI Dashboard |
| **Giselle Dupont** | `STF-002` | **Decorator** | `staff123` | Custom Cake Decorating Queue |
| **Mateo Rossi** | `STF-003` | **Master Baker** | `staff123` | Ovens & Sourdough Production Board |

---

## 📍 Contact & Bakery Headquarters

* **Brand**: Sweetora – *Cakes • Desserts • Sweeter Moments*
* **Address**: Hedeniya, Kandy, Sri Lanka
* **Hotline / Customer Care**: +94 76 749 4866
* **Official Inquiries**: `billing@sweetora.com`
* **Opening Hours**: Open Daily: 7:00 AM – 9:00 PM

---

## 📜 Academic Integrity & License
This project was developed for the **SE1020 Object-Oriented Programming (OOP)** module.  
All rights reserved © 2026 Sweetora & Cake Studio.
