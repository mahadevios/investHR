//
//  ChangePasswordViewController.swift
//  investHR
//
//  Created by mac on 21/07/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController
{
    @IBOutlet weak var oldPasswordTextField: UITextField!

    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        oldPasswordTextField.layer.borderColor = UIColor.init(red: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        newPasswordTextField.layer.borderColor = UIColor.init(red: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        confirmNewPasswordTextField.layer.borderColor = UIColor.init(red: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkResetPasswordResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_RESET_PASSWORD), object: nil)
        // popupView.layer.borderColor = UIColor.gray.cgColor
        // popupView.layer.borderWidth = 1.0
        // popupView.layer.cornerRadius = 3.0
        //        let tapToDismissNotif = UITapGestureRecognizer(target: self, action: #selector(tapped))
        //
        //        self.view.addGestureRecognizer(tapToDismissNotif)
        //
        //        tapToDismissNotif.delegate = self
        // Do any additional setup after loading the view.
    }

    @objc func checkResetPasswordResponse(dataDic:Notification)
    {
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

                guard let responseDic = dataDic.object as? [String:String] else
                {
                    return
                }
        
                //print(responseDic)
                guard let code = responseDic["code"] else {
        
                    return
                }
        
        //let newPassword = responseDic["updatedPassword"]
        
        //UserDefaults.standard.set(newPassword!, forKey: Constant.PASSWORD)
        
        //self.revealViewController().revealToggle(animated: true)
        
        //self.navigationController?.popViewController(animated: true)
        let username = UserDefaults.standard.value(forKey: Constant.USERNAME)
        
        let password = UserDefaults.standard.value(forKey: Constant.PASSWORD)

        self.dismiss(animated: true, completion: nil)
        
        let sw = self.presentingViewController! as! SWRevealViewController
        
        let na = sw.frontViewController as! UINavigationController
        
        na.popViewController(animated: true)
        
        sw.revealToggle(animated: false)


        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        
        //print(self.presentingViewController!.navigationController?.popToViewController(HomeViewController, animated: true))



        //self.presentingViewController?.revealToggle(animated: true)
        
        if AppPreferences.sharedPreferences().isReachable == true
        {
            AppPreferences.sharedPreferences().logoutFromPasswordReset = true
            APIManager.getSharedAPIManager().logout(username: username as! String, password: password as! String, linkedinId: "")

        }

        
//        let alert = UIAlertController(title: "Password Reset", message: "Password reset successfully, please login with new password", preferredStyle: .alert)
//        
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
//            
//            self.dismiss(animated: true, completion: nil)
//        }
//        
//        alert.addAction(okAction)
//        
//        alert.present(self, animated: true, completion: nil)
        
        //AppPreferences.sharedPreferences().showAlertViewWith(title: "Password Reset", withMessage: "Password reset successfully, please login with new password", withCancelText: "Ok")
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButtonPressed(_ sender: Any)
    {
        
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String

        if oldPasswordTextField?.text == "" || newPasswordTextField?.text == "" || confirmNewPasswordTextField?.text == ""
                        {
                            AppPreferences.sharedPreferences().showAlertViewWith(title: "Empty Field(s)", withMessage: "Please fill up the empty field(s)", withCancelText: "Ok")                        }
                        else
                            if oldPasswordTextField?.text != password
                            {
                                AppPreferences.sharedPreferences().showAlertViewWith(title: "Incorrect Password", withMessage: "Current password entered is incorrect", withCancelText: "Ok")
                            }
                            else
                                if newPasswordTextField?.text != confirmNewPasswordTextField?.text
                                {
                                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Confirm Password Failed" , withMessage: "Please confirm password", withCancelText: "Ok")
                                }
                                else
                                {
                                    APIManager.getSharedAPIManager().resetPassword(username: username!, password: password!, newPassword: (newPasswordTextField?.text!)!)
                                }

    }
    @IBAction func cancelButtonPressed(_ sender: Any)
    {
        self.presentingViewController?.navigationController?.navigationBar.alpha = 1.0
        self.presentingViewController?.view.alpha = 1.0
        self.dismiss(animated: true, completion: nil)
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
