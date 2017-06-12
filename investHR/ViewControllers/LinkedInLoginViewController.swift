//
//  LinkedInLoginViewController.swift
//  investHR
//
//  Created by mac on 12/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class LinkedInLoginViewController: UIViewController,UIWebViewDelegate
{

    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    let linkedInKey = "81no6kz3uepufn"
    
    let linkedInSecret = "tgGDfootCo2zoLwB"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        showWebView()
        
    }
    
    func showWebView() -> Void
    {
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        
        let responseType = "code"
        
        let clientId = responseType
        
        var redirectUrl = "https://www.example.com"
        
        let scope = "r_basicprofile"
        
        
        
        
        redirectUrl = redirectUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!
        
        let authUrl = "https://www.linkedin.com/oauth/v2/authorization?scope=\(scope)%20r_emailaddress&redirect_uri=\(redirectUrl)&client_id=81no6kz3uepufn&state=\(state)&responseType=\(responseType)"
        
        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectUrl)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print("1=",authorizationURL)
        print("2=",authUrl)
        
        //        let authUrl = "https://www.linkedin.com/oauth/v2/authorization?response_type=code&redirect_uri=http%3A%2F%2Fwww.example.com%2Fauth%2Flinkedin&state=987654321&scope=r_basicprofile&client_id=F27W4sBvOjnfRKXZNGiL2V18uttDvQZu"
        //https://investhr.auth0.com/ios/com.xanadutec.investHR/callback
        
        
        //
        
        let webView = UIWebView(frame: self.view.bounds)
        
        webView.delegate = self
        
        webView.loadRequest(NSURLRequest(url: NSURL(string: authorizationURL) as! URL) as URLRequest)
        
        self.view.addSubview(webView)
        
        
 
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        let url = request.url!
        print(url)
        
        if url.host == "www.example.com"
        {
            if url.absoluteString.range(of: "code") != nil
            {
                // Extract the authorization code.
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let code = (urlParts[1].components(separatedBy:"=")[1]).components(separatedBy: "&")[0]
                
                requestForAccessToken(authorizationCode: code)
            }
        }
        
        return true
    }
    
    func requestForAccessToken(authorizationCode: String)
    {
        let grantType = "authorization_code"
        
        let redirectURL = "https://www.example.com".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)
        // }
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL!)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        let params = ["grant_type=\(grantType)&","code=\(authorizationCode)&","redirect_uri=\(redirectURL!)&","client_id=\(linkedInKey)&","client_secret=\(linkedInSecret)"]
        
        let dic = [Constant.REQUEST_PARAMETER:params]
        
        let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API, withHttpMethd: Constant.POST)
        
        downloadmetadatajob.startMetaDataDownLoad()
        
//        let postData = postParams.data(using: .utf8)
//        
//        let request = NSMutableURLRequest(url: NSURL(string: accessTokenEndPoint)! as URL)
//        
//        // Indicate that we're about to make a POST request.
//        request.httpMethod = "POST"
//        
//        // Set the HTTP body using the postData object created above.
//        request.httpBody = postData
//        
//        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        
//        // Make the request.
//        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
//            // Get the HTTP status code of the request.
//            let statusCode = (response as! HTTPURLResponse).statusCode
//            
//            if statusCode == 200 {
//                // Convert the received JSON data into a dictionary.
//                do {
//                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
//                    
//                    let accessToken = dataDictionary["access_token"] as! String
//                    
//                    print(dataDictionary)
//                    print(accessToken)
//                    
//                    UserDefaults.standard.set(accessToken, forKey: Constant.LINKEDIN_ACCESS_TOKEN)
//                    UserDefaults.standard.synchronize()
//                    
//                    
//                    if let accessToken = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN)
//                    {
//                        // Specify the URL string that we'll get the profile info from.
//                        let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url)?format=json"
//                        
//                        let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
//                        
//                        // Indicate that this is a GET request.
//                        request.httpMethod = "GET"
//                        
//                        // Add the access token as an HTTP header field.
//                        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//                        
//                        let session = URLSession(configuration: URLSessionConfiguration.default)
//                        
//                        // Make the request.
//                        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
//                            
//                            let statusCode = (response as! HTTPURLResponse).statusCode
//                            
//                            if statusCode == 200
//                            {
//                                // Convert the received JSON data into a dictionary.
//                                do {
//                                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
//                                    
//                                    let profileURLString = dataDictionary["publicProfileUrl"] as! String
//                                    
//                                    print(profileURLString)
//                                }
//                                catch {
//                                    print("Could not convert JSON data into a dictionary.")
//                                }
//                            }
//                            
//                            
//                        }
//                        
//                        task.resume()
//                    }
//                }
//                catch {
//                    print("Could not convert JSON data into a dictionary.")
//                }
//            }
//            else
//            {
//                print(data)
//                do {
//                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
//                    
//                    let accessToken = dataDictionary["access_token"] as! String
//                    
//                    
//                }
//                catch {
//                    print("Could not convert JSON data into a dictionary.")
//                }
//            }
//        }
//        
//        task.resume()
//        
        
    }
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        print(error)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
