---  
description: This page contains a list of docker images available on the Semaphore Container Registry.  
---  
  
# Semaphore Container Registry  
Semaphore hosts a set of images that are used by `sem-service` as well as a set of convenience images.
You can use these images inside your Semaphore environment without any restrictions or limits.
  
### Using an unsupported version  
In case that you need to use a Docker image that is not covered in this list, please note that Semaphore allows pulls from any Docker repository.  

You can find more information on our [working with Docker](/ci-cd-environment/working-with-docker/) documentation page. 

!!! info "Semaphore convenience images redirection"
	Due to the Docker Hub [rate limits](/ci-cd-environment/docker-authentication/), if you are using a [Docker-based CI/CD environment](/ci-cd-environment/custom-ci-cd-environment-with-docker/) in combination with convenience images Semaphore will **automatically redirect** any pulls from the `semaphoreci` Docker Hub repository to the [Semaphore Container Registry](/ci-cd-environment/semaphore-registry-images/).
  
## Convenience Docker images  
Semaphore comes with pre-built convenience Docker images hosted on Semaphore Registry.  
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

### Python  
| Image | Link |
|--------|--------|
| python:2.8 | `registry.semaphoreci.com/python:2.8` |  
| python:2.8-node-browsers | `registry.semaphoreci.com/python:2.8-node-browsers` |  
| python:3.0 | `registry.semaphoreci.com/python:3.0` |  
| python:3.0-node-browsers | `registry.semaphoreci.com/python:3.0-node-browsers` |  
| python:3.0 | `registry.semaphoreci.com/python:3.0` |  
| python:3.1-node-browsers | `registry.semaphoreci.com/python:3.1-node-browsers` |  
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

### PHP
| Image | Link |
|--------|--------|
| php:5.6 | `registry.semaphoreci.com/php:5.6` |
| php:7.2 | `registry.semaphoreci.com/php:7.2` |
| php:7.3 | `registry.semaphoreci.com/php:7.3` |
| php:7.4 | `registry.semaphoreci.com/php:7.4` |
| php:5.6-node | `registry.semaphoreci.com/php:5.6-node` |
| php:7.2-node | `registry.semaphoreci.com/php:7.2-node` |
| php:7.3-node | `registry.semaphoreci.com/php:7.3-node` |
| php:7.4-node | `registry.semaphoreci.com/php:7.4-node` |
| php:5.6-browsers | `registry.semaphoreci.com/php:5.6-browsers` |
| php:7.2-browsers | `registry.semaphoreci.com/php:7.2-browsers` |
| php:7.3-browsers | `registry.semaphoreci.com/php:7.3-browsers` |
| php:7.4-browsers | `registry.semaphoreci.com/php:7.4-browsers` |
| php:5.6-node-browsers | `registry.semaphoreci.com/php:5.6-node-browsers` |
| php:7.2-node-browsers | `registry.semaphoreci.com/php:7.2-node-browsers` |
| php:7.3-node-browsers | `registry.semaphoreci.com/php:7.3-node-browsers` |
| php:7.4-node-browsers | `registry.semaphoreci.com/php:7.4-node-browsers` |

### Haskell  
| Image | Link |
|--------|--------|
| haskell:8.4 | `registry.semaphoreci.com/haskell:8.4` |  
| haskell:8.4-node-browsers | `registry.semaphoreci.com/haskell:8.4-node-browsers` |  
| haskell:8.5 | `registry.semaphoreci.com/haskell:8.5` |  
| haskell:8.5-node-browsers | `registry.semaphoreci.com/haskell:8.5-node-browsers` |  
| haskell:8.6 | `registry.semaphoreci.com/haskell:8.6` |  
| haskell:8.6-node-browsers | `registry.semaphoreci.com/haskell:8.6-node-browsers` |  

### Rust  
| Image | Link |
|--------|--------|
| rust:1.45 | `registry.semaphoreci.com/rust:1.45` |  
| rust:1.45-node-browsers | `registry.semaphoreci.com/rust:1.45-node-browsers` |  
| rust:1.46 | `registry.semaphoreci.com/rust:1.46` |  
| rust:1.46-node-browsers | `registry.semaphoreci.com/rust:1.46-node-browsers` |  

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
| golang:1.19 | `registry.semaphoreci.com/golang:1.19` |  
| golang:1.19-node-browsers | `registry.semaphoreci.com/golang:1.19-node-browsers` |  

### Clojure  
| Image | Link |
|--------|--------|
| clojure:13 | `registry.semaphoreci.com/clojure:13` |  
| clojure:13-node-browsers | `registry.semaphoreci.com/clojure:13-node-browsers` |  

### Elixir  
| Image | Link |
|--------|--------|
| elixir:1.5 | `registry.semaphoreci.com/elixir:1.5` |  
| elixir:1.5-node-browsers | `registry.semaphoreci.com/elixir:1.5-node-browsers` |  
| elixir:1.6 | `registry.semaphoreci.com/elixir:1.6` |  
| elixir:1.6-node-browsers | `registry.semaphoreci.com/elixir:1.6-node-browsers` |  
| elixir:1.7 | `registry.semaphoreci.com/elixir:1.7` |  
| elixir:1.7-node-browsers | `registry.semaphoreci.com/elixir:1.7-node-browsers` |  
| elixir:1.8 | `registry.semaphoreci.com/elixir:1.8` |  
| elixir:1.8-node-browsers | `registry.semaphoreci.com/elixir:1.8-node-browsers` |  
| elixir:1.9 | `registry.semaphoreci.com/elixir:1.9` |  
| elixir:1.9-node-browsers | `registry.semaphoreci.com/elixir:1.9-node-browsers` |  

### Node  
| Image | Link |
|--------|--------|
| node:10 | `registry.semaphoreci.com/node:10` |  
| node:10-browsers | `registry.semaphoreci.com/node:10-browsers` |  
| node:11 | `registry.semaphoreci.com/node:11` |  
| node:11-browsers | `registry.semaphoreci.com/node:11-browsers` |  
| node:12 | `registry.semaphoreci.com/node:12` |  
| node:12-browsers | `registry.semaphoreci.com/node:12-browsers` |  
| node:13 | `registry.semaphoreci.com/node:13` |  
| node:13-browsers | `registry.semaphoreci.com/node:13-browsers` |  
| node:14 | `registry.semaphoreci.com/node:14` |  
| node:14-browsers | `registry.semaphoreci.com/node:14-browsers` |  

### Ubuntu  
| Image | Link |
|--------|--------|
| ubuntu:14.04 | `registry.semaphoreci.com/ubuntu:14.04` |  
| ubuntu:18.04 | `registry.semaphoreci.com/ubuntu:18.04` |  
| ubuntu:20.04 | `registry.semaphoreci.com/ubuntu:20.04` |  

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

## Supported sem-service images  
The `sem-service` is [a utility on Linux based virtual machines](/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/) for starting, stopping and getting the status of background services.  
You can use `sem-service` to pull images from the Semaphore Container Registry. All versions that are supported are listed below.  
  
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

### ElasticSearch    
| Image | Link |
|--------|--------|
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

### MongoDB    
| Image | Link |
|--------|--------|
| mongo:3.2 | `registry.semaphoreci.com/mongo:3.2` |    
| mongo:3.6 | `registry.semaphoreci.com/mongo:3.6` |    
| mongo:4.0 | `registry.semaphoreci.com/mongo:4.0` |    
| mongo:4.1 | `registry.semaphoreci.com/mongo:4.1` |    
| mongo:4.2 | `registry.semaphoreci.com/mongo:4.2` |    

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
| rabbitmq:3.8.2 | `registry.semaphoreci.com/rabbitmq:3.8.2` |  
| rabbitmq:3.6 | `registry.semaphoreci.com/rabbitmq:3.6` |  

### Cassandra DB
| Image | Link |
|--------|--------|
| cassandra:3 | `registry.semaphoreci.com/cassandra:3` |  

### Rethink DB
| Image | Link |
|--------|--------|
| rethinkdb:2 | `registry.semaphoreci.com/rethinkdb:2 ` |  

