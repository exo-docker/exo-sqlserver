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
    echo "[ERROR] You need to specify the desired SQLSERVER_PASSWORD"
    error=true
  fi

  if [ -z ${ACCEPT_EULA} ]; then
    echo "[ERROR] You need to specify ACCEPT_EULA=y option"
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
database_starting=1
delay=10
max_count=30 # Waiting 5 minutes for database startup
check_count=0

while [ ${database_starting} -gt 0 ]; do
  sleep ${delay}
  /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -S localhost -U SA -P "${SA_PASSWORD}" -Q "select 1"
  database_starting=$?

  check_count=$(( $check_count + 1 ))
  if [ ${check_count} -ge ${max_count} ]; then
    echo "ERROR Database not available afer $(( $max_count * $delay ))s"
    exit 1
  fi
done 

echo "Database configuration in progress..."

echo "Create database ${SQLSERVER_DATABASE}..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -U SA -P "${SA_PASSWORD}" -Q "create database ${SQLSERVER_DATABASE};"
echo "Create user ${SQLSERVER_USER}..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -U SA -P "${SA_PASSWORD}" -Q "create login ${SQLSERVER_USER} with password = '${SQLSERVER_PASSWORD}', CHECK_POLICY = OFF, DEFAULT_DATABASE=[${SQLSERVER_DATABASE}];"
echo "Allow user ${SQLSERVER_USER} to access database ${SQLSERVER_DATABASE}..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -U SA -P "${SA_PASSWORD}" -d "${SQLSERVER_DATABASE}" -Q "create user ${SQLSERVER_USER}"
echo "Change ${SQLSERVER_USER} as owner of ${SQLSERVER_DATABASE}..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -U SA -P "${SA_PASSWORD}" -d "${SQLSERVER_DATABASE}"  -Q "EXEC sp_addrolemember N'db_owner', N'${SQLSERVER_USER}';"

echo "Database started"

wait
