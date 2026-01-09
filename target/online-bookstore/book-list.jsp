<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Books - Online Bookstore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-inner">
                <a href="${pageContext.request.contextPath}/index" class="logo">Bookstore</a>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/index">Home</a>
                    <a href="${pageContext.request.contextPath}/book?action=list" class="active">Books</a>
                    <c:if test="${not empty sessionScope.user && sessionScope.user.isAdmin}">
                        <a href="${pageContext.request.contextPath}/admin/manage">Admin</a>
                    </c:if>
                </nav>
                <div class="header-actions">
                    <form action="${pageContext.request.contextPath}/book" method="get" class="search-box">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" placeholder="Search books..." value="${keyword}">
                        <button type="submit">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="11" cy="11" r="8"></circle>
                                <path d="m21 21-4.35-4.35"></path>
                            </svg>
                        </button>
                    </form>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/cart?action=list" class="icon-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="9" cy="21" r="1"></circle>
                                <circle cx="20" cy="21" r="1"></circle>
                                <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                            </svg>
                            <span class="cart-badge" id="cartBadge">0</span>
                        </a>
                    </c:if>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/user/profile.jsp" class="icon-btn">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-sm btn-outline">Login</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <section class="section">
        <div class="container">
            <c:if test="${not empty keyword}">
                <h2 class="section-title">Search results for "${keyword}"</h2>
            </c:if>
            
            <div class="category-list">
                <a href="${pageContext.request.contextPath}/book?action=list" 
                   class="category-item ${empty currentCategory ? 'active' : ''}">All</a>
                <c:forEach var="category" items="${categories}">
                    <a href="${pageContext.request.contextPath}/book?action=list&categoryId=${category.id}" 
                       class="category-item ${currentCategory == category.id ? 'active' : ''}">${category.name}</a>
                </c:forEach>
            </div>

            <c:choose>
                <c:when test="${empty books}">
                    <div style="text-align: center; padding: 60px 0; color: #86868b;">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                        <p style="margin-top: 16px;">No books found</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="book-grid">
                        <c:forEach var="book" items="${books}">
                            <a href="${pageContext.request.contextPath}/book?action=detail&id=${book.id}" class="book-card">
                                <div class="book-cover">
                                    <c:choose>
                                        <c:when test="${not empty book.coverImage}">
                                            <img src="${pageContext.request.contextPath}/uploads/covers/${book.coverImage}" alt="${book.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="placeholder">
                                                <svg width="48" height="48" viewBox="0 0 24 24" fill="currentColor">
                                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                                </svg>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="book-info">
                                    <div class="book-title">${book.title}</div>
                                    <div class="book-author">${book.author}</div>
                                    <div class="book-price">¥<fmt:formatNumber value="${book.price}" pattern="#,##0.00"/></div>
                                    <c:if test="${book.reviewCount > 0}">
                                        <div class="book-rating">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                            </svg>
                                            <fmt:formatNumber value="${book.avgRating}" pattern="#.0"/> (${book.reviewCount})
                                        </div>
                                    </c:if>
                                </div>
                            </a>
                        </c:forEach>
                    </div>

                    <c:if test="${pageUtil.totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${pageUtil.hasPrevious()}">
                                <a href="${pageContext.request.contextPath}/book?action=${not empty keyword ? 'search' : 'list'}&page=${pageUtil.pageNum - 1}${not empty currentCategory ? '&categoryId='.concat(currentCategory) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}">
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
                                        <a href="${pageContext.request.contextPath}/book?action=${not empty keyword ? 'search' : 'list'}&page=${i}${not empty currentCategory ? '&categoryId='.concat(currentCategory) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${pageUtil.hasNext()}">
                                <a href="${pageContext.request.contextPath}/book?action=${not empty keyword ? 'search' : 'list'}&page=${pageUtil.pageNum + 1}${not empty currentCategory ? '&categoryId='.concat(currentCategory) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}">
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
    <script>
        <c:if test="${not empty sessionScope.user}">
        updateCartBadge();
        </c:if>
    </script>
</body>
</html>
