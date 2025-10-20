---
description: Execute SQL query on MySQL database
argument-hint: <SQL query>
---

Execute the following SQL query on the MySQL database:

!docker exec gumloop_mysql mysql -u root -pRootPassword123\!\@\# client_database -e "$ARGUMENTS"
