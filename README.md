# SQL Server docker image by eXo Platform

This is a SQL Server image to easily build an SQL Server environment for test purposes with a dedicated database and user.
It's build on top of the official Microsoft mssql container : https://hub.docker.com/r/microsoft/mssql-server-linux/

## Running

```
docker run -d -e SA_PASSWORD=<passord> -e SQLSERVER_DATABASE=<db name> -e SQLSERVER_USER=<user> -e SQLSERVER_PASSWORD=<password> -p <local port>:1433 <image name>
```

:warning: For Docker4Mac and Docker4Windows users, your docker instance must have at least **3192Mo of memory** allocated.

Supported environment variables :
- SA_PASSWORD : The password of the SA user
- SQLSERVER_DATABASE : the database name to user
- SQLSERVER_USER : the username to use. It will be the owner of the database
- SQLSERVER_PASSWORD : the password of the username

:warning: All your password must match the MSSQL rule : at least 8 chars, with lower, upper and digits.

## Ports :

- 1433 : The database port

## Volumes

The data is persisted on the directory ``/var/opt/mssql``.
Add the following option to persist your data on volume :
```
-v <your volume>:/var/opt/mssql
```
