
<%@ page import="java.sql.*" %>

<%
    // 1. Get username and password from the login.jsp form
    String user = request.getParameter("username");
    String pass = request.getParameter("password");

    // 2. Database Connection Details
    String dbUrl = "jdbc:mysql://localhost:3306/projectdb";
    String dbUser = "root"; // 
    String dbPass = "password123"; //

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 3. Load the MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // 4. Establish the connection
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        // 5. Create a secure query using PreparedStatement to prevent SQL Injection
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user);
        pstmt.setString(2, pass); 
        
        // 6. Execute the query
        rs = pstmt.executeQuery();
        
        // 7. Process the result
        if (rs.next()) {
            // SUCCESS: User and password match
            // Create a session to "log in" the user
            session.setAttribute("username", user);
            
            // Redirect back to the login page (which will now show the welcome message)
            response.sendRedirect("login.jsp");
        } else {
            // FAILURE: No user found or password incorrect
            // Set an error message (as per our "Contract" in the README)
            request.setAttribute("errorMessage", "Invalid username or password.");
            
            // Forward the request back to login.jsp to display the error
            // We use forward() so the request (and the error message) is preserved
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

    } catch (Exception e) {
        // Handle any exceptions (e.g., DB down, driver not found)
        e.printStackTrace(); // Good for debugging
        
        // Send user to a generic error page or back to login with a friendly error
        request.setAttribute("errorMessage", "A database error occurred: " + e.getMessage());
        request.getRequestDispatcher("login.jsp").forward(request, response);
        
    } finally {
        // 8. Always close resources in a finally block
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (pstmt != null) {
            try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

