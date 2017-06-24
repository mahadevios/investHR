//
//  LocationViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import CoreData

class LocationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var locationsArray:[String] = []
    var locationAreaArray:[String] = []
    var selectedCollectionCell = 0
    var selectedTableViewCell:Int = 0
    
    var statesArray:[String] = []
    var cityArray:[String] = []
    var stateNameAndIdDic = [String:Int16]()
    var cityNameAndIdDic = [String:Int64]()
    
    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        
        locationAreaArray = ["East Coast","Midwest","West Coast"]
        locationsArray = ["NYC","NJ","Boston","Raleigh","Philadelphia","Pittsburg","Detroit","Others"]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Location"
        
        self.cityArray.removeAll()
        
        self.getState()

        self.getCitiesFromState(stateName: statesArray[0] as! String)

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
        
        
    }
    func popViewController() -> Void
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return statesArray.count
    }
    
    // make a cell for each cell index path
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        //cell.viewWithTag(201)?.removeFromSuperview()
        //cell.layoutSubviews()
//        if cell.viewWithTag(102) != nil
//        {
//            cell.viewWithTag(102)?.removeFromSuperview()
//        }
        if indexPath.row == statesArray.count-1
        {
            cell.viewWithTag(103)?.isHidden = true
        }
        else
        {
            cell.viewWithTag(103)?.isHidden = false

        }
        
        //let locationAreaLabel = UILabel(frame: CGRect(x: cell.frame.origin.x+10, y: cell.frame.origin.y+15, width: 80, height: 30))
        
        let locationAreaLabel = cell.viewWithTag(201) as! UILabel
        
        locationAreaLabel.text = statesArray[indexPath.row]

        //locationAreaLabel.tag = 102
        
        if indexPath.row == selectedCollectionCell
        {
            cell.backgroundColor = UIColor.white
            locationAreaLabel.textColor = UIColor(red: 30/255.0, green: 129/255.0, blue: 239/255.0, alpha: 1)
        }
        else
        {
            cell.backgroundColor = UIColor(red: 30/255.0, green: 129/255.0, blue: 239/255.0, alpha: 1)
            locationAreaLabel.textColor = UIColor.white

        }
        
        //cell.addSubview(locationAreaLabel)
        
//        let companyWebSiteLabel = cell.viewWithTag(102) as! UILabel
//        let applyButton = cell.viewWithTag(103) as! UIButton
//        
//        applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
        //        applyButton.layer.cornerRadius = 3.0
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        return cell
    }
    
//    override func viewWillLayoutSubviews()
//    {
//        super.viewWillLayoutSubviews()
//        self.collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //let cell = self.collectionView.cellForItem(at: indexPath)
        
        let cell = collectionView.cellForItem(at: indexPath)

        let stateNameLabel = cell?.viewWithTag(201) as! UILabel
        
        self.cityArray.removeAll()

        self.getCitiesFromState(stateName: stateNameLabel.text!)
        
        selectedCollectionCell = indexPath.row
        
        self.collectionView.reloadData()
        
        self.tableView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collectionView.frame.size.width, height: 70)
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cityArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        // set the text from the data model
        
//        let menuImageView = cell.viewWithTag(101) as! UIImageView
//        menuImageView.image = UIImage(named: locationsArray[indexPath.row])
        
        
        let locationLabel = cell.viewWithTag(104) as! UILabel
        locationLabel.text = cityArray[indexPath.row]
        if indexPath.row == selectedTableViewCell
        {
            locationLabel.textColor = UIColor(red: 24/255.0, green: 127/255.0, blue: 239/255.0, alpha: 1)
        }
        else
        {
            locationLabel.textColor = UIColor(red: 85/255.0, green: 100/255.0, blue: 107/255.0, alpha: 1)

        }
        
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let cell = tableView.cellForRow(at: indexPath)
        selectedTableViewCell = indexPath.row
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
                
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
    }
    
    func getCitiesFromState( stateName:String)
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.fetchCitiesFromStateId(entity: "City", stateId: Int16(stateNameAndIdDic[stateName]!))
            for userObject in managedObjects as! [City]
            {
                cityArray.append(userObject.cityName!)
                
                cityNameAndIdDic[userObject.cityName!] = userObject.id
                //stateNameAndIdDic[userObject.stateName!] = userObject.id as AnyObject?
                
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
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
