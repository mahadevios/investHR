//
//  AppPreferences.swift
//  investHR
//
//  Created by mac on 01/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class AppPreferences: NSObject,UIAlertViewDelegate
{
    
    private static let appPreferences = AppPreferences()
    
    var isReachable:Bool
    
    var gotMessages:Bool

    var firebaseInstanceId:String
    
    var customMessagesArray:[Any]
    
    var popUpShown:Bool
    
    var logoutFromPasswordReset:Bool

    var reach = Reachability(hostname: "www.google.com")
    
    private override init()
    {
        isReachable = false
        
        gotMessages = false
        
        popUpShown = false
        
        logoutFromPasswordReset = false
        
        firebaseInstanceId = ""
        
        customMessagesArray = [Any]()
        
        reach = Reachability(hostname: "www.google.com")
        
        super.init()
    }
    
    class func sharedPreferences() -> AppPreferences
    {
        return appPreferences;
    }
   
    
    func showAlertViewWith( title:String, withMessage message:String, withCancelText okText:String) -> Void
    {
        
        let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: okText)
        
        alertView.show()
        
    }
    
    func startReachabilityNotifier()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: nil)
        
        reach = Reachability(hostname: "www.google.com")

        do
        {
            try  reach?.startNotifier()
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    
        
    }
    
    func reachabilityChanged(_ note:Notification) -> Void
    {
        reach = note.object as? Reachability
        
        if (reach?.currentReachabilityStatus == .reachableViaWiFi) || (reach?.currentReachabilityStatus == .reachableViaWWAN)
        {
            self.isReachable = true
        }
        else
        {
            self.isReachable = false
        }
    }
//    func reachabilityChanged(_ note: NSNotification) {
//        //
//    }
    func showHudWith(title:String, detailText:String) -> Void
    {
        //let hud = MBProgressHUD.init(window: UIApplication.shared.keyWindow!)
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        //UIApplication.shared.keyWindow?.addSubview(hud)
        hud.tag = 789
        
        hud.minSize = CGSize(width: 150.0, height: 100.0)
        
        hud.label.text = title
        
        hud.detailsLabel.text = detailText
        
        //print("keywindow = " + "\(UIApplication.shared.keyWindow)")
    }
    
    func hideHudWithTag(tag:Int)
    {
       // print("keywindow = " + "\(UIApplication.shared.keyWindow)")

        UIApplication.shared.keyWindow?.viewWithTag(tag)?.removeFromSuperview()

    }

}
