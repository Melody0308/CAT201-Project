<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
                <a href="${pageContext.request.contextPath}/admin/manage" class="menu-item">
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
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders" class="menu-item active">
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
            <h1 style="font-size: 24px; font-weight: 600; margin-bottom: 32px;">Manage Orders</h1>

            <div class="tabs" style="margin-bottom: 24px;">
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders" class="tab ${empty status ? 'active' : ''}">All</a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders&status=PENDING" class="tab ${status == 'PENDING' ? 'active' : ''}">Pending</a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders&status=PAID" class="tab ${status == 'PAID' ? 'active' : ''}">Paid</a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders&status=SHIPPED" class="tab ${status == 'SHIPPED' ? 'active' : ''}">Shipped</a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders&status=COMPLETED" class="tab ${status == 'COMPLETED' ? 'active' : ''}">Completed</a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders&status=CANCELLED" class="tab ${status == 'CANCELLED' ? 'active' : ''}">Cancelled</a>
            </div>

            <div class="card">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Order No</th>
                            <th>Customer</th>
                            <th>Items</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderNo}</td>
                                <td>${order.user.username}</td>
                                <td>${order.items.size()} items</td>
                                <td>¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                <td>
                                    <span class="status-badge status-${order.status == 'PENDING' ? 'pending' : order.status == 'PAID' ? 'paid' : order.status == 'SHIPPED' ? 'shipped' : order.status == 'COMPLETED' ? 'completed' : 'cancelled'}">
                                        ${order.status == 'PENDING' ? 'Pending' : order.status == 'PAID' ? 'Paid' : order.status == 'SHIPPED' ? 'Shipped' : order.status == 'COMPLETED' ? 'Completed' : 'Cancelled'}
                                    </span>
                                </td>
                                <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <button onclick="viewOrderDetail(${order.id})" class="btn btn-sm btn-secondary">View</button>
                                        <c:if test="${order.status == 'PAID'}">
                                            <button onclick="shipOrder(${order.id})" class="btn btn-sm btn-primary">Ship</button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${pageUtil.totalPages > 1}">
                    <div class="pagination" style="margin-top: 24px;">
                        <c:if test="${pageUtil.hasPrevious()}">
                            <a href="${pageContext.request.contextPath}/admin/manage?action=orders&page=${pageUtil.pageNum - 1}${not empty status ? '&status='.concat(status) : ''}">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                            </a>
                        </c:if>
                        
                        <c:forEach begin="1" end="${pageUtil.totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == pageUtil.pageNum}">
                                    <span class="active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/admin/manage?action=orders&page=${i}${not empty status ? '&status='.concat(status) : ''}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <c:if test="${pageUtil.hasNext()}">
                            <a href="${pageContext.request.contextPath}/admin/manage?action=orders&page=${pageUtil.pageNum + 1}${not empty status ? '&status='.concat(status) : ''}">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <div class="modal-overlay" id="orderDetailModal">
        <div class="modal" style="max-width: 600px;">
            <div class="modal-header">
                <h3 class="modal-title">Order Detail</h3>
                <button class="modal-close" onclick="closeOrderModal()">&times;</button>
            </div>
            <div class="modal-body" id="orderDetailContent"></div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function viewOrderDetail(orderId) {
            fetch('${pageContext.request.contextPath}/admin/manage?action=orderDetail&id=' + orderId)
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        const order = data.data;
                        // Handle both 'items' and 'orderItems' property names
                        const items = order.items || order.orderItems || [];
                        
                        let itemsHtml = items.map(item => 
                            '<div style="display: flex; gap: 12px; padding: 12px 0; border-bottom: 1px solid var(--border-gray);">' +
                            '<div style="flex: 1;"><div style="font-weight: 500;">' + (item.book ? item.book.title : 'Unknown') + '</div>' +
                            '<div style="color: var(--primary-gray); font-size: 14px;">Qty: ' + item.quantity + '</div></div>' +
                            '<div style="font-weight: 500;">¥' + (item.subtotal || (item.price * item.quantity)).toFixed(2) + '</div></div>'
                        ).join('');
                        
                        const address = order.address || {};
                        document.getElementById('orderDetailContent').innerHTML = 
                            '<div style="margin-bottom: 16px;"><strong>Order No:</strong> ' + order.orderNo + '</div>' +
                            '<div style="margin-bottom: 16px;"><strong>Customer:</strong> ' + (order.user ? order.user.username : 'Unknown') + '</div>' +
                            '<div style="margin-bottom: 16px;"><strong>Address:</strong> ' + 
                                (address.receiverName || '') + ' ' + (address.phone || '') + '<br>' +
                                (address.province || '') + ' ' + (address.city || '') + ' ' + (address.district || '') + ' ' + (address.detailAddress || '') + '</div>' +
                            '<div style="margin-bottom: 16px;"><strong>Items:</strong></div>' + itemsHtml +
                            '<div style="margin-top: 16px; text-align: right; font-size: 18px;"><strong>Total: ¥' + order.totalAmount.toFixed(2) + '</strong></div>';
                        document.getElementById('orderDetailModal').classList.add('active');
                    } else {
                        alert(data.message || 'Failed to load order details');
                    }
                })
                .catch(err => {
                    console.error('Error loading order details:', err);
                    alert('Error loading order details');
                });
        }
        
        function closeOrderModal() {
            document.getElementById('orderDetailModal').classList.remove('active');
        }
        
        function shipOrder(orderId) {
            if (!confirm('Confirm to ship this order?')) return;
            fetch('${pageContext.request.contextPath}/admin/manage?action=shipOrder', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'id=' + orderId
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message);
                }
            });
        }
    </script>
</body>
</html>
