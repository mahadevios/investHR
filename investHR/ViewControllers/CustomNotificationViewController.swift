//
//  CustomNotificationViewController.swift
//  investHR
//
//  Created by mac on 05/07/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class CustomNotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate
{

    @IBOutlet weak var tableView: UITableView!
    
    //var indicator = UIActivityIndicatorView()

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBAction func backButtonClicked(_ sender: Any)
    {
        NotificationCenter.default.removeObserver(self)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.view.frame = CGRect(x: self.view.frame.width*0.2, y: self.view.frame.height*0.2, width: self.view.frame.width*0.6, height: self.view.frame.height*0.6)
        
//        self.indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width*0.5-40, y: self.view.frame.height*0.5-40, width: 40, height: 40))
//        //self.indicator = UIActivityIndicatorView(frame: CGRect(x: 12, y: 12, width: 40, height: 40))
//
//        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        self.view.addSubview(self.indicator)
        self.indicator.startAnimating()
//        self.indicator.backgroundColor = UIColor.white
        
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getCustomMessages(username: username!, password: password!, linkedinId: "")
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getCustomMessages(username: "", password: "", linkedinId: linkedInId!)
                
        }
        self.tableView.backgroundView = nil
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkCustomMessagesList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_CUSTOM_MESSAGES), object: nil)


        let tapToDismissNotif = UITapGestureRecognizer(target: self, action: #selector(tapped))

        self.view.addGestureRecognizer(tapToDismissNotif)
        
        tapToDismissNotif.delegate = self
        
        self.tableView.layer.cornerRadius = 4.0
        
//        if AppPreferences.sharedPreferences().gotMessages == false
//        {
        
        
        
        
        
        
        
//        }

        // Do any additional setup after loading the view.
    }

    
    @objc func checkCustomMessagesList(dataDic:Notification)
    {
        DispatchQueue.main.async
            {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
        }
        guard let notiObj = dataDic.object as? [String:Any] else
        {
            return
        }
        
        let messagesString = notiObj["NotificationMessage"] as! String
        
        if messagesString == "\("[ ]")" || messagesString == "null"
        {
            return
        }
        else
        {
            let messageData = messagesString.data(using: .utf8)
            
            do
            {
                AppPreferences.sharedPreferences().gotMessages = true
                
                let messagesArray = try JSONSerialization.jsonObject(with: messageData!, options: .allowFragments) as! [Any]
                
                //            print(messagesArray)
                
                AppPreferences.sharedPreferences().customMessagesArray.removeAll()
                
                for index in messagesArray
                {
                    var idMessageDic = [String:Any]()
                    
                    let messageDic = index as! [String:Any]
                    
                    guard let id = messageDic["jobId"] as? Int else
                    {
                        break
                    }
                    idMessageDic["jobId"]  = id
                    
                    guard let message = messageDic["message"] as? String else
                    {
                        break
                    }
                    idMessageDic["message"]  = message
                    
                    
                    
                    
                    AppPreferences.sharedPreferences().customMessagesArray.append(idMessageDic)
                    
                }
                
                self.tableView.reloadData()

                
                
            } catch let error as NSError
            {
                
            }
        }
        
    }

//    func activityIndicator()
//    {
//        indicator = UIActivityIndicatorView(frame: CGRect(x: 40, y: 40, width: 40, height: 40))
//        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        indicator.center = self.view.center
//        self.tableView.addSubview(indicator)
//    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if touch.view == self.view
        {
          return true
        }
        else
        {
          return false
        }
        
    }
    @objc func tapped(sender:UITapGestureRecognizer) -> Void
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: "header")
        
        return header
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return AppPreferences.sharedPreferences().customMessagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let messageLabel = cell?.viewWithTag(101) as! UILabel
        
        let idMessageDic = AppPreferences.sharedPreferences().customMessagesArray[indexPath.row] as! [String:Any]
        
        messageLabel.text = idMessageDic["message"] as! String?
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        let idMessageDic = AppPreferences.sharedPreferences().customMessagesArray[indexPath.row] as! [String:Any]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpMessageViewController") as! PopUpMessageViewController
        
        vc.messageString = (idMessageDic["message"] as! String?)!
        
        vc.jobId = String(describing: idMessageDic["jobId"] as! Int)
        
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(vc, animated: true, completion: nil)
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
