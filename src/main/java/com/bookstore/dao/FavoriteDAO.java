package com.bookstore.dao;

import com.bookstore.model.Favorite;
import com.bookstore.model.Book;
import com.bookstore.model.Category;
import com.bookstore.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Favorite data access object
 */
public class FavoriteDAO {
    
    /**
     * Check if user has favorited a book
     */
    public boolean isFavorited(Integer userId, Integer bookId) {
        String sql = "SELECT COUNT(*) FROM favorites WHERE user_id = ? AND book_id = ?";
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
     * Add favorite
     */
    public boolean add(Integer userId, Integer bookId) {
        String sql = "INSERT INTO favorites (user_id, book_id) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Remove favorite
     */
    public boolean remove(Integer userId, Integer bookId) {
        String sql = "DELETE FROM favorites WHERE user_id = ? AND book_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Get user's favorites with book details
     */
    public List<Favorite> findByUserId(Integer userId) {
        String sql = "SELECT f.*, b.id as book_id, b.title, b.author, b.price, b.cover_image, b.stock, " +
                     "c.id as category_id, c.name as category_name " +
                     "FROM favorites f " +
                     "JOIN books b ON f.book_id = b.id " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE f.user_id = ? " +
                     "ORDER BY f.created_at DESC";
        List<Favorite> favorites = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Favorite favorite = new Favorite();
                favorite.setId(rs.getInt("id"));
                favorite.setUserId(rs.getInt("user_id"));
                favorite.setBookId(rs.getInt("book_id"));
                favorite.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Set book details
                Book book = new Book();
                book.setId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setCoverImage(rs.getString("cover_image"));
                book.setStock(rs.getInt("stock"));
                book.setCategoryId(rs.getInt("category_id"));
                
                // Set category
                Category category = new Category();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getString("category_name"));
                book.setCategory(category);
                
                favorite.setBook(book);
                favorites.add(favorite);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return favorites;
    }
}

