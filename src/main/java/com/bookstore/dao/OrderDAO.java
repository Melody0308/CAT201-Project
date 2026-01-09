package com.bookstore.dao;

import com.bookstore.model.*;
import com.bookstore.util.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Order data access object
 */
public class OrderDAO {
    
    /**
     * Find orders by user ID
     */
    public List<Order> findByUserId(Integer userId) {
        String sql = "SELECT o.*, a.receiver_name, a.phone as addr_phone, a.province, " +
                     "a.city, a.district, a.detail_address " +
                     "FROM orders o " +
                     "LEFT JOIN addresses a ON o.address_id = a.id " +
                     "WHERE o.user_id = ? ORDER BY o.created_at DESC";
        List<Order> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Pass userId to check review status
                order.setOrderItems(findOrderItems(order.getId(), userId));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return orders;
    }
    
    /**
     * Find orders by user ID and status
     */
    public List<Order> findByUserIdAndStatus(Integer userId, String status) {
        String sql = "SELECT o.*, a.receiver_name, a.phone as addr_phone, a.province, " +
                     "a.city, a.district, a.detail_address " +
                     "FROM orders o " +
                     "LEFT JOIN addresses a ON o.address_id = a.id " +
                     "WHERE o.user_id = ? AND o.status = ? ORDER BY o.created_at DESC";
        List<Order> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, status);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Pass userId to check review status
                order.setOrderItems(findOrderItems(order.getId(), userId));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return orders;
    }
    
    /**
     * Find all orders (for admin)
     */
    public List<Order> findAll(int offset, int limit) {
        String sql = "SELECT o.*, a.receiver_name, a.phone as addr_phone, a.province, " +
                     "a.city, a.district, a.detail_address, u.username " +
                     "FROM orders o " +
                     "LEFT JOIN addresses a ON o.address_id = a.id " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.created_at DESC LIMIT ?, ?";
        List<Order> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Set user
                User user = new User();
                user.setId(order.getUserId());
                user.setUsername(rs.getString("username"));
                order.setUser(user);
                order.setOrderItems(findOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return orders;
    }
    
    /**
     * Find order by ID
     */
    public Order findById(Integer id) {
        String sql = "SELECT o.*, a.receiver_name, a.phone as addr_phone, a.province, " +
                     "a.city, a.district, a.detail_address " +
                     "FROM orders o " +
                     "LEFT JOIN addresses a ON o.address_id = a.id " +
                     "WHERE o.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Pass userId to check review status
                order.setOrderItems(findOrderItems(order.getId(), order.getUserId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Find order by ID with full details (including user info)
     */
    public Order findByIdWithDetails(Integer id) {
        String sql = "SELECT o.*, a.receiver_name, a.phone as addr_phone, a.province, " +
                     "a.city, a.district, a.detail_address, u.username " +
                     "FROM orders o " +
                     "LEFT JOIN addresses a ON o.address_id = a.id " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Set user info
                User user = new User();
                user.setId(order.getUserId());
                user.setUsername(rs.getString("username"));
                order.setUser(user);
                order.setOrderItems(findOrderItems(order.getId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Find order by order number
     */
    public Order findByOrderNo(String orderNo) {
        String sql = "SELECT o.*, a.receiver_name, a.phone as addr_phone, a.province, " +
                     "a.city, a.district, a.detail_address " +
                     "FROM orders o " +
                     "LEFT JOIN addresses a ON o.address_id = a.id " +
                     "WHERE o.order_no = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, orderNo);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderItems(findOrderItems(order.getId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Create order with items (transaction)
     */
    public boolean createOrder(Order order, List<OrderItem> items) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Insert order
            String orderSql = "INSERT INTO orders (order_no, user_id, address_id, total_amount, status) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, order.getOrderNo());
            ps.setInt(2, order.getUserId());
            ps.setInt(3, order.getAddressId());
            ps.setBigDecimal(4, order.getTotalAmount());
            ps.setString(5, order.getStatus());
            ps.executeUpdate();
            
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                order.setId(keys.getInt(1));
            }
            ps.close();
            
            // Insert order items and update stock
            String itemSql = "INSERT INTO order_items (order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
            String stockSql = "UPDATE books SET stock = stock - ? WHERE id = ? AND stock >= ?";
            
            for (OrderItem item : items) {
                // Insert order item
                ps = conn.prepareStatement(itemSql);
                ps.setInt(1, order.getId());
                ps.setInt(2, item.getBookId());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getPrice());
                ps.executeUpdate();
                ps.close();
                
                // Update stock
                ps = conn.prepareStatement(stockSql);
                ps.setInt(1, item.getQuantity());
                ps.setInt(2, item.getBookId());
                ps.setInt(3, item.getQuantity());
                int updated = ps.executeUpdate();
                ps.close();
                
                if (updated == 0) {
                    conn.rollback();
                    return false; // Insufficient stock
                }
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Cancel order and restore stock (transaction)
     */
    public boolean cancelOrder(Integer orderId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Get order items
            String selectSql = "SELECT book_id, quantity FROM order_items WHERE order_id = ?";
            ps = conn.prepareStatement(selectSql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            
            List<OrderItem> items = new ArrayList<>();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                items.add(item);
            }
            rs.close();
            ps.close();
            
            // Restore stock for each item
            String stockSql = "UPDATE books SET stock = stock + ? WHERE id = ?";
            for (OrderItem item : items) {
                ps = conn.prepareStatement(stockSql);
                ps.setInt(1, item.getQuantity());
                ps.setInt(2, item.getBookId());
                ps.executeUpdate();
                ps.close();
            }
            
            // Update order status
            String statusSql = "UPDATE orders SET status = ? WHERE id = ?";
            ps = conn.prepareStatement(statusSql);
            ps.setString(1, Order.STATUS_CANCELLED);
            ps.setInt(2, orderId);
            ps.executeUpdate();
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.close(conn, ps, rs);
        }
        return false;
    }
    
    /**
     * Update order status
     */
    public boolean updateStatus(Integer orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Count all orders
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM orders";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }
    
    /**
     * Find orders by status with pagination
     */
    public List<Order> findByStatus(String status, int offset, int limit) {
        String sql = "SELECT o.*, a.receiver_name, a.phone as addr_phone, a.province, " +
                     "a.city, a.district, a.detail_address, u.username " +
                     "FROM orders o " +
                     "LEFT JOIN addresses a ON o.address_id = a.id " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.status = ? " +
                     "ORDER BY o.created_at DESC LIMIT ?, ?";
        List<Order> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Set user
                User user = new User();
                user.setUsername(rs.getString("username"));
                order.setUser(user);
                // Set address
                Address address = new Address();
                address.setReceiverName(rs.getString("receiver_name"));
                address.setPhone(rs.getString("addr_phone"));
                address.setProvince(rs.getString("province"));
                address.setCity(rs.getString("city"));
                address.setDistrict(rs.getString("district"));
                address.setDetailAddress(rs.getString("detail_address"));
                order.setAddress(address);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return orders;
    }
    
    /**
     * Count orders by status
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }
    
    /**
     * Get total sales amount
     */
    public BigDecimal getTotalSales() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Find order items by order ID
     */
    private List<OrderItem> findOrderItems(Integer orderId) {
        return findOrderItems(orderId, null);
    }
    
    private List<OrderItem> findOrderItems(Integer orderId, Integer userId) {
        String sql = "SELECT oi.*, b.title, b.author, b.cover_image " +
                     "FROM order_items oi " +
                     "JOIN books b ON oi.book_id = b.id " +
                     "WHERE oi.order_id = ?";
        List<OrderItem> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                
                Book book = new Book();
                book.setId(item.getBookId());
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setCoverImage(rs.getString("cover_image"));
                item.setBook(book);
                
                // Check if reviewed in this order (if userId provided)
                if (userId != null) {
                    item.setReviewed(hasReviewedInOrder(userId, item.getBookId(), orderId));
                } else {
                    item.setReviewed(false);
                }
                
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return items;
    }
    
    private boolean hasReviewedInOrder(Integer userId, Integer bookId, Integer orderId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND book_id = ? AND order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, orderId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return false;
    }
    
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNo(rs.getString("order_no"));
        order.setUserId(rs.getInt("user_id"));
        order.setAddressId(rs.getInt("address_id"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Set address
        Address address = new Address();
        address.setId(order.getAddressId());
        address.setReceiverName(rs.getString("receiver_name"));
        address.setPhone(rs.getString("addr_phone"));
        address.setProvince(rs.getString("province"));
        address.setCity(rs.getString("city"));
        address.setDistrict(rs.getString("district"));
        address.setDetailAddress(rs.getString("detail_address"));
        order.setAddress(address);
        
        return order;
    }
}
