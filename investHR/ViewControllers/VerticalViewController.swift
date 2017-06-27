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

        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        if self.domainType == "vertical"
        {
            //domainNameArray = ["Banking & Financial Serivces","Insurance(P&C and Life & Annuity)","Healthcare Insurance","Healthcare Provider(Hospitals)","Pharma & Biotech","Life Sciences","Media & Entertainment & Gaming","Travel & Transportation & Hospitality","Manufacturing","Retail","Consumer Product Goods(CPG)","High Tech & ISV","Communication & Telecom","Aerospace","Oil and Gas","Utilities & Energy","Semi-Conductor","Logistics","Defence","Government & Public Sector","Education","Publishing","Medical Devices"]
            
            self.navigationItem.title = "Vertical"
            getdomainNames(type: "VertcalDomains")
        }
        else
            if self.domainType == "roles"
            {
                //domainNameArray = ["Hunter or New Business Acquisation","Farner or Account Management or Client Partner","Leadership","Human Resources","Recriuter or Talent manager","Practice Manager","Program Manager","Delivery MAnager","Finance","Marketing"]
                
                self.navigationItem.title = "Roles"

                getdomainNames(type: "Roles")

            }
            else
                if self.domainType == "horizontal"
                {
                    //domainNameArray = ["IT Services","Digital Services","Engineering Services","BPO","Staffing or Staff Augmentation","Inside Sales"]
                    
                    self.navigationItem.title = "Horizontal"

                    getdomainNames(type: "HorizontalDomains")

                }
        
    }

    func getdomainNames( type:String)
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.getAllRecords(entity: type)
            
            if type == "VertcalDomains"
            {
                for userObject in managedObjects as! [VertcalDomains]
                {
                    domainNameArray.append(userObject.verticalName!)
                    
                    domainNameAndIdDic[userObject.verticalName!] = userObject.verticalId
                    
                }

            }
            else
                if type == "HorizontalDomains"
                {
                    for userObject in managedObjects as! [HorizontalDomains]
                    {
                        domainNameArray.append(userObject.horizontalName!)
                        
                        domainNameAndIdDic[userObject.horizontalName!] = userObject.horizontalId
                        
                    }
                    
                }
            else
                    if type == "Roles"
                    {
                        for userObject in managedObjects as! [Roles]
                        {
                            domainNameArray.append(userObject.roleName!)
                            
                            domainNameAndIdDic[userObject.roleName!] = userObject.roleId
                            
                        }
                        
                    }
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
    }

    func popViewController() -> Void
    {
       // self.revealViewController().revealToggle(animated: true)

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
        let cell:UITableViewCell = self.domainTableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
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
        
        
//        if self.domainType == "vertical"
//        {
//            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
//            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
//
//            if username != nil && password != nil
//            {
//               APIManager.getSharedAPIManager().getVerticalJobs(username: username!, password: password!, varticalId: String(verticalId), linkedinId:"")
//            }
//            else
//                if linkedInId != nil
//                {
//                    APIManager.getSharedAPIManager().getVerticalJobs(username: "", password: "", varticalId: String(verticalId), linkedinId:linkedInId!)
//
//                }
//            
//            
//        }
//        else
//            if self.domainType == "horizontal"
//            {
//                let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
//                let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//                let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
//                
//                if username != nil && password != nil
//                {
//                    APIManager.getSharedAPIManager().getHorizontalJobs(username: username!, password: password!, horizontalId: String(verticalId), linkedinId:"")
//                }
//                else
//                    if linkedInId != nil
//                    {
//                        APIManager.getSharedAPIManager().getHorizontalJobs(username: "", password: "", horizontalId: String(verticalId), linkedinId:linkedInId!)
//                        
//                    }
//                
//                
//            }
//            else
//                if self.domainType == "roles"
//                {
//                    let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
//                    let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
//                    let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
//                    
//                    if username != nil && password != nil
//                    {
//                        APIManager.getSharedAPIManager().getRoleJobs(username: username!, password: password!, roleId: String(verticalId), linkedinId:"")
//                    }
//                    else
//                        if linkedInId != nil
//                        {
//                            APIManager.getSharedAPIManager().getRoleJobs(username: "", password: "", roleId: String(verticalId), linkedinId:linkedInId!)
//                            
//                        }
//                    
//                    
//            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsViewController") as! JobsViewController
        
            vc.verticalId = String(verticalId)
        
            vc.domainType = self.domainType
        
            self.navigationController?.pushViewController(vc, animated: true)
        
//        AppPreferences.sharedPreferences().showHudWith(title: "Loading jobs..", detailText: "Please wait")

        
            print("You tapped cell number \(indexPath.row).")
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
