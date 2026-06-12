package com.lostfound.servlet;

import com.lostfound.dao.AdminDAO;
import com.lostfound.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles admin login (GET shows form, POST validates credentials).
 */
@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedAdmin") != null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }
        req.getRequestDispatcher("/jsp/adminLogin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username").trim();
        String password = req.getParameter("password");

        if (username.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/jsp/adminLogin.jsp").forward(req, resp);
            return;
        }

        Admin admin = adminDAO.authenticate(username, password);

        if (admin != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedAdmin", admin);
            session.setAttribute("adminName", admin.getFullName());
            session.setMaxInactiveInterval(30 * 60);
            resp.sendRedirect(req.getContextPath() + "/admin");
        } else {
            req.setAttribute("error", "Invalid admin credentials.");
            req.getRequestDispatcher("/jsp/adminLogin.jsp").forward(req, resp);
        }
    }
}
