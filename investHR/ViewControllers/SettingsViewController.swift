//
//  SettingsViewController.swift
//  investHR
//
//  Created by mac on 30/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    var settingsItemsArray:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemImageNamesArray = ["DeleteAccount","ResetPassword"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
//        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
//        
//        if username != nil && password != nil
//        {
//            settingsItemsArray = ["Delete Account","Reset Password","Help/Support(Email ID)"]
//        }
//        else
//        if linkedInId != nil
//        {
            settingsItemsArray = ["Delete Account","Reset Password"]
            
      //  }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Settings"
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDeleteAccountResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_DELETE_ACCOUNT), object: nil)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.view.alpha = 1.0
        
        self.navigationController?.navigationBar.alpha = 1.0
        
        self.tableView.reloadData()
    }
    func popViewController() -> Void
    {
        self.revealViewController().revealToggle(animated: true)

        self.navigationController?.popViewController(animated: true)
    }
    func checkDeleteAccountResponse(dataDic:Notification)
    {
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
        
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
//        print(responseDic)
        guard let code = responseDic["code"] else {
            
            return
        }
        
        //let newPassword = responseDic["updatedPassword"]
        
        //UserDefaults.standard.set(newPassword!, forKey: Constant.PASSWORD)
        
        //self.revealViewController().revealToggle(animated: true)
        
        //self.navigationController?.popViewController(animated: true)
        let username = UserDefaults.standard.value(forKey: Constant.USERNAME)
        
        let password = UserDefaults.standard.value(forKey: Constant.PASSWORD)
        
        //self.dismiss(animated: true, completion: nil)
        
        //let sw = self.presentingViewController! as! SWRevealViewController
        
        //let na = sw.frontViewController as! UINavigationController
        
//        let alert = UIAlertController(title: "Account Delete", message: "Account deleted successfully", preferredStyle: .alert)
//        
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
//            
//            self.dismiss(animated: true, completion: nil)
//            
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            
//            appDelegate.window?.makeKeyAndVisible()
//            
//            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
//            
//        }
//        
//        alert.addAction(okAction)
//        
//        self.present(alert, animated: true)
        
        AppPreferences.sharedPreferences().showAlertViewWith(title: "Account Delete", withMessage: "Account deleted successfully", withCancelText: "Ok")
        
        if AppPreferences.sharedPreferences().isReachable == true
        {
            UserDefaults.standard.set(nil, forKey: Constant.LAST_LOGGEDIN_USER_NAME)
            APIManager.getSharedAPIManager().logout(username: username as! String, password: password as! String, linkedinId: "")
            
        }
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
       // AppPreferences.sharedPreferences().showAlertViewWith(title: "Account Delete", withMessage: "Account deleted successfully", withCancelText: "Ok")
        
        
        
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        
        //print(self.presentingViewController!.navigationController?.popToViewController(HomeViewController, animated: true))
        
        
        
        //self.presentingViewController?.revealToggle(animated: true)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return settingsItemsArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        let settingItemLabel = cell.viewWithTag(200) as! UILabel
        
        let itemImageView = cell.viewWithTag(201) as! UIImageView
        
        
        itemImageView.image = UIImage(named: itemImageNamesArray[indexPath.row])
        
        settingItemLabel.text = settingsItemsArray[indexPath.row]
        
//        if let notiSwitch = cell.viewWithTag(201)
//        {
//            notiSwitch.removeFromSuperview()
//        }
//        if indexPath.row == 0
//        {
//            let notificationSwitch = UISwitch(frame: CGRect(x: cell.frame.size.width-100, y: settingItemLabel.frame.origin.y-5, width: 25, height: settingItemLabel.frame.size.height))
//            
//            notificationSwitch.addTarget(self, action: #selector(switchValueChanged), for: UIControlEvents.valueChanged)
//
//            notificationSwitch.tag = 200
//            
//            cell.addSubview(notificationSwitch)
//        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        let settingItemLabel = cell?.viewWithTag(200) as! UILabel

        if settingItemLabel.text! == "Reset Password"
        {
//            let titlePrompt = UIAlertController(title: "Forgot password?",
//                                                message: "Enter the email you registered with:",
//                                                preferredStyle: .alert)
//            
//            var oldPasswordTextField: UITextField?
//            var newPasswordTextField: UITextField?
//            var confirmNewPasswordTextField: UITextField?
//            
//            titlePrompt.addTextField { (textField) -> Void in
//                oldPasswordTextField = textField
//                textField.placeholder = "Old Password"
//            }
//            
//            
//            titlePrompt.addTextField { (textField) -> Void in
//                newPasswordTextField = textField
//                textField.placeholder = "New Password"
//            }
//            titlePrompt.addTextField { (textField) -> Void in
//                confirmNewPasswordTextField = textField
//                textField.placeholder = "Confirm New Password"
//            }
//            
//            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//            
//            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//            
//            titlePrompt.addAction(cancelAction)
//            
//            titlePrompt.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
//                if oldPasswordTextField?.text == "" || newPasswordTextField?.text == "" || confirmNewPasswordTextField?.text == ""
//                {
//                    // please fill up all the fields
//                }
//                else
//                    if oldPasswordTextField?.text != password
//                    {
//                        // wrong password
//                    }
//                    else
//                        if newPasswordTextField?.text != confirmNewPasswordTextField?.text
//                        {
//                            // please confirm password
//                        }
//                
//                
//            }))
//            
//            self.present(titlePrompt, animated: true, completion: nil)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
//            vc.view.frame = CGRect(x: vc.view.frame.width*0.2, y: vc.view.frame.height*0.2, width: vc.view.frame.width*0.6, height: vc.view.frame.height*0.6)
//            vc.view.frame = CGRect(x: vc.view.frame.width*0.2, y: vc.view.frame.height*0.2, width: vc.view.frame.width*0.6, height: vc.view.frame.height*0.6)

            //self.view.alpha = 0.8
  
            //self.navigationController?.navigationBar.alpha = 0.8
            //vc.modalPresentationStyle = .overCurrentContext
            
            //vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else
            if settingItemLabel.text! == "Delete Account"
            {
                let alertController = UIAlertController(title: "Delete Account?", message: "Are you sure to delete this account", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    
                    let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
 
                    let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String

                    alertController.dismiss(animated: true, completion: nil)

                    APIManager.getSharedAPIManager().deleteAccount(username: username!, password: password!)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                })
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                
        
            }
        
        
                
    }

    func switchValueChanged(sender: UISwitch)
    {
        if sender.isOn
        {
            
        }
        else
        {
        
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
