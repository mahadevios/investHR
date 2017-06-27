//
//  SavedJobsViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class SavedJobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{

    @IBOutlet weak var collectionView: UICollectionView!
    var verticalJobListArray:[AnyObject] = []
    var appliedJobsIdsArray = [Int]()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Jobs"
        
        let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
        numberOfJobsLabel.textColor = UIColor(colorLiteralRed: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
        numberOfJobsLabel.text = "108 jobs"
        numberOfJobsLabel.textAlignment = NSTextAlignment.right
        let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSAvedJobList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVED_JOB_LIST), object: nil)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(checkApplyJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_APPLY_JOB), object: nil)
        
        self.collectionView.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    func checkSAvedJobList(dataDic:Notification)
    {
        let appliedJobsDict = dataDic.object as! [String:AnyObject]
        
        //let appliedJobsNumber = appliedJobsDict["appliedJobSize"]
        
        let appliedJobsListString = appliedJobsDict["savedJobList"] as! String
        
        let jobData = appliedJobsListString.data(using: .utf8, allowLossyConversion: true)
        
        do {
            verticalJobListArray = try JSONSerialization.jsonObject(with: jobData!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()
        } catch let error as NSError
        {
            
        }

    }
    func checkApplyJob(dataDic:NSNotification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let appliedJobId = dataDictionary["jobId"] as! String
        
        let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "AppliedJobs", ["domainType":"" ,"jobId":appliedJobId,"userId":"1"])
        
        appliedJobsIdsArray.removeAll()
        
        //        if let managedObjects1 = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "AppliedJobs")
        //        {
        //            for appliedJobObject in managedObjects1 as! [AppliedJobs]
        //            {
        //                let jobId = appliedJobObject.jobId
        //
        //                appliedJobsIdsArray.append(Int(jobId!)!)
        //            }
        //        }
        self.collectionView.reloadData()
        
        
    }

    func popViewController() -> Void
    {
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let managedObjects1 = CoreDataManager.getSharedCoreDataManager().getAllRecords(entity: "AppliedJobs")
        {
            for appliedJobObject in managedObjects1 as! [AppliedJobs]
            {
                let jobId = appliedJobObject.jobId
                
                appliedJobsIdsArray.append(Int(jobId!)!)
            }
        }
        return verticalJobListArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        let subjectLabel = cell.viewWithTag(101) as! UILabel
        let positionLabel = cell.viewWithTag(103) as! UILabel
        let appliedOnLabel = cell.viewWithTag(107) as! UILabel
        
        let appliedJobDict = verticalJobListArray[indexPath.row] as! [String:AnyObject]
        
        let subject = appliedJobDict["subject"] as! String
        subjectLabel.text = subject
        
        let position = appliedJobDict["position"] as! String
        positionLabel.text = position
        
        let dateInt = appliedJobDict["date"] as! Double
        
        let jobId = appliedJobDict["jobId"] as! Int

        let appliedJobDateString = Date().getLocatDateFromMillisecods(millisecods: dateInt)
        appliedOnLabel.text = appliedJobDateString
        
        let applyButton = cell.viewWithTag(108) as! subclassedUIButton
        
        if appliedJobsIdsArray.contains(jobId as! Int)
        {
            applyButton.setTitle("Applied", for: .normal)
            applyButton.setTitleColor(UIColor.init(colorLiteralRed: 7/255.0, green: 116/255.0, blue: 1/255.0, alpha: 1.0), for: .normal)
            applyButton.isUserInteractionEnabled = false
        }
        else
        {
            applyButton.setTitle("Apply", for: .normal)
            applyButton.setTitleColor(UIColor.init(colorLiteralRed: 54/255.0, green: 134/255.0, blue: 239/255.0, alpha: 1.0), for: .normal)
            applyButton.isUserInteractionEnabled = true
        }
        applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
        
        applyButton.jobId = jobId

        applyButton.addTarget(self, action: #selector(applyJobButtonClicked), for: UIControlEvents.touchUpInside)

        //        applyButton.layer.cornerRadius = 3.0
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width*0.95, height: 200)
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let jobDic = verticalJobListArray[indexPath.row] as! [String:AnyObject]
        let jobId = jobDic["jobId"] as! Int
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getSavedOrAppliedJobDescription(username: username!, password: password!, linkedinId: "", jobId: String( jobId))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getSavedOrAppliedJobDescription(username: "", password: "", linkedinId: linkedInId!,  jobId: String( jobId))
        }
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewJobsViewController") as! NewJobsViewController
       
        vc.saveHidden = true
        //vc.appliedAndSaveHidden = true
        if appliedJobsIdsArray.contains(jobId)
        {
            vc.applied = true
        }
        self.present(vc, animated: true, completion: nil)

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
