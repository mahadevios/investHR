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
        let params = ["invalidateToken=\(accesToken)"]
        
        let dic = [Constant.REQUEST_PARAMETER:params]
        
        let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LINKEDIN_LOGOUT_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LINKEDIN_LOGOUT_API, withHttpMethd: Constant.GET)
        
        downloadmetadatajob.startMetaDataDownLoad()
        
        
        
    }

}
