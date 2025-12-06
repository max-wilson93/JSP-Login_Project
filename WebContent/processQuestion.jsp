<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userID") == null) { response.sendRedirect("login.jsp"); return; }
    int userId = (int) session.getAttribute("userID");
    String question = request.getParameter("question");
    
    // Note: Schema links questions to USERS, not auctions directly, but for context we usually want both.
    // Based strictly on your PDF schema, we insert UserID and Text.
    
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    PreparedStatement ps = conn.prepareStatement("INSERT INTO Questions (EndUserID, QuestionText) VALUES (?, ?)");
    ps.setInt(1, userId);
    ps.setString(2, question);
    ps.executeUpdate();
    conn.close();
    
    // Redirect back to the previous page (referer) or home
    String referer = request.getHeader("referer");
    response.sendRedirect(referer != null ? referer : "home.jsp");
%>
