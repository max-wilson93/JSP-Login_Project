<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userID") == null) { response.sendRedirect("login.jsp"); return; }
    int userId = (int) session.getAttribute("userID");
    String question = request.getParameter("question");
    
    if (question == null || question.trim().isEmpty()) {
        response.sendRedirect("questions.jsp?error=EmptyQuestion");
        return;
    }

    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        
        if ("admin".equals(session.getAttribute("role"))) {
             response.sendRedirect("questions.jsp?error=AdminCannotPost");
             return;
        }

        PreparedStatement ps = conn.prepareStatement("INSERT INTO Questions (EndUserID, QuestionText) VALUES (?, ?)");
        ps.setInt(1, userId);
        ps.setString(2, question);
        ps.executeUpdate();
        
        response.sendRedirect("questions.jsp?msg=Posted");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("questions.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>