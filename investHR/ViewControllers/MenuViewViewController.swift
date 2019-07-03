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
        
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if linkedInId != nil
        {
            menuItemsArray.removeAll()
            
            menuItemsArray = ["Profile","Notification","Saved Jobs","Applied Jobs","Upload Resume","Upload Video","Refer A Friend","Contact Us","Log Out"]
            
            menuImageNamesArray = ["SideMenuProfile","SideMenuNoti","SideMenuSavedJob","SideMenuAppliedJob","SideMenuUploadResume","SideMenuUploadVideo","SideMenuReferFriend","SideMenuContactUs","SideMenuLogout"]
        }
        else
        {
            menuItemsArray = ["Profile","Notification","Saved Jobs","Applied Jobs","Upload Resume","Upload Video","Refer A Friend","Contact Us","Settings","Log Out"]
            
            menuImageNamesArray = ["SideMenuProfile","SideMenuNoti","SideMenuSavedJob","SideMenuAppliedJob","SideMenuUploadResume","SideMenuUploadVideo","SideMenuReferFriend","SideMenuContactUs","SideMenuSetting","SideMenuLogout"]
        }

        
        NotificationCenter.default.addObserver(self, selector: #selector(upadateUserData), name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loggedOut), name: NSNotification.Name(Constant.NOTIFICATION_LOGOUT), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newNotiAdded), name: NSNotification.Name(Constant.NOTIFICATION_NOTI_DATA_ADDED), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func upadateUserData()
    {
       showData()
    }
    
    @objc func newNotiAdded()
    {
        self.menuTableView.reloadData()
    }
    @objc func loggedOut(dataDic:Notification)
    {
        DispatchQueue.main.async
            {
                AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

       // LISDKSessionManager.clearSession()
        
        let cookieStorage =  HTTPCookieStorage.shared
        for cookie in cookieStorage.cookies! {
            cookieStorage.deleteCookie(cookie)
        }
        
        if UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN) != nil
        {
            UserDefaults.standard.setValue(nil, forKey: Constant.LAST_LOGGEDIN_USER_NAME)

        }
        UserDefaults.standard.setValue(nil, forKey: Constant.LINKEDIN_ACCESS_TOKEN)
        UserDefaults.standard.setValue(nil, forKey: Constant.USERNAME)
        UserDefaults.standard.setValue(nil, forKey: Constant.PASSWORD)
        UserDefaults.standard.setValue(nil, forKey: Constant.USERID)

        AppPreferences.sharedPreferences().customMessagesArray.removeAll()
        AppPreferences.sharedPreferences().gotMessages = false
        self.revealViewController().revealToggle(animated: true)
        AppPreferences.sharedPreferences().popUpShown = false

        
        //CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
        let database = Database.sharedDatabse()
        

        database.truncateTable(tableName: "ZSAVEDJOBS")
        database.truncateTable(tableName: "ZAPPLIEDJOBS")

        //CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "SavedJobs")
        //CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "AppliedJobs")
        
        if AppPreferences.sharedPreferences().logoutFromPasswordReset == true
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "Password Reset", withMessage: "Password reset successfully, please login with new password", withCancelText: "Ok")
            
            AppPreferences.sharedPreferences().logoutFromPasswordReset = false
        }
        self.present(vc, animated: true, completion: nil)
    
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_DISMISS_SUGGESTION_POPUP), object: nil, userInfo: nil)

        self.menuTableView.reloadData()
        
       

    }
    override func viewWillDisappear(_ animated: Bool)
    {
        //NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_HOME_BUTTONS_ENABLED), object: nil, userInfo: nil)
        self.setUserInteractionEnabled(setEnable: true)


    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.setUserInteractionEnabled(setEnable: false)

    }
    
    func getUnreadNotificationCount() -> Int
    {
        let specialNotiCount = Database.sharedDatabse().getUnreadNotiCount(tableName: "SpecialNotification")

        let commonNotiCount = Database.sharedDatabse().getUnreadNotiCount(tableName: "CommonNotification")

//        let commonNotiCount = CoreDataManager.getSharedCoreDataManager().getUnreadNotiCount(entity: "CommonNotification")
//        
//        let specialNotiCount = CoreDataManager.getSharedCoreDataManager().getUnreadNotiCount(entity: "ZSpecialNotification")
        
        //print("count =  \(commonNotiCount+specialNotiCount)")
        
        return commonNotiCount+specialNotiCount
    
    }
    func setUserInteractionEnabled(setEnable:Bool)
    {
        let button1 = self.revealViewController().frontViewController.view.viewWithTag(501) as? UIButton
        button1?.isEnabled = setEnable
        
        let button2 = self.revealViewController().frontViewController.view.viewWithTag(502) as? UIButton
        button2?.isEnabled = setEnable
        
        let button3 = self.revealViewController().frontViewController.view.viewWithTag(503) as? UIButton
        button3?.isEnabled = setEnable

        let button4 = self.revealViewController().frontViewController.view.viewWithTag(504) as? UIButton
        button4?.isEnabled = setEnable

    }
    
    @objc func addView() -> Void
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
        let cell:UITableViewCell = (self.menuTableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        // set the text from the data model
        
        let menuImageView = cell.viewWithTag(101) as! UIImageView
            menuImageView.image = UIImage(named: menuImageNamesArray[indexPath.row])
        
        let menuNameLabel = cell.viewWithTag(102) as! UILabel
            menuNameLabel.text = menuItemsArray[indexPath.row]
        
        if let bgView = cell.viewWithTag(203)
        {
            cell.viewWithTag(203)?.removeFromSuperview()
        }
        
        if menuItemsArray[indexPath.row] == "Notification"
        {
            if let bgView = cell.viewWithTag(203)
            {
                let notiCountLabel = bgView.viewWithTag(204) as! UILabel
                
                let notiCount = self.getUnreadNotificationCount()

                if notiCount < 1
                {
                    bgView.isHidden = true
                }
                else
                {
                    bgView.isHidden = false
                    
                    notiCountLabel.text = "\(self.getUnreadNotificationCount())"

                }

            }
            else
            {
                let countBGView = UIView(frame: CGRect(x: cell.frame.size.width-41, y: cell.frame.size.height/2 - 12, width: 35, height: 24))
                
                countBGView.layer.cornerRadius = 4.0
                
                countBGView.backgroundColor = UIColor.appOrangeColor()
                
                countBGView.tag = 203
                
//                let notiCountLabel = UILabel(frame: CGRect(x: countBGView.frame.size.width-15, y: countBGView.frame.size.height/2 - 7, width: 15, height: 15))
                let notiCountLabel = UILabel(frame: CGRect(x: 2.5, y: 2, width: 30, height: 20))

                notiCountLabel.tag = 204

                notiCountLabel.font = UIFont.systemFont(ofSize: 12)
                //notiCountLabel.center = countBGView.center
                
                notiCountLabel.textAlignment = NSTextAlignment.center
                
                let notiCount = self.getUnreadNotificationCount()
                
                if notiCount < 1
                {
                  countBGView.isHidden = true
                }
                else
                {
                    countBGView.isHidden = false

                    notiCountLabel.text = "\(notiCount)"
                    
                    notiCountLabel.textColor = UIColor.white
                    
                    countBGView.addSubview(notiCountLabel)
                    
                    cell.addSubview(countBGView)
                }
               

            }
          
            
            
            
        }
//        else
//        {
//            if let bgView = cell.viewWithTag(203)
//            {
//                bgView.removeFromSuperview()
//            }
//        }
        
        
        
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: false)
            
            self.revealViewController().pushFrontViewController(vc1, animated: false)
            
            self.revealViewController().revealToggle(animated: true)
            
            break
            

        case 8:
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String

            if linkedInId != nil
            {
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
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                
                
                let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
                
                vc1.pushViewController(vc, animated: false)
                
                self.revealViewController().pushFrontViewController(vc1, animated: false)
                
                self.revealViewController().revealToggle(animated: true)
            }
            
            
            break
            
            
        case 9:
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
//        print("You tapped cell number \(indexPath.row).")
    }
    
    func showData() -> Void
    {
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if linkedInId != nil
        {
            menuItemsArray.removeAll()
            
            menuItemsArray = ["Profile","Notification","Saved Jobs","Applied Jobs","Upload Resume","Upload Video","Refer A Friend","Contact Us","Log Out"]
            
            menuImageNamesArray = ["SideMenuProfile","SideMenuNoti","SideMenuSavedJob","SideMenuAppliedJob","SideMenuUploadResume","SideMenuUploadVideo","SideMenuReferFriend","SideMenuContactUs","SideMenuLogout"]
        }
        else
        {
            menuItemsArray.removeAll()
            
            menuItemsArray = ["Profile","Notification","Saved Jobs","Applied Jobs","Upload Resume","Upload Video","Refer a Friend","Contact Us","Settings","Log Out"]
            
            menuImageNamesArray = ["SideMenuProfile","SideMenuNoti","SideMenuSavedJob","SideMenuAppliedJob","SideMenuUploadResume","SideMenuUploadVideo","SideMenuReferFriend","SideMenuContactUs","SideMenuSetting","SideMenuLogout"]
        }
        
        self.menuTableView.reloadData()
        
        let database = Database.sharedDatabse()
        
        let userObject = database.getUserData() as User1
        
        //let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            //var managedObjects:[NSManagedObject]?
            
           // managedObjects = coreDataManager.getAllRecords(entity: "User")
//            for userObject1 in (managedObjects as? [User])!
//            {
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
//                    print("This is run on the background queue")
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
//                                    print(error.localizedDescription)
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
                
                
    
            //}
            
        } catch let error as NSError
        {
//            print(error.localizedDescription)
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
