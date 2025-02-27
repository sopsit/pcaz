// HTTP handlers (for API)

package user_handler

import (
    "database/sql"
    "net/http"
    "github.com/gin-gonic/gin"
    "github.com/sopsit/myproject/user_handler"
)

// GetUsers handles GET /users request
func GetUsers(c *gin.Context) {
    rows, err := configdb.DB.Query("SELECT id, name, email FROM users")
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    defer rows.Close()

    var users []map[string]interface{}
    for rows.Next() {
        var id int
        var name, email string
        rows.Scan(&id, &name, &email)
        users = append(users, map[string]interface{}{"id": id, "name": name, "email": email})
    }

    c.JSON(http.StatusOK, users)
}
// CreateUser handles POST /users request
func CreateUser(c *gin.Context) {
    var user struct {
        Name  string `json:"name"`
        Email string `json:"email"`
    }

    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
        return
    }

    _, err := configdb.DB.Exec("INSERT INTO users (name, email) VALUES (?, ?)", user.Name, user.Email)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusCreated, gin.H{"message": "User created successfully"})
}
