<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - Online Bookstore</title>
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
                    <a href="${pageContext.request.contextPath}/order?action=list" class="icon-btn">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
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
            <h1 class="section-title">Shopping Cart</h1>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="card" style="text-align: center; padding: 60px;">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#d2d2d7" stroke-width="1">
                            <circle cx="9" cy="21" r="1"></circle>
                            <circle cx="20" cy="21" r="1"></circle>
                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                        </svg>
                        <p style="margin-top: 16px; color: var(--primary-gray);">Your cart is empty</p>
                        <a href="${pageContext.request.contextPath}/book?action=list" class="btn btn-primary" style="margin-top: 24px;">Continue Shopping</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: flex; gap: 32px;">
                        <div style="flex: 1;">
                            <div class="card">
                                <div style="padding-bottom: 16px; border-bottom: 1px solid var(--border-gray); margin-bottom: 16px;">
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                        <input type="checkbox" id="selectAll" onchange="checkAllCart(this.checked)" 
                                               ${checkedCount == cartItems.size() ? 'checked' : ''}>
                                        <span>Select All</span>
                                    </label>
                                </div>
                                
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="cart-item">
                                        <input type="checkbox" ${item.checked ? 'checked' : ''} 
                                               onchange="updateCartChecked(${item.id}, this.checked)"
                                               style="margin-top: 40px;">
                                        <div class="cart-item-image">
                                            <c:choose>
                                                <c:when test="${not empty item.book.coverImage}">
                                                    <img src="${pageContext.request.contextPath}/uploads/covers/${item.book.coverImage}" alt="${item.book.title}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="width: 100%; height: 100%; background: var(--light-gray); display: flex; align-items: center; justify-content: center;">
                                                        <svg width="32" height="32" viewBox="0 0 24 24" fill="#d2d2d7">
                                                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                                        </svg>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="cart-item-info">
                                            <a href="${pageContext.request.contextPath}/book?action=detail&id=${item.bookId}" class="cart-item-title">${item.book.title}</a>
                                            <div class="cart-item-author">${item.book.author}</div>
                                            <div class="cart-item-price">¥<fmt:formatNumber value="${item.book.price}" pattern="#,##0.00"/></div>
                                            <div class="quantity-control">
                                                <button class="quantity-btn" onclick="updateCartQuantity(${item.id}, ${item.quantity - 1})">-</button>
                                                <input type="text" class="quantity-input" value="${item.quantity}" readonly>
                                                <button class="quantity-btn" onclick="updateCartQuantity(${item.id}, ${item.quantity + 1})">+</button>
                                            </div>
                                        </div>
                                        <div style="text-align: right;">
                                            <div style="font-size: 18px; font-weight: 600; margin-bottom: 8px;">
                                                ¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                            </div>
                                            <button onclick="deleteCartItem(${item.id})" class="btn btn-sm btn-secondary">Remove</button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <div style="width: 320px;">
                            <div class="card" style="position: sticky; top: 80px;">
                                <h3 class="card-title">Order Summary</h3>
                                <div style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                                    <span style="color: var(--primary-gray);">Selected Items</span>
                                    <span>${checkedCount}</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; padding-top: 16px; border-top: 1px solid var(--border-gray);">
                                    <span style="font-weight: 600;">Total</span>
                                    <span style="font-size: 20px; font-weight: 600;">¥<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></span>
                                </div>
                                <c:if test="${checkedCount > 0}">
                                    <a href="${pageContext.request.contextPath}/order?action=checkout" class="btn btn-primary" style="width: 100%; margin-top: 24px;">
                                        Proceed to Checkout
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
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
