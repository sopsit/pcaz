// Queries (Insert, Select, Update, Delete)

package main

import (
	"database/sql"
	"errors"
	"fmt"
	"myproject/configdb"
	"myproject/structure"
)

func GetClientInfo(Phonenum string) (*structure.Client, error) {

	db, err_1 := configdb.Connect_db()
	if err_1 != nil {
		return nil, errors.New("cant connect to database! ")
	}

	defer db.Close()

	var ClientInfo structure.Client

	query := " SELECT * FROM clients WHERE Phone_number = ? "

	row := db.QueryRow(query, Phonenum)
	err := row.Scan(&ClientInfo.Cid, &ClientInfo.PhoneNumber, &ClientInfo.Name, &ClientInfo.LastName, &ClientInfo.WalletBalance,
		&ClientInfo.SignupTime, &ClientInfo.ReferralCode)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, errors.New(" Phone number not found! ")
		}
		return nil, err
	}

	return &ClientInfo, nil

}

func Getaddress(userId int) ([]string, error) {

	db, err_1 := configdb.Connect_db()
	if err_1 != nil {
		return nil, errors.New("cant connect to database! ")
	}

	defer db.Close()

	query := " SELECT Province , Remainder FROM address WHERE id=? "
	row, err_2 := db.Query(query, userId)

	if err_2 != nil {
		if err_2 == sql.ErrNoRows {
			return nil, errors.New(" No adress found. ")
		}
		return nil, err_2
	}

	var add []string

	for row.Next() {

		var province, remainder string
		err_3 := row.Scan(&province, &remainder)
		if err_3 != nil {
			return nil, err_3
		}
		temp := "Province:" + province + " Remainder:" + remainder
		add = append(add, temp)

	}

	return add, nil

}

func main() {

	// res , err := GetClientInfo("09183455290")

	//fmt.Println(res , err)

	res1, err1 := Getaddress(3)
	fmt.Println(res1, err1)

}
