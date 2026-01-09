package com.bookstore.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Character encoding filter - ensures UTF-8 encoding for all requests
 */
@WebFilter("/*")
public class EncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String configEncoding = filterConfig.getInitParameter("encoding");
        if (configEncoding != null) {
            encoding = configEncoding;
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI();
        
        // 设置请求编码
        request.setCharacterEncoding(encoding);
        response.setCharacterEncoding(encoding);
        
        // 只对非静态资源设置 Content-Type
        // 静态资源（CSS、JS、图片等）让容器自动处理
        if (!isStaticResource(requestURI)) {
            response.setContentType("text/html;charset=" + encoding);
        }
        
        chain.doFilter(request, response);
    }
    
    /**
     * 判断是否是静态资源
     */
    private boolean isStaticResource(String uri) {
        return uri.endsWith(".css") || 
               uri.endsWith(".js") || 
               uri.endsWith(".jpg") || 
               uri.endsWith(".jpeg") || 
               uri.endsWith(".png") || 
               uri.endsWith(".gif") || 
               uri.endsWith(".svg") || 
               uri.endsWith(".ico") || 
               uri.endsWith(".woff") || 
               uri.endsWith(".woff2") || 
               uri.endsWith(".ttf") || 
               uri.endsWith(".eot");
    }
    
    @Override
    public void destroy() {
    }
}
