<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Detail - Online Bookstore</title>
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
                </div>
            </div>
        </div>
    </header>

    <section class="section">
        <div class="container">
            <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 32px;">
                <a href="${pageContext.request.contextPath}/order?action=list" style="color: var(--primary-gray);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="15 18 9 12 15 6"></polyline>
                    </svg>
                </a>
                <h1 style="font-size: 24px; font-weight: 600;">Order Detail</h1>
            </div>

            <div style="display: flex; gap: 32px;">
                <div style="flex: 1;">
                    <div class="card" style="margin-bottom: 24px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                            <div>
                                <div style="font-size: 18px; font-weight: 600; margin-bottom: 8px;">Order #${order.orderNo}</div>
                                <div style="color: var(--primary-gray);">
                                    <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </div>
                            </div>
                            <span class="status-badge status-${order.status == 'PENDING' ? 'pending' : order.status == 'PAID' ? 'paid' : order.status == 'SHIPPED' ? 'shipped' : order.status == 'COMPLETED' ? 'completed' : 'cancelled'}" style="font-size: 14px; padding: 8px 16px;">
                                ${order.status == 'PENDING' ? 'Pending Payment' : order.status == 'PAID' ? 'Paid' : order.status == 'SHIPPED' ? 'Shipped' : order.status == 'COMPLETED' ? 'Completed' : 'Cancelled'}
                            </span>
                        </div>
                        
                        <c:if test="${order.status == 'PENDING'}">
                            <div style="display: flex; gap: 12px;">
                                <button onclick="payOrder(${order.id})" class="btn btn-primary">Pay Now</button>
                                <button onclick="cancelOrder(${order.id})" class="btn btn-outline">Cancel Order</button>
                            </div>
                        </c:if>
                        <c:if test="${order.status == 'SHIPPED'}">
                            <button onclick="confirmReceive(${order.id})" class="btn btn-primary">Confirm Receipt</button>
                        </c:if>
                    </div>

                    <div class="card" style="margin-bottom: 24px;">
                        <h3 class="card-title">Shipping Address</h3>
                        <div>
                            <strong>${order.address.receiverName}</strong>
                            <span style="margin-left: 16px; color: var(--primary-gray);">${order.address.phone}</span>
                        </div>
                        <div style="color: var(--secondary-black); margin-top: 8px;">
                            ${order.address.province} ${order.address.city} ${order.address.district} ${order.address.detailAddress}
                        </div>
                    </div>

                    <div class="card">
                        <h3 class="card-title">Order Items</h3>
                        <c:forEach var="item" items="${order.items}" varStatus="st">
                            <div style="display: flex; gap: 16px; padding: 16px 0; ${not st.first ? 'border-top: 1px solid var(--border-gray);' : ''}">
                                <div style="width: 80px; height: 100px; background: var(--light-gray); border-radius: 8px; overflow: hidden; flex-shrink: 0;">
                                    <c:if test="${not empty item.book.coverImage}">
                                        <img src="${pageContext.request.contextPath}/uploads/covers/${item.book.coverImage}" alt="${item.book.title}" style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:if>
                                </div>
                                <div style="flex: 1;">
                                    <a href="${pageContext.request.contextPath}/book?action=detail&id=${item.bookId}" style="font-weight: 500; color: var(--primary-black);">${item.book.title}</a>
                                    <div style="color: var(--primary-gray); font-size: 14px; margin-top: 4px;">${item.book.author}</div>
                                    <div style="color: var(--primary-gray); font-size: 14px; margin-top: 8px;">
                                        ¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/> × ${item.quantity}
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 600;">¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></div>
                                    <c:if test="${order.status == 'COMPLETED' && not item.reviewed}">
                                        <button onclick="showReviewModal(${item.bookId}, '${item.book.title}')" class="btn btn-sm btn-outline" style="margin-top: 12px;">Write Review</button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div style="width: 320px;">
                    <div class="card" style="position: sticky; top: 80px;">
                        <h3 class="card-title">Order Summary</h3>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                            <span style="color: var(--primary-gray);">Subtotal</span>
                            <span>¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                            <span style="color: var(--primary-gray);">Shipping</span>
                            <span>Free</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding-top: 16px; border-top: 1px solid var(--border-gray);">
                            <span style="font-weight: 600;">Total</span>
                            <span style="font-size: 20px; font-weight: 600;">¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                        </div>
                        
                        <c:if test="${order.status == 'PAID' || order.status == 'SHIPPED' || order.status == 'COMPLETED'}">
                            <div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border-gray); font-size: 14px; color: var(--primary-gray);">
                                Last updated: <fmt:formatDate value="${order.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="modal-overlay" id="reviewModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">Write Review</h3>
                <button class="modal-close" onclick="closeReviewModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="reviewForm">
                    <input type="hidden" id="reviewBookId" name="bookId">
                    <div class="form-group">
                        <label class="form-label">Book: <span id="reviewBookTitle"></span></label>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Rating</label>
                        <div id="ratingStars" style="display: flex; gap: 4px;">
                            <c:forEach begin="1" end="5" var="i">
                                <svg class="star" data-rating="${i}" width="28" height="28" viewBox="0 0 24 24" fill="#d2d2d7" style="cursor: pointer;">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                            </c:forEach>
                        </div>
                        <input type="hidden" id="reviewRating" name="rating" value="5">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Review</label>
                        <textarea id="reviewContent" name="content" class="form-control" rows="4" placeholder="Share your thoughts about this book..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Submit Review</button>
                </form>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="container">
            <div class="footer-inner">
                <div class="footer-text">© 2026 Online Bookstore. All rights reserved.</div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        let selectedRating = 5;
        
        function showReviewModal(bookId, bookTitle) {
            document.getElementById('reviewBookId').value = bookId;
            document.getElementById('reviewBookTitle').textContent = bookTitle;
            document.getElementById('reviewContent').value = '';
            selectedRating = 5;
            updateStars(5);
            document.getElementById('reviewModal').classList.add('active');
        }
        
        function closeReviewModal() {
            document.getElementById('reviewModal').classList.remove('active');
        }
        
        function updateStars(rating) {
            document.querySelectorAll('#ratingStars .star').forEach((star, index) => {
                star.setAttribute('fill', index < rating ? '#1d1d1f' : '#d2d2d7');
            });
            document.getElementById('reviewRating').value = rating;
        }
        
        document.querySelectorAll('#ratingStars .star').forEach(star => {
            star.addEventListener('click', function() {
                selectedRating = parseInt(this.dataset.rating);
                updateStars(selectedRating);
            });
            star.addEventListener('mouseenter', function() {
                updateStars(parseInt(this.dataset.rating));
            });
            star.addEventListener('mouseleave', function() {
                updateStars(selectedRating);
            });
        });
        
        document.getElementById('reviewForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const bookId = document.getElementById('reviewBookId').value;
            const rating = document.getElementById('reviewRating').value;
            const content = document.getElementById('reviewContent').value;
            
            if (!content.trim()) {
                alert('Please enter your review');
                return;
            }
            
            submitReview(bookId, rating, content);
            closeReviewModal();
        });
        
        updateStars(5);
    </script>
</body>
</html>
