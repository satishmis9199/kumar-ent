package com.kumarent.filters;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("adminUser") != null);

        String uri = req.getRequestURI();

        // Allow login page & login servlet
        if (loggedIn ||
            uri.endsWith("/admin/login.jsp") ||
            uri.endsWith("/admin/login")) {

            chain.doFilter(request, response); // continue
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
        }
    }
}
