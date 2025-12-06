<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Item Details</title></head>
<body>
    <%@ include file="home.jsp" %>
    <%
        int auctionId = Integer.parseInt(request.getParameter("id"));
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        
        PreparedStatement psItem = conn.prepareStatement("SELECT * FROM Auction WHERE AuctionID=?");
        psItem.setInt(1, auctionId);
        ResultSet rs = psItem.executeQuery();
        if(rs.next()) {
            PreparedStatement psMax = conn.prepareStatement("SELECT MAX(BidAmount) FROM Bid WHERE AuctionID=?");
            psMax.setInt(1, auctionId);
            ResultSet rsMax = psMax.executeQuery();
            double currentPrice = rs.getDouble("InitialPrice");
            if(rsMax.next() && rsMax.getDouble(1) > 0) currentPrice = rsMax.getDouble(1);
    %>
        <h2><%= rs.getString("ItemName") %></h2>
        <p><%= rs.getString("ItemDescription") %></p>
        <h3>Current Price: $<%= currentPrice %></h3>
        <p>Ends: <%= rs.getTimestamp("CloseTime") %></p>

        <div style="background:#eee; padding:15px; border-left: 5px solid #333;">
            <h4>Place Bid</h4>
            <form action="processBid.jsp" method="post">
                <input type="hidden" name="auction_id" value="<%= auctionId %>">
                <label>Your Max Bid ($):</label> 
                <input type="number" step="0.01" name="amount" required>
                <input type="submit" value="Bid">
            </form>
            <small>Automatic bidding active. We bid for you up to your max.</small>
        </div>

        <h3>Bid History</h3>
        <ul>
        <%
            PreparedStatement psHist = conn.prepareStatement("SELECT b.BidAmount, b.BidTime, u.LoginID FROM Bid b JOIN EndUser e ON b.BuyerID=e.UserID JOIN User u ON e.UserID=u.UserID WHERE b.AuctionID=? ORDER BY b.BidAmount DESC");
            psHist.setInt(1, auctionId);
            ResultSet rsHist = psHist.executeQuery();
            while(rsHist.next()) {
        %>
            <li>$<%= rsHist.getDouble("BidAmount") %> - <%= rsHist.getString("LoginID") %> (<%= rsHist.getTimestamp("BidTime") %>)</li>
        <% } %>
        </ul>

        <h3>Similar Items (Last Month)</h3>
        <ul>
        <%
            String sqlSim = "SELECT AuctionID, ItemName FROM Auction WHERE CategoryID=? AND AuctionID != ? AND CloseTime BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) AND NOW() LIMIT 5";
            PreparedStatement psSim = conn.prepareStatement(sqlSim);
            psSim.setInt(1, rs.getInt("CategoryID"));
            psSim.setInt(2, auctionId);
            ResultSet rsSim = psSim.executeQuery();
            while(rsSim.next()) {
        %>
            <li><a href="item.jsp?id=<%= rsSim.getInt("AuctionID") %>"><%= rsSim.getString("ItemName") %></a></li>
        <% } %>
        </ul>
    <% } conn.close(); %>
    </div></body></html>