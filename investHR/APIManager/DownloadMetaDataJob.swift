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
    
        webservicePath = "\(Constant.BASE_URL_PATH)\(resourcePath)"
        
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
    
    func connectionDidFinishLoading(_ connection: NSURLConnection)
    {
        if statusCode == 200 {
            
            do {
                let response1 = String(data: responseData as Data, encoding: .utf8)
                print(response1)
                
                let dataDictionary =  try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as! [String:AnyObject]
                
                NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_LIACCESSTOKEN_FETCHED), object: dataDictionary, userInfo: nil)

            }
            catch let error as NSError
            {
            
            }
        }
        else
        {
            do {
                let dataDictionary = try JSONSerialization.jsonObject(with: responseData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                
                let accessToken = dataDictionary["access_token"] as! String
                
                
            }
            catch {
                print("Could not convert JSON data into a dictionary.")
            }
            
            
        }
        
        
    

    
    }

    func connection(_ connection: NSURLConnection, didReceive data: Data)
    {
        responseData.append(data)
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error)
    {
        print(error)
        if self.downLoadEntityJobName == Constant.NEW_USER_LOGIN_API
        {
            
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
