//
//  APIManager.swift
//  investHR
//
//  Created by mac on 31/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

import MobileCoreServices

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

    }
    
    func loginWithEmail(username:String, password:String, deviceToken:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","deviceToken=\(deviceToken)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.NEW_USER_LOGIN_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.NEW_USER_LOGIN_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
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
    
    
    func getVerticalJobs(username:String, password:String, varticalId:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","varticalId=\(varticalId)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.VERTICAL_JOB_LIST_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.VERTICAL_JOB_LIST_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getHorizontalJobs(username:String, password:String, horizontalId:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","horizontalId=\(horizontalId)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.HORIZONTAL_JOB_LIST_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.HORIZONTAL_JOB_LIST_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }

    func getRoleJobs(username:String, password:String, roleId:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","roleId=\(roleId)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.ROLE_JOB_LIST_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.ROLE_JOB_LIST_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    
    func getSavedJobs(username:String, password:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.SAVED_JOBS_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.SAVED_JOBS_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getAppliedJobs(username:String, password:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.APPLIED_JOBS_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.APPLIED_JOBS_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }

    func saveJob(username:String, password:String, linkedinId:String, jobId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","jobId=\(jobId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.SAVE_JOB_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.SAVE_JOB_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func applyJob(username:String, password:String, linkedinId:String, jobId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","jobId=\(jobId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.APPLY_JOB_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.APPLY_JOB_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getSavedOrAppliedJobDescription(username:String, password:String, linkedinId:String, jobId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","jobId=\(jobId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.SAVED_APPLIED_JOB_DESCRIPTION_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.SAVED_APPLIED_JOB_DESCRIPTION_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getJobDescription(username:String, password:String, linkedinId:String,varticalId:String, jobId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","varticalId=\(varticalId)","jobId=\(jobId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.JOB_DESCRIPTION_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.JOB_DESCRIPTION_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getMoreVerticalJobs(username:String, password:String, linkedinId:String,varticalId:String, jobId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","varticalId=\(varticalId)","existingJobId=\(jobId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LOAD_MORE_VERTICAL_JOB_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LOAD_MORE_VERTICAL_JOB_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getMoreHorizontalJobs(username:String, password:String, linkedinId:String,horizontalId:String, jobId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","horizontalId=\(horizontalId)","existingJobId=\(jobId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LOAD_MORE_HORIZONTAL_JOB_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LOAD_MORE_HORIZONTAL_JOB_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getMoreRoleJobs(username:String, password:String, linkedinId:String,roleId:String, jobId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","roleId=\(roleId)","existingJobId=\(jobId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LOAD_MORE_ROLE_JOB_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LOAD_MORE_ROLE_JOB_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getUserProfile(username:String, password:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.GET_USER_PROFILE_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.GET_USER_PROFILE_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func saveInterestedJob(username:String, password:String, linkedinId:String, jobId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","jobId=\(jobId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.INTERESTED_JOB_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.INTERESTED_JOB_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func saveVideo(username:String, password:String, linkedinId:String, fileName:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","videoName=\(fileName)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.UPLOAD_USER_VIDEO_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.UPLOAD_USER_VIDEO_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }

    func saveResume(username:String, password:String, linkedinId:String, fileName:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)","resumeName=\(fileName)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.UPLOAD_USER_RESUME_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.UPLOAD_USER_RESUME_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getUploadedVideoList(username:String, password:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.UPLOADED_VIDEO_LIST_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.UPLOADED_VIDEO_LIST_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func getUploadedResumeList(username:String, password:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.UPLOADED_RESUME_LIST_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.UPLOADED_RESUME_LIST_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func uodateUserProfile(userDict:Any) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["registrationDict=\(userDict)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.SAVE_EDITED_PROFILE_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.SAVE_EDITED_PROFILE_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    
    func logout(username:String, password:String, linkedinId:String) -> Void
    {
        if AppPreferences.sharedPreferences().isReachable
        {
            let params = ["username=\(username)","password=\(password)","linkedinId=\(linkedinId)"]
            
            let dic = [Constant.REQUEST_PARAMETER:params]
            
            let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LOGOUT_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LOGOUT_API, withHttpMethd: Constant.POST)
            
            downloadmetadatajob.startMetaDataDownLoad()
            
        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
        }
        
    }
    func createRegistrationRequestAndSend(dict:Any, imageData:Data?)
    {
        var request:NSURLRequest!
        do
        {
           request  = try createRegistrationRequest(dict: dict, imageData: imageData) as NSURLRequest!

        } catch let error as NSError
        {
            
        }
        let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.NEW_USER_REGISTRATION_API, withRequestParameter: "" as AnyObject, withResourcePath: Constant.NEW_USER_REGISTRATION_API, withHttpMethd: Constant.POST)
        
        downloadmetadatajob.makeMultipartRequest(request: request as URLRequest)
    }
    
    private func createRegistrationRequest(dict:Any, imageData: Data?) throws -> URLRequest
    {
        let parameters = [
            "registrationDict"  : dict
            ]  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: "\(Constant.BASE_URL_PATH)\("login/registration")")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let path1 = "userImage"
        request.httpBody = try createBody(with: parameters, filePathKey: "file", paths: [path1], boundary: boundary, imageData: imageData)
        
        return request
    }
    
    func createUpdateProfileRequestAndSend(dict:Any, imageData:Data?)
    {
        var request:NSURLRequest!
        do
        {
            request  = try createUpdateProfileRequest(dict: dict, imageData: imageData) as NSURLRequest!
            
        } catch let error as NSError
        {
            
        }
        let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.SAVE_EDITED_PROFILE_API, withRequestParameter: "" as AnyObject, withResourcePath: Constant.SAVE_EDITED_PROFILE_API, withHttpMethd: Constant.POST)
        
        downloadmetadatajob.makeMultipartRequest(request: request as URLRequest)
    }
    
    private func createUpdateProfileRequest(dict:Any, imageData: Data?) throws -> URLRequest
    {
        let parameters = [
            "registrationDict"  : dict
        ]  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: "\(Constant.BASE_URL_PATH)\("login/mobileEditProfile")")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let path1 = "userImage"
        request.httpBody = try createBody(with: parameters, filePathKey: "file", paths: [path1], boundary: boundary, imageData: imageData)
        
        return request
    }

    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    
    func createBody(with parameters: [String: Any]?, filePathKey: String, paths: [String], boundary: String, imageData:Data?) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        if let data = imageData
        {
        for path in paths {
            let url = URL(fileURLWithPath: path)
            //let filename = url.lastPathComponent
            let filename = "userImage.png"

//            let data = try Data(contentsOf: url)
            

            let data1 = UIImagePNGRepresentation(UIImage(named:"Cross")!)
            let mimetype = mimeType(for: path)
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            
                body.append(data)
                body.append("\r\n")
            }
            
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    func mimeType(for path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }    
    

//    func downloadFileFromFTP(fileName:String, sender:Any)
//    {
//        let username = Constant.FTP_USERNAME.replacingOccurrences(of: "@", with: "%40")
//        
//        let password = Constant.FTP_PASSWORD.replacingOccurrences(of: "@", with: "%40")
//        
//        let hostName = Constant.FTP_HOST_NAME
//        
//        let directoryPath = Constant.FTP_DIRECTORY_PATH
//        
//        let downloadFileName = fileName.replacingOccurrences(of: " ", with: "%20")
//        
//       // NSString* urlString=[NSString stringWithFormat:@"ftp://%@:%@%@%@%@",username,password,FTPHostName,FTPFilesFolderName,downloadableAttachmentName];
//
//        let fullyQualifiedPath = "ftp://\(username):\(password)\("@")\(hostName)/\(directoryPath)/\(downloadFileName)"
//        
//        let downloadUrl = URL(string: fullyQualifiedPath)
//        
//        let sessionConf = URLSessionConfiguration.default
//        
//        let downloadSession = URLSession(configuration: sessionConf, delegate: self, delegateQueue: nil)
//        
//        if downloadUrl != nil
//        {
//            let downloadTask = downloadSession.downloadTask(with: downloadUrl!)
//            
//            downloadTask.resume()
//        }
//        
//        
//    }
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
//    {
//        print(error?.localizedDescription)
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
//    {
//        do
//        {
//            let data = try Data.init(contentsOf: location)
//
//        } catch let error as Error
//        {
//            
//        }
//        print(location)
//    }
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
//    {
//        print(totalBytesSent)
//    }
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
//    {
//        print(bytesWritten)
//    }

//    func documentsPath() ->String?
//    {
//        // fetch our paths
//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        
//        if paths.count > 0
//        {
//            // return our docs directory path if we have one
//            let docsDir = paths[0]
//            return docsDir
//        }
//        return nil
//    }
//    
//    func UserVideosFolderPath() -> String
//    {
//        let folderpath = self.documentsPath()! + "/"  + Constant.USER_VIDEOS_FOLDER_NAME
//        
//        return folderpath
//    }

}
