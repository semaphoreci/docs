
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

    

### Create a new user with administrative privileges

In order to create a new user with administrative privileges in MySQL you will
need to execute the following command:

    

## Redis


### Create a new user

In order to create a new user in Redis you will need to execute the following
command:

    

### Create a new user with administrative privileges

In order to create a new user with administrative privileges in Redis you will
need to execute the following command:

    

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

### Create a new user

In order to create a new user in memcached you will need to execute the
following command:

    

### Create a new user with administrative privileges

In order to create a new user with administrative privileges in memcached you
will need to execute the following command:

    

## Elasticsearch

### Create a new user

In order to create a new user in Elasticsearch you will need to execute the
following command:

    

### Create a new user with administrative privileges

In order to create a new user with administrative privileges in Elasticsearch
you will need to execute the following command:

    

## A simple project

The following Semaphore 2.0 project illustrates all these commands in action:



## See Also

* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
