package com.bookstore.dao;

import com.bookstore.model.Book;
import com.bookstore.model.CartItem;
import com.bookstore.model.Category;
import com.bookstore.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Shopping cart data access object
 */
public class CartDAO {
    
    /**
     * Find all cart items by user ID
     */
    public List<CartItem> findByUserId(Integer userId) {
        String sql = "SELECT ci.*, b.title, b.author, b.price, b.stock, b.cover_image, " +
                     "b.category_id, c.name as category_name " +
                     "FROM cart_items ci " +
                     "JOIN books b ON ci.book_id = b.id " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE ci.user_id = ? ORDER BY ci.created_at DESC";
        List<CartItem> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                items.add(mapResultSetToCartItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return items;
    }
    
    /**
     * Find checked cart items by user ID
     */
    public List<CartItem> findCheckedByUserId(Integer userId) {
        String sql = "SELECT ci.*, b.title, b.author, b.price, b.stock, b.cover_image, " +
                     "b.category_id, c.name as category_name " +
                     "FROM cart_items ci " +
                     "JOIN books b ON ci.book_id = b.id " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE ci.user_id = ? AND ci.checked = 1 ORDER BY ci.created_at DESC";
        List<CartItem> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                items.add(mapResultSetToCartItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return items;
    }
    
    /**
     * Find cart item by user ID and book ID
     */
    public CartItem findByUserIdAndBookId(Integer userId, Integer bookId) {
        String sql = "SELECT ci.*, b.title, b.author, b.price, b.stock, b.cover_image, " +
                     "b.category_id, c.name as category_name " +
                     "FROM cart_items ci " +
                     "JOIN books b ON ci.book_id = b.id " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE ci.user_id = ? AND ci.book_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCartItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Add item to cart
     */
    public boolean insert(CartItem item) {
        String sql = "INSERT INTO cart_items (user_id, book_id, quantity, checked) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, item.getUserId());
            ps.setInt(2, item.getBookId());
            ps.setInt(3, item.getQuantity());
            ps.setBoolean(4, item.getChecked() != null ? item.getChecked() : true);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    item.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Update quantity
     */
    public boolean updateQuantity(Integer id, Integer quantity) {
        String sql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Update checked status
     */
    public boolean updateChecked(Integer id, Boolean checked) {
        String sql = "UPDATE cart_items SET checked = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, checked);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Update all checked status for user
     */
    public boolean updateAllChecked(Integer userId, Boolean checked) {
        String sql = "UPDATE cart_items SET checked = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, checked);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Delete cart item
     */
    public boolean delete(Integer id) {
        String sql = "DELETE FROM cart_items WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Delete checked items for user
     */
    public boolean deleteCheckedByUserId(Integer userId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ? AND checked = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Count cart items for user
     */
    public int countByUserId(Integer userId) {
        String sql = "SELECT COUNT(*) FROM cart_items WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
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
    
    private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setId(rs.getInt("id"));
        item.setUserId(rs.getInt("user_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setChecked(rs.getBoolean("checked"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Set associated book
        Book book = new Book();
        book.setId(item.getBookId());
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setStock(rs.getInt("stock"));
        book.setCoverImage(rs.getString("cover_image"));
        book.setCategoryId(rs.getInt("category_id"));
        
        Category category = new Category();
        category.setId(book.getCategoryId());
        category.setName(rs.getString("category_name"));
        book.setCategory(category);
        
        item.setBook(book);
        return item;
    }
}
