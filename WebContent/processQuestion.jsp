<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userID") == null) { response.sendRedirect("login.jsp"); return; }
    int userId = (int) session.getAttribute("userID");
    String question = request.getParameter("question");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    PreparedStatement ps = conn.prepareStatement("INSERT INTO Questions (EndUserID, QuestionText) VALUES (?, ?)");
    ps.setInt(1, userId);
    ps.setString(2, question);
    ps.executeUpdate();
    conn.close();
    String referer = request.getHeader("referer");
    response.sendRedirect(referer != null ? referer : "home.jsp");
%>