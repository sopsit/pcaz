// HTTP handlers (for API)

package handlers

import (
	//"database/sql"
	"net/http"
	"github.com/gin-gonic/gin"

	//"myproject/configdb"
	//"myproject/repositories"
	//"encoding/json"
	"myproject/services"
	"myproject/structure"
	// "log"
)



func LoginHandler(c *gin.Context) {
    var userInput structure.Client

    if err := c.ShouldBindJSON(&userInput); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
        return
    }

    user, err := services.AuthenticateUser(userInput.PhoneNumber)
	is_VIP, _ := services.Get_status(userInput.Cid)
    if err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"message": "Invalid credentials"})
        return
    }
	var status  string

	if !*is_VIP {
		status = "CIP"
	} else {
		status ="VIP"
	}

    c.JSON(http.StatusOK, gin.H{"message": "Login successful", "user": user, "status" : status})
}

func ProfileHandler(c *gin.Context) {

	var userInput structure.Client

	if err := c.ShouldBindJSON(&userInput); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	user, err1 := services.AuthenticateUser(userInput.PhoneNumber)
	is_VIP, err2 := services.Get_status(userInput.Cid)

	if err1 != nil || err2 !=nil {
		c.JSON(http.StatusUnauthorized, gin.H{"message": "Invalid credentials"})
		return
	}

	var status  string

	if !*is_VIP {
		status = "CIP"
	} else {
		status ="VIP"
	}
	// log.Println(status)

	c.JSON(http.StatusOK, gin.H{"message": "Profile retrieval successful", "user": user, "status" : status})

}





