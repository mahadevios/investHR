//
//  HomeViewController.swift
//  investHR
//
//  Created by mac on 17/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import FirebaseAuth

//import FBSDKLoginKit

import Firebase

import FirebaseAnalytics

import SafariServices

//import LinkedinSwift

//import IOSLinkedInAPIFix

class HomeViewController: UIViewController,UIWebViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate, SFSafariViewControllerDelegate
{
    
    @IBOutlet weak var sliderButton: UIButton!
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    let linkedInKey = "81no6kz3uepufn"
    
    let linkedInSecret = "tgGDfootCo2zoLwB"
    
    var webView:UIWebView!
    
    var linkedInLoginView:UIView!

    var responseData = NSMutableData()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        definesPresentationContext = true
        

        
//        let alert2 = MyAlert.showAlert(ofType: MyAlertType.invalidLogin, handler: { (UIAlertAction) in
//            
//            print("cancel pressed")
//        }) { (UIAlertAction) in
//            print("ok pressed")
//
//        }
        
      

        

       // AppPreferences.sharedPreferences().customMessagesArray.append("firstOne")
        //self.present(alert2, animated: true, completion: nil)
        
        
        
        
//        AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Invalid login", withCancelText: "Ok")

//        NotificationCenter.default.addObserver(self, selector: #selector(share(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_LIACCESSTOKEN_FETCHED), object: nil) // after getting the accessToken from linkedin webview, ask for user info and get back to this view with hud, NOTIFICATION_LIACCESSTOKEN_FETCHED when webview fetch the user info, get this info in this controller and pass it to the server and validate the user

        
        
    }
    
    func checkCustomMessagesList(dataDic:Notification)
    {
        guard let notiObj = dataDic.object as? [String:Any] else
        {
            return
        }
        
        let messagesString = notiObj["NotificationMessage"] as! String
        
        if messagesString == "\("[ ]")" || messagesString == "null"
        {
            return
        }
        else
        {
        let messageData = messagesString.data(using: .utf8)
        
        do
        {
            AppPreferences.sharedPreferences().gotMessages = true
            
           let messagesArray = try JSONSerialization.jsonObject(with: messageData!, options: .allowFragments) as! [Any]
            
            print(messagesArray)
            
            AppPreferences.sharedPreferences().customMessagesArray.removeAll()
            
            for index in messagesArray
            {
                var idMessageDic = [String:Any]()

                let messageDic = index as! [String:Any]

                guard let id = messageDic["jobId"] as? Int else
                {
                  break
                }
                idMessageDic["jobId"]  = id
                
                guard let message = messageDic["message"] as? String else
                {
                  break
                }
                idMessageDic["message"]  = message

                

                
                AppPreferences.sharedPreferences().customMessagesArray.append(idMessageDic)
                
            }
            

        } catch let error as NSError
        {
            
        }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(checkCustomMessagesList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_CUSTOM_MESSAGES), object: nil)
        
        if AppPreferences.sharedPreferences().gotMessages == false
        {
            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            
            if username != nil && password != nil
            {
                APIManager.getSharedAPIManager().getCustomMessages(username: username!, password: password!, linkedinId: "")
            }
            else
                if linkedInId != nil
                {
                    APIManager.getSharedAPIManager().getCustomMessages(username: "", password: "", linkedinId: linkedInId!)
                    
            }
        }
//        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.example.com")! as URL)
//        self.present(safariVC, animated: true, completion: nil)
//        safariVC.delegate = self
        
        //        if AppPreferences.sharedPreferences().isReachable
//        {
//            print("reachable")
//        }
       
//        DispatchQueue.global().async
//        {
        
       // }
       // CoreDataManager.getSharedCoreDataManager().getMaxUserId(entityName: "User")
    //uploadFtp()
        
        //self.showWebViewForShare()

    }

    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
    }
    
//    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
//        
//    }
    func uploadFtp()
    {
        let data1    = UIImagePNGRepresentation(UIImage(named:"Cross")!) as NSData!
       // let data    = NSData(contentsOfFile: "example.txt")! as Data

        //let data = UIImagePNGRepresentation(UIImage(named:"Cross")!) as NSData?
        let data    = UIImagePNGRepresentation(UIImage(named:"Cross")!) as Data!
        data?.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
            var buf = UnsafePointer(u8Ptr)
            
            var buf2    = UnsafePointer(u8Ptr)
            var buf3    = UnsafeMutableRawPointer(mutating: u8Ptr)
            //var buf     = UnsafePointer(data.bytes)

            // ... use `rawPtr` ...
        
        //var buf     = UnsafePointer(data.bytes)
       // var buf     = UnsafeRawPointer(data.bytes)

       // let buf2    = UnsafeRawPointer(data.bytes)
        ///let buf3    = UnsafeRawPointer(data.bytes)
        print(data1?.length)
        
        var leftOverSize        = data1?.length
        var bytesFile           = data1?.length
        var totalBytesWritten   = 0
        var bytesWritten        = 0
        
        let login       = "mt@mtcommunicator.com"
        let password    = "mtone@123"
        let ftpServer   = "ftp.mtcommunicator.com"
        var fileName    = ""
        
            if let resourcePath = Bundle.main.resourcePath {
                let imgName = "Cross.png"
                fileName = resourcePath + "/" + imgName
            }
        let ftpUrl = NSURL(string: "ftp://\(login):\(password)@\(ftpServer):21/\(fileName)")
        let stream      = CFWriteStreamCreateWithFTPURL(nil,ftpUrl!).takeUnretainedValue()
        var cfstatus    = CFWriteStreamOpen(stream) as Bool
        // connection fail
        if cfstatus == false {
            print("Not connected")
        }
        
        repeat{
            // Write the data to the write stream
            print(String(describing: stream))
            bytesWritten = CFWriteStreamWrite(stream, buf, leftOverSize!)
            print("bytesWritten: \(bytesWritten)")
            if (bytesWritten > 0) {
                totalBytesWritten += bytesWritten
                // Store leftover data until kCFStreamEventCanAcceptBytes event occurs again
                if (bytesWritten < bytesFile!) {
                    leftOverSize = bytesFile! - totalBytesWritten
                    memmove(buf3, buf2 + bytesWritten, leftOverSize!)
                }else{
                    leftOverSize = 0
                }
                
            }else{
                print("CFWriteStreamWrite returned \(bytesWritten)")
                break
            }
            
            if CFWriteStreamCanAcceptBytes(stream) != true{
                sleep(1)
            }
        }while((totalBytesWritten < bytesFile!))
        
        print("totalBytesWritten: \(totalBytesWritten)")
        
        CFWriteStreamClose(stream)
            
        }
    }
    @IBAction func verticalWiseButtonPressed(_ sender: Any)
    {
       
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerticalViewController") as! VerticalViewController
        vc.domainType = "vertical"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func rolesWiseButtonPressed(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerticalViewController") as! VerticalViewController
        vc.domainType = "roles"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func locationWiseButtonPressed(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        
        
       // let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
        
        //vc1.pushViewController(vc, animated: true)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        //self.revealViewController().pushFrontViewController(vc1, animated: true)
       
    }
    
    @IBAction func horizontalWiseButtonPressed(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerticalViewController") as! VerticalViewController
        vc.domainType = "horizontal"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sliderButtonClicked(_ sender: Any)
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(sender)
        }
    }
    
    @IBAction func notificationButtonClicked(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomNotificationViewController") as! CustomNotificationViewController
        vc.view.frame = CGRect(x: vc.view.frame.width*0.2, y: vc.view.frame.height*0.2, width: vc.view.frame.width*0.6, height: vc.view.frame.height*0.6)
        
        vc.modalPresentationStyle = .overCurrentContext        
        
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    //-(void)createSWRevealView
    //{
    //    SWRevealViewController *revealViewController = self.revealViewController;
    //    if ( revealViewController )
    //    {
    //        [menuBarButton setTarget: self.revealViewController];
    //        [menuBarButton setAction: @selector( revealToggle: )];
    //        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //    }     // Do any additional setup after loading the view.
    //}

    @IBAction func logoutButtonClicked(_ sender: Any)
    {
        //GIDSignIn.sharedInstance().signOut()
        
        try! FIRAuth.auth()!.signOut()
        
        //let loginManager = FBSDKLoginManager()
        
        //FBSDKLoginManager().logOut()
        
      //  loginManager.logOut() // this is an instance function
        
      //  UserDefaults.standard.removeObject(forKey: "fbAccessToken")
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }

        //self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func showWebViewForShare() -> Void
//    {
//        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
//        
//        
//        let responseType = "code"
//        
//        let clientId = responseType
//        
//        var redirectUrl = "https://www.example.com"
//        //var redirectUrl = "https://www.investhr.auth0.com/ios/com.xanadutec.investHR/callback"
//        let scope = "r_basicprofile,r_emailaddress,w_share"
//        
//        
//        
//        
//        redirectUrl = redirectUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!
//        
//        //let authUrl = "https://www.linkedin.com/oauth/v2/authorization?scope=\(scope)%20r_emailaddress&redirect_uri=\(redirectUrl)&client_id=81no6kz3uepufn&state=\(state)&responseType=\(responseType)"
//        
//        
//        var authorizationURL = "\(authorizationEndPoint)?"
//        authorizationURL += "response_type=\(responseType)&"
//        authorizationURL += "client_id=\(linkedInKey)&"
//        authorizationURL += "redirect_uri=\(redirectUrl)&"
//        authorizationURL += "state=\(state)&"
//        authorizationURL += "scope=\(scope)"
//        
//        print("1=",authorizationURL)
//        //print("2=",authUrl)
//        
//        //        let authUrl = "https://www.linkedin.com/oauth/v2/authorization?response_type=code&redirect_uri=http%3A%2F%2Fwww.example.com%2Fauth%2Flinkedin&state=987654321&scope=r_basicprofile&client_id=F27W4sBvOjnfRKXZNGiL2V18uttDvQZu"
//        //https://investhr.auth0.com/ios/com.xanadutec.investHR/callback
//        
//        
//        //
//        
//        self.linkedInLoginView = UIView(frame: self.view.bounds)
//        
//        linkedInLoginView.tag = 1000
//        
//        let cancelLinkedInViewImageView = UIImageView(frame: CGRect(x:linkedInLoginView.frame.origin.x+10 , y: linkedInLoginView.frame.origin.y+15, width: 20, height: 20))
//        let cancelLinkedInViewButton = UIButton(frame: CGRect(x:linkedInLoginView.frame.origin.x , y: linkedInLoginView.frame.origin.y, width: 70, height: 70))
//        cancelLinkedInViewButton.addTarget(self, action: #selector(cancelLinkedInViewButtonClicked), for: .touchUpInside)
//        
//        cancelLinkedInViewButton.tag = 999
//        //cancelLinkedInViewButton.setTitleColor(UIColor.red, for: UIControlState.normal)
//        //cancelLinkedInViewButton.setTitle("Cancel", for: .normal)
//        //cancelLinkedInViewButton.setBackgroundImage(UIImage(named:"Cross"), for: .normal)
//        cancelLinkedInViewImageView.image = UIImage(named: "Cross")
//        self.webView = UIWebView(frame: CGRect(x:linkedInLoginView.frame.origin.x , y: linkedInLoginView.frame.origin.y, width: linkedInLoginView.frame.size.width, height: linkedInLoginView.frame.size.height))
//        
//        webView.tag = 998
//        
//        linkedInLoginView.addSubview(webView)
//        
//        linkedInLoginView.addSubview(cancelLinkedInViewImageView)
//        
//        linkedInLoginView.addSubview(cancelLinkedInViewButton)
//        
//        webView.delegate = self
//        
//        DispatchQueue.global(qos: .background).async
//            {
//                self.webView.loadRequest(NSURLRequest(url: NSURL(string: authorizationURL) as! URL) as URLRequest)
//                
//        }
//        
//        self.view.addSubview(linkedInLoginView)
//        
//        
//        
//    }
//    
    
    // MARK: webview delegates
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
//    {
//        let url = request.url!
//        print(url)
//        
//        if url.host == "www.example.com"
//        {
//            if url.absoluteString.range(of: "code") != nil
//            {
//                // Extract the authorization code.
//                let urlParts = url.absoluteString.components(separatedBy: "?")
//                let code = (urlParts[1].components(separatedBy:"=")[1]).components(separatedBy: "&")[0]
//                
//                requestForAccessToken(authorizationCode: code)
////                let url = NSURL(string: Constant.LINKEDIN_SHARE_API.addingPercentEscapes(using: String.Encoding.utf8)!)
////                
////                let request = NSMutableURLRequest(url: url as! URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 120)
////                
////               
////                let parameter = ["comment": "Check out developer.linkedin.com!","content": [
////                    "title": "LinkedIn Developers Resources",
////                    "description": "Leverage LinkedIn's APIs to maximize engagement",
////                    "submitted-url": "https://developer.linkedin.com",
////                    "submitted-image-url": "https://example.com/logo.png"
////                ],
////                "visibility": [
////                    "code": "anyone"
////                ]
////            ] as! [String : Any]
////                
////                
////                
////                do {
////                    let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
////                    // here "jsonData" is the dictionary encoded in JSON data
////                    
////                    //let decoded = try JSONSerialization.jsonObject(with: jsonData, options: []) as! String
////                    
////                    //print(decoded)
////                    
////                    request.setValue("json", forHTTPHeaderField: "x-li-format")
////                    
////                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
////                    
////                    //let postData = decoded.data(using: .utf8)
////                    
////                    // Set the HTTP body using the postData object created above.
////                    request.httpBody = jsonData
////                    
////                   // print(postData ?? "nil")
////                    print(request.httpBody ?? "nil")
////                    
////                    //request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
////                    
////                    
////                    request.httpMethod = "POST"
////                    
////                    let urlConnection = NSURLConnection.init(request: request as URLRequest, delegate: self)
////
////                    // you can now cast it with the right type
//////                    if let dictFromJSON = decoded as? [String:String] {
//////                        // use dictFromJSON
//////                    }
////                } catch {
////                    print(error.localizedDescription)
////                }
////
//                                    //self.dismiss(animated: true, completion: nil)
//            }
//            else
//            {
//                //self.dismiss(animated: true, completion: nil)
//                cancelLinkedInViewButtonClicked()
//            }
//        }
//        
//        return true
//    }
//    
//    func requestForAccessToken(authorizationCode: String)
//    {
//        let grantType = "authorization_code"
//        
//        let redirectURL = "https://www.example.com".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)
//        // }
//        // Set the POST parameters.
////        var postParams = "grant_type=\(grantType)&"
////        postParams += "code=\(authorizationCode)&"
////        postParams += "redirect_uri=\(redirectURL!)&"
////        postParams += "client_id=\(linkedInKey)&"
////        postParams += "client_secret=\(linkedInSecret)"
//        
//        
//        APIManager.getSharedAPIManager().getLinkedInAccessToken(grant_type: grantType, code: authorizationCode, redirect_uri: redirectURL!, client_id: linkedInKey, client_secret: linkedInSecret)
//        
//        cancelLinkedInViewButtonClicked()
//        
//        //self.hud().show(animated: true)
//        
//        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
//        
//        hud.tag = 789
//        
//        hud.minSize = CGSize(width: 150.0, height: 100.0)
//        
//        hud.label.text = "Logging in.."
//        
//        hud.detailsLabel.text = "Please wait"
//        
//        
//        //
//        
//    }
//    func webViewDidStartLoad(_ webView: UIWebView)
//    {
//        
//    }
//    
//    func webViewDidFinishLoad(_ webView: UIWebView)
//    {
//        
//    }
//    
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
//    {
//        print(error)
//    }
//
//    func cancelLinkedInViewButtonClicked()
//    {
//        self.webView.delegate = nil
//        self.webView.removeFromSuperview()
//        self.linkedInLoginView.removeFromSuperview()
//        self.webView.stopLoading()
//        //self.view.viewWithTag(1000)?.removeFromSuperview()
//        
//        
//        let cookieStorage =  HTTPCookieStorage.shared
//        for cookie in cookieStorage.cookies! {
//            cookieStorage.deleteCookie(cookie)
//        }
//        //URLCache.shared.removeAllCachedResponses()
//        //self.removeFromParentViewController()
//    }
//
//    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
//        
//        let httpResponse = response as! HTTPURLResponse
//        
//        let statusCode = httpResponse.statusCode
//        
//        print(statusCode)
//    }
//    
//    func connectionDidFinishLoading(_ connection: NSURLConnection) {
//        
//        do {
//            let response =  try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as? [String:AnyObject]
//            print(response)
//        } catch let error as NSError
//        {
//            print(error)
//        }
//
//    }
//    
//    func connection(_ connection: NSURLConnection, didReceive data: Data) {
//        
//        responseData.append(data)
//    }
//    
//    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
//        
//        print(error)
//
//    }
//    
//    func share(dataDic:NSNotification)
//    {
//        
//        let dic = dataDic.object as! [String:AnyObject]
//        let accessToken = dic["access_token"] as! String
//        
//        let url = NSURL(string: Constant.LINKEDIN_SHARE_API.addingPercentEscapes(using: String.Encoding.utf8)!)
//        
//        let request = NSMutableURLRequest(url: url as! URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 120)
//        
//        
//        let parameter = ["comment": "Check out developer.linkedin.com!","content": [
//            "title": "LinkedIn Developers Resources",
//            "description": "Leverage LinkedIn's APIs to maximize engagement",
//            "submitted-url": "https://developer.linkedin.com",
//            "submitted-image-url": "https://example.com/logo.png"
//            ],
//                         "visibility": [
//                            "code": "anyone"
//            ]
//            ] as! [String : Any]
//        
//        
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
//            // here "jsonData" is the dictionary encoded in JSON data
//            
//            //let decoded = try JSONSerialization.jsonObject(with: jsonData, options: []) as! String
//            
//            //print(decoded)
//            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//            
//            request.setValue("json", forHTTPHeaderField: "x-li-format")
//            
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            //let postData = decoded.data(using: .utf8)
//            
//            // Set the HTTP body using the postData object created above.
//            request.httpBody = jsonData
//            
//            // print(postData ?? "nil")
//            print(request.httpBody ?? "nil")
//            
//            //request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
//            
//            
//            request.httpMethod = "POST"
//            
//            let urlConnection = NSURLConnection.init(request: request as URLRequest, delegate: self)
//            
//            // you can now cast it with the right type
//            //                    if let dictFromJSON = decoded as? [String:String] {
//            //                        // use dictFromJSON
//            //                    }
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        
//        
//        
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
