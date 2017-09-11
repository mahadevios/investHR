//
//  NotificationJobsViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class NotificationJobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var commonNotificationObjectsArray:[CommonNotification]?
    
    var jobNotificationObjectsArray:[CommonNotification]?

    var specialNotificationObjectsArray:[ZSpecialNotification]?

    @IBOutlet weak var notificationSegment: UISegmentedControl!
    var indexePathArray:[IndexPath]=[]
    
    var savedJobsIdsArray = [Int64]()
    
    var closedJobsIdsArray = [Int64]()

    
    var appliedJobsIdsArray = [Int64]()

    @IBAction func notificationSegmentClicked(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            self.jobNotificationObjectsArray?.removeAll()

            self.jobNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "CommonNotification") as? [CommonNotification]
            
            self.collectionView.reloadData()

            //self.commonNotificationObjectsArray?.removeAll()
            
            //self.commonNotificationObjectsArray = self.jobNotificationObjectsArray

        }
        else
        {
            self.specialNotificationObjectsArray?.removeAll()

            self.specialNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecordsOfSpecialNotification() as? [ZSpecialNotification]
            
            self.collectionView.reloadData()
            //self.commonNotificationObjectsArray?.removeAll()
            
            //self.commonNotificationObjectsArray = self.specialNotificationObjectsArray
        }
    }
    @IBOutlet weak var dataNotFoundLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Notifications"
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkClosedJobList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_CLOSED_JOBIDS), object: nil)
        
        if AppPreferences.sharedPreferences().isReachable
        {
            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            
            if username != nil && password != nil
            {
                APIManager.getSharedAPIManager().getDeletedJobIds(username: username!, password: password!, linkedInId: "")
            }
            else
                if linkedInId != nil
                {
                    APIManager.getSharedAPIManager().getDeletedJobIds(username: "", password: "", linkedInId: linkedInId!)
                    
                }
        }
        else
        {
            self.jobNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "CommonNotification") as? [CommonNotification]
            
            //self.specialNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "ZSpecialNotification") as? [CommonNotification]
            
            //self.commonNotificationObjectsArray?.removeAll()
            
            //self.commonNotificationObjectsArray = self.jobNotificationObjectsArray
            
            //self.collectionView.reloadData()
        }
        
       // self.automaticallyAdjustsScrollViewInsets = false

//        let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
//        numberOfJobsLabel.textColor = UIColor(colorLiteralRed: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
//        numberOfJobsLabel.text = "108 jobs"
//        numberOfJobsLabel.textAlignment = NSTextAlignment.right
//        let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
//        
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
      
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkApplyJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_APPLY_JOB), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSaveJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_JOB), object: nil)
        
    }
    
    func checkClosedJobList(dataDic:Notification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let codeString = String(describing: dataDictionary["code"]!)
        
        self.commonNotificationObjectsArray?.removeAll()
        
        self.jobNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "CommonNotification") as? [CommonNotification]
        
        
        if codeString == "1001"
        {

            if self.commonNotificationObjectsArray?.count == 0
            {
                dataNotFoundLabel.isHidden = false
            }
            

            self.collectionView.reloadData()
            
            return
        }
        
        let closedJobIdsString = dataDictionary["deletedJobId"] as! String
        
        let closedJobIdsData = closedJobIdsString.data(using: .utf8)
        
        do
        {
            self.closedJobsIdsArray = try JSONSerialization.jsonObject(with: closedJobIdsData!, options: .allowFragments) as! [Int64]
            
            if self.closedJobsIdsArray.count < 1
            {
                dataNotFoundLabel.isHidden = false

                self.collectionView.reloadData()
            }
            else
            {
                if self.jobNotificationObjectsArray != nil
                {
                    for notiObj in self.jobNotificationObjectsArray!
                    {
                        if self.closedJobsIdsArray.contains(notiObj.jobId)
                        {
                            let index = self.jobNotificationObjectsArray?.index(of: notiObj)
                            
                            self.jobNotificationObjectsArray?.remove(at: index!)
                            
                        }
                    }

                }
               

               // print(closedJobsIdsArray)
            }
           

        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
        self.commonNotificationObjectsArray = self.jobNotificationObjectsArray

        self.collectionView.reloadData()


    }
    
    
    
    func checkSaveJob(dataDic:NSNotification)
    {
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
        
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
        
        savedJobsIdsArray.removeAll()
        
        if let managedObjects = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "SavedJobs")
        {
            for savedJobObject in managedObjects as! [SavedJobs]
            {
                let jobId = savedJobObject.jobId
                
                savedJobsIdsArray.append(Int64(jobId!)!)
            }
        }
        //self.collectionView.reloadData()
        
        self.collectionView.reloadItems(at: indexePathArray)
        
        indexePathArray.removeAll()
    }
    
    func checkApplyJob(dataDic:NSNotification)
    {
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
        
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let appliedJobId = dataDictionary["jobId"] as! String
        
        let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "AppliedJobs", ["domainType":"" ,"jobId":appliedJobId,"userId":"1"])
        
        appliedJobsIdsArray.removeAll()
        
        if let managedObjects1 = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "AppliedJobs")
        {
            for appliedJobObject in managedObjects1 as! [AppliedJobs]
            {
                let jobId = appliedJobObject.jobId
                
                appliedJobsIdsArray.append(Int64(jobId!)!)
            }
        }
        
        self.collectionView.reloadItems(at: indexePathArray)
        
        indexePathArray.removeAll()
        
        //self.collectionView.reloadData()
        
        
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    func popViewController() -> Void
    {
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        savedJobsIdsArray.removeAll()
//        if let managedObjects = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "SavedJobs")
//        {
//            for savedJobObject in managedObjects as! [SavedJobs]
//            {
//                let jobId = savedJobObject.jobId
//                
//                savedJobsIdsArray.append(Int64(jobId!)!)
//            }
//        }
//        
//        //let managedObjects1 = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "AppliedJobs")
//        appliedJobsIdsArray.removeAll()
//        if let managedObjects1 = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "AppliedJobs")
//        {
//            for appliedJobObject in managedObjects1 as! [AppliedJobs]
//            {
//                let jobId = appliedJobObject.jobId
//                
//                appliedJobsIdsArray.append(Int64(jobId!)!)
//            }
//        }

        if notificationSegment.selectedSegmentIndex == 0
        {
            if jobNotificationObjectsArray != nil
            {
                if jobNotificationObjectsArray?.count == 0
                {
                    dataNotFoundLabel.isHidden = false
                }
                else
                {
                    dataNotFoundLabel.isHidden = true
                    
                }
                
                return jobNotificationObjectsArray!.count
            }
            else
            {
                if jobNotificationObjectsArray?.count == 0
                {
                    dataNotFoundLabel.isHidden = false
                }
                else
                {
                    dataNotFoundLabel.isHidden = true
                    
                }
                
                return 0
            }

        }
        else
        {
            if specialNotificationObjectsArray != nil
            {
                if specialNotificationObjectsArray?.count == 0
                {
                    dataNotFoundLabel.isHidden = false
                }
                else
                {
                    dataNotFoundLabel.isHidden = true
                    
                }
                
                return specialNotificationObjectsArray!.count
            }
            else
            {
                if specialNotificationObjectsArray?.count == 0
                {
                    dataNotFoundLabel.isHidden = false
                }
                else
                {
                    dataNotFoundLabel.isHidden = true
                    
                }
                
                return 0
            }

        }
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        let subjectLabel = cell.viewWithTag(101) as! UILabel
        
        let applyButton = cell.viewWithTag(102) as! subclassedUIButton
        
        let saveButton = cell.viewWithTag(103) as! subclassedUIButton
        
        let saveImageView = cell.viewWithTag(104) as! UIImageView
        
        applyButton.isHidden = true
        saveButton.isHidden = true
        
        applyButton.isEnabled = false
        saveButton.isEnabled = false

        saveImageView.isHidden = true

        let dateLabel = cell.viewWithTag(105) as! UILabel

        
        if notificationSegment.selectedSegmentIndex == 0
        {
            let notificationObject = jobNotificationObjectsArray![indexPath.row]
            
            subjectLabel.text = notificationObject.subject!
            
            let date = String(describing: notificationObject.notificationDate1!).components(separatedBy: " ")[0] as! String
            
            dateLabel.text = date
        }
        else
        {
            
            let notificationObject = specialNotificationObjectsArray![indexPath.row]

            subjectLabel.text = notificationObject.subject!
            
            let date = String(describing: notificationObject.notificationDate!).components(separatedBy: " ")[0] as! String
            
            dateLabel.text = date
        }
        

        
        
  //      let jobId = notificationObject.jobId
        
//        if appliedJobsIdsArray.contains(jobId)
//        {
//            applyButton.setTitle("Applied", for: .normal)
//            applyButton.setTitleColor(UIColor.white, for: .normal)
//            applyButton.backgroundColor = UIColor.appliedJobGreenColor()
//            applyButton.isUserInteractionEnabled = false
//        }
//        else
//        {
//            applyButton.setTitle("Apply", for: .normal)
//            applyButton.setTitleColor(UIColor.white, for: .normal)
//            applyButton.backgroundColor = UIColor.appBlueColor()
//            applyButton.isUserInteractionEnabled = true
//        }
//        if savedJobsIdsArray.contains(jobId)
//        {
//            saveImageView.image = UIImage(named: "SideMenuSavedJob")
//            saveButton.isUserInteractionEnabled = false
//            
//        }
//        else
//        {
//            saveImageView.image = UIImage(named: "SavedUnselected")
//            saveButton.isUserInteractionEnabled = true
//            
//        }
//
//        saveButton.jobId = notificationObject.jobId
//        applyButton.jobId = notificationObject.jobId
//        
//        //applyButton.tag = jobId as! Int
//        saveButton.indexPath = indexPath.row
//        applyButton.indexPath = indexPath.row
//        
//        saveButton.addTarget(self, action: #selector(saveJobButtonClicked), for: UIControlEvents.touchUpInside)
//        applyButton.addTarget(self, action: #selector(applyJobButtonClicked), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width*0.95, height: 100)
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // handle tap events
        let notificationObj = commonNotificationObjectsArray?[indexPath.row]
        let jobId = notificationObj?.jobId
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewJobsViewController") as! NewJobsViewController
        if savedJobsIdsArray.contains(jobId!)
        {
            vc.saved = true
        }
        if appliedJobsIdsArray.contains(jobId!)
        {
            vc.applied = true
        }
        vc.verticalId = String(0)
        vc.domainType = "vertical"
        let jobId1 = String(describing: jobId!)
        vc.jobId = jobId1
        self.present(vc, animated: true, completion: nil)
        print("You selected cell #\(indexPath.item)!")
        
    }
    
    func saveJobButtonClicked(_ sender: subclassedUIButton)
    {
        AppPreferences.sharedPreferences().showHudWith(title: "Saving Job", detailText: "Please wait..")
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        indexePathArray.append(IndexPath.init(row: sender.indexPath, section: 0))

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
        AppPreferences.sharedPreferences().showHudWith(title: "Applying for job", detailText: "Please wait..")
        
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        indexePathArray.append(IndexPath.init(row: sender.indexPath, section: 0))

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
