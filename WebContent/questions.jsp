<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
    <h2>Community Q&A</h2>
    
    <form action="questions.jsp" method="get">
        Search: <input type="text" name="qsearch" placeholder="Keyword...">
        <input type="submit" value="Search">
    </form>
    
    <div style="margin-top:20px; padding:15px; border:1px solid #ccc;">
        <h3>Ask a Question</h3>
        <form action="processQuestion.jsp" method="post">
            <input type="text" name="question" placeholder="Your Question..." required style="width:300px;">
            <input type="submit" value="Post Question">
        </form>
    </div>

    <h3>Recent Questions</h3>
    <ul>
    <%
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectdb", "root", "password123");
        String qsearch = request.getParameter("qsearch");
        String sql = "SELECT q.QuestionText, q.AnswerText, u.LoginID FROM Questions q JOIN EndUser e ON q.EndUserID=e.UserID JOIN User u ON e.UserID=u.UserID";
        
        if (qsearch != null && !qsearch.isEmpty()) sql += " WHERE q.QuestionText LIKE '%" + qsearch + "%'";
        
        ResultSet rs = conn.createStatement().executeQuery(sql);
        while(rs.next()) {
            String ans = rs.getString("AnswerText");
    %>
        <li>
            <strong><%= rs.getString("LoginID") %>:</strong> <%= rs.getString("QuestionText") %><br>
            <% if (ans != null) { %>
                <em style="color:green;">Rep Reply: <%= ans %></em>
            <% } else { %>
                <em>(Waiting for reply)</em>
            <% } %>
        </li><br>
    <% } conn.close(); %>
    </ul>
    </div>
</body>
</html>