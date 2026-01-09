package com.bookstore.dao;

import com.bookstore.model.Book;
import com.bookstore.model.Category;
import com.bookstore.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Book data access object
 */
public class BookDAO {
    
    /**
     * Find all books with pagination (for admin - shows all status)
     */
    public List<Book> findAll(int offset, int limit) {
        String sql = "SELECT b.*, c.name as category_name, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN reviews r ON b.id = r.book_id " +
                     "GROUP BY b.id ORDER BY b.created_at DESC LIMIT ?, ?";
        return queryBooks(sql, offset, limit);
    }
    
    /**
     * Find all active books with pagination (for user frontend - only status=1)
     */
    public List<Book> findAllActive(int offset, int limit) {
        String sql = "SELECT b.*, c.name as category_name, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN reviews r ON b.id = r.book_id " +
                     "WHERE b.status = 1 " +
                     "GROUP BY b.id ORDER BY b.created_at DESC LIMIT ?, ?";
        return queryBooks(sql, offset, limit);
    }
    
    /**
     * Find books by category with pagination (for admin - shows all status)
     */
    public List<Book> findByCategory(Integer categoryId, int offset, int limit) {
        String sql = "SELECT b.*, c.name as category_name, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN reviews r ON b.id = r.book_id " +
                     "WHERE b.category_id = ? " +
                     "GROUP BY b.id ORDER BY b.created_at DESC LIMIT ?, ?";
        List<Book> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return books;
    }
    
    /**
     * Find active books by category with pagination (for user frontend - only status=1)
     */
    public List<Book> findActiveByCat(Integer categoryId, int offset, int limit) {
        String sql = "SELECT b.*, c.name as category_name, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN reviews r ON b.id = r.book_id " +
                     "WHERE b.category_id = ? AND b.status = 1 " +
                     "GROUP BY b.id ORDER BY b.created_at DESC LIMIT ?, ?";
        List<Book> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return books;
    }
    
    /**
     * Search books by keyword (for user frontend - only active books)
     */
    public List<Book> search(String keyword, int offset, int limit) {
        String sql = "SELECT b.*, c.name as category_name, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN reviews r ON b.id = r.book_id " +
                     "WHERE (b.title LIKE ? OR b.author LIKE ?) AND b.status = 1 " +
                     "GROUP BY b.id ORDER BY b.created_at DESC LIMIT ?, ?";
        List<Book> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setInt(3, offset);
            ps.setInt(4, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return books;
    }
    
    /**
     * Search books by keyword and category with pagination
     */
    public List<Book> search(String keyword, Integer categoryId, int page, int pageSize) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.*, c.name as category_name, ");
        sql.append("COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count ");
        sql.append("FROM books b ");
        sql.append("LEFT JOIN categories c ON b.category_id = c.id ");
        sql.append("LEFT JOIN reviews r ON b.id = r.book_id ");
        sql.append("WHERE 1=1 ");
        
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasCategory = categoryId != null;
        
        if (hasKeyword) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ?) ");
        }
        if (hasCategory) {
            sql.append("AND b.category_id = ? ");
        }
        
        sql.append("GROUP BY b.id ORDER BY b.created_at DESC LIMIT ?, ?");
        
        List<Book> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (hasKeyword) {
                String pattern = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            if (hasCategory) {
                ps.setInt(paramIndex++, categoryId);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return books;
    }
    
    /**
     * Count search results
     */
    public int countSearch(String keyword, Integer categoryId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM books b WHERE 1=1 ");
        
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasCategory = categoryId != null;
        
        if (hasKeyword) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ?) ");
        }
        if (hasCategory) {
            sql.append("AND b.category_id = ? ");
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (hasKeyword) {
                String pattern = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            if (hasCategory) {
                ps.setInt(paramIndex, categoryId);
            }
            
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
     * Find book by ID
     */
    public Book findById(Integer id) {
        String sql = "SELECT b.*, c.name as category_name, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN reviews r ON b.id = r.book_id " +
                     "WHERE b.id = ? GROUP BY b.id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Find newest books
     */
    public List<Book> findNewest(int limit) {
        String sql = "SELECT b.*, c.name as category_name, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN reviews r ON b.id = r.book_id " +
                     "WHERE b.status = 1 " +
                     "GROUP BY b.id ORDER BY b.created_at DESC LIMIT ?";
        List<Book> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return books;
    }
    
    /**
     * Insert new book
     */
    public boolean insert(Book book) {
        String sql = "INSERT INTO books (title, author, category_id, price, stock, description, cover_image, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setInt(3, book.getCategoryId());
            ps.setBigDecimal(4, book.getPrice());
            ps.setInt(5, book.getStock());
            ps.setString(6, book.getDescription());
            ps.setString(7, book.getCoverImage());
            ps.setInt(8, book.getStatus() != null ? book.getStatus() : 1);  // 默认上架
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    book.setId(keys.getInt(1));
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
     * Update book
     */
    public boolean update(Book book) {
        String sql = "UPDATE books SET title = ?, author = ?, category_id = ?, " +
                     "price = ?, stock = ?, description = ?, cover_image = ?, status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setInt(3, book.getCategoryId());
            ps.setBigDecimal(4, book.getPrice());
            ps.setInt(5, book.getStock());
            ps.setString(6, book.getDescription());
            ps.setString(7, book.getCoverImage());
            ps.setInt(8, book.getStatus() != null ? book.getStatus() : 1);
            ps.setInt(9, book.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Update stock
     */
    public boolean updateStock(Integer bookId, int quantity) {
        String sql = "UPDATE books SET stock = stock - ? WHERE id = ? AND stock >= ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Delete book
     */
    public boolean delete(Integer id) {
        String sql = "DELETE FROM books WHERE id = ?";
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
     * Update book status (enable/disable)
     */
    public boolean updateStatus(Integer id, Integer status) {
        String sql = "UPDATE books SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
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
     * Count all books
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM books";
        return executeCount(sql);
    }
    
    /**
     * Count all active books (for user frontend)
     */
    public int countAllActive() {
        String sql = "SELECT COUNT(*) FROM books WHERE status = 1";
        return executeCount(sql);
    }
    
    /**
     * Find books with low stock
     */
    public List<Book> findLowStock(int threshold, int offset, int limit) {
        String sql = "SELECT b.*, c.name AS category_name FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE b.stock < ? AND b.status = 1 " +
                     "ORDER BY b.stock ASC LIMIT ?, ?";
        List<Book> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, threshold);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return books;
    }
    
    /**
     * Count books by category
     */
    public int countByCategory(Integer categoryId) {
        String sql = "SELECT COUNT(*) FROM books WHERE category_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
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
     * Count active books by category (for user frontend)
     */
    public int countActiveByCat(Integer categoryId) {
        String sql = "SELECT COUNT(*) FROM books WHERE category_id = ? AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
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
     * Count books by search keyword
     */
    public int countBySearch(String keyword) {
        String sql = "SELECT COUNT(*) FROM books WHERE (title LIKE ? OR author LIKE ?) AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
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
    
    private List<Book> queryBooks(String sql, int offset, int limit) {
        List<Book> books = new ArrayList<>();
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
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return books;
    }
    
    private int executeCount(String sql) {
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
    
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setCategoryId(rs.getInt("category_id"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setStock(rs.getInt("stock"));
        book.setDescription(rs.getString("description"));
        book.setCoverImage(rs.getString("cover_image"));
        book.setStatus(rs.getInt("status"));
        book.setCreatedAt(rs.getTimestamp("created_at"));
        book.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Set category
        Category category = new Category();
        category.setId(book.getCategoryId());
        category.setName(rs.getString("category_name"));
        book.setCategory(category);
        
        // Set rating info
        book.setAvgRating(rs.getDouble("avg_rating"));
        book.setReviewCount(rs.getInt("review_count"));
        
        return book;
    }
}
