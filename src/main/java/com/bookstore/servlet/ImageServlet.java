package com.bookstore.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.Files;

/**
 * Servlet to serve images from external upload directory
 */
@WebServlet("/uploads/covers/*")
public class ImageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fileName = request.getPathInfo();
        if (fileName == null || fileName.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Remove leading slash
        fileName = fileName.substring(1);
        
        // Get upload path (same logic as in AdminServlet)
        String uploadPath = System.getProperty("bookstore.upload.path");
        if (uploadPath == null || uploadPath.isEmpty()) {
            uploadPath = "C:/bookstore-uploads/covers";
        }
        
        File imageFile = new File(uploadPath, fileName);
        
        if (!imageFile.exists() || !imageFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Set content type based on file extension
        String mimeType = getServletContext().getMimeType(fileName);
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLength((int) imageFile.length());
        
        // Set cache headers for better performance
        response.setHeader("Cache-Control", "public, max-age=31536000");
        
        // Stream the file to response
        try (InputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}

