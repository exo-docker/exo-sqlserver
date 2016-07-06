sqlcmd /E /Q"create database @@SQLSERVER_DATABASE@@;"
sqlcmd /E /d @@SQLSERVER_DATABASE@@ /Q"create login @@SQLSERVER_USER@@ with password = '@@SQLSERVER_PASSWORD@@';"
sqlcmd /E /d @@SQLSERVER_DATABASE@@ /Q"create user @@SQLSERVER_USER@@ for login @@SQLSERVER_USER@@;"
sqlcmd /E /d @@SQLSERVER_DATABASE@@ /Q"EXEC sp_addrolemember N'db_owner', N'@@SQLSERVER_USER@@';"
