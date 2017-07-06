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
    
    private override init()
    {
        isReachable = false
        
        gotMessages = false
        
        firebaseInstanceId = ""
        
        customMessagesArray = [Any]()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: ReachabilityChangedNotification, object: nil)
        
        let reach = Reachability(hostname: "www.google.com")

        do
        {
            try  reach?.startNotifier()
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    
        
    }
    
    func reachabilityChanged( note:Notification) -> Void
    {
        let reach = note.object as! Reachability
        
        if (reach.currentReachabilityStatus == .reachableViaWiFi) || (reach.currentReachabilityStatus == .reachableViaWWAN)
        {
            self.isReachable = true
        }
        else
        {
            self.isReachable = false
        }
    }
    
    func showHudWith(title:String, detailText:String) -> Void
    {
        //let hud = MBProgressHUD.init(window: UIApplication.shared.keyWindow!)
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        //UIApplication.shared.keyWindow?.addSubview(hud)
        hud.tag = 789
        
        hud.minSize = CGSize(width: 150.0, height: 100.0)
        
        hud.label.text = title
        
        hud.detailsLabel.text = detailText
    }
    
    func hideHudWithTag(tag:Int)
    {
        UIApplication.shared.keyWindow?.viewWithTag(tag)?.removeFromSuperview()

    }

}
