package com.bookstore.servlet;

import com.bookstore.dao.AnnouncementDAO;
import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CategoryDAO;
import com.bookstore.model.Announcement;
import com.bookstore.model.Book;
import com.bookstore.model.Category;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Index servlet - prepares data for homepage
 */
@WebServlet("/index")
public class IndexServlet extends HttpServlet {
    
    private BookDAO bookDAO = new BookDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private AnnouncementDAO announcementDAO = new AnnouncementDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get newest books
        List<Book> newBooks = bookDAO.findNewest(8);
        
        // Get all categories
        List<Category> categories = categoryDAO.findAll();
        
        // Get latest announcements (for banner)
        List<Announcement> announcements = announcementDAO.findAll(0, 5);
        
        request.setAttribute("newBooks", newBooks);
        request.setAttribute("categories", categories);
        request.setAttribute("announcements", announcements);
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
