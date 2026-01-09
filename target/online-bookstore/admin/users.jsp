<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-inner">
                <a href="${pageContext.request.contextPath}/admin/manage" class="logo">Admin Panel</a>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/index">Store Front</a>
                </nav>
                <div class="header-actions">
                    <span style="color: var(--primary-gray); margin-right: 16px;">${sessionScope.user.username}</span>
                    <a href="${pageContext.request.contextPath}/user-servlet?action=logout" class="btn btn-sm btn-outline">Logout</a>
                </div>
            </div>
        </div>
    </header>

    <div style="display: flex;">
        <aside class="admin-sidebar">
            <nav>
                <a href="${pageContext.request.contextPath}/admin/manage" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7"></rect>
                        <rect x="14" y="3" width="7" height="7"></rect>
                        <rect x="14" y="14" width="7" height="7"></rect>
                        <rect x="3" y="14" width="7" height="7"></rect>
                    </svg>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=books" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    Books
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=categories" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="8" y1="6" x2="21" y2="6"></line>
                        <line x1="8" y1="12" x2="21" y2="12"></line>
                        <line x1="8" y1="18" x2="21" y2="18"></line>
                        <line x1="3" y1="6" x2="3.01" y2="6"></line>
                        <line x1="3" y1="12" x2="3.01" y2="12"></line>
                        <line x1="3" y1="18" x2="3.01" y2="18"></line>
                    </svg>
                    Categories
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=orders" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                    </svg>
                    Orders
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=users" class="menu-item active">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/manage?action=announcements" class="menu-item">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                    </svg>
                    Announcements
                </a>
            </nav>
        </aside>

        <main class="admin-content">
            <h1 style="font-size: 24px; font-weight: 600; margin-bottom: 32px;">Manage Users</h1>

            <div class="card" style="margin-bottom: 24px;">
                <form action="${pageContext.request.contextPath}/admin/manage" method="get" style="display: flex; gap: 16px; align-items: center;">
                    <input type="hidden" name="action" value="users">
                    <input type="text" name="keyword" class="form-control" placeholder="Search by username or email..." value="${keyword}" style="flex: 1;">
                    <button type="submit" class="btn btn-secondary">Search</button>
                </form>
            </div>

            <div class="card">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Registered</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.id}</td>
                                <td>${u.username}</td>
                                <td>${u.email}</td>
                                <td>${u.phone}</td>
                                <td>
                                    <span class="status-badge ${u.isAdmin ? 'status-paid' : 'status-pending'}">
                                        ${u.isAdmin ? 'Admin' : 'User'}
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge ${u.status == 1 ? 'status-completed' : 'status-cancelled'}">
                                        ${u.status == 1 ? 'Active' : 'Disabled'}
                                    </span>
                                </td>
                                <td><fmt:formatDate value="${u.createdAt}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <c:if test="${u.id != sessionScope.user.id}">
                                            <button onclick="toggleUserStatus(${u.id}, ${u.status})" class="btn btn-sm btn-outline">
                                                ${u.status == 1 ? 'Disable' : 'Enable'}
                                            </button>
                                            <c:if test="${not u.isAdmin}">
                                                <button onclick="setAdmin(${u.id})" class="btn btn-sm btn-secondary">Set Admin</button>
                                            </c:if>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${pageUtil.totalPages > 1}">
                    <div class="pagination" style="margin-top: 24px;">
                        <c:if test="${pageUtil.hasPrevious()}">
                            <a href="${pageContext.request.contextPath}/admin/manage?action=users&page=${pageUtil.pageNum - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}">
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
                                    <a href="${pageContext.request.contextPath}/admin/manage?action=users&page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <c:if test="${pageUtil.hasNext()}">
                            <a href="${pageContext.request.contextPath}/admin/manage?action=users&page=${pageUtil.pageNum + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function toggleUserStatus(id, currentStatus) {
            const action = currentStatus == 1 ? 'disable' : 'enable';
            if (!confirm('Are you sure you want to ' + action + ' this user?')) return;
            
            fetch('${pageContext.request.contextPath}/admin/manage?action=updateUserStatus', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'id=' + id + '&status=' + (currentStatus == 1 ? 0 : 1)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message);
                }
            });
        }
        
        function setAdmin(id) {
            if (!confirm('Are you sure you want to grant admin privileges to this user?')) return;
            
            fetch('${pageContext.request.contextPath}/admin/manage?action=setAdmin', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'id=' + id
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message);
                }
            });
        }
    </script>
</body>
</html>
