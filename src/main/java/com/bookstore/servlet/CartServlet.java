package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CartDAO;
import com.bookstore.model.Book;
import com.bookstore.model.CartItem;
import com.bookstore.model.User;
import com.bookstore.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Cart servlet - handles shopping cart operations
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    
    private CartDAO cartDAO = new CartDAO();
    private BookDAO bookDAO = new BookDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("list".equals(action) || action == null) {
            showCart(request, response);
        } else if ("count".equals(action)) {
            getCartCount(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            JsonUtil.error(response, "Please login first");
            return;
        }
        
        if (action == null) {
            JsonUtil.error(response, "Invalid action");
            return;
        }
        
        switch (action) {
            case "add":
                addToCart(request, response, user);
                break;
            case "update":
                updateQuantity(request, response, user);
                break;
            case "delete":
                deleteItem(request, response, user);
                break;
            case "check":
                updateChecked(request, response, user);
                break;
            case "checkAll":
                updateAllChecked(request, response, user);
                break;
            default:
                JsonUtil.error(response, "Invalid action");
        }
    }
    
    private void showCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        List<CartItem> cartItems = cartDAO.findByUserId(user.getId());
        
        // Calculate totals
        BigDecimal totalAmount = BigDecimal.ZERO;
        int checkedCount = 0;
        for (CartItem item : cartItems) {
            if (item.getChecked()) {
                totalAmount = totalAmount.add(item.getSubtotal());
                checkedCount++;
            }
        }
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("checkedCount", checkedCount);
        request.getRequestDispatcher("/user/cart.jsp").forward(request, response);
    }
    
    private void getCartCount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        int count = 0;
        if (user != null) {
            count = cartDAO.countByUserId(user.getId());
        }
        
        Map<String, Object> data = new HashMap<>();
        data.put("count", count);
        JsonUtil.success(response, data);
    }
    
    private void addToCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String bookIdStr = request.getParameter("bookId");
        String quantityStr = request.getParameter("quantity");
        
        if (bookIdStr == null || bookIdStr.isEmpty()) {
            JsonUtil.error(response, "Book ID is required");
            return;
        }
        
        int bookId, quantity = 1;
        try {
            bookId = Integer.parseInt(bookIdStr);
            if (quantityStr != null && !quantityStr.isEmpty()) {
                quantity = Integer.parseInt(quantityStr);
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid parameters");
            return;
        }
        
        Book book = bookDAO.findById(bookId);
        if (book == null) {
            JsonUtil.error(response, "Book not found");
            return;
        }
        
        if (book.getStock() < quantity) {
            JsonUtil.error(response, "Insufficient stock");
            return;
        }
        
        // Check if already in cart
        CartItem existingItem = cartDAO.findByUserIdAndBookId(user.getId(), bookId);
        if (existingItem != null) {
            int newQuantity = existingItem.getQuantity() + quantity;
            if (newQuantity > book.getStock()) {
                JsonUtil.error(response, "Insufficient stock");
                return;
            }
            cartDAO.updateQuantity(existingItem.getId(), newQuantity);
        } else {
            CartItem item = new CartItem();
            item.setUserId(user.getId());
            item.setBookId(bookId);
            item.setQuantity(quantity);
            item.setChecked(true);
            cartDAO.insert(item);
        }
        
        int cartCount = cartDAO.countByUserId(user.getId());
        Map<String, Object> data = new HashMap<>();
        data.put("cartCount", cartCount);
        JsonUtil.success(response, data);
    }
    
    private void updateQuantity(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String itemIdStr = request.getParameter("itemId");
        String quantityStr = request.getParameter("quantity");
        
        if (itemIdStr == null || quantityStr == null) {
            JsonUtil.error(response, "Invalid parameters");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            int quantity = Integer.parseInt(quantityStr);
            
            if (quantity <= 0) {
                cartDAO.delete(itemId);
            } else {
                cartDAO.updateQuantity(itemId, quantity);
            }
            
            JsonUtil.success(response, "Updated successfully");
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid parameters");
        }
    }
    
    private void deleteItem(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String itemIdStr = request.getParameter("itemId");
        
        if (itemIdStr == null) {
            JsonUtil.error(response, "Item ID is required");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            cartDAO.delete(itemId);
            JsonUtil.success(response, "Deleted successfully");
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid item ID");
        }
    }
    
    private void updateChecked(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String itemIdStr = request.getParameter("itemId");
        String checkedStr = request.getParameter("checked");
        
        if (itemIdStr == null || checkedStr == null) {
            JsonUtil.error(response, "Invalid parameters");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            boolean checked = Boolean.parseBoolean(checkedStr);
            cartDAO.updateChecked(itemId, checked);
            JsonUtil.success(response, "Updated successfully");
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid parameters");
        }
    }
    
    private void updateAllChecked(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String checkedStr = request.getParameter("checked");
        
        if (checkedStr == null) {
            JsonUtil.error(response, "Invalid parameters");
            return;
        }
        
        boolean checked = Boolean.parseBoolean(checkedStr);
        cartDAO.updateAllChecked(user.getId(), checked);
        JsonUtil.success(response, "Updated successfully");
    }
}
