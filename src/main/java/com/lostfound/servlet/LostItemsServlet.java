package com.lostfound.servlet;

import com.lostfound.dao.LostItemDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Displays all (or filtered) lost item listings.
 */
@WebServlet("/lost-items")
public class LostItemsServlet extends HttpServlet {

    private final LostItemDAO lostItemDAO = new LostItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword  = req.getParameter("keyword");
        String category = req.getParameter("category");

        // Load items — filtered or all
        if ((keyword != null && !keyword.trim().isEmpty())
                || (category != null && !category.equals("All"))) {
            req.setAttribute("items", lostItemDAO.searchLostItems(keyword, category));
            req.setAttribute("keyword",  keyword);
            req.setAttribute("category", category);
            req.setAttribute("searching", true);
        } else {
            req.setAttribute("items", lostItemDAO.getAllLostItems());
            req.setAttribute("searching", false);
        }

        req.setAttribute("totalCount", lostItemDAO.getTotalLostCount());
        req.getRequestDispatcher("/jsp/lostItems.jsp").forward(req, resp);
    }
}
