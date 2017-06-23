//
//  NewJobsViewController.swift
//  investHR
//
//  Created by mac on 22/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class NewJobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    var verticalId:String = ""
    var jobLocationArray = [String]()
    var jobDetailsDic:[String:Any]?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(checkJobDescriptionResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_JOB_DESCRIPTION), object: nil)

        // Do any additional setup after loading the view.
    }

    func checkJobDescriptionResponse(dataDic:Notification) -> Void
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        guard let code = responseDic["code"] else {
            
            return
        }
        
        guard let verticalJobDetailsString = responseDic["VerticalJobDetails"] else {
            
            return
        }
        
        let jobDetailsData = verticalJobDetailsString.data(using: .utf8, allowLossyConversion: true)
        
        
        
        do
        {
             jobDetailsDic = try JSONSerialization.jsonObject(with: jobDetailsData!, options: .allowFragments) as? [String:Any]
        } catch let error as NSError
        {
            
        }
        
               let discription = jobDetailsDic?["discription"]
//        let state = jobDetailsDic?["state"]
//        let city = jobDetailsDic?["city"]

        guard let cityStateListString = responseDic["cityStateList"] else {
            
            return
        }
        
        let cityStateListData = cityStateListString.data(using: .utf8, allowLossyConversion: true)
        var cityStateArray:[Any]?

        do
        {
            cityStateArray = try JSONSerialization.jsonObject(with: cityStateListData!, options: .allowFragments) as? [Any]
            
            for index in 0 ..< cityStateArray!.count
            {
                let cityStateDic = cityStateArray![index] as? [String:String]
                
                let state = cityStateDic?["state"]
                
                let city = cityStateDic?["city"]
                
                jobLocationArray.append("\(state!)\(" ")\(city!)")

            }
            


        } catch let error as NSError
        {
            
        }
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        let companyNameLabel = cell.viewWithTag(101) as! UILabel
        //let companyWebSiteLabel = cell.viewWithTag(102) as! UILabel
        var locationLabel = cell.viewWithTag(105) as! UILabel

        let dateLabel = cell.viewWithTag(107) as! UILabel
        let descriptionWebView = cell.viewWithTag(109) as! UIWebView

        let applyButton = cell.viewWithTag(103) as! UIButton
        
        applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
        
        let jobId = jobDetailsDic?["jobId"]
        let relocation = jobDetailsDic?["relocation"]
        let date = jobDetailsDic?["date"] as? Double
        let subject = jobDetailsDic?["subject"]
        let location = jobDetailsDic?["location"]
        
        guard let discription = jobDetailsDic?["discription"]  as? String else
        {
            return cell
        }

        let dateString = Date().getLocatDateFromMillisecods(millisecods: date )
        companyNameLabel.text = subject as? String
        
        var jobLocationString:NSMutableString = ""
        
        for index in 0 ..< jobLocationArray.count
        {
            if index == 0
            {
                jobLocationString.append(jobLocationArray[index])
            }
            else
            {
                jobLocationString.append(",")

                jobLocationString.append(jobLocationArray[index])

            }
        }
        
        
        locationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        locationLabel.numberOfLines = 0
        //let cgrect = jobLocationString.boundingRect(with: CGSize.init(width: 50, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: locationLabel.font], context: nil)

        //locationLabel.frame = cgrect
        let height = heightForView(text: jobLocationString as String, font: UIFont.systemFont(ofSize: 14), width: self.view.frame.size.width*0.7) as CGFloat
        
        //let label = UILabel(frame:  CGRect(x: locationLabel.frame.origin.x, y: locationLabel.frame.origin.y, width: self.view.frame.size.width*0.5, height: height))
        locationLabel.frame = CGRect(x: locationLabel.frame.origin.x, y: locationLabel.frame.origin.y, width: self.view.frame.size.width*0.5, height: height)
        locationLabel.text = jobLocationString as String

        //let width = NSLayoutConstraint(item: locationLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)

        //locationLabel.addConstraint(width)


        descriptionWebView.loadHTMLString(discription, baseURL: nil)
        //        let applyButton = cell.viewWithTag(103) as! UIButton
        
        // applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
        //        applyButton.layer.cornerRadius = 3.0
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        return cell
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var jobLocationString:NSMutableString = ""
        
        for index in 0 ..< jobLocationArray.count
        {
            if index == 0
            {
                jobLocationString.append(jobLocationArray[index])
            }
            else
            {
                jobLocationString.append(",")
                
                jobLocationString.append(jobLocationArray[index])
                
            }
        }

        let height = heightForView(text: jobLocationString as String, font: UIFont.systemFont(ofSize: 14), width: self.view.frame.size.width*0.5) as CGFloat

        return CGSize(width: self.view.frame.size.width*0.95, height: height+300)
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
