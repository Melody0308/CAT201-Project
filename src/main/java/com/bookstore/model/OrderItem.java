package com.bookstore.model;

import java.math.BigDecimal;

/**
 * Order item entity class
 */
public class OrderItem {
    private Integer id;
    private Integer orderId;
    private Integer bookId;
    private Integer quantity;
    private BigDecimal price;
    
    // Associated object
    private Book book;
    
    // Whether this book has been reviewed
    private Boolean reviewed;

    public OrderItem() {}

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }
    
    public Boolean getReviewed() {
        return reviewed;
    }
    
    public void setReviewed(Boolean reviewed) {
        this.reviewed = reviewed;
    }

    /**
     * Calculate subtotal
     */
    public BigDecimal getSubtotal() {
        if (price != null) {
            return price.multiply(new BigDecimal(quantity));
        }
        return BigDecimal.ZERO;
    }
}
