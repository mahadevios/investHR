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
    static let  REQUEST_PARAMETER                        = "requestParameter"
    static let  POST                                     = "POST"
    static let  GET                                      = "GET"
    static let  PUT                                      = "PUT"
    static let  SUCCESS                                  = "1000"
    static let  FAILURE                                  = "1001"
    static let  DATE_TIME_FORMAT                         = "yyyy-MM-dd HH:mm:ss"
    static let  USERNAME                                 = "username"
    static let  PASSWORD                                 = "password"
    static let  FTP_HOST_NAME                            = "ftp.mtcommunicator.com"
    static let  FTP_FILES_FOLDER_NAME                    = "/TEST/"
    static let  FTP_USERNAME                             = "mt%40mtcommunicator.com"
    static let  FTP_PASSWORD                             = "mtone%40123"

    //static let  BASE_URL_PATH                            = "http://192.168.3.75:9091/coreflex/investhr/"

    static let  BASE_URL_PATH                            = "http://192.168.3.67:8080/coreflex/investhr/"
    static let  NEW_USER_REGISTRATION_API                = "login/registration"
    static let  NEW_USER_LOGIN_API                       = "login"
    static let  LINKEDIN_LOGOUT_API                      = "https://api.linkedin.com/uas/oauth/invalidateToken"
    static let  LINKEDIN_ACCESS_TOKEN                    = "linkedInAccessToken"
    static let  LINKEDIN_ACCESS_TOKEN_EXPIRES_IN         = "linkedInAccessTokenExpiresIn"

    static let  LINKEDIN_ACCESS_TOKEN_ENDPOINT_API       = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    static let  NOTIFICATION_LIACCESSTOKEN_FETCHED       = "LIAccessTokenFetched"
    static let  NOTIFICATION_USER_CHANGED                = "userChanged"
    static let  NOTIFICATION_NEW_USER_LOGGED_IN          = "newUserLoggedIn"

    static let  NOTIFICATION_NEW_USER_REGISTERED         = "newUserRegistered"

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
