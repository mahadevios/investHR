//
//  PopUpMessageViewController.swift
//  investHR
//
//  Created by mac on 07/07/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class PopUpMessageViewController: UIViewController,UIWebViewDelegate
{

    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var viewJobButton: UIButton!
    
    var savedJobsIdsArray = [Int64]()
    
    var appliedJobsIdsArray = [Int64]()
    
       @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var webView: UIWebView!
    var messageString:String = ""
    var jobId:String = ""
    private var webViewHeight:CGFloat = 50.0
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let managedObjects = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "SavedJobs")
        {
            for savedJobObject in managedObjects as! [SavedJobs]
            {
                let jobId = savedJobObject.jobId
                
                savedJobsIdsArray.append(Int64(jobId!)!)
            }
        }
        
        if let managedObjects1 = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "AppliedJobs")
        {
            for appliedJobObject in managedObjects1 as! [AppliedJobs]
            {
                let jobId = appliedJobObject.jobId
                
                appliedJobsIdsArray.append(Int64(jobId!)!)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if self.jobId == "0"
        {
            viewJobButton.isHidden = true
        }
        
           self.webView.loadHTMLString(self.messageString, baseURL: nil)
        
           self.webView.delegate = self
        
           self.webView.scrollView.isScrollEnabled = false
        
        
    }
    
    @IBAction func viewJobButtonClicked(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewJobsViewController") as! NewJobsViewController
        if savedJobsIdsArray.contains(Int64(self.jobId)!)
        {
            vc.saved = true
        }
        if appliedJobsIdsArray.contains(Int64(self.jobId)!)
        {
            vc.applied = true
        }
        vc.verticalId = String(0)
        vc.domainType = "vertical"
        let jobId1 = String(describing: self.jobId)
        vc.jobId = jobId1
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    @IBAction func viewjobButtonClicked(_ sender: Any) {
    }

    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.webViewHeight = webView.scrollView.contentSize.height
        
        var webViewFrame = webView.frame
        webViewFrame.size.height = 1
        webView.frame = webViewFrame
        let fittingSize = webView.sizeThatFits(CGSize.zero)
        webViewFrame.size = fittingSize
        // webViewFrame.size.width = 276; Making sure that the webView doesn't get wider than 276 px
        webView.frame = webViewFrame;
        
        let webViewHeit = webView.frame.size.height
        
        //webViewLoaded = true
        //webViewAdded = true
        self.webView.frame.size.height = webViewHeit
        
        self.insideView.frame.size.height = webViewHeit
        print("webview h = \(webViewHeit)")
        
        print("webview height = " + "\(self.webView.frame.size.height)")
        
        print("insideview height = " + "\(self.insideView.frame.size.height)")
        
        let heightConstraint = NSLayoutConstraint(item: self.webView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: webViewHeit)

        self.webView.addConstraint(heightConstraint)
        
        self.scrollView.contentSize = CGSize(width: self.insideView.frame.size.width, height: webViewHeit)

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
