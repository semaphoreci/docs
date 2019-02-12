
* [Overview](#overview)
* [Postgres](#postgres)
* [MySQL](#mysql)
* [Redis](#redis)
* [MongoDB](#mongodb)
* [Memcached](#memcached)
* [Elasticsearch](#elasticsearch)
* [A simple project](#a-simple-project)
* [See also](#see-also)

## Overview

This document describes how you can create a new regular user as well as a user
with administrative privileges on the databases that are supported by Semaphore
2.0.

## Postgres

### Create a new user

In order to create a new user in Postgres you will need to execute the
following command:

    psql -U postgres -h localhost -c "CREATE USER developer WITH PASSWORD 'developer';"

### Create a new user with administrative privileges

In order to create a new user with administrative privileges in Postgres you
will need to execute the following command:

	psql -U postgres -h localhost -c "CREATE USER developer WITH PASSWORD 'developer';"
	psql -U postgres -h localhost -c "ALTER USER developer WITH SUPERUSER;"

## MySQL

### Create a new user

In order to create a new user in MySQL you will need to execute the
following command:

    mysql -h 127.0.0.1 -P 3306 -u root < rMySQL.sql

The contents of `rMySQL.sql` are as follows:

    CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';

### Create a new user with administrative privileges

In order to create a new user with administrative privileges in MySQL you will
need to execute the following command:

    mysql -h 127.0.0.1 -P 3306 -u root < adminMySQL.sql

The contents of `adminMySQL.sql` are as follows:

	CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
	GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';

## Redis

The Redis database does not have the ability to define users.

## MongoDB

### Create a new user

In order to create a new user in MongoDB you will need to execute the following
command:

    echo 'db.createUser( {user:"username", pwd:"password", roles:[], mechanisms:["SCRAM-SHA-1"]  } )' | mongo s2

### Create a new user with administrative privileges

In order to create a new user with administrative privileges in MongoDB you
will need to execute the following command:

    echo 'db.createUser({user:"username", pwd:"password", roles:[{role:"userAdminAnyDatabase",db:"admin"}], mechanisms:["SCRAM-SHA-1"]})' | mongo admin

## Memcached

The Memcached database does not have users.

## Elasticsearch

### Create a new user

In order to create a new user in Elasticsearch you will need to execute the
following command:

    sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd new_user -p password -r reporting_user

### Create a new user with administrative privileges

In order to create a new user with administrative privileges in Elasticsearch
you will need to execute the following command:

    sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd new_user -p password -r superuser

## A simple project

The following Semaphore 2.0 project illustrates all these commands in action:

	version: v1.0
	name: Configuring Databases
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Postgres
	    task:
	      jobs:
	      - name: Postgres Create user
	        commands:
	          - sem-service start postgres
	          - psql -U postgres -h localhost -c "CREATE USER developer WITH PASSWORD 'developer';"
	      - name: Postgres Create admin user
	        commands:
	          - sem-service start postgres
	          - psql -U postgres -h localhost -c "CREATE USER developer WITH PASSWORD 'developer';"
	          - psql -U postgres -h localhost -c "ALTER USER developer WITH SUPERUSER;"
    
	  - name: MySQL
	    task:
	      jobs:
	      - name: MySQL Create user
	        commands:
	          - checkout
	          - sem-service start mysql
	          - mysql -h 127.0.0.1 -P 3306 -u root < rMySQL.sql
    
	      - name: MySQL Create admin user
	        commands:
	          - checkout
	          - sem-service start mysql
	          - mysql -h 127.0.0.1 -P 3306 -u root < adminMySQL.sql
    
	  - name: Redis
	    task:
	      jobs:
	      - name: Redis use database
	        commands:
	          - sem-service start redis
	          - sudo apt install redis-tools -y
	          - redis-cli incr mycounter
	          - redis-cli incr mycounter
    
	  - name: MongoDB
	    task:
	      jobs:
	      - name: MongoDB Create user
	        commands:
	          - sem-service start mongodb
	          - sudo apt install mongodb-clients -y
	          - echo 'db.createUser( {user:"username", pwd:"password", roles:[], mechanisms:["SCRAM-SHA-1"]  } )' | mongo s2
	      - name: MongoDB Create admin user
	        commands:
	          - sem-service start mongodb
	          - sudo apt install mongodb-clients -y
	          - echo 'db.createUser({user:"username", pwd:"password", roles:[{role:"userAdminAnyDatabase",db:"admin"}], mechanisms:["SCRAM-SHA-1"]})' | mongo admin
    
	  - name: Elasticsearch
	    task:
	      jobs:
	      - name: Elasticsearch Create user
	        commands:
	          - sem-service start elasticsearch
	          - wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.deb
	          - sudo dpkg -i elasticsearch-6.3.2.deb
	          - sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd new_user -p password -r reporting_user
	          - sudo /usr/share/elasticsearch/bin/elasticsearch-users list
    
	      - name: Elasticsearch Create admin user
	        commands:
	          - sem-service start elasticsearch
	          - wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.deb
	          - sudo dpkg -i elasticsearch-6.3.2.deb
	          - sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd new_user -p password -r superuser
	          - sudo /usr/share/elasticsearch/bin/elasticsearch-users list
    
	  - name: Memcached
	    task:
	      jobs:
	      - name: Memcached operating status
	        commands:
	          - sem-service start memcached
	          - sudo apt install libmemcached-tools -y
	          - memcstat --servers="127.0.0.1

## See Also

* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
