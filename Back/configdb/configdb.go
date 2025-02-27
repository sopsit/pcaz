// Database connection setup

package configdb

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

var DB *sql.DB

func Connect_db() (*sql.DB, error) {

	dsn := "root:sanativanamazhayash@@tcp(127.0.0.1:3306)/pcaz"
	var err error
	// Open database connection
	DB, err = sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal("Error connecting to the database:", err)
		return nil, err
	}
	defer DB.Close()

	// Test the connection
	err = DB.Ping()
	if err != nil {
		log.Fatal("Database connection failed:", err)
		return nil, err
	}

	fmt.Println("Connected to db successfully!")
	return DB, err
}

func Get_database() *sql.DB {

	return DB
}
