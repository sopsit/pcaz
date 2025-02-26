// Entry point (starts server, calls functions)

package main

import (
	"log"
	"net/http"
	"myapp/config"
	"myapp/routes"
)

func main() {

	config.ConnectDB()
	routes.SetupRoutes()

	log.Println("Server running on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}


