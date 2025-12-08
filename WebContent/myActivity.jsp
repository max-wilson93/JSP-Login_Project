<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
    <h2>My Activity</h2>
    <%
        int userId = (int) session.getAttribute("userID");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    %>
    <div style="border: 2px solid #ff9800; padding: 10px; background: #fff8e1; margin-bottom: 20px;">
        <h3>Notifications</h3>
        <ul>
        <%
            String sqlOutbid = "SELECT a.ItemName, a.AuctionID FROM AutoBid ab JOIN Auction a ON ab.AuctionID = a.AuctionID WHERE ab.UserID = ? AND a.Status='Active' AND ab.UserID != (SELECT BuyerID FROM Bid WHERE AuctionID=a.AuctionID ORDER BY BidAmount DESC LIMIT 1)";
            PreparedStatement psOut = conn.prepareStatement(sqlOutbid);
            psOut.setInt(1, userId);
            ResultSet rsOut = psOut.executeQuery();
            while(rsOut.next()) {
                out.println("<li style='color:red;'>OUTBID! <a href='item.jsp?id="+rsOut.getInt("AuctionID")+"'>"+rsOut.getString("ItemName")+"</a> is slipping away!</li>");
            }
            
            PreparedStatement psCriteria = conn.prepareStatement("SELECT SearchCriteria FROM Alert WHERE UserID=?");
            psCriteria.setInt(1, userId);
            ResultSet rsCrit = psCriteria.executeQuery();
            while(rsCrit.next()) {
                String criteria = rsCrit.getString("SearchCriteria");
                PreparedStatement psMatch = conn.prepareStatement("SELECT AuctionID, ItemName FROM Auction WHERE ItemName LIKE ? AND StartTime > DATE_SUB(NOW(), INTERVAL 1 DAY)");
                psMatch.setString(1, "%" + criteria + "%");
                ResultSet rsMatch = psMatch.executeQuery();
                while(rsMatch.next()) {
                    out.println("<li style='color:green;'>NEW ITEM! A <a href='item.jsp?id="+rsMatch.getInt("AuctionID")+"'>"+rsMatch.getString("ItemName")+"</a> matches your alert for '" + criteria + "'.</li>");
                }
            }
        %>
        </ul>
    </div>
    <h3>My Selling</h3>
    <ul>
    <%
        PreparedStatement psSell = conn.prepareStatement("SELECT * FROM Auction WHERE SellerID=?");
        psSell.setInt(1, userId);
        ResultSet rsSell = psSell.executeQuery();
        while(rsSell.next()) {
            out.println("<li>" + rsSell.getString("ItemName") + " - " + rsSell.getString("Status") + "</li>");
        }
    %>
    </ul>
    </div>
</body>
</html>