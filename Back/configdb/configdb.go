// Database connection setup

package configdb

import (
    "database/sql"
    "fmt"
    "log"
    _ "github.com/go-sql-driver/mysql"
)
var db *sql.DB

func Connect_db() (*sql.DB, error) {

	dsn := "root:sanativanamazhayash@@tcp(127.0.0.1:3306)/pcaz"
	var err error
	// Open database connection
	db, err = sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal("Error connecting to the database:", err)
		return nil, err
	}
	defer db.Close()

	// Test the connection
	err = db.Ping()
	if err != nil {
		log.Fatal("Database connection failed:", err)
		return nil, err
	}

	fmt.Println("Connected to FreeSQLDatabase.com successfully!")
	return db, err
}

func Get_database() *sql.DB {

	return db
}
