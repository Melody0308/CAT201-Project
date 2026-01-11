package com.bookstore.servlet;

import com.bookstore.dao.FavoriteDAO;
import com.bookstore.model.Favorite;
import com.bookstore.model.User;
import com.bookstore.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Favorite servlet - handles user favorites
 */
@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {
    
    private FavoriteDAO favoriteDAO = new FavoriteDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        if ("list".equals(action)) {
            listFavorites(request, response, user);
        } else if ("check".equals(action)) {
            checkFavorite(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/index");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            JsonUtil.error(response, "Please login first");
            return;
        }
        
        if ("add".equals(action)) {
            addFavorite(request, response, user);
        } else if ("remove".equals(action)) {
            removeFavorite(request, response, user);
        } else {
            JsonUtil.error(response, "Invalid action");
        }
    }
    
    private void listFavorites(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Favorite> favorites = favoriteDAO.findByUserId(user.getId());
        request.setAttribute("favorites", favorites);
        request.getRequestDispatcher("/user/favorites.jsp").forward(request, response);
    }
    
    private void checkFavorite(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr == null) {
            JsonUtil.error(response, "Book ID is required");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdStr);
            boolean isFavorited = favoriteDAO.isFavorited(user.getId(), bookId);
            JsonUtil.success(response, isFavorited);
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid book ID");
        }
    }
    
    private void addFavorite(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr == null) {
            JsonUtil.error(response, "Book ID is required");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdStr);
            if (favoriteDAO.add(user.getId(), bookId)) {
                JsonUtil.success(response, "Added to favorites");
            } else {
                JsonUtil.error(response, "Failed to add favorite");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid book ID");
        }
    }
    
    private void removeFavorite(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr == null) {
            JsonUtil.error(response, "Book ID is required");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdStr);
            if (favoriteDAO.remove(user.getId(), bookId)) {
                JsonUtil.success(response, "Removed from favorites");
            } else {
                JsonUtil.error(response, "Failed to remove favorite");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid book ID");
        }
    }
}

