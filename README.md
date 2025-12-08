### JSP Final Project
Maxwell Wilson
Robert Reuter
Logan Ford

Group 10
## Account credentials:
# Admin:
User: admin
Pass: password123

# Customer Rep:
User: rep1
Pass: password123

# Buyer1:
User: buyer1
Pass: password123

# Buyer2:
User: buyer2
Pass: password123

# Buyer3:
User: buyer3
Pass: password123

## Initialization:
Fresh db start: 
```bash
cd ~/JSP-Login_Project

mysql -u root -p[Local_SQL_Password] < database.sql

cd
```

# Start the server

Copy all of WebContents into a new folder named 'project' inside the Tomcat 'webapps' directory.

Make sure the MySQL Connector JAR is in the WEB-INF/lib folder OR in the Tomcat lib folder.

tomcat server fresh start: 
```bash
rm -rf ~/tomcat9/webapps/project

mkdir -p ~/tomcat9/webapps/project

cp -r ~/JSP-Login_Project/WebContent/* ~/tomcat9/webapps/project/

~/tomcat9/bin/startup.sh
```

Open browser and navigate to 'localhost:8080/project/login.jsp'