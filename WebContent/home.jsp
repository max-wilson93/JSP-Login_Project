<%@ include file="header.jsp" %>
    
    <h1>Welcome to the Auction System</h1>
    <p>Select an option from the menu above to get started.</p>
    
    <% if ("enduser".equals(session.getAttribute("role"))) { %>
        <div style="display:flex; gap:20px; margin-top:20px;">
            <div style="border:1px solid #ccc; padding:20px; border-radius:8px; width:45%;">
                <h3>Buying?</h3>
                <p>Find items and place automatic bids.</p>
                <a href="browse.jsp"><button style="padding:10px;">Browse Auctions</button></a>
            </div>
            <div style="border:1px solid #ccc; padding:20px; border-radius:8px; width:45%;">
                <h3>Selling?</h3>
                <p>List your items for sale instantly.</p>
                <a href="createAuction.jsp"><button style="padding:10px;">Sell Item</button></a>
            </div>
        </div>
    <% } else { %>
        <p>You are logged in as <strong><%= session.getAttribute("role") %></strong>.</p>
        <p>Please use your dashboard specific links in the navigation bar.</p>
    <% } %>
    
    </div> 
</body> 
</html> 