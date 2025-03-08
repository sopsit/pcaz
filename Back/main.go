// Entry point (starts server, calls functions)

package main

import (
	//"database/sql"
	//"log"
	"myproject/configdb"
	//"net/http"
	//"myproject/routes"
	"myproject/middlewares"
	"github.com/gin-gonic/gin"
   // "github.com/gin-contrib/cors"
    "myproject/handlers"
)

//var db *sql.DB 

// func main() {
// // return db , err
//     configdb.Connect_db()
// 	// routes.SetupRoutes()
// 	// handler := middlewares.CORS(http.DefaultServeMux)
// 	// log.Println("Server started on :8080")
// 	// log.Fatal(http.ListenAndServe(":8080", handler))

// 	router := gin.Default()

//     // Apply middlewares (CORS, authentication, etc.)
//     router.Use(middlewares.CORS())

//     // Set up routes
//     routes.SetupRoutes(router)

//     // Start the server
//     router.Run(":8080")
// }


func main() {
    router := gin.Default()
    
    // Apply CORS Middleware
    router.Use(middlewares.CORSMiddleware())

    // Initialize database
    configdb.Connect_db()

    // Set up API routes
    api := router.Group("/api")
    {
        api.POST("/login", handlers.LoginHandler)
        api.POST("/SazgarYab", handlers.Product)
    }

    router.Run(":8080")
}


