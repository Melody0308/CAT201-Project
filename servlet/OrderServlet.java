package com.bookstore.servlet;

import com.bookstore.dao.AddressDAO;
import com.bookstore.dao.CartDAO;
import com.bookstore.dao.OrderDAO;
import com.bookstore.model.*;
import com.bookstore.util.JsonUtil;
import com.bookstore.util.OrderNoUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Order servlet - handles order creation and management
 */
@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private CartDAO cartDAO = new CartDAO();
    private AddressDAO addressDAO = new AddressDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listOrders(request, response, user);
                break;
            case "detail":
                showDetail(request, response, user);
                break;
            case "checkout":
                showCheckout(request, response, user);
                break;
            default:
                listOrders(request, response, user);
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
            case "create":
                createOrder(request, response, user);
                break;
            case "cancel":
                cancelOrder(request, response, user);
                break;
            case "confirm":
                confirmOrder(request, response, user);
                break;
            case "pay":
                payOrder(request, response, user);
                break;
            default:
                JsonUtil.error(response, "Invalid action");
        }
    }
    
    private void listOrders(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        List<Order> orders;
        
        if (status != null && !status.isEmpty()) {
            // Filter by status
            orders = orderDAO.findByUserIdAndStatus(user.getId(), status);
        } else {
            // Get all orders
            orders = orderDAO.findByUserId(user.getId());
        }
        
        request.setAttribute("orders", orders);
        request.setAttribute("status", status);
        request.getRequestDispatcher("/user/orders.jsp").forward(request, response);
    }
    
    private void showDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Order order = orderDAO.findById(id);
            
            if (order == null || !order.getUserId().equals(user.getId())) {
                response.sendRedirect(request.getContextPath() + "/order?action=list");
                return;
            }
            
            request.setAttribute("order", order);
            request.getRequestDispatcher("/user/order-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/order?action=list");
        }
    }
    
    private void showCheckout(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<CartItem> checkedItems = cartDAO.findCheckedByUserId(user.getId());
        
        if (checkedItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?action=list");
            return;
        }
        
        List<Address> addresses = addressDAO.findByUserId(user.getId());
        Address defaultAddress = addressDAO.findDefaultByUserId(user.getId());
        
        // Calculate total
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : checkedItems) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }
        
        request.setAttribute("cartItems", checkedItems);
        request.setAttribute("addresses", addresses);
        request.setAttribute("defaultAddress", defaultAddress);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/user/checkout.jsp").forward(request, response);
    }
    
    private void createOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String addressIdStr = request.getParameter("addressId");
        
        if (addressIdStr == null || addressIdStr.isEmpty()) {
            JsonUtil.error(response, "Please select a shipping address");
            return;
        }
        
        int addressId;
        try {
            addressId = Integer.parseInt(addressIdStr);
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid address");
            return;
        }
        
        // Verify address belongs to user
        Address address = addressDAO.findById(addressId);
        if (address == null || !address.getUserId().equals(user.getId())) {
            JsonUtil.error(response, "Invalid address");
            return;
        }
        
        // Get checked cart items
        List<CartItem> checkedItems = cartDAO.findCheckedByUserId(user.getId());
        if (checkedItems.isEmpty()) {
            JsonUtil.error(response, "Cart is empty");
            return;
        }
        
        // Calculate total and prepare order items
        BigDecimal totalAmount = BigDecimal.ZERO;
        List<OrderItem> orderItems = new ArrayList<>();
        
        for (CartItem cartItem : checkedItems) {
            if (cartItem.getQuantity() > cartItem.getBook().getStock()) {
                JsonUtil.error(response, "Insufficient stock for: " + cartItem.getBook().getTitle());
                return;
            }
            
            OrderItem orderItem = new OrderItem();
            orderItem.setBookId(cartItem.getBookId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(cartItem.getBook().getPrice());
            orderItems.add(orderItem);
            
            totalAmount = totalAmount.add(cartItem.getSubtotal());
        }
        
        // Create order
        Order order = new Order();
        order.setOrderNo(OrderNoUtil.generate());
        order.setUserId(user.getId());
        order.setAddressId(addressId);
        order.setTotalAmount(totalAmount);
        order.setStatus(Order.STATUS_PENDING);
        
        if (orderDAO.createOrder(order, orderItems)) {
            // Clear checked items from cart
            cartDAO.deleteCheckedByUserId(user.getId());
            JsonUtil.success(response, order.getOrderNo());
        } else {
            JsonUtil.error(response, "Failed to create order. Please check stock availability.");
        }
    }
    
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr == null) {
            JsonUtil.error(response, "Order ID is required");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.findById(orderId);
            
            if (order == null || !order.getUserId().equals(user.getId())) {
                JsonUtil.error(response, "Order not found");
                return;
            }
            
            if (!Order.STATUS_PENDING.equals(order.getStatus())) {
                JsonUtil.error(response, "This order cannot be cancelled");
                return;
            }
            
            if (orderDAO.cancelOrder(orderId)) {
                JsonUtil.success(response, "Order cancelled successfully");
            } else {
                JsonUtil.error(response, "Failed to cancel order");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid order ID");
        }
    }
    
    private void confirmOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr == null) {
            JsonUtil.error(response, "Order ID is required");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.findById(orderId);
            
            if (order == null || !order.getUserId().equals(user.getId())) {
                JsonUtil.error(response, "Order not found");
                return;
            }
            
            if (!Order.STATUS_SHIPPED.equals(order.getStatus())) {
                JsonUtil.error(response, "This order cannot be confirmed");
                return;
            }
            
            if (orderDAO.updateStatus(orderId, Order.STATUS_COMPLETED)) {
                JsonUtil.success(response, "Order confirmed successfully");
            } else {
                JsonUtil.error(response, "Failed to confirm order");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid order ID");
        }
    }
    
    private void payOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr == null) {
            JsonUtil.error(response, "Order ID is required");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.findById(orderId);
            
            if (order == null || !order.getUserId().equals(user.getId())) {
                JsonUtil.error(response, "Order not found");
                return;
            }
            
            if (!Order.STATUS_PENDING.equals(order.getStatus())) {
                JsonUtil.error(response, "This order cannot be paid");
                return;
            }
            
            // Simulate payment success
            if (orderDAO.updateStatus(orderId, Order.STATUS_PAID)) {
                JsonUtil.success(response, "Payment successful");
            } else {
                JsonUtil.error(response, "Payment failed");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid order ID");
        }
    }
}
