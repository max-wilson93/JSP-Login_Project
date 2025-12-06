<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Admin Reports</title></head>
<body>
    <%@ include file="home.jsp" %>
    <% if (!"admin".equals(session.getAttribute("role"))) { response.sendRedirect("home.jsp"); return; } %>
    
    <h1>Administrative Reports</h1>
    <%
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        Statement stmt = conn.createStatement();
        
        // Report 1: Total Earnings
        ResultSet rs1 = stmt.executeQuery("SELECT SUM(b.BidAmount) as Total FROM Auction a JOIN Bid b ON a.AuctionID = b.AuctionID WHERE a.CloseTime < NOW() AND b.BidAmount = (SELECT MAX(BidAmount) FROM Bid WHERE AuctionID = a.AuctionID)");
        if(rs1.next()) {
    %>
        <h3>Total Earnings: $<%= rs1.getDouble("Total") %></h3>
    <% } %>

    <!-- Report 2: Earnings per Item Type (Category) -->
    <h3>Earnings per Category</h3>
    <table border="1">
    <%
        ResultSet rs2 = stmt.executeQuery("SELECT c.CategoryName, SUM(b.BidAmount) as Total FROM Auction a JOIN Category c ON a.CategoryID = c.CategoryID JOIN Bid b ON a.AuctionID = b.AuctionID WHERE a.CloseTime < NOW() AND b.BidAmount = (SELECT MAX(BidAmount) FROM Bid WHERE AuctionID = a.AuctionID) GROUP BY c.CategoryName");
        while(rs2.next()) {
    %>
        <tr><td><%= rs2.getString("CategoryName") %></td><td>$<%= rs2.getDouble("Total") %></td></tr>
    <% } %>
    </table>

    <!-- Report 3: Best Selling Items -->
    <h3>Best Selling Items (Most Bids)</h3>
    <ul>
    <%
        ResultSet rs3 = stmt.executeQuery("SELECT a.ItemName, COUNT(*) as Bids FROM Bid b JOIN Auction a ON b.AuctionID = a.AuctionID GROUP BY b.AuctionID ORDER BY Bids DESC LIMIT 5");
        while(rs3.next()) {
    %>
        <li><%= rs3.getString("ItemName") %> (<%= rs3.getInt("Bids") %> bids)</li>
    <% } %>
    </ul>
    
    <br><hr>
    <h3>Create Customer Rep Account</h3>
    <form action="processRegister.jsp" method="post">
        User: <input type="text" name="user"><br>
        Pass: <input type="text" name="pass"><br>
        <input type="hidden" name="role" value="rep">
        <input type="submit" value="Create Rep">
    </form>
</body>
</html>
