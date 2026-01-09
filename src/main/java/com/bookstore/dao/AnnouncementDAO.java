package com.bookstore.dao;

import com.bookstore.model.Announcement;
import com.bookstore.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Announcement data access object
 */
public class AnnouncementDAO {
    
    /**
     * Find all announcements ordered by sort order (only active ones)
     */
    public List<Announcement> findAll() {
        String sql = "SELECT * FROM announcements WHERE status = 1 ORDER BY sort_order DESC, created_at DESC";
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                announcements.add(mapResultSetToAnnouncement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return announcements;
    }
    
    /**
     * Find all announcements for admin (including disabled ones)
     */
    public List<Announcement> findAllForAdmin() {
        String sql = "SELECT * FROM announcements ORDER BY sort_order DESC, created_at DESC";
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                announcements.add(mapResultSetToAnnouncement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return announcements;
    }
    
    /**
     * Find announcements with pagination
     */
    public List<Announcement> findAll(int offset, int limit) {
        String sql = "SELECT * FROM announcements WHERE status = 1 ORDER BY sort_order DESC, created_at DESC LIMIT ?, ?";
        List<Announcement> announcements = new ArrayList<>();
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
                announcements.add(mapResultSetToAnnouncement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return announcements;
    }
    
    /**
     * Find latest announcement
     */
    public Announcement findLatest() {
        String sql = "SELECT * FROM announcements ORDER BY sort_order DESC, created_at DESC LIMIT 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAnnouncement(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Find announcement by ID
     */
    public Announcement findById(Integer id) {
        String sql = "SELECT * FROM announcements WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAnnouncement(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Insert new announcement
     */
    public boolean insert(Announcement announcement) {
        String sql = "INSERT INTO announcements (title, content, status, sort_order) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, announcement.getTitle());
            ps.setString(2, announcement.getContent());
            ps.setInt(3, announcement.getStatus() != null ? announcement.getStatus() : 1);
            ps.setInt(4, announcement.getSortOrder() != null ? announcement.getSortOrder() : 0);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    announcement.setId(keys.getInt(1));
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
     * Update announcement
     */
    public boolean update(Announcement announcement) {
        String sql = "UPDATE announcements SET title = ?, content = ?, status = ?, sort_order = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, announcement.getTitle());
            ps.setString(2, announcement.getContent());
            ps.setInt(3, announcement.getStatus() != null ? announcement.getStatus() : 1);
            ps.setInt(4, announcement.getSortOrder() != null ? announcement.getSortOrder() : 0);
            ps.setInt(5, announcement.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Delete announcement
     */
    public boolean delete(Integer id) {
        String sql = "DELETE FROM announcements WHERE id = ?";
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
     * Update announcement status
     */
    public boolean updateStatus(Integer id, Integer status) {
        String sql = "UPDATE announcements SET status = ? WHERE id = ?";
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
    
    private Announcement mapResultSetToAnnouncement(ResultSet rs) throws SQLException {
        Announcement announcement = new Announcement();
        announcement.setId(rs.getInt("id"));
        announcement.setTitle(rs.getString("title"));
        announcement.setContent(rs.getString("content"));
        announcement.setStatus(rs.getInt("status"));
        announcement.setSortOrder(rs.getInt("sort_order"));
        announcement.setCreatedAt(rs.getTimestamp("created_at"));
        return announcement;
    }
}
