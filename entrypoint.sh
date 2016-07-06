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

cp init_database-template.cmd init_database.cmd
sed -i "s|@@SQLSERVER_DATABASE@@|${SQLSERVER_DATABASE}|g" init_database.cmd
sed -i "s|@@SQLSERVER_USER@@|${SQLSERVER_USER}|g" init_database.cmd
sed -i "s|@@SQLSERVER_PASSWORD@@|${SQLSERVER_PASSWORD}|g" init_database.cmd

service vboxdrv setup
service vboxdrv start
vagrant --provision up

echo "Database started"

tail -f /dev/null
