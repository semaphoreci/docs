---  
description: This page contains the list of docker images available on Semaphore registry.  
---  
  
# Semaphore Registry  
Semaphore hosts a set of images that are used by `sem-service` as well as a set of convinience images that you can easily pull in your Semaphore jobs.  
  
### Using unsuported version  
Instruction on how you should proceed if you need unsuported version  
  
## Supported sem-service images  
The `sem-service` is [a utility on Linux based virtual machines](/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/) for starting, stopping and getting the status of background services.  
The `sem-service` pulls images from Semaphore registry and supports all versions that are listed bellow.  
  
### Postgres    
[postgres:9.4](https://registry.semaphoreci.com/postgres:9.4)    
[postgres:9.5](https://registry.semaphoreci.com/postgres:9.5)    
[postgres:9.6](https://registry.semaphoreci.com/postgres:9.6)    
[postgres:10](https://registry.semaphoreci.com/postgres:10)    
[postgres:11](https://registry.semaphoreci.com/postgres:11)    
[postgres:12](https://registry.semaphoreci.com/postgres:12)    
[postgres:13](https://registry.semaphoreci.com/postgres:13)    
### ElasticSearch    
[elasticsearch:5.4](https://registry.semaphoreci.com/elasticsearch:5.4)    
[elasticsearch:5.5](https://registry.semaphoreci.com/elasticsearch:5.5)    
[elasticsearch:5.6](https://registry.semaphoreci.com/elasticsearch:5.6)    
[elasticsearch:6.5](https://registry.semaphoreci.com/elasticsearch:6.5)    
[elasticsearch:6.6](https://registry.semaphoreci.com/elasticsearch:6.6)    
[elasticsearch:7.1](https://registry.semaphoreci.com/elasticsearch:7.1)    
[elasticsearch:7.2](https://registry.semaphoreci.com/elasticsearch:7.2)    
[elasticsearch:7.3](https://registry.semaphoreci.com/elasticsearch:7.3)    
[elasticsearch:7.4](https://registry.semaphoreci.com/elasticsearch:7.4)    
[elasticsearch:7.5](https://registry.semaphoreci.com/elasticsearch:7.5)    
[elasticsearch:7.6](https://registry.semaphoreci.com/elasticsearch:7.6)    
[elasticsearch:7.7](https://registry.semaphoreci.com/elasticsearch:7.7)    
[elasticsearch:7.8](https://registry.semaphoreci.com/elasticsearch:7.8)    
[elasticsearch:7.9](https://registry.semaphoreci.com/elasticsearch:7.9)    
### MongoDB    
[mongo:3.2](https://registry.semaphoreci.com/mongo:3.2)    
[mongo:3.6](https://registry.semaphoreci.com/mongo:3.6)    
[mongo:4.0](https://registry.semaphoreci.com/mongo:4.0)    
[mongo:4.1](https://registry.semaphoreci.com/mongo:4.1)    
[mongo:4.2](https://registry.semaphoreci.com/mongo:4.2)    
### Redis    
[redis:2.8](https://registry.semaphoreci.com/redis:2.8)    
[redis:3.2](https://registry.semaphoreci.com/redis:3.2)    
[redis:4.0](https://registry.semaphoreci.com/redis:4.0)    
[redis:5.0](https://registry.semaphoreci.com/redis:5.0)    
[redis:6.0](https://registry.semaphoreci.com/redis:6.0)    
### MySQL    
[mysql:5.5](https://registry.semaphoreci.com/mysql:5.5)    
[mysql:5.6](https://registry.semaphoreci.com/mysql:5.6)    
[mysql:5.7](https://registry.semaphoreci.com/mysql:5.7)    
[mysql:8.0](https://registry.semaphoreci.com/mysql:8.0)    
### Memcached    
[memcached:1.5](https://registry.semaphoreci.com/memcached:1.5)    
[memcached:1.6](https://registry.semaphoreci.com/memcached:1.6)    
### RabbitMQ  
[rabbitmq:3.8.2](https://registry.semaphoreci.com/rabbitmq:3.8.2)
[rabbitmq:3.6](https://registry.semaphoreci.com/rabbitmq:3.6)

## Convenience Docker images  
For convenience, Semaphore comes with a pre-built convenience Docker images hosted on Semaphore Registry.  
The source code of the Semaphore Docker images is [hosted on Github](https://github.com/semaphoreci/docker-images).  
  
### Ruby  
[ruby:2.0](https://registry.semaphoreci.com/ruby:2.0)  
[ruby:2.0-node-browsers](https://registry.semaphoreci.com/ruby:2.0-node-browsers)  
[ruby:2.1](https://registry.semaphoreci.com/ruby:2.1)  
[ruby:2.1-node-browsers](https://registry.semaphoreci.com/ruby:2.1-node-browsers)  
[ruby:2.2](https://registry.semaphoreci.com/ruby:2.2)  
[ruby:2.2-node-browsers](https://registry.semaphoreci.com/ruby:2.2-node-browsers)  
[ruby:2.3](https://registry.semaphoreci.com/ruby:2.3)  
[ruby:2.3-node-browsers](https://registry.semaphoreci.com/ruby:2.3-node-browsers)  
[ruby:2.4](https://registry.semaphoreci.com/ruby:2.4)  
[ruby:2.4-node-browsers](https://registry.semaphoreci.com/ruby:2.4-node-browsers)  
[ruby:2.5](https://registry.semaphoreci.com/ruby:2.5)  
[ruby:2.5-node-browsers](https://registry.semaphoreci.com/ruby:2.5-node-browsers)  
[ruby:2.5](https://registry.semaphoreci.com/ruby:2.5)  
[ruby:2.5-node-browsers](https://registry.semaphoreci.com/ruby:2.5-node-browsers)  
[ruby:2.6](https://registry.semaphoreci.com/ruby:2.6)  
[ruby:2.6-node-browsers](https://registry.semaphoreci.com/ruby:2.6-node-browsers)  
[ruby:2.7](https://registry.semaphoreci.com/ruby:2.7)  
[ruby:2.7-node-browsers](https://registry.semaphoreci.com/ruby:2.7-node-browsers)  
### Python  
[python:2.8](https://registry.semaphoreci.com/python:2.8)  
[python:2.8-node-browsers](https://registry.semaphoreci.com/python:2.8-node-browsers)  
[python:3.0](https://registry.semaphoreci.com/python:3.0)  
[python:3.0-node-browsers](https://registry.semaphoreci.com/python:3.0-node-browsers)  
[python:3.0](https://registry.semaphoreci.com/python:3.0)  
[python:3.1-node-browsers](https://registry.semaphoreci.com/python:3.1-node-browsers)  
[python:3.2](https://registry.semaphoreci.com/python:3.2)  
[python:3.2-node-browsers](https://registry.semaphoreci.com/python:3.2-node-browsers)  
[python:3.3](https://registry.semaphoreci.com/python:3.3)  
[python:3.3-node-browsers](https://registry.semaphoreci.com/python:3.3-node-browsers)  
[python:3.4](https://registry.semaphoreci.com/python:3.4)  
[python:3.4-node-browsers](https://registry.semaphoreci.com/python:3.4-node-browsers)  
[python:3.5](https://registry.semaphoreci.com/python:3.5)  
[python:3.5-node-browsers](https://registry.semaphoreci.com/python:3.5-node-browsers)  
[python:3.6](https://registry.semaphoreci.com/python:3.6)  
[python:3.6-node-browsers](https://registry.semaphoreci.com/python:3.6-node-browsers)  
[python:3.7](https://registry.semaphoreci.com/python:3.7)  
[python:3.7-node-browsers](https://registry.semaphoreci.com/python:3.7-node-browsers)  
[python:3.8](https://registry.semaphoreci.com/python:3.8)  
[python:3.8-node-browsers](https://registry.semaphoreci.com/python:3.8-node-browsers)  
[python:3.9](https://registry.semaphoreci.com/python:3.9)  
[python:3.9-node-browsers](https://registry.semaphoreci.com/python:3.9-node-browsers)  
### Haskell  
[haskell:8.4](https://registry.semaphoreci.com/haskell:8.4)  
[haskell:8.4-node-browsers](https://registry.semaphoreci.com/haskell:8.4-node-browsers)  
[haskell:8.5](https://registry.semaphoreci.com/haskell:8.5)  
[haskell:8.5-node-browsers](https://registry.semaphoreci.com/haskell:8.5-node-browsers)  
[haskell:8.6](https://registry.semaphoreci.com/haskell:8.6)  
[haskell:8.6-node-browsers](https://registry.semaphoreci.com/haskell:8.6-node-browsers)  
### Rust  
[rust:1.45](https://registry.semaphoreci.com/rust:1.45)  
[rust:1.45-node-browsers](https://registry.semaphoreci.com/rust:1.45-node-browsers)  
[rust:1.46](https://registry.semaphoreci.com/rust:1.46)  
[rust:1.46-node-browsers](https://registry.semaphoreci.com/rust:1.46-node-browsers)  
### Golang  
[golang:1.14](https://registry.semaphoreci.com/golang:1.14)  
[golang:1.14-node-browsers](https://registry.semaphoreci.com/golang:1.14-node-browsers)  
[golang:1.15](https://registry.semaphoreci.com/golang:1.15)  
[golang:1.15-node-browsers](https://registry.semaphoreci.com/golang:1.15-node-browsers)  
[golang:1.16](https://registry.semaphoreci.com/golang:1.16)  
[golang:1.16-node-browsers](https://registry.semaphoreci.com/golang:1.16-node-browsers)  
[golang:1.17](https://registry.semaphoreci.com/golang:1.17)  
[golang:1.17-node-browsers](https://registry.semaphoreci.com/golang:1.17-node-browsers)  
[golang:1.18](https://registry.semaphoreci.com/golang:1.18)  
[golang:1.18-node-browsers](https://registry.semaphoreci.com/golang:1.18-node-browsers)  
[golang:1.19](https://registry.semaphoreci.com/golang:1.19)  
[golang:1.19-node-browsers](https://registry.semaphoreci.com/golang:1.19-node-browsers)  
### Clojure  
[clojure:13](https://registry.semaphoreci.com/clojure:13)  
[clojure:13-node-browsers](https://registry.semaphoreci.com/clojure:13-node-browsers)  
### Elixir  
[elixir:1.5](https://registry.semaphoreci.com/elixir:1.5)  
[elixir:1.5-node-browsers](https://registry.semaphoreci.com/elixir:1.5-node-browsers)  
[elixir:1.6](https://registry.semaphoreci.com/elixir:1.6)  
[elixir:1.6-node-browsers](https://registry.semaphoreci.com/elixir:1.6-node-browsers)  
[elixir:1.7](https://registry.semaphoreci.com/elixir:1.7)  
[elixir:1.7-node-browsers](https://registry.semaphoreci.com/elixir:1.7-node-browsers)  
[elixir:1.8](https://registry.semaphoreci.com/elixir:1.8)  
[elixir:1.8-node-browsers](https://registry.semaphoreci.com/elixir:1.8-node-browsers)  
[elixir:1.9](https://registry.semaphoreci.com/elixir:1.9)  
[elixir:1.9-node-browsers](https://registry.semaphoreci.com/elixir:1.9-node-browsers)  
### Node  
[node:10](https://registry.semaphoreci.com/node:10)  
[node:10-browsers](https://registry.semaphoreci.com/node:10-browsers)  
[node:11](https://registry.semaphoreci.com/node:11)  
[node:11-browsers](https://registry.semaphoreci.com/node:11-browsers)  
[node:12](https://registry.semaphoreci.com/node:12)  
[node:12-browsers](https://registry.semaphoreci.com/node:12-browsers)  
[node:13](https://registry.semaphoreci.com/node:13)  
[node:13-browsers](https://registry.semaphoreci.com/node:13-browsers)  
[node:14](https://registry.semaphoreci.com/node:14)  
[node:14-browsers](https://registry.semaphoreci.com/node:14-browsers)  
### Ubuntu  
[ubuntu:14.04](https://registry.semaphoreci.com/ubuntu:14.04)  
[ubuntu:18.04](https://registry.semaphoreci.com/ubuntu:18.04)  
[ubuntu:20.04](https://registry.semaphoreci.com/ubuntu:20.04)  
### Android  
MISSING  
  
