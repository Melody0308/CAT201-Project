package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CategoryDAO;
import com.bookstore.dao.ReviewDAO;
import com.bookstore.model.Book;
import com.bookstore.model.Category;
import com.bookstore.model.Review;
import com.bookstore.util.PageUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Book servlet - handles book listing, search, and details
 */
@WebServlet("/book")
public class BookServlet extends HttpServlet {
    
    private static final int PAGE_SIZE = 12;
    private BookDAO bookDAO = new BookDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listBooks(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "search":
                searchBooks(request, response);
                break;
            default:
                listBooks(request, response);
        }
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNum = 1;
        try {
            pageNum = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            // Use default
        }
        
        String categoryIdStr = request.getParameter("categoryId");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (Exception e) {
                // Ignore
            }
        }
        
        List<Category> categories = categoryDAO.findAll();
        List<Book> books;
        int totalCount;
        
        // Use active book methods for user frontend
        if (categoryId != null) {
            totalCount = bookDAO.countActiveByCat(categoryId);
            PageUtil pageUtil = new PageUtil(pageNum, PAGE_SIZE, totalCount);
            books = bookDAO.findActiveByCat(categoryId, pageUtil.getOffset(), PAGE_SIZE);
            request.setAttribute("currentCategory", categoryId);
            request.setAttribute("pageUtil", pageUtil);
        } else {
            totalCount = bookDAO.countAllActive();
            PageUtil pageUtil = new PageUtil(pageNum, PAGE_SIZE, totalCount);
            books = bookDAO.findAllActive(pageUtil.getOffset(), PAGE_SIZE);
            request.setAttribute("pageUtil", pageUtil);
        }
        
        request.setAttribute("categories", categories);
        request.setAttribute("books", books);
        request.getRequestDispatcher("/book-list.jsp").forward(request, response);
    }
    
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/book?action=list");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Book book = bookDAO.findById(id);
            
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/book?action=list");
                return;
            }
            
            List<Review> reviews = reviewDAO.findByBookId(id);
            
            request.setAttribute("book", book);
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("/book-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/book?action=list");
        }
    }
    
    private void searchBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        int pageNum = 1;
        try {
            pageNum = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            // Use default
        }
        
        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/book?action=list");
            return;
        }
        
        keyword = keyword.trim();
        int totalCount = bookDAO.countBySearch(keyword);
        PageUtil pageUtil = new PageUtil(pageNum, PAGE_SIZE, totalCount);
        List<Book> books = bookDAO.search(keyword, pageUtil.getOffset(), PAGE_SIZE);
        List<Category> categories = categoryDAO.findAll();
        
        request.setAttribute("categories", categories);
        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        request.setAttribute("pageUtil", pageUtil);
        request.getRequestDispatcher("/book-list.jsp").forward(request, response);
    }
}
