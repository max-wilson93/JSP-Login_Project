<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head><title>Sell Item</title></head>
<body>
    <%@ include file="home.jsp" %>
    <h2>List an Item for Auction</h2>
    <form action="processAuction.jsp" method="post">
        <label>Item Name:</label><br>
        <input type="text" name="title" required><br><br>
        
        <label>Description:</label><br>
        <textarea name="description" rows="4" cols="50"></textarea><br><br>
        
        <label>Category:</label><br>
        <select name="category">
            <option value="1">Electronics</option>
            <option value="1">General</option> <!-- Simplified for demo -->
        </select><br><br>

        <label>Starting Price ($):</label><br>
        <input type="number" step="0.01" name="initial_price" required><br><br>
        
        <label>Reserve Price (Hidden Minimum):</label><br>
        <input type="number" step="0.01" name="min_price" value="0.00"><br><br>
        
        <label>Duration (Days):</label><br>
        <select name="days">
            <option value="1">1 Day</option>
            <option value="3">3 Days</option>
            <option value="7">7 Days</option>
        </select><br><br>
        
        <input type="submit" value="Start Auction">
    </form>
</body>
</html>
