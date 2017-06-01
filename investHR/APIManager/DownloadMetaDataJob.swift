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
    var responseData:NSMutableData?
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
        
        var parameter:NSMutableString!
        
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
        
        let webservicePath = "\(Constant.BASE_URL_PATH)\(resourcePath)\(parameter)"
        
        let url = NSURL.init(string: webservicePath.addingPercentEscapes(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: url as! URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 120)
        
        request.httpMethod = httpMethodParameter
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let urlConnection = NSURLConnection.init(request: request as URLRequest, delegate: self)
        
        print(urlConnection ?? "urlConnection = nil")

        //let url = NSURL.init(string: webservicePath.addingPercentEncoding(withAllowedCharacters: CharacterSet)

        
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection)
    {
        
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data)
    {
        responseData?.append(data)
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error)
    {
        if self.downLoadEntityJobName == Constant.NEW_USER_LOGIN_API
        {
            
        }
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse)
    {
        responseData?.length = 0
        
        let httpResponse = response as! HTTPURLResponse
        
        statusCode = httpResponse.statusCode
        
    }
    
    
    
}
