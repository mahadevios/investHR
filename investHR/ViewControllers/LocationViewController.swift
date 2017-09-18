//
//  LocationViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import CoreData

class LocationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchResultsUpdating {

    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
   
    var locationsArray:[String] = []
    var locationAreaArray:[String] = []
    //var selectedCollectionCell = 0
    var selectedTableViewCell:Int? = 0
    
    var statesArray:[String] = []
    var statesCopyForPredicateArray:[String] = []
    var cityArray:[String] = []
    var stateNameAndIdDic = [String:Int16]()
    var cityNameAndIdDic = [String:Int64]()
    
    @IBOutlet weak var searchBarView: UIView!
    var searchController:UISearchController = UISearchController()

    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        
       // locationAreaArray = ["East Coast","Midwest","West Coast"]
       // locationsArray = ["NYC","NJ","Boston","Raleigh","Philadelphia","Pittsburg","Detroit","Others"]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Location"
        
        //self.cityArray.removeAll()
        
        self.getState()

        self.setSearchController()
        //self.getCitiesFromState(stateName: statesArray[0] as! String)

        // Do any additional setup after loading the view.
    }

//    func setLocationAreas() -> Void
//    {
//        let locationAreasView = self.view.viewWithTag(101)
//        for i in 0 ..< 4
//        {
//            let button = UIButton(frame: CGRect(x: 0, y: 0, width: (locationAreasView?.frame.size.width)!, height: 70))
//            
//            let lineView = UIView(frame: CGRect(x: , y: button.frame.size.height, width: (locationAreasView?.frame.size.width)!, height: 70))
//            
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        deviceRotated()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        
    }
    func popViewController() -> Void
    {
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.popViewController(animated: true)
    }
    
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
        DispatchQueue.main.async
            {
                self.searchController.searchBar.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 50)
                
        }
        //}
        
        //self.collectionView.reloadData()
        
    }
    

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
        if self.searchController.searchBar.text == ""
        {
            statesArray.removeAll()
            
            statesArray.append(contentsOf: statesCopyForPredicateArray)
            
            self.tableView.reloadData()
        }
        else
        {
//            let predicate = NSPredicate(format: "subject CONTAINS [cd] %@", self.searchController.searchBar.text!)
            self.selectedTableViewCell = nil
            
            let predicate = NSPredicate(format: "self CONTAINS [cd] %@", self.searchController.searchBar.text!)
            
            let resultArray = statesCopyForPredicateArray.filter { predicate.evaluate(with: $0) };
            
            //jobsArray.filter(predicate)
            statesArray.removeAll()
            
            statesArray.append(contentsOf: resultArray)
            
            self.tableView.reloadData()
            
//            print("resultArray = " + "\(resultArray)")
        }
        
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        statesArray.removeAll()
        
        statesArray.append(contentsOf: statesCopyForPredicateArray)
        
        self.tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController)
    {
        
    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        return statesArray.count
//    }
//    
//    // make a cell for each cell index path
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 0
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        
//        // get a reference to our storyboard cell
//        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
//        
//        //cell.viewWithTag(201)?.removeFromSuperview()
//        //cell.layoutSubviews()
////        if cell.viewWithTag(102) != nil
////        {
////            cell.viewWithTag(102)?.removeFromSuperview()
////        }
//        if indexPath.row == statesArray.count-1
//        {
//            cell.viewWithTag(103)?.isHidden = true
//        }
//        else
//        {
//            cell.viewWithTag(103)?.isHidden = false
//
//        }
//        
//        //let locationAreaLabel = UILabel(frame: CGRect(x: cell.frame.origin.x+10, y: cell.frame.origin.y+15, width: 80, height: 30))
//        
//        let locationAreaLabel = cell.viewWithTag(201) as! UILabel
//        
//        locationAreaLabel.text = statesArray[indexPath.row]
//
//        //locationAreaLabel.tag = 102
//        
//        if indexPath.row == selectedCollectionCell
//        {
//            cell.backgroundColor = UIColor.white
//            locationAreaLabel.textColor = UIColor(red: 30/255.0, green: 129/255.0, blue: 239/255.0, alpha: 1)
//        }
//        else
//        {
//            cell.backgroundColor = UIColor(red: 30/255.0, green: 129/255.0, blue: 239/255.0, alpha: 1)
//            locationAreaLabel.textColor = UIColor.white
//
//        }
//        
//        //cell.addSubview(locationAreaLabel)
//        
////        let companyWebSiteLabel = cell.viewWithTag(102) as! UILabel
////        let applyButton = cell.viewWithTag(103) as! UIButton
////        
////        applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
//        //        applyButton.layer.cornerRadius = 3.0
//        
//        // Use the outlet in our custom class to get a reference to the UILabel in the cell
//        
//        return cell
//    }
//    
////    override func viewWillLayoutSubviews()
////    {
////        super.viewWillLayoutSubviews()
////        self.collectionView.collectionViewLayout.invalidateLayout()
////    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        //let cell = self.collectionView.cellForItem(at: indexPath)
//        
//        let cell = collectionView.cellForItem(at: indexPath)
//
//        let stateNameLabel = cell?.viewWithTag(201) as! UILabel
//        
//        self.cityArray.removeAll()
//
//        self.getCitiesFromState(stateName: stateNameLabel.text!)
//        
//        selectedCollectionCell = indexPath.row
//        
//        selectedTableViewCell = nil
//        
//        self.collectionView.reloadData()
//        
//        self.tableView.reloadData()
//    }
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        return CGSize(width: self.collectionView.frame.size.width, height: 70)
//    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return statesArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        // set the text from the data model
        
//        let menuImageView = cell.viewWithTag(101) as! UIImageView
//        menuImageView.image = UIImage(named: locationsArray[indexPath.row])
        
        
        let locationLabel = cell.viewWithTag(104) as! UILabel
        locationLabel.text = statesArray[indexPath.row]
//        if indexPath.row == selectedTableViewCell
//        {
//            locationLabel.textColor = UIColor(red: 24/255.0, green: 127/255.0, blue: 239/255.0, alpha: 1)
//        }
//        else
//        {
//            locationLabel.textColor = UIColor(red: 85/255.0, green: 100/255.0, blue: 107/255.0, alpha: 1)
//
//        }
        
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        selectedTableViewCell = indexPath.row
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsViewController") as! JobsViewController
        
        let locationLabel = cell?.viewWithTag(104) as! UILabel

        let stateId = stateNameAndIdDic[locationLabel.text!]
        
        vc.stateId = String(describing: stateId!)
        
        //        if selectedTableViewCell != nil
        //        {
        //            vc.cityId = String(selectedTableViewCell! + 1)
        //
        //        }
        //        else
        //        {
        //            vc.cityId = ""
        //        }
        
        vc.domainType = "location"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.tableView.reloadData()
        
    }
    
    func getState()
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.getAllRecords(entity: "State")
            for userObject in managedObjects as! [State]
            {
                statesArray.append(userObject.stateName!)
                
                stateNameAndIdDic[userObject.stateName!] = userObject.id
                
                statesCopyForPredicateArray.append(userObject.stateName!)
                
            }
            
//            let index = statesArray.index(of: "asda")
//            
//            if index != nil
//            {
//                statesArray.remove(at: index!)
//            }
            
        } catch let error as NSError
        {
//            print(error.localizedDescription)
        }
        
        
    }
    
//    func getCitiesFromState( stateName:String)
//    {
//        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
//        
//        do
//        {
//            var managedObjects:[NSManagedObject]?
//            
//            managedObjects = coreDataManager.fetchCitiesFromStateId(entity: "City", stateId: Int16(stateNameAndIdDic[stateName]!))
//            for userObject in managedObjects as! [City]
//            {
//                cityArray.append(userObject.cityName!)
//                
//                cityNameAndIdDic[userObject.cityName!] = userObject.id
//                //stateNameAndIdDic[userObject.stateName!] = userObject.id as AnyObject?
//                
//            }
//            
//        } catch let error as NSError
//        {
//            print(error.localizedDescription)
//        }
//        
//    }

    @IBAction func viewJobButtonClicked(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsViewController") as! JobsViewController
        
        
        vc.stateId = String(selectedTableViewCell! + 1)
        
//        if selectedTableViewCell != nil
//        {
//            vc.cityId = String(selectedTableViewCell! + 1)
//
//        }
//        else
//        {
//            vc.cityId = ""
//        }

        vc.domainType = "location"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
