package com.lostfound.servlet;

import com.lostfound.dao.FoundItemDAO;
import com.lostfound.model.FoundItem;
import com.lostfound.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.sql.Date;
import java.util.UUID;

/**
 * Handles reporting a found item (GET shows form, POST saves it with optional image).
 */
@WebServlet("/report-found")
@MultipartConfig(maxFileSize = 5_242_880, maxRequestSize = 10_485_760)
public class ReportFoundServlet extends HttpServlet {

    private final FoundItemDAO foundItemDAO = new FoundItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isLoggedIn(req)) { redirectToLogin(req, resp); return; }
        req.getRequestDispatcher("/jsp/reportFound.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) { redirectToLogin(req, resp); return; }

        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession().getAttribute("loggedUser");

        String itemName     = req.getParameter("itemName").trim();
        String category     = req.getParameter("category").trim();
        String description  = req.getParameter("description").trim();
        String dateFoundStr = req.getParameter("dateFound").trim();
        String location     = req.getParameter("location").trim();
        String contactInfo  = req.getParameter("contactInfo").trim();

        // ── Validation ────────────────────────────────────────────────────
        if (itemName.isEmpty() || category.isEmpty() || dateFoundStr.isEmpty()
                || location.isEmpty() || contactInfo.isEmpty()) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("/jsp/reportFound.jsp").forward(req, resp);
            return;
        }

        // ── Image Upload ──────────────────────────────────────────────────
        String imagePath = null;
        Part filePart = req.getPart("itemImage");
        if (filePart != null && filePart.getSize() > 0) {
            imagePath = saveUploadedFile(filePart);
        }

        // ── Build and Save ────────────────────────────────────────────────
        FoundItem item = new FoundItem();
        item.setUserId(user.getUserId());
        item.setItemName(itemName);
        item.setCategory(category);
        item.setDescription(description);
        item.setDateFound(Date.valueOf(dateFoundStr));
        item.setLocation(location);
        item.setImagePath(imagePath);
        item.setContactInfo(contactInfo);

        int id = foundItemDAO.addFoundItem(item);
        if (id > 0) {
            req.getSession().setAttribute("flashSuccess", "Found item reported successfully!");
            resp.sendRedirect(req.getContextPath() + "/found-items");
        } else {
            req.setAttribute("error", "Failed to submit the report. Please try again.");
            req.getRequestDispatcher("/jsp/reportFound.jsp").forward(req, resp);
        }
    }

    private String saveUploadedFile(Part filePart) {
        try {
            String uploadsDir = getServletContext().getRealPath("/images/uploads");
            Files.createDirectories(Paths.get(uploadsDir));

            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension    = originalName.contains(".")
                                ? originalName.substring(originalName.lastIndexOf('.'))
                                : ".jpg";
            String fileName = UUID.randomUUID().toString() + extension;

            try (InputStream is = filePart.getInputStream();
                 OutputStream os = new FileOutputStream(uploadsDir + File.separator + fileName)) {
                byte[] buf = new byte[4096];
                int n;
                while ((n = is.read(buf)) != -1) os.write(buf, 0, n);
            }
            return "images/uploads/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
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
