package com.lostfound.servlet;

import com.lostfound.dao.ClaimRequestDAO;
import com.lostfound.model.ClaimRequest;
import com.lostfound.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles claim request actions:
 *   GET  /claim?action=submit&itemId=X  → Show claim form
 *   POST /claim?action=submit           → Submit a new claim
 *   POST /claim?action=resolve          → Approve or reject an existing claim (item owner)
 */
@WebServlet("/claim")
public class ClaimServlet extends HttpServlet {

    private final ClaimRequestDAO claimDAO = new ClaimRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) { redirectToLogin(req, resp); return; }

        String action = req.getParameter("action");
        if ("submit".equals(action)) {
            String itemId = req.getParameter("itemId");
            req.setAttribute("itemId", itemId);
            req.getRequestDispatcher("/jsp/claimRequests.jsp").forward(req, resp);
        } else {
            // Show user's own claim requests
            User user = (User) req.getSession().getAttribute("loggedUser");
            req.setAttribute("claims", claimDAO.getClaimsByUser(user.getUserId()));
            req.getRequestDispatcher("/jsp/claimRequests.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) { redirectToLogin(req, resp); return; }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("submit".equals(action)) {
            // Submit a new claim request
            User user = (User) req.getSession().getAttribute("loggedUser");
            String foundItemIdStr    = req.getParameter("foundItemId");
            String proofDescription  = req.getParameter("proofDescription").trim();

            if (foundItemIdStr == null || proofDescription.isEmpty()) {
                req.getSession().setAttribute("flashError", "Please provide proof of ownership.");
                resp.sendRedirect(req.getContextPath() + "/found-items");
                return;
            }

            int foundItemId = Integer.parseInt(foundItemIdStr);

            // Check for duplicate claim
            if (claimDAO.hasClaimed(foundItemId, user.getUserId())) {
                req.getSession().setAttribute("flashError", "You have already submitted a claim for this item.");
                resp.sendRedirect(req.getContextPath() + "/item-detail?type=found&id=" + foundItemId);
                return;
            }

            ClaimRequest claim = new ClaimRequest();
            claim.setFoundItemId(foundItemId);
            claim.setClaimantUserId(user.getUserId());
            claim.setProofDescription(proofDescription);

            boolean ok = claimDAO.submitClaim(claim);
            if (ok) {
                req.getSession().setAttribute("flashSuccess", "Claim submitted successfully! The finder will review it.");
            } else {
                req.getSession().setAttribute("flashError", "Failed to submit claim. You may have already claimed this item.");
            }
            resp.sendRedirect(req.getContextPath() + "/item-detail?type=found&id=" + foundItemId);

        } else if ("resolve".equals(action)) {
            // Approve or reject an existing claim (by finder or admin)
            String claimIdStr = req.getParameter("claimId");
            String status     = req.getParameter("status");      // Approved | Rejected
            String adminNote  = req.getParameter("adminNote");

            if (claimIdStr == null || status == null) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }

            int claimId = Integer.parseInt(claimIdStr);
            boolean resolved = claimDAO.resolveClaim(claimId, status, adminNote);

            if (resolved) {
                req.getSession().setAttribute("flashSuccess", "Claim has been " + status.toLowerCase() + ".");
            } else {
                req.getSession().setAttribute("flashError", "Failed to update claim status.");
            }
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("loggedUser") != null;
    }

    private void redirectToLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
