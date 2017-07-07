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
    @IBAction func backButtonClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.view.frame = CGRect(x: self.view.frame.width*0.2, y: self.view.frame.height*0.2, width: self.view.frame.width*0.6, height: self.view.frame.height*0.6)
        
        self.tableView.backgroundView = nil
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let tapToDismissNotif = UITapGestureRecognizer(target: self, action: #selector(tapped))

        self.view.addGestureRecognizer(tapToDismissNotif)
        
        tapToDismissNotif.delegate = self
        
        self.tableView.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
    }

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
    func tapped(sender:UITapGestureRecognizer) -> Void
    {
        self.dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let idMessageDic = AppPreferences.sharedPreferences().customMessagesArray[indexPath.row] as! [String:Any]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpMessageViewController") as! PopUpMessageViewController
        
        vc.messageString = (idMessageDic["message"] as! String?)!
        
        vc.jobId = String(describing: idMessageDic["jobId"] as! Int)
        
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(vc, animated: true, completion: nil)
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
