#!/bin/bash

function checkEnv() {
  local error=false

  if [ -z ${SQLSERVER_DATABASE} ]; then
    echo "[ERROR] You need to specify the desired SQLSERVER_DATABASE"
    error=true
  fi

  if [ -z ${SQLSERVER_USER} ]; then
    echo "[ERROR] You need to specify the desired SQLSERVER_USER"
    error=true
  fi

  if [ -z ${SQLSERVER_PASSWORD} ]; then
    echo "[ERROR] Uou need to specify the desired SQLSERVER_PASSWORD"
    error=true
  fi

  if ${error}; then
    exit 1
  fi
}

checkEnv
cd /sqlserver

/opt/mssql/bin/sqlservr &

# Wait for database availability
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -S localhost -U SA -P "${SA_PASSWORD}" -Q "select 1"

echo "Database started"

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -S localhost -U SA -P "${SA_PASSWORD}" -Q "create database ${SQLSERVER_DATABASE};"
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -S localhost -U SA -P "${SA_PASSWORD}" -Q "create login ${SQLSERVER_USER} with password = '${SQLSERVER_PASSWORD}', DEFAULT_DATABASE=[${SQLSERVER_DATABASE}];"
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -S localhost -U SA -P "${SA_PASSWORD}" -d "${SQLSERVER_DATABASE}" -Q "create user ${SQLSERVER_USER}"
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -S localhost -U SA -P "${SA_PASSWORD}" -d "${SQLSERVER_DATABASE}"  -Q "EXEC sp_addrolemember N'db_owner', N'${SQLSERVER_USER}';"

echo "Database initialized"

wait
