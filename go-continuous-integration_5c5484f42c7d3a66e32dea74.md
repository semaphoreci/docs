
* [Overview](#overview)
* [The sample project](#the-sample-project)
* [Explaining the sample project](#explaining-the-sample-project)
* [See also](#see-also)

## Overview

Semaphore 2.0 has support for building Go projects using the supported Go
versions that are listed in the
[VM reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image#go).
The way to select the desired Go version is by using the
[`sem-version`](https://docs.semaphoreci.com/article/54-toolbox-reference#sem-version)
utility.

You can find all required files in a GitHub
[repository](https://github.com/renderedtext/semaphore-demo-go).

## The sample project

The contents of the `.semaphore/semaphore.yml` file are as follows:

	$ cat .semaphore/semaphore.yml
	version: v1.0
	name: Go project
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Build project
	    task:
	      jobs:
	      - name: Get Go packages
	        commands:
	          - checkout
	          - sem-version go 1.12
	          - go get github.com/lib/pq
	          - go build webServer.go
	          - mkdir bin
	          - mv webServer bin
	          - cache store $(checksum webServer.go) bin
    
	  - name: Check code style
	    task:
	      jobs:
	      - name: gofmt
	        commands:
	          - checkout
	          - sem-version go 1.12
	          - yes | sudo apt install gccgo-go
	          - gofmt webServer.go | diff --ignore-tab-expansion webServer.go -
    
	  - name: Smoke tests
	    task:
	      jobs:
	      - name: go test
	        commands:
	          - checkout
	          - sem-version go 1.12
	          - sem-service start postgres
	          - psql -p 5432 -h localhost -U postgres -c "CREATE DATABASE s2"
	          - go get github.com/lib/pq
	          - go test ./... -v
    
	      - name: Test Web Server
	        commands:
	          - checkout
	          - sem-version go 1.12
	          - cache restore $(checksum webServer.go)
	          - ./bin/webServer 8001 &
	          - curl --silent localhost:8001/time | grep "The current time is"

The contents of `webServer.go`, which is a Go implementation of a web server
are as follows:

    package main
    
    import (
    	"database/sql"
    	"fmt"
    	_ "github.com/lib/pq"
    	"net/http"
    	"os"
    	"time"
    )
    
    func myHandler(w http.ResponseWriter, r *http.Request) {
    	fmt.Fprintf(w, "Serving: %s\n", r.URL.Path)
    	fmt.Printf("Served: %s\n", r.Host)
    }
    
    func timeHandler(w http.ResponseWriter, r *http.Request) {
    	t := time.Now().Format(time.RFC1123)
    	Body := "The current time is:"
    	fmt.Fprintf(w, "<h1 align=\"center\">%s</h1>", Body)
    	fmt.Fprintf(w, "<h2 align=\"center\">%s</h2>\n", t)
    	fmt.Fprintf(w, "Serving: %s\n", r.URL.Path)
    	fmt.Printf("Served time for: %s\n", r.Host)
    }
    
    func getData(w http.ResponseWriter, r *http.Request) {
    	fmt.Printf("Serving: %s\n", r.URL.Path)
    	fmt.Printf("Served: %s\n", r.Host)
    
    	connStr := "user=postgres dbname=s2 sslmode=disable"
    	db, err := sql.Open("postgres", connStr)
    	if err != nil {
    		fmt.Fprintf(w, "<h1 align=\"center\">%s</h1>", err)
    		return
    	}
    
    	rows, err := db.Query("SELECT * FROM users")
    	if err != nil {
    		fmt.Fprintf(w, "<h3 align=\"center\">%s</h3>\n", err)
    		return
    	}
    	defer rows.Close()
    
    	for rows.Next() {
    		var id int
    		var firstName string
    		var lastName string
    		err = rows.Scan(&id, &firstName, &lastName)
    		if err != nil {
    			fmt.Fprintf(w, "<h1 align=\"center\">%s</h1>\n", err)
    			return
    		}
    		fmt.Fprintf(w, "<h3 align=\"center\">%d, %s, %s</h3>\n", id, firstName, lastName)
    	}
    
    	err = rows.Err()
    	if err != nil {
    		fmt.Fprintf(w, "<h1 align=\"center\">%s</h1>", err)
    		return
    	}
    }
    
    func main() {
    	PORT := ":8001"
    	arguments := os.Args
    	if len(arguments) != 1 {
    		PORT = ":" + arguments[1]
    	}
    	fmt.Println("Using port number: ", PORT)
    	http.HandleFunc("/time", timeHandler)
    	http.HandleFunc("/getdata", getData)
    	http.HandleFunc("/", myHandler)
    
    	err := http.ListenAndServe(PORT, nil)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    }

The contents of `webServer_test.go`, which is the Go test package used in the
Go project are as follows:

    package main
    
    import (
    	"database/sql"
    	"fmt"
    	_ "github.com/lib/pq"
    	"net/http"
    	"net/http/httptest"
    	"testing"
    )
    
    func create_table() {
    	connStr := "user=postgres dbname=s2 sslmode=disable"
    	db, err := sql.Open("postgres", connStr)
    	if err != nil {
    		fmt.Println(err)
    	}
    
    	const query = `
    		CREATE TABLE IF NOT EXISTS users (
    		  id SERIAL PRIMARY KEY,
    		  first_name TEXT,
    		  last_name TEXT
    	)`
    
    	_, err = db.Exec(query)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    	db.Close()
    }
    
    func drop_table() {
    	connStr := "user=postgres dbname=s2 sslmode=disable"
    	db, err := sql.Open("postgres", connStr)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    
    	_, err = db.Exec("DROP TABLE IF EXISTS users")
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    	db.Close()
    }
    
    func insert_record(query string) {
    	connStr := "user=postgres dbname=s2 sslmode=disable"
    	db, err := sql.Open("postgres", connStr)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    	_, err = db.Exec(query)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    	db.Close()
    }
    
    func Test_count(t *testing.T) {
    	var count int
    	create_table()
    
    	insert_record("INSERT INTO users (first_name, last_name) VALUES ('John', 'Doe')")
    	insert_record("INSERT INTO users (first_name, last_name) VALUES ('Mihalis', 'Tsoukalos')")
    	insert_record("INSERT INTO users (first_name, last_name) VALUES ('Marko', 'Anastasov')")
    
    	connStr := "user=postgres dbname=s2 sslmode=disable"
    	db, err := sql.Open("postgres", connStr)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    
    	row := db.QueryRow("SELECT COUNT(*) FROM users")
    	err = row.Scan(&count)
    	db.Close()
    
    	if count != 3 {
    		t.Errorf("Select query returned %d", count)
    	}
    	drop_table()
    }
    
    func Test_queryDB(t *testing.T) {
    	create_table()
    
    	connStr := "user=postgres dbname=s2 sslmode=disable"
    	db, err := sql.Open("postgres", connStr)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    
    	query := "INSERT INTO users (first_name, last_name) VALUES ('Random Text', '123456')"
    	insert_record(query)
    
    	rows, err := db.Query(`SELECT * FROM users WHERE last_name=$1`, `123456`)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    	var col1 int
    	var col2 string
    	var col3 string
    	for rows.Next() {
    		rows.Scan(&col1, &col2, &col3)
    	}
    	if col2 != "Random Text" {
    		t.Errorf("first_name returned %s", col2)
    	}
    
    	if col3 != "123456" {
    		t.Errorf("last_name returned %s", col3)
    	}
    
    	db.Close()
    	drop_table()
    }
    
    func Test_record(t *testing.T) {
    	create_table()
    	insert_record("INSERT INTO users (first_name, last_name) VALUES ('John', 'Doe')")
    
    	req, err := http.NewRequest("GET", "/getdata", nil)
    	if err != nil {
    		fmt.Println(err)
    		return
    	}
    	rr := httptest.NewRecorder()
    	handler := http.HandlerFunc(getData)
    	handler.ServeHTTP(rr, req)
    
    	status := rr.Code
    	if status != http.StatusOK {
    		t.Errorf("Handler returned %v", status)
    	}
    
    	if rr.Body.String() != "<h3 align=\"center\">1, John, Doe</h3>\n" {
    		t.Errorf("Wrong server response!")
    	}
    	drop_table()
    }

## Explaining the sample project

Each `.semaphore/semaphore.yml` file begins with a preamble that defines the
environment you are going to work with. In this case the preamble is as
follows:

    version: v1.0
    name: Go project
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804

In this preamble we are defining the version of the YAML grammar, the name of
the pipeline and the agent that is going to be used. In this case the agent is
going to be running Linux (`ubuntu1804`) on a `e1-standard-2` machine.

Now, it is time to explain what each `block` of the `.semaphore/semaphore.yml`
file does.

The first `block` is defined as follows:

    - name: Build project
      task:
        jobs:
        - name: Get Go packages
          commands:
            - checkout
            - sem-version go 1.12
            - go get github.com/lib/pq
            - go build webServer.go
            - mkdir bin
            - mv webServer bin
            - cache store $(checksum webServer.go) bin

The `sem-version` utility allows us to select and use Go version 1.12 instead
of the default Go version found in the Semaphore VM. The `checkout` utility is
used for checking out the source code that can be found at the GitHub
repository. The `cache store` command is used for keeping the generated
executable binary file in the Semaphore Cache servers and not having to build
it again.

The second `block` is as follows:

    - name: Check code style
      task:
        jobs:
        - name: gofmt
          commands:
            - checkout
            - sem-version go 1.12
            - yes | sudo apt install gccgo-go
            - gofmt webServer.go | diff --ignore-tab-expansion webServer.go -

The `gofmt`, which is not installed by default, makes sure that the Go code
follows the Go code standards. The `yes | sudo apt install gccgo-go` command is
used for its installation.

The last `block` that has two jobs is defined with the following commands:

    - name: Smoke tests
      task:
        jobs:
        - name: go test
          commands:
            - checkout
            - sem-version go 1.12
            - sem-service start postgres
            - psql -p 5432 -h localhost -U postgres -c "CREATE DATABASE s2"
            - go get github.com/lib/pq
            - go test ./... -v
    
        - name: Test Web Server
          commands:
            - checkout
            - sem-version go 1.12
            - cache restore $(checksum webServer.go)
            - ./bin/webServer 8001 &
            - curl --silent localhost:8001/time | grep "The current time is"

The first job runs that automated tests whereas the second job makes sure that
the developed web server accepts incoming requests. The `sem-service` utility
is used for starting the desired version of the Postgres database server.
The `curl` utility, which is installed by default, is used as an HTTP client
for connecting to the desired URL of the web server.

### See also

* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Ubuntu 18.04 image](https://docs.semaphoreci.com/article/32-ubuntu-1804-image)
