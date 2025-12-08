<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
    <% if (!"admin".equals(session.getAttribute("role"))) { response.sendRedirect("home.jsp"); return; } %>
    
    <h2>Reports</h2>
    <%
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        Statement stmt = conn.createStatement();
        
        ResultSet rs1 = stmt.executeQuery("SELECT SUM(b.BidAmount) as Total FROM Auction a JOIN Bid b ON a.AuctionID = b.AuctionID WHERE a.CloseTime < NOW() AND b.BidAmount = (SELECT MAX(BidAmount) FROM Bid WHERE AuctionID = a.AuctionID)");
        if(rs1.next()) out.println("<h3>Total Revenue: $" + rs1.getDouble("Total") + "</h3>");

        out.println("<h3>Revenue per Category</h3><ul>");
        ResultSet rs2 = stmt.executeQuery("SELECT c.CategoryName, SUM(b.BidAmount) as Total FROM Auction a JOIN Category c ON a.CategoryID = c.CategoryID JOIN Bid b ON a.AuctionID = b.AuctionID WHERE a.CloseTime < NOW() AND b.BidAmount = (SELECT MAX(BidAmount) FROM Bid WHERE AuctionID = a.AuctionID) GROUP BY c.CategoryName");
        while(rs2.next()) out.println("<li>" + rs2.getString("CategoryName") + ": $" + rs2.getDouble("Total") + "</li>");
        out.println("</ul>");

        out.println("<h3>Best Sellers</h3><ul>");
        ResultSet rs3 = stmt.executeQuery("SELECT u.LoginID, COUNT(*) as Sold FROM Auction a JOIN EndUser e ON a.SellerID=e.UserID JOIN User u ON e.UserID=u.UserID WHERE a.CloseTime < NOW() GROUP BY u.LoginID ORDER BY Sold DESC LIMIT 5");
        while(rs3.next()) out.println("<li>" + rs3.getString("LoginID") + " sold " + rs3.getInt("Sold") + " items</li>");
        out.println("</ul>");
    %>
    <hr>
    <h3>Create Customer Rep</h3>
    <form action="processRegister.jsp" method="post">
        User: <input type="text" name="user"> Pass: <input type="text" name="pass">
        <input type="submit" value="Create">
    </form>
    </div> 
</body>
</html>