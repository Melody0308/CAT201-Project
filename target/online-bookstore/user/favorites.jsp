<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Favorites - Online Bookstore</title>
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
            <h1 class="section-title">My Favorites</h1>

            <c:choose>
                <c:when test="${empty favorites}">
                    <div class="card" style="text-align: center; padding: 60px;">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#d2d2d7" stroke-width="1" style="margin: 0 auto 16px;">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                        </svg>
                        <div style="color: var(--primary-gray); font-size: 16px; margin-bottom: 24px;">No favorites yet</div>
                        <a href="${pageContext.request.contextPath}/book?action=list" class="btn btn-primary">Browse Books</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="book-grid">
                        <c:forEach var="fav" items="${favorites}">
                            <div class="book-card">
                                <a href="${pageContext.request.contextPath}/book?action=detail&id=${fav.book.id}" class="book-cover">
                                    <c:choose>
                                        <c:when test="${not empty fav.book.coverImage}">
                                            <img src="${pageContext.request.contextPath}/uploads/covers/${fav.book.coverImage}" alt="${fav.book.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: var(--light-gray);">
                                                <svg width="60" height="60" viewBox="0 0 24 24" fill="#d2d2d7">
                                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                                </svg>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="book-info">
                                    <h3 class="book-title">
                                        <a href="${pageContext.request.contextPath}/book?action=detail&id=${fav.book.id}">${fav.book.title}</a>
                                    </h3>
                                    <p class="book-author">${fav.book.author}</p>
                                    <div class="book-footer">
                                        <span class="book-price">¥<fmt:formatNumber value="${fav.book.price}" pattern="#,##0.00"/></span>
                                        <button onclick="removeFavorite(${fav.book.id})" class="btn btn-sm btn-outline" style="color: var(--error);">Remove</button>
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
    <script>
        function removeFavorite(bookId) {
            if (!confirm('Remove this book from favorites?')) return;
            
            const formData = new URLSearchParams();
            formData.append('action', 'remove');
            formData.append('bookId', bookId);
            
            fetch('${pageContext.request.contextPath}/favorite', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Failed to remove favorite');
                }
            })
            .catch(err => {
                alert('Network error, please try again');
            });
        }
    </script>
</body>
</html>

