// Entry point (starts server, calls functions)

package main

import (
	//"database/sql"
	"log"
	"myproject/configdb"
	//"net/http"
	"myproject/routes"  //not use yet
	//"github.com/gin-gonic/gin"
    //"github.com/gin-contrib/cors"
)

//var db *sql.DB 

func main() {
// return db , err
    configdb.Connect_db()
//	routes.SetupRoutes()

	r := routes.SetupRouter()
	r.Run(":8080") 
	log.Println("Server running on port 8080...")
}

