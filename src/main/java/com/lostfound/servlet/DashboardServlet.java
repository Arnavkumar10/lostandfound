package com.lostfound.servlet;

import com.lostfound.dao.*;
import com.lostfound.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Loads dashboard statistics and forwards to dashboard.jsp.
 * Requires an authenticated user session.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final LostItemDAO  lostItemDAO  = new LostItemDAO();
    private final FoundItemDAO foundItemDAO = new FoundItemDAO();
    private final ClaimRequestDAO claimDAO  = new ClaimRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            session = req.getSession(true);
            session.setAttribute("redirectAfterLogin", req.getContextPath() + "/dashboard");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        // ── Global statistics ──────────────────────────────────────────────
        req.setAttribute("totalLost",       lostItemDAO.getTotalLostCount());
        req.setAttribute("totalFound",      foundItemDAO.getTotalFoundCount());
        req.setAttribute("totalRecovered",  lostItemDAO.getRecoveredCount());
        req.setAttribute("pendingClaims",   claimDAO.getPendingClaimCount());

        // ── User-specific items ────────────────────────────────────────────
        req.setAttribute("myLostItems",     lostItemDAO.getLostItemsByUser(user.getUserId()));
        req.setAttribute("myFoundItems",    foundItemDAO.getFoundItemsByUser(user.getUserId()));
        req.setAttribute("myClaims",        claimDAO.getClaimsByUser(user.getUserId()));

        // ── Recent activity (latest 6) ─────────────────────────────────────
        req.setAttribute("recentLostItems",  lostItemDAO.getAllLostItems()
                .stream().limit(6).collect(java.util.stream.Collectors.toList()));
        req.setAttribute("recentFoundItems", foundItemDAO.getAllFoundItems()
                .stream().limit(6).collect(java.util.stream.Collectors.toList()));

        req.getRequestDispatcher("/jsp/dashboard.jsp").forward(req, resp);
    }
}
