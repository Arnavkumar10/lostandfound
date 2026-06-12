package com.lostfound.servlet;

import com.lostfound.dao.*;
import com.lostfound.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Shows detailed view of a single lost or found item.
 * Accepts query params: ?type=lost&id=X  or  ?type=found&id=X
 */
@WebServlet("/item-detail")
public class ItemDetailServlet extends HttpServlet {

    private final LostItemDAO  lostItemDAO  = new LostItemDAO();
    private final FoundItemDAO foundItemDAO = new FoundItemDAO();
    private final ClaimRequestDAO claimDAO  = new ClaimRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String type   = req.getParameter("type");
        String idStr  = req.getParameter("id");

        if (type == null || idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/lost-items");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            if ("lost".equals(type)) {
                LostItem item = lostItemDAO.getLostItemById(id);
                if (item == null) { resp.sendRedirect(req.getContextPath() + "/lost-items"); return; }
                req.setAttribute("item", item);
                req.setAttribute("type", "lost");

            } else if ("found".equals(type)) {
                FoundItem item = foundItemDAO.getFoundItemById(id);
                if (item == null) { resp.sendRedirect(req.getContextPath() + "/found-items"); return; }
                req.setAttribute("item", item);
                req.setAttribute("type", "found");

                // Load claim requests for this found item
                req.setAttribute("claims", claimDAO.getClaimsForItem(id));

                // Check if the current user has already claimed this item
                HttpSession session = req.getSession(false);
                if (session != null && session.getAttribute("loggedUser") != null) {
                    User user = (User) session.getAttribute("loggedUser");
                    req.setAttribute("hasClaimed", claimDAO.hasClaimed(id, user.getUserId()));
                    req.setAttribute("isOwner", item.getUserId() == user.getUserId());
                }
            }

            req.getRequestDispatcher("/jsp/itemDetail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/lost-items");
        }
    }
}
