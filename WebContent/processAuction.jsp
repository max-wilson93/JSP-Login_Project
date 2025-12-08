<%@ page import="java.sql.*, java.time.LocalDateTime" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userID") == null) { response.sendRedirect("login.jsp"); return; }
    int sellerId = (int) session.getAttribute("userID");

    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    
    int days = Integer.parseInt(request.getParameter("days"));
    Timestamp closeTime = Timestamp.valueOf(LocalDateTime.now().plusDays(days));

    String sql = "INSERT INTO Auction (SellerID, CategoryID, ItemName, ItemDescription, InitialPrice, MinPrice, BidIncrement, StartTime, CloseTime, Status) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?, 'Active')";
    PreparedStatement ps = conn.prepareStatement(sql);
    
    ps.setInt(1, sellerId);
    ps.setInt(2, Integer.parseInt(request.getParameter("category")));
    ps.setString(3, request.getParameter("title"));
    ps.setString(4, request.getParameter("description"));
    ps.setDouble(5, Double.parseDouble(request.getParameter("initial_price")));
    ps.setDouble(6, Double.parseDouble(request.getParameter("min_price")));
    ps.setDouble(7, 1.00); 
    ps.setTimestamp(8, closeTime);
    
    ps.executeUpdate();
    conn.close();
    response.sendRedirect("browse.jsp");
%>