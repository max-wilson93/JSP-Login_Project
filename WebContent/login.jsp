
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <meta name-"viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Login Page</title>
    <style>
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            display: grid;
            place-items: center;
            min-height: 90vh;
            background-color: #f4f7f6;
            color: #333;
        }
        
        .container {
            width: 100%;
            max-width: 400px;
            padding: 2.5rem;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e0e0;
        }
        
        h2 {
            text-align: center;
            margin-top: 0;
            margin-bottom: 1.5rem;
            color: #2c3e50;
        }
        
        form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        input[type="text"],
        input[type="password"] {
            padding: 0.75rem 1rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0,123,255,0.2);
        }
        
        input[type="submit"],
        .logout-button {
            padding: 0.75rem 1rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            color: #fff;
            background-color: #007bff;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            text-align: center;
            display: block;
        }
        
        input[type="submit"]:hover,
        .logout-button:hover {
            background-color: #0056b3;
        }
        
        .error-message {
            color: #d9534f;
            background: #fdf2f2;
            border: 1px solid #d9534f;
            padding: 0.75rem;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 1rem;
        }
        
        .welcome-message {
            text-align: center;
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>

    <div class="container">
    
        <%
            // Check if user is logged in (from session)
            String username = (String) session.getAttribute("username");
            
            if (username != null) {
                // --- USER IS LOGGED IN ---
        %>
                <h2>Welcome!</h2>
                <p class="welcome-message">You are logged in as: <strong><%= username %></strong></p>
                
                <!-- This is a link styled as a button -->
                <a href="logout.jsp" class="logout-button">Log Out</a>
        
        <%
            } else {
                // --- USER IS LOGGED OUT ---
        %>
                <h2>Project Login</h2>
        
                <%
                    // Check if an error message was sent from loginProcess.jsp
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null && !errorMessage.isEmpty()) {
                %>
                        <!-- Fulfills the "contract" to display the error -->
                        <div class="error-message">
                            <%= errorMessage %>
                        </div>
                <%
                    }
                %>
                
                <!-- 
                  Fulfills the "contract":
                  - action="loginProcess.jsp"
                  - method="post"
                  - name="username"
                  - name="password"
                -->
                <form action="loginProcess.jsp" method="post">
                    <input type="text" name="username" placeholder="Username" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <input type="submit" value="Log In">
                </form>
        
        <%
            } // End of else
        %>

    </div>
    
</body>
</html>