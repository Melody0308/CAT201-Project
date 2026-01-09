package com.bookstore.dao;

import com.bookstore.model.Review;
import com.bookstore.model.User;
import com.bookstore.model.Book;
import com.bookstore.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Review data access object
 */
public class ReviewDAO {
    
    /**
     * Find reviews by book ID
     */
    public List<Review> findByBookId(Integer bookId) {
        String sql = "SELECT r.*, u.username FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.book_id = ? ORDER BY r.created_at DESC";
        List<Review> reviews = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            rs = ps.executeQuery();
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return reviews;
    }
    
    /**
     * Find reviews by user ID
     */
    public List<Review> findByUserId(Integer userId) {
        String sql = "SELECT r.*, b.title as book_title, b.cover_image " +
                     "FROM reviews r " +
                     "JOIN books b ON r.book_id = b.id " +
                     "WHERE r.user_id = ? " +
                     "ORDER BY r.created_at DESC";
        List<Review> reviews = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setBookId(rs.getInt("book_id"));
                review.setOrderId(rs.getObject("order_id") != null ? rs.getInt("order_id") : null);
                review.setRating(rs.getInt("rating"));
                review.setContent(rs.getString("content"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Set book info
                Book book = new Book();
                book.setId(rs.getInt("book_id"));
                book.setTitle(rs.getString("book_title"));
                book.setCoverImage(rs.getString("cover_image"));
                review.setBook(book);
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return reviews;
    }
    
    /**
     * Check if user has reviewed the book
     */
    public boolean hasReviewed(Integer userId, Integer bookId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND book_id = ?";
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
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return false;
    }
    
    /**
     * Check if user has reviewed the book in a specific order
     */
    public boolean hasReviewedInOrder(Integer userId, Integer bookId, Integer orderId) {
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
    
    /**
     * Insert new review
     */
    public boolean insert(Review review) {
        String sql = "INSERT INTO reviews (user_id, book_id, order_id, rating, content) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getBookId());
            if (review.getOrderId() != null) {
                ps.setInt(3, review.getOrderId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getContent());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    review.setId(keys.getInt(1));
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
     * Delete review
     */
    public boolean delete(Integer id) {
        String sql = "DELETE FROM reviews WHERE id = ?";
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
    
    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getInt("id"));
        review.setUserId(rs.getInt("user_id"));
        review.setBookId(rs.getInt("book_id"));
        review.setOrderId(rs.getObject("order_id") != null ? rs.getInt("order_id") : null);
        review.setRating(rs.getInt("rating"));
        review.setContent(rs.getString("content"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Set username
        String username = rs.getString("username");
        if (username != null) {
            review.setUsername(username);
            User user = new User();
            user.setId(review.getUserId());
            user.setUsername(username);
            review.setUser(user);
        }
        
        return review;
    }
}
