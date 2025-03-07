package services

import (
	"errors"
	"fmt"
	"myproject/configdb"
	"myproject/repositories"
	"myproject/structure"
)



    func AuthenticateUser(phonenumber string) (*structure.Client, error) {
        configdb.Connect_db()
        
        user, err := repositories.GetClientInfo(phonenumber)
        if err != nil || user == nil {
            return nil, errors.New("invalid credentials")
        }
        
        return user, nil
    }

    func Get_status(userId int) (*bool, error){

        configdb.Connect_db()

        is_VIP, err := repositories.Is_VIP(userId)
        if err != nil || is_VIP == nil {
            return nil, errors.New("invalid credentials") 
        }
        return is_VIP, nil
    }
    
    func Get_GetCountOfReferredClient(userId int) (*int , error){
        configdb.Connect_db()

        
        count, err := repositories.GetCountOfReferredClient(userId)
        if err != nil || count == nil {
            return nil, errors.New("invalid credentials") 
        }
        return count, nil
    }
    func Get_GetTimeRemaningofSubscribe(userID int) (string , error){
        configdb.Connect_db()
        
        remainingTime, err := repositories.GetTimeRemaningofSubscribe(userID)
        if err != nil  {
            return "You are not VIP", errors.New("invalid credentials") 
        }
        return remainingTime, nil
    }
    
    func Get_Get15percent(userId int) (float64 , error){
        configdb.Connect_db()
        
        fiftyP, err := repositories.Get15percent(userId)
        
        if err != nil  {
            return 0, errors.New("invalid credentials") 
        }
        
        return fiftyP, nil
    }
    func Get_address(userId int) ([]string, error){
        configdb.Connect_db()
        
        address, err := repositories.Getaddress(userId)
        fmt.Println("in service: ", address)
        if len(address) == 0 {
            address = append(address, "No addres avalable")
        }
        if err != nil  {
            return address, errors.New("invalid credentials") 
        }

        return address, nil
    }
    func Get_CountofDiscountCodeFromReferralSystem(userId int) (int , error) {
        configdb.Connect_db()
        
        dif_count, err := repositories.GetCountofDiscountCodeFromReferralSystem(userId)
        fmt.Println("in service: ", dif_count)

        if err != nil  {
            return dif_count, errors.New("invalid credentials") 
        }

        return dif_count, nil
    }
    func Get_CartStatus(userID int) ([]structure.CartStatus , error) {

        configdb.Connect_db()
        
        cart, err := repositories.GetCartStatus(userID)
        // fmt.Println("in service: ", cart)
        if err != nil  {
            return cart, errors.New("invalid credentials") 
        }

        return cart, nil
    }
    func Get_CartInformation(userID int) ([]structure.History , error) {
        configdb.Connect_db()
        
        cartInfo, err := repositories.GetCartInformation(userID)
        // fmt.Println("in service: ", cart)
        if err != nil  {
            fmt.Println("Error in GetCartInformation:", err) 
            return cartInfo, errors.New("invalid credentials") 
        }
        
        return cartInfo, nil
    }
    func Get_PrivateDiscountCode(userID int) ([]structure.DiscountCode, error) {
        configdb.Connect_db()
        
        disCode, err := repositories.GetPrivateDiscountCode(userID)
        //  fmt.Println("in service3: ", disCode)
        if err != nil  {
            fmt.Println("Error in GetCartInformation:", err) 
            return disCode, errors.New("invalid credentials") 
        }

        return disCode, nil
    }

    

