//
//  HomeViewController.swift
//  investHR
//
//  Created by mac on 17/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import FirebaseAuth

import FBSDKLoginKit

import Firebase

import FirebaseAnalytics

import LinkedinSwift

import IOSLinkedInAPIFix

class HomeViewController: UIViewController
{
    
    @IBOutlet weak var sliderButton: UIButton!

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
    @IBAction func notificationButtonClicked(_ sender: Any) {
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

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
        GIDSignIn.sharedInstance().signOut()
        
        try! FIRAuth.auth()!.signOut()
        
        let loginManager = FBSDKLoginManager()
        
        FBSDKLoginManager().logOut()
        
        loginManager.logOut() // this is an instance function
        
        UserDefaults.standard.removeObject(forKey: "fbAccessToken")
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }

        //self.dismiss(animated: true, completion: nil)
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
