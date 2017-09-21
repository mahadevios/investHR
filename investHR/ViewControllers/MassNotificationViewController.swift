//
//  MassNotificationViewController.swift
//  investHR
//
//  Created by mac on 12/09/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class MassNotificationViewController: UIViewController,UIWebViewDelegate
{

    @IBOutlet weak var massDetailsWebView: UIWebView!
    
    var notificationId = "0"
    
    var presentingVC: UIViewController?

    @IBAction func backButtonClicked(_ sender: Any)
    {
        if self.presentingVC?.classForCoder == NotificationJobsViewController.classForCoder()
        {
            let vc = self.presentingVC as! NotificationJobsViewController
            
            vc.notificationSegmentClicked(vc.notificationSegment)
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        massDetailsWebView.delegate = self
        
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
             APIManager.getSharedAPIManager().getMassNotiData(username: username!, password: password!, linkedinId: "", notificationId: notificationId)
        
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getMassNotiData(username: "", password: "", linkedinId: linkedInId!, notificationId: notificationId)
                
            }
       
        NotificationCenter.default.addObserver(self, selector: #selector(checkMassNotiResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_MASS_NOTI), object: nil)
        

        // Do any additional setup after loading the view.
    }

    func webViewDidFinishLoad(_ webView: UIWebView)
    {
//        self.webViewHeight = webView.scrollView.contentSize.height
//        self.webViewWidth = webView.scrollView.contentSize.width
        
        var webViewFrame = webView.frame
        
        webView.frame = webViewFrame
        let fittingSize = webView.sizeThatFits(CGSize.zero)
        webViewFrame.size = fittingSize
        webView.autoresizingMask = .flexibleWidth
        webView.autoresizingMask = .flexibleHeight
        
        let webViewHeit = webView.frame.size.height
        let webViewWidth = webView.frame.size.width
        
        //webView.scrollView.contentSize = CGSize(width: self.webViewWidth, height: self.webViewHeight)
//        webViewLoaded = true
//        webViewAdded = true
        
      //  webView.scrollView.showsVerticalScrollIndicator = false
        
      //  webView.scrollView.showsHorizontalScrollIndicator = false
        
//        if self.webViewWidth < self.view.frame.size.width
//        {
//            webView.isUserInteractionEnabled = false
//        }
        let ht = webView.stringByEvaluatingJavaScript(from: "document.documentElement.scrollHeight")
        
        //self.collectionView.reloadData()
        
        
//        print("webview h = \(webViewHeit)")
//        print("webview w = \(webViewWidth)")
        
        //self.refreshWebView(webView: webView)
        
    }

    func checkMassNotiResponse(dataDic:Notification) -> Void
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        guard let code = responseDic["code"] else {
            
            return
        }

        guard let description = responseDic["Description"] else {
            
            return
        }
        
        self.massDetailsWebView.loadHTMLString(description, baseURL: nil)
        
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
