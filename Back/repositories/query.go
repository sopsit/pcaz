// Queries (Insert, Select, Update, Delete)

package main

import (
	"database/sql"
	"errors"
	"fmt"
	"myproject/configdb"
	"myproject/structure"
)

func AddClient (newclient structure.Client) error {

	Database := configdb.Get_database()

	query := ` INSERT INTO clients (Phone_number, First_name, Last_name, Wallet_balance, Referral_code)
	           VALUES (? , ? , ? , ? , ?) `
	
	_ , err := Database.Exec(query , newclient.PhoneNumber , newclient.Name , newclient.LastName , newclient.WalletBalance ,
		newclient.ReferralCode)	
		
	if err != nil {
		return err
	}

	return nil

}

func GetClientInfo(Phonenum string) (*structure.Client, error) {

	Database := configdb.Get_database()

	var ClientInfo structure.Client

	query := " SELECT * FROM clients WHERE Phone_number = ? "

	row := Database.QueryRow(query, Phonenum)
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

func Is_VIP(userId int) (*bool, error) {

	Database := configdb.Get_database()

	var clientId int
	var ISVIP bool = false

	query := " SELECT id FROM VIP_Clients WHERE id=? AND Subscription_expiration_time >= NOW() "
	row := Database.QueryRow(query, userId)
	err := row.Scan(&clientId)

	if err != nil {
		if err == sql.ErrNoRows {
			return &ISVIP, nil
		}
		return nil, err
	}

	ISVIP = true

	return &ISVIP, nil

}

func Getaddress(userId int) ([]string, error) {

	Database := configdb.Get_database()

	query := " SELECT Province , Remainder FROM address WHERE id=? "
	row, err1 := Database.Query(query, userId)

	if err1 != nil {

		return nil, err1
	}

	defer row.Close()

	var add []string

	for row.Next() {

		var province, remainder string
		err2 := row.Scan(&province, &remainder)
		if err2 != nil {
			return nil, err2
		}
		temp := "Province:" + province + " Remainder:" + remainder
		add = append(add, temp)

	}

	if len(add) == 0 {
		return nil, errors.New(" No adress found. ")
	}

	return add, nil

}

func GetCountOfReferredClient (userId int) (*int , error) {

	Database := configdb.Get_database()
	var count int

	query := ` SELECT COUNT(*) FROM refers WHERE Referrer= ? `
    
	row := Database.QueryRow(query , userId)
	err1 := row.Scan(&count)

	if err1 != nil {
       if err1 == sql.ErrNoRows {
		   return nil , errors.New(" No referred client found! ")
	   }
	   return nil , err1
	}

	return &count , nil



}

func GetPrivateDiscountCode(userID int) ([]structure.DiscountCode, error) {

	Database := configdb.Get_database()

	query := ` SELECT Dis_Code , Amount , Dis_Limit , Usage_count , Expiration_date , Code_Time
	           FROM Discount_Code JOIN Private_Code ON Dis_Code=Private_DCode
			   WHERE id = ? AND  (Expiration_date >= NOW() AND Expiration_date <= (NOW() + INTERVAL 7 DAY )) `

	row, err1 := Database.Query(query, userID)

	if err1 != nil {
		return nil, err1
	}

	defer row.Close()

	var privateCodeList []structure.DiscountCode

	for row.Next() {

		var discode structure.DiscountCode
		err2 := row.Scan(&discode.Code, &discode.CodeAmount, &discode.Limit, &discode.UseCount,
			&discode.ExpirationDate, &discode.CTime)
		if err2 != nil {
			return nil, err2
		}
		privateCodeList = append(privateCodeList, discode)
	}

	if len(privateCodeList) == 0 {
		return nil, errors.New(" No PrivateDiscountCode found. ")
	}

	return privateCodeList, nil

}

func main() {

	configdb.Connect_db()

	defer configdb.Get_database().Close()

	  res , err := GetClientInfo("09123459587")

	 fmt.Println(res , err)

	// id := res.Cid

	// res1, err1 := Getaddress(1)
	
	// res2 , err2 := Is_VIP(1)
	
	//res3 , err3 := GetPrivateDiscountCode(1)

	// res4 , err4 := GetCountOfReferredClient(1)
	

	
}
