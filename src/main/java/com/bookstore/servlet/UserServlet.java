package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;
import com.bookstore.util.JsonUtil;
import com.bookstore.util.MD5Util;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * User servlet - handles login, register, logout operations
 */
@WebServlet("/user-servlet")
public class UserServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            JsonUtil.error(response, "Invalid action");
            return;
        }
        
        switch (action) {
            case "login":
                login(request, response);
                break;
            case "register":
                register(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
            case "update":
                updateProfile(request, response);
                break;
            case "changePassword":
                changePassword(request, response);
                break;
            default:
                JsonUtil.error(response, "Invalid action");
        }
    }
    
    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            JsonUtil.error(response, "Username and password are required");
            return;
        }
        
        User user = userDAO.findByUsername(username);
        if (user == null || !MD5Util.verify(password, user.getPassword())) {
            JsonUtil.error(response, "Invalid username or password");
            return;
        }
        
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        
        // Get redirect URL if exists
        String redirectUrl = (String) session.getAttribute("redirectUrl");
        session.removeAttribute("redirectUrl");
        
        if (redirectUrl == null || redirectUrl.isEmpty()) {
            redirectUrl = request.getContextPath() + "/index.jsp";
        }
        
        JsonUtil.success(response, redirectUrl);
    }
    
    private void register(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        if (username == null || password == null || email == null ||
            username.isEmpty() || password.isEmpty() || email.isEmpty()) {
            JsonUtil.error(response, "Username, password and email are required");
            return;
        }
        
        if (username.length() < 3 || username.length() > 20) {
            JsonUtil.error(response, "Username must be 3-20 characters");
            return;
        }
        
        if (password.length() < 6) {
            JsonUtil.error(response, "Password must be at least 6 characters");
            return;
        }
        
        if (userDAO.existsByUsername(username)) {
            JsonUtil.error(response, "Username already exists");
            return;
        }
        
        if (userDAO.existsByEmail(email)) {
            JsonUtil.error(response, "Email already exists");
            return;
        }
        
        User user = new User();
        user.setUsername(username);
        user.setPassword(MD5Util.encrypt(password));
        user.setEmail(email);
        user.setPhone(phone);
        user.setIsAdmin(false);
        
        if (userDAO.insert(user)) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            JsonUtil.success(response, "Registration successful");
        } else {
            JsonUtil.error(response, "Registration failed");
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            JsonUtil.error(response, "Please login first");
            return;
        }
        
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        user.setEmail(email);
        user.setPhone(phone);
        
        if (userDAO.update(user)) {
            session.setAttribute("user", user);
            JsonUtil.success(response, "Profile updated successfully");
        } else {
            JsonUtil.error(response, "Update failed");
        }
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            JsonUtil.error(response, "Please login first");
            return;
        }
        
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        
        if (!MD5Util.verify(oldPassword, user.getPassword())) {
            JsonUtil.error(response, "Current password is incorrect");
            return;
        }
        
        if (newPassword == null || newPassword.length() < 6) {
            JsonUtil.error(response, "New password must be at least 6 characters");
            return;
        }
        
        String encryptedPassword = MD5Util.encrypt(newPassword);
        if (userDAO.updatePassword(user.getId(), encryptedPassword)) {
            user.setPassword(encryptedPassword);
            session.setAttribute("user", user);
            JsonUtil.success(response, "Password changed successfully");
        } else {
            JsonUtil.error(response, "Password change failed");
        }
    }
}
