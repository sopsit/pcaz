// Queries (Insert, Select, Update, Delete)

package repositories

//package main


import (
	"database/sql"
	"errors"
	"myproject/configdb"
	"myproject/structure"
	"fmt"
)

func AddClient(newclient structure.Client) error {

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

func  GetCompatibleWith (pid int , p1 string , p2 string , p3 string) ([]int , error) {
  
	Database := configdb.Get_database()

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

func GetProcucts () ([]structure.Product , error) {

	Database := configdb.Get_database()

	query := " SELECT  Category , Current_price , Stock_count , Brand ,  Model  FROM Product "

	 row , err :=Database.Query(query)
	 if(err!=nil) { return nil , err}
	 defer row.Close()

	 var plist []structure.Product
	 for row.Next() {
		var tmp structure.Product
		er := row.Scan(&tmp.P_category , &tmp.P_currentprice , &tmp.P_Stock_count , &tmp.P_brand , &tmp.P_model)
		if(er!=nil) { return nil , er}
		plist = append(plist, tmp)
	 }

	 if (len(plist) == 0 ) {
		return nil , errors.New(" Not products found")
	 }

	 return plist , nil

}

func Getproductfromid (pid int)(structure.Product , error){

	Database := configdb.Get_database()
	var tmp structure.Product
	query := " SELECT  Category , Current_price , Stock_count , Brand ,  Model  FROM Product WHERE id =? "
	err := Database.QueryRow(query , pid).Scan(&tmp.P_category , &tmp.P_currentprice  , &tmp.P_Stock_count , &tmp.P_brand , &tmp.P_model)
	if err != nil{
		if err==sql.ErrNoRows {return  tmp , errors.New(" Not found. ")}
		return tmp , err
	}

	return tmp , nil
}


func intersect (cmap map[int]int , cslise []int , err error) (map[int]int){

	res := make(map[int]int)

	if (len(cmap) == 0 && err==nil) {
		for _ , value := range cslise {
			res[value]=value
		}

	} else {

		if err != nil {

			res[-1]=-1
			return res
		}

		for _ , value := range cslise {
          
			_ , exists := cmap[value]
			if exists {
				
			   res[value]=value
   
			}
	}

}

	return res

}



func Compatible (list []structure.Info) ([]int , error) {
    
	comatiblelist := make(map[string]map[int]int)
	comatiblelist["POWERSUPPLY"]= make(map[int]int)
	comatiblelist["GPU"]= make(map[int]int)
	comatiblelist["SSD"]= make(map[int]int)
	comatiblelist["RAMSTICK"]= make(map[int]int)
	comatiblelist["MOTHERBOARD"]= make(map[int]int)
	comatiblelist["CPU"]= make(map[int]int)
	comatiblelist["COOLER"]= make(map[int]int)

	for _ , val := range list {

		id , iderr := GetProductId(val.ProductBrand , val.ProductModel)
		if(iderr == nil) {
			if(val.ProductCategory=="Power Supply") {
				s1 , perr := GetCompatibleWith(id , "GPU_ID" , "Power_ID" , "CONNECTOR_COMPATIBLE_WITH")
					comatiblelist["GPU"] = intersect(comatiblelist["GPU"] , s1 , perr)

			} else if(val.ProductCategory=="SSD") {
			   s2 , serr := GetCompatibleWith(id , "Motherboard_ID" , "SSD_ID" , "SM_SLOT_COMPATIBLE_WITH")
					comatiblelist["MOTHERBOARD"] = intersect(comatiblelist["MOTHERBOARD"] , s2 , serr)
				
			} else if(val.ProductCategory=="Cooler"){
				s3 , cerr := GetCompatibleWith(id , "CPU_ID" , "Cooler_ID" , "CC_SOCKET_COMPATIBLE_WITH")
				comatiblelist["CPU"] = intersect(comatiblelist["CPU"] , s3 , cerr)
				 
			}  else if(val.ProductCategory=="GPU"){
				s4 , gpuerr := GetCompatibleWith(id , "Motherboard_ID" , "GPU_ID" , "GM_SLOT_COMPATIBLE_WITH")
				 comatiblelist["MOTHERBOARD"] = intersect(comatiblelist["MOTHERBOARD"] , s4 , gpuerr)

				 s4_1 ,  gpuerr1 := GetCompatibleWith(id , "Power_ID" , "GPU_ID" , "CONNECTOR_COMPATIBLE_WITH")
				comatiblelist["POWERSUPPLY"] = intersect(comatiblelist["POWERSUPPLY"] , s4_1 ,  gpuerr1)	

	    	} else if(val.ProductCategory=="CPU"){
				s5 , cpuerr := GetCompatibleWith(id , "Motherboard_ID" , "CPU_ID" , "MC_SOCKET_COMPATIBLE_WITH")
				 comatiblelist["MOTHERBOARD"] = intersect(comatiblelist["MOTHERBOARD"] , s5 , cpuerr)
				 s5_1 , cpuerr1 := GetCompatibleWith(id , "Cooler_ID" , "CPU_ID" , "CC_SOCKET_COMPATIBLE_WITH")
				comatiblelist["COOLER"] = intersect(comatiblelist["COOLER"] , s5_1 , cpuerr1)

	       }	else if(val.ProductCategory=="RAM"){
		           s6 , Ramerr := GetCompatibleWith(id , "Motherboard_ID" , "Ram_ID" , "RM_SLOT_COMPATIBLE_WITH")
		           comatiblelist["MOTHERBOARD"] = intersect(comatiblelist["MOTHERBOARD"] , s6 ,  Ramerr)

  		   } else if (val.ProductCategory== "Motherboard"){

			   s7 , merr := GetCompatibleWith(id , "SSD_ID" , "Motherboard_ID" , "SM_SLOT_COMPATIBLE_WITH")
			  comatiblelist["SSD"] = intersect(comatiblelist["SSD"] , s7 ,  merr)

			  s7_1 , merr1 := GetCompatibleWith(id , "GPU_ID" , "Motherboard_ID" , "GM_SLOT_COMPATIBLE_WITH")
			  comatiblelist["GPU"] = intersect(comatiblelist["GPU"] , s7_1 ,  merr1)

			  s7_2 , merr2 := GetCompatibleWith(id , "Ram_ID" , "Motherboard_ID" , "RM_SLOT_COMPATIBLE_WITH")
			  comatiblelist["RAMSTICK"] = intersect(comatiblelist["RAMSTICK"] , s7_2 ,  merr2)

			  s7_3 , merr3 := GetCompatibleWith(id , "CPU_ID" , "Motherboard_ID" , "MC_SOCKET_COMPATIBLE_WITH")
			  comatiblelist["CPU"] = intersect(comatiblelist["CPU"] , s7_3 ,  merr3)
		   }

		} 
	}

	var compatiblesid []int

	for _ , categories := range comatiblelist {
        
		if(len(categories) != 0) {
			for _ , val := range categories {
               if(val != -1) {
				compatiblesid = append(compatiblesid, val)
			   }
			}
		}

	}
	if(len(compatiblesid)==0) {
		return nil , errors.New(" NO compatible products found. ")
	}

	return compatiblesid , nil
}

func Getcomatbleproducts(p_list []int) ([]structure.Product ) {

	var l []structure.Product

	for _ , val := range p_list {
       
        a , err:= Getproductfromid(val)
		if err == nil {
		l = append(l, a)
		}
	}

	return l

}




// func main(){

// 	configdb.Connect_db()


// 	 var a structure.Info
// 	 a.ProductBrand="Corsair"
// 	 a.ProductModel="Vengeance LPX"
// 	 a.ProductCategory="RAM"
// 	 var a1 structure.Info
// 	 a1.ProductBrand="Cooler Master"
// 	 a1.ProductModel="Hyper 212"
// 	 a1.ProductCategory="Cooler"

// 	 var a2 structure.Info
// 	 a2.ProductBrand="ASUS"
// 	 a2.ProductModel="ROG Strix Z590-E"
// 	 a2.ProductCategory="Motherboard"

// 	 var b []structure.Info
// 	 b= append(b, a)
// 	 b= append(b, a1)
// 	 b= append(b, a2)

// 	 res , err := Compatible(b)
// 	s := Getcomatbleproducts(res)
// 	fmt.Println(s)

// 	 fmt.Println(res , err )


	
// }



