package com.bookstore.servlet;

import com.bookstore.dao.AddressDAO;
import com.bookstore.model.Address;
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
 * Address servlet - handles shipping address CRUD
 */
@WebServlet("/address")
public class AddressServlet extends HttpServlet {
    
    private AddressDAO addressDAO = new AddressDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        List<Address> addresses = addressDAO.findByUserId(user.getId());
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/user/addresses.jsp").forward(request, response);
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
        
        if (action == null) {
            JsonUtil.error(response, "Invalid action");
            return;
        }
        
        switch (action) {
            case "add":
                addAddress(request, response, user);
                break;
            case "update":
                updateAddress(request, response, user);
                break;
            case "delete":
                deleteAddress(request, response, user);
                break;
            case "setDefault":
                setDefault(request, response, user);
                break;
            default:
                JsonUtil.error(response, "Invalid action");
        }
    }
    
    private void addAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        Address address = parseAddressFromRequest(request);
        address.setUserId(user.getId());
        
        if (!validateAddress(address)) {
            JsonUtil.error(response, "All fields are required");
            return;
        }
        
        if (addressDAO.insert(address)) {
            JsonUtil.success(response, "Address added successfully");
        } else {
            JsonUtil.error(response, "Failed to add address");
        }
    }
    
    private void updateAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            JsonUtil.error(response, "Address ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Address existing = addressDAO.findById(id);
            
            if (existing == null || !existing.getUserId().equals(user.getId())) {
                JsonUtil.error(response, "Address not found");
                return;
            }
            
            Address address = parseAddressFromRequest(request);
            address.setId(id);
            address.setUserId(user.getId());
            
            if (!validateAddress(address)) {
                JsonUtil.error(response, "All fields are required");
                return;
            }
            
            if (addressDAO.update(address)) {
                JsonUtil.success(response, "Address updated successfully");
            } else {
                JsonUtil.error(response, "Failed to update address");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid address ID");
        }
    }
    
    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            JsonUtil.error(response, "Address ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Address existing = addressDAO.findById(id);
            
            if (existing == null || !existing.getUserId().equals(user.getId())) {
                JsonUtil.error(response, "Address not found");
                return;
            }
            
            if (addressDAO.delete(id)) {
                JsonUtil.success(response, "Address deleted successfully");
            } else {
                JsonUtil.error(response, "Failed to delete address");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid address ID");
        }
    }
    
    private void setDefault(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            JsonUtil.error(response, "Address ID is required");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            if (addressDAO.setDefault(user.getId(), id)) {
                JsonUtil.success(response, "Default address set successfully");
            } else {
                JsonUtil.error(response, "Failed to set default address");
            }
        } catch (NumberFormatException e) {
            JsonUtil.error(response, "Invalid address ID");
        }
    }
    
    private Address parseAddressFromRequest(HttpServletRequest request) {
        Address address = new Address();
        address.setReceiverName(request.getParameter("receiverName"));
        address.setPhone(request.getParameter("phone"));
        address.setProvince(request.getParameter("province"));
        address.setCity(request.getParameter("city"));
        address.setDistrict(request.getParameter("district"));
        address.setDetailAddress(request.getParameter("detailAddress"));
        address.setIsDefault("true".equals(request.getParameter("isDefault")));
        return address;
    }
    
    private boolean validateAddress(Address address) {
        return address.getReceiverName() != null && !address.getReceiverName().isEmpty() &&
               address.getPhone() != null && !address.getPhone().isEmpty() &&
               address.getProvince() != null && !address.getProvince().isEmpty() &&
               address.getCity() != null && !address.getCity().isEmpty() &&
               address.getDistrict() != null && !address.getDistrict().isEmpty() &&
               address.getDetailAddress() != null && !address.getDetailAddress().isEmpty();
    }
}
