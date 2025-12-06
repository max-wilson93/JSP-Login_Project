<%@ page import="java.sql.*" %>
<%
    String action = request.getParameter("action");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    
    if ("deleteAuction".equals(action)) {
        String id = request.getParameter("id");
        conn.createStatement().execute("DELETE FROM Auction WHERE AuctionID=" + id);
    } else {
        String qid = request.getParameter("qid");
        String ans = request.getParameter("answer");
        int repId = (int) session.getAttribute("userID");
        PreparedStatement ps = conn.prepareStatement("UPDATE Questions SET AnswerText=?, RepID=? WHERE QuestionID=?");
        ps.setString(1, ans);
        ps.setInt(2, repId);
        ps.setString(3, qid);
        ps.executeUpdate();
    }
    conn.close();
    response.sendRedirect("rep.jsp");
%>