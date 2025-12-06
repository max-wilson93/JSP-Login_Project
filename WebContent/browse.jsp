<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Browse</title></head>
<body>
    <%@ include file="home.jsp" %>
    <h2>Browse Auctions</h2>
    
    <form action="browse.jsp" method="get">
        Search: <input type="text" name="search" placeholder="Item Name...">
        Sort: 
        <select name="sort">
            <option value="CloseTime ASC">Ending Soon</option>
            <option value="InitialPrice ASC">Price: Low to High</option>
            <option value="InitialPrice DESC">Price: High to Low</option>
        </select>
        <input type="submit" value="Go">
    </form>
    <br>

    <table border="1" cellpadding="5">
        <tr>
            <th>Item</th>
            <th>Description</th>
            <th>Current Price</th>
            <th>Closes</th>
            <th>Link</th>
        </tr>
        <%
            String url = "jdbc:mysql://localhost:3306/projectdb";
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, "root", "password123");
                
                String search = request.getParameter("search");
                String sort = request.getParameter("sort");
                
                String sql = "SELECT a.*, (SELECT MAX(BidAmount) FROM Bid WHERE AuctionID = a.AuctionID) as HighBid FROM Auction a WHERE Status='Active' AND CloseTime > NOW()";
                
                if (search != null && !search.isEmpty()) sql += " AND ItemName LIKE ?";
                if (sort != null) sql += " ORDER BY " + sort; else sql += " ORDER BY CloseTime ASC";

                PreparedStatement ps = conn.prepareStatement(sql);
                if (search != null && !search.isEmpty()) ps.setString(1, "%" + search + "%");
                
                ResultSet rs = ps.executeQuery();
                while(rs.next()) {
                    double price = rs.getDouble("HighBid");
                    if (rs.wasNull()) price = rs.getDouble("InitialPrice");
        %>
            <tr>
                <td><%= rs.getString("ItemName") %></td>
                <td><%= rs.getString("ItemDescription") %></td>
                <td>$<%= String.format("%.2f", price) %></td>
                <td><%= rs.getTimestamp("CloseTime") %></td>
                <td><a href="item.jsp?id=<%= rs.getInt("AuctionID") %>">View</a></td>
            </tr>
        <%
                }
                conn.close();
            } catch (Exception e) { out.println(e); }
        %>
    </table>
</body>
</html>
