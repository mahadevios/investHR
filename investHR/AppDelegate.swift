//
//  AppDelegate.swift
//  investHR
//
//  Created by mac on 11/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

import CoreData

import Firebase

import UserNotifications

import FirebaseMessaging

import SafariServices

//import Auth0

import AVFoundation



//import FBSDKLoginKit

//import LinkedinSwift

//https://www.hackingwithswift.com/read/38/4/creating-an-nsmanagedobject-subclass-with-xcode
// typealias and enum http://www.jessesquires.com/better-coredata-models-in-swift/
// fb login inte. with firebase http://www.appcoda.com/firebase-facebook-login/

// app store rejection app switch http://stackoverflow.com/questions/36520067/google-login-in-login-view-controller-instead-of-appdelegate-ios-swift
//http://stackoverflow.com/questions/36630276/google-login-ios-app-rejection-from-appstore-using-google-sdk-v3-x

// google sign in video https://www.youtube.com/watch?v=QmnI5c85sf0

// relative to margin http://coding.tabasoft.it/ios/ios8-layout-margins/

//doc picker and metadata query  https://developer.xamarin.com/guides/ios/platform_features/introduction_to_the_document_picker/

// auth 0 https://auth0.com/docs/quickstart/native/ios-objc/00-login#hybrid-objective-c-swift

// sqlite  => without shm and wal https://stackoverflow.com/questions/29598830/read-through-my-apps-core-data-files-sqlite-sqlite-wal
//https://developer.apple.com/library/content/qa/qa1809/_index.html
//https://stackoverflow.com/questions/25667447/how-to-turn-off-core-data-write-ahead-logging-in-swift-using-options-dictionary
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    var notifView: UIView?
    var jobID:String!
    var massNotificationId:String!
    
    var messageString:String?
    var linkedInUrl:String?

    var isMessageNotification:Bool!

    var islinkedInNotification:Bool!
    
    var isMassNotification:Bool!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
        
        
        var configureError: NSError?
        
        
        //GGLContext.sharedInstance().configureWithError(&configureError)
        
        FIRApp.configure()
        
        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        //print(urls[urls.count-1] as URL)
        
//        if GIDSignIn.sharedInstance().hasAuthInKeychain()
//        {
//            let viewController = (self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"))! as UIViewController
//            self.window?.rootViewController = viewController
//        }
//        //GIDSignIn.sharedInstance().signInSilently()
//        else
//        if FBSDKAccessToken.current() == nil
//        {
//            print("logged out ")
//
//        }
//        else
//        {
//          print("logged in \(FBSDKAccessToken.current())")
//            
//            //let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//
////            if let viewController = storyboard.instantiateViewController(withIdentifier: "MainView") {
////                UIApplication.shared.keyWindow?.rootViewController = viewController
////                //self.dismiss(animated: true, completion: nil)
////            }
//            
////            if let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
////            {
////                UIApplication.shared.keyWindow?.rootViewController = viewController
////            }
//            
//            let viewController = (self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"))! as UIViewController
//            self.window?.rootViewController = viewController
//            
//        }
        
        AppPreferences.sharedPreferences().startReachabilityNotifier()
        
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()
        connectToFcm()
        
        
        if let refreshedToken = FIRInstanceID.instanceID().token()
        {
            AppPreferences.sharedPreferences().firebaseInstanceId = refreshedToken
        }
        
        self.loadAccount()

        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name:NSNotification.Name.firInstanceIDTokenRefresh, object: nil)

        if notification != nil
        {

                    self.application(application, didReceiveRemoteNotification: notification as! [AnyHashable : Any])

            
        }
       // let obj = CoreDataManager.sharedManager
        
        CoreDataManager.getSharedCoreDataManager().deleteOldNotifications(entity: "CommonNotification")
        
        return true
    }
    
    func tokenRefreshNotification( notification:Notification)
    {
        if let refreshedToken = FIRInstanceID.instanceID().token()
        {
            AppPreferences.sharedPreferences().firebaseInstanceId = refreshedToken
            
            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            
            if username != nil && password != nil
            {
                APIManager.getSharedAPIManager().updateDeviceToken(username: username!, password: password!,linkedinId:"", deviceToken: AppPreferences.sharedPreferences().firebaseInstanceId)
            }
            else
                if linkedInId != nil
                {
                    APIManager.getSharedAPIManager().updateDeviceToken(username: "", password: "",linkedinId:linkedInId!, deviceToken: AppPreferences.sharedPreferences().firebaseInstanceId)
                    
                }

        }

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        if let refreshedToken = FIRInstanceID.instanceID().token()
        {
            //print("InstanceID token: \(refreshedToken)")
        }
        // Print it to console
        //print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any])
    {
        // Print notification payload data
        //print("Push notification received: \(data)")
        
        islinkedInNotification = false
        
        isMessageNotification = false

        
        let notificationString = data["notification"] as! String
        
        let notificatioData = notificationString.data(using: .utf8)
        
        
        let apsDic = data["aps"] as! [String:Any]
        
        
        let alertObject = apsDic["alert"] as! [String:String]
        
        //let alertData = alertString.data(using: .utf8)
        
        do
        {
            let notificationObject = try JSONSerialization.jsonObject(with: notificatioData!, options: .allowFragments) as! [String:Any]
            
            let jobIDInt = notificationObject["JobId"] as! Int

            let message = notificationObject["Message"] as? String
            
            linkedInUrl = notificationObject["LinkedIn"] as? String
            
            let massNotification = notificationObject["MassNotification"] as? String

            
            self.jobID = String(jobIDInt)
            
           // print(self.jobID)
            
            let body = alertObject["body"]
            
            let title = alertObject["title"]
            
            if linkedInUrl != nil
            {
                islinkedInNotification = true
                
                //print(linkedInUrl ?? "nil")

            }
            else
            {
                islinkedInNotification = false  // not a linkedin noti...1
                
                if message != nil
                {
                    isMessageNotification = true
                
                    self.messageString = message!
                
                    var idMessageDic = [String:Any]()
                
                    idMessageDic["jobId"]  = jobIDInt
                
                    idMessageDic["message"]  = message
                
                    if application.applicationState == UIApplicationState.background
                    {
                        
                        
                    }
                    else
                    {
                        AppPreferences.sharedPreferences().customMessagesArray.append(idMessageDic)

                    }

                }
                else
                {
                    self.islinkedInNotification = false // not a linkedin noti..
                    
                    self.isMessageNotification = false // not a message noti...2
                    
                    if massNotification != nil
                    {
                        self.isMassNotification = true
                        
                        
                            let date = Date().getLocalDateWithouTimeInString()
                        
                        
                            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as? String
                        
                            let notificationId = notificationObject["NotificationId"] as! Int
                        
                            self.massNotificationId = String(describing:notificationId)
                        
                            let jobIdExist = CoreDataManager.getSharedCoreDataManager().idExists(aToken: self.massNotificationId, entityName: "ZSpecialNotification")

                            if !jobIdExist
                            {

                             CoreDataManager.getSharedCoreDataManager().save(entity: "ZSpecialNotification", ["NotificationId1":notificationId,"subject":body,"notificationDate":date, "userId":userId!, "notificationType":Constant.Notification_Type_Job])
                                
                              NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NOTI_DATA_ADDED), object: nil, userInfo: nil)
                            }
                        
                    }
                    else
                    {
                        self.islinkedInNotification = false // not a linkedin noti..
                        
                        self.isMessageNotification = false // not a message noti.
                        
                        self.isMassNotification = false  // not a mass noti....3
                        
                        
                        let jobIdExist = CoreDataManager.getSharedCoreDataManager().idExists(aToken: String(jobIDInt), entityName: "CommonNotification")
                        
                        let date = Date().getLocalDateWithouTimeInString()
                        
                        if !jobIdExist
                        {
                            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as? String
                            
                            CoreDataManager.getSharedCoreDataManager().save(entity: "CommonNotification", ["jobId":jobIDInt,"subject":body,"notificationDate1":date, "userId":userId!, "notificationType":Constant.Notification_Type_Job])
                            
                            NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NOTI_DATA_ADDED), object: nil, userInfo: nil)
                        }
                        else
                        {
                            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as? String
                            
                            CoreDataManager.getSharedCoreDataManager().updateNotificationJob(entityName: "CommonNotification", jobId: jobIDInt, subject: body!, notificationDate: date, userId: userId!)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NOTI_DATA_ADDED), object: nil, userInfo: nil)
                        }
                        
                    }

                }
                
            }

            
            
            
        } catch let error as NSError
        {
            //print(error.localizedDescription)
        }
        
        if UIApplication.shared.applicationState == UIApplicationState.active
        {
            
            let systemSoundID: SystemSoundID = 1315
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
            
            notifView?.removeFromSuperview() //If already existing
            notifView = UIView(frame: CGRect(x: 0, y: -70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 80))
            notifView?.backgroundColor = UIColor.appBlueColor()
            let imageView = UIImageView(frame: CGRect(x: 10, y: 15, width: 30, height: 30))
            imageView.image = UIImage(named: "AppIcon40x40")
            let label = UILabel(frame: CGRect(x: 60, y: 15, width: (UIApplication.shared.keyWindow?.frame.size.width)! - 100, height: 30))
            label.font = UIFont.systemFont(ofSize: 12)
            
            if islinkedInNotification == true
            {
                label.text = "New Linkedin Job"

            }
            else
            if isMessageNotification == true
            {
                label.text = "New Message"

            }
            else
            if isMessageNotification == true
            {
                label.text = "New Activity"
            }
            else
            {
                label.text = "New Job"

            }
            
            label.textColor = UIColor.white
            label.numberOfLines = 0
            
            notifView?.alpha = 0.95
            
            notifView?.addSubview(imageView)
            
            notifView?.addSubview(label)
            
            UIApplication.shared.keyWindow?.addSubview(notifView!)

            let tapToDismissNotif = UITapGestureRecognizer(target: self, action: #selector(notificationTapped))

            let swipeRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(dismissNotifFromScreen1))
            
            swipeRecogniser.direction = UISwipeGestureRecognizerDirection.right
            
            swipeRecogniser.direction = UISwipeGestureRecognizerDirection.left
            
            notifView?.addGestureRecognizer(tapToDismissNotif)
            
            notifView?.addGestureRecognizer(swipeRecogniser)

            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
                
                self.notifView?.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 60)
                
            }) { (bo) in
                
                
                
            }
            self.perform(#selector(dismissNotifFromScreen1), with: nil, afterDelay: 4.0)

        }
        else
        {
            //AppPreferences.sharedPreferences().showHudWith(title: "inacti", detailText: "")
            //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "app is in active ", withCancelText: "got")
            if application.applicationState == UIApplicationState.background
            {
//                if ismessageNotification == true
//                {
//                
//                }
//                else
//                {
//                    self.notificationTapped()
//                }

            }
            else
            {
               self.notificationTapped()
            }
            
        }
        
        
    }
    
    func notificationTapped()
    {
        
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
       // print(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.classForCoder)
        
       // print(investHR.NewJobsViewController.classForCoder())
        //loadAccount()
        if islinkedInNotification == true
        {
                    let safariVC = SFSafariViewController(url: NSURL(string: linkedInUrl!)! as URL)
            
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
                    DispatchQueue.main.async {
                            appDelegate.window?.rootViewController?.present(safariVC, animated: true, completion: nil)
                    }
                    //safariVC.delegate = self

        }
        else
        {
            if isMessageNotification == true
            {
                if let vc1 = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
                {
                    if vc1.classForCoder == PopUpMessageViewController.classForCoder()
                    {
                        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                       //print("presented = " + "\(vc1.classForCoder)")
                        
                    }
                    
                    
                }
                
                self.notifView?.frame = CGRect(x: 0, y: -70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 60)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "PopUpMessageViewController") as! PopUpMessageViewController
                
                //vc.verticalId = String(0)
                //vc.domainType = "horizontal"
                vc.messageString = self.messageString!
                vc.jobId = self.jobID
                vc.modalPresentationStyle = .overCurrentContext
                
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let currentRootVC = (appDelegate.window?.rootViewController)! as UIViewController
                
               // print(currentRootVC)
                
                let className = String(describing: type(of: currentRootVC))
                
                if className == "LoginViewController"
                {
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    
                    DispatchQueue.main.async {
                        appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                    }
                    
                }
                else
                {
                    
                }
                
                //UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                DispatchQueue.main.async {
                    appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                }
            }
            else
            if self.isMassNotification == true
            {
                if let vc1 = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
                {
                    if vc1.classForCoder == MassNotificationViewController.classForCoder()
                    {
                        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                        //print("presented = " + "\(vc1.classForCoder)")
                        
                    }
                    
                    
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "\(appDelegate.window?.rootViewController)", withCancelText: "got")
                
                self.notifView?.frame = CGRect(x: 0, y: -70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 60)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MassNotificationViewController") as! MassNotificationViewController
                
                vc.notificationId = self.massNotificationId
                
                //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "\(vc.jobId)" + "\(vc)", withCancelText: "got")
                //  UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                DispatchQueue.main.async {
                    appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                }
                
            }
            else
            {
                if let vc1 = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
                {
                    if vc1.classForCoder == NewJobsViewController.classForCoder()
                    {
                        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                        //print("presented = " + "\(vc1.classForCoder)")
                        
                    }
                    
                    
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "\(appDelegate.window?.rootViewController)", withCancelText: "got")
                
                self.notifView?.frame = CGRect(x: 0, y: -70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 60)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "NewJobsViewController") as! NewJobsViewController
                
                vc.verticalId = String(0)
                vc.domainType = "horizontal"
                vc.jobId = self.jobID
                
                //AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "\(vc.jobId)" + "\(vc)", withCancelText: "got")
                //  UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                DispatchQueue.main.async {
                    appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
                }
                
            }

        
        }
        //        }) { (bo) in
//            
//        }
        
    }
    
    func dismissNotifFromScreen1()
    {
       
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            
            self.notifView?.frame = CGRect(x: 0, y: -70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 60)
            
            
            
        }) { (bo) in
            
        }
        
    }
    func notificationSwiped()
    {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            
            self.notifView?.frame = CGRect(x: -(UIApplication.shared.keyWindow?.frame.size.width)!-10, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 60)
            
            
        }) { (bo) in
            
        }
        
    }
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        //print("APNs registration failed: \(error)")
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
//    {
    
        
//                return GIDSignIn.sharedInstance().handle(url,
//                                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
//                                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
//        let fb:Bool =  FBSDKApplicationDelegate.sharedInstance().application(app,
//        open: url,
//        sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
//        annotation: options [UIApplicationOpenURLOptionsKey.annotation]) == true
//        if fb == true
//        {
//            
//                return true
//
//        }
//        
//        else
//        {
//        let gg:Bool = GIDSignIn.sharedInstance().handle(url,
//                                                        sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
//                                                        annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    
//        if gg == true
//        {
//            
//                return true
//                
//        }
//        }
//            if LinkedinSwiftHelper.shouldHandle(url)
//            {
//                if LISDKCallbackHandler.shouldHandle(url) {
//                    return LISDKCallbackHandler.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options [UIApplicationOpenURLOptionsKey.annotation])
//                }
//        else
//                {
//                    if (url.host == "oauth-callback") {
//                        
//                        OAuthSwift.handle(url: url)
//                    }
                    
       // return Auth0.resumeAuth(url, options:options)
       // }

                
        //}
        
//        if([[FBSDKApplicationDelegate sharedInstance] application:application
//            openURL:url
//            sourceApplication:sourceApplication
//            annotation:annotation])
//        {
//            return YES;
//        }
//        let isFBOpenUrl = FBSDKApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//        let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//        if isFBOpenUrl { return true }
//        if isGoogleOpenUrl { return true }
//        return false    
    
  //  }

    
    func loadAccount()
    {
        
        if let username = UserDefaults.standard.value(forKey: Constant.USERNAME) as? String, let password = UserDefaults.standard.value(forKey: Constant.PASSWORD) as? String
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            
            appDelegate.window?.rootViewController = rootViewController
            //UIApplication.shared.keyWindow?.rootViewController = rootViewController
        }
        else
        {
            //let accessToken = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            let accessToken = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            // let accessTokenExpiresIn = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN_EXPIRES_IN) as? String
            
            if accessToken != nil
            {
                
                    //                let accessToken = LISDKAccessToken.init(serializedString: serializedToken)
                    
                    //                if (accessTokenExpiresIn)! > Date()
                    //                {
                    //                    LISDKSessionManager.createSession(with: accessToken)
                    
                    //performFetch()
                    //  fetchUserProfile(accessToken: accessToken)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    
                    appDelegate.window?.rootViewController = rootViewController
                //UIApplication.shared.keyWindow?.rootViewController = rootViewController


                    // }
                
                
            }

        }
        
        
            

    }

//    func fetchUserProfile(accessToken:String)
//    {
//        // Convert the received JSON data into a dictionary.
//        do {
//            
//            //                let dataDictionary = try JSONSerialization.jsonObject(with: responseData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
//            
//            print(accessToken )
//            
//            UserDefaults.standard.set(accessToken, forKey: Constant.LINKEDIN_ACCESS_TOKEN)
//            UserDefaults.standard.synchronize()
//            
//            
//            if let accessToken = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN)
//            {
//                // Specify the URL string that we'll get the profile info from.
//                let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url,id,first-name,last-name,maiden-name,headline,email-address,picture-urls::(original))?format=json"
//                
//                let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
//                
//                // Indicate that this is a GET request.
//                request.httpMethod = "GET"
//                
//                // Add the access token as an HTTP header field.
//                request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//                
//                let session = URLSession(configuration: URLSessionConfiguration.default)
//                
//                // Make the request.
//                let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
//                    
//                    let statusCode = (response as! HTTPURLResponse).statusCode
//                    
//                    if statusCode == 200
//                    {
//                        // Convert the received JSON data into a dictionary.
//                        do {
//                            let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
//                            
//                            let profileURLString = dataDictionary["publicProfileUrl"] as! String
//                            
//                            print(profileURLString)
//                            
//                            DispatchQueue.main.async
//                                {
//                                    
//                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                    
//                                    let currentRootVC = (appDelegate.window?.rootViewController)! as UIViewController
//                                    
//                                    print(currentRootVC)
//                                    
//                                    let className = String(describing: type(of: currentRootVC))
//                                    
//                                    if className == "LoginViewController"
//                                    {
//                                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                                        let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//                                        appDelegate.window?.rootViewController = rootViewController
//                                        
//                                    }
//                                    else
//                                    {
//                                        //self.dismiss(animated: true, completion: nil)
//                                        
//                                    }
//                                    
//                            }
//                            
//                        }
//                        catch {
//                            print("Could not convert JSON data into a dictionary.")
//                        }
//                    }
//                    else
//                    {
//                        do {
//                            let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
//                            
//                            let profileURLString = dataDictionary["publicProfileUrl"] as! String
//                            
//                            print(profileURLString)
//                        }
//                        catch {
//                            print("Could not convert JSON data into a dictionary.")
//                        }
//                    }
//                    
//                    
//                }
//                
//                task.resume()
//            }
//        }
//        catch {
//            print("Could not convert JSON data into a dictionary.")
//        }
//    }
//
//    func application(_ application: UIApplication,
//                     open url: URL,
//                     sourceApplication: String?,
//                     annotation: Any) -> Bool {
//        
//        // Linkedin sdk handle redirect
//        if LISDKCallbackHandler.shouldHandle(url)
//        {
//            return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication as String!, annotation:annotation)
//        }
//        
//        
//        
//        return false
//    }
//    func getManageObjectContext() -> NSManagedObjectContext
//    {
//        let manageObjectContext = self.persistentContainer.viewContext
//
//        return manageObjectContext
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer =
        {
                let container = NSPersistentContainer(name: "investHR")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.CoreDataDemo" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "investHR", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("investHR.sqlite")
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "info", ofType: "plist")
        print(path)
        // Load the existing database
        if !FileManager.default.fileExists(atPath: url.path) {
//            let sourceSqliteURLs = [Bundle.main.url(forResource: "investHR", withExtension: "sqlite")!, Bundle.main.url(forResource: "investHR", withExtension: "sqlite-wal")!, Bundle.main.url(forResource: "investHR", withExtension: "sqlite-shm")!]
//            let destSqliteURLs = [self.applicationDocumentsDirectory.appendingPathComponent("investHR.sqlite"), self.applicationDocumentsDirectory.appendingPathComponent("investHR.sqlite-wal"), self.applicationDocumentsDirectory.appendingPathComponent("investHR.sqlite-shm")]
            let sourceSqliteURLs = [Bundle.main.url(forResource: "investHR", withExtension: "sqlite")!]
            let destSqliteURLs = [self.applicationDocumentsDirectory.appendingPathComponent("investHR.sqlite")]
            
            for index in 0 ..< sourceSqliteURLs.count {
                do {
                    try FileManager.default.copyItem(at: sourceSqliteURLs[index], to: destSqliteURLs[index])
                } catch {
                    print(error)
                }
            }
        }
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            var dict = [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true, "journal_mode":"DELETE"] as [String : Any]
           // dict.setValue(true, forKey: NSMigratePersistentStoresAutomaticallyOption)
           // dict.setValue(true, forKey: NSInferMappingModelAutomaticallyOption)
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: dict)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
//
//    // MARK: - Core Data Saving support
//    
//    func saveContext () {
//        if managedObjectContext.hasChanges {
//            do {
//                try managedObjectContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                abort()
//            }
//        }
//    }
//
    
    func connectToFcm()
    {
        FIRMessaging.messaging()
    }
    
    
}

