<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Invalidate the session, which removes all attributes (like "username")
    session.invalidate();
    
    // Redirect the user back to the login page
    response.sendRedirect("login.jsp");
%>