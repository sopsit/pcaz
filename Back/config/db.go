// Database connection setup

package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	
		dsn := "root:sanativanamazhayash@@tcp(127.0.0.1:3306)/pcaz"
	// Open database connection
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal("Error connecting to the database:", err)
	}
	defer db.Close()

	// Test the connection
	err = db.Ping()
	if err != nil {
		log.Fatal("Database connection failed:", err)
	}

	fmt.Println("Connected to FreeSQLDatabase.com successfully!")
}