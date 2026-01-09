<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books - Admin</title>
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
                <a href="${pageContext.request.contextPath}/admin/manage?action=books" class="menu-item active">
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
                <a href="${pageContext.request.contextPath}/admin/manage?action=users" class="menu-item">
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
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
                <h1 style="font-size: 24px; font-weight: 600;">Manage Books</h1>
                <a href="${pageContext.request.contextPath}/admin/manage?action=editBook" class="btn btn-primary">Add New Book</a>
            </div>

            <div class="card" style="margin-bottom: 24px;">
                <form action="${pageContext.request.contextPath}/admin/manage" method="get" style="display: flex; gap: 16px; align-items: center;">
                    <input type="hidden" name="action" value="books">
                    <input type="text" name="keyword" class="form-control" placeholder="Search by title or author..." value="${keyword}" style="flex: 1;">
                    <select name="categoryId" class="form-control" style="width: 200px;">
                        <option value="">All Categories</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-secondary">Search</button>
                </form>
            </div>

            <div class="card">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Cover</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="book" items="${books}">
                            <tr>
                                <td>${book.id}</td>
                                <td>
                                    <div style="width: 50px; height: 65px; background: var(--light-gray); border-radius: 4px; overflow: hidden;">
                                        <c:if test="${not empty book.coverImage}">
                                            <img src="${pageContext.request.contextPath}/uploads/covers/${book.coverImage}" alt="${book.title}" style="width: 100%; height: 100%; object-fit: cover;">
                                        </c:if>
                                    </div>
                                </td>
                                <td style="max-width: 200px;">${book.title}</td>
                                <td>${book.author}</td>
                                <td>${book.category.name}</td>
                                <td>¥<fmt:formatNumber value="${book.price}" pattern="#,##0.00"/></td>
                                <td style="color: ${book.stock <= 10 ? 'var(--error)' : 'inherit'};">${book.stock}</td>
                                <td>
                                    <span class="status-badge ${book.status == 1 ? 'status-completed' : 'status-cancelled'}">
                                        ${book.status == 1 ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="${pageContext.request.contextPath}/admin/manage?action=editBook&id=${book.id}" class="btn btn-sm btn-secondary">Edit</a>
                                        <button onclick="toggleBookStatus(${book.id}, ${book.status})" class="btn btn-sm btn-outline">
                                            ${book.status == 1 ? 'Disable' : 'Enable'}
                                        </button>
                                        <button onclick="deleteBook(${book.id})" class="btn btn-sm btn-outline" style="color: var(--error); border-color: var(--error);">Delete</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${pageUtil.totalPages > 1}">
                    <div class="pagination" style="margin-top: 24px;">
                        <c:if test="${pageUtil.hasPrevious()}">
                            <a href="${pageContext.request.contextPath}/admin/manage?action=books&page=${pageUtil.pageNum - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty categoryId ? '&categoryId='.concat(categoryId) : ''}">
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
                                    <a href="${pageContext.request.contextPath}/admin/manage?action=books&page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty categoryId ? '&categoryId='.concat(categoryId) : ''}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <c:if test="${pageUtil.hasNext()}">
                            <a href="${pageContext.request.contextPath}/admin/manage?action=books&page=${pageUtil.pageNum + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty categoryId ? '&categoryId='.concat(categoryId) : ''}">
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
        function toggleBookStatus(id, currentStatus) {
            const newStatus = currentStatus == 1 ? 0 : 1;
            fetch('${pageContext.request.contextPath}/admin/manage?action=updateBookStatus', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'id=' + id + '&status=' + newStatus
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
        
        function deleteBook(id) {
            if (!confirm('Are you sure you want to delete this book?')) return;
            fetch('${pageContext.request.contextPath}/admin/manage?action=deleteBook', {
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
