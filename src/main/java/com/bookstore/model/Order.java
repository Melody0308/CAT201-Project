package com.bookstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * Order entity class
 */
public class Order {
    private Integer id;
    private String orderNo;
    private Integer userId;
    private Integer addressId;
    private BigDecimal totalAmount;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Associated objects
    private User user;
    private Address address;
    private List<OrderItem> orderItems;

    // Order status constants
    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_PAID = "PAID";
    public static final String STATUS_SHIPPED = "SHIPPED";
    public static final String STATUS_COMPLETED = "COMPLETED";
    public static final String STATUS_CANCELLED = "CANCELLED";

    public Order() {}

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    /**
     * Alias for getOrderItems() - for JSP EL convenience
     */
    public List<OrderItem> getItems() {
        return orderItems;
    }

    /**
     * Get status display text
     */
    public String getStatusText() {
        switch (status) {
            case STATUS_PENDING: return "Pending Payment";
            case STATUS_PAID: return "Paid";
            case STATUS_SHIPPED: return "Shipped";
            case STATUS_COMPLETED: return "Completed";
            case STATUS_CANCELLED: return "Cancelled";
            default: return "Unknown";
        }
    }
}
