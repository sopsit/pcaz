// API route definitions

package routes

import (
    "github.com/gin-gonic/gin"
    "myproject/handlers"
   // "net/http"
)

// func SetupRoutes() {

// 	http.HandleFunc("/login", handlers.LoginHandler)

// }
func SetupRoutes(router *gin.Engine) {

    api := router.Group("/api")
    {
        api.POST("api/login", handlers.LoginHandler)
        api.POST("api/profile", handlers.ProfileHandler)
    }
}
