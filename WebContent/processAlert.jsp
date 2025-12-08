<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    int userId = (int) session.getAttribute("userID");
    String crit = request.getParameter("criteria");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    PreparedStatement ps = conn.prepareStatement("INSERT INTO Alert (UserID, SearchCriteria) VALUES (?, ?)");
    ps.setInt(1, userId);
    ps.setString(2, crit);
    ps.executeUpdate();
    conn.close();
    response.sendRedirect("myActivity.jsp");
%>