package com.lostfound.servlet;

import com.lostfound.dao.FoundItemDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Displays all (or filtered) found item listings.
 */
@WebServlet("/found-items")
public class FoundItemsServlet extends HttpServlet {

    private final FoundItemDAO foundItemDAO = new FoundItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword  = req.getParameter("keyword");
        String category = req.getParameter("category");

        if ((keyword != null && !keyword.trim().isEmpty())
                || (category != null && !category.equals("All"))) {
            req.setAttribute("items", foundItemDAO.searchFoundItems(keyword, category));
            req.setAttribute("keyword",  keyword);
            req.setAttribute("category", category);
            req.setAttribute("searching", true);
        } else {
            req.setAttribute("items", foundItemDAO.getAllFoundItems());
            req.setAttribute("searching", false);
        }

        req.setAttribute("totalCount", foundItemDAO.getTotalFoundCount());
        req.getRequestDispatcher("/jsp/foundItems.jsp").forward(req, resp);
    }
}
