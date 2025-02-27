// Queries (Insert, Select, Update, Delete)

package main

import (
	"database/sql"
	"fmt"
	"myproject/configdb"
)

var db *sql.DB 
var err error

func main(){
	
	db , err = configdb.Connect_db()
	fmt.Println(db , err)

}