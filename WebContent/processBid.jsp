<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userID") == null) { response.sendRedirect("login.jsp"); return; }
    int buyerId = (int) session.getAttribute("userID");
    int auctionId = Integer.parseInt(request.getParameter("auction_id"));
    double userMaxBid = Double.parseDouble(request.getParameter("amount"));

    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    
    PreparedStatement psCur = conn.prepareStatement("SELECT MAX(BidAmount) FROM Bid WHERE AuctionID=?");
    psCur.setInt(1, auctionId);
    ResultSet rsCur = psCur.executeQuery();
    double currentHigh = 0;
    if(rsCur.next()) currentHigh = rsCur.getDouble(1);

    PreparedStatement psAuto = conn.prepareStatement("INSERT INTO AutoBid (UserID, AuctionID, MaxBidAmount) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE MaxBidAmount=?");
    psAuto.setInt(1, buyerId);
    psAuto.setInt(2, auctionId);
    psAuto.setDouble(3, userMaxBid);
    psAuto.setDouble(4, userMaxBid);
    psAuto.executeUpdate();

    PreparedStatement psWar = conn.prepareStatement("SELECT UserID, MaxBidAmount FROM AutoBid WHERE AuctionID=? ORDER BY MaxBidAmount DESC LIMIT 2");
    psWar.setInt(1, auctionId);
    ResultSet rsWar = psWar.executeQuery();
    
    if (rsWar.next()) {
        int winnerId = rsWar.getInt("UserID");
        double winnerMax = rsWar.getDouble("MaxBidAmount");
        double newPublicBid = currentHigh;
        
        if (rsWar.next()) {
            double secondMax = rsWar.getDouble("MaxBidAmount");
            newPublicBid = secondMax + 1.00; 
        } else {
            if (newPublicBid == 0) {
                 ResultSet rsInit = conn.createStatement().executeQuery("SELECT InitialPrice FROM Auction WHERE AuctionID=" + auctionId);
                 if(rsInit.next()) newPublicBid = rsInit.getDouble(1);
            }
        }
        
        if (newPublicBid > winnerMax) newPublicBid = winnerMax;
        if (newPublicBid > currentHigh) {
            PreparedStatement psBid = conn.prepareStatement("INSERT INTO Bid (AuctionID, BuyerID, BidAmount, BidTime) VALUES (?, ?, ?, NOW())");
            psBid.setInt(1, auctionId);
            psBid.setInt(2, winnerId);
            psBid.setDouble(3, newPublicBid);
            psBid.executeUpdate();
        }
    }
    conn.close();
    response.sendRedirect("item.jsp?id=" + auctionId);
%>