<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Rep Dashboard</title></head>
<body>
    <%@ include file="home.jsp" %>
    <% if (!"rep".equals(session.getAttribute("role"))) { response.sendRedirect("home.jsp"); return; } %>

    <h2>Customer Service & Moderation</h2>
    
    <h3>Unanswered Questions</h3>
    <ul>
    <%
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        // Linking Questions to Users via EndUser table
        ResultSet rsQ = conn.createStatement().executeQuery("SELECT q.QuestionID, q.QuestionText, u.LoginID FROM Questions q JOIN EndUser e ON q.EndUserID=e.UserID JOIN User u ON e.UserID=u.UserID WHERE q.AnswerText IS NULL");
        while(rsQ.next()) {
    %>
        <li>
            <%= rsQ.getString("LoginID") %> asks: "<%= rsQ.getString("QuestionText") %>"
            <form action="processRepAction.jsp" method="post">
                <input type="hidden" name="qid" value="<%= rsQ.getInt("QuestionID") %>">
                <input type="text" name="answer" placeholder="Answer here...">
                <input type="submit" value="Reply">
            </form>
        </li>
    <% } %>
    </ul>

    <h3>Manage Auctions</h3>
    <ul>
    <%
        ResultSet rsAuc = conn.createStatement().executeQuery("SELECT AuctionID, ItemName FROM Auction");
        while(rsAuc.next()) {
    %>
        <li>
            <%= rsAuc.getString("ItemName") %> 
            <a href="processRepAction.jsp?action=delete&id=<%= rsAuc.getInt("AuctionID") %>" style="color:red;">[DELETE]</a>
        </li>
    <% } %>
    </ul>
</body>
</html>
