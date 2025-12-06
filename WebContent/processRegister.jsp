<%@ page import="java.sql.*" %>
<%
    // Security: Only Admin can do this
    if (!"admin".equals(session.getAttribute("role"))) { response.sendRedirect("home.jsp"); return; }
    
    String u = request.getParameter("user");
    String p = request.getParameter("pass");
    int adminId = (int) session.getAttribute("userID");

    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
    
    // 1. Insert into base USER table
    PreparedStatement psUser = conn.prepareStatement("INSERT INTO User (LoginID, Password, Email) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
    psUser.setString(1, u);
    psUser.setString(2, p);
    psUser.setString(3, u + "@system.com"); // Dummy email
    psUser.executeUpdate();
    
    ResultSet rs = psUser.getGeneratedKeys();
    rs.next();
    int newId = rs.getInt(1);
    
    // 2. Insert into STAFF table
    PreparedStatement psStaff = conn.prepareStatement("INSERT INTO Staff (UserID) VALUES (?)");
    psStaff.setInt(1, newId);
    psStaff.executeUpdate();
    
    // 3. Insert into CUSTOMERREP table
    PreparedStatement psRep = conn.prepareStatement("INSERT INTO CustomerRep (UserID, CreatorAdminID, HireDate) VALUES (?, ?, CURDATE())");
    psRep.setInt(1, newId);
    psRep.setInt(2, adminId);
    psRep.executeUpdate();
    
    conn.close();
    response.sendRedirect("admin.jsp?msg=RepCreated");
%>
