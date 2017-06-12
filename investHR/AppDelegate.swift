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

import Auth0





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
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        var configureError: NSError?
        
        
        //GGLContext.sharedInstance().configureWithError(&configureError)
        
        FIRApp.configure()
        
        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
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
       // let obj = CoreDataManager.sharedManager
        self.loadAccount(then: { () in
            
            print("cancel pressed")
        }, or: nil)
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any])
    {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        
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
                    
        return Auth0.resumeAuth(url, options:options)
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
    
    }

    
    func loadAccount(then: (() -> Void)?, or: ((String) -> Void)?)
    {
        
        let serializedToken = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if let serializedToken = serializedToken
        {
            if serializedToken.characters.count > 0
            {
                let accessToken = LISDKAccessToken.init(serializedString: serializedToken)
                
                if (accessToken?.expiration)! > Date()
                {
                    LISDKSessionManager.createSession(with: accessToken)
                    
                    //performFetch()
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    
                    appDelegate.window?.rootViewController = rootViewController
                    
                    
                }
            }

        }
            

    }

    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        
        // Linkedin sdk handle redirect
        if LISDKCallbackHandler.shouldHandle(url)
        {
            return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication as String!, annotation:annotation)
        }
        
        
        
        return false
    }
    func getManageObjectContext() -> NSManagedObjectContext
    {
        let manageObjectContext = self.persistentContainer.viewContext

        return manageObjectContext
    }

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
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
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

    
    
    func connectToFcm()
    {
        FIRMessaging.messaging()
    }
    
    
}

