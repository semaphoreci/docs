---
Description: This page describes how you can create regular users and users with administrative privileges on databases supported by Semaphore 2.0.
---

# Configuring Database Access

This document describes how you can create regular users and users with administrative privileges on databases supported by Semaphore 2.0.

## Postgres

### Creating a new Postgres user

In order to create a new user in Postgres, execute the
following command:

``` bash
psql -U postgres -h localhost -c "CREATE USER developer WITH PASSWORD 'developer';"
```

### Creating a new Postgres user with administrative privileges

In order to create a new user with administrative privileges in Postgres, execute the following command:

``` bash
psql -U postgres -h localhost -c "CREATE USER developer WITH PASSWORD 'developer';"
psql -U postgres -h localhost -c "ALTER USER developer WITH SUPERUSER;"
```

### Creating Postgres extensions

You can extend the capabilities of the default Postgres database by
creating extensions, as shown below:

```bash
psql -U postgres -h localhost -c "CREATE EXTENSION \"uuid-ossp\""
```

## MySQL

### Creating a new MySQL user

In order to create a new user in MySQL, execute the
following command:

``` bash
mysql -h 127.0.0.1 -P 3306 -u root -e "CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';"
```

### Creating a new MySQL user with administrative privileges

In order to create a new user with administrative privileges in MySQL, execute the following command:

``` bash
mysql -h 127.0.0.1 -P 3306 -u root -e "CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'newuser'@'localhost';"
```

## Redis

Redis database does not have the ability to define users.

## MongoDB

### Creating a new MongoDB user

In order to create a new user in MongoDB, execute the following
command:

``` bash
echo 'db.createUser( {user:"username", pwd:"password", roles:[], mechanisms:["SCRAM-SHA-1"]  } )' | mongo s2
```

### Creating a new MongoDB user with administrative privileges

In order to create a new user with administrative privileges in MongoDB, execute the following command:

``` bash
echo 'db.createUser({user:"username", pwd:"password", roles:[{role:"userAdminAnyDatabase",db:"admin"}], mechanisms:["SCRAM-SHA-1"]})' | mongo admin
```

## Memcached

Memcached database does not have users.

## Elasticsearch

### Creating a new Elasticsearch user

In order to create a new user in Elasticsearch, execute the
following command:

``` bash
sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd new_user -p password -r reporting_user
```

### Creating a new Elasticsearch user with administrative privileges

In order to create a new user with administrative privileges in Elasticsearch, execute the following command:

``` bash
sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd new_user -p password -r superuser
```

## A simple project

The following Semaphore 2.0 project illustrates all of the aforementioned commands in action:

``` yaml
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
```

## See Also

- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
