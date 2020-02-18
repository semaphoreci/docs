# sem-service: Managing Databases and Services on Linux

The `sem-service` is a utility on Linux based virtual machines for starting,
stopping and getting the status of background services. Started services will
listen on 0.0.0.0 and their default port. The 0.0.0.0 IP address includes all
available network interfaces. Essentially, you will be using services as if
they were natively installed in the Operating System.

The general form of a `sem-service` command is as follows:

``` bash
sem-service start [mysql | postgres | redis | memcached | mongodb | elasticsearch | rabbitmq] [version]
[--username=username] [--password=password] [--db=databasename]
```

Therefore, each `sem-service` command requires at least two parameters: the
first one is the task you want to perform and the second parameter is the name
of the service that will be used for the task. The third parameter is optional
and is the version of the service that you want to start.<br/> For MySQL and PostgreSQL it 
is possible to provide `username` via ```--username=username```, password for the new username 
via ```--password=password``` and database name for which the user will be granted admin access
via ```--db=dbname```. 

- The default MySQL username is `root`, the password is blank and the default database name is `test`
- The default PostgreSQL username is `postgres` and password is blank.

If no `version` value is given, a default value will be used according to the following list:

- mysql: The default value is `5.6`
- postgres: The default value is `10.6`
- redis: The default value is `4`
- memcached: The default value is `1.5`
- mongodb: The default value is `4.1`
- elasticsearch: The default value is `6.5.1`
- rabbitmq: The default is `3.8.2`

`sem-service` pulls images from Docker Hub and supports all versions that are
available in Docker Hub. You can find the list of available versions at the
following URLs:

- ElasticSearch: <https://hub.docker.com/_/elasticsearch/>
- MySQL: <https://hub.docker.com/_/mysql/>
- PostgreSQL: <https://hub.docker.com/_/postgres/>
- Redis: <https://hub.docker.com/_/redis/>
- MongoDB: <https://hub.docker.com/_/mongo/>
- Memcached: <https://hub.docker.com/_/memcached/>
- RabbitMQ: <https://hub.docker.com/_/rabbitmq/>

The following are valid uses of `sem-service`:

``` bash
sem-service start redis
sem-service stop redis
sem-service start redis 5
sem-service status postgres
sem-service start postgres 11
sem-service start postgres 11 --username=some_user_name --password=some_password --db=some_db_name
sem-service start mysql 8.0.19 --username=some_user_name --password=some_password --db=some_db_name
sem-service status mysql
sem-service start memcached
sem-service start elasticsearch
sem-service start elasticsearch 6.5.2
sem-service start mongodb
sem-service start mongodb 3.2
sem-service start rabbitmq
sem-service start rabbitmq 3.7
```

Services are not automatically shared across blocks. To do that, start services
within the [prologue](https://docs.semaphoreci.com/article/50-pipeline-yaml#prologue)
property of each task and populate data as needed.

Example `sem-service` in your pipelines:

``` yaml
version: v1.0
name: Testing sem-service
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Databases
    task:
      env_vars:
        - name: DB_NAME
          value: "test"
      jobs:
      - name: MySQL
        commands:
          - sem-service start mysql
          - sudo apt-get install -y -qq mysql-client
          - mysql --host=0.0.0.0 -uroot -e "create database $DB_NAME"
          - mysql --host=0.0.0.0 -uroot -e "show databases" | grep $DB_NAME
          - sem-service status mysql

      - name: PostgreSQL
        commands:
          - sem-service start postgres
          - sudo apt-get install -y -qq postgresql-client
          - createdb -U postgres -h 0.0.0.0 $DB_NAME
          - psql -h 0.0.0.0 -U postgres -c "\l" | grep $DB_NAME
          - sem-service status postgres

      - name: Redis
        commands:
          - sem-service start redis
          - sem-service status redis

      - name: Memcached
        commands:
          - sem-service start memcached
          - sem-service status memcached
```
