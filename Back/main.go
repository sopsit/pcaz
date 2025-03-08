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
        api.POST("/getSazgarProduct", handlers.GetCompatibleProducts)
    }

    router.Run(":8080")
}


