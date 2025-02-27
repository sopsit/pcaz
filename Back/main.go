// Entry point (starts server, calls functions)

package main

import (
	//"database/sql"
	//"log"
	"github.com/sopsit/pcaz/configdb"
    "github.com/sopsit/pcaz/routes"
)


func main() {

	// return db , err
    configdb.Connect_db()
	r := routes.SetupRouter()
	r.Run(":8080") // Start server on port 8080
	
	//routes.SetupRoutes()
	//log.Println("Server running on port 8080...")
	//log.Fatal(http.ListenAndServe(":8080", nil))
}





