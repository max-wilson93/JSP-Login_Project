<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Auction System</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f4f4f4; }
        .nav { background: #333; padding: 15px; color: white; border-radius: 5px; }
        .nav a { color: white; margin-right: 20px; text-decoration: none; font-weight: bold; }
        .nav a:hover { color: #ff9800; }
        .role-badge { background: #ff9800; color: black; padding: 2px 6px; border-radius: 4px; font-size: 0.8em; text-transform: uppercase;}
        .container { background: white; padding: 20px; margin-top: 20px; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <%
        if (session.getAttribute("userID") == null) { response.sendRedirect("login.jsp"); return; }
        String role = (String) session.getAttribute("role");
        String username = (String) session.getAttribute("username");
    %>
    <div class="nav">
        <span>User: <%= username %> <span class="role-badge"><%= role %></span></span> |
        <a href="home.jsp">Home</a>
        <a href="browse.jsp">Browse & Alerts</a>
        <a href="questions.jsp">Q&A</a>
        
        <% if ("enduser".equals(role)) { %>
            <a href="createAuction.jsp">Sell Item</a>
            <a href="myActivity.jsp">My Activity</a>
        <% } %>
        <% if ("admin".equals(role)) { %>
            <a href="admin.jsp">Reports</a>
        <% } %>
        <% if ("rep".equals(role)) { %>
            <a href="rep.jsp">Rep Dashboard</a>
        <% } %>
        <a href="logout.jsp" style="float:right;">Log Out</a>
    </div>
    <div class="container">