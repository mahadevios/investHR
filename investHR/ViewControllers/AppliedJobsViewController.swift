//
//  AppliedJobsViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class AppliedJobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{

    @IBOutlet weak var collectionView: UICollectionView!
    var verticalJobListArray:[AnyObject] = []

    @IBOutlet weak var dataNotFoundLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItem.Style.done, target: self, action: #selector(popViewController))
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkRolesJobList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_APPLIED_JOB_LIST), object: nil)
        
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getAppliedJobs(username: username!, password: password!,linkedinId:"")
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getAppliedJobs(username:"", password:"",linkedinId:linkedInId!)
                
        }

//        let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
//        numberOfJobsLabel.textColor = UIColor(colorLiteralRed: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
//        numberOfJobsLabel.text = "108 jobs"
//        numberOfJobsLabel.textAlignment = NSTextAlignment.right
//        let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
//        
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        // Do any additional setup after loading the view.
    }
    
    @objc func deviceRotated()
    {
        self.collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.title = "Applied Jobs"

    }
    @objc func checkRolesJobList(dataDic:NSNotification)
    {
        let appliedJobsDict = dataDic.object as! [String:AnyObject]
        
        let codeString = String(describing: appliedJobsDict["code"]!)
        
        
        if codeString == "1001"
        {
            dataNotFoundLabel.isHidden = false
            
            //self.collectionView.reloadData()
            
            return
        }
        else
        {
            dataNotFoundLabel.isHidden = true
            
        }        
        let appliedJobsNumber = appliedJobsDict["appliedJobSize"] as? Int
        
        if appliedJobsNumber != nil
        {
            if appliedJobsNumber == 0
            {
                
            }
            else
                if appliedJobsNumber == 1

            {
                
                let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 25))
                numberOfJobsLabel.textColor = UIColor(red: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
                numberOfJobsLabel.text = "\(appliedJobsNumber!) job"
                numberOfJobsLabel.textAlignment = NSTextAlignment.right
                let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
                
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
            else
                {
                    let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 25))
                    numberOfJobsLabel.textColor = UIColor(red: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
                    numberOfJobsLabel.text = "\(appliedJobsNumber!) jobs"
                    numberOfJobsLabel.textAlignment = NSTextAlignment.right
                    let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
                    
                    self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
            

        }
        
        let appliedJobsListString = appliedJobsDict["appliedJobList"] as! String

        let jobData = appliedJobsListString.data(using: .utf8, allowLossyConversion: true)
        
        do {
            verticalJobListArray = try JSONSerialization.jsonObject(with: jobData!, options: .allowFragments) as! [AnyObject]
            
            if verticalJobListArray.count == 0
            {
                self.dataNotFoundLabel.isHidden = false
            }

            self.collectionView.reloadData()
        } catch let error as NSError
        {
            
        }
        
    }
    
    func setNumberOfJobs()
    {
        
    }
    
    @objc func popViewController() -> Void
    {
        NotificationCenter.default.removeObserver(self)

        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
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
        
        let appliedJobDateString = Date().getLocatDateFromMillisecods(millisecods: dateInt)
        appliedOnLabel.text = appliedJobDateString
       // applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
        //        applyButton.layer.cornerRadius = 3.0
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width*0.95, height: 120)
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        //print("You selected cell #\(indexPath.item)!")
        //print("You selected cell #\(indexPath.item)!")
        let jobDic = verticalJobListArray[indexPath.row] as! [String:AnyObject]
        let jobId = jobDic["jobId"] as! Int
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getSavedOrAppliedJobDescription(username: username!, password: password!, linkedinId: "", jobId: String(jobId))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getSavedOrAppliedJobDescription(username: "", password: "", linkedinId: linkedInId!,  jobId: String(jobId))
        }
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewJobsViewController") as! NewJobsViewController
        
        vc.appliedAndSaveHidden = true
        
        vc.jobId = "\(jobId)"
        
        
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
