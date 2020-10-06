#!/bin/bash
yum -y update
yum -y install mysql

cat <<EOF >>/tmp/mysql-query.sql
create database test;

use test;

CREATE TABLE users (
id int(11) NOT NULL auto_increment,
name varchar(100) NOT NULL,
age int(3) NOT NULL,
email varchar(100) NOT NULL,
PRIMARY KEY (id)
);
EOF

mysql 	--host=${DATABASE_ENDPOINT} \
		--port=${DATABASE_PORT} \
		--user=${DATABASE_USER} \
		--password='${DATABASE_PASSWORD}' \
		${DATABASE_NAME} \
		< /tmp/mysql-query.sql

shutdown
