package com.bookstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Shopping cart item entity class
 */
public class CartItem {
    private Integer id;
    private Integer userId;
    private Integer bookId;
    private Integer quantity;
    private Boolean checked;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Associated object
    private Book book;

    public CartItem() {
        this.quantity = 1;
        this.checked = true;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
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

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
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

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    /**
     * Calculate subtotal
     */
    public BigDecimal getSubtotal() {
        if (book != null && book.getPrice() != null) {
            return book.getPrice().multiply(new BigDecimal(quantity));
        }
        return BigDecimal.ZERO;
    }
}
