package middlewares

// import (
//     "github.com/gin-contrib/cors"
//     "github.com/gin-gonic/gin"	
// 	//"net/http"
//     "time"

// )

// func CORS(next http.Handler) http.Handler {
// 	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
// 		w.Header().Set("Access-Control-Allow-Origin", "*")
// 		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
// 		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

// 		// Handle preflight requests
// 		if r.Method == "OPTIONS" {
// 			w.WriteHeader(http.StatusOK)
// 			return
// 		}

// 		next.ServeHTTP(w, r)
// 	})
// }


// CORS middleware setup

    // func CORS() gin.HandlerFunc {
    //     return cors.New(cors.Config{
    //         AllowOrigins:     []string{"http://localhost:8080/api/login"},
    //         AllowMethods:     []string{"GET", "POST", "OPTIONS"},
    //         AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
    //         AllowCredentials: true,
    //         ExposeHeaders:    []string{"Authorization"},
    //         MaxAge:           12 * time.Hour,
    //     })
    // }


import (
        "github.com/gin-gonic/gin"
        "net/http"
)
    
    func CORSMiddleware() gin.HandlerFunc {
        return func(c *gin.Context) {
            c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
            c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
            c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
    
            if c.Request.Method == "OPTIONS" {
                c.AbortWithStatus(http.StatusNoContent)
                return
            }
    
            c.Next()
        }
    }
    