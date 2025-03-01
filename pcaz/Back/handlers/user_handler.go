// HTTP handlers (for API)

package handlers

import (
    //"database/sql"
    "net/http"
    //"github.com/gin-gonic/gin"
    //"myproject/configdb" 
    "myproject/repositories"
    "encoding/json"
	//"net/http"
    "myproject/structure"
)


func LoginHandler(w http.ResponseWriter, r *http.Request) {

	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	var req structure.Client
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	_ , err := repositories.GetClientInfo(req.PhoneNumber)
	if err != nil  {
		http.Error(w, " Phone number not found! ", http.StatusUnauthorized)
		return
	}
	// Successful login
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Login successful"})
}


