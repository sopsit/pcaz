package services

import (
    "myproject/configdb"
    "myproject/structure"
    "myproject/repositories"
    "errors"

    //"errors"
)
    // if err := configdb.DB.Where("phone_number = ?", phoneNumber).First(&user).Error; err != nil {
    //     return nil, errors.New("invalid credentials")
    // }
    // return &user, nil

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


