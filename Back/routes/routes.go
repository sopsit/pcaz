// API route definitions

package routes

import (
    "github.com/gin-gonic/gin"
    "myproject/handlers"
)

func SetupRouter() *gin.Engine {
    r := gin.Default()

    // Define API routes
    r.GET("/users", handlers.GetUsers)
    r.POST("/users", handlers.CreateUser)

    return r
}
