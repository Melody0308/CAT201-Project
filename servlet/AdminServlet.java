package com.bookstore.servlet;

import com.bookstore.dao.*;
import com.bookstore.model.*;
import com.bookstore.util.JsonUtil;
import com.bookstore.util.PageUtil;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Admin servlet - handles backend management operations
 */
@WebServlet("/admin/manage")
public class AdminServlet extends HttpServlet {
    
    private static final int PAGE_SIZE = 10;
    private UserDAO userDAO = new UserDAO();
    private BookDAO bookDAO = new BookDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private AnnouncementDAO announcementDAO = new AnnouncementDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "dashboard";
        }
        
        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "books":
                listBooks(request, response);
                break;
            case "editBook":
                showEditBook(request, response);
                break;
            case "orders":
                listOrders(request, response);
                break;
            case "users":
                listUsers(request, response);
                break;
            case "categories":
                listCategories(request, response);
                break;
            case "announcements":
                listAnnouncements(request, response);
                break;
            case "getAnnouncement":
                getAnnouncement(request, response);
                break;
            case "orderDetail":
                getOrderDetail(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            JsonUtil.error(response, "Invalid action");
            return;
        }
        
        switch (action) {
            case "addBook":
            case "updateBook":
                saveBook(request, response);
                break;
            case "deleteBook":
                deleteBook(request, response);
                break;
            case "updateBookStatus":
                updateBookStatus(request, response);
                break;
            case "updateOrderStatus":
                updateOrderStatus(request, response);
                break;
            case "shipOrder":
                shipOrder(request, response);
                break;
            case "addCategory":
            case "updateCategory":
                saveCategory(request, response);
                break;
            case "deleteCategory":
                deleteCategory(request, response);
                break;
            case "addAnnouncement":
            case "updateAnnouncement":
                saveAnnouncement(request, response);
                break;
            case "deleteAnnouncement":
                deleteAnnouncement(request, response);
                break;
            case "updateAnnouncementStatus":
                updateAnnouncementStatus(request, response);
                break;
            case "updateUserStatus":
                updateUserStatus(request, response);
                break;
            case "setAdmin":
                setAdmin(request, response);
                break;
            default:
                JsonUtil.error(response, "Invalid action");
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Basic statistics
        int userCount = userDAO.countAll();
        int bookCount = bookDAO.countAll();
        int orderCount = orderDAO.countAll();
        BigDecimal totalSales = orderDAO.getTotalSales();
        
        // Recent orders (last 5)
        List<Order> recentOrders = orderDAO.findAll(0, 5);
        
        // Low stock books (stock < 10)
        List<Book> lowStockBooks = bookDAO.findLowStock(10, 0, 10);
        
        // Order statistics by status
        int pendingCount = orderDAO.countByStatus("PENDING");
        int paidCount = orderDAO.countByStatus("PAID");
        int shippedCount = orderDAO.countByStatus("SHIPPED");
        int completedCount = orderDAO.countByStatus("COMPLETED");
        int cancelledCount = orderDAO.countByStatus("CANCELLED");
        
        request.setAttribute("userCount", userCount);
        request.setAttribute("bookCount", bookCount);
        request.setAttribute("orderCount", orderCount);
        request.setAttribute("totalSales", totalSales);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("lowStockBooks", lowStockBooks);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("paidCount", paidCount);
        request.setAttribute("shippedCount", shippedCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("cancelledCount", cancelledCount);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNum = 1;
        try {
            pageNum = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            // Use default
        }
        
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        List<Book> books;
        int totalCount;
        
        if ((keyword != null && !keyword.trim().isEmpty()) || categoryId != null) {
            // Search with filters
            books = bookDAO.search(keyword, categoryId, pageNum, PAGE_SIZE);
            totalCount = bookDAO.countSearch(keyword, categoryId);
        } else {
            // No filter, show all
            totalCount = bookDAO.countAll();
            books = bookDAO.findAll((pageNum - 1) * PAGE_SIZE, PAGE_SIZE);
        }
        
        PageUtil pageUtil = new PageUtil(pageNum, PAGE_SIZE, totalCount);
        List<Category> categories = categoryDAO.findAll();
        
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("pageUtil", pageUtil);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categoryId", categoryId);
        request.getRequestDispatcher("/admin/books.jsp").forward(request, response);
    }
    
    private void showEditBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Book book = bookDAO.findById(id);
                request.setAttribute("book", book);
            } catch (NumberFormatException e) {
                // New book
            }
        }
        
        request.getRequestDispatcher("/admin/book-edit.jsp").forward(request, response);
    }
    
    private void saveBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            if (!ServletFileUpload.isMultipartContent(request)) {
                JsonUtil.error(response, "Invalid request");
                return;
            }
            
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");
            
            List<FileItem> items = upload.parseRequest(request);
            Map<String, String> params = new HashMap<>();
            String coverImage = null;
            
            for (FileItem item : items) {
                if (item.isFormField()) {
                    params.put(item.getFieldName(), item.getString("UTF-8"));
                } else if (!item.getName().isEmpty()) {
                    // Handle file upload
                    String fileName = item.getName();
                    String ext = fileName.substring(fileName.lastIndexOf("."));
                    String newFileName = UUID.randomUUID().toString() + ext;
                    
                    // Use external directory to persist uploads across deployments
                    // Option 1: Use system property (can be set in Tomcat startup script)
                    String uploadPath = System.getProperty("bookstore.upload.path");
                    
                    // Option 2: Use fixed absolute path (fallback)
                    if (uploadPath == null || uploadPath.isEmpty()) {
                        uploadPath = "E:/bookstore-uploads/covers";  // Change this to your preferred path
                    }
                    
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    File file = new File(uploadDir, newFileName);
                    item.write(file);
                    coverImage = newFileName;
                }
            }
            
            Book book = new Book();
            String idStr = params.get("id");
            if (idStr != null && !idStr.isEmpty()) {
                book.setId(Integer.parseInt(idStr));
                // Keep existing cover if no new one uploaded
                if (coverImage == null) {
                    Book existing = bookDAO.findById(book.getId());
                    if (existing != null) {
                        coverImage = existing.getCoverImage();
                    }
                }
            }
            
            book.setTitle(params.get("title"));
            book.setAuthor(params.get("author"));
            book.setCategoryId(Integer.parseInt(params.get("categoryId")));
            book.setPrice(new BigDecimal(params.get("price")));
            book.setStock(Integer.parseInt(params.get("stock")));
            book.setDescription(params.get("description"));
            book.setCoverImage(coverImage);
            book.setStatus(params.get("status") != null ? Integer.parseInt(params.get("status")) : 1);
            
            boolean success;
            if (book.getId() != null) {
                success = bookDAO.update(book);
            } else {
                success = bookDAO.insert(book);
            }
            
            if (success) {
                // Redirect to books list page
                response.sendRedirect(request.getContextPath() + "/admin/manage?action=books");
            } else {
                // On error, redirect back with error message (could be improved)
                response.sendRedirect(request.getContextPath() + "/admin/manage?action=books&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            JsonUtil.error(response, "Error: " + e.getMessage());
        }
    }
    
    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            JsonUtil.error(response, "Book ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            if (bookDAO.delete(id)) {
                JsonUtil.success(response, "Book deleted successfully");
            } else {
                JsonUtil.error(response, "Failed to delete book");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid book ID");
        }
    }
    
    private void updateBookStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String statusStr = request.getParameter("status");
        
        if (idStr == null || statusStr == null) {
            JsonUtil.error(response, "Book ID and status are required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            int status = Integer.parseInt(statusStr);
            
            if (bookDAO.updateStatus(id, status)) {
                JsonUtil.success(response, status == 1 ? "Book enabled" : "Book disabled");
            } else {
                JsonUtil.error(response, "Failed to update book status");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid parameters");
        }
    }
    
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNum = 1;
        try {
            pageNum = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            // Use default
        }
        
        String status = request.getParameter("status");
        
        List<Order> orders;
        int totalCount;
        
        if (status != null && !status.trim().isEmpty()) {
            orders = orderDAO.findByStatus(status, (pageNum - 1) * PAGE_SIZE, PAGE_SIZE);
            totalCount = orderDAO.countByStatus(status);
        } else {
            totalCount = orderDAO.countAll();
            orders = orderDAO.findAll((pageNum - 1) * PAGE_SIZE, PAGE_SIZE);
        }
        
        PageUtil pageUtil = new PageUtil(pageNum, PAGE_SIZE, totalCount);
        
        request.setAttribute("orders", orders);
        request.setAttribute("pageUtil", pageUtil);
        request.setAttribute("status", status);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }
    
    private void getOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            JsonUtil.error(response, "Order ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Order order = orderDAO.findByIdWithDetails(id);
            if (order != null) {
                JsonUtil.success(response, order);
            } else {
                JsonUtil.error(response, "Order not found");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid order ID");
        }
    }
    
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status");
        
        if (orderIdStr == null || status == null) {
            JsonUtil.error(response, "Order ID and status are required");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            if (orderDAO.updateStatus(orderId, status)) {
                JsonUtil.success(response, "Order status updated successfully");
            } else {
                JsonUtil.error(response, "Failed to update order status");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid order ID");
        }
    }
    
    private void shipOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        
        if (idStr == null) {
            JsonUtil.error(response, "Order ID is required");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(idStr);
            if (orderDAO.updateStatus(orderId, Order.STATUS_SHIPPED)) {
                JsonUtil.success(response, "Order shipped successfully");
            } else {
                JsonUtil.error(response, "Failed to ship order");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid order ID");
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        
        List<User> users;
        if (keyword != null && !keyword.trim().isEmpty()) {
            users = userDAO.search(keyword);
        } else {
            users = userDAO.findAll();
        }
        
        request.setAttribute("users", users);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAllWithBookCount();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }
    
    private void saveCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String sortOrderStr = request.getParameter("sortOrder");
        
        if (name == null || name.isEmpty()) {
            JsonUtil.error(response, "Category name is required");
            return;
        }
        
        Category category = new Category();
        category.setName(name);
        category.setDescription(description);
        category.setSortOrder(sortOrderStr != null && !sortOrderStr.isEmpty() ? 
                              Integer.parseInt(sortOrderStr) : 0);
        
        boolean success;
        if (idStr != null && !idStr.isEmpty()) {
            category.setId(Integer.parseInt(idStr));
            success = categoryDAO.update(category);
        } else {
            success = categoryDAO.insert(category);
        }
        
        if (success) {
            JsonUtil.success(response, "Category saved successfully");
        } else {
            JsonUtil.error(response, "Failed to save category");
        }
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            JsonUtil.error(response, "Category ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            if (categoryDAO.delete(id)) {
                JsonUtil.success(response, "Category deleted successfully");
            } else {
                JsonUtil.error(response, "Failed to delete category (may have associated books)");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid category ID");
        }
    }
    
    private void listAnnouncements(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin should see all announcements (including disabled ones)
        List<Announcement> announcements = announcementDAO.findAllForAdmin();
        request.setAttribute("announcements", announcements);
        request.getRequestDispatcher("/admin/announcements.jsp").forward(request, response);
    }
    
    private void saveAnnouncement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String statusStr = request.getParameter("status");
        String sortOrderStr = request.getParameter("sortOrder");
        
        if (title == null || title.isEmpty()) {
            JsonUtil.error(response, "Announcement title is required");
            return;
        }
        
        Announcement announcement = new Announcement();
        announcement.setTitle(title);
        announcement.setContent(content);
        announcement.setStatus(statusStr != null && !statusStr.isEmpty() ? 
                               Integer.parseInt(statusStr) : 1);
        announcement.setSortOrder(sortOrderStr != null && !sortOrderStr.isEmpty() ? 
                                  Integer.parseInt(sortOrderStr) : 0);
        
        boolean success;
        if (idStr != null && !idStr.isEmpty()) {
            announcement.setId(Integer.parseInt(idStr));
            success = announcementDAO.update(announcement);
        } else {
            success = announcementDAO.insert(announcement);
        }
        
        if (success) {
            JsonUtil.success(response, "Announcement saved successfully");
        } else {
            JsonUtil.error(response, "Failed to save announcement");
        }
    }
    
    private void deleteAnnouncement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            JsonUtil.error(response, "Announcement ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            if (announcementDAO.delete(id)) {
                JsonUtil.success(response, "Announcement deleted successfully");
            } else {
                JsonUtil.error(response, "Failed to delete announcement");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid announcement ID");
        }
    }
    
    private void getAnnouncement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            JsonUtil.error(response, "Announcement ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Announcement announcement = announcementDAO.findById(id);
            if (announcement != null) {
                JsonUtil.success(response, announcement);
            } else {
                JsonUtil.error(response, "Announcement not found");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid announcement ID");
        }
    }
    
    private void updateAnnouncementStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String statusStr = request.getParameter("status");
        
        if (idStr == null || statusStr == null) {
            JsonUtil.error(response, "Announcement ID and status are required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            int status = Integer.parseInt(statusStr);
            if (announcementDAO.updateStatus(id, status)) {
                JsonUtil.success(response, "Announcement status updated successfully");
            } else {
                JsonUtil.error(response, "Failed to update announcement status");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid parameters");
        }
    }
    
    private void updateUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String statusStr = request.getParameter("status");
        
        if (idStr == null || statusStr == null) {
            JsonUtil.error(response, "User ID and status are required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            int status = Integer.parseInt(statusStr);
            if (userDAO.updateStatus(id, status)) {
                JsonUtil.success(response, "User status updated successfully");
            } else {
                JsonUtil.error(response, "Failed to update user status");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid parameters");
        }
    }
    
    private void setAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        
        if (idStr == null) {
            JsonUtil.error(response, "User ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            if (userDAO.setAdmin(id)) {
                JsonUtil.success(response, "User granted admin privileges successfully");
            } else {
                JsonUtil.error(response, "Failed to grant admin privileges");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid user ID");
        }
    }
}
