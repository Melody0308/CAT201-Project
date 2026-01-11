<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Online Bookstore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-inner">
                <a href="${pageContext.request.contextPath}/index" class="logo">Bookstore</a>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/index">Home</a>
                    <a href="${pageContext.request.contextPath}/book?action=list">Books</a>
                </nav>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/cart?action=list" class="icon-btn">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="9" cy="21" r="1"></circle>
                            <circle cx="20" cy="21" r="1"></circle>
                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                        </svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/user/profile.jsp" class="icon-btn">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <section class="section">
        <div class="container">
            <h1 class="section-title">My Orders</h1>

            <div class="tabs" style="margin-bottom: 24px;">
                <a href="${pageContext.request.contextPath}/order?action=list" class="tab ${empty status ? 'active' : ''}">All</a>
                <a href="${pageContext.request.contextPath}/order?action=list&status=PENDING" class="tab ${status == 'PENDING' ? 'active' : ''}">Pending</a>
                <a href="${pageContext.request.contextPath}/order?action=list&status=PAID" class="tab ${status == 'PAID' ? 'active' : ''}">Paid</a>
                <a href="${pageContext.request.contextPath}/order?action=list&status=SHIPPED" class="tab ${status == 'SHIPPED' ? 'active' : ''}">Shipped</a>
                <a href="${pageContext.request.contextPath}/order?action=list&status=COMPLETED" class="tab ${status == 'COMPLETED' ? 'active' : ''}">Completed</a>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="card" style="text-align: center; padding: 60px;">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#d2d2d7" stroke-width="1">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                        </svg>
                        <p style="margin-top: 16px; color: var(--primary-gray);">No orders yet</p>
                        <a href="${pageContext.request.contextPath}/book?action=list" class="btn btn-primary" style="margin-top: 24px;">Start Shopping</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="order" items="${orders}">
                        <div class="card" style="margin-bottom: 16px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 16px; border-bottom: 1px solid var(--border-gray); margin-bottom: 16px;">
                                <div>
                                    <span style="color: var(--primary-gray);">Order No: </span>
                                    <span style="font-weight: 500;">${order.orderNo}</span>
                                    <span style="color: var(--primary-gray); margin-left: 24px;">
                                        <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </span>
                                </div>
                                <span class="status-badge status-${order.status == 'PENDING' ? 'pending' : order.status == 'PAID' ? 'paid' : order.status == 'SHIPPED' ? 'shipped' : order.status == 'COMPLETED' ? 'completed' : 'cancelled'}">
                                    ${order.status == 'PENDING' ? 'Pending' : order.status == 'PAID' ? 'Paid' : order.status == 'SHIPPED' ? 'Shipped' : order.status == 'COMPLETED' ? 'Completed' : 'Cancelled'}
                                </span>
                            </div>
                            
                            <c:forEach var="item" items="${order.items}" varStatus="st">
                                <c:if test="${st.index < 3}">
                                    <div style="display: flex; gap: 16px; padding: 12px 0; ${st.index > 0 ? 'border-top: 1px solid var(--border-gray);' : ''}">
                                        <div style="width: 60px; height: 75px; background: var(--light-gray); border-radius: 6px; overflow: hidden; flex-shrink: 0;">
                                            <c:if test="${not empty item.book.coverImage}">
                                                <img src="${pageContext.request.contextPath}/uploads/covers/${item.book.coverImage}" alt="${item.book.title}" style="width: 100%; height: 100%; object-fit: cover;">
                                            </c:if>
                                        </div>
                                        <div style="flex: 1;">
                                            <div style="font-weight: 500;">${item.book.title}</div>
                                            <div style="color: var(--primary-gray); font-size: 14px;">Qty: ${item.quantity}</div>
                                        </div>
                                        <div style="text-align: right;">
                                            <div style="font-weight: 500;">¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${order.items.size() > 3}">
                                <div style="color: var(--primary-gray); padding: 8px 0;">... and ${order.items.size() - 3} more items</div>
                            </c:if>
                            
                            <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 16px; border-top: 1px solid var(--border-gray); margin-top: 16px;">
                                <div>
                                    <span style="color: var(--primary-gray);">Total: </span>
                                    <span style="font-size: 18px; font-weight: 600;">¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                                </div>
                                <div style="display: flex; gap: 12px;">
                                    <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.id}" class="btn btn-sm btn-secondary">View Details</a>
                                    <c:if test="${order.status == 'PENDING'}">
                                        <button onclick="payOrder(${order.id})" class="btn btn-sm btn-primary">Pay Now</button>
                                        <button onclick="cancelOrder(${order.id})" class="btn btn-sm btn-outline">Cancel</button>
                                    </c:if>
                                    <c:if test="${order.status == 'SHIPPED'}">
                                        <button onclick="confirmReceive(${order.id})" class="btn btn-sm btn-primary">Confirm Receipt</button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${pageUtil.totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${pageUtil.hasPrevious()}">
                                <a href="${pageContext.request.contextPath}/order?action=list&page=${pageUtil.pageNum - 1}${not empty status ? '&status='.concat(status) : ''}">
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
                                        <a href="${pageContext.request.contextPath}/order?action=list&page=${i}${not empty status ? '&status='.concat(status) : ''}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${pageUtil.hasNext()}">
                                <a href="${pageContext.request.contextPath}/order?action=list&page=${pageUtil.pageNum + 1}${not empty status ? '&status='.concat(status) : ''}">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="9 18 15 12 9 6"></polyline>
                                    </svg>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-inner">
                <div class="footer-text">© 2026 Online Bookstore. All rights reserved.</div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
