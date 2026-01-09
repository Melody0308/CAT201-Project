package com.bookstore.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * JSON response utility class
 */
public class JsonUtil {
    
    private static final Gson GSON = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();
    
    /**
     * Convert object to JSON string
     */
    public static String toJson(Object obj) {
        return GSON.toJson(obj);
    }
    
    /**
     * Parse JSON string to object
     */
    public static <T> T fromJson(String json, Class<T> clazz) {
        return GSON.fromJson(json, clazz);
    }
    
    /**
     * Write JSON response
     */
    public static void writeJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(toJson(data));
        out.flush();
    }
    
    /**
     * Write success response
     */
    public static void success(HttpServletResponse response, Object data) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", data);
        writeJson(response, result);
    }
    
    /**
     * Write success response with message
     */
    public static void success(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", message);
        writeJson(response, result);
    }
    
    /**
     * Write error response
     */
    public static void error(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);
        writeJson(response, result);
    }
}
