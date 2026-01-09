<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - Admin</title>
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
                <a href="${pageContext.request.contextPath}/admin/manage?action=categories" class="menu-item active">
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
                <h1 style="font-size: 24px; font-weight: 600;">Manage Categories</h1>
                <button onclick="showCategoryModal()" class="btn btn-primary">Add Category</button>
            </div>

            <div class="card">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Books Count</th>
                            <th>Sort Order</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cat" items="${categories}">
                            <tr>
                                <td>${cat.id}</td>
                                <td>${cat.name}</td>
                                <td>${cat.description}</td>
                                <td>${cat.bookCount}</td>
                                <td>${cat.sortOrder}</td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <button onclick="editCategory(${cat.id}, '${cat.name}', '${cat.description}', ${cat.sortOrder})" class="btn btn-sm btn-secondary">Edit</button>
                                        <button onclick="deleteCategory(${cat.id})" class="btn btn-sm btn-outline" style="color: var(--error); border-color: var(--error);">Delete</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <div class="modal-overlay" id="categoryModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title" id="categoryModalTitle">Add Category</h3>
                <button class="modal-close" onclick="closeCategoryModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="categoryForm">
                    <input type="hidden" id="categoryId" name="id">
                    <div class="form-group">
                        <label class="form-label">Name *</label>
                        <input type="text" id="categoryName" name="name" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea id="categoryDesc" name="description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Sort Order</label>
                        <input type="number" id="categorySortOrder" name="sortOrder" class="form-control" value="0" min="0">
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Save</button>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        let editingCategoryId = null;
        
        function showCategoryModal() {
            editingCategoryId = null;
            document.getElementById('categoryModalTitle').textContent = 'Add Category';
            document.getElementById('categoryId').value = '';
            document.getElementById('categoryName').value = '';
            document.getElementById('categoryDesc').value = '';
            document.getElementById('categorySortOrder').value = '0';
            document.getElementById('categoryModal').classList.add('active');
        }
        
        function closeCategoryModal() {
            document.getElementById('categoryModal').classList.remove('active');
        }
        
        function editCategory(id, name, description, sortOrder) {
            editingCategoryId = id;
            document.getElementById('categoryModalTitle').textContent = 'Edit Category';
            document.getElementById('categoryId').value = id;
            document.getElementById('categoryName').value = name;
            document.getElementById('categoryDesc').value = description || '';
            document.getElementById('categorySortOrder').value = sortOrder;
            document.getElementById('categoryModal').classList.add('active');
        }
        
        function deleteCategory(id) {
            if (!confirm('Are you sure you want to delete this category?')) return;
            
            fetch('${pageContext.request.contextPath}/admin/manage?action=deleteCategory', {
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
        
        document.getElementById('categoryForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const action = editingCategoryId ? 'updateCategory' : 'addCategory';
            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/admin/manage?action=' + action, {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message);
                }
            });
        });
    </script>
</body>
</html>
