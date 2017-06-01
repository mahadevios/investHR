//
//  Constant.swift
//  investHR
//
//  Created by mac on 01/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation



struct Constant
{
    static let  REQUEST_PARAMETER           = "requestParameter"
    static let  POST                        = "POST"
    static let  GET                         = "GET"
    static let  PUT                         = "PUT"
    static let  SUCCESS                     = "1000"
    static let  FAILURE                     = "1001"
    static let  DATE_TIME_FORMAT            = "yyyy-MM-dd HH:mm:ss"
    static let  BASE_URL_PATH               = "http://115.249.195.23:8080/Communicator/feedcom"
    static let  NEW_USER_LOGIN_API          = ""

}

enum MyAlertType
{
    case invalidLogin
    case fileUploadSuccess
}

struct MyAlert
{
    static func showAlert(ofType type: MyAlertType, handler: ((UIAlertAction) -> ())? = nil,handler1: ((UIAlertAction) -> ())? = nil) -> UIAlertController
    {
        
        var message: String
        
        switch type
        {
            case .invalidLogin:
            message = "Invalid credentials,please try again"
            
            case .fileUploadSuccess:
            message = "File uploaded successfully"
        }
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handler))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler1))

        return alert
    }
}
