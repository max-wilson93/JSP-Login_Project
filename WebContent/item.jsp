<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Item Details</title></head>
<body>
    <%@ include file="home.jsp" %>
    <%
        int auctionId = Integer.parseInt(request.getParameter("id"));
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        
        // --- 1. GET ITEM DETAILS ---
        PreparedStatement psItem = conn.prepareStatement("SELECT * FROM Auction WHERE AuctionID=?");
        psItem.setInt(1, auctionId);
        ResultSet rs = psItem.executeQuery();
        if(rs.next()) {
            // Calculate current price (Highest bid OR initial price)
            PreparedStatement psMax = conn.prepareStatement("SELECT MAX(BidAmount) FROM Bid WHERE AuctionID=?");
            psMax.setInt(1, auctionId);
            ResultSet rsMax = psMax.executeQuery();
            double currentPrice = rs.getDouble("InitialPrice");
            if(rsMax.next() && rsMax.getDouble(1) > 0) currentPrice = rsMax.getDouble(1);
    %>
        <h2><%= rs.getString("ItemName") %></h2>
        <p><strong>Description:</strong> <%= rs.getString("ItemDescription") %></p>
        <h3>Current Price: $<%= currentPrice %></h3>
        <p>Closes: <%= rs.getTimestamp("CloseTime") %></p>

        <!-- BIDDING FORM (Checklist: Buyer bids) -->
        <div style="background:#ddd; padding:15px; width: 300px;">
            <form action="processBid.jsp" method="post">
                <input type="hidden" name="auction_id" value="<%= auctionId %>">
                <label>Your Max Bid ($):</label><br>
                <input type="number" step="0.01" name="amount" required>
                <input type="submit" value="Place Bid">
            </form>
            <small>We will auto-bid for you up to your max.</small>
        </div>
        <br>

        <!-- BID HISTORY (Checklist requirement) -->
        <h4>Bid History</h4>
        <ul>
        <%
            PreparedStatement psHist = conn.prepareStatement("SELECT b.BidAmount, b.BidTime, u.LoginID FROM Bid b JOIN EndUser e ON b.BuyerID=e.UserID JOIN User u ON e.UserID=u.UserID WHERE b.AuctionID=? ORDER BY b.BidAmount DESC");
            psHist.setInt(1, auctionId);
            ResultSet rsHist = psHist.executeQuery();
            while(rsHist.next()) {
        %>
            <li>$<%= rsHist.getDouble("BidAmount") %> by <%= rsHist.getString("LoginID") %> at <%= rsHist.getTimestamp("BidTime") %></li>
        <% } %>
        </ul>

        <!-- SIMILAR ITEMS (Checklist requirement) -->
        <h4>Similar Items (Last Month)</h4>
        <ul>
        <%
            // Logic: Same category, ended in last 30 days
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

        <!-- Q&A SECTION (Checklist requirement) -->
        <h4>Questions & Answers</h4>
        <form action="processQuestion.jsp" method="post">
            <input type="hidden" name="auction_id" value="<%= auctionId %>">
            <input type="text" name="question" placeholder="Ask a question..." required>
            <input type="submit" value="Ask">
        </form>
        <ul>
        <%
            // Note: Since 'Questions' table isn't directly linked to Auction in the schema PDF, 
            // we assume questions are usually linked to items. 
            // I'll skip display for now to strictly follow schema provided which links Question to User/Rep only.
        %>
        </ul>

    <% 
        } 
        conn.close();
    %>
</body>
</html>
