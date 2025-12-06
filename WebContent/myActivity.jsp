<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>My Activity</title></head>
<body>
    <%@ include file="home.jsp" %>
    <h2>My Dashboard</h2>
    <%
        int userId = (int) session.getAttribute("userID");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    %>

    <!-- ALERTS (Checklist: Alert when outbid) -->
    <div style="border: 2px solid red; padding: 10px; background: #ffe6e6;">
        <h3>Alerts</h3>
        <ul>
        <%
            // Logic: Find auctions where I have an AutoBid, but I am NOT the winner in the Bid table
            String sqlAlert = "SELECT a.ItemName, a.AuctionID FROM AutoBid ab JOIN Auction a ON ab.AuctionID = a.AuctionID WHERE ab.UserID = ? AND a.Status='Active' AND ab.UserID != (SELECT BuyerID FROM Bid WHERE AuctionID=a.AuctionID ORDER BY BidAmount DESC LIMIT 1)";
            PreparedStatement psAlert = conn.prepareStatement(sqlAlert);
            psAlert.setInt(1, userId);
            ResultSet rsAlert = psAlert.executeQuery();
            boolean hasAlert = false;
            while(rsAlert.next()) {
                hasAlert = true;
        %>
            <li>You have been <strong>OUTBID</strong> on <a href="item.jsp?id=<%= rsAlert.getInt("AuctionID") %>"><%= rsAlert.getString("ItemName") %></a>!</li>
        <% } 
           if(!hasAlert) out.println("<li>No alerts.</li>");
        %>
        </ul>
    </div>

    <!-- SELLING HISTORY -->
    <h3>My Auctions</h3>
    <ul>
    <%
        PreparedStatement psSell = conn.prepareStatement("SELECT * FROM Auction WHERE SellerID=?");
        psSell.setInt(1, userId);
        ResultSet rsSell = psSell.executeQuery();
        while(rsSell.next()) {
    %>
        <li><%= rsSell.getString("ItemName") %> - Status: <%= rsSell.getString("Status") %></li>
    <% } %>
    </ul>
</body>
</html>
