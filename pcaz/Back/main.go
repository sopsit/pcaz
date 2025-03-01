// Entry point (starts server, calls functions)

package main

import (
	//"database/sql"
	"log"
	"myproject/configdb"
	"net/http"
	"myproject/routes"
	"myproject/middlewares"
	//"github.com/gin-gonic/gin"
    //"github.com/gin-contrib/cors"
)

//var db *sql.DB 

func main() {
// return db , err
    configdb.Connect_db()
	routes.SetupRoutes()
	handler := middlewares.CORS(http.DefaultServeMux)
	log.Println("Server started on :8080")
	log.Fatal(http.ListenAndServe(":8080", handler))
}

