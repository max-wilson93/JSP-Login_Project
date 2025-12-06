<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Rep Dashboard</title></head>
<body>
    <%@ include file="home.jsp" %>
    <% if (!"rep".equals(session.getAttribute("role"))) { response.sendRedirect("home.jsp"); return; } %>
    
    <h2>Customer Service</h2>
    <h3>Questions needing answers</h3>
    <ul>
    <%
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        ResultSet rsQ = conn.createStatement().executeQuery("SELECT QuestionID, QuestionText FROM Questions WHERE AnswerText IS NULL");
        while(rsQ.next()) {
    %>
        <li>
            "<%= rsQ.getString("QuestionText") %>"
            <form action="processRepAction.jsp" method="post" style="display:inline;">
                <input type="hidden" name="qid" value="<%= rsQ.getInt("QuestionID") %>">
                <input type="text" name="answer" placeholder="Answer...">
                <input type="submit" value="Reply">
            </form>
        </li>
    <% } %>
    </ul>

    <h3>Moderation</h3>
    <h4>Active Auctions</h4>
    <ul>
    <%
        ResultSet rsA = conn.createStatement().executeQuery("SELECT AuctionID, ItemName FROM Auction");
        while(rsA.next()) {
    %>
        <li><%= rsA.getString("ItemName") %> <a href="processRepAction.jsp?action=deleteAuction&id=<%= rsA.getInt("AuctionID") %>" style="color:red;">[DELETE AUCTION]</a></li>
    <% } %>
    </ul>
    </div></body></html>