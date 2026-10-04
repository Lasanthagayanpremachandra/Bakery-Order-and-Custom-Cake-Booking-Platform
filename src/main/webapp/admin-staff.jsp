<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.model.Staff" %>
<%@ page import="java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff & Workload Management | Sweetora</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bakery-theme.css?v=3.0">
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="container">
        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <span class="hero-badge">🧑‍🍳 Kitchen Roster & Roles</span>
                <h1 style="font-size: 2.3rem; margin-top: 0.4rem;">Baker & Decorator Staff Management</h1>
                <p style="color: var(--c-cacao-muted);">
                    Rosters, shifts, and culinary specialities persisted in <code>data/staff.txt</code>.
                </p>
            </div>

            <div style="display: flex; gap: 0.8rem;">
                <a href="<%= request.getContextPath() %>/staff/dashboard" class="btn btn-secondary btn-sm">
                    &larr; Admin Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/staff/queue" class="btn btn-primary btn-sm">
                    Live Production Queue &rarr;
                </a>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1.7fr 1.3fr; gap: 2rem; align-items: flex-start;">
            <!-- Staff List Table -->
            <div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <h2 style="font-size: 1.4rem;">Active Bakery Brigade</h2>
                    <span class="badge badge-gold"><%= staffList != null ? staffList.size() : 0 %> Staff Members</span>
                </div>

                <div class="bakery-table-wrap">
                    <table class="bakery-table">
                        <thead>
                            <tr>
                                <th>Staff ID</th>
                                <th>Name & Role</th>
                                <th>Speciality</th>
                                <th>Shift</th>
                                <th>Access</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (staffList == null || staffList.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 2.5rem; color: var(--c-cacao-muted);">
                                        No staff recorded yet. Register your first staff member below!
                                    </td>
                                </tr>
                            <% } else { %>
                                <% for (Staff s : staffList) { %>
                                    <tr>
                                        <td>
                                            <strong style="font-family: monospace; color: var(--c-caramel); font-size: 0.88rem;">
                                                <%= s.getStaffId() %>
                                            </strong>
                                        </td>
                                        <td>
                                            <strong style="color: var(--c-cacao);"><%= s.getName() %></strong>
                                            <div style="font-size: 0.78rem; color: var(--c-caramel); font-weight: 600;">
                                                <%= s.getRoleTitle() %>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.84rem; color: var(--c-cacao-muted);"><%= s.getSpeciality() %></div>
                                        </td>
                                        <td>
                                            <span class="badge badge-soft" style="font-size: 0.74rem;">
                                                <%= s.getShift() %>
                                            </span>
                                        </td>
                                        <td>
                                            <% if (s.hasAdminPrivileges()) { %>
                                                <span class="badge badge-gold" style="font-size: 0.72rem;">👑 Admin</span>
                                            <% } else { %>
                                                <span class="badge badge-soft" style="font-size: 0.72rem;">Kitchen</span>
                                            <% } %>
                                        </td>
                                        <td style="text-align: right;">
                                            <a href="<%= request.getContextPath() %>/staff/delete?id=<%= s.getStaffId() %>" 
                                               onclick="return confirm('Remove <%= s.getName() %> from the staff roster?');" 
                                               class="btn btn-outline btn-sm" style="padding: 0.25rem 0.6rem; font-size: 0.76rem; color: #DC2626; border-color: #FECACA;">
                                                Remove
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- New Staff Registration Form -->
            <div>
                <form action="<%= request.getContextPath() %>/staff/register" method="POST" class="form-panel">
                    <h3 style="font-size: 1.35rem; margin-bottom: 0.4rem;">Add Brigade Member</h3>
                    <p style="font-size: 0.85rem; color: var(--c-cacao-muted); margin-bottom: 1.5rem;">
                        Add a new head baker, decorator, or manager to the kitchen staff roster.
                    </p>

                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="name" class="form-control" placeholder="e.g. Mateo Rossi" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Role Designation</label>
                        <select name="role" class="form-control" required>
                            <option value="BAKER">🥣 Artisan Baker (Sponges, Doughs, Hearth Ovens)</option>
                            <option value="DECORATOR" selected>🎨 Cake Decorator (Fondant Sculpting & Sugar Art)</option>
                            <option value="MANAGER">👑 Bakery Manager / Executive Admin</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Artisan Speciality</label>
                        <input type="text" name="speciality" class="form-control" placeholder="e.g. Multi-Tier Wedding Cakes, Macarons" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Shift Assignment</label>
                        <select name="shift" class="form-control">
                            <option value="MORNING">☀️ Morning Shift (5:00 AM – 1:30 PM)</option>
                            <option value="AFTERNOON">🌤️ Afternoon Shift (1:00 PM – 9:30 PM)</option>
                            <option value="EVENING">🌙 Evening Shift (8:00 PM – 4:30 AM)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Assigned Account Password</label>
                        <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.85rem; font-size: 1rem; margin-top: 0.5rem;">
                        Enroll Staff Member &rarr;
                    </button>
                </form>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
