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
    
    
//    var jobNotificationObjectsArray:[CommonNotification]?
    var jobNotificationObjectsArray:[JobsNotification]?

//    var specialNotificationObjectsArray:[ZSpecialNotification]?
    var specialNotificationObjectsArray:[GeneralNotification]?

    @IBOutlet weak var notificationSegment: UISegmentedControl!
    var indexePathArray:[IndexPath]=[]
    
    var savedJobsIdsArray = [Int64]()
    
    var closedJobsIdsArray = [Int64]()

    
    var appliedJobsIdsArray = [Int64]()

    lazy var database =
    {
    
            return Database.sharedDatabse()
    }
    @IBAction func notificationSegmentClicked(_ sender: UISegmentedControl)
    {
        self.getDataOfSegmennt(sender: sender)
    }
    
    func getDataOfSegmennt(sender: UISegmentedControl)
    {
        
        if sender.selectedSegmentIndex == 0
        {
            self.jobNotificationObjectsArray?.removeAll()
            
            //let database = Database.sharedDatabse()
            
            self.jobNotificationObjectsArray = database().getJobsNotification()
            
            //self.jobNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "CommonNotification") as? [CommonNotification]
            
            self.removeClosedJobs()
            
            self.collectionView.reloadData()
            
            
            
        }
        else
        {
            self.specialNotificationObjectsArray?.removeAll()
            
//            self.specialNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecordsOfSpecialNotification() as? [ZSpecialNotification]
            self.specialNotificationObjectsArray = database().getGeneralNotification()
            
            //let specialNotiCount = CoreDataManager.getSharedCoreDataManager().getUnreadNotiCount(entity: "ZSpecialNotification")
            
//            let specialNotiCount = database().getUnreadNotiCount(tableName: "SpecialNotification")
//
//            
//            if specialNotiCount > 0
//            {
//                self.notificationSegment.setTitle("General(\(specialNotiCount))", forSegmentAt: 1)
//                
//            }
//            else
//            {
//                self.notificationSegment.setTitle("General", forSegmentAt: 1)
//                
//            }
            self.collectionView.reloadData()
            
        }
        
        self.displayNotificationCount()

    }
    
    func displayNotificationCount()
    {
        let commonNotiCount = database().getUnreadNotiCount(tableName: "CommonNotification")
        
        
        if commonNotiCount > 0
        {
            self.notificationSegment.setTitle("Jobs(\(commonNotiCount))", forSegmentAt: 0)
            
        }
        else
        {
            self.notificationSegment.setTitle("Jobs", forSegmentAt: 0)
            
        }
        
        //let specialNotiCount = CoreDataManager.getSharedCoreDataManager().getUnreadNotiCount(entity: "ZSpecialNotification")
        let specialNotiCount = database().getUnreadNotiCount(tableName: "SpecialNotification")
        
        if specialNotiCount > 0
        {
            self.notificationSegment.setTitle("General(\(specialNotiCount))", forSegmentAt: 1)
            
        }
        else
        {
            self.notificationSegment.setTitle("General", forSegmentAt: 1)
            
        }
    
    }
    @IBOutlet weak var dataNotFoundLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItem.Style.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Notifications"
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkClosedJobList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_CLOSED_JOBIDS), object: nil)
        
        if AppPreferences.sharedPreferences().isReachable
        {
            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_USER_ID) as? String
            
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
            self.jobNotificationObjectsArray = database().getJobsNotification()

//            self.jobNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "CommonNotification") as? [CommonNotification]
            
            
            self.collectionView.reloadData()
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
      
        
//        NotificationCenter.default.addObserver(self, selector: #selector(checkApplyJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_APPLY_JOB), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(checkSaveJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_JOB), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newNotiAdded(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_NOTI_DATA_ADDED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    @objc func newNotiAdded(dataDic:Notification)
    {
        self.getDataOfSegmennt(sender: self.notificationSegment)
    }
    @objc func checkClosedJobList(dataDic:Notification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            
            return
        }
        
        let codeString = String(describing: dataDictionary["code"]!)
        
        self.jobNotificationObjectsArray?.removeAll()
        
        self.jobNotificationObjectsArray = database().getJobsNotification()

//        self.jobNotificationObjectsArray = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "CommonNotification") as? [CommonNotification]
        
        
        if codeString == "1001"
        {

            if self.jobNotificationObjectsArray?.count == 0
            {
                dataNotFoundLabel.isHidden = false
            }
            
            self.removeClosedJobs()

            self.collectionView.reloadData()
            
            return
        }
        
        let closedJobIdsString = dataDictionary["deletedJobId"] as! String
        
        let closedJobIdsData = closedJobIdsString.data(using: .utf8)
        
        do
        {
            self.closedJobsIdsArray = try JSONSerialization.jsonObject(with: closedJobIdsData!, options: .allowFragments) as! [Int64]
            
            
            

        } catch let error as NSError
        {
//            print(error.localizedDescription)
        }
        
        
//        self.jobNotificationObjectsArray = self.jobNotificationObjectsArray

        self.removeClosedJobs()
        
        self.collectionView.reloadData()


    }
    
    func removeClosedJobs()
    {
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
                    if self.closedJobsIdsArray.contains(notiObj.jobId!)
                    {
                        let index = self.jobNotificationObjectsArray?.index(of: notiObj)
                        
                        self.jobNotificationObjectsArray?.remove(at: index!)
                        
                    }
                }
                
            }
            
            
            // print(closedJobsIdsArray)
        }
        
        self.displayNotificationCount()
    }
    

    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func popViewController() -> Void
    {
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {

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
                
                    dataNotFoundLabel.isHidden = false
                
                
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
                
                dataNotFoundLabel.isHidden = false
                
                
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
            
            if notificationObject.readStatus == 0
            {
                subjectLabel.textColor = UIColor.black
            }
            else
            {
                subjectLabel.textColor = UIColor(red: 99/255.0, green: 126/255.0, blue: 140/255.0, alpha: 1.0)
            }
            
            let date = String(describing: notificationObject.notificationDate1!).components(separatedBy: " ")[0] as! String
            
            dateLabel.text = date
        }
        else
        {
            
            let notificationObject = specialNotificationObjectsArray![indexPath.row]

            subjectLabel.text = notificationObject.subject!
            
            if notificationObject.readStatus == 0
            {
                subjectLabel.textColor = UIColor.black
            }
            else
            {
                subjectLabel.textColor = UIColor(red: 99/255.0, green: 126/255.0, blue: 140/255.0, alpha: 1.0)
            }
            
            let date = String(describing: notificationObject.notificationDate!).components(separatedBy: " ")[0] as! String
            
            dateLabel.text = date
        }
        
        
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
        
        if AppPreferences.sharedPreferences().isReachable
        {
            if notificationSegment.selectedSegmentIndex == 0
            {
                let notificationObj = jobNotificationObjectsArray?[indexPath.row]
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
                
                if notificationObj?.readStatus == 0
                {
                    //CoreDataManager.getSharedCoreDataManager().updateNotificationReadStatus(entityName: "CommonNotification", notificationID: Int((notificationObj?.notificationId)!))
                    DispatchQueue.main.async
                    {
                        self.database().updateReadStatus(tableName: "CommonNotification", notificationId: Int((notificationObj?.notificationId)!))
                    }
                }
                
                
                vc.verticalId = String(0)
                vc.domainType = "vertical"
                let jobId1 = String(describing: jobId!)
                vc.jobId = jobId1
                vc.presentingVC = self
                self.present(vc, animated: true, completion: nil)
                
            }
            else
            {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MassNotificationViewController") as! MassNotificationViewController
                
                let notificationObj = specialNotificationObjectsArray?[indexPath.row]
                
                let notificationId = notificationObj?.notificationId1
                
                vc.notificationId = String(describing:notificationId!)
                
                if notificationObj?.readStatus == 0
                {
                    DispatchQueue.main.async
                        {
                            //CoreDataManager.getSharedCoreDataManager().updateNotificationReadStatus(entityName: "ZSpecialNotification", notificationID: Int((notificationObj?.notificationId1)!))

                            self.database().updateReadStatus(tableName: "SpecialNotification", notificationId: Int((notificationObj?.notificationId1)!))
                        }
                }
                vc.presentingVC = self

                self.present(vc, animated: true, completion: nil)
                
                
            }

        }
        else
        {
          AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your internet connection to access this feature", withCancelText: "Ok")
        }
        
//        print("You selected cell #\(indexPath.item)!")
        
    }
    
//    func saveJobButtonClicked(_ sender: subclassedUIButton)
//    {
//        AppPreferences.sharedPreferences().showHudWith(title: "Saving Job", detailText: "Please wait..")
//        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
//        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_USER_ID) as? String
//        
//        indexePathArray.append(IndexPath.init(row: sender.indexPath, section: 0))
//
//        if username != nil && password != nil
//        {
//            APIManager.getSharedAPIManager().saveJob(username: username!, password: password!, linkedinId: "", jobId: String(describing: sender.jobId!))
//        }
//        else
//            if linkedInId != nil
//            {
//                APIManager.getSharedAPIManager().saveJob(username: "", password: "", linkedinId: linkedInId!, jobId: String(describing: sender.jobId!))
//        }
//        
//    }
//    func applyJobButtonClicked(_ sender: subclassedUIButton)
//    {
//        AppPreferences.sharedPreferences().showHudWith(title: "Applying for job", detailText: "Please wait..")
//        
//        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
//        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_USER_ID) as? String
//        
//        indexePathArray.append(IndexPath.init(row: sender.indexPath, section: 0))
//
//        if username != nil && password != nil
//        {
//            APIManager.getSharedAPIManager().applyJob(username: username!, password: password!, linkedinId: "", jobId: String(describing: sender.jobId!))
//        }
//        else
//            if linkedInId != nil
//            {
//                APIManager.getSharedAPIManager().applyJob(username: "", password: "", linkedinId: linkedInId!, jobId: String(describing: sender.jobId!))
//        }
//        
//        //self.collectionView.reloadData()
//    }

    @objc func deviceRotated()
    {
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
