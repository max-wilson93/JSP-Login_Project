<%@ include file="header.jsp" %>
    <h2>List an Item</h2>
    <form action="processAuction.jsp" method="post">
        <label>Item Name:</label><br>
        <input type="text" name="title" required style="width:300px;"><br><br>
        
        <label>Description:</label><br>
        <textarea name="description" rows="4" cols="50"></textarea><br><br>
        
        <label>Category:</label><br>
        <select name="category">
            <option value="1">Electronics</option>
            <option value="1">General</option>
        </select><br><br>

        <label>Starting Price ($):</label><br>
        <input type="number" step="0.01" name="initial_price" required><br><br>
        
        <label>Secret Reserve Price (Optional):</label><br>
        <input type="number" step="0.01" name="min_price" value="0.00"><br>
        <small>If bidding doesn't reach this, you don't have to sell.</small><br><br>
        
        <label>Duration:</label><br>
        <select name="days">
            <option value="1">1 Day</option>
            <option value="3">3 Days</option>
            <option value="7">7 Days</option>
        </select><br><br>
        
        <input type="submit" value="Start Auction">
    </form>
    </div> 
</body>
</html>