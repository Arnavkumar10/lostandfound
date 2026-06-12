package com.lostfound.servlet;

import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles student/staff login (GET shows form, POST validates credentials).
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String usn      = req.getParameter("usn").trim().toUpperCase();
        String password = req.getParameter("password");

        if (usn.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "USN and password are required.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(usn, password);

        if (user != null) {
            // Create a new session and store the user
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Redirect to originally requested page or dashboard
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin");
                resp.sendRedirect(redirectUrl);
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } else {
            req.setAttribute("error", "Invalid USN or password. Please try again.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }
}
