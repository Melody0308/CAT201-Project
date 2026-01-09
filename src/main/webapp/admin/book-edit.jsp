<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty book ? 'Add Book' : 'Edit Book'} - Admin</title>
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
            <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 32px;">
                <a href="${pageContext.request.contextPath}/admin/manage?action=books" style="color: var(--primary-gray);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="15 18 9 12 15 6"></polyline>
                    </svg>
                </a>
                <h1 style="font-size: 24px; font-weight: 600;">${empty book ? 'Add New Book' : 'Edit Book'}</h1>
            </div>

            <div class="card">
                <form action="${pageContext.request.contextPath}/admin/manage?action=${empty book ? 'addBook' : 'updateBook'}" method="post" enctype="multipart/form-data">
                    <c:if test="${not empty book}">
                        <input type="hidden" name="id" value="${book.id}">
                    </c:if>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                        <div class="form-group">
                            <label class="form-label">Title *</label>
                            <input type="text" name="title" class="form-control" value="${book.title}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Author *</label>
                            <input type="text" name="author" class="form-control" value="${book.author}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Category *</label>
                            <select name="categoryId" class="form-control" required>
                                <option value="">Select Category</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${book.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Price *</label>
                            <input type="number" name="price" class="form-control" value="${book.price}" step="0.01" min="0" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Stock *</label>
                            <input type="number" name="stock" class="form-control" value="${empty book ? 0 : book.stock}" min="0" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="4">${book.description}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Cover Image</label>
                        <div style="display: flex; gap: 16px; align-items: start;">
                            <c:if test="${not empty book.coverImage}">
                                <div style="width: 100px; height: 130px; background: var(--light-gray); border-radius: 8px; overflow: hidden;">
                                    <img src="${pageContext.request.contextPath}/uploads/covers/${book.coverImage}" alt="${book.title}" style="width: 100%; height: 100%; object-fit: cover;">
                                </div>
                            </c:if>
                            <input type="file" name="coverFile" class="form-control" accept="image/*" style="flex: 1;">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                            <input type="checkbox" name="status" value="1" ${empty book || book.status == 1 ? 'checked' : ''}>
                            <span>Active (visible in store)</span>
                        </label>
                    </div>
                    
                    <div style="display: flex; gap: 16px;">
                        <button type="submit" class="btn btn-primary">${empty book ? 'Add Book' : 'Save Changes'}</button>
                        <a href="${pageContext.request.contextPath}/admin/manage?action=books" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
