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
    func popViewController() -> Void
    {
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
        
        let applyButton = cell.viewWithTag(108) as! UIButton
        
        applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
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
