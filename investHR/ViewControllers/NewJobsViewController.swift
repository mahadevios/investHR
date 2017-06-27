//
//  NewJobsViewController.swift
//  investHR
//
//  Created by mac on 22/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class NewJobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate
{
    var applied:Bool = false
    var saved:Bool = false
    var appliedAndSaveHidden:Bool = false
    var saveHidden:Bool = false
    var webViewLoaded:Bool = false
    var webViewAdded:Bool = false

    var verticalId:String = ""
    var domainType:String = ""
    var jobId:String = ""
    var webViewHeight:CGFloat = 10.0

    var jobLocationArray = [String]()
    var jobDetailsDic:[String:Any]?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(checkJobDescriptionResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_JOB_DESCRIPTION), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSavedOrAppliedJobDescriptionResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVED_APPLIED_JOB_DESCRIPTION), object: nil)


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(checkApplyJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_APPLY_JOB), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSaveJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_JOB), object: nil)
        
        
        getJobDetails()
    }
    
    func getJobDetails()
    {
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getJobDescription(username: username!, password: password!, linkedinId: "", varticalId: verticalId, jobId: String( jobId))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getJobDescription(username: "", password: "", linkedinId: linkedInId!, varticalId: verticalId, jobId: String( jobId))
        }

        AppPreferences.sharedPreferences().showHudWith(title: "Loading job..", detailText: "Please wait")

    
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkJobDescriptionResponse(dataDic:Notification) -> Void
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        guard let code = responseDic["code"] else {
            
            return
        }
        
        guard let verticalJobDetailsString = responseDic["VerticalJobDetails"] else {
            
            return
        }
        
        let jobDetailsData = verticalJobDetailsString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
             jobDetailsDic = try JSONSerialization.jsonObject(with: jobDetailsData!, options: .allowFragments) as? [String:Any]
        } catch let error as NSError
        {
            
        }
        
        let discription = jobDetailsDic?["discription"]


        guard let cityStateListString = responseDic["cityStateList"] else {
            
            return
        }
        
        let cityStateListData = cityStateListString.data(using: .utf8, allowLossyConversion: true)
        var cityStateArray:[Any]?

        do
        {
            cityStateArray = try JSONSerialization.jsonObject(with: cityStateListData!, options: .allowFragments) as? [Any]
            
            for index in 0 ..< cityStateArray!.count
            {
                let cityStateDic = cityStateArray![index] as? [String:String]
                
                let state = cityStateDic?["state"]
                
                let city = cityStateDic?["city"]
                
                jobLocationArray.append("\(state!)\(" ")\(city!)")

            }
            


        } catch let error as NSError
        {
            
        }
        
        
        
        if self.domainType == "vertical" || self.domainType == "horizontal" || self.domainType == "roles"
        {
            let jobId = jobDetailsDic?["jobid"] as! Int
            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            
            if username != nil && password != nil
            {
                APIManager.getSharedAPIManager().saveInterestedJob(username: username!, password: password!, linkedinId: "", jobId: String(jobId))
            }
            else
                if linkedInId != nil
                {
                    APIManager.getSharedAPIManager().saveInterestedJob(username: "", password: "", linkedinId: linkedInId!, jobId: String(jobId))
            }
        }
        
        self.collectionView.reloadData()
    }
    
    func checkSavedOrAppliedJobDescriptionResponse(dataDic:Notification) -> Void
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        guard let code = responseDic["code"] else {
            
            return
        }
        
        guard let verticalJobDetailsString = responseDic["JobDetailList"] else {
            
            return
        }
        
        let jobDetailsData = verticalJobDetailsString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            jobDetailsDic = try JSONSerialization.jsonObject(with: jobDetailsData!, options: .allowFragments) as? [String:Any]
        } catch let error as NSError
        {
            
        }
        
        let discription = jobDetailsDic?["discription"]
        
        
        guard let cityStateListString = responseDic["cityStateList"] else {
            
            return
        }
        
        let cityStateListData = cityStateListString.data(using: .utf8, allowLossyConversion: true)
        var cityStateArray:[Any]?
        
        do
        {
            cityStateArray = try JSONSerialization.jsonObject(with: cityStateListData!, options: .allowFragments) as? [Any]
            
            for index in 0 ..< cityStateArray!.count
            {
                let cityStateDic = cityStateArray![index] as? [String:String]
                
                let state = cityStateDic?["state"]
                
                let city = cityStateDic?["city"]
                
                jobLocationArray.append("\(state!)\(" ")\(city!)")
                
            }
            
            
            
        } catch let error as NSError
        {
            
        }
        
        self.collectionView.reloadData()
    }

    func checkApplyJob(dataDic:NSNotification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let appliedJobId = dataDictionary["jobId"] as! String
        
        let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "AppliedJobs", ["domainType":"" ,"jobId":appliedJobId,"userId":"1"])
        
        applied = true
        
        self.collectionView.reloadData()
        
        
    }
    func saveJobButtonClicked(_ sender: subclassedUIButton)
    {
        
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().saveJob(username: username!, password: password!, linkedinId: "", jobId: String(describing: sender.jobId!))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().saveJob(username: "", password: "", linkedinId: linkedInId!, jobId: String(describing: sender.jobId!))
        }
        
    }
    func applyJobButtonClicked(_ sender: subclassedUIButton)
    {
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().applyJob(username: username!, password: password!, linkedinId: "", jobId: String(describing: sender.jobId!))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().applyJob(username: "", password: "", linkedinId: linkedInId!, jobId: String(describing: sender.jobId!))
        }
        
        //self.collectionView.reloadData()
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
        
        webViewLoaded = true
        webViewAdded = true
        self.collectionView.reloadData()
        
        
        print("webview h = \(webViewHeit)")

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        let companyNameLabel = cell.viewWithTag(101) as! UILabel
        //let companyWebSiteLabel = cell.viewWithTag(102) as! UILabel
        let locationLabel = cell.viewWithTag(105) as! UILabel

        let dateLabel = cell.viewWithTag(107) as! UILabel
        
        let jobDescLabel = cell.viewWithTag(108) as! UILabel

        var descriptionWebView = cell.viewWithTag(109) as! UIWebView
        
        var descriptionWebView1 = UIWebView(frame: CGRect(x: descriptionWebView.frame.origin.x, y: descriptionWebView.frame.origin.y+50, width: descriptionWebView.frame.size.width, height: descriptionWebView.frame.size.height))
        
        //descriptionWebView.isHidden = true
        descriptionWebView1.scrollView.isScrollEnabled = false
        descriptionWebView1.delegate = self
        descriptionWebView1.backgroundColor = UIColor.red
        descriptionWebView.backgroundColor = UIColor.red

        let applyButton = cell.viewWithTag(103) as! subclassedUIButton
        
        let saveButton = cell.viewWithTag(104) as! subclassedUIButton
        
        let saveImageView = cell.viewWithTag(110) as! UIImageView

        let lineView = cell.viewWithTag(111)


        
        let jobId = jobDetailsDic?["jobid"]
        let relocation = jobDetailsDic?["relocation"]
        let date = jobDetailsDic?["date"] as? Double
        let subject = jobDetailsDic?["subject"]
        let location = jobDetailsDic?["location"]
        

        
        if let discription = jobDetailsDic?["discription"]  as? String
        {
            if !webViewLoaded
            {
                descriptionWebView1.loadHTMLString(discription, baseURL: nil)
                //descriptionWebView.loadHTMLString(discription, baseURL: nil)

            }
            
        }
 
        if !webViewAdded
        {
            cell.addSubview(descriptionWebView1)

        }

        
//        descriptionWebView.frame = CGRect(x: descriptionWebView.frame.origin.x, y: descriptionWebView.frame.origin.y, width: descriptionWebView.frame.size.width, height: 300)
        
        let dateString = Date().getLocatDateFromMillisecods(millisecods: date )
        companyNameLabel.text = subject as? String
        
        var jobLocationString:NSMutableString = ""
        
        for index in 0 ..< jobLocationArray.count
        {
            if index == 0
            {
                jobLocationString.append(jobLocationArray[index])
            }
            else
            {
                jobLocationString.append(",")

                jobLocationString.append(jobLocationArray[index])

            }
        }
        
        
        locationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        locationLabel.numberOfLines = 0
       
        locationLabel.textColor = UIColor(colorLiteralRed: 142/255.0, green: 159/255.0, blue: 168/255.0, alpha: 1.0)
        let height = heightForView(text: jobLocationString as String, font: UIFont.systemFont(ofSize: 14), width: locationLabel.frame.size.width) as CGFloat
        
        
        locationLabel.frame = CGRect(x: locationLabel.frame.origin.x, y: locationLabel.frame.origin.y, width: locationLabel.frame.size.width, height: height)
        
        if jobLocationString == ""
        {
            locationLabel.text = "Location"
            locationLabel.textColor = UIColor.clear

        }
        else
        {
            locationLabel.text = jobLocationString as String
        }

        
        
       
        
        
        if appliedAndSaveHidden // viewed from appliedjobs vc
        {
            applyButton.isHidden = true
            saveButton.isHidden = true
            saveImageView.isHidden = true
        }
        else
        if saveHidden // viewed from saved job vc
        {
            saveButton.isHidden = true
            saveImageView.isHidden = true
        }
        
        
            if applied
            {
                applyButton.setTitle("Applied", for: .normal)
                applyButton.setTitleColor(UIColor.init(colorLiteralRed: 7/255.0, green: 116/255.0, blue: 1/255.0, alpha: 1.0), for: .normal)
                applyButton.isUserInteractionEnabled = false
            }
            else
            {
                applyButton.setTitle("Apply", for: .normal)
                applyButton.setTitleColor(UIColor.init(colorLiteralRed: 54/255.0, green: 134/255.0, blue: 239/255.0, alpha: 1.0), for: .normal)
                saveButton.isUserInteractionEnabled = true
            }
            if saved
            {
                saveImageView.image = UIImage(named: "SideMenuSavedJob")
                saveButton.isUserInteractionEnabled = false

            }
            else
            {
                saveImageView.image = UIImage(named: "SavedUnselected")
                applyButton.isUserInteractionEnabled = true

            }
       
        
        saveButton.jobId = jobId as! Int?
        applyButton.jobId = jobId as! Int?
        
        //applyButton.tag = jobId as! Int
        
        saveButton.addTarget(self, action: #selector(saveJobButtonClicked), for: UIControlEvents.touchUpInside)
        applyButton.addTarget(self, action: #selector(applyJobButtonClicked), for: UIControlEvents.touchUpInside)
        
        applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
        return cell
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var jobLocationString:NSMutableString = ""
        
        for index in 0 ..< jobLocationArray.count
        {
            if index == 0
            {
                jobLocationString.append(jobLocationArray[index])
            }
            else
            {
                jobLocationString.append(",")
                
                jobLocationString.append(jobLocationArray[index])
                
            }
        }

        let height = heightForView(text: jobLocationString as String, font: UIFont.systemFont(ofSize: 14), width: self.view.frame.size.width*0.5) as CGFloat

        return CGSize(width: self.view.frame.size.width*0.95, height: height+webViewHeight+200)
    }
    
   
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    func checkSaveJob(dataDic:NSNotification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let codeString = dataDictionary["code"] as! String
        
        if codeString == "1000"
        {
            
        }
        
        let savedJobId = dataDictionary["jobId"] as! String
        
        let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "SavedJobs", ["domainType":"" ,"jobId":savedJobId,"userId":"1"])
        
        saved = true
        
        self.collectionView.reloadData()
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
