package com.lostfound.servlet;

import com.lostfound.dao.*;
import com.lostfound.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Admin Panel controller.
 *
 * GET  /admin            → show dashboard with stats
 * GET  /admin?tab=users  → manage users
 * GET  /admin?tab=lost   → manage lost items
 * GET  /admin?tab=found  → manage found items
 * GET  /admin?tab=claims → manage claims
 * POST /admin?action=... → perform admin action
 */
@WebServlet("/admin")
public class AdminPanelServlet extends HttpServlet {

    private final AdminDAO        adminDAO    = new AdminDAO();
    private final UserDAO         userDAO     = new UserDAO();
    private final LostItemDAO     lostDAO     = new LostItemDAO();
    private final FoundItemDAO    foundDAO    = new FoundItemDAO();
    private final ClaimRequestDAO claimDAO    = new ClaimRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/admin-login");
            return;
        }

        String tab = req.getParameter("tab");
        if (tab == null) tab = "dashboard";

        // Load data based on active tab
        switch (tab) {
            case "users":
                req.setAttribute("users", userDAO.getAllUsers());
                break;
            case "lost":
                req.setAttribute("lostItems", lostDAO.getAllLostItemsAdmin());
                break;
            case "found":
                req.setAttribute("foundItems", foundDAO.getAllFoundItemsAdmin());
                break;
            case "claims":
                req.setAttribute("claims", claimDAO.getAllClaims());
                break;
            default:
                // Dashboard tab — load statistics
                int[] stats = adminDAO.getDashboardStats();
                req.setAttribute("statTotalLost",     stats[0]);
                req.setAttribute("statTotalFound",    stats[1]);
                req.setAttribute("statRecovered",     stats[2]);
                req.setAttribute("statTotalUsers",    stats[3]);
                req.setAttribute("statPendingClaims", stats[4]);
                // Also load recent items for dashboard
                req.setAttribute("recentLost",  lostDAO.getAllLostItemsAdmin()
                        .stream().limit(5).collect(java.util.stream.Collectors.toList()));
                req.setAttribute("recentFound", foundDAO.getAllFoundItemsAdmin()
                        .stream().limit(5).collect(java.util.stream.Collectors.toList()));
                break;
        }

        req.setAttribute("activeTab", tab);
        req.getRequestDispatcher("/jsp/adminPanel.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/admin-login");
            return;
        }

        String action = req.getParameter("action");
        String redirectTab = "dashboard";

        switch (action) {
            // ── User management ───────────────────────────────────────────
            case "toggleUser": {
                int userId  = Integer.parseInt(req.getParameter("userId"));
                boolean active = "true".equals(req.getParameter("active"));
                userDAO.toggleUserStatus(userId, active);
                redirectTab = "users";
                break;
            }
            case "deleteUser": {
                int userId = Integer.parseInt(req.getParameter("userId"));
                userDAO.deleteUser(userId);
                redirectTab = "users";
                break;
            }

            // ── Lost item management ──────────────────────────────────────
            case "approveLost": {
                int itemId   = Integer.parseInt(req.getParameter("itemId"));
                boolean appr = "true".equals(req.getParameter("approved"));
                lostDAO.setApproval(itemId, appr);
                redirectTab = "lost";
                break;
            }
            case "deleteLost": {
                int itemId = Integer.parseInt(req.getParameter("itemId"));
                lostDAO.deleteLostItem(itemId);
                redirectTab = "lost";
                break;
            }
            case "updateLostStatus": {
                int itemId    = Integer.parseInt(req.getParameter("itemId"));
                String status = req.getParameter("status");
                lostDAO.updateStatus(itemId, status);
                redirectTab = "lost";
                break;
            }

            // ── Found item management ─────────────────────────────────────
            case "approveFound": {
                int itemId   = Integer.parseInt(req.getParameter("itemId"));
                boolean appr = "true".equals(req.getParameter("approved"));
                foundDAO.setApproval(itemId, appr);
                redirectTab = "found";
                break;
            }
            case "deleteFound": {
                int itemId = Integer.parseInt(req.getParameter("itemId"));
                foundDAO.deleteFoundItem(itemId);
                redirectTab = "found";
                break;
            }

            // ── Claim management ──────────────────────────────────────────
            case "resolveClaim": {
                int claimId    = Integer.parseInt(req.getParameter("claimId"));
                String status  = req.getParameter("status");
                String note    = req.getParameter("adminNote");
                claimDAO.resolveClaim(claimId, status, note);
                redirectTab = "claims";
                break;
            }
        }

        req.getSession().setAttribute("flashSuccess", "Action completed successfully.");
        resp.sendRedirect(req.getContextPath() + "/admin?tab=" + redirectTab);
    }

    private boolean isAdminLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("loggedAdmin") != null;
    }
}
