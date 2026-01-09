<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Addresses - Online Bookstore</title>
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
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
                <h1 class="section-title" style="margin: 0;">My Addresses</h1>
                <button onclick="showAddressModal()" class="btn btn-primary">Add New Address</button>
            </div>

            <c:choose>
                <c:when test="${empty addresses}">
                    <div class="card" style="text-align: center; padding: 60px;">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#d2d2d7" stroke-width="1">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                        <p style="margin-top: 16px; color: var(--primary-gray);">No addresses yet</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px;">
                        <c:forEach var="addr" items="${addresses}">
                            <div class="card">
                                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 12px;">
                                    <div>
                                        <strong>${addr.receiverName}</strong>
                                        <span style="margin-left: 12px; color: var(--primary-gray);">${addr.phone}</span>
                                    </div>
                                    <c:if test="${addr.isDefault}">
                                        <span style="padding: 2px 8px; background: var(--primary-black); color: white; border-radius: 4px; font-size: 12px;">Default</span>
                                    </c:if>
                                </div>
                                <div style="color: var(--secondary-black); margin-bottom: 16px;">
                                    ${addr.province} ${addr.city} ${addr.district} ${addr.detailAddress}
                                </div>
                                <div style="display: flex; gap: 12px;">
                                    <button onclick="editAddress(${addr.id})" class="btn btn-sm btn-secondary">Edit</button>
                                    <c:if test="${not addr.isDefault}">
                                        <button onclick="setDefaultAddress(${addr.id})" class="btn btn-sm btn-outline">Set Default</button>
                                    </c:if>
                                    <button onclick="deleteAddress(${addr.id})" class="btn btn-sm btn-outline" style="color: var(--error); border-color: var(--error);">Delete</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <div class="modal-overlay" id="addressModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title" id="addressModalTitle">Add Address</h3>
                <button class="modal-close" onclick="closeAddressModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="addressForm">
                    <input type="hidden" id="addressId" name="id">
                    <div class="form-group">
                        <label class="form-label">Receiver Name</label>
                        <input type="text" id="receiverName" name="receiverName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone</label>
                        <input type="tel" id="addrPhone" name="phone" class="form-control" required>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
                        <div class="form-group">
                            <label class="form-label">Province</label>
                            <input type="text" id="province" name="province" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">City</label>
                            <input type="text" id="city" name="city" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">District</label>
                            <input type="text" id="district" name="district" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Detail Address</label>
                        <input type="text" id="detailAddress" name="detailAddress" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                            <input type="checkbox" id="isDefault" name="isDefault">
                            <span>Set as default address</span>
                        </label>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Save Address</button>
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
        let editingAddressId = null;
        
        function showAddressModal(address) {
            editingAddressId = address ? address.id : null;
            document.getElementById('addressModalTitle').textContent = address ? 'Edit Address' : 'Add Address';
            document.getElementById('addressId').value = address ? address.id : '';
            document.getElementById('receiverName').value = address ? address.receiverName : '';
            document.getElementById('addrPhone').value = address ? address.phone : '';
            document.getElementById('province').value = address ? address.province : '';
            document.getElementById('city').value = address ? address.city : '';
            document.getElementById('district').value = address ? address.district : '';
            document.getElementById('detailAddress').value = address ? address.detailAddress : '';
            document.getElementById('isDefault').checked = address ? address.isDefault : false;
            const modal = document.getElementById('addressModal');
            modal.classList.add('active');
        }
        
        function closeAddressModal() {
            const modal = document.getElementById('addressModal');
            modal.classList.remove('active');
        }
        
        function editAddress(id) {
            fetch('${pageContext.request.contextPath}/address?action=get&id=' + id)
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        showAddressModal(data.data);
                    }
                });
        }
        
        function setDefaultAddress(id) {
            fetch('${pageContext.request.contextPath}/address?action=setDefault', {
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
        
        function deleteAddress(id) {
            if (!confirm('Are you sure you want to delete this address?')) return;
            fetch('${pageContext.request.contextPath}/address?action=delete', {
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
        
        document.getElementById('addressForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const action = editingAddressId ? 'update' : 'add';
            formData.append('action', action);
            
            fetch('${pageContext.request.contextPath}/address?' + new URLSearchParams({action: action}), {
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
