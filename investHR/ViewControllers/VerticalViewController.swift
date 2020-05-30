//
//  VerticalViewController.swift
//  investHR
//
//  Created by mac on 26/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

import CoreData

class VerticalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet weak var domainTableView: UITableView!
    
    var domainType:String = ""
    
    var domainNameArray:[String] = []
    
    var domainNameAndIdDic = [String:Int16]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItem.Style.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        if self.domainType == "vertical"
        {
            //domainNameArray = ["Banking & Financial Serivces","Insurance(P&C and Life & Annuity)","Healthcare Insurance","Healthcare Provider(Hospitals)","Pharma & Biotech","Life Sciences","Media & Entertainment & Gaming","Travel & Transportation & Hospitality","Manufacturing","Retail","Consumer Product Goods(CPG)","High Tech & ISV","Communication & Telecom","Aerospace","Oil and Gas","Utilities & Energy","Semi-Conductor","Logistics","Defence","Government & Public Sector","Education","Publishing","Medical Devices"]
            
            self.navigationItem.title = "Vertical"
            getdomainNames(type: "ZVERTCALDOMAINS")
        }
        else
            if self.domainType == "roles"
            {
                //domainNameArray = ["Hunter or New Business Acquisation","Farner or Account Management or Client Partner","Leadership","Human Resources","Recriuter or Talent manager","Practice Manager","Program Manager","Delivery MAnager","Finance","Marketing"]
                
                self.navigationItem.title = "Roles"

                getdomainNames(type: "ZROLES")

            }
            else
                if self.domainType == "horizontal"
                {
                    //domainNameArray = ["IT Services","Digital Services","Engineering Services","BPO","Staffing or Staff Augmentation","Inside Sales"]
                    
                    self.navigationItem.title = "Horizontal"

                    getdomainNames(type: "ZHORIZONTALDOMAINS")

                }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getItemList(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_VERTICAL_ITEMS), object: nil)
    }

//    override func viewWillAppear(_ animated: Bool)
//    {
//        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
//
//    }
    @objc func getItemList(dataDic:NSNotification)
    {
        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        let codeString = String(describing: dataDictionary["code"]!)
        
        if codeString == "1001"
        {
           // dataNotFoundLabel.isHidden = false
            
            return
        }
        
        let itemType = dataDictionary["type"] as! String

        
        let itemListString = dataDictionary["itemList"] as! String
        
        let itemListData = itemListString.data(using: .utf8, allowLossyConversion: true)
        
        do
        {
            let itemListArray =  try JSONSerialization.jsonObject(with: (itemListData as Data?)!, options: .allowFragments) as! [AnyObject]
            
            var itemIdKeyName = ""

            var itemKeyName = ""

            if itemType == "vertical"
            {
                itemIdKeyName = "vertical_id"
                itemKeyName = "vertical_name"
            }
            else
            if itemType == "horizontal"
            {
                itemIdKeyName = "horizontal_id"
                itemKeyName = "horizontal_name"

            }
            else
            if itemType == "roles"
            {
                itemIdKeyName = "role_id"
                itemKeyName = "role_name"
                    
            }
            for itemDic in itemListArray as! [NSDictionary]
            {
                let itemId = itemDic[itemIdKeyName] as! Int16
                
                let itemName = itemDic[itemKeyName] as! String
                
                domainNameArray.append(itemName)
                
                domainNameAndIdDic[itemName] = itemId
            }
            
            self.domainTableView.reloadData()
        }
        catch let error as NSError
        {
            
        }
        
        //domainNameArray.append(userObject.roleName!)
        
       // domainNameAndIdDic[userObject.roleName!] = userObject.roleId
    }
    
    func getdomainNames( type:String)
    {
        //let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        self.getItems()

//        do
//        {
//            //var managedObjects:[NSManagedObject]?
//            var managedObjects:[Role]?
//
//
//            //managedObjects = coreDataManager.getAllRecords(entity: type)
//            //self.getItems()
//
//            managedObjects = Database.sharedDatabse().getRolesVerticalHorizontal(type: type)
//
//            if type == "ZVERTCALDOMAINS"
//            {
//
//                for userObject in managedObjects!
//                {
//                    domainNameArray.append(userObject.roleName!)
//
//                    domainNameAndIdDic[userObject.roleName!] = userObject.roleId
//
//                }
//
//            }
//            else
//                if type == "ZHORIZONTALDOMAINS"
//                {
//                    for userObject in managedObjects!
//                    {
//                        domainNameArray.append(userObject.roleName!)
//
//                        domainNameAndIdDic[userObject.roleName!] = userObject.roleId
//
//                    }
//
//                }
//            else
//                    if type == "ZROLES"
//                    {
//                        for userObject in managedObjects!
//                        {
//                            domainNameArray.append(userObject.roleName!)
//
//                            domainNameAndIdDic[userObject.roleName!] = userObject.roleId
//
//                        }
//                    }
//        } catch let error as NSError
//        {
////            print(error.localizedDescription)
//        }
//
        
    }

    
    func getItems()
    {
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_USER_ID) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getVerticalItems(username: username!, password: password!, itemName: self.domainType, linkedinId: "")
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getVerticalItems(username: "", password: "", itemName: self.domainType, linkedinId: linkedInId!)
                
        }
        
    }
    
    @objc func popViewController() -> Void
    {
       // self.revealViewController().revealToggle(animated: true)
        NotificationCenter.default.removeObserver(self)

        self.navigationController?.popViewController(animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return domainNameArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.domainTableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        // set the text from the data model
        
        let itemNameLabel = cell.viewWithTag(101) as! UILabel
        itemNameLabel.text = domainNameArray[indexPath.row]
                
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //APIManager.getSharedAPIManager()
        let cell = tableView.cellForRow(at: indexPath)!
        
        let itemNameLabel = cell.viewWithTag(101) as! UILabel

        let itemName = itemNameLabel.text!
        
        let verticalId = domainNameAndIdDic[itemName]! 
        
        
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsViewController") as! JobsViewController
        
            vc.verticalId = String(verticalId)
        
            vc.domainType = self.domainType
        
            self.navigationController?.pushViewController(vc, animated: true)
        
//        AppPreferences.sharedPreferences().showHudWith(title: "Loading jobs..", detailText: "Please wait")

        
//            print("You tapped cell number \(indexPath.row).")
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
