<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Bookstore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-inner">
                <a href="${pageContext.request.contextPath}/index" class="logo">Bookstore</a>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/index" class="active">Home</a>
                    <a href="${pageContext.request.contextPath}/book?action=list">Books</a>
                    <c:if test="${not empty sessionScope.user && sessionScope.user.isAdmin}">
                        <a href="${pageContext.request.contextPath}/admin/manage">Admin</a>
                    </c:if>
                </nav>
                <div class="header-actions">
                    <form action="${pageContext.request.contextPath}/book" method="get" class="search-box">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" placeholder="Search books...">
                        <button type="submit">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="11" cy="11" r="8"></circle>
                                <path d="m21 21-4.35-4.35"></path>
                            </svg>
                        </button>
                    </form>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/cart?action=list" class="icon-btn">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="9" cy="21" r="1"></circle>
                                    <circle cx="20" cy="21" r="1"></circle>
                                    <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                                </svg>
                                <span class="cart-badge" id="cartBadge">0</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/order?action=list" class="icon-btn">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                </svg>
                            </a>
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

    <!-- Announcement Banner -->
    <c:if test="${not empty announcements}">
        <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 0; overflow: hidden; position: relative;">
            <div class="container" style="position: relative;">
                <div id="announcementSlider" style="display: flex; transition: transform 0.5s ease;">
                    <c:forEach var="ann" items="${announcements}">
                        <div style="min-width: 100%; padding: 16px 60px; text-align: center; box-sizing: border-box;">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display: inline-block; vertical-align: middle; margin-right: 8px;">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <strong style="font-weight: 600;">${ann.title}</strong>
                            <c:if test="${not empty ann.content}">
                                <span style="margin-left: 8px; opacity: 0.95;">- ${ann.content}</span>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
                <c:if test="${fn:length(announcements) > 1}">
                    <button onclick="prevAnnouncement()" style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); background: rgba(255,255,255,0.2); border: none; color: white; width: 36px; height: 36px; border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background 0.3s;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="15 18 9 12 15 6"></polyline>
                        </svg>
                    </button>
                    <button onclick="nextAnnouncement()" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: rgba(255,255,255,0.2); border: none; color: white; width: 36px; height: 36px; border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background 0.3s;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </button>
                </c:if>
            </div>
        </div>
    </c:if>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Discover Your Next Read</h1>
            <p>Explore our curated collection of books across all genres. Find your perfect book today.</p>
            <a href="${pageContext.request.contextPath}/book?action=list" class="btn btn-primary btn-lg">Browse Books</a>
        </div>
    </section>

    <!-- Categories -->
    <section class="section">
        <div class="container">
            <h2 class="section-title">Categories</h2>
            <div class="category-list">
                <a href="${pageContext.request.contextPath}/book?action=list" class="category-item active">All</a>
                <c:forEach var="category" items="${categories}">
                    <a href="${pageContext.request.contextPath}/book?action=list&categoryId=${category.id}" class="category-item">${category.name}</a>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- New Arrivals -->
    <section class="section" style="background: var(--light-gray);">
        <div class="container">
            <h2 class="section-title">New Arrivals</h2>
            <div class="book-grid">
                <c:forEach var="book" items="${newBooks}">
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
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-inner">
                <div class="footer-text">© 2026 Online Bookstore. All rights reserved.</div>
                <div class="footer-text">Powered by Servlet + JSP</div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        // Update cart badge
        <c:if test="${not empty sessionScope.user}">
        updateCartBadge();
        </c:if>

        // Announcement slider
        let currentAnnouncementIndex = 0;
        const announcementCount = ${not empty announcements ? fn:length(announcements) : 0};
        
        function updateAnnouncementSlider() {
            const slider = document.getElementById('announcementSlider');
            if (slider) {
                slider.style.transform = 'translateX(-' + (currentAnnouncementIndex * 100) + '%)';
            }
        }
        
        function nextAnnouncement() {
            currentAnnouncementIndex = (currentAnnouncementIndex + 1) % announcementCount;
            updateAnnouncementSlider();
        }
        
        function prevAnnouncement() {
            currentAnnouncementIndex = (currentAnnouncementIndex - 1 + announcementCount) % announcementCount;
            updateAnnouncementSlider();
        }
        
        // Auto-rotate announcements every 5 seconds
        if (announcementCount > 1) {
            setInterval(nextAnnouncement, 5000);
        }
    </script>
</body>
</html>
