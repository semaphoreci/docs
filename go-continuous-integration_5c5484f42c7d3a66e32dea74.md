
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

Now, it is time to explain what each `block` of the `.semaphore/semaphore.yml`
file does.

The first `block` is defined as follows:


The second `block` is as follows:


The last `block` is defined with the following commands:


### See also

* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
