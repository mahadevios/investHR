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
        
        menuItemsArray = ["Profile","Notification","Saved Jobs","Applied Jobs","Search Job","Upload Resume","Upload Video","Refer a Friend","Setting","Log Out"]
        
        menuImageNamesArray = ["SideMenuProfile","SideMenuNoti","SideMenuSavedJob","SideMenuAppliedJob","SideMenuSearchJob","SideMenuUploadResume","SideMenuUploadVideo","SideMenuReferFriend","SideMenuSetting","SideMenuLogout"]
        // Do any additional setup after loading the view.
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
        
//        let urls = FileManager().urls(for: .documentDirectory, in: .userDomainMask)
//        
//        if let documentDirectory:NSURL = urls.first as NSURL?
//        {
//            let userImageUrl = documentDirectory.appendingPathComponent("DefaultUser.png")
//            
//            do
//            {
//                let imageData = try Data(contentsOf: userImageUrl! as URL)
//                
//                let userImage = UIImage(data: imageData)
//                
//                circleImageView.image = userImage
//
//            }
//            catch let error as NSError
//            {
//              print(error.localizedDescription)
//            }
//        }
        
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
            
            //self.navigationController?.pushViewController(vc, animated: true)
            
            //self.revealViewController().navigationController?.pushViewController(vc, animated: true)
            // let vc1 = self.revealViewController().rearViewController as! UINavigationController
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: true)
            
            self.revealViewController().pushFrontViewController(vc1, animated: true)
            
            
            
            break

            
            
            
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationJobsViewController") as! NotificationJobsViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: true)
            
            self.revealViewController().pushFrontViewController(vc1, animated: true)
            
            
            
            break

            
            
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SavedJobsViewController") as! SavedJobsViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: true)
            
            self.revealViewController().pushFrontViewController(vc1, animated: true)
            
            
            
            break
            
            
            
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppliedJobsViewController") as! AppliedJobsViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: true)
            
            self.revealViewController().pushFrontViewController(vc1, animated: true)
            
            
            
            break
            
            
            
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadResumeViewController") as! UploadResumeViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: true)
            
            self.revealViewController().pushFrontViewController(vc1, animated: true)
            
            
            
            break
            
        case 6:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadVideoViewController") as! UploadVideoViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: true)
            
            self.revealViewController().pushFrontViewController(vc1, animated: true)
            
            
            
            break
            
        case 7:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReferFriendViewController") as! ReferFriendViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: true)
            
            self.revealViewController().pushFrontViewController(vc1, animated: true)
            
            
            
            break
        case 8:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            
            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            vc1.pushViewController(vc, animated: true)
            
            self.revealViewController().pushFrontViewController(vc1, animated: true)
            
            
            
            break
            
        case 9:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            
            //let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardNavigation") as! UINavigationController
            
            //vc1.pushViewController(vc, animated: true)
            
            //self.revealViewController().pushFrontViewController(vc, animated: true)
            LISDKSessionManager.clearSession()
            
            UserDefaults.standard.setValue(nil, forKey: Constant.LINKEDIN_ACCESS_TOKEN)
            
            self.revealViewController().revealToggle(animated: true)
            
            self.present(vc, animated: true, completion: nil)
            
            
            
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
        let coreDataManager = CoreDataManager.sharedManager
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.fetch(entity: "User")
            for userObject in managedObjects as! [User]
            {
                let firstName = userObject.firstName
                let lastName = userObject.lastName
                let pictureUrlString = userObject.pictureUrl
                
                if let firstName = firstName
                {
                    userNameLabel.text = firstName
                }
                if let pictureUrlString = pictureUrlString
                {
                    let pictureUrl = URL(string: pictureUrlString)
                    
                    if let pictureUrl = pictureUrl
                    {
                        do
                        {
                            let imageData = try Data(contentsOf: pictureUrl as URL)
                    
                            let userImage = UIImage(data: imageData)
                    
                            circleImageView.image = userImage
                    
                        }
                        catch let error as NSError
                        {
                            print(error.localizedDescription)
                        }
                    }
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
