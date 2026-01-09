<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Online Bookstore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-inner">
                <a href="${pageContext.request.contextPath}/admin/manage" class="logo">Admin Panel</a>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/index">Store Front</a>
                </nav>
                <div class="header-actions">
                    <span style="color: var(--primary-gray); margin-right: 16px;">${sessionScope.user.username}</span>
                    <a href="${pageContext.request.contextPath}/user-servlet?action=logout" class="btn btn-sm btn-outline">Logout</a>
                </div>
            </div>
        </div>
    </header>

    <div style="display: flex;">
        <aside class="admin-sidebar">
            <nav>
                <a href="${pageContext.request.contextPath}/admin/manage" class="menu-item active">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7"></rect>
                        <rect x="14" y="3" width="7" height="7"></rect>
                        <rect x="14" y="14" width="7" height="7"></rect>
                        <rect x="3" y="14" width="7" height="7"></rect>
                    </svg>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=books" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    Books
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=categories" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="8" y1="6" x2="21" y2="6"></line>
                        <line x1="8" y1="12" x2="21" y2="12"></line>
                        <line x1="8" y1="18" x2="21" y2="18"></line>
                        <line x1="3" y1="6" x2="3.01" y2="6"></line>
                        <line x1="3" y1="12" x2="3.01" y2="12"></line>
                        <line x1="3" y1="18" x2="3.01" y2="18"></line>
                    </svg>
                    Categories
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                    </svg>
                    Orders
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=users" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=announcements" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                    </svg>
                    Announcements
                </a>
            </nav>
        </aside>

        <main class="admin-content">
            <h1 style="font-size: 24px; font-weight: 600; margin-bottom: 32px;">Dashboard</h1>

            <!-- Statistics Cards -->
            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 32px;">
                <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                    </div>
                    <div class="stat-value" style="color: #fff;">${bookCount}</div>
                    <div class="stat-label" style="color: rgba(255,255,255,0.9);">Total Books</div>
                </div>
                <div class="stat-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                        </svg>
                    </div>
                    <div class="stat-value" style="color: #fff;">${userCount}</div>
                    <div class="stat-label" style="color: rgba(255,255,255,0.9);">Total Users</div>
                </div>
                <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                        </svg>
                    </div>
                    <div class="stat-value" style="color: #fff;">${orderCount}</div>
                    <div class="stat-label" style="color: rgba(255,255,255,0.9);">Total Orders</div>
                </div>
                <div class="stat-card" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2">
                            <line x1="12" y1="1" x2="12" y2="23"></line>
                            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                        </svg>
                    </div>
                    <div class="stat-value" style="color: #fff;">¥<fmt:formatNumber value="${totalSales}" pattern="#,##0"/></div>
                    <div class="stat-label" style="color: rgba(255,255,255,0.9);">Total Sales</div>
                </div>
            </div>

            <!-- Charts Row -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px;">
                <div class="card">
                    <h3 class="card-title">Order Status Distribution</h3>
                    <div style="position: relative; height: 300px;">
                        <canvas id="orderStatusChart"></canvas>
                    </div>
                </div>
                <div class="card">
                    <h3 class="card-title">Order Status Summary</h3>
                    <div style="padding: 20px 0;">
                        <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border-gray);">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 12px; height: 12px; background: #ffb800; border-radius: 2px;"></div>
                                <span>Pending</span>
                            </div>
                            <strong>${pendingCount}</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border-gray);">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 12px; height: 12px; background: #4facfe; border-radius: 2px;"></div>
                                <span>Paid</span>
                            </div>
                            <strong>${paidCount}</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border-gray);">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 12px; height: 12px; background: #667eea; border-radius: 2px;"></div>
                                <span>Shipped</span>
                            </div>
                            <strong>${shippedCount}</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border-gray);">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 12px; height: 12px; background: #43e97b; border-radius: 2px;"></div>
                                <span>Completed</span>
                            </div>
                            <strong>${completedCount}</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 12px 0;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 12px; height: 12px; background: #f5576c; border-radius: 2px;"></div>
                                <span>Cancelled</span>
                            </div>
                            <strong>${cancelledCount}</strong>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders and Low Stock -->
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px;">
                <div class="card">
                    <h3 class="card-title">Recent Orders</h3>
                    <c:choose>
                        <c:when test="${empty recentOrders}">
                            <p style="color: var(--primary-gray); text-align: center; padding: 24px;">No orders yet</p>
                        </c:when>
                        <c:otherwise>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Order No</th>
                                        <th>Customer</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${recentOrders}">
                                        <tr>
                                            <td><a href="${pageContext.request.contextPath}/admin/manage?action=orders" style="color: var(--primary);">${order.orderNo}</a></td>
                                            <td>${order.user.username}</td>
                                            <td>¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                            <td>
                                                <span class="status-badge status-${order.status == 'PENDING' ? 'pending' : order.status == 'PAID' ? 'paid' : order.status == 'SHIPPED' ? 'shipped' : order.status == 'COMPLETED' ? 'completed' : 'cancelled'}">
                                                    ${order.status == 'PENDING' ? 'Pending' : order.status == 'PAID' ? 'Paid' : order.status == 'SHIPPED' ? 'Shipped' : order.status == 'COMPLETED' ? 'Completed' : 'Cancelled'}
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${order.createdAt}" pattern="MM-dd HH:mm"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="card">
                    <h3 class="card-title">Low Stock Alert</h3>
                    <c:choose>
                        <c:when test="${empty lowStockBooks}">
                            <div style="text-align: center; padding: 60px 20px;">
                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#43e97b" stroke-width="2" style="margin: 0 auto 12px;">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <p style="color: var(--primary-gray);">All books have sufficient stock</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="book" items="${lowStockBooks}">
                                <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid var(--border-gray);">
                                    <div style="flex: 1; min-width: 0;">
                                        <div style="font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${book.title}</div>
                                        <div style="font-size: 14px; color: var(--primary-gray); margin-top: 4px;">${book.author}</div>
                                    </div>
                                    <div style="margin-left: 12px; padding: 4px 12px; border-radius: 12px; font-weight: 500; font-size: 14px; white-space: nowrap; background: ${book.stock == 0 ? '#fff0f0' : '#fff8e6'}; color: ${book.stock == 0 ? '#f5576c' : '#ffb800'};">
                                        ${book.stock} left
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        // Order Status Chart
        const ctx = document.getElementById('orderStatusChart');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Pending', 'Paid', 'Shipped', 'Completed', 'Cancelled'],
                datasets: [{
                    data: [${pendingCount}, ${paidCount}, ${shippedCount}, ${completedCount}, ${cancelledCount}],
                    backgroundColor: [
                        '#ffb800',
                        '#4facfe',
                        '#667eea',
                        '#43e97b',
                        '#f5576c'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 15,
                            font: {
                                size: 13
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
