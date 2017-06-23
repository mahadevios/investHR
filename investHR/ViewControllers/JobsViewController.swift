//
//  JobsViewController.swift
//  investHR
//
//  Created by mac on 26/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class JobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate, UISearchResultsUpdating
{

    
    @IBOutlet weak var collectionView: UICollectionView!
    var jobsArray:[String] = ["abc","bcd","cde","ghj"]
    var searchController:UISearchController = UISearchController()
    @IBOutlet weak var searchBarView: UIView!
    var verticalJobListArray:[AnyObject] = []
    var savedJobsArray:[Int] = []
    var verticalId:String = ""
    @IBOutlet weak var saveJobImage: UIImageView!
    
    
//    @property (nonatomic, strong) NSArray *search;
    override func viewDidLoad()
    {
    
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Jobs"
        
       self.setRightBarButtonItem(totalJobs: "")
//self.navigationItem.rightBarButtonItem.
        self.setSearchController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkVerticalJobList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_VERTICAL_JOB_LIST), object: nil)

         NotificationCenter.default.addObserver(self, selector: #selector(checkHorizontalJobList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_HORIZONTAL_JOB_LIST), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(checkRolesJobList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_ROLE_JOB_LIST), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSaveJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_APPLY_JOB), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkApplyJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_JOB), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func setRightBarButtonItem(totalJobs:String)
    {
        let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
        numberOfJobsLabel.textColor = UIColor(colorLiteralRed: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
        numberOfJobsLabel.text = totalJobs
        numberOfJobsLabel.textAlignment = NSTextAlignment.right
        let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func checkVerticalJobList(dataDic:NSNotification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
          return
        }

         let verticalJobListString = dataDictionary["verticalJobList"] as! String
        
        let totalJobsString = dataDictionary["totalCount"] as! Int

        self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")
        //self.descriptionString = dataDictionary["discription"] as! String

        
        let verticalJobListData = verticalJobListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            verticalJobListArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()

        } catch let error as NSError
        {
            
        }
        
    }
    
    func checkHorizontalJobList(dataDic:NSNotification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let verticalJobListString = dataDictionary["verticalJobList"] as! String
        
        let totalJobsString = dataDictionary["totalCount"] as! Int
        
        self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")
        //self.descriptionString = dataDictionary["discription"] as! String
        
        
        let verticalJobListData = verticalJobListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            verticalJobListArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()
            
        } catch let error as NSError
        {
            
        }


        
    }

    func checkRolesJobList(dataDic:NSNotification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let verticalJobListString = dataDictionary["verticalJobList"] as! String
        
        let totalJobsString = dataDictionary["totalCount"] as! Int
        
        self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")
        //self.descriptionString = dataDictionary["discription"] as! String
        
        
        let verticalJobListData = verticalJobListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            verticalJobListArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()
            
        } catch let error as NSError
        {
            
        }
        
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
    }

    func checkApplyJob(dataDic:NSNotification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let verticalJobListString = dataDictionary["verticalJobList"] as! String
        
        let totalJobsString = dataDictionary["totalCount"] as! Int
        
        self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")
        //self.descriptionString = dataDictionary["discription"] as! String
        
        
        let verticalJobListData = verticalJobListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            verticalJobListArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()
            
        } catch let error as NSError
        {
            
        }
        
    }

    func popViewController() -> Void
    {
        //self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }

    func updateSearchResults(for searchController: UISearchController)
    {
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        let view = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
//                                                                        withReuseIdentifier:"header", for: indexPath)
//        
//        
//
//        //let view1 = UIView(frame: CGRect(x: 10, y: 10, width: 300, height: 200))
//        //view1.backgroundColor = UIColor.blue
////        self.searchController.searchBar.delegate = self
////        self.searchController.searchBar.frame = CGRect(x: 0, y: 10, width: 300, height: 200)
////        view.addSubview(self.searchController.searchBar)
//        
//        //let serachBar:UICollectionReusableView = self.searchController.searchBar as! UICollectionReusableView
//        
//        return view
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//    {
//        return CGSize(width: self.collectionView.frame.size.width, height: 100)
//    }
    func setSearchController() -> Void
    {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self;
        self.searchController = UISearchController();
        self.searchController.searchResultsUpdater = self;
        self.searchController.searchBar.delegate = self;
        //self.collectionView.tableHeaderView = self.searchController.searchBar;
        self.definesPresentationContext = true;
        self.searchController.obscuresBackgroundDuringPresentation = true;
        self.searchController.hidesNavigationBarDuringPresentation=true;
        self.definesPresentationContext = true;
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false // Optional
        self.searchController.searchBar.delegate = self
        //self.searchController.searchBar.barTintColor = UIColor.white
        // Add the search bar as a subview of the UIView you added above the table view
        self.searchBarView.addSubview(self.searchController.searchBar)
        // Call sizeToFit() on the search bar so it fits nicely in the UIView
        //self.searchController.searchBar.sizeToFit()
        // For some reason, the search bar will extend outside the view to the left after calling sizeToFit. This next line corrects this.
        self.searchController.searchBar.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 50)
        //self.searchController.searchBar.frame.size.width = self.view.frame.size.width
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
//        let predicate1 = [NSPredicate predicateWithFormat:"soNumber CONTAINS [cd] %@", self.searchController.searchBar.text];
        
      let predicate = NSPredicate(format: "SELF CONTAINS [cd] %@", self.searchController.searchBar.text!)
        
       let resultArray = jobsArray.filter { predicate.evaluate(with: $0) };

        //jobsArray.filter(predicate)
        print(resultArray)
        
        }
    
//    - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//    {
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    return view;
//    }
    
    
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
        let companyWebSiteLabel = cell.viewWithTag(102) as! UILabel
        let applyButton = cell.viewWithTag(103) as! UIButton
        let saveButton = cell.viewWithTag(104) as! UIButton
        let saveImageView = cell.viewWithTag(105) as! UIImageView
        let dateLabel = cell.viewWithTag(106) as! UILabel
        //let descriptionWebView = cell.viewWithTag(107) as! UIWebView

        let jobDic = verticalJobListArray[indexPath.row] as! [String:AnyObject]
        
        let subject = jobDic["subject"] as! String
        
        subjectLabel.text = subject
        
        let jobId = jobDic["jobid"]
        
        let date = jobDic["date"] as! Double
        
        let dateString = Date().getLocatDateFromMillisecods(millisecods: date)
        
        dateLabel.text = dateString.components(separatedBy: " ")[0]
        
        //let discription = jobDic["discription"] as! String
        
        //descriptionWebView.loadHTMLString(discription, baseURL: nil)
        
        let location = jobDic["location"] as! String
        
        companyWebSiteLabel.text = location
        
        saveButton.accessibilityHint = String(indexPath.row)
        
        if savedJobsArray.contains(indexPath.row)
        {
            saveImageView.image = UIImage(named: "SideMenuSavedJob")
        }
        else
        {
            saveImageView.image = UIImage(named: "SavedUnselected")
        }
        //saveButton.tag = indexPath.row
        saveButton.tag = jobId as! Int
        applyButton.tag = jobId as! Int

        saveButton.addTarget(self, action: #selector(saveJobButtonClicked), for: UIControlEvents.touchUpInside)
        applyButton.addTarget(self, action: #selector(applyJobButtonClicked), for: UIControlEvents.touchUpInside)

        applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
//        applyButton.layer.cornerRadius = 3.0

//        for index in 0 ..< verticalJobListArray.count
//        {
        
        
        //}
        
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
        print("You selected cell #\(indexPath.item)!")
        let jobDic = verticalJobListArray[indexPath.row] as! [String:AnyObject]
        let jobId = jobDic["jobid"]

        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getJobDescription(username: username!, password: password!, linkedinId: "", varticalId: verticalId, jobId: String(describing: jobId!))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getJobDescription(username: "", password: "", linkedinId: linkedInId!, varticalId: verticalId, jobId: String(describing: jobId!))
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewJobsViewController") as! NewJobsViewController
        vc.verticalId = String(verticalId)
        self.present(vc, animated: true, completion: nil)
        
        print("You tapped cell number \(indexPath.row).")
        
    }
    
    
    func saveJobButtonClicked(_ sender: UIButton)
    {
//        let hint = Int(sender.accessibilityHint! as String)!
//        
//        if let elementIndex = savedJobsArray.index(of: hint)
//        {
//            savedJobsArray.remove(at: elementIndex)
//        }
//        else
//        {
//            savedJobsArray.append(hint)
//        }
//        self.collectionView.reloadData()
        
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().saveJob(username: username!, password: password!, linkedinId: "", jobId: String(describing: sender.tag))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().saveJob(username: "", password: "", linkedinId: linkedInId!, jobId: String(describing: sender.tag))
        }

    }
    func applyJobButtonClicked(_ sender: UIButton)
    {
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().applyJob(username: username!, password: password!, linkedinId: "", jobId: String(describing: sender.tag))
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().applyJob(username: "", password: "", linkedinId: linkedInId!, jobId: String(describing: sender.tag))
        }

        //self.collectionView.reloadData()
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
