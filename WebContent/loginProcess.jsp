<%@ page import="java.sql.*" %>
<%
    // 1. Get form inputs
    String user = request.getParameter("username"); 
    String pass = request.getParameter("password");

    // 2. DB Config
    String dbUrl = "jdbc:mysql://localhost:3306/projectdb";
    String dbUser = "root";
    String dbPass = "password123"; 

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        // --- THE FIX IS HERE ---
        // Old Code: SELECT * FROM users WHERE username = ?
        // New Code: SELECT UserID FROM User WHERE LoginID = ?
        String sql = "SELECT UserID FROM User WHERE LoginID = ? AND Password = ?";
        
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, user);
        ps.setString(2, pass);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            int userId = rs.getInt("UserID");
            session.setAttribute("userID", userId);
            session.setAttribute("username", user);
            
            // 3. Determine Role (Check the sub-tables)
            
            // Check if they are an Admin
            PreparedStatement psAdmin = conn.prepareStatement("SELECT UserID FROM Administrator WHERE UserID = ?");
            psAdmin.setInt(1, userId);
            if (psAdmin.executeQuery().next()) {
                session.setAttribute("role", "admin");
                response.sendRedirect("admin.jsp");
                return;
            }
            
            // Check if they are a Rep
            PreparedStatement psRep = conn.prepareStatement("SELECT UserID FROM CustomerRep WHERE UserID = ?");
            psRep.setInt(1, userId);
            if (psRep.executeQuery().next()) {
                session.setAttribute("role", "rep");
                response.sendRedirect("rep.jsp");
                return;
            }
            
            // Default: EndUser
            session.setAttribute("role", "enduser");
            response.sendRedirect("home.jsp");
            
        } else {
            request.setAttribute("errorMessage", "Invalid LoginID or Password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
        conn.close();
    } catch (Exception e) { 
        e.printStackTrace();
        // Print the specific error to the screen so you can see it
        request.setAttribute("errorMessage", "Database Error: " + e.getMessage());
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
%>