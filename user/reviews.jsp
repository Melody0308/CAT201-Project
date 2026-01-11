<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reviews - Online Bookstore</title>
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
            <h1 class="section-title">My Reviews</h1>

            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="card" style="text-align: center; padding: 60px;">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#d2d2d7" stroke-width="1" style="margin: 0 auto 16px;">
                            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                        </svg>
                        <div style="color: var(--primary-gray); font-size: 16px; margin-bottom: 24px;">No reviews yet</div>
                        <a href="${pageContext.request.contextPath}/order?action=list" class="btn btn-primary">View Orders</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <c:forEach var="review" items="${reviews}" varStatus="status">
                            <div class="review-item" style="padding: 24px; ${not status.last ? 'border-bottom: 1px solid var(--border-color);' : ''}">
                                <div style="display: flex; gap: 20px;">
                                    <c:if test="${not empty review.book.coverImage}">
                                        <a href="${pageContext.request.contextPath}/book?action=detail&id=${review.book.id}" style="flex-shrink: 0;">
                                            <img src="${pageContext.request.contextPath}/uploads/covers/${review.book.coverImage}" 
                                                 alt="${review.book.title}" 
                                                 style="width: 80px; height: 110px; object-fit: cover; border-radius: 4px;">
                                        </a>
                                    </c:if>
                                    <div style="flex: 1;">
                                        <h3 class="book-title" style="margin-bottom: 8px;">
                                            <a href="${pageContext.request.contextPath}/book?action=detail&id=${review.book.id}">${review.book.title}</a>
                                        </h3>
                                        <div style="display: flex; gap: 4px; margin-bottom: 12px;">
                                            <c:forEach var="i" begin="1" end="5">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="${i <= review.rating ? '#ffb800' : 'none'}" 
                                                     stroke="${i <= review.rating ? '#ffb800' : '#d2d2d7'}" stroke-width="2">
                                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                                </svg>
                                            </c:forEach>
                                            <span style="color: var(--secondary-gray); font-size: 14px; margin-left: 8px;">
                                                <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                            </span>
                                        </div>
                                        <c:if test="${not empty review.content}">
                                            <p style="color: var(--primary-gray); line-height: 1.6;">${review.content}</p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
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

