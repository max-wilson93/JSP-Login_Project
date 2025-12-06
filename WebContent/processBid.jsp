<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userID") == null) { response.sendRedirect("login.jsp"); return; }
    int buyerId = (int) session.getAttribute("userID");
    int auctionId = Integer.parseInt(request.getParameter("auction_id"));
    double userMaxBid = Double.parseDouble(request.getParameter("amount"));

    String url = "jdbc:mysql://localhost:3306/projectdb";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, "root", "password123");
        
        // 1. Get current public high bid
        String sqlCurrent = "SELECT MAX(BidAmount) as highest FROM Bid WHERE AuctionID=?";
        PreparedStatement psCur = conn.prepareStatement(sqlCurrent);
        psCur.setInt(1, auctionId);
        ResultSet rsCur = psCur.executeQuery();
        double currentHigh = 0;
        if(rsCur.next()) currentHigh = rsCur.getDouble("highest");
        
        // 2. Insert/Update user's Secret Max Bid in AutoBid table
        String sqlAuto = "INSERT INTO AutoBid (UserID, AuctionID, MaxBidAmount) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE MaxBidAmount=?";
        PreparedStatement psAuto = conn.prepareStatement(sqlAuto);
        psAuto.setInt(1, buyerId);
        psAuto.setInt(2, auctionId);
        psAuto.setDouble(3, userMaxBid);
        psAuto.setDouble(4, userMaxBid);
        psAuto.executeUpdate();

        // 3. Run "Bidding War" Logic
        // Get top 2 max bids to calculate price
        String sqlWar = "SELECT UserID, MaxBidAmount FROM AutoBid WHERE AuctionID=? ORDER BY MaxBidAmount DESC LIMIT 2";
        PreparedStatement psWar = conn.prepareStatement(sqlWar);
        psWar.setInt(1, auctionId);
        ResultSet rsWar = psWar.executeQuery();
        
        if (rsWar.next()) {
            int winnerId = rsWar.getInt("UserID");
            double winnerMax = rsWar.getDouble("MaxBidAmount");
            
            double newPublicBid = currentHigh;
            
            if (rsWar.next()) {
                // Scenario: Two people fighting. Price = Loser's Max + $1
                double secondMax = rsWar.getDouble("MaxBidAmount");
                newPublicBid = secondMax + 1.00;
            } else {
                // Scenario: Only one person (or you bumped your own bid). 
                // Price stays same unless it was below starting.
                // For simplicity, we assume price bumps by 1 if you are new leader.
                if (newPublicBid == 0) { 
                    // Fetch initial price
                    PreparedStatement psInit = conn.prepareStatement("SELECT InitialPrice FROM Auction WHERE AuctionID=?");
                    psInit.setInt(1, auctionId);
                    ResultSet rsInit = psInit.executeQuery();
                    if(rsInit.next()) newPublicBid = rsInit.getDouble("InitialPrice");
                }
            }
            
            // Cap bid at winner's max
            if (newPublicBid > winnerMax) newPublicBid = winnerMax;

            // Only insert new bid if it's higher than current public
            if (newPublicBid > currentHigh) {
                String sqlInsertBid = "INSERT INTO Bid (AuctionID, BuyerID, BidAmount, BidTime) VALUES (?, ?, ?, NOW())";
                PreparedStatement psBid = conn.prepareStatement(sqlInsertBid);
                psBid.setInt(1, auctionId);
                psBid.setInt(2, winnerId);
                psBid.setDouble(3, newPublicBid);
                psBid.executeUpdate();
            }
        }
        
        conn.close();
        response.sendRedirect("item.jsp?id=" + auctionId);
        
    } catch (Exception e) { out.println(e); }
%>
