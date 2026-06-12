package com.lostfound.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Logs out the current user (or admin) by invalidating their session.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            // Detect if it was an admin session
            boolean isAdmin = session.getAttribute("loggedAdmin") != null;
            session.invalidate();

            if (isAdmin) {
                resp.sendRedirect(req.getContextPath() + "/admin-login");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
