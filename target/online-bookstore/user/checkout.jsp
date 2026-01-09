<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Online Bookstore</title>
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
                </div>
            </div>
        </div>
    </header>

    <section class="section">
        <div class="container">
            <h1 class="section-title">Checkout</h1>

            <div style="display: flex; gap: 32px;">
                <div style="flex: 1;">
                    <div class="card" style="margin-bottom: 24px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                            <h3 class="card-title" style="margin: 0;">Shipping Address</h3>
                            <a href="${pageContext.request.contextPath}/address?action=list" class="btn btn-sm btn-outline">Manage Addresses</a>
                        </div>
                        
                        <c:choose>
                            <c:when test="${empty addresses}">
                                <p style="color: var(--primary-gray);">No shipping address. Please add one.</p>
                                <a href="${pageContext.request.contextPath}/address?action=list" class="btn btn-primary" style="margin-top: 16px;">Add Address</a>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="addr" items="${addresses}">
                                    <label class="address-option ${addr.isDefault ? 'selected' : ''}" style="display: block; padding: 16px; border: 2px solid ${addr.isDefault ? 'var(--primary-black)' : 'var(--border-gray)'}; border-radius: 8px; margin-bottom: 12px; cursor: pointer;">
                                        <input type="radio" name="addressId" value="${addr.id}" ${addr.isDefault ? 'checked' : ''} style="margin-right: 12px;">
                                        <strong>${addr.receiverName}</strong>
                                        <span style="color: var(--primary-gray); margin-left: 12px;">${addr.phone}</span>
                                        <div style="margin-top: 8px; color: var(--secondary-black);">
                                            ${addr.province} ${addr.city} ${addr.district} ${addr.detailAddress}
                                        </div>
                                        <c:if test="${addr.isDefault}">
                                            <span style="display: inline-block; margin-top: 8px; padding: 2px 8px; background: var(--light-gray); border-radius: 4px; font-size: 12px;">Default</span>
                                        </c:if>
                                    </label>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="card">
                        <h3 class="card-title">Order Items</h3>
                        <c:forEach var="item" items="${cartItems}">
                            <div style="display: flex; gap: 16px; padding: 16px 0; border-bottom: 1px solid var(--border-gray);">
                                <div style="width: 80px; height: 100px; background: var(--light-gray); border-radius: 8px; overflow: hidden; flex-shrink: 0;">
                                    <c:if test="${not empty item.book.coverImage}">
                                        <img src="${pageContext.request.contextPath}/uploads/covers/${item.book.coverImage}" alt="${item.book.title}" style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:if>
                                </div>
                                <div style="flex: 1;">
                                    <div style="font-weight: 500; margin-bottom: 4px;">${item.book.title}</div>
                                    <div style="color: var(--primary-gray); font-size: 14px;">${item.book.author}</div>
                                    <div style="color: var(--primary-gray); font-size: 14px; margin-top: 8px;">Qty: ${item.quantity}</div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 600;">¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div style="width: 320px;">
                    <div class="card" style="position: sticky; top: 80px;">
                        <h3 class="card-title">Order Summary</h3>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                            <span style="color: var(--primary-gray);">Items (${totalQuantity})</span>
                            <span>¥<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                            <span style="color: var(--primary-gray);">Shipping</span>
                            <span>Free</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding-top: 16px; border-top: 1px solid var(--border-gray);">
                            <span style="font-weight: 600;">Total</span>
                            <span style="font-size: 20px; font-weight: 600;">¥<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></span>
                        </div>
                        <c:if test="${not empty addresses}">
                            <button onclick="submitOrder()" class="btn btn-primary" style="width: 100%; margin-top: 24px;">
                                Place Order
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
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
    <script>
        function submitOrder() {
            const addressId = document.querySelector('input[name="addressId"]:checked');
            if (!addressId) {
                alert('Please select a shipping address');
                return;
            }
            createOrder(addressId.value);
        }
    </script>
</body>
</html>
