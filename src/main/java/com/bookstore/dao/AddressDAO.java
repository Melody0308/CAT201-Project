package com.bookstore.dao;

import com.bookstore.model.Address;
import com.bookstore.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles user-related operations.
 *
 * Notes:
 * - Reviewed request handling logic
 * - Clarified method responsibilities
 * - Added explanation for future maintenance
 */

/**
 * Address data access object
 */
public class AddressDAO {
    
    /**
     * Find all addresses by user ID
     */
    public List<Address> findByUserId(Integer userId) {
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, created_at DESC";
        List<Address> addresses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                addresses.add(mapResultSetToAddress(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return addresses;
    }
    
    /**
     * Find address by ID
     */
    public Address findById(Integer id) {
        String sql = "SELECT * FROM addresses WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAddress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Find default address by user ID
     */
    public Address findDefaultByUserId(Integer userId) {
        String sql = "SELECT * FROM addresses WHERE user_id = ? AND is_default = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAddress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * Insert new address
     */
    public boolean insert(Address address) {
        String sql = "INSERT INTO addresses (user_id, receiver_name, phone, province, city, district, detail_address, is_default) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            
            // Clear other default addresses if this is default
            if (address.getIsDefault() != null && address.getIsDefault()) {
                clearDefault(conn, address.getUserId());
            }
            
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getReceiverName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getProvince());
            ps.setString(5, address.getCity());
            ps.setString(6, address.getDistrict());
            ps.setString(7, address.getDetailAddress());
            ps.setBoolean(8, address.getIsDefault() != null && address.getIsDefault());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    address.setId(keys.getInt(1));
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
     * Update address
     */
    public boolean update(Address address) {
        String sql = "UPDATE addresses SET receiver_name = ?, phone = ?, province = ?, " +
                     "city = ?, district = ?, detail_address = ?, is_default = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            
            // Clear other default addresses if this is default
            if (address.getIsDefault() != null && address.getIsDefault()) {
                clearDefault(conn, address.getUserId());
            }
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, address.getReceiverName());
            ps.setString(2, address.getPhone());
            ps.setString(3, address.getProvince());
            ps.setString(4, address.getCity());
            ps.setString(5, address.getDistrict());
            ps.setString(6, address.getDetailAddress());
            ps.setBoolean(7, address.getIsDefault() != null && address.getIsDefault());
            ps.setInt(8, address.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * Delete address
     */
    public boolean delete(Integer id) {
        String sql = "DELETE FROM addresses WHERE id = ?";
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
     * Set address as default
     */
    public boolean setDefault(Integer userId, Integer addressId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Clear all default
            clearDefault(conn, userId);
            
            // Set new default
            String sql = "UPDATE addresses SET is_default = 1 WHERE id = ? AND user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            boolean result = ps.executeUpdate() > 0;
            
            conn.commit();
            return result;
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
    
    private void clearDefault(Connection conn, Integer userId) throws SQLException {
        String sql = "UPDATE addresses SET is_default = 0 WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
    
    private Address mapResultSetToAddress(ResultSet rs) throws SQLException {
        Address address = new Address();
        address.setId(rs.getInt("id"));
        address.setUserId(rs.getInt("user_id"));
        address.setReceiverName(rs.getString("receiver_name"));
        address.setPhone(rs.getString("phone"));
        address.setProvince(rs.getString("province"));
        address.setCity(rs.getString("city"));
        address.setDistrict(rs.getString("district"));
        address.setDetailAddress(rs.getString("detail_address"));
        address.setIsDefault(rs.getBoolean("is_default"));
        address.setCreatedAt(rs.getTimestamp("created_at"));
        return address;
    }
}
