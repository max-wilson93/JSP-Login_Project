<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%
    if (session.getAttribute("userID") == null) { response.sendRedirect("login.jsp"); return; }
    int sellerId = (int) session.getAttribute("userID");

    String url = "jdbc:mysql://localhost:3306/projectdb";
    String dbUser = "root";
    String dbPass = "password123"; // Updated Password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, dbUser, dbPass);
        
        int days = Integer.parseInt(request.getParameter("days"));
        Timestamp startTime = new Timestamp(System.currentTimeMillis());
        Timestamp closeTime = Timestamp.valueOf(LocalDateTime.now().plusDays(days));

        // Insert into 'Auction' table matching your PDF schema
        String sql = "INSERT INTO Auction (SellerID, CategoryID, ItemName, ItemDescription, InitialPrice, MinPrice, BidIncrement, StartTime, CloseTime, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Active')";
        PreparedStatement ps = conn.prepareStatement(sql);
        
        ps.setInt(1, sellerId);
        ps.setInt(2, Integer.parseInt(request.getParameter("category")));
        ps.setString(3, request.getParameter("title"));
        ps.setString(4, request.getParameter("description"));
        ps.setDouble(5, Double.parseDouble(request.getParameter("initial_price")));
        ps.setDouble(6, Double.parseDouble(request.getParameter("min_price")));
        ps.setDouble(7, 1.00); // Default Increment
        ps.setTimestamp(8, startTime);
        ps.setTimestamp(9, closeTime);
        
        ps.executeUpdate();
        conn.close();
        response.sendRedirect("browse.jsp");
        
    } catch (Exception e) { out.println("Error: " + e); }
%>
