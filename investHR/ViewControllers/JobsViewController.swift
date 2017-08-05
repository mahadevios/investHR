//
//  JobsViewController.swift
//  investHR
//
//  Created by mac on 26/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
//https://stackoverflow.com/questions/5137943/how-to-know-when-uitableview-did-scroll-to-bottom-in-iphone
class JobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate, UISearchResultsUpdating
{

    
    @IBOutlet weak var dataNotFoundLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var jobsArray:[String] = ["abc","bcd","cde","ghj"]
    var savedJobsIdsArray = [Int]()
    var appliedJobsIdsArray = [Int]()

    var searchController:UISearchController = UISearchController()
    @IBOutlet weak var searchBarView: UIView!
    var verticalJobListArray:[AnyObject] = []
    var verticalJobListCopyForPredicateArray:[AnyObject] = []

    var verticalId:String = ""
    var domainType:String = ""
    var stateId:String = ""
    var cityId:String = ""
    var activityView:UIActivityIndicatorView?
    var isLoading:Bool = false
    var isIndicatorAdded:Bool = false

    var indexePathArray:[IndexPath]=[]

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
        
         NotificationCenter.default.addObserver(self, selector: #selector(checkLocationJobList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_LOCATION_WISE_JOB), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(checkApplyJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_APPLY_JOB), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(checkSaveJob(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_JOB), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(getLoadMoreData(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_VERTICAL_JOB), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(getLoadMoreData(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_HORIZONTAL_JOB), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(getLoadMoreData(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_ROLE_JOB), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(getLoadMoreData(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_LOAD_MORE_LOCATION_JOB), object: nil)
        
         getJobList()

        
               // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        self.view.viewWithTag(200)?.isHidden = true
        
        //self.setSearchController()

        
        
        
        deviceRotated()


    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//    
//    }
    
    func deviceRotated()
    {
       
//            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
//            {
//                DispatchQueue.main.async
//                    {
//                        
//                    self.searchController.searchBar.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 50)
//
//                }
//                
//                
//
//            }
//    
//            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
//            {
                //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
//                DispatchQueue.main.async
//                    {
                       // self.searchBarView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 50)
                        self.searchController.searchBar.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 50)
                        
                        
                        
              //  }
            //}
    
        self.collectionView.reloadData()

    }
    
    func getJobList()
    {
    
        if self.domainType == "vertical"
        {
            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            
            if username != nil && password != nil
            {
                APIManager.getSharedAPIManager().getVerticalJobs(username: username!, password: password!, varticalId: String(verticalId), linkedinId:"")
            }
            else
                if linkedInId != nil
                {
                    APIManager.getSharedAPIManager().getVerticalJobs(username: "", password: "", varticalId: String(verticalId), linkedinId:linkedInId!)
                    
            }
            
            
        }
        else
            if self.domainType == "horizontal"
            {
                let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
                let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
                let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
                
                if username != nil && password != nil
                {
                    APIManager.getSharedAPIManager().getHorizontalJobs(username: username!, password: password!, horizontalId: String(verticalId), linkedinId:"")
                }
                else
                    if linkedInId != nil
                    {
                        APIManager.getSharedAPIManager().getHorizontalJobs(username: "", password: "", horizontalId: String(verticalId), linkedinId:linkedInId!)
                        
                }
                
                
            }
            else
                if self.domainType == "roles"
                {
                    let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
                    let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
                    let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
                    
                    if username != nil && password != nil
                    {
                        APIManager.getSharedAPIManager().getRoleJobs(username: username!, password: password!, roleId: String(verticalId), linkedinId:"")
                    }
                    else
                        if linkedInId != nil
                        {
                            APIManager.getSharedAPIManager().getRoleJobs(username: "", password: "", roleId: String(verticalId), linkedinId:linkedInId!)
                            
                    }
                    
                    
                }
                else
                    if self.domainType == "location"
                    {
                        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
                        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
                        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
                        var optionalCityId = ""
                        
                        if self.cityId == ""
                        {
                            optionalCityId = "0"
                        }
                        else
                        {
                            optionalCityId = self.cityId

                        }
                        if username != nil && password != nil
                        {
                            APIManager.getSharedAPIManager().getLocationJobs(username: username!, password: password!, linkedinId:"", stateId: self.stateId, cityId: optionalCityId)
                        }
                        else
                            if linkedInId != nil
                            {
                                APIManager.getSharedAPIManager().getLocationJobs(username: "", password: "", linkedinId:linkedInId!, stateId: self.stateId, cityId: optionalCityId)
                                
                        }
                        
                        
        }
       // AppPreferences.sharedPreferences().showHudWith(title: "Loading jobs", detailText: "Please wait..")

    
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        //NotificationCenter.default.removeObserver(self)
    }
    func setRightBarButtonItem(totalJobs:String!)
    {
      if totalJobs != nil
      {
        let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
        numberOfJobsLabel.textColor = UIColor(colorLiteralRed: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
        numberOfJobsLabel.text = totalJobs
        numberOfJobsLabel.textAlignment = NSTextAlignment.right
        let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
      }
    }
    
    func getLoadMoreData(dataDic:NSNotification)
    {
        
        //print("iscoming")
        isLoading = false

        isIndicatorAdded = false
        
        self.collectionView.collectionViewLayout.invalidateLayout()

        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        if dataDictionary["code"] as! String == Constant.FAILURE
        {
            return
        }
        print("not coming")

        var verticalJobListString = dataDictionary["verticalJobList"] as? String

        if verticalJobListString == nil
        {
            verticalJobListString = dataDictionary["horizontalJobList"] as? String
            
            if verticalJobListString == nil
            {
                verticalJobListString = dataDictionary["roleJobList"] as? String
                
                if verticalJobListString == nil
                {
                    return
                }
            }
            

        }
        
       // let totalJobsString = dataDictionary["totalCount"] as? Int
        
        //self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")
        //self.descriptionString = dataDictionary["discription"] as! String
        
        
        let verticalJobListData = verticalJobListString!.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            let loadMoreJobListArray = try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            var indexes:[IndexPath]=[]
            for item in verticalJobListArray.count ..< loadMoreJobListArray.count+verticalJobListArray.count
            {
                indexes.append(IndexPath(row: item, section: 0))
            }
            verticalJobListArray.append(contentsOf: loadMoreJobListArray)
            
            verticalJobListCopyForPredicateArray.append(contentsOf: loadMoreJobListArray)

            self.collectionView.insertItems(at: indexes)
            
            //self.collectionView.setNeedsDisplay()
        //    self.collectionView.reloadData()
            
        } catch let error as NSError
        {
            
        }

    
    }
    
    func checkVerticalJobList(dataDic:NSNotification)
    {
        //AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
          return
        }

        let codeString = String(describing: dataDictionary["code"]!)
        
        if codeString == "1001"
        {
            dataNotFoundLabel.isHidden = false
            
            return
        }
         let verticalJobListString = dataDictionary["verticalJobList"] as! String
        
        if let totalJobsString = dataDictionary["totalCount"] as? Int
        {
            if totalJobsString == 1
            {
                self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("job")")

            }
            else
            {
                self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")

            }
            
        }
        //self.descriptionString = dataDictionary["discription"] as! String

        
        let verticalJobListData = verticalJobListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            verticalJobListArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            verticalJobListCopyForPredicateArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()
            
            

        } catch let error as NSError
        {
            
        }
        
    }
    
    func checkHorizontalJobList(dataDic:NSNotification)
    {
        //AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let codeString = String(describing: dataDictionary["code"]!)
        
        if codeString == "1001"
        {
            dataNotFoundLabel.isHidden = false
            
            return
        }
        
        let verticalJobListString = dataDictionary["verticalJobList"] as! String
        
        if let totalJobsString = dataDictionary["totalCount"] as? Int
        {
            if totalJobsString == 1
            {
                self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("job")")
                
            }
            else
            {
                self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")
                
            }
        }
        //self.descriptionString = dataDictionary["discription"] as! String
        
        
        let verticalJobListData = verticalJobListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            verticalJobListArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            verticalJobListCopyForPredicateArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()
            
        } catch let error as NSError
        {
            
        }


        
    }

    func checkRolesJobList(dataDic:NSNotification)
    {
//        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let codeString = String(describing: dataDictionary["code"]!)
        
        if codeString == "1001"
        {
            dataNotFoundLabel.isHidden = false
            
            return
        }
        
        let verticalJobListString = dataDictionary["verticalJobList"] as! String
        
        if let totalJobsString = dataDictionary["totalCount"] as? Int
        {
            if totalJobsString == 1
            {
                self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("job")")
                
            }
            else
            {
                self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")
                
            }
        }
        //self.descriptionString = dataDictionary["discription"] as! String
        
        
        let verticalJobListData = verticalJobListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            verticalJobListArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            verticalJobListCopyForPredicateArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()
            
        } catch let error as NSError
        {
            
        }
        
    }
    
    func checkLocationJobList(dataDic:NSNotification)
    {
        //AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
        
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let codeString = String(describing: dataDictionary["code"]!)
        
        if codeString == "1001"
        {
            dataNotFoundLabel.isHidden = false
            
            return
        }
        let verticalJobListString = dataDictionary["JobList"] as! String
        
        if let totalJobsString = dataDictionary["totalCount"] as? Int
        {
            if totalJobsString == 1
            {
                self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("job")")
                
            }
            else
            {
                self.setRightBarButtonItem(totalJobs: "\(totalJobsString) \("jobs")")
                
            }
        }
        //self.descriptionString = dataDictionary["discription"] as! String
        
        
        let verticalJobListData = verticalJobListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            verticalJobListArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            verticalJobListCopyForPredicateArray =  try JSONSerialization.jsonObject(with: verticalJobListData as Data!, options: .allowFragments) as! [AnyObject]
            
            self.collectionView.reloadData()
            
        } catch let error as NSError
        {
            
        }
        
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
                
                savedJobsIdsArray.append(Int(jobId!)!)
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
                
                appliedJobsIdsArray.append(Int(jobId!)!)
            }
        }
        
        self.collectionView.reloadItems(at: indexePathArray)

        indexePathArray.removeAll()

        //self.collectionView.reloadData()
            
        
    }

    func popViewController() -> Void
    {
        //self.revealViewController().revealToggle(animated: true)
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.popViewController(animated: true)
    }

    func updateSearchResults(for searchController: UISearchController)
    {
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        let view = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter,
//                                                                        withReuseIdentifier:"Footer", for: indexPath)
//        
//        
//        return view
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//    {
//        return CGSize(width: self.collectionView.frame.size.width, height: 100)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath)
//    {
//        
//    }
    func setSearchController() -> Void
    {
        self.searchController = UISearchController(searchResultsController: nil)
        //self.searchController.searchResultsUpdater = self;
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
        self.searchController.searchBar.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 50)
        self.searchBarView.addSubview(self.searchController.searchBar)
        
        
        // Call sizeToFit() on the search bar so it fits nicely in the UIView
        //self.searchController.searchBar.sizeToFit()
        // For some reason, the search bar will extend outside the view to the left after calling sizeToFit. This next line corrects this.
        
        //self.searchController.searchBar.frame.size.width = self.view.frame.size.width
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
//        let predicate1 = [NSPredicate predicateWithFormat:"soNumber CONTAINS [cd] %@", self.searchController.searchBar.text];
        if self.searchController.searchBar.text == ""
        {
            verticalJobListArray.removeAll()

            verticalJobListArray.append(contentsOf: verticalJobListCopyForPredicateArray)

            self.collectionView.reloadData()
        }
        else
        {
            let predicate = NSPredicate(format: "subject CONTAINS [cd] %@", self.searchController.searchBar.text!)
        
            let resultArray = verticalJobListCopyForPredicateArray.filter { predicate.evaluate(with: $0) };

            //jobsArray.filter(predicate)
            verticalJobListArray.removeAll()
        
            verticalJobListArray.append(contentsOf: resultArray)
        
            self.collectionView.reloadData()
        
            print("resultArray = " + "\(resultArray)")
        }

        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        verticalJobListArray.removeAll()
        
        verticalJobListArray.append(contentsOf: verticalJobListCopyForPredicateArray)
        
        self.collectionView.reloadData()
    }
    
    
    
//    - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//    {
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    return view;
//    }
    
    
    
    func scrollViewDidScroll(_ aScrollView: UIScrollView)
    {
        let offset = aScrollView.contentOffset;
        let bounds = aScrollView.bounds;
        let size = aScrollView.contentSize;
        let inset = aScrollView.contentInset;
        let y = offset.y + bounds.size.height - inset.bottom;
        let h = size.height;
        // NSLog(@"offset: %f", offset.y);
        // NSLog(@"content.height: %f", size.height);
        // NSLog(@"bounds.height: %f", bounds.size.height);
        // NSLog(@"inset.top: %f", inset.top);
        // NSLog(@"inset.bottom: %f", inset.bottom);
        // NSLog(@"pos: %f of %f", y, h);
        
        let reload_distance = 10.0 as CGFloat
        if y > (h + reload_distance)
        {
            
            if isLoading == false
            {
                loadMoreData()

                isLoading = true

                self.collectionView.collectionViewLayout.invalidateLayout()

            }
            else
            {
               // isLoading = false

                //self.collectionView.collectionViewLayout.invalidateLayout()

            }
            

        }
    }
    // MARK: - UICollectionViewDelegate protocol
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
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
        
        return verticalJobListArray.count
    }

//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath)
//    {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath)
//    {
//    }
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return cache[indexPath.row]
//    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footerView1 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            switch kind
            {
                

                case UICollectionElementKindSectionFooter:
                    
//                    let attributes = collectionView.layoutAttributesForItem(at: indexPath)
//                    
//                    if attributes == nil
//                    {
                        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as UICollectionReusableView
                        
                        if isLoading == true && isIndicatorAdded == false
                        {
                            if footerView.viewWithTag(123) != nil
                            {
                                footerView.viewWithTag(123)?.removeFromSuperview()
                            }
                            activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                            activityView!.frame = CGRect(x: self.view.center.x, y: 10, width: 30, height: 30)
                            //activityView.frame = footerView.center
                            activityView!.startAnimating()
                            
                            activityView!.tag = 123
                            
                            isIndicatorAdded = true
                            
                            footerView.bringSubview(toFront: activityView!)
                            footerView.addSubview(activityView!)
                        }
                        else
                        {

                            if activityView != nil
                            {
                                activityView!.removeFromSuperview()
                                
                            }
                            isIndicatorAdded = false

                        }
                        
                        
                        //footerView.backgroundColor = UIColor.green;
                        return footerView

//                    }
//                    else
//                    {
//                        return attributes?.representedElementKind
//                    }
                
            case UICollectionElementKindSectionHeader:
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) 
                
                headerView.backgroundColor = UIColor.blue;
                return headerView
                
            default:
                return footerView1
//                assert(false, "Unexpected element kind")
            }
        return footerView1

    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        if isLoading
        {
            return CGSize(width: self.collectionView.frame.size.width, height: 50)

        }
        else
        {
            return CGSize(width: 1, height: 1)

        }


    }
    // make a cell for each cell index path
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
//    {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        
//    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
       
//        if indexPath.row == verticalJobListArray.count-1
//        {
//            //footerView.isHidden = true
//            loadMoreData()
//            isLoading = true
//            self.collectionView.collectionViewLayout.invalidateLayout()
//        }
//        else
//        {
//            //footerView.isHidden = false
//            
//        }

        
       
        let subjectLabel = cell.viewWithTag(101) as! UILabel
        subjectLabel.isUserInteractionEnabled = false
        //let companyWebSiteLabel = cell.viewWithTag(102) as! UILabel
        let applyButton = cell.viewWithTag(103) as! subclassedUIButton
        let saveButton = cell.viewWithTag(104) as! subclassedUIButton
        let saveImageView = cell.viewWithTag(105) as! UIImageView
        let dateLabel = cell.viewWithTag(106) as! UILabel
        //let descriptionWebView = cell.viewWithTag(107) as! UIWebView

        let jobDic = verticalJobListArray[indexPath.row] as! [String:AnyObject]
        
        let subject = jobDic["subject"] as! String
        
        subjectLabel.text = subject
        
        let jobId = jobDic["jobid"] as! Int
        
        if let date = jobDic["date"] as? Double
        {
            if let dateString = Date().getLocatDateFromMillisecods(millisecods: date)
            {
                dateLabel.text = dateString.components(separatedBy: " ")[0]

            }
        }
        
        
        //let discription = jobDic["discription"] as! String
        
        //descriptionWebView.loadHTMLString(discription, baseURL: nil)
        
        //let location = jobDic["location"] as! String
        
        //companyWebSiteLabel.text = location
        
        saveButton.accessibilityHint = String(indexPath.row)
        
        if appliedJobsIdsArray.contains(jobId)
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
           // applyButton.isUserInteractionEnabled = true
            applyButton.isEnabled = true

        }
        if savedJobsIdsArray.contains(jobId)
        {
            saveImageView.image = UIImage(named: "SideMenuSavedJob")
            //saveButton.isUserInteractionEnabled = false
            saveButton.isEnabled = false

        }
        else
        {
            saveImageView.image = UIImage(named: "SavedUnselected")
            //saveButton.isUserInteractionEnabled = true
            saveButton.isEnabled = true

        }


        saveButton.jobId = Int64(jobId)
        applyButton.jobId = Int64(jobId)

        //applyButton.tag = jobId as! Int
        saveButton.indexPath = indexPath.row
        applyButton.indexPath = indexPath.row

        saveButton.addTarget(self, action: #selector(saveJobButtonClicked), for: UIControlEvents.touchUpInside)
        applyButton.addTarget(self, action: #selector(applyJobButtonClicked), for: UIControlEvents.touchUpInside)

        //applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        
        let jobDic = verticalJobListArray[indexPath.row] as! [String:AnyObject]
        let jobId = jobDic["jobid"] as! Int

        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewJobsViewController") as! NewJobsViewController
        if savedJobsIdsArray.contains(jobId)
        {
            vc.saved = true
        }
        if appliedJobsIdsArray.contains(jobId)
        {
            vc.applied = true
        }
        vc.verticalId = String(verticalId)
        vc.domainType = self.domainType
        vc.jobId = String(jobId)
        self.present(vc, animated: true, completion: nil)
        
//        AppPreferences.sharedPreferences().showHudWith(title: "Loading job..", detailText: "Please wait")

        print("You tapped cell number \(indexPath.row).")
        
    }
    
    func loadMoreData()
    {
        var existingJobIdsArray:[String] = []
        for index in 0 ..< verticalJobListCopyForPredicateArray.count
        {
            let jobDic = verticalJobListCopyForPredicateArray[index] as! [String:AnyObject]
            
            existingJobIdsArray.append(String(jobDic["jobid"] as! Int) as String)
            
        }
        
        var existingJobIdsString = ""
        
        for index in 0 ..< existingJobIdsArray.count
        {
            
                if index == 0
                {
                    existingJobIdsString.append(existingJobIdsArray[index])
                }
                else
                {
                    existingJobIdsString.append(",\(existingJobIdsArray[index])")
                }
            
        }
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String

        switch self.domainType
        {
            //let jobDic = verticalJobListArray[indexPath.row] as! [String:AnyObject]
            
           

            case "vertical":
            
                            if username != nil && password != nil
                            {
                                APIManager.getSharedAPIManager().getMoreVerticalJobs(username: username!, password: password!, linkedinId:"", varticalId: String(verticalId), jobId: existingJobIdsString)
                            }
                            else
                                if linkedInId != nil
                                {
                                    APIManager.getSharedAPIManager().getMoreVerticalJobs(username: "", password: "", linkedinId:linkedInId!, varticalId: String(verticalId), jobId: existingJobIdsString)
                            }
                            break
            
            
        case "horizontal":
            
                            if username != nil && password != nil
                            {
                                APIManager.getSharedAPIManager().getMoreHorizontalJobs(username: username!, password: password!, linkedinId:"", horizontalId: String(verticalId), jobId: existingJobIdsString)
                            }
                            else
                                if linkedInId != nil
                                {
                                    APIManager.getSharedAPIManager().getMoreHorizontalJobs(username: "", password: "", linkedinId:linkedInId!, horizontalId: String(verticalId), jobId: existingJobIdsString)
                            }
                            break
            
        case "roles":
            
                            if username != nil && password != nil
                            {
                                APIManager.getSharedAPIManager().getMoreRoleJobs(username: username!, password: password!, linkedinId:"", roleId: String(verticalId), jobId: existingJobIdsString)
                            }
                            else
                                if linkedInId != nil
                                {
                                    APIManager.getSharedAPIManager().getMoreRoleJobs(username: "", password: "", linkedinId:linkedInId!, roleId: String(verticalId), jobId: existingJobIdsString)
                            }
                            break
            
        case "location":
                            var optionalCityId = ""

                            if self.cityId == ""
                            {
                                optionalCityId = "0"
                            }
                            else
                            {
                                optionalCityId = self.cityId
                
                            }
                            if username != nil && password != nil
                            {
                                APIManager.getSharedAPIManager().getMoreLocationJobs(username: username!, password: password!, linkedinId: "", jobId: existingJobIdsString, stateId: self.stateId, cityId: optionalCityId)
                            }
                            else
                                if linkedInId != nil
                                {
                                    APIManager.getSharedAPIManager().getMoreLocationJobs(username: "", password: "", linkedinId: linkedInId!, jobId: existingJobIdsString, stateId: self.stateId, cityId: optionalCityId)
                                }
                            break
            
                            default:
                            break
        }
    
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
