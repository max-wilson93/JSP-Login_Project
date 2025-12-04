<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
    // Invalidate the session, which removes all attributes (like "username")
    session.invalidate();
    
    // Redirect the user back to the login page
    response.sendRedirect("login.jsp");
%>