<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Online Bookstore</title>
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
            <h1 class="auth-title">Create Account</h1>
            <div id="errorMsg" class="message message-error" style="display: none;"></div>
            <form id="registerForm">
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-input" required placeholder="3-20 characters">
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input" required placeholder="your@email.com">
                </div>
                <div class="form-group">
                    <label class="form-label">Phone (Optional)</label>
                    <input type="text" name="phone" class="form-input" placeholder="Phone number">
                </div>
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-input" required placeholder="At least 6 characters">
                </div>
                <div class="form-group">
                    <label class="form-label">Confirm Password</label>
                    <input type="password" name="confirmPassword" class="form-input" required placeholder="Confirm your password">
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%;">Create Account</button>
            </form>
            <div class="auth-switch">
                Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Sign In</a>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            
            if (formData.get('password') !== formData.get('confirmPassword')) {
                document.getElementById('errorMsg').textContent = 'Passwords do not match';
                document.getElementById('errorMsg').style.display = 'block';
                return;
            }
            
            formData.append('action', 'register');
            
            fetch('${pageContext.request.contextPath}/user-servlet', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = '${pageContext.request.contextPath}/index';
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
