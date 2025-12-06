<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Browse</title></head>
<body>
    <%@ include file="home.jsp" %>
    <h2>Browse Auctions</h2>
    
    <div style="background:#e9e9e9; padding:15px; border-radius:5px;">
        <form action="browse.jsp" method="get">
            Search: <input type="text" name="search" placeholder="Item Name or Category..." value="<%= request.getParameter("search")!=null?request.getParameter("search"):"" %>">
            Sort: 
            <select name="sort">
                <option value="CloseTime ASC">Ending Soon</option>
                <option value="InitialPrice ASC">Price: Low to High</option>
                <option value="InitialPrice DESC">Price: High to Low</option>
            </select>
            <input type="submit" value="Search">
        </form>
        <% if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
            <form action="processAlert.jsp" method="post" style="margin-top:10px;">
                <input type="hidden" name="criteria" value="<%= request.getParameter("search") %>">
                <input type="submit" value="Create Alert for this Search" style="background:#4CAF50; color:white; border:none; padding:5px 10px; cursor:pointer;">
            </form>
        <% } %>
    </div>
    <br>
    <table>
        <tr><th>Item</th><th>Current Price</th><th>Closes</th><th>Action</th></tr>
        <%
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
            String search = request.getParameter("search");
            String sort = request.getParameter("sort");
            
            String sql = "SELECT a.*, (SELECT MAX(BidAmount) FROM Bid WHERE AuctionID = a.AuctionID) as HighBid FROM Auction a WHERE Status='Active' AND CloseTime > NOW()";
            
            if (search != null && !search.isEmpty()) sql += " AND (ItemName LIKE ? OR ItemDescription LIKE ?)";
            if (sort != null) sql += " ORDER BY " + sort; else sql += " ORDER BY CloseTime ASC";

            PreparedStatement ps = conn.prepareStatement(sql);
            if (search != null && !search.isEmpty()) {
                ps.setString(1, "%" + search + "%");
                ps.setString(2, "%" + search + "%");
            }
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                double price = rs.getDouble("HighBid");
                if (rs.wasNull()) price = rs.getDouble("InitialPrice");
        %>
            <tr>
                <td><%= rs.getString("ItemName") %></td>
                <td>$<%= String.format("%.2f", price) %></td>
                <td><%= rs.getTimestamp("CloseTime") %></td>
                <td><a href="item.jsp?id=<%= rs.getInt("AuctionID") %>">View</a></td>
            </tr>
        <% } conn.close(); %>
    </table>
    </div></body></html>