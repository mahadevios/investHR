//
//  DownloadMetaDataJob.swift
//  investHR
//
//  Created by mac on 01/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class DownloadMetaDataJob: NSObject,NSURLConnectionDelegate,NSURLConnectionDataDelegate
{
    var downLoadResourcePath:String!
    var requestParameter:[String:AnyObject]?
    var downLoadEntityJobName:String!
    var httpMethod:String!
    var responseData = NSMutableData()
    var statusCode:Int!
    
    
    func initWithdownLoadEntityJobName( jobName:String, withRequestParameter localRequestParameter:AnyObject, withResourcePath resourcePath:String, withHttpMethd httpMethodParameter:String) -> DownloadMetaDataJob
    {
        let downloadJob = DownloadMetaDataJob()
        downloadJob.downLoadResourcePath = resourcePath;
        downloadJob.requestParameter = localRequestParameter as? [String:AnyObject];
        downloadJob.downLoadEntityJobName = jobName
        downloadJob.httpMethod=httpMethodParameter;
        return downloadJob
    }
    
    func startMetaDataDownLoad()
    {
        
        self.sendNewRequestWithResourcePath(resourcePath: self.downLoadResourcePath, withRequestParameter: self.requestParameter!, withJobName: self.downLoadEntityJobName, withMethodType: self.httpMethod)
        
    }
    
    func sendNewRequestWithResourcePath( resourcePath:String, withRequestParameter dictionary:[String:AnyObject], withJobName jobName:String, withMethodType httpMethodParameter:String ) -> Void
    {
        
        self.responseData = NSMutableData()
        
        let paramArray = (self.requestParameter?[Constant.REQUEST_PARAMETER]) as! [String]
        
        var parameter = ""
        
        
        var webservicePath = ""
    
        if jobName == Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API
        {
            webservicePath = jobName

        }
        else
        {
            webservicePath = "\(Constant.BASE_URL_PATH)\(resourcePath)"

        }
        
        let url = NSURL(string: webservicePath.addingPercentEscapes(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: url as! URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 120)

        for param in paramArray
        {
            if paramArray[0] == param
            {
                parameter.append(param)
            }
            else
            {
                parameter.append("&\(param)")
            }
        }
        
        if httpMethodParameter == Constant.GET
        {
            
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        else
        {
            let postData = parameter.data(using: .utf8)
            
            // Set the HTTP body using the postData object created above.
            request.httpBody = postData
            
            print(postData ?? "nil")
            print(request.httpBody ?? "nil")

            //request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpMethod = httpMethodParameter
        
        let urlConnection = NSURLConnection.init(request: request as URLRequest, delegate: self)
        
        print(urlConnection ?? "urlConnection = nil")

        //let url = NSURL.init(string: webservicePath.addingPercentEncoding(withAllowedCharacters: CharacterSet)
        
    }
    
    func makeMultipartRequest(request:URLRequest)
    {
        let urlConnection = NSURLConnection.init(request: request as URLRequest, delegate: self)
        
        print(urlConnection ?? "urlConnection = nil")

    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection)
    {
        let response:[String:AnyObject]?
        //let dictFromJSON:[String:String]?
        do
        {
            response =  try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as? [String:AnyObject]
            
            guard response != nil else
            {
                AppPreferences.sharedPreferences().showAlertViewWith(title: "Error", withMessage: "please try again", withCancelText: "Ok")
                return
            }
            
            
                if self.downLoadEntityJobName == Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API
                {
                    //                if dictFromJSON["code"] == Constant.SUCCESS
                    //                {
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LIACCESSTOKEN_FETCHED), object: response, userInfo: nil)
                    //
                    //                }
                    //                else
                    //                {
                    //                   AppPreferences.sharedPreferences().showAlertViewWith(title: "Error", withMessage: "username or password is incorrect, please try again", withCancelText: "Cancel")
                    //                }
                    return
                }

            
            switch self.downLoadEntityJobName
            {
                case Constant.NEW_USER_LOGIN_API:
                
                    guard let dictFromJSON = response else
                    {
                        return
                    }
                    if dictFromJSON["code"] as! String == Constant.SUCCESS
                    {
                        
                        UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                        //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"], withCancelText: "Ok")
                        
                        NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_LOGGED_IN), object: dictFromJSON, userInfo: nil)
                    
                    }
                    else
                    {
                        UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                        AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"] as! String, withCancelText: "Ok")
                    
                        //                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Error", withMessage: "username or password is incorrect, please try again", withCancelText: "Ok")
                        // NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_REGISTERED), object: dictFromJSON, userInfo: nil)
                    
                    }
                    break
                
            case Constant.NEW_USER_REGISTRATION_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if dictFromJSON["code"] as! String == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_REGISTERED), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"] as! String, withCancelText: "Ok")
                    
                    //                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Error", withMessage: "username or password is incorrect, please try again", withCancelText: "Ok")
                    // NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_REGISTERED), object: dictFromJSON, userInfo: nil)
                    
                }
                break
            case Constant.VERTICAL_JOB_LIST_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_VERTICAL_JOB_LIST), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_VERTICAL_JOB_LIST), object: dictFromJSON, userInfo: nil)

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    
                }
                
                    break
            case Constant.HORIZONTAL_JOB_LIST_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_HORIZONTAL_JOB_LIST), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_VERTICAL_JOB_LIST), object: dictFromJSON, userInfo: nil)

                    // AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
            case Constant.ROLE_JOB_LIST_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_ROLE_JOB_LIST), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_VERTICAL_JOB_LIST), object: dictFromJSON, userInfo: nil)

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.LOCATION_WISE_JOB_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOCATION_WISE_JOB), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_VERTICAL_JOB_LIST), object: dictFromJSON, userInfo: nil)

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.SAVED_JOBS_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_SAVED_JOB_LIST), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.APPLIED_JOBS_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_APPLIED_JOB_LIST), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }

                break
                
            case Constant.JOB_DESCRIPTION_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_JOB_DESCRIPTION), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.SAVE_JOB_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_SAVE_JOB), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                
                break
                
            case Constant.APPLY_JOB_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_APPLY_JOB), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.SAVED_APPLIED_JOB_DESCRIPTION_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_SAVED_APPLIED_JOB_DESCRIPTION), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }

                break
                
            case Constant.LOAD_MORE_VERTICAL_JOB_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_VERTICAL_JOB), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_VERTICAL_JOB), object: dictFromJSON, userInfo: nil)

                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.LOAD_MORE_HORIZONTAL_JOB_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_HORIZONTAL_JOB), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_HORIZONTAL_JOB), object: dictFromJSON, userInfo: nil)

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break

            case Constant.LOAD_MORE_ROLE_JOB_API:

                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_ROLE_JOB), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_ROLE_JOB), object: dictFromJSON, userInfo: nil)

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
             
            case Constant.LOAD_MORE_LOCATION_JOB_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_LOCATION_JOB), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_LOCATION_JOB), object: dictFromJSON, userInfo: nil)

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.GET_USER_PROFILE_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_GET_USER_PROFILE), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break

            case Constant.INTERESTED_JOB_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "File uploaded successfully", withCancelText: "Ok")

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_INTERESTED_JOB), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.UPLOAD_USER_VIDEO_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    //UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_UPLOAD_USER_VIDEO), object: dictFromJSON, userInfo: nil)

                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Upload Success", withMessage: "Video uploaded successfully", withCancelText: "Ok")

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    
                }
                else
                {

                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.UPLOAD_USER_RESUME_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
//                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_UPLOAD_USER_RESUME), object: dictFromJSON, userInfo: nil)

                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Upload Success", withMessage: "Resume uploaded successfully", withCancelText: "Ok")
                    
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.UPLOADED_VIDEO_LIST_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_UPLOADED_VIDEO_LIST), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
            case Constant.UPLOADED_RESUME_LIST_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_UPLOADED_RESUME_LIST), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break

            case Constant.SAVE_EDITED_PROFILE_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_SAVE_EDITED_PROFILE), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.DELETE_VIDEO_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_DELETE_VIDEO), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    //UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
   
            case Constant.DELETE_RESUME_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_DELETE_RESUME), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
//                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.CUSTOM_MESSAGES_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_CUSTOM_MESSAGES), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    //                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break

                
            case Constant.LOGOUT_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                   // NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_DELETE_RESUME), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    //                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break
                
            case Constant.FORGOT_PASSWORD_API:
                
                guard let dictFromJSON = response else
                {
                    return
                }
                if String(describing: dictFromJSON["code"]!) == Constant.SUCCESS
                {
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                     NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_FORGOT_PASSWORD), object: dictFromJSON, userInfo: nil)
                    
                }
                else
                {
                    //                    UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: dictFromJSON["Message"]!, withCancelText: "Ok")
                    
                }
                break

            default: break
                
            }
            
        }
        catch let error as NSError
        {
            UIApplication.shared.keyWindow?.viewWithTag(789)?.removeFromSuperview()
            print("in catch block" + error.localizedDescription)
           // AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Something went wrong!, please try again", withCancelText: "Ok")

        }
        
    
//        
//        if statusCode == 200
//        {
//            
//            do {
//                let response1 = String(data: responseData as Data, encoding: .utf8)
//                print(response1)
//                
//                let dataDictionary =  try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as! [String:AnyObject]
//                
//                NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LIACCESSTOKEN_FETCHED), object: dataDictionary, userInfo: nil)
//
//            }
//            catch let error as NSError
//            {
//            
//            }
//        }
//        else
//        {
//            do {
//                let dataDictionary = try JSONSerialization.jsonObject(with: responseData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
//                
//                let accessToken = dataDictionary["access_token"] as! String
//                
//                
//            }
//            catch {
//                print("Could not convert JSON data into a dictionary.")
//            }
//            
//            
//        }
        
        
    

    
    }

    func connection(_ connection: NSURLConnection, didReceive data: Data)
    {
        responseData.append(data)
    }
    
    func showErrorFromErro( error:NSError) -> String
    {
      return error.localizedDescription
    }
    func connection(_ connection: NSURLConnection, didFailWithError error: Error)
    {
        print(error)
        if self.downLoadEntityJobName == Constant.NEW_USER_LOGIN_API
        {
           
            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
           // NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_LOGGED_IN), object: nil, userInfo: nil)

            AppPreferences.sharedPreferences().showAlertViewWith(title: "Error", withMessage:showErrorFromErro(error: error as NSError) , withCancelText: "Ok")
            
        }
        else

        if self.downLoadEntityJobName == Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API
        {
            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

            AppPreferences.sharedPreferences().showAlertViewWith(title: "Error", withMessage:showErrorFromErro(error: error as NSError) , withCancelText: "Ok")
            //NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LIACCESSTOKEN_FETCHED), object: nil, userInfo: nil)

        }
        else
        if self.downLoadEntityJobName == Constant.NEW_USER_REGISTRATION_API
        {
            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

            AppPreferences.sharedPreferences().showAlertViewWith(title: "Error", withMessage:showErrorFromErro(error: error as NSError) , withCancelText: "Ok")

            //NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_REGISTERED), object: nil, userInfo: nil)

        }
        else
        if self.downLoadEntityJobName == Constant.NEW_USER_REGISTRATION_API
        {
            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
            
            AppPreferences.sharedPreferences().showAlertViewWith(title: "Error", withMessage:showErrorFromErro(error: error as NSError) , withCancelText: "Ok")
        }
        else
        {
            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        }
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse)
    {
        responseData.length = 0
        
        let httpResponse = response as! HTTPURLResponse
        
        statusCode = httpResponse.statusCode
        
        print(statusCode)
        
    }
    
    
}
