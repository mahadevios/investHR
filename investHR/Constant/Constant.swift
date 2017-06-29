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
    static let  USER_VIDEOS_FOLDER_NAME                  = "UserVideosFolder"
    static let  FTP_HOST_NAME                            = "ftp.mtcommunicator.com"
    static let  FTP_USERNAME                             = "mt@mtcommunicator.com"
    static let  FTP_PASSWORD                             = "mtone@123"
    static let  FTP_DIRECTORY_PATH                       = "TEST"

    static let  BASE_URL_PATH                            = "http://192.168.3.75:9091/coreflex/investhr/"
    //static let  USER_IMAGE_PATH                          = " http://192.168.3.75:9091/coreflex/resources/UserImages/"

   
    //static let  BASE_URL_PATH                            = "http://192.168.3.80:8080/InvestHr/investhr/"

    //static let  BASE_URL_PATH                            = "http://192.168.3.67:8080/coreflex/investhr/"

   // static let  BASE_URL_PATH                            = "http://192.168.3.74:9090/coreflex/investhr/"
    static let  LINKEDIN_LOGOUT_API                      = "https://api.linkedin.com/uas/oauth/invalidateToken"
    static let  LINKEDIN_ACCESS_TOKEN                    = "linkedInAccessToken"
    static let  LINKEDIN_ACCESS_TOKEN_EXPIRES_IN         = "linkedInAccessTokenExpiresIn"
    static let  LINKEDIN_ACCESS_TOKEN_ENDPOINT_API       = "https://www.linkedin.com/uas/oauth2/accessToken"

    static let  NEW_USER_REGISTRATION_API                = "login/registration"
    static let  NEW_USER_LOGIN_API                       = "login"
    static let  VERTICAL_JOB_LIST_API                    = "login/mobileVerticalJob"
    static let  ROLE_JOB_LIST_API                        = "login/mobileRoleJob"
    static let  HORIZONTAL_JOB_LIST_API                  = "login/mobileHorizontalJob"
    static let  APPLIED_JOBS_API                         = "login/mobileAppliedJob"
    static let  SAVED_JOBS_API                           = "login/mobileSavedJob"
    static let  JOB_DESCRIPTION_API                      = "login/mobileVerticalJobDescription"
    static let  APPLY_JOB_API                            = "login/mobileSaveAppliedJob"
    static let  SAVE_JOB_API                             = "login/mobileSaveUserJob"
    static let  SAVED_APPLIED_JOB_DESCRIPTION_API        = "login/mobileSaveAppliedJobDescription"
    static let  LOAD_MORE_VERTICAL_JOB_API               = "login/mobileLoadMoreVerticalJob"
    static let  LOAD_MORE_HORIZONTAL_JOB_API             = "login/mobileLoadMoreHorizontalJob"
    static let  LOAD_MORE_ROLE_JOB_API                   = "login/mobileLoadMoreRoleJob"
    static let  GET_USER_PROFILE_API                     = "login/mobileGetUserModelDetails"
    static let  INTERESTED_JOB_API                       = "login/mobileSaveInterestedJob"
    static let  UPLOAD_USER_VIDEO_API                    = "login/mobileUploadVideo"
    static let  UPLOAD_USER_RESUME_API                   = "login/mobileUploadResume"
    static let  UPLOADED_RESUME_LIST_API                 = "login/mobileResumeList"
    static let  UPLOADED_VIDEO_LIST_API                  = "login/MobileVideoList"
    static let  SAVE_EDITED_PROFILE_API                  = "login/mobileEditProfile"



    
    static let  NOTIFICATION_LIACCESSTOKEN_FETCHED          = "LIAccessTokenFetched"
    static let  NOTIFICATION_USER_CHANGED                   = "userChanged"
    static let  NOTIFICATION_NEW_USER_LOGGED_IN             = "newUserLoggedIn"
    static let  NOTIFICATION_NEW_USER_REGISTERED            = "newUserRegistered"
    static let  NOTIFICATION_VERTICAL_JOB_LIST              = "verticalJobList"
    static let  NOTIFICATION_HORIZONTAL_JOB_LIST            = "horizontalJobList"
    static let  NOTIFICATION_ROLE_JOB_LIST                  = "roleJobList"
    static let  NOTIFICATION_SAVED_JOB_LIST                 = "savedJobList"
    static let  NOTIFICATION_APPLIED_JOB_LIST               = "appliedJobList"
    static let  NOTIFICATION_JOB_DESCRIPTION                = "jobDescription"
    static let  NOTIFICATION_APPLY_JOB                      = "applyjob"
    static let  NOTIFICATION_SAVE_JOB                       = "savejob"
    static let  NOTIFICATION_SAVED_APPLIED_JOB_DESCRIPTION  = "savedapplieddesc"
    static let  NOTIFICATION_LOAD_MORE_VERTICAL_JOB         = "loadMoreVerticalJob"
    static let  NOTIFICATION_LOAD_MORE_HORIZONTAL_JOB       = "loadMoreHorizontalJob"
    static let  NOTIFICATION_LOAD_MORE_ROLE_JOB             = "loadMoreRoleJob"
    static let  NOTIFICATION_GET_USER_PROFILE               = "getUSerProfile"
    static let  NOTIFICATION_INTERESTED_JOB                 = "interestedJob"
    static let  NOTIFICATION_UPLOAD_USER_VIDEO              = "uploadVideo"
    static let  NOTIFICATION_UPLOAD_USER_RESUME             = "uploadResume"
    static let  NOTIFICATION_UPLOADED_VIDEO_LIST            = "uploadedVideoList"
    static let  NOTIFICATION_UPLOADED_RESUME_LIST           = "uploadedResumeList"
    static let  NOTIFICATION_SAVE_EDITED_PROFILE            = "saveEditedProfile"
    static let  NOTIFICATION_FTP_UPLOAD                     = "ftpUpload"
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
