package com.lostfound.servlet;

import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles user registration (GET shows form, POST processes registration).
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // If already logged in, redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String usn        = req.getParameter("usn").trim().toUpperCase();
        String fullName   = req.getParameter("fullName").trim();
        String email      = req.getParameter("email").trim().toLowerCase();
        String phone      = req.getParameter("phone").trim();
        String department = req.getParameter("department").trim();
        String password   = req.getParameter("password");
        String confirmPwd = req.getParameter("confirmPassword");

        // ── Validation ────────────────────────────────────────────────────
        if (usn.isEmpty() || fullName.isEmpty() || email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "All required fields must be filled.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirmPwd)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }
        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters long.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }
        if (userDAO.usnExists(usn)) {
            req.setAttribute("error", "USN '" + usn + "' is already registered.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }
        if (userDAO.emailExists(email)) {
            req.setAttribute("error", "Email address is already in use.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        // ── Persist ───────────────────────────────────────────────────────
        User user = new User();
        user.setUsn(usn);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setDepartment(department);

        boolean success = userDAO.registerUser(user, password);
        if (success) {
            req.setAttribute("success", "Registration successful! You can now log in.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Registration failed due to a server error. Please try again.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
        }
    }
}
