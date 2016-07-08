# SQL Server docker image by eXo Platform

This is a SQL Server image to easily build an SQL Server environment for test purposes. 

## Build
This image package Virtualbox and Vagrant and deploy [msabramo/mssqlserver2014express](https://atlas.hashicorp.com/msabramo/boxes/mssqlserver2014express).
As Virtualbox need to interact with the kernel to deploy the vboxdrv module, the container must have some particularity :
- it *must* use the same distribution and kernel version as the underlying system
- it *must* be launched with the --privileged option

```
docker build -t <image name> .
```
Nothing more is needed

## Running

```
docker run -d --privileged -e SQLSERVER_DATABASE=<db name> -e SQLSERVER_USER=<user> -e SQLSERVER_PASSWORD=<password> -p <local port>:1433 -p <local port>:3389 <image name>
```

Supported environment variables :
- SQLSERVER_DATABASE : the database name to user
- SQLSERVER_USER : the username to use. It will be the owner of the database
- SQLSERVER_PASSWORD : the password of the username

Ports :
- 1433 : The database port
- 3389 : The remote display port (user: vagrant/vagrant)

TODO:
* Volume support