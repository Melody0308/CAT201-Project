<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Online Bookstore</title>
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
            <div style="display: flex; gap: 32px;">
                <div style="width: 240px;">
                    <div class="card">
                        <div style="text-align: center; padding: 24px 0;">
                            <div style="width: 80px; height: 80px; background: var(--light-gray); border-radius: 50%; margin: 0 auto 16px; display: flex; align-items: center; justify-content: center;">
                                <svg width="40" height="40" viewBox="0 0 24 24" fill="#86868b">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                            </div>
                            <div style="font-size: 18px; font-weight: 600;">${sessionScope.user.username}</div>
                            <div style="color: var(--primary-gray); font-size: 14px; margin-top: 4px;">${sessionScope.user.email}</div>
                        </div>
                        <nav style="border-top: 1px solid var(--border-gray);">
                            <a href="${pageContext.request.contextPath}/user/profile.jsp" class="menu-item active">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                Profile
                            </a>
                            <a href="${pageContext.request.contextPath}/order?action=list" class="menu-item">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                                Orders
                            </a>
                            <a href="${pageContext.request.contextPath}/address?action=list" class="menu-item">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                    <circle cx="12" cy="10" r="3"></circle>
                                </svg>
                                Addresses
                            </a>
                            <a href="${pageContext.request.contextPath}/favorite?action=list" class="menu-item">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                                </svg>
                                Favorites
                            </a>
                            <a href="${pageContext.request.contextPath}/review?action=myReviews" class="menu-item">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                                My Reviews
                            </a>
                            <a href="${pageContext.request.contextPath}/user-servlet?action=logout" class="menu-item" style="color: var(--error);">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                    <polyline points="16 17 21 12 16 7"></polyline>
                                    <line x1="21" y1="12" x2="9" y2="12"></line>
                                </svg>
                                Logout
                            </a>
                        </nav>
                    </div>
                </div>

                <div style="flex: 1;">
                    <div class="card" style="margin-bottom: 24px;">
                        <h3 class="card-title">Profile Information</h3>
                        <form id="profileForm">
                            <div class="form-group">
                                <label class="form-label">Username</label>
                                <input type="text" class="form-control" value="${sessionScope.user.username}" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <input type="email" id="email" name="email" class="form-control" value="${sessionScope.user.email}">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone</label>
                                <input type="tel" id="phone" name="phone" class="form-control" value="${sessionScope.user.phone}" placeholder="Enter phone number">
                            </div>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </form>
                    </div>

                    <div class="card">
                        <h3 class="card-title">Change Password</h3>
                        <form id="passwordForm">
                            <div class="form-group">
                                <label class="form-label">Current Password</label>
                                <input type="password" id="oldPassword" name="oldPassword" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Change Password</button>
                        </form>
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
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phone').value;
            updateProfile(email, phone);
        });
        
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const oldPwd = document.getElementById('oldPassword').value;
            const newPwd = document.getElementById('newPassword').value;
            const confirmPwd = document.getElementById('confirmPassword').value;
            
            if (newPwd !== confirmPwd) {
                alert('New passwords do not match');
                return;
            }
            
            if (newPwd.length < 6) {
                alert('Password must be at least 6 characters');
                return;
            }
            
            changePassword(oldPwd, newPwd);
        });
    </script>
</body>
</html>
