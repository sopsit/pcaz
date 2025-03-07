// HTTP handlers (for API)

package handlers

import (
	//"database/sql"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	//"myproject/configdb"
	//"myproject/repositories"
	//"encoding/json"
	"myproject/services"
	"myproject/structure"
	// "log"
	// "fmt"
)



func LoginHandler(c *gin.Context) {
    var userInput structure.Client
    if err := c.ShouldBindJSON(&userInput); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
        return
    }

    user, uerr := services.AuthenticateUser(userInput.PhoneNumber)
	if  uerr != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"message": "Invalid credentials"})
        return
	}
	is_VIP, err1 := services.Get_status(user.Cid)
	count, err2 := services.Get_GetCountOfReferredClient(user.Cid)
	remaining, _ := services.Get_GetTimeRemaningofSubscribe(user.Cid)
	fiftyP, _ :=services.Get_Get15percent((user.Cid))
	addresses, _ := services.Get_address(user.Cid) 
	diff_count, _ := services.Get_CountofDiscountCodeFromReferralSystem(user.Cid)
	cart, _ :=services.Get_CartStatus(user.Cid)
	cartInfo, _ :=services.Get_CartInformation(user.Cid)
	disCode, _ := services.Get_PrivateDiscountCode(user.Cid)
	// fmt.Println("handler discode:", disCode)
    if uerr != nil || err1 != nil ||err2 != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"message": "Invalid credentials"})
        return
    }
	var status  string

	if !(*is_VIP) {
		status = "CIP"
	} else {
		status ="VIP"
	}
	count_ref := strconv.Itoa(*count) 
	fiftyPer :=strconv.Itoa(int(fiftyP))
	dif_count := strconv.Itoa(diff_count)
    c.JSON(http.StatusOK, gin.H{"message": "Login successful", "user": user, "status" : status, "count_ref" : count_ref, "remaining" : remaining, "fiftyPer" : fiftyPer, "addresses" : addresses, "dif_count" : dif_count, "cart" :cart, "cartInfo" :cartInfo, "disCode" : disCode})
}

func ProfileHandler(c *gin.Context) {

	var userInput structure.Client

	if err := c.ShouldBindJSON(&userInput); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	user, err1 := services.AuthenticateUser(userInput.PhoneNumber)
	is_VIP, err2 := services.Get_status(user.Cid)

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





