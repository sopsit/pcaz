// Entry point (starts server, calls functions)

package main

import (
	//"database/sql"
	"log"
	"myproject/configdb"
	"net/http"
	//"myproject/routes"  not use yet
)

//var db *sql.DB 

func main() {
// return db , err
    configdb.Connect_db()
//	routes.SetupRoutes()

	log.Println("Server running on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}


