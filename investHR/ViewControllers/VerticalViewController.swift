//
//  VerticalViewController.swift
//  investHR
//
//  Created by mac on 26/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class VerticalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet weak var domainTableView: UITableView!
    
    var domainType:String = ""
    
    var domainNameArray:[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;

        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        if self.domainType == "vertical"
        {
            domainNameArray = ["Banking & Financial Serivces","Insurance(P&C and Life & Annuity)","Healthcare Insurance","Healthcare Provider(Hospitals)","Pharma & Biotech","Life Sciences","Media & Entertainment & Gaming","Travel & Transportation & Hospitality","Manufacturing","Retail","Consumer Product Goods(CPG)","High Tech & ISV","Communication & Telecom","Aerospace","Oil and Gas","Utilities & Energy","Semi-Conductor","Logistics","Defence","Government & Public Sector","Education","Publishing","Medical Devices"]
            
            self.navigationItem.title = "Vertical"

        }
        else
            if self.domainType == "roles"
            {
                domainNameArray = ["Hunter or New Business Acquisation","Farner or Account Management or Client Partner","Leadership","Human Resources","Recriuter or Talent manager","Practice Manager","Program Manager","Delivery MAnager","Finance","Marketing"]
                
                self.navigationItem.title = "Roles"

            }
            else
                if self.domainType == "horizontal"
                {
                    domainNameArray = ["IT Services","Digital Services","Engineering Services","BPO","Staffing or Staff Augmentation","Inside Sales"]
                    
                    self.navigationItem.title = "Horizontal"

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
        
        let itemName = cell.viewWithTag(101) as! UILabel
        itemName.text = domainNameArray[indexPath.row]
                
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsViewController") as! JobsViewController
        
            self.navigationController?.pushViewController(vc, animated: true)
        
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
