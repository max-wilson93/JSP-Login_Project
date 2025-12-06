<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Auction System</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        .nav { background: #333; padding: 10px; color: white; }
        .nav a { color: white; margin-right: 15px; text-decoration: none; }
        .role-badge { background: #ff9800; color: black; padding: 2px 5px; border-radius: 4px; font-size: 0.8em;}
    </style>
</head>
<body>
    <%
        // Security: Ensure login
        if (session.getAttribute("userID") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        String username = (String) session.getAttribute("username");
    %>
    
    <div class="nav">
        <span>User: <%= username %> <span class="role-badge"><%= role %></span></span> |
        <a href="home.jsp">Home</a>
        <a href="browse.jsp">Browse</a>
        
        <% if ("enduser".equals(role)) { %>
            <a href="createAuction.jsp">Sell Item</a>
            <a href="myActivity.jsp">My Activity & Alerts</a>
        <% } %>

        <% if ("admin".equals(role)) { %>
            <a href="admin.jsp">Admin Reports</a>
        <% } %>

        <% if ("rep".equals(role)) { %>
            <a href="rep.jsp">Rep Dashboard</a>
        <% } %>

        <a href="logout.jsp" style="float:right;">Log Out</a>
    </div>
    <br>
</body>
</html>
