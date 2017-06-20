//
//  APIManager.swift
//  investHR
//
//  Created by mac on 31/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class APIManager: NSObject
{
    private static let sharedManager = APIManager()
    //private var dummyObject:APIManager
    
    private override init()
    {
        super.init()
       // dummyObject = APIManager()
    }
    
    class func getSharedAPIManager() -> APIManager
    {
        return sharedManager;
    }
    
    func logoutFromLinkedIn(accesTOken accesToken:String) -> Void
    {
        let params = ["invalidateToken=\(accesToken)"]
        
        let dic = [Constant.REQUEST_PARAMETER:params]
        
        let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LINKEDIN_LOGOUT_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LINKEDIN_LOGOUT_API, withHttpMethd: Constant.GET)
        
        downloadmetadatajob.startMetaDataDownLoad()
        
        
        
    }
    
    func loginWithLinkedIn(accesTOken accesToken:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["invalidateToken=\(accesToken)"]
        
            let dic = [Constant.REQUEST_PARAMETER:params]
        
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LINKEDIN_LOGOUT_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LINKEDIN_LOGOUT_API, withHttpMethd: Constant.GET)
        
            downloadmetadatajob.startMetaDataDownLoad()
        
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }

//        var postParams = "grant_type=\(grantType)&"
//        postParams += "code=\(authorizationCode)&"
//        postParams += "redirect_uri=\(redirectURL!)&"
//        postParams += "client_id=\(linkedInKey)&"
//        postParams += "client_secret=\(linkedInSecret)"
    }
    
    func getLinkedInAccessToken(grant_type:String, code:String, redirect_uri:String, client_id:String, client_secret:String)
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let paramArray = ["grant_type=\(grant_type)","code=\(code)","redirect_uri=\(redirect_uri)","client_id=\(client_id)","client_secret=\(client_secret)"]
        
            let dic = [Constant.REQUEST_PARAMETER:paramArray]
        
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API, withHttpMethd: Constant.POST)
        
            downloadmetadatajob.startMetaDataDownLoad()
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }

        
    }
    
//    func registerUser(name:String, emailId:String, mobileNumber:String, password:String, curentRole:String, currentCompany:String,state:String, city:String, visaStatus:String, service:String, linkedInProfileUrl:String, candidateRole:String, verticals:String, revenueQuota:String, PL:String, experience:String, cuurrentCompany:String, companyInterViewed:String, expectedCompany:String, relocation:String, joiningTimeReq:String, benefits:String, notJoin:String) -> Void
//    {
//        if AppPreferences.sharedPreferences().isReachable
//        {
//            let parameterArray = ["name=\(name)","emailId=\(emailId)","mobileNumber=\(mobileNumber)","password=\(password)","currentRole=\(curentRole)","currentCompany=\(currentCompany)","stateId=\(state)","cityId=\(city)","visaStatus=\(visaStatus)","candidateRole=\(candidateRole)","services=\(service)","linkedInProfileUrl=\(linkedInProfileUrl)","verticalsServiceTo=\(verticals)","revenueQuota=\(revenueQuota)","PandL=\(PL)","currentCompLastYrW2=\(cuurrentCompany)","expectedCompany=\(expectedCompany)","joiningTime=\(joiningTimeReq)","compInterviewPast1Yr=\(companyInterViewed)","benifits=\(benefits)","notJoinSpecificOrg=\(notJoin)"]
//            
//            let dic = [Constant.REQUEST_PARAMETER:parameterArray]
//            
//            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API, withHttpMethd: Constant.POST)
//            
//            downloadmetadatajob.startMetaDataDownLoad()
//        }
//        else
//        {
//           AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
//        }
//        
//    }
    
    func registerUser( dict:Any) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let parameterArray = ["registrationDict=\(dict)"]
        
            let dic = [Constant.REQUEST_PARAMETER:parameterArray]
        
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.NEW_USER_REGISTRATION_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.NEW_USER_REGISTRATION_API, withHttpMethd: Constant.POST)
        
            downloadmetadatajob.startMetaDataDownLoad()
        
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
    }

}
