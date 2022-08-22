---  
Description: This page contains a list of docker images available in the Semaphore Container Registry.  
---  
  
# Semaphore Container Registry  
Semaphore hosts a set of images that are used by `sem-service`, as well as a set of convenience images.
You can use these images in your Semaphore environment without any restrictions or limits.
  
### Using an unsupported version  
In event that you need to use a Docker image that is not covered in this list, please note that Semaphore allows pulls from any Docker repository.  

You can find more information on our [working with Docker](/ci-cd-environment/working-with-docker/) documentation page. 
  
## Convenience Docker images  
Semaphore comes with pre-built convenience Docker images hosted on the Semaphore Container Registry.  

If you are using a [Docker-based CI/CD environment](/ci-cd-environment/custom-ci-cd-environment-with-docker/) in combination with convenience images, Semaphore will **automatically redirect** any pulls from the `semaphoreci` Docker Hub repository to the Semaphore Container Registry.

The source code of the Semaphore Docker images is [hosted on Github](https://github.com/semaphoreci/docker-images).  
  
### Ruby  
| Image | Link |
|--------|--------|
| ruby:2.0 | `registry.semaphoreci.com/ruby:2.0` |  
| ruby:2.0-node-browsers | `registry.semaphoreci.com/ruby:2.0-node-browsers` |  
| ruby:2.1 | `registry.semaphoreci.com/ruby:2.1` |  
| ruby:2.1-node-browsers | `registry.semaphoreci.com/ruby:2.1-node-browsers` |  
| ruby:2.2 | `registry.semaphoreci.com/ruby:2.2` |  
| ruby:2.2-node-browsers | `registry.semaphoreci.com/ruby:2.2-node-browsers` |  
| ruby:2.3 | `registry.semaphoreci.com/ruby:2.3` |  
| ruby:2.3-node-browsers | `registry.semaphoreci.com/ruby:2.3-node-browsers` |  
| ruby:2.4 | `registry.semaphoreci.com/ruby:2.4` |  
| ruby:2.4-node-browsers | `registry.semaphoreci.com/ruby:2.4-node-browsers` |  
| ruby:2.5 | `registry.semaphoreci.com/ruby:2.5` |  
| ruby:2.5-node-browsers | `registry.semaphoreci.com/ruby:2.5-node-browsers` |  
| ruby:2.5 | `registry.semaphoreci.com/ruby:2.5` |  
| ruby:2.5-node-browsers | `registry.semaphoreci.com/ruby:2.5-node-browsers` |  
| ruby:2.6 | `registry.semaphoreci.com/ruby:2.6` |  
| ruby:2.6-node-browsers | `registry.semaphoreci.com/ruby:2.6-node-browsers` |  
| ruby:2.7 | `registry.semaphoreci.com/ruby:2.7` |  
| ruby:2.7-node-browsers | `registry.semaphoreci.com/ruby:2.7-node-browsers` |  
| ruby:3.0 | `registry.semaphoreci.com/ruby:3.0` |  
| ruby:3.0-node-browsers | `registry.semaphoreci.com/ruby:3.0-node-browsers` |  

### Python  
| Image | Link |
|--------|--------|
| python:3.2 | `registry.semaphoreci.com/python:3.2` |  
| python:3.2-node-browsers | `registry.semaphoreci.com/python:3.2-node-browsers` |  
| python:3.3 | `registry.semaphoreci.com/python:3.3` |  
| python:3.3-node-browsers | `registry.semaphoreci.com/python:3.3-node-browsers` |  
| python:3.4 | `registry.semaphoreci.com/python:3.4` |  
| python:3.4-node-browsers | `registry.semaphoreci.com/python:3.4-node-browsers` |  
| python:3.5 | `registry.semaphoreci.com/python:3.5` |  
| python:3.5-node-browsers | `registry.semaphoreci.com/python:3.5-node-browsers` |  
| python:3.6 | `registry.semaphoreci.com/python:3.6` |  
| python:3.6-node-browsers | `registry.semaphoreci.com/python:3.6-node-browsers` |  
| python:3.7 | `registry.semaphoreci.com/python:3.7` |  
| python:3.7-node-browsers | `registry.semaphoreci.com/python:3.7-node-browsers` |  
| python:3.8 | `registry.semaphoreci.com/python:3.8` |  
| python:3.8-node-browsers | `registry.semaphoreci.com/python:3.8-node-browsers` |  
| python:3.9 | `registry.semaphoreci.com/python:3.9` |  
| python:3.9-node-browsers | `registry.semaphoreci.com/python:3.9-node-browsers` |  
| python:3.10 | `registry.semaphoreci.com/python:3.10.0a1` |  
| python:3.10-node-browsers | `registry.semaphoreci.com/python:3.10.0a1-node-browsers` |  

### PHP
| Image | Link |
|--------|--------|
| php:5.6 | `registry.semaphoreci.com/php:5.6` |
| php:7.2 | `registry.semaphoreci.com/php:7.2` |
| php:7.3 | `registry.semaphoreci.com/php:7.3` |
| php:7.4 | `registry.semaphoreci.com/php:7.4` |
| php:8.0 | `registry.semaphoreci.com/php:8.0` |
| php:5.6-node | `registry.semaphoreci.com/php:5.6-node` |
| php:7.2-node | `registry.semaphoreci.com/php:7.2-node` |
| php:7.3-node | `registry.semaphoreci.com/php:7.3-node` |
| php:7.4-node | `registry.semaphoreci.com/php:7.4-node` |
| php:8.0-node | `registry.semaphoreci.com/php:8.0-node` |
| php:5.6-browsers | `registry.semaphoreci.com/php:5.6-browsers` |
| php:7.2-browsers | `registry.semaphoreci.com/php:7.2-browsers` |
| php:7.3-browsers | `registry.semaphoreci.com/php:7.3-browsers` |
| php:7.4-browsers | `registry.semaphoreci.com/php:7.4-browsers` |
| php:8.0-browsers | `registry.semaphoreci.com/php:8.0-browsers` |
| php:5.6-node-browsers | `registry.semaphoreci.com/php:5.6-node-browsers` |
| php:7.2-node-browsers | `registry.semaphoreci.com/php:7.2-node-browsers` |
| php:7.3-node-browsers | `registry.semaphoreci.com/php:7.3-node-browsers` |
| php:7.4-node-browsers | `registry.semaphoreci.com/php:7.4-node-browsers` |
| php:8.0-node-browsers | `registry.semaphoreci.com/php:8.0-node-browsers` |

### Haskell  
| Image | Link |
|--------|--------|
| haskell:8.8 | `registry.semaphoreci.com/haskell:8.8` |  
| haskell:8.10 | `registry.semaphoreci.com/haskell:8.10` |  
| haskell:9.0 | `registry.semaphoreci.com/haskell:9.0` |  

### Rust  
| Image | Link |
|--------|--------|
| rust:1.47 | `registry.semaphoreci.com/rust:1.47` |  
| rust:1.47-node-browsers | `registry.semaphoreci.com/rust:1.47-node-browsers` |
| rust:1.51 | `registry.semaphoreci.com/rust:1.51` |  
| rust:1.51-node-browsers | `registry.semaphoreci.com/rust:1.51-node-browsers` |


### Golang  
| Image | Link |
|--------|--------|
| golang:1.14 | `registry.semaphoreci.com/golang:1.14` |  
| golang:1.14-node-browsers | `registry.semaphoreci.com/golang:1.14-node-browsers` |  
| golang:1.15 | `registry.semaphoreci.com/golang:1.15` |  
| golang:1.15-node-browsers | `registry.semaphoreci.com/golang:1.15-node-browsers` |  
| golang:1.16 | `registry.semaphoreci.com/golang:1.16` |  
| golang:1.16-node-browsers | `registry.semaphoreci.com/golang:1.16-node-browsers` |  
| golang:1.17 | `registry.semaphoreci.com/golang:1.17` |  
| golang:1.17-node-browsers | `registry.semaphoreci.com/golang:1.17-node-browsers` |  
| golang:1.18 | `registry.semaphoreci.com/golang:1.18` |  
| golang:1.18-node-browsers | `registry.semaphoreci.com/golang:1.18-node-browsers` |  


### Elixir  
| Image | Link |
|--------|--------|
| elixir:1.5 | `registry.semaphoreci.com/elixir:1.5` |  
| elixir:1.6 | `registry.semaphoreci.com/elixir:1.6` |  
| elixir:1.7 | `registry.semaphoreci.com/elixir:1.7` |  
| elixir:1.8 | `registry.semaphoreci.com/elixir:1.8` |  
| elixir:1.9 | `registry.semaphoreci.com/elixir:1.9` |  
| elixir:1.10 | `registry.semaphoreci.com/elixir:1.10` |  
| elixir:1.11 | `registry.semaphoreci.com/elixir:1.11` |  
| elixir:1.12 | `registry.semaphoreci.com/elixir:1.12` |  


### Node  
| Image | Link |
|--------|--------|
| node:10 | `registry.semaphoreci.com/node:10` |  
| node:10-browsers | `registry.semaphoreci.com/node:10-browsers` |   
| node:12 | `registry.semaphoreci.com/node:12` |  
| node:12-browsers | `registry.semaphoreci.com/node:12-browsers` |  
| node:14 | `registry.semaphoreci.com/node:14` |  
| node:14-browsers | `registry.semaphoreci.com/node:14-browsers` |  
| node:15 | `registry.semaphoreci.com/node:15` |  
| node:15-browsers | `registry.semaphoreci.com/node:15-browsers` |  


### Ubuntu  
| Image | Link |
|--------|--------|
| ubuntu:18.04 | `registry.semaphoreci.com/ubuntu:18.04` |  

### Android  
| Image | Link |
|--------|--------|
| android:25 | `registry.semaphoreci.com/android:25` |
| android:25-flutter | `registry.semaphoreci.com/android:25-flutter` |
| android:25-node | `registry.semaphoreci.com/android:25-node` |
| android:26 | `registry.semaphoreci.com/android:26` |
| android:26-flutter | `registry.semaphoreci.com/android:26-flutter` |
| android:26-node | `registry.semaphoreci.com/android:26-node` |
| android:27 | `registry.semaphoreci.com/android:27` |
| android:27-flutter | `registry.semaphoreci.com/android:27-flutter` |
| android:27-node | `registry.semaphoreci.com/android:27-node` |
| android:28 | `registry.semaphoreci.com/android:28` |
| android:28-flutter | `registry.semaphoreci.com/android:28-flutter` |
| android:28-node | `registry.semaphoreci.com/android:28-node` |
| android:29 | `registry.semaphoreci.com/android:29` |
| android:29-flutter | `registry.semaphoreci.com/android:29-flutter` |
| android:29-node | `registry.semaphoreci.com/android:29-node` |
| android:30 | `registry.semaphoreci.com/android:30` |
| android:30-flutter | `registry.semaphoreci.com/android:30-flutter` |
| android:30-node | `registry.semaphoreci.com/android:30-node` |
| android:31 | `registry.semaphoreci.com/android:31` |
| android:31-flutter | `registry.semaphoreci.com/android:31-flutter` |
| android:31-node | `registry.semaphoreci.com/android:31-node` |


## Supported sem-service images  
The `sem-service` is [a utility on Linux-based virtual machines](/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/) for starting, stopping, and getting the status of background services. You can use `sem-service` to pull images from the Semaphore Container Registry. All supported versions are listed below.  
  
### Postgres  
| Image | Link |
|--------|--------|
| postgres:9.4 | `registry.semaphoreci.com/postgres:9.4` |    
| postgres:9.5 | `registry.semaphoreci.com/postgres:9.5` |    
| postgres:9.6 | `registry.semaphoreci.com/postgres:9.6` |    
| postgres:10 | `registry.semaphoreci.com/postgres:10` |    
| postgres:11 | `registry.semaphoreci.com/postgres:11` |    
| postgres:12 | `registry.semaphoreci.com/postgres:12` |    
| postgres:13 | `registry.semaphoreci.com/postgres:13` |  
| postgres:14 | `registry.semaphoreci.com/postgres:14` |  

### PostGis
| Image | Link |
|--------|--------|
| postgis:9.6-2.5 | `registry.semaphoreci.com/postgis:9.6-2.5` |    
| postgis:9.6-3.0 | `registry.semaphoreci.com/postgis:9.6-3.0` |    
| postgis:10-2.5 | `registry.semaphoreci.com/postgis:10-2.5` |    
| postgis:11-2.5 | `registry.semaphoreci.com/postgis:11-2.5` |    
| postgis:11-3.0 | `registry.semaphoreci.com/postgis:11-3.0` |    
| postgis:12-2.5 | `registry.semaphoreci.com/postgis:12-2.5` |    
| postgis:12-3.0 | `registry.semaphoreci.com/postgis:12-3.0` |    
| postgis:13-3.0 | `registry.semaphoreci.com/postgis:13-3.0` |    
| postgis:14-3.1 | `registry.semaphoreci.com/postgis:14-3.1` |    

### ElasticSearch    
| Image | Link |
|--------|--------|
| elasticsearch:1.7 | `registry.semaphoreci.com/elasticsearch:1.7` |    
| elasticsearch:2.4 | `registry.semaphoreci.com/elasticsearch:2.4` |    
| elasticsearch:5.4 | `registry.semaphoreci.com/elasticsearch:5.4` |    
| elasticsearch:5.5 | `registry.semaphoreci.com/elasticsearch:5.5` |    
| elasticsearch:5.6 | `registry.semaphoreci.com/elasticsearch:5.6` |    
| elasticsearch:6.5 | `registry.semaphoreci.com/elasticsearch:6.5` |    
| elasticsearch:6.6 | `registry.semaphoreci.com/elasticsearch:6.6` |    
| elasticsearch:7.1 | `registry.semaphoreci.com/elasticsearch:7.1` |    
| elasticsearch:7.2 | `registry.semaphoreci.com/elasticsearch:7.2` |    
| elasticsearch:7.3 | `registry.semaphoreci.com/elasticsearch:7.3` |    
| elasticsearch:7.4 | `registry.semaphoreci.com/elasticsearch:7.4` |    
| elasticsearch:7.5 | `registry.semaphoreci.com/elasticsearch:7.5` |    
| elasticsearch:7.6 | `registry.semaphoreci.com/elasticsearch:7.6` |    
| elasticsearch:7.7 | `registry.semaphoreci.com/elasticsearch:7.7` |    
| elasticsearch:7.8 | `registry.semaphoreci.com/elasticsearch:7.8` |    
| elasticsearch:7.9 | `registry.semaphoreci.com/elasticsearch:7.9` |   
| elasticsearch:7.10 | `registry.semaphoreci.com/elasticsearch:7.10` |   
| elasticsearch:7.11 | `registry.semaphoreci.com/elasticsearch:7.11` |   
| elasticsearch:7.12 | `registry.semaphoreci.com/elasticsearch:7.12` |   

### MongoDB    
| Image | Link |
|--------|--------|
| mongo:3.2 | `registry.semaphoreci.com/mongo:3.2` |    
| mongo:3.6 | `registry.semaphoreci.com/mongo:3.6` |    
| mongo:4.0 | `registry.semaphoreci.com/mongo:4.0` |    
| mongo:4.1 | `registry.semaphoreci.com/mongo:4.1` |    
| mongo:4.2 | `registry.semaphoreci.com/mongo:4.2` |    
| mongo:4.4 | `registry.semaphoreci.com/mongo:4.4` |    

### Redis    
| Image | Link |
|--------|--------|
| redis:2.8 | `registry.semaphoreci.com/redis:2.8` |    
| redis:3.2 | `registry.semaphoreci.com/redis:3.2` |    
| redis:4.0 | `registry.semaphoreci.com/redis:4.0` |    
| redis:5.0 | `registry.semaphoreci.com/redis:5.0` |    
| redis:6.0 | `registry.semaphoreci.com/redis:6.0` |    

### MySQL    
| Image | Link |
|--------|--------|
| mysql:5.5 | `registry.semaphoreci.com/mysql:5.5` |    
| mysql:5.6 | `registry.semaphoreci.com/mysql:5.6` |    
| mysql:5.7 | `registry.semaphoreci.com/mysql:5.7` |    
| mysql:8.0 | `registry.semaphoreci.com/mysql:8.0` |    

### Memcached    
| Image | Link |
|--------|--------|
| memcached:1.5 | `registry.semaphoreci.com/memcached:1.5` |    
| memcached:1.6 | `registry.semaphoreci.com/memcached:1.6` |    

### RabbitMQ  
| Image | Link |
|--------|--------|
| rabbitmq:3.6 | `registry.semaphoreci.com/rabbitmq:3.6` | 
| rabbitmq:3.8 | `registry.semaphoreci.com/rabbitmq:3.8` |  

### Cassandra DB
| Image | Link |
|--------|--------|
| cassandra:3.11 | `registry.semaphoreci.com/cassandra:3.11` |  

### Rethink DB
| Image | Link |
|--------|--------|
| rethinkdb:2.3 | `registry.semaphoreci.com/rethinkdb:2.3 ` |  
| rethinkdb:2.4 | `registry.semaphoreci.com/rethinkdb:2.4 ` |  

### Unity
| Image | Link |
|--------|--------|
| unityci/editor:2020.3.25f1-android-0 | `registry.semaphoreci.com/unityci/editor:2020.3.25f1-android-0 ` |  
| unityci/editor:ubuntu-2020.3.25f1-webgl-0.15.0 | `registry.semaphoreci.com/unityci/editor:ubuntu-2020.3.25f1-webgl-0.15.0 ` |  
| unityci/editor:ubuntu-2020.3.25f1-ios-0.15.0 | `registry.semaphoreci.com/unityci/editor:ubuntu-2020.3.25f1-ios-0.15.0` |  



