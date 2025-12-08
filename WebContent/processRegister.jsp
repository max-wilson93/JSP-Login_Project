<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (!"admin".equals(session.getAttribute("role"))) { response.sendRedirect("home.jsp"); return; }
    
    String u = request.getParameter("user");
    String p = request.getParameter("pass");
    int adminId = (int) session.getAttribute("userID");

    Connection conn = null;
    try {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        
        PreparedStatement psUser = conn.prepareStatement("INSERT INTO User (LoginID, Password, Email) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
        psUser.setString(1, u); 
        psUser.setString(2, p); 
        psUser.setString(3, u + "@sys.com");
        psUser.executeUpdate();
        
        ResultSet rs = psUser.getGeneratedKeys(); 
        rs.next(); 
        int newId = rs.getInt(1);
        
        conn.createStatement().execute("INSERT INTO Staff (UserID) VALUES (" + newId + ")");
        conn.createStatement().execute("INSERT INTO CustomerRep (UserID, CreatorAdminID, HireDate) VALUES (" + newId + ", " + adminId + ", CURDATE())");
        
        response.sendRedirect("admin.jsp?msg=Success");

    } catch (SQLIntegrityConstraintViolationException e) {
        response.sendRedirect("admin.jsp?error=UsernameTaken");
    } catch (Exception e) {
        response.sendRedirect("admin.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    } finally {
        if(conn != null) conn.close();
    }
%>