<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Online Bookstore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-inner">
                <a href="${pageContext.request.contextPath}/index" class="logo">Bookstore</a>
            </div>
        </div>
    </header>

    <div class="auth-container">
        <div class="auth-box">
            <h1 class="auth-title">Sign In</h1>
            <div id="errorMsg" class="message message-error" style="display: none;"></div>
            <form id="loginForm">
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-input" required placeholder="Enter your username">
                </div>
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-input" required placeholder="Enter your password">
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%;">Sign In</button>
            </form>
            <div class="auth-switch">
                Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Sign Up</a>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            formData.append('action', 'login');
            
            fetch('${pageContext.request.contextPath}/user-servlet', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = data.data || '${pageContext.request.contextPath}/index';
                } else {
                    document.getElementById('errorMsg').textContent = data.message;
                    document.getElementById('errorMsg').style.display = 'block';
                }
            })
            .catch(error => {
                document.getElementById('errorMsg').textContent = 'Network error, please try again';
                document.getElementById('errorMsg').style.display = 'block';
            });
        });
    </script>
</body>
</html>
