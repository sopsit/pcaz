// Queries (Insert, Select, Update, Delete)

package repositories


import (
	"database/sql"
	"errors"
	"myproject/configdb"
	"myproject/structure"
	"fmt"
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

func GetCartStatus(userID int) ([]structure.CartStatus , error) {

	Database := configdb.Get_database()

	query := ` SELECT Cart_Number , Cart_Status FROM Shopping_Cart WHERE id = ? ORDER BY Cart_Number `

	row , err1 := Database.Query(query, userID)

	if err1 != nil {
		return nil , err1
	}

	defer row.Close()

	var carts []structure.CartStatus

	for row.Next() {

		var cs structure.CartStatus
		err2 := row.Scan(&cs.Cartnum , &cs.Carts)
		if err2 != nil {
			return nil, err2
		}

		carts = append(carts, cs)
	}

	if (len(carts) == 0 ) {
        return nil , errors.New(" NO Carts found! ")
	}

      return carts , nil
}

func GetCartInformation (userID int) ([]structure.History , error) {
       
	Database := configdb.Get_database()

	query1 := `SELECT L.id , L.Cart_Number , L.Locked_Cart_Number 
             FROM  Locked_Shopping_Cart L JOIN Issued_For I ON L.id=I.id AND L.Cart_Number=I.Cart_number AND L.Locked_Cart_Number=I.Locked_number
             JOIN Transactions T ON  T.Tracking_code = I.Tracking_code
             WHERE T.T_Status = 'Successful' AND L.id = ? 
             ORDER BY T.Transactions_time DESC
             LIMIT 5; `

    query2 := ` SELECT Category , Brand , Model , Cart_price , Quantity
                FROM Added_To A JOIN Product P ON A.Product_ID=P.id
                WHERE  A.id=? AND A.Cart_number=? AND A.Locked_number=? `

	query3 := ` CALL calculate_price(? , ? , ? , @res)`

    row , err := Database.Query(query1 , userID)

	if err != nil {
		return nil , err
	}

	defer row.Close()
    var cartin []structure.History

	for row.Next() {

		var cid , cnum , lcnum int
		var Tprice float64
        var tempcartin structure.History
		err1 := row.Scan(&cid , &cnum , &lcnum)
		if err1 != nil { return nil , err1 }

		rows , err2 := Database.Query(query2 , cid , cnum , lcnum)
        if err2 != nil { return nil , err2 }
		var plist []structure.ProuductInfo
		for rows.Next() {
               var pl structure.ProuductInfo
			 err3 :=  rows.Scan(&pl.PCategory , &pl.PBrand , &pl.PModel , &pl.CartPrice , &pl.PQuantity)
			 if err3 != nil { return nil , err3 }
			 plist = append(plist, pl)
		}

		_ , err4 :=  Database.Exec(query3 , cid , cnum , lcnum )
		if err4 != nil { return nil , err4 }
		err5 := Database.QueryRow("SELECT @res").Scan(&Tprice)
		if err5 != nil { return nil , err5 }
		tempcartin.PInfo = plist
		tempcartin.TotalPrice = Tprice

		cartin = append(cartin, tempcartin)    
        rows.Close()
	}

	if(len(cartin)== 0 ) { return nil , errors.New(" No carts found. ")}

	return cartin , nil

}

func GetProductId (brand string , model string) (int , error){
     
	Database := configdb.Get_database()

	var PID int

	query := " SELECT id FROM Product WHERE Brand=? AND Model=?"

	err := Database.QueryRow(query , brand , model).Scan(&PID)

	if err != nil {
		if err == sql.ErrNoRows {return  -1 , errors.New(" Prouduct not found. ")}
		return -1 , err
	}

	return PID , nil
       
}

func  GetCompatible (Pbrand string , pmodel string , p1 string , p2 string , p3 string) ([]int , error) {
  
	Database := configdb.Get_database()

    pid , er := GetProductId(Pbrand , pmodel)
	if er != nil {return nil , er}

	query := fmt.Sprintf(" SELECT %s FROM %s WHERE %s = ? " , p1 , p3 , p2)
	row , err := Database.Query(query , pid)
	if(err!=nil) { return nil , err}
    defer row.Close()

	var cmpids []int
	for row.Next() {
		var ids int
		err1 := row.Scan(&ids)
		if(err1!=nil) { return nil , err1}
       cmpids = append(cmpids, ids)
	}

	if(len(cmpids) == 0){
		return nil , errors.New(" NO Products Found! ")
	}

	return cmpids , nil

}







