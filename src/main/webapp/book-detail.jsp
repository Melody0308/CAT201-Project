<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.title} - Online Bookstore</title>
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
            <div style="display: flex; gap: 48px;">
                <div style="width: 300px; flex-shrink: 0;">
                    <div style="background: var(--light-gray); border-radius: 12px; overflow: hidden; height: 400px; display: flex; align-items: center; justify-content: center;">
                        <c:choose>
                            <c:when test="${not empty book.coverImage}">
                                <img src="${pageContext.request.contextPath}/uploads/covers/${book.coverImage}" alt="${book.title}" style="width: 100%; height: 100%; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <svg width="80" height="80" viewBox="0 0 24 24" fill="#d2d2d7">
                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                </svg>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div style="flex: 1;">
                    <h1 style="font-size: 32px; font-weight: 600; margin-bottom: 8px;">${book.title}</h1>
                    <p style="font-size: 16px; color: var(--primary-gray); margin-bottom: 16px;">${book.author}</p>
                    
                    <c:if test="${book.reviewCount > 0}">
                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 24px;">
                            <c:forEach begin="1" end="5" var="i">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="${i <= book.avgRating ? '#1d1d1f' : '#d2d2d7'}">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                            </c:forEach>
                            <span style="color: var(--primary-gray);">(<fmt:formatNumber value="${book.avgRating}" pattern="#.0"/> / ${book.reviewCount} reviews)</span>
                        </div>
                    </c:if>
                    
                    <div style="font-size: 28px; font-weight: 600; margin-bottom: 16px;">
                        ¥<fmt:formatNumber value="${book.price}" pattern="#,##0.00"/>
                    </div>
                    
                    <div style="margin-bottom: 24px;">
                        <span style="color: var(--primary-gray);">Category: </span>
                        <a href="${pageContext.request.contextPath}/book?action=list&categoryId=${book.categoryId}" style="color: var(--primary-black);">${book.category.name}</a>
                    </div>
                    
                    <div style="margin-bottom: 24px;">
                        <span style="color: ${book.stock > 0 ? 'var(--success)' : 'var(--error)'};">
                            ${book.stock > 0 ? 'In Stock' : 'Out of Stock'} (${book.stock} available)
                        </span>
                    </div>
                    
                    <c:if test="${not empty sessionScope.user}">
                        <div style="margin-bottom: 16px;">
                            <button id="favoriteBtn" onclick="toggleFavoriteBtn()" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 8px;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                                </svg>
                                <span id="favoriteBtnText">Add to Favorites</span>
                            </button>
                        </div>
                    </c:if>
                    
                    <c:if test="${book.stock > 0}">
                        <div style="display: flex; gap: 16px; align-items: center; margin-bottom: 32px;">
                            <div class="quantity-control">
                                <button class="quantity-btn" onclick="changeQty(-1)">-</button>
                                <input type="number" id="quantity" class="quantity-input" value="1" min="1" max="${book.stock}">
                                <button class="quantity-btn" onclick="changeQty(1)">+</button>
                            </div>
                            <button onclick="addToCart(${book.id}, document.getElementById('quantity').value)" class="btn btn-primary btn-lg">
                                Add to Cart
                            </button>
                        </div>
                    </c:if>
                    
                    <div style="border-top: 1px solid var(--border-gray); padding-top: 24px;">
                        <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 12px;">Description</h3>
                        <p style="color: var(--secondary-black); line-height: 1.8;">${book.description}</p>
                    </div>
                </div>
            </div>

            <div style="margin-top: 60px;">
                <h2 class="section-title">Reviews (${book.reviewCount})</h2>
                
                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="card" style="text-align: center; padding: 40px;">
                            <p style="color: var(--primary-gray);">No reviews yet. Be the first to review this book!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviews}">
                            <div class="card" style="margin-bottom: 16px;">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                                    <div>
                                        <strong>${review.user.username}</strong>
                                        <span style="color: var(--primary-gray); margin-left: 12px;">
                                            <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd"/>
                                        </span>
                                    </div>
                                    <div>
                                        <c:forEach begin="1" end="5" var="i">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="${i <= review.rating ? '#1d1d1f' : '#d2d2d7'}">
                                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                            </svg>
                                        </c:forEach>
                                    </div>
                                </div>
                                <p style="color: var(--secondary-black);">${review.content}</p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
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
        <c:if test="${not empty sessionScope.user}">
        updateCartBadge();
        checkFavoriteStatus();
        </c:if>
        
        function changeQty(delta) {
            const input = document.getElementById('quantity');
            let val = parseInt(input.value) + delta;
            if (val < 1) val = 1;
            if (val > ${book.stock}) val = ${book.stock};
            input.value = val;
        }
        
        let isFavorited = false;
        
        function checkFavoriteStatus() {
            fetch('${pageContext.request.contextPath}/favorite?action=check&bookId=${book.id}')
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        isFavorited = data.data;
                        updateFavoriteBtn();
                    }
                });
        }
        
        function updateFavoriteBtn() {
            const btn = document.getElementById('favoriteBtn');
            const text = document.getElementById('favoriteBtnText');
            const svg = btn.querySelector('svg');
            if (isFavorited) {
                text.textContent = 'Favorited';
                svg.setAttribute('fill', 'currentColor');
                btn.style.color = '#ff6b6b';
            } else {
                text.textContent = 'Add to Favorites';
                svg.setAttribute('fill', 'none');
                btn.style.color = '';
            }
        }
        
        function toggleFavoriteBtn() {
            toggleFavorite(${book.id}, isFavorited);
        }
        
        // Override toggleFavorite callback for this page
        const originalToggleFavorite = toggleFavorite;
        toggleFavorite = function(bookId, currentState) {
            const action = currentState ? 'remove' : 'add';
            const formData = new URLSearchParams();
            formData.append('action', action);
            formData.append('bookId', bookId);

            fetch(contextPath + '/favorite', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage(data.message, 'success');
                    isFavorited = !currentState;
                    updateFavoriteBtn();
                } else {
                    showMessage(data.message || 'Failed to update favorite', 'error');
                }
            })
            .catch(error => {
                showMessage('Network error, please try again', 'error');
            });
        };
    </script>
</body>
</html>
