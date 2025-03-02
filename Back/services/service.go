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


