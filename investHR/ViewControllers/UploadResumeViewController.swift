//
//  UploadResumeViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class UploadResumeViewController: UIViewController,UIDocumentPickerDelegate
{
    var uploadedResumeNamesArray = [String]()
    
    var uploadingRow: Int!
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        let resumeData = NSData(contentsOf: url)
        
        var uniqueImageName = String(Date().millisecondsSince1970)

        let userId = UserDefaults.standard.value(forKey: Constant.USERNAME)
        
        if userId != nil
        {
            uniqueImageName = uniqueImageName.appending(userId as! String)
        }
        else
        {
            let userId = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN)
            
            if userId != nil
            {
                uniqueImageName =  uniqueImageName.appending(userId as! String)
            }
        }

        print(url.pathExtension)
        
        let alertController = UIAlertController(title: "Upload File", message: "Are you sure to upload this file?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.default, handler: { act -> Void in
            
            AppPreferences.sharedPreferences().showHudWith(title: "Uploading Video..", detailText: "Please wait")

            let ftp = FTPImageUpload(baseUrl: Constant.FTP_HOST_NAME, userName: Constant.FTP_USERNAME, password: Constant.FTP_PASSWORD, directoryPath: Constant.FTP_DIRECTORY_PATH)
            
            let result = ftp.send(data: resumeData! as Data, with: uniqueImageName)
            
            if result
            {
                let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
                let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
                let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
                
                if username != nil && password != nil
                {
                    APIManager.getSharedAPIManager().saveResume(username: username!, password: password!, linkedinId: "", fileName: uniqueImageName)
                }
                else
                    if linkedInId != nil
                    {
                        APIManager.getSharedAPIManager().saveResume(username: "", password: "", linkedinId: linkedInId!, fileName: uniqueImageName)
                        
                }
            }
            else
            {
                AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

            }
            //alertController.dismiss(animated: true, completion: nil)
        }
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {act -> Void in
            
            alertController.dismiss(animated: true, completion: nil)
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

        
        //let imageView = self.view.viewWithTag(101) as! UIImageView
        
        //imageView.image = UIImage(data: data as! Data)
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Upload Resume"
        
//        let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
//        numberOfJobsLabel.textColor = UIColor(colorLiteralRed: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
//        numberOfJobsLabel.text = "108 jobs"
//        numberOfJobsLabel.textAlignment = NSTextAlignment.right
//        let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
//        
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        let editProfileView = UIView(frame: CGRect(x: 70, y: 0, width: 60, height: 50))
        //editProfileView.backgroundColor = UIColor.red
        
        let attachmentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        attachmentButton.addTarget(self, action: #selector(rightBArButtonCLicked), for: UIControlEvents.touchUpInside)
        attachmentButton.titleLabel?.textAlignment = NSTextAlignment.center
        attachmentButton.setTitleColor(UIColor.init(colorLiteralRed: 82/255.0, green: 158/255.0, blue: 242/255.0, alpha: 1), for: UIControlState.normal)
        //attachmentButton.backgroundColor = UIColor.blue
        
        let attachMentImageView = UIImageView(frame: CGRect(x: editProfileView.frame.size.width-16, y: 16, width: 16, height: 18))
        attachMentImageView.image = UIImage(named: "Attachment")
        
        
        //editProfileView.backgroundColor = UIColor.red
        editProfileView.addSubview(attachmentButton)
        editProfileView.addSubview(attachMentImageView)
        
        let rightBarButtonItem = UIBarButtonItem(customView: editProfileView)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getUploadedResumeList(username: username!, password: password!, linkedinId: "")
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getUploadedResumeList(username: "", password: "", linkedinId: linkedInId!)
                
        }
        NotificationCenter.default.addObserver(self, selector: #selector(checkUploadVideoResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_UPLOAD_USER_RESUME), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkUploadedResumeListResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_UPLOADED_RESUME_LIST), object: nil)
    }
    
    func checkUploadVideoResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        let code = responseDic["code"]
        
        if let videoName = responseDic["videoName"]
        {
            
            uploadedResumeNamesArray.append(videoName)
            
            //self.collectionView.reloadItems(at: [IndexPath.init(row: uploadingRow, section: 0)])
            
            
            
        }
        
        
        
    }

    func checkUploadedResumeListResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        let code = responseDic["code"]
        
        if let videoName = responseDic["videoName"]
        {
            let resumeNamesArray = videoName.components(separatedBy: "#@")
            
            for index in 0 ..< resumeNamesArray.count
            {
                uploadedResumeNamesArray.append(resumeNamesArray[index])
                
            }
            
            //self.collectionView.reloadItems(at: [IndexPath.init(row: uploadingRow, section: 0)])
            
            
            
        }

    }
//    func showiCloudFiles()
//    {
//        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text","public.image"], in: UIDocumentPickerMode.import)
//        
//        documentPickerController.delegate = self
//        present(documentPickerController, animated: true, completion: nil)
//    }
    
    func popViewController() -> Void
    {
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    func rightBArButtonCLicked() -> Void
    {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text"], in: UIDocumentPickerMode.import)
        
        documentPickerController.delegate = self
        present(documentPickerController, animated: true, completion: nil)
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
