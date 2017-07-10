//
//  UploadResumeViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class UploadResumeViewController: UIViewController,UIDocumentPickerDelegate, UITableViewDataSource,UITableViewDelegate,URLSessionDelegate,URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate
{
    var uploadedResumeNamesArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    var uploadingOrDownloadingRow: Int!
    var downloadingFileName: String!
    var interactionController: UIDocumentInteractionController?

    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
      if uploadedResumeNamesArray.count <= 2
      {
        let resumeData = NSData(contentsOf: url)
        
        let uniqueImageName = String(Date().millisecondsSince1970) + "." + url.pathExtension

//        let userId = UserDefaults.standard.value(forKey: Constant.USERNAME)
//        
//        if userId != nil
//        {
//            uniqueImageName = uniqueImageName.appending(userId as! String)
//        }
//        else
//        {
//            let userId = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN)
//            
//            if userId != nil
//            {
//                uniqueImageName =  uniqueImageName.appending(userId as! String)
//            }
//        }

        print(url.pathExtension)
        
        let alertController = UIAlertController(title: "Upload File", message: "Are you sure to upload this file?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.default, handler: { act -> Void in
            
            AppPreferences.sharedPreferences().showHudWith(title: "Uploading Resume..", detailText: "Please wait")

            self.saveResumeToLocalDirectory(uniqueImageName: uniqueImageName, resumeData: resumeData! as Data)

            let ftp = FTPImageUpload(baseUrl: Constant.FTP_HOST_NAME, userName: Constant.FTP_USERNAME, password: Constant.FTP_PASSWORD, directoryPath: Constant.FTP_DIRECTORY_PATH)
            

            DispatchQueue.global(qos: .background).async {

                let result = ftp.send(data: resumeData! as Data, with: uniqueImageName)

                
                DispatchQueue.main.async {
                    
                    
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
            }

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

    }
    
    else
    {
        AppPreferences.sharedPreferences().showAlertViewWith(title: "Upload Resume Limit", withMessage: "Maximum 3 resume can be upload, please delete exsting resume", withCancelText: "ok")
    }
   
        //let imageView = self.view.viewWithTag(101) as! UIImageView
        
        //imageView.image = UIImage(data: data as! Data)
        
    }
    
    func saveResumeToLocalDirectory(uniqueImageName:String, resumeData:Data)
    {
        let fileManager = FileManager.default
        
        let folderpath = self.UserResumeFolderPath()
        
        if !fileManager.fileExists(atPath: folderpath)
        {
            do
            {
                try fileManager.createDirectory(atPath: folderpath, withIntermediateDirectories: false, attributes: nil)
                
            }
            catch let error as NSError
            {
                
            }
            
        }
        
        var savePath:String = folderpath + "/" + uniqueImageName
        
        let resumeURL = NSURL(fileURLWithPath:savePath as String)
        
        do {
            
            try resumeData.write(to: resumeURL as URL)

        } catch let error as NSError
        {
            
        }


    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Upload Resume"
        
        //interactionController!.delegate = self

//        let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
//        numberOfJobsLabel.textColor = UIColor(colorLiteralRed: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
//        numberOfJobsLabel.text = "108 jobs"
//        numberOfJobsLabel.textAlignment = NSTextAlignment.right
//        let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
//        
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        let editProfileView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        //editProfileView.backgroundColor = UIColor.red
        
        let attachmentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDeletedResumeListResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_DELETE_RESUME), object: nil)

        // Do any additional setup after loading the view.
    }
    
    func checkDeletedResumeListResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        let code = responseDic["code"]
        
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
        
        if let videoName = responseDic["resumeName"]
        {
            
            uploadedResumeNamesArray.remove(at: uploadingOrDownloadingRow)
            
            self.tableView.deleteRows(at: [IndexPath.init(row: uploadingOrDownloadingRow, section: 0)], with: .automatic)
            //self.collectionView.reloadItems(at: [IndexPath.init(row: uploadingOrDownloadingRow, section: 0)])
            
        }

    
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedResumeNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let resumeNameLabel = cell?.viewWithTag(101) as! UILabel
        
        resumeNameLabel.text = uploadedResumeNamesArray[indexPath.row]
        
        let downloadButton = cell?.viewWithTag(102) as! subclassedUIButton
        
        downloadButton.indexPath = indexPath.row
        
        let downloadOrViewImageView = cell?.viewWithTag(104) as! UIImageView

        let deleteImageView = cell?.viewWithTag(105) as! UIImageView

        var savePath:String = self.UserResumeFolderPath() + "/" + uploadedResumeNamesArray[indexPath.row]
        
        let videoURL = URL(fileURLWithPath: savePath)
        

        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: savePath)
        {
            // view options
            
            downloadButton.addTarget(self, action: #selector(viewButtonCLicked(sender:)), for: .touchUpInside)

            downloadOrViewImageView.image = #imageLiteral(resourceName: "ViewAttachment")
            
            downloadOrViewImageView.frame = CGRect(x: downloadOrViewImageView.frame.origin.x, y: downloadOrViewImageView.frame.origin.y, width: 23.0, height: 13.0)
        }
        else
        {
            downloadOrViewImageView.image = #imageLiteral(resourceName: "Download")

            downloadOrViewImageView.frame = CGRect(x: downloadOrViewImageView.frame.origin.x, y: downloadOrViewImageView.frame.origin.y, width: 20.0, height: 20.0)

            downloadButton.addTarget(self, action: #selector(downloadButtonCLicked(sender:)), for: .touchUpInside)

        }

        downloadButton.cell = cell

        
        let deleteButton = cell?.viewWithTag(103) as! subclassedUIButton
                
        deleteButton.indexPath = indexPath.row
        
        deleteButton.cell = cell
        
        deleteButton.addTarget(self, action: #selector(deleteButtonCLicked(sender:)), for: .touchUpInside)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var savePath:String = self.UserResumeFolderPath() + "/" + uploadedResumeNamesArray[indexPath.row]
        
        let videoURL = URL(fileURLWithPath: savePath)
        
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: savePath)
        {
            // view options
            
        }
            //        if let image = videoSnapshot(filePathLocal: savePath as NSString)
            //        {
            //            videoImagePreview.image = image
            //        }
        else
        {
            
        }
        
        
       // uploadingOrDownloadingRow = indexPath.row
    }
    func downloadFileFromFTP(fileName:String, sender:Any)
    {
        let username = Constant.FTP_USERNAME.replacingOccurrences(of: "@", with: "%40")
        
        let password = Constant.FTP_PASSWORD.replacingOccurrences(of: "@", with: "%40")
        
        let hostName = Constant.FTP_HOST_NAME
        
        let directoryPath = Constant.FTP_DIRECTORY_PATH
        
        let downloadFileName = fileName.replacingOccurrences(of: " ", with: "%20")
        
        // NSString* urlString=[NSString stringWithFormat:@"ftp://%@:%@%@%@%@",username,password,FTPHostName,FTPFilesFolderName,downloadableAttachmentName];
        
        let fullyQualifiedPath = "ftp://\(username):\(password)\("@")\(hostName)/\(directoryPath)/\(downloadFileName)"
        
        let downloadUrl = URL(string: fullyQualifiedPath)
        
        let sessionConf = URLSessionConfiguration.default
        
        let downloadSession = URLSession(configuration: sessionConf, delegate: self, delegateQueue: nil)
        
        if downloadUrl != nil
        {
            let downloadTask = downloadSession.downloadTask(with: downloadUrl!)
            
            self.downloadingFileName = fileName
            
            downloadTask.resume()
        }
        
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        print(error?.localizedDescription)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        let fileManager = FileManager.default
        
        let folderpath = self.UserResumeFolderPath()
        
        if !fileManager.fileExists(atPath: folderpath)
        {
            do
            {
                try fileManager.createDirectory(atPath: folderpath, withIntermediateDirectories: false, attributes: nil)
                
            }
            catch let error as NSError
            {
                
            }
            
        }
        
        do
        {
            let data = try Data.init(contentsOf: location)
            
            var savePath:String = self.UserResumeFolderPath() + "/" + self.downloadingFileName
            
            try data.write(to: URL(fileURLWithPath: savePath))
            
            DispatchQueue.main.async
                {
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    
                    self.tableView.reloadRows(at: [IndexPath.init(row: self.uploadingOrDownloadingRow, section: 0)], with: .automatic)
            }
            
            
            
        } catch let error as Error
        {
            
        }
        
        
        print(location)
    }

    func deleteButtonCLicked(sender: subclassedUIButton)
    {
        let alertController = UIAlertController(title: "Remove File", message: "Are you sure to remove this file?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.destructive, handler: { act -> Void in
            
        let indexpath = self.tableView.indexPath(for: sender.cell)
        
        let videoName = self.uploadedResumeNamesArray[indexpath!.row]
        
        self.uploadingOrDownloadingRow = indexpath!.row

        let username = UserDefaults.standard.value(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().deleteResume(username: username!, password: password!, linkedinId: "", fileName: videoName)
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().deleteResume(username: "", password: "", linkedinId: linkedInId!, fileName: videoName)
                
            }
        })
    
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {act -> Void in
        
            alertController.dismiss(animated: true, completion: nil)
        
        })
    
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }

    func documentsPath() ->String?
    {
        // fetch our paths
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if paths.count > 0
        {
            // return our docs directory path if we have one
            let docsDir = paths[0]
            return docsDir
        }
        return nil
    }
    
    func UserResumeFolderPath() -> String
    {
        let folderpath = self.documentsPath()! + "/"  + Constant.USER_RESUME_FOLDER_NAME
        
        return folderpath
    }

    func viewButtonCLicked(sender: subclassedUIButton)
    {
        let indexpath = self.tableView.indexPath(for: sender.cell)
        
        let videoName = self.uploadedResumeNamesArray[indexpath!.row]
        
        self.uploadingOrDownloadingRow = indexpath!.row
        
        var savePath:String = self.UserResumeFolderPath() + "/" + videoName
        
        //let videoURL = URL(fileURLWithPath: savePath)


        
        let url = URL(fileURLWithPath: savePath)
        interactionController = UIDocumentInteractionController(url: url)
        interactionController!.delegate = self

        interactionController!.presentPreview(animated: true)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    func downloadButtonCLicked(sender: subclassedUIButton)
    {
        let indexpath = self.tableView.indexPath(for: sender.cell)
        
        let videoName = self.uploadedResumeNamesArray[indexpath!.row]
        
        self.uploadingOrDownloadingRow = indexpath!.row
        
        var savePath:String = self.UserResumeFolderPath() + "/" + videoName
        
        let videoURL = URL(fileURLWithPath: savePath)
        
        
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: savePath)
        {
            //view resume
        }
            //        if let image = videoSnapshot(filePathLocal: savePath as NSString)
            //        {
            //            videoImagePreview.image = image
            //        }
        else
        {
            //FTPImageUpload.deleteFileFromFTP(fileName: recordedVideoNamesArray[indexPath.row])
            self.downloadFileFromFTP(fileName: uploadedResumeNamesArray[sender.indexPath], sender: self)

            AppPreferences.sharedPreferences().showHudWith(title: "Downloading video", detailText: "Please wait")
        }
        
        
    }
    
    func checkUploadVideoResponse(dataDic:Notification)
    {
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        let code = responseDic["code"]
        
        if let videoName = responseDic["ResumeName"]
        {
            
            uploadedResumeNamesArray.append(videoName)
            
            //self.collectionView.reloadItems(at: [IndexPath.init(row: uploadingRow, section: 0)])
            
            
            
        }
        
        tableView.reloadData()
        
    }

    func checkUploadedResumeListResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        let code = responseDic["code"]
        
        if let videoName = responseDic["ResumeName"]
        {
            let resumeNamesArray = videoName.components(separatedBy: "#@")
            
            for index in 0 ..< resumeNamesArray.count
            {
                if resumeNamesArray[index] != ""
                {
                    uploadedResumeNamesArray.append(resumeNamesArray[index])
                    
                    
                }
                
            }
            
            //self.collectionView.reloadItems(at: [IndexPath.init(row: uploadingRow, section: 0)])
            
            self.tableView.reloadData()
            
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
        NotificationCenter.default.removeObserver(self)
        
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    func rightBArButtonCLicked() -> Void
    {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text","public.composite-content"], in: UIDocumentPickerMode.import)
        
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
