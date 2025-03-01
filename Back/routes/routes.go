// API route definitions

package routes

import (
    //"github.com/gin-gonic/gin"
    "myproject/handlers"
    "net/http"
)

func SetupRoutes() {

	http.HandleFunc("/login", handlers.LoginHandler)

}

