package com.bookstore.util;

/**
 * Pagination utility class
 */
public class PageUtil {
    
    private int pageNum;      // Current page number
    private int pageSize;     // Items per page
    private int totalCount;   // Total items
    private int totalPages;   // Total pages
    
    public PageUtil(int pageNum, int pageSize, int totalCount) {
        this.pageNum = pageNum;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPages = (int) Math.ceil((double) totalCount / pageSize);
    }
    
    /**
     * Get offset for SQL LIMIT clause
     */
    public int getOffset() {
        return (pageNum - 1) * pageSize;
    }
    
    public boolean hasPrevious() {
        return pageNum > 1;
    }
    
    public boolean hasNext() {
        return pageNum < totalPages;
    }
    
    public int getPageNum() {
        return pageNum;
    }
    
    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }
    
    public int getPageSize() {
        return pageSize;
    }
    
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    
    public int getTotalCount() {
        return totalCount;
    }
    
    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }
    
    public int getTotalPages() {
        return totalPages;
    }
    
    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }
}
