package com.bookstore.servlet;

import com.bookstore.dao.ReviewDAO;
import com.bookstore.model.Review;
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
 * Review servlet - handles book reviews
 */
@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    
    private ReviewDAO reviewDAO = new ReviewDAO();
    
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
        
        if ("myReviews".equals(action)) {
            listMyReviews(request, response, user);
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
            addReview(request, response, user);
        } else {
            JsonUtil.error(response, "Invalid action");
        }
    }
    
    private void addReview(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String bookIdStr = request.getParameter("bookId");
        String orderIdStr = request.getParameter("orderId");
        String ratingStr = request.getParameter("rating");
        String content = request.getParameter("content");
        
        if (bookIdStr == null || ratingStr == null) {
            JsonUtil.error(response, "Book ID and rating are required");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdStr);
            int rating = Integer.parseInt(ratingStr);
            Integer orderId = null;
            if (orderIdStr != null && !orderIdStr.isEmpty()) {
                orderId = Integer.parseInt(orderIdStr);
            }
            
            if (rating < 1 || rating > 5) {
                JsonUtil.error(response, "Rating must be between 1 and 5");
                return;
            }
            
            // Check if already reviewed this book in this order
            if (orderId != null) {
                // If orderId is provided, check if this specific order item has been reviewed
                if (reviewDAO.hasReviewedInOrder(user.getId(), bookId, orderId)) {
                    JsonUtil.error(response, "You have already reviewed this book in this order");
                    return;
                }
            } else {
                // If no orderId, check if the book has been reviewed at all (for general reviews)
                if (reviewDAO.hasReviewed(user.getId(), bookId)) {
                    JsonUtil.error(response, "You have already reviewed this book");
                    return;
                }
            }
            
            Review review = new Review();
            review.setUserId(user.getId());
            review.setBookId(bookId);
            review.setOrderId(orderId);
            review.setRating(rating);
            review.setContent(content);
            
            if (reviewDAO.insert(review)) {
                JsonUtil.success(response, "Review submitted successfully");
            } else {
                JsonUtil.error(response, "Failed to submit review");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid parameters");
        }
    }
    
    private void listMyReviews(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Review> reviews = reviewDAO.findByUserId(user.getId());
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/user/reviews.jsp").forward(request, response);
    }
}
