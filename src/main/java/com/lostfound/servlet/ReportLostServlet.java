package com.lostfound.servlet;

import com.lostfound.dao.LostItemDAO;
import com.lostfound.model.LostItem;
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
 * Handles reporting a lost item (GET shows form, POST saves it with optional image).
 */
@WebServlet("/report-lost")
@MultipartConfig(maxFileSize = 5_242_880, maxRequestSize = 10_485_760)
public class ReportLostServlet extends HttpServlet {

    private final LostItemDAO lostItemDAO = new LostItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isLoggedIn(req)) { redirectToLogin(req, resp); return; }
        req.getRequestDispatcher("/jsp/reportLost.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) { redirectToLogin(req, resp); return; }

        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession().getAttribute("loggedUser");

        String itemName    = req.getParameter("itemName").trim();
        String category    = req.getParameter("category").trim();
        String description = req.getParameter("description").trim();
        String dateLostStr = req.getParameter("dateLost").trim();
        String location    = req.getParameter("location").trim();
        String contactInfo = req.getParameter("contactInfo").trim();

        // ── Validation ────────────────────────────────────────────────────
        if (itemName.isEmpty() || category.isEmpty() || dateLostStr.isEmpty()
                || location.isEmpty() || contactInfo.isEmpty()) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("/jsp/reportLost.jsp").forward(req, resp);
            return;
        }

        // ── Image Upload ──────────────────────────────────────────────────
        String imagePath = null;
        Part filePart = req.getPart("itemImage");
        if (filePart != null && filePart.getSize() > 0) {
            imagePath = saveUploadedFile(filePart, req);
        }

        // ── Build and Save ────────────────────────────────────────────────
        LostItem item = new LostItem();
        item.setUserId(user.getUserId());
        item.setItemName(itemName);
        item.setCategory(category);
        item.setDescription(description);
        item.setDateLost(Date.valueOf(dateLostStr));
        item.setLocation(location);
        item.setImagePath(imagePath);
        item.setContactInfo(contactInfo);

        int id = lostItemDAO.addLostItem(item);
        if (id > 0) {
            req.getSession().setAttribute("flashSuccess", "Lost item reported successfully!");
            resp.sendRedirect(req.getContextPath() + "/lost-items");
        } else {
            req.setAttribute("error", "Failed to submit the report. Please try again.");
            req.getRequestDispatcher("/jsp/reportLost.jsp").forward(req, resp);
        }
    }

    /**
     * Saves the uploaded image to the /images/uploads/ directory.
     *
     * @return relative web path to the saved file, or null on failure
     */
    private String saveUploadedFile(Part filePart, HttpServletRequest req) {
        try {
            String uploadsDir = getServletContext().getRealPath("/images/uploads");
            Files.createDirectories(Paths.get(uploadsDir));

            // Generate a unique filename to prevent overwriting
            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension    = originalName.contains(".")
                                ? originalName.substring(originalName.lastIndexOf('.'))
                                : ".jpg";
            String fileName = UUID.randomUUID().toString() + extension;
            String fullPath = uploadsDir + File.separator + fileName;

            try (InputStream is = filePart.getInputStream();
                 OutputStream os = new FileOutputStream(fullPath)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
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
