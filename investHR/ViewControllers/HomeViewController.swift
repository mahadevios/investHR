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


//import LinkedinSwift

//import IOSLinkedInAPIFix

class HomeViewController: UIViewController
{
    
    @IBOutlet weak var sliderButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        definesPresentationContext = true
        

        
        let alert2 = MyAlert.showAlert(ofType: MyAlertType.invalidLogin, handler: { (UIAlertAction) in
            
            print("cancel pressed")
        }) { (UIAlertAction) in
            print("ok pressed")

        }
        //self.present(alert2, animated: true, completion: nil)
        
        
        
        
//        AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Invalid login", withCancelText: "Ok")

   
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if AppPreferences.sharedPreferences().isReachable
        {
            print("reachable")
        }
       
    uploadFtp()
    }

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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
