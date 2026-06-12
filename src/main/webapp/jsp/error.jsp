<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Capture error details for display
    Integer statusCode   = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String  errorMessage = (String)  request.getAttribute("javax.servlet.error.message");
    String  requestUri   = (String)  request.getAttribute("javax.servlet.error.request_uri");
    if (statusCode == null) statusCode = 500;
    if (errorMessage == null || errorMessage.isEmpty()) {
        errorMessage = statusCode == 404 ? "The page you're looking for doesn't exist." : "An unexpected error occurred.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= statusCode %> Error — College Lost &amp; Found Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container d-flex align-items-center justify-content-center" style="min-height:100vh;">
    <div class="text-center" style="max-width:500px;">
        <div style="font-size:6rem;line-height:1;margin-bottom:1rem;">
            <%= statusCode == 404 ? "🔍" : "⚠️" %>
        </div>
        <h1 class="fw-800" style="font-size:3rem;color:<%= statusCode == 404 ? "#fca5a5" : "#fcd34d" %>;">
            <%= statusCode %>
        </h1>
        <h2 class="h4 fw-700 mb-3"><%= statusCode == 404 ? "Page Not Found" : "Server Error" %></h2>
        <p class="text-secondary-custom mb-4"><%= errorMessage %></p>
        <% if (requestUri != null) { %>
        <p style="font-size:0.8rem;color:var(--text-muted);">Requested: <code><%= requestUri %></code></p>
        <% } %>
        <div class="d-flex gap-3 justify-content-center mt-4">
            <a href="javascript:history.back()" class="btn btn-outline-custom">← Go Back</a>
            <a href="${pageContext.request.contextPath}/jsp/index.jsp" class="btn btn-primary-custom">🏠 Home Page</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
