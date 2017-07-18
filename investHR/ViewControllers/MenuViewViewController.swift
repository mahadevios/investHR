//
//  MenuViewViewController.swift
//  investHR
//
//  Created by mac on 25/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

import CoreData

class MenuViewViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var outSideCircleView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    var menuItemsArray:[String] = []
    var menuImageNamesArray:[String] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //self.addView()
        
        self.perform(#selector(addView), with: nil, afterDelay: 0.2)
        
        menuItemsArray = ["Profile","Notification","Saved Jobs","Applied Jobs","Upload Resume","Upload Video","Refer a Friend","Settings","Log Out"]
        
        menuImageNamesArray = ["SideMenuProfile","SideMenuNoti","SideMenuSavedJob","SideMenuAppliedJob","SideMenuUploadResume","SideMenuUploadVideo","SideMenuReferFriend","SideMenuSetting","SideMenuLogout"]
        
        NotificationCenter.default.addObserver(self, selector: #selector(upadateUserData), name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loggedOut), name: NSNotification.Name(Constant.NOTIFICATION_LOGOUT), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func upadateUserData()
    {
       showData()
    }
    
    func loggedOut(dataDic:Notification)
    {
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

       // LISDKSessionManager.clearSession()
        
        let cookieStorage =  HTTPCookieStorage.shared
        for cookie in cookieStorage.cookies! {
            cookieStorage.deleteCookie(cookie)
        }
        
        UserDefaults.standard.setValue(nil, forKey: Constant.LINKEDIN_ACCESS_TOKEN)
        UserDefaults.standard.setValue(nil, forKey: Constant.USERNAME)
        UserDefaults.standard.setValue(nil, forKey: Constant.PASSWORD)
        AppPreferences.sharedPreferences().customMessagesArray.removeAll()
        AppPreferences.sharedPreferences().gotMessages = false
        self.revealViewController().revealToggle(animated: true)
        
        
        //CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
        CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "SavedJobs")
        CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "AppliedJobs")
        
        self.present(vc, animated: true, completion: nil)
    
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        self.menuTableView.reloadData()
        
    }
    func addView() -> Void
    {
        outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0
        
        circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0
        
        outSideCircleView.clipsToBounds = true;
        
        outSideCircleView.image = UIImage(named:"OutsideCircle")
        
        circleImageView.clipsToBounds = true;
        
        circleImageView.image = UIImage(named:"InsideDefaultCircle")
                
        showData()
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItemsArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.menuTableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        // set the text from the data model
        
        let menuImageView = cell.viewWithTag(101) as! UIImageView
            menuImageView.image = UIImage(named: menuImageNamesArray[indexPath.row])
        
        let menuNameLabel = cell.viewWithTag(102) as! UILabel
            menuNameLabel.text = menuItemsArray[indexPath.row]
        
        
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
          
            vc1.pushViewController(vc, animated: false)

            self.revealViewController().pushFrontViewController(vc1, animated: false)
            
            //self.revealViewController().frontViewController.navigationController?.pushViewController(vc, animated: false)
            self.revealViewController().revealToggle(animated: true)
            
            //self.revealViewController().setFront((self.storyboard?.instantiateViewController(withIdentifier: "temp"))!, animated: true)
            
            break

            
            
            
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationJobsViewController") as! NotificationJobsViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: false)
            
            self.revealViewController().pushFrontViewController(vc1, animated: false)

            self.revealViewController().revealToggle(animated: true)
            //self.revealViewController().setFront(vc1, animated: true)
            
            
            break

            
            
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SavedJobsViewController") as! SavedJobsViewController
            
            //APIManager.getSharedAPIManager().
//            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
//            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
//            
//            if username != nil && password != nil
//            {
//                APIManager.getSharedAPIManager().getSavedJobs(username: username!, password: password!,linkedinId:"")
//            }
//            else
//                if linkedInId != nil
//                {
//                    APIManager.getSharedAPIManager().getSavedJobs(username: "", password: "",linkedinId:linkedInId!)
//                    
//                }
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: false)
            
            self.revealViewController().pushFrontViewController(vc1, animated: false)
            
            self.revealViewController().revealToggle(animated: true)
            
            
            break
            
            
            
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppliedJobsViewController") as! AppliedJobsViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
//            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
//            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
//            
//            if username != nil && password != nil
//            {
//                APIManager.getSharedAPIManager().getAppliedJobs(username: username!, password: password!,linkedinId:"")
//            }
//            else
//                if linkedInId != nil
//                {
//                    APIManager.getSharedAPIManager().getAppliedJobs(username:"", password:"",linkedinId:linkedInId!)
//                    
//                }
            vc1.pushViewController(vc, animated: false)
            
            self.revealViewController().pushFrontViewController(vc1, animated: false)
            
            self.revealViewController().revealToggle(animated: true)
            
            break
            
            
            
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadResumeViewController") as! UploadResumeViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: false)
            
            self.revealViewController().pushFrontViewController(vc1, animated: false)
            
            self.revealViewController().revealToggle(animated: true)
            
            
            break
            
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadVideoViewController") as! UploadVideoViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: false)
            
            self.revealViewController().pushFrontViewController(vc1, animated: false)
            
            self.revealViewController().revealToggle(animated: true)
            
            break
            
        case 6:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReferFriendViewController") as! ReferFriendViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: false)
            
            self.revealViewController().pushFrontViewController(vc1, animated: false)
            
            self.revealViewController().revealToggle(animated: true)
            
            break
        case 7:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: false)
            
            self.revealViewController().pushFrontViewController(vc1, animated: false)
            
            self.revealViewController().revealToggle(animated: true)
            
            break
            
        case 8:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            
            //let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            //vc1.pushViewController(vc, animated: true)
            
            //self.revealViewController().pushFrontViewController(vc, animated: true)
            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            
            if username != nil && password != nil
            {
                APIManager.getSharedAPIManager().logout(username: username!, password: password!,linkedinId:"")
            }
            else
                if linkedInId != nil
                {
                    APIManager.getSharedAPIManager().logout(username:"", password:"",linkedinId:linkedInId!)
                    
            }
//            LISDKSessionManager.clearSession()
//            
//            let cookieStorage =  HTTPCookieStorage.shared
//            for cookie in cookieStorage.cookies! {
//                cookieStorage.deleteCookie(cookie)
//            }
//            
//            UserDefaults.standard.setValue(nil, forKey: Constant.LINKEDIN_ACCESS_TOKEN)
//            UserDefaults.standard.setValue(nil, forKey: Constant.USERNAME)
//            UserDefaults.standard.setValue(nil, forKey: Constant.PASSWORD)
//            AppPreferences.sharedPreferences().customMessagesArray.removeAll()
//            AppPreferences.sharedPreferences().gotMessages = false
//            self.revealViewController().revealToggle(animated: true)
//            
//            
//            //CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
//            CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "SavedJobs")
//            CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "AppliedJobs")
//
//            self.present(vc, animated: true, completion: nil)
            
            
            
            break
//        case 1:
//               let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsViewController") as! JobsViewController
//               
//               
//               let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
//               
//              vc1.pushViewController(vc, animated: true)
//               
//               self.revealViewController().pushFrontViewController(vc1, animated: true)
//               
//               
//               
//                break
            
            
        default:break
            
            
        }
        print("You tapped cell number \(indexPath.row).")
    }
    
    func showData() -> Void
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.getAllRecords(entity: "User")
            for userObject in (managedObjects as? [User])!
            {
                let firstName = userObject.name
                //let pictureUrlString1 = Constant.USER_PROFILE_IMAGE_PATH + userObject.pictureUrl
                
                
                let pictureUrlString = userObject.pictureUrl

                
               // print(pictureUrlString!)
                if let firstName = firstName
                {
                    userNameLabel.text = firstName
                }
                
                DispatchQueue.global(qos: .background).async
                    {
                    print("This is run on the background queue")
                        if let pictureUrlString = pictureUrlString
                        {
                            let pictureUrl = URL(string: Constant.USER_PROFILE_IMAGE_PATH + pictureUrlString)
                            
                            
                            
                            
                            //
                                do
                                {
                                    
                                    let imageData = try Data(contentsOf: pictureUrl! as URL)
                                    
                                    let userImage = UIImage(data: imageData)
                                    
                                    DispatchQueue.main.async
                                        {
                                            self.circleImageView.image = userImage
                                        }
                                    
                                }
                                catch let error as NSError
                                {
                                    DispatchQueue.main.async
                                        {
                                            self.circleImageView.image = UIImage(named:"InsideDefaultCircle")
                                    }
                                    print(error.localizedDescription)
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async
                                    {
                                        self.circleImageView.image = UIImage(named:"InsideDefaultCircle")
                                    }
                                
                            }
                        //}
                    }
                
                
    
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
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
