//
//  NewJobsViewController.swift
//  investHR
//
//  Created by mac on 22/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class NewJobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
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
    var savedJobsIdsArray = [Int]()
    var appliedJobsIdsArray = [Int]()
    var jobLocationArray = [String]()
    var jobDetailsDic:[String:Any]?
    
    var overLayView:UIView!
    
    var scrollView:UIScrollView!
    
    var insideView:UIView!
    
    var referenceLabel:UILabel!
    
    var lineView:UIView!
    
    var textField:UITextField!
    
    var textField1:UITextField!

    var textField2:UITextField!

    var textField3:UITextField!

    var countryCodeButton:UIButton!

    var coutryCodesArray:[String] = []

    //var browseButton:UIButton!

    var submitButton:UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func shareFriendButtonClicked(_ sender: Any)
    {
        self.addReferFriendView()

    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(checkJobDescriptionResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_JOB_DESCRIPTION), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSavedOrAppliedJobDescriptionResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVED_APPLIED_JOB_DESCRIPTION), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(checkRederFriendResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_REFER_FRIEND), object: nil)

        coutryCodesArray = ["+1","+93","+355","+213","+1 684","+376","+244","+1 264","+672","+64","+1 268","+54","+374","+297","+247","+61","+43","+994","+1 242","+973","+880","+1 246","+375","+32","+501","+229","+1 441","+975","+591","+387","+267","+55","+1 284","+673","+359","+226","+95","+257","+855","+237","+238","+1 345","+236","+235","+56","+86","+61","+57","+269","+242","+682","+506","+385","+53","+357","+420","+243","+45","+246","+253","+1 767","+1 809","+1 829","+1, 849","+593","+20","+503","+240","+291","+372","+251","+500","+298","+679","+358","+33","+594","+689","+241","+220","+995","+49","+233","+350","+30","+299","+1 473","+590","+1 671","+502","+224","+245","+592","+509","+39","+504","+852","+36","+354","+91","+62","+98","+964","+353","+44","+972","+225","+1 876","+81","+962","+7","+254","+686","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+596","+222","+230","+262","+52","+691","+373","+377","+976","+382","+1 664","+212","+258","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+672","+850","+1 670","+47","+968","+92","+680","+970","+507","+595","+51","+63","+870","+48","+351","+1 787","+1 939","+974","+242","+262","+40","+250","+590","+290","+1 869","+1 758","+508","+1 784","+685","+378","+239","+966","+221","+381","+248","+232","+65","+1 721","+421","+386","+677","+252","+27","+82","+211","+34","+94","+249","+597","+47","+268","+46","+41","+963","+886","+992","+255","+66","+670","+228","+690","+676","+1 868","+216","+90","+993","+1 649","+688","+256","+380","+971","+598","+1 340","+998","+678","+58","+84","+681","+212","+967","+260","+263"]
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(checkApplyJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_APPLY_JOB), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSaveJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_JOB), object: nil)
        
        if self.domainType == "vertical" || self.domainType == "horizontal" || self.domainType == "roles" || self.domainType == "location"
        {
            getJobDetails()
        }
        
        savedJobsIdsArray.removeAll()
        if let managedObjects = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "SavedJobs")
        {
            for savedJobObject in managedObjects as! [SavedJobs]
            {
                let jobId = savedJobObject.jobId
                
                savedJobsIdsArray.append(Int(jobId!)!)
            }
        }
        
        //let managedObjects1 = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "AppliedJobs")
        appliedJobsIdsArray.removeAll()
        if let managedObjects1 = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "AppliedJobs")
        {
            for appliedJobObject in managedObjects1 as! [AppliedJobs]
            {
                let jobId = appliedJobObject.jobId
                
                appliedJobsIdsArray.append(Int(jobId!)!)
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    func getJobDetails()
    {
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getJobDescription(username: username!, password: password!, linkedinId: "", varticalId: verticalId, jobId: String(jobId))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getJobDescription(username: "", password: "", linkedinId: linkedInId!, varticalId: verticalId, jobId: String(jobId))
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
            
            var uniqueStateArray = [String]()
            
            for index in 0 ..< cityStateArray!.count
            {
                let cityStateDic = cityStateArray![index] as? [String:AnyObject]
                
                let state = cityStateDic?["state"] as! String
                
                if !uniqueStateArray.contains(state)
                {
                    uniqueStateArray.append(state)
                }
                
                
            }
            jobLocationArray.removeAll()
            
            for index in 0 ..< uniqueStateArray.count
            {
                if index != uniqueStateArray.count - 1
                {
                    jobLocationArray.append(uniqueStateArray[index])
                    
                    jobLocationArray.append(",")
                }
                else
                {
                    jobLocationArray.append(uniqueStateArray[index])
                    
                }
            }
            //for index0 in 0 ..< uniqueStateArray.count
//            {
//                var stateAdded = false
//                var firstTime = true
//                
//                
//                for index in 0 ..< cityStateArray!.count
//                {
//                    let cityStateDic = cityStateArray![index] as? [String:AnyObject]
//                    
//                    let state = cityStateDic?["state"] as! String
//                    
//                    
//                    if state == uniqueStateArray[index0]
//                    {
//                        let optionalCity = cityStateDic?["city"]
//                        
//                        var city = ""
//                        
//                        if optionalCity is NSNull
//                        {
//                            city = ""
//                            if !stateAdded
//                            {
//                                //                                jobLocationArray.append("\(state)\(":")\(city)")
//                                jobLocationArray.append("\(state)")
//                                
//                                stateAdded = true
//                            }
//                            else
//                            {
//                                //jobLocationArray.append("\(",")\(city)")
//                            }
//                        }
//                        else
//                        {
//                            city = optionalCity! as! String
//                            
//                            if !stateAdded
//                            {
//                                jobLocationArray.append("\(state)\(":")\(city)")
//                                stateAdded = true
//                                firstTime = false
//                                
//                            }
//                            else
//                            {
//                                if firstTime == true
//                                {
//                                    jobLocationArray.append("\(":")\(city)")
//                                    firstTime = false
//                                    
//                                }
//                                else
//                                {
//                                    jobLocationArray.append("\(",")\(city)")
//                                    
//                                }
//                                
//                            }
//                        }
//                    }
//                }
//                jobLocationArray.append("\n")
//            }
            
            
        } catch let error as NSError
        {
            
        }
        

        
        
        
        if self.domainType == "vertical" || self.domainType == "horizontal" || self.domainType == "roles" || self.domainType == "location"
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
        let jobId = jobDetailsDic?["jobid"] as! Int

        if self.appliedJobsIdsArray.contains(jobId)
        {
            self.applied = true
        }
        if self.savedJobsIdsArray.contains(jobId)
        {
            self.saved = true
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
            
            var uniqueStateArray = [String]()
            
            for index in 0 ..< cityStateArray!.count
            {
                let cityStateDic = cityStateArray![index] as? [String:AnyObject]
                
                let state = cityStateDic?["state"] as! String
                
                if !uniqueStateArray.contains(state)
                {
                    uniqueStateArray.append(state)
                }
                //                let optionalCity = cityStateDic?["city"]
                //
                //                var city = ""
                //
                //                if optionalCity is NSNull
                //                {
                //                    city = ""
                //                }
                //                else
                //                {
                //                 city = optionalCity! as! String
                //                }
                //                jobLocationArray.append("\(state)\(" ")\(city)")
                
            }
            jobLocationArray.removeAll()
            
//            for uniqueStateName in uniqueStateArray
//            {
//                jobLocationArray.append(uniqueStateName)
//                
//                jobLocationArray.append(",")
//
//            }
            
            for index in 0 ..< uniqueStateArray.count
            {
                if index != uniqueStateArray.count - 1
                {
                    jobLocationArray.append(uniqueStateArray[index])

                    jobLocationArray.append(",")
                }
                else
                {
                    jobLocationArray.append(uniqueStateArray[index])

                }
            }
            

           // for 0..< u
            //for index0 in 0 ..< uniqueStateArray.count
//            {
//                var stateAdded = false
//                var firstTime = true
//
//                
//                for index in 0 ..< cityStateArray!.count
//                {
//                    let cityStateDic = cityStateArray![index] as? [String:AnyObject]
//                    
//                    let state = cityStateDic?["state"] as! String
//                    
//                    
//                    if state == uniqueStateArray[index0]
//                    {
//                        let optionalCity = cityStateDic?["city"]
//                        
//                        var city = ""
//                        
//                        if optionalCity is NSNull
//                        {
//                            city = ""
//                            if !stateAdded
//                            {
//                                //                                jobLocationArray.append("\(state)\(":")\(city)")
//                                jobLocationArray.append("\(state)")
//                                
//                                stateAdded = true
//                            }
//                            else
//                            {
//                                //jobLocationArray.append("\(",")\(city)")
//                            }
//                        }
//                        else
//                        {
//                            city = optionalCity! as! String
//                            
//                            if !stateAdded
//                            {
//                                jobLocationArray.append("\(state)\(":")\(city)")
//                                stateAdded = true
//                                firstTime = false
//
//                            }
//                            else
//                            {
//                                if firstTime == true
//                                {
//                                    jobLocationArray.append("\(":")\(city)")
//                                    firstTime = false
//
//                                }
//                                else
//                                {
//                                    jobLocationArray.append("\(",")\(city)")
//
//                                }
//
//                            }
//                        }
//                    }
//                }
//                jobLocationArray.append("\n")
//            }
            
            
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
        
        self.applied = true
        
        self.collectionView.reloadData()
        
        
    }
    func saveJobButtonClicked(_ sender: subclassedUIButton)
    {
        AppPreferences.sharedPreferences().showHudWith(title: "Saving job..", detailText: "Please wait")

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
        AppPreferences.sharedPreferences().showHudWith(title: "Applying for job..", detailText: "Please wait")

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

       /// let dateLabel = cell.viewWithTag(107) as! UILabel
        
        let jobDescLabel = cell.viewWithTag(108) as! UILabel

        let descriptionWebView = cell.viewWithTag(109) as! UIWebView
        
        

        let applyButton = cell.viewWithTag(103) as! subclassedUIButton
        
        let saveButton = cell.viewWithTag(104) as! subclassedUIButton
        
        let saveImageView = cell.viewWithTag(110) as! UIImageView

        let lineView = cell.viewWithTag(111)


        
        let jobId = jobDetailsDic?["jobid"]
       // let relocation = jobDetailsDic?["relocation"]
        let date = jobDetailsDic?["date"] as? Double
        //let location = jobDetailsDic?["location"]
        
        var descriptionWebView1 = UIWebView(frame: CGRect(x: descriptionWebView.frame.origin.x, y: descriptionWebView.frame.origin.y+50, width: descriptionWebView.frame.size.width, height: descriptionWebView.frame.size.height))

        

        if let subject = jobDetailsDic?["subject"]
        {
            companyNameLabel.text = subject as? String
            companyNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            companyNameLabel.numberOfLines = 0
            let height1 = heightForView(text: subject as! String, font: UIFont.systemFont(ofSize: 14), width: locationLabel.frame.size.width) as CGFloat
            companyNameLabel.frame = CGRect(x: companyNameLabel.frame.origin.x, y: companyNameLabel.frame.origin.y, width: companyNameLabel.frame.size.width, height: height1)
            
            //
            
            
            let dateString = Date().getLocatDateFromMillisecods(millisecods: date )
            
            var jobLocationString:NSMutableString = ""
            
            for index in 0 ..< jobLocationArray.count
            {
//                if index == 0
//                {
                    jobLocationString.append(jobLocationArray[index])
//                }
//                else
//                {
//                    jobLocationString.append(",")
//                    
//                    jobLocationString.append(jobLocationArray[index])
//                    
//                }
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
            

            
            
            
            //
            
            descriptionWebView1 = UIWebView(frame: CGRect(x: descriptionWebView.frame.origin.x, y: companyNameLabel.frame.origin.y+20+height1+20+height+jobDescLabel.frame.size.height+30, width: descriptionWebView.frame.size.width, height: descriptionWebView.frame.size.height))
            print("subject = " + "\(subject)")
        }

        
        //descriptionWebView.isHidden = true
        descriptionWebView1.scrollView.isScrollEnabled = false
        descriptionWebView1.delegate = self
        descriptionWebView1.backgroundColor = UIColor.red
        descriptionWebView.backgroundColor = UIColor.red
        
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
        
        
            if self.applied
            {
                applyButton.setTitle("Applied", for: .normal)
                applyButton.setTitleColor(UIColor.white, for: .normal)
                applyButton.backgroundColor = UIColor.appliedJobGreenColor()
                //applyButton.isUserInteractionEnabled = false
                applyButton.isEnabled = false
            }
            else
            {
                applyButton.setTitle("Apply", for: .normal)
                applyButton.setTitleColor(UIColor.white, for: .normal)
                applyButton.backgroundColor = UIColor.appBlueColor()

                //saveButton.isUserInteractionEnabled = true
                applyButton.isEnabled = true

            }
            if self.saved
            {
                saveImageView.image = UIImage(named: "SideMenuSavedJob")
                saveButton.isEnabled = false


            }
            else
            {
                saveImageView.image = UIImage(named: "SavedUnselected")
                saveButton.isEnabled = true

            }
       
        
        saveButton.jobId = jobId as! Int64?
        applyButton.jobId = jobId as! Int64?
        
        //applyButton.tag = jobId as! Int
        
        saveButton.addTarget(self, action: #selector(saveJobButtonClicked), for: UIControlEvents.touchUpInside)
        applyButton.addTarget(self, action: #selector(applyJobButtonClicked), for: UIControlEvents.touchUpInside)
        
        //applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
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
//            if index == 0
//            {
                jobLocationString.append(jobLocationArray[index])
//            }
//            else
//            {
//                jobLocationString.append(",")
//                
//                jobLocationString.append(jobLocationArray[index])
//                
//            }
        }


        let height = heightForView(text: jobLocationString as String, font: UIFont.systemFont(ofSize: 14), width: self.view.frame.size.width*0.5) as CGFloat

        var height1:CGFloat = 10.0
        
        if let subject = jobDetailsDic?["subject"]
        {
          let height2 = heightForView(text: subject as! String, font: UIFont.systemFont(ofSize: 14), width: self.view.frame.size.width*0.5) as CGFloat
            
            height1 = height2
        }
        
        print("location height = " + "\(height)")
        print("subject height = " + "\(height1)")

        return CGSize(width: self.view.frame.size.width*0.95, height: height+height1+webViewHeight+200)
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
        
        self.saved = true
        
        self.collectionView.reloadData()
    }
    
    
    
    func addReferFriendView()
    {
        
        
        overLayView = UIView(frame: self.view.frame)
        
        overLayView.tag = 222
        
        overLayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let tapToDismissNotif = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        self.view.addGestureRecognizer(tapToDismissNotif)
        
        tapToDismissNotif.delegate = self
        
        scrollView = UIScrollView(frame: CGRect(x: self.view.frame.size.width*0.1, y: self.view.frame.size.height*0.09, width: self.view.frame.size.width*0.8, height: self.view.frame.size.height*0.73))
        
        //scrollView.isOpaque = false
        scrollView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false

        
        scrollView.backgroundColor = UIColor.white
        
        insideView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: 500))
        
        //insideView.isOpaque = false

        insideView.backgroundColor = UIColor.white

        scrollView.layer.cornerRadius = 4.0
        
        insideView.layer.cornerRadius = 4.0

        
        referenceLabel = UILabel(frame: CGRect(x: insideView.frame.size.width/2 - 60, y: 10, width: 120, height: 35))
        
        referenceLabel.textAlignment = NSTextAlignment.center
        
        referenceLabel.text = "Referral"
        
        referenceLabel.textColor = UIColor(colorLiteralRed: 24/255.0, green: 125/255.0, blue: 239/255.0, alpha: 1.0)
        
        
        lineView = UIView(frame: CGRect(x: 0, y: referenceLabel.frame.origin.y + referenceLabel.frame.size.height + 10, width: insideView.frame.size.width, height: 2))
        
        lineView.backgroundColor = UIColor(colorLiteralRed: 24/255.0, green: 125/255.0, blue: 239/255.0, alpha: 1.0)

        
        
        textField = UITextField(frame: CGRect(x: insideView.frame.size.width*0.07, y: lineView.frame.origin.y + lineView.frame.size.height + 20, width: insideView.frame.size.width*0.86, height: 30))

        textField1 = UITextField(frame: CGRect(x: textField.frame.origin.x, y: textField.frame.origin.y + textField.frame.size.height + 15, width: textField.frame.size.width, height: textField.frame.size.height))
        
        textField2 = UITextField(frame: CGRect(x: textField.frame.origin.x, y: textField1.frame.origin.y + textField1.frame.size.height + 15, width: textField.frame.size.width, height: textField.frame.size.height))
        
        textField3 = UITextField(frame: CGRect(x: textField.frame.origin.x, y: textField2.frame.origin.y + textField2.frame.size.height + 15, width: textField.frame.size.width, height: textField.frame.size.height))
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.delegate = self
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField1.leftView = paddingView1
        textField1.leftViewMode = .always
        textField1.font = UIFont.systemFont(ofSize: 14.0)
        textField1.delegate = self
        textField1.keyboardType = .emailAddress

        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        textField2.leftViewMode = .always
        textField2.font = UIFont.systemFont(ofSize: 14.0)
        textField2.delegate = self
        textField2.keyboardType = .phonePad
        countryCodeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        countryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        countryCodeButton.setTitleColor(UIColor.black, for: .normal)
        countryCodeButton.setTitle("\(coutryCodesArray[0])", for: .normal)
        countryCodeButton.addTarget(self, action: #selector(countryCodeButtonClicekd), for: .touchUpInside)
        paddingView2.addSubview(countryCodeButton)
        textField2.leftView = paddingView2

        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField3.leftView = paddingView3
        textField3.leftViewMode = .always
        textField3.font = UIFont.systemFont(ofSize: 14.0)
        textField3.delegate = self
        textField3.keyboardType = .URL

//        browseButton = UIButton(frame: CGRect(x: textField.frame.origin.x, y: textField3.frame.origin.y + textField3.frame.size.height + 15, width: textField.frame.size.width/2.3, height: textField.frame.size.height))
//        
//        browseButton.backgroundColor = UIColor.lightGray
//        
//        browseButton.setTitle("Browse Resume", for: .normal)
//        
//        browseButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        
//        browseButton.setTitleColor(UIColor.black, for: .normal)
//        
//        browseButton.layer.cornerRadius = 4.0
//        
//        browseButton.addTarget(self, action: #selector(browseResumeButtonClicked), for: .touchUpInside)
        
        submitButton = UIButton(frame: CGRect(x: insideView.frame.width/2 - 50, y: textField3.frame.origin.y + textField3.frame.size.height + 20, width: 100, height: 40))
        
        submitButton.backgroundColor = UIColor(colorLiteralRed: 24/255.0, green: 125/255.0, blue: 239/255.0, alpha: 1.0)
        
        submitButton.setTitle("Send", for: .normal)
        
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        submitButton.setTitleColor(UIColor.white, for: .normal)
        
        //submitButton.layer.cornerRadius = 4.0
        
        submitButton.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)

        textField.placeholder = "Name"
        
        textField1.placeholder = "Email"
        
        textField2.placeholder = "Mobile"
        
        textField3.placeholder = "Linkedin Url"
        
        textField.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        textField1.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        textField2.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        textField3.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        textField.layer.borderWidth = 1.0
        
        textField1.layer.borderWidth = 1.0
        
        textField2.layer.borderWidth = 1.0
        
        textField3.layer.borderWidth = 1.0
        
        textField.layer.cornerRadius = 4.0
        
        textField1.layer.cornerRadius = 4.0
        
        textField2.layer.cornerRadius = 4.0
        
        textField3.layer.cornerRadius = 4.0
        
        insideView.addSubview(referenceLabel)
        insideView.addSubview(lineView)
        insideView.addSubview(textField)
        insideView.addSubview(textField1)
        insideView.addSubview(textField2)
        insideView.addSubview(textField3)
        //insideView.addSubview(browseButton)
        insideView.addSubview(submitButton)
        
        scrollView.addSubview(insideView)
        
        overLayView.addSubview(scrollView)
        //self.view.addSubview(insideView)
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width*0.1, height: 450)

        self.view.addSubview(overLayView)
        
        
    }

    func browseResumeButtonClicked()
    {
    
    }
    
    func submitButtonClicked()
    {
        if textField.text == ""
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Please enter a name", withCancelText: "Ok")
        }
        else
            if textField1.text == "" || !(textField1.text?.contains("@"))!  || !(textField1.text?.contains("."))!
            {
                AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Please enter a valid email address", withCancelText: "Ok")
            }
        else
            {
                let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
                let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
                let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
                let name = textField.text
                
                let email = textField1.text
                
                var mobileNum = ""
                
                if textField2.text != nil || textField2.text != ""
                {
                    mobileNum = (countryCodeButton.titleLabel?.text)! + "-" + textField2.text!
                }
                let linkedIn = textField3.text
                
                if username != nil && password != nil
                {
                    APIManager.getSharedAPIManager().referFriend(username: username!, password: password!, linkedinId: "", email: email!, jobId: self.jobId, name: name!, linkedInIdOfFriend: linkedIn!, mobile: mobileNum)
                }
                else
                    if linkedInId != nil
                    {
                        APIManager.getSharedAPIManager().referFriend(username: "", password: "", linkedinId: linkedInId!, email: email!, jobId: self.jobId, name: name!, linkedInIdOfFriend: linkedIn!, mobile: mobileNum)
                }
                
                
            }
        
        //self.view.viewWithTag(222)?.removeFromSuperview()

    }
    
    func dismissReferFriendView()
    {
//        view.backgroundColor = UIColor.white
//        
//        view.alpha = 1.0

        self.view.viewWithTag(222)?.removeFromSuperview()
    }
    
    func deviceRotated() -> Void
    {
        if self.view.viewWithTag(222) != nil
        {
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
            {
                //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
                DispatchQueue.main.async
                    {
                        self.overLayView.frame = self.view.frame
                        
                        self.scrollView.frame = CGRect(x: self.view.frame.size.width*0.1, y: self.view.frame.size.height*0.07, width: self.view.frame.size.width*0.8, height: self.view.frame.size.height*0.8)
                        
                        
                        self.insideView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width, height: 450)
                        
                        self.referenceLabel.frame = CGRect(x: self.insideView.frame.size.width/2 - 60, y: 10, width: 120, height: 35)
                        
                        self.lineView.frame = CGRect(x: 0, y: self.referenceLabel.frame.origin.y + self.referenceLabel.frame.size.height + 10, width: self.insideView.frame.size.width, height: 2)
                        
                        self.textField.frame = CGRect(x: self.insideView.frame.size.width*0.07, y: self.lineView.frame.origin.y + self.lineView.frame.size.height + 20, width: self.insideView.frame.size.width*0.86, height: 30)
                        
                        self.textField1.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField.frame.origin.y + self.textField.frame.size.height + 15, width: self.textField.frame.size.width, height: self.textField.frame.size.height)
                        
                        self.textField2.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField1.frame.origin.y + self.textField1.frame.size.height + 15, width: self.textField.frame.size.width, height: self.textField.frame.size.height)
                        
                        self.textField3.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField2.frame.origin.y + self.textField2.frame.size.height + 15, width: self.textField.frame.size.width, height: self.textField.frame.size.height)
                        
                        //submitButton = UIButton(frame: CGRect(x: insideView.frame.width/2 - 50, y: textField3.frame.origin.y + textField3.frame.size.height + 15, width: 100, height: 40))
                        
                       // self.browseButton.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField3.frame.origin.y + self.textField3.frame.size.height + 15, width: self.textField.frame.size.width/2.3, height: 40)
                        
                        self.submitButton.frame = CGRect(x: self.insideView.frame.width/2 - 100, y: self.textField3.frame.origin.y + self.textField3.frame.size.height + 20, width: 200, height: 40)
                        
                        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width*0.1, height: 450)
                }
                
                
                print("Landscape")
            }
            
            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
            {
                //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
                DispatchQueue.main.async
                    {
                        self.overLayView.frame = self.view.frame
                        
                        self.scrollView.frame = CGRect(x: self.view.frame.size.width*0.1, y: self.view.frame.size.height*0.09, width: self.view.frame.size.width*0.8, height: self.view.frame.size.height*0.7)
                        
                        self.insideView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width, height: 450)
                        
                        //self.insideView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width, height: 500)
                        
                        self.referenceLabel.frame = CGRect(x: self.insideView.frame.size.width/2 - 60, y: 10, width: 120, height: 35)
                        
                        self.lineView.frame = CGRect(x: 0, y: self.referenceLabel.frame.origin.y + self.referenceLabel.frame.size.height + 10, width: self.insideView.frame.size.width, height: 2)
                        
                        self.textField.frame = CGRect(x: self.insideView.frame.size.width*0.07, y: self.lineView.frame.origin.y + self.lineView.frame.size.height + 20, width: self.insideView.frame.size.width*0.86, height: 30)
                        
                        self.textField1.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField.frame.origin.y + self.textField.frame.size.height + 15, width: self.textField.frame.size.width, height: self.textField.frame.size.height)
                        
                        self.textField2.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField1.frame.origin.y + self.textField1.frame.size.height + 15, width: self.textField.frame.size.width, height: self.textField.frame.size.height)
                        
                        self.textField3.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField2.frame.origin.y + self.textField2.frame.size.height + 15, width: self.textField.frame.size.width, height: self.textField.frame.size.height)
                        
                        //self.browseButton.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField3.frame.origin.y + self.textField3.frame.size.height + 15, width: self.textField.frame.size.width/2.3, height: 40)
                        
                        self.submitButton.frame = CGRect(x: self.insideView.frame.width/2 - 50, y: self.textField3.frame.origin.y + self.textField3.frame.size.height + 20, width: 100, height: 40)
                        
                        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width*0.1, height: 450)
                        
                }
                print("Portrait")
            }

        }
        
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if touch.view == self.overLayView
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
        self.view.viewWithTag(222)?.removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
            textField.resignFirstResponder()
        
            return true
    }
    func countryCodeButtonClicekd(sender:UIButton)
    {
        resignAllResponders()
        self.addPickerToolBarForCountryCodes()
        
    }
    func resignAllResponders()
    {
        DispatchQueue.main.async
            {
                self.textField.resignFirstResponder()
                self.textField1.resignFirstResponder()
                self.textField2.resignFirstResponder()
                self.textField3.resignFirstResponder()
            }
        

    }
    func addPickerToolBarForCountryCodes()
    {
        if self.view.viewWithTag(10000) == nil
        {
            
            let picker = UIPickerView()
            
            picker.tag = 10001;
            
            picker.frame = CGRect(x: 0.0, y: self.view.frame.size.height - 216.0, width: self.view.frame.size.width, height: 216.0)
            
            picker.delegate = self
            
            picker.dataSource = self
            
            picker.showsSelectionIndicator = true
            
            self.view.addSubview(picker)
            
            picker.isUserInteractionEnabled = true
            
            picker.backgroundColor = UIColor.lightGray
            
            //        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressToGetValue:)];
            let btn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonPressed))
            
            //        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, picker.frame.origin.y - 40.0f, self.view.frame.size.width, 40.0f)];
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: picker.frame.origin.y - 40.0, width: self.view.frame.size.width, height: 40.0))
            
            toolBar.tag = 10000
            
            toolBar.setItems([btn], animated: true)
            
            self.view.addSubview(toolBar)
            //     OperatorTextField.inputAccessoryView=toolBar;
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        return coutryCodesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return coutryCodesArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        //
        //        if pickerView.tag == 1
        //        {
        //            label?.font = UIFont.systemFont(ofSize: 12)
        //            label?.text =  candidateFunctionArray[row] as? String
        //            label?.textAlignment = .left
        //        }
        //        else
        //        {
        label?.font = UIFont.systemFont(ofSize: 14)
        label?.text =  coutryCodesArray[row] as String
        
        label?.textAlignment = .center
        // label?.textAlignment = .left
        //}
        
        return label!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        let selectedCountryCode = coutryCodesArray[row]
        
        countryCodeButton.setTitle(selectedCountryCode, for: .normal)
        // relocationTextFIeld.text = selectedRole
        
    }

    func pickerDoneButtonPressed()
    {
        removePickerToolBar()
    }
    
    func removePickerToolBar()
    {
        if let picker = self.view.viewWithTag(10000)
        {
            picker.removeFromSuperview()
            
        }
        
        
        
        
        
        
        if let toolbar1 = self.view.viewWithTag(10001)
        {
            toolbar1.removeFromSuperview()
            
        }
        
        
        // [DescriptionTextView becomeFirstResponder];
        
    }
    
    func checkRederFriendResponse(dataDic:Notification)
    {
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
        
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        print(responseDic)
        guard let code = responseDic["code"] else {
            
            return
        }
        
        self.view.viewWithTag(222)?.removeFromSuperview()

        AppPreferences.sharedPreferences().showAlertViewWith(title: "Referral Sent", withMessage: "Referral Sent successfully", withCancelText: "Ok")
        
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
