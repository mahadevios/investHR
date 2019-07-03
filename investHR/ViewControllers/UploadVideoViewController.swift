//
//  UploadVideoViewController.swift
//  investHR
//
//  Created by mac on 30/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class UploadVideoViewController: UIViewController,UIDocumentPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,URLSessionDownloadDelegate,URLSessionDelegate
{
    var imagePicker = UIImagePickerController()
    
    var uploadedVideoNamesArray = [String]()
    
    var recordedVideoNamesArray = [String]()
    

    var uploadingOrDownloadingRow: Int!
    
    var counter: Int = 0

    
    var downloadingFileName: String!

    
    @IBOutlet weak var collectionView: UICollectionView!
    
 // MARK: - view delegates

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItem.Style.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.title = "Upload Video"
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
       
//        let editProfileView = UIView(frame: CGRect(x: 70, y: 0, width: 60, height: 50))
//        
//        let attachmentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
//        attachmentButton.addTarget(self, action: #selector(rightBArButtonCLicked), for: UIControlEvents.touchUpInside)
//        attachmentButton.titleLabel?.textAlignment = NSTextAlignment.center
//        attachmentButton.setTitleColor(UIColor.init(colorLiteralRed: 82/255.0, green: 158/255.0, blue: 242/255.0, alpha: 1), for: UIControlState.normal)
//        
//        let attachMentImageView = UIImageView(frame: CGRect(x: editProfileView.frame.size.width-16, y: 16, width: 16, height: 18))
//        attachMentImageView.image = UIImage(named: "Attachment")
//        
//        
//        //editProfileView.backgroundColor = UIColor.red
//        editProfileView.addSubview(attachmentButton)
//        editProfileView.addSubview(attachMentImageView)
//        
//        let rightBarButtonItem = UIBarButtonItem(customView: editProfileView)
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 2, bottom: 30, right: 2)
        
        layout.minimumInteritemSpacing = 0
        
        layout.minimumLineSpacing = 20
        
        collectionView!.collectionViewLayout = layout
    
        NotificationCenter.default.addObserver(self, selector: #selector(checkUploadVideoResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_UPLOAD_USER_VIDEO), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkUploadedVideoListResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_UPLOADED_VIDEO_LIST), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDeletedVideoListResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_DELETE_VIDEO), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)

        if AppPreferences.sharedPreferences().isReachable
        {
            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
            
            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
            
            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
            
            if username != nil && password != nil
            {
                APIManager.getSharedAPIManager().getUploadedVideoList(username: username!, password: password!, linkedinId: "")
            }
            else
                if linkedInId != nil
                {
                    APIManager.getSharedAPIManager().getUploadedVideoList(username: "", password: "", linkedinId: linkedInId!)
                    
                }
            //AppPreferences.sharedPreferences().showHudWith(title: "Loading Videos", detailText: "Please wait..")

        }
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")

            self.getStoredVideoList() // if internet connection not avaialbel show the stored video list
            
            self.collectionView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        

       
    }
// MARK: - Notification response methods
   
    @objc func deviceRotated()
    {
        self.collectionView.reloadData()
    }
    
    
    @objc func checkUploadedVideoListResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        if let videoName = responseDic["videoName"]
        {
            let videoNamesArray = videoName.components(separatedBy: "#@")
            
            for index in 0 ..< videoNamesArray.count
            {
                if videoNamesArray[index] != ""
                {
                    self.uploadedVideoNamesArray.append(videoNamesArray[index])
                    //recordedVideoNamesArray.append(videoNamesArray[index])
                    
                }
            }
            
            
        }
        
        self.getStoredVideoList()
        
        self.collectionView.reloadData()

        
    }

    func getStoredVideoList()
    {
        let fileManager = FileManager.default
        
        let videoPath = self.UserVideosFolderPath()
        
        let url = URL.init(string: videoPath)
        
        let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
        
//        if let managedObjects = CoreDataManager.getSharedCoreDataManager().getRecordedVideoNames(entity: "UserVideos", userId: userId as! String) as? [UserVideos]

        if let managedObjects = Database.sharedDatabse().getUserVideos(userId: userId)
        {
            for index in managedObjects
            {
                let userVideoObject = index
                
                if !self.uploadedVideoNamesArray.contains(userVideoObject.videoName!)
                {
                    recordedVideoNamesArray.append(userVideoObject.videoName!)

                }
                
            }
        
        }
        
    }
    @objc func checkUploadVideoResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        let code = responseDic["code"]
        
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)

        
        if let videoName = responseDic["videoName"]
        {
            
            if let index = recordedVideoNamesArray.index(of: videoName)
            {
                recordedVideoNamesArray.remove(at: index)
                
                if self.uploadedVideoNamesArray.count == 0
                {
                    
                }
                else
                {
                    self.collectionView.deleteItems(at: [IndexPath.init(row: uploadingOrDownloadingRow, section: 1)])

                }
                
                self.uploadedVideoNamesArray.append(videoName)

                if self.uploadedVideoNamesArray.count == 1
                {
                    self.collectionView.reloadData()
                }
                else
                {
                    self.collectionView.insertItems(at: [IndexPath.init(row: self.uploadedVideoNamesArray.count-1, section: 0)])

                }

                
            }
            //recordedVideoNamesArray.remove
            //self.collectionView.reloadItems(at: [IndexPath.init(row: uploadingOrDownloadingRow, section: 0)])

        }
        
    }
    
    @objc func checkDeletedVideoListResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        let code = responseDic["code"]
        
        AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
        
        if let videoName = responseDic["videoName"]
        {
            let savePath:String = self.UserVideosFolderPath() + "/" + videoName
            
            let videoURL = URL(fileURLWithPath: savePath)
            
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: savePath)
            {
                do
                {
                    //CoreDataManager.getSharedCoreDataManager().deleteUserVideos(entity: "UserVideos", videoName: videoName)
                    Database.sharedDatabse().deleteVideo(videoName: String(videoName))
                    try fileManager.removeItem(atPath: savePath)
                    
                    
                }
                catch let error as NSError
                {
                    
                }
                
            }
            
//            print("count = " + "\(self.uploadedVideoNamesArray.count)")
//            print("deleting row =" + "\(self.uploadingOrDownloadingRow)")
            self.uploadedVideoNamesArray.remove(at: self.uploadingOrDownloadingRow!)

            //recordedVideoNamesArray.remove(at: uploadingOrDownloadingRow)
            if self.uploadedVideoNamesArray.count == 0
            {
                self.collectionView.reloadData()
            }
            else
            {
                self.collectionView.deleteItems(at: [IndexPath.init(row: uploadingOrDownloadingRow, section: 0)])

            }

                        
        }
  
    
    }
   
// MARK: - Bar button Methods
    
    @objc func popViewController() -> Void
    {
        //deleteAllFiles()
        NotificationCenter.default.removeObserver(self)
        
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBArButtonCLicked() -> Void
    {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text","public.image","public.movie"], in: UIDocumentPickerMode.import)
        
        documentPickerController.delegate = self
        
        present(documentPickerController, animated: true, completion: nil)
    }
    
    func deleteAllFiles()
    {
        let fileManager = FileManager.default
        
        do
        {
            try fileManager.removeItem(atPath: UserVideosFolderPath())
        }
        catch let error as NSError
        {
//            print("Ooops! Something went wrong: \(error)")
        }
    }
    
// MARK: - Image picker controller delegates
    
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        let data = NSData(contentsOf: url)
        
//        print(url.pathExtension)
        
        let imageView = self.view.viewWithTag(101) as! UIImageView
        
        imageView.image = UIImage(data: data as! Data)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {

        let fileManager = FileManager.default
        
        let folderpath = self.UserVideosFolderPath()
        
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
        let uniqueImageName = String(Date().millisecondsSince1970) + ".mp4"

        var unCompressedFilePath:String = folderpath + "/" + "unCompressed" + uniqueImageName
        
        var savePath:String = folderpath + "/" + uniqueImageName

        let mediaType = info[UIImagePickerController.InfoKey.originalImage] as! String
        
        let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
        
        //let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "UserVideos", ["userId":userId ,"videoName":uniqueImageName])

        let videoObj = Videos()
        videoObj.userId = userId
        videoObj.videoName = uniqueImageName
        
        Database.sharedDatabse().insertIntoVideos(videoObj: videoObj)
        if mediaType == "public.movie"
        {
            let mediaUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            
            do
            {
                let imgData = try Data(contentsOf: mediaUrl)
                
                do
                {
                    try imgData.write(to: URL(fileURLWithPath: unCompressedFilePath))
//                    print("uncompressed kb - \(imgData.count / (1024))")

                    let url = URL(fileURLWithPath: unCompressedFilePath)
                    recordedVideoNamesArray.append(uniqueImageName)
                    
                    //self.collectionView.reloadData()
                    DispatchQueue.main.async {
                        //self.collectionView.reloadData()
                        AppPreferences.sharedPreferences().showHudWith(title: "Saving Video", detailText: "Please wait")
                    }
                    self.convertVideoWithMediumQuality(fromUrl: url as NSURL, toPath: savePath)
                    
                } catch let error as NSError
                {
//                    print(error.localizedDescription)
                }
                
                
            } catch let error as NSError
            {
//                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // picker cancelled, dismiss picker view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    func convertVideoWithMediumQuality(fromUrl : NSURL, toPath: String){
        
        
        if FileManager.default.fileExists(atPath: toPath) {
            do {
                try FileManager.default.removeItem(atPath: toPath)
            } catch { }
        }
        
        let savePathUrl =  NSURL(fileURLWithPath: toPath)
        
        let sourceAsset = AVURLAsset(url: fromUrl as URL, options: nil)
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetMediumQuality)!
        assetExport.outputFileType = AVFileType.mov
        assetExport.outputURL = savePathUrl as URL
        assetExport.exportAsynchronously { () -> Void in
            
            switch assetExport.status {
            case AVAssetExportSessionStatus.completed:
                DispatchQueue.main.async( execute: {
                    do {
                        let videoData = try NSData(contentsOf: savePathUrl as URL, options: NSData.ReadingOptions())
//                        print("KB - \(videoData.length / (1024))")
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                            self.dismiss(animated: true, completion: nil)

                        }
                    } catch {
//                        print(error)
                    }
                    
                })
            case  AVAssetExportSessionStatus.failed:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    self.dismiss(animated: true, completion: nil)
                    
                }
//                print("failed \(assetExport.error)")
            case AVAssetExportSessionStatus.cancelled:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    self.dismiss(animated: true, completion: nil)
                    
                }
//                print("cancelled \(assetExport.error)")
            default:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                    self.dismiss(animated: true, completion: nil)
                    
                }
//                print("complete")
            }
        }
        
    }// MARK: - Support methods
    
    // added these methods simply for convenience/completeness
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
    
    func UserVideosFolderPath() -> String
    {
        let folderpath = self.documentsPath()! + "/"  + Constant.USER_VIDEOS_FOLDER_NAME

        return folderpath
    }
    
    func presentDateTimeString() ->String
    {
        // setup date formatter
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        // get current date
        let now:NSDate = NSDate()
        
        // generate date string from now
        let theDateTime = dateFormatter.string(from: now as Date)
        return theDateTime
        
    }
    
    func videoSnapshot(filePathLocal: NSString) -> UIImage?
    {
        
        let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: vidURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
//            print("Image generation failed with error \(error)")
            return nil
        }
    }

    @IBAction func uploadVideoButtonClicked(_ sender: Any)
    {
        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
//        {
//            let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)
//            
//            if (availableMediaTypes?.contains("public.movie"))!
//            {
//                
//                let camera = UIImagePickerController()
//                
//                camera.sourceType = UIImagePickerControllerSourceType.camera
//                
//                camera.mediaTypes = ["public.movie"]
//                
//                camera.delegate = self;
//                
//                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front)
//                {
//                    camera.cameraDevice = UIImagePickerControllerCameraDevice.front
//                }
//                
//                let cameraDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//               
//                var cameraDeviceInput = AVCaptureDeviceInput()
//                do
//                {
//                    cameraDeviceInput = try AVCaptureDeviceInput.init(device: cameraDevice)
//                    
//                } catch let error as NSError
//                {
//                    print(error.localizedDescription)
//                }
//
//                
//                let captureSession = AVCaptureSession()
//                
//                if captureSession.canAddInput(cameraDeviceInput)
//                {
//                    captureSession.addInput(cameraDeviceInput)
//                }
//                
//                captureSession.startRunning()
//            }
//        }
        
        self.actionLaunchCamera()
    }
    
    func actionLaunchCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.videoMaximumDuration = 60
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert:UIAlertController = UIAlertController(title: "Camera Unavailable", message: "Unable to find a camera on this device", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UICollectionViewDelegate adn Datasource protocol

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if self.uploadedVideoNamesArray.count > 0
        {
            return 2

        }
        else
        {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0 && self.uploadedVideoNamesArray.count > 0
        {
            return self.uploadedVideoNamesArray.count


        }
        else
        {
            return self.recordedVideoNamesArray.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        var videoName:String!
        if indexPath.section == 0 && self.uploadedVideoNamesArray.count > 0
        {
            videoName = self.uploadedVideoNamesArray[indexPath.row]
        }
        else
        {
            videoName = self.recordedVideoNamesArray[indexPath.row]

        }
        
        
        let savePath:String = self.UserVideosFolderPath() + "/" + videoName

        let videoImagePreview = cell.viewWithTag(101) as! UIImageView

        let playVideoImageView = cell.viewWithTag(102) as! UIImageView

        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: savePath)
        {
            if let image = videoSnapshot(filePathLocal: savePath as NSString)
            {
                videoImagePreview.image = image
                
                playVideoImageView.image = #imageLiteral(resourceName: "VideoPlay")

            }
        }
//        if let image = videoSnapshot(filePathLocal: savePath as NSString)
//        {
//            videoImagePreview.image = image
//        }
        else
        {
            videoImagePreview.image = #imageLiteral(resourceName: "VideoBG")
            
            playVideoImageView.image = nil
        }
        
        
        let uploadButton = cell.viewWithTag(103) as! subclassedUIButton
        
        
        uploadButton.cell1 = cell

        //uploadButton.indexPath = indexPath.row

        uploadButton.addTarget(self, action: #selector(uploadButtonCLicked(sender:)), for: .touchUpInside)
        
        
        
        


        if self.uploadedVideoNamesArray.contains(videoName)
        {
            uploadButton.setTitle("Uploaded", for: .normal)
            uploadButton.setTitleColor(UIColor.white, for: .normal)
            uploadButton.titleLabel?.baselineAdjustment = .alignCenters
            uploadButton.backgroundColor = UIColor.appliedJobGreenColor()
            uploadButton.isUserInteractionEnabled = false
            let deleteButton = cell.viewWithTag(105) as! subclassedUIButton
            deleteButton.cell1 = cell
            deleteButton.addTarget(self, action: #selector(deleteButtonCLicked(sender:)), for: .touchUpInside)

        }
        else
        {
            uploadButton.setTitle("Upload", for: .normal)
            uploadButton.setTitleColor(UIColor.white, for: .normal)
            uploadButton.backgroundColor = UIColor.appBlueColor()
            uploadButton.isUserInteractionEnabled = true
            let deleteButton = cell.viewWithTag(105) as! subclassedUIButton
            deleteButton.cell1 = cell
            deleteButton.addTarget(self, action: #selector(deleteButtonCLicked(sender:)), for: .touchUpInside)

        }

        //self.downloadFileFromFTP(fileName: videoName, sender: self)
        //APIManager.getSharedAPIManager().downloadFileFromFTP(fileName: videoName, sender: self)
       // uploadButton.layer.borderWidth = 1.0
        
        //uploadButton.layer.borderColor = UIColor(colorLiteralRed: 29/255.0, green: 123/255.0, blue: 231/255.0, alpha: 1.0).cgColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 10), height: CGFloat(130))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var videoName:String!
        
        if indexPath.section == 0 && self.uploadedVideoNamesArray.count > 0
        {
            videoName = self.uploadedVideoNamesArray[indexPath.row]
        }
        else
        {
            videoName = self.recordedVideoNamesArray[indexPath.row]
            
        }
        var savePath:String = self.UserVideosFolderPath() + "/" + videoName

        let videoURL = URL(fileURLWithPath: savePath)
        
        let player = AVPlayer(url: videoURL)
        
    
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: savePath)
        {
            self.present(playerViewController, animated: true)
            {
                playerViewController.player!.play()
            }
 
        }
            //        if let image = videoSnapshot(filePathLocal: savePath as NSString)
            //        {
            //            videoImagePreview.image = image
            //        }
        else
        {
            self.downloadFileFromFTP(fileName: uploadedVideoNamesArray[indexPath.row], sender: self)
            
            //FTPImageUpload.deleteFileFromFTP(fileName: recordedVideoNamesArray[indexPath.row])
            AppPreferences.sharedPreferences().showHudWith(title: "Downloading video", detailText: "Please wait")
        }
        
        
        uploadingOrDownloadingRow = indexPath.row
        
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//         return 20
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 20.0
//    }
   
    @objc func uploadButtonCLicked( sender: subclassedUIButton)
    {
        self.startUploading(sender: sender)
        
    }
    
    @objc func deleteButtonCLicked( sender: subclassedUIButton)
    {
        let alertController = UIAlertController(title: "Remove File", message: "Are you sure to remove this file?", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Remove", style: UIAlertAction.Style.destructive, handler: { act -> Void in
            
            
           // let videoName = self.recordedVideoNamesArray[sender.indexPath]
            
            //self.uploadingOrDownloadingRow = sender.indexPath
            
            
            let indexpath = self.collectionView.indexPath(for: sender.cell1)
            
            if indexpath!.section == 0 && self.uploadedVideoNamesArray.count > 0
            {
                let videoName = self.uploadedVideoNamesArray[indexpath!.row]
                
                self.uploadingOrDownloadingRow = indexpath!.row
                
                let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
                let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
                let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
                
                
                if username != nil && password != nil
                {
                    APIManager.getSharedAPIManager().deleteVideo(username: username!, password: password!, linkedinId: "", fileName: videoName)
                }
                else
                    if linkedInId != nil
                    {
                        APIManager.getSharedAPIManager().deleteVideo(username: "", password: "", linkedinId: linkedInId!, fileName: videoName)
                        
                }

            }
            else
            if indexpath!.section == 0 && self.uploadedVideoNamesArray.count == 0
            {
               self.deleteButtonCLickedForLocalFiles(sender: sender)
            }
            else
            {
                self.deleteButtonCLickedForLocalFiles(sender: sender)

            }
            
            
        })
          
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {act -> Void in
            
            alertController.dismiss(animated: true, completion: nil)
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
            
    }
    
    func deleteButtonCLickedForLocalFiles( sender: subclassedUIButton)
    {
//        let alertController = UIAlertController(title: "Remove File", message: "Are you sure to remove this file?", preferredStyle: UIAlertControllerStyle.alert)
//        
//        let okAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.destructive, handler: { act -> Void in
        
            
            // let videoName = self.recordedVideoNamesArray[sender.indexPath]
            
            //self.uploadingOrDownloadingRow = sender.indexPath
            
            let indexpath = self.collectionView.indexPath(for: sender.cell1)
            
            let videoName = self.recordedVideoNamesArray[indexpath!.row]
            
            self.uploadingOrDownloadingRow = indexpath!.row
            
            
            let savePath:String = self.UserVideosFolderPath() + "/" + videoName
            
            let videoURL = URL(fileURLWithPath: savePath)
            
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: savePath)
            {
                do
                {
                    try fileManager.removeItem(atPath: savePath)
                    
                    if let index = recordedVideoNamesArray.index(of: videoName)
                    {
                        recordedVideoNamesArray.remove(at: index)
                        
                        Database.sharedDatabse().deleteVideo(videoName: String(videoName))

                       // CoreDataManager.getSharedCoreDataManager().deleteUserVideos(entity: "UserVideos", videoName: videoName)
                    }
                    
                    self.collectionView.deleteItems(at: [indexpath!])

                }
                catch let error as NSError
                {
                
                }
                
            }
            
            
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {act -> Void in
//            
//            alertController.dismiss(animated: true, completion: nil)
//            
//        })
//        
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
        
    }
    func startUploading( sender: subclassedUIButton)
    {
        if self.uploadedVideoNamesArray.count <= 2
        {
//            let videoName = recordedVideoNamesArray[sender.indexPath]
//            
//            self.uploadingOrDownloadingRow = sender.indexPath
            
            let indexpath = self.collectionView.indexPath(for: sender.cell1)
            
            let videoName = self.recordedVideoNamesArray[indexpath!.row]
            
            self.uploadingOrDownloadingRow = indexpath!.row
            
            let savePath:String = self.UserVideosFolderPath() + "/" + videoName
            
            let videoURL = URL(fileURLWithPath: savePath)
            
            var videoData = Data()
            
            do
            {
                videoData = try Data(contentsOf: videoURL)
                
            } catch let error as NSError
            {
                
            }
            
            let alertController = UIAlertController(title: "Upload File", message: "Are you sure to upload this video?", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "Upload", style: UIAlertAction.Style.default, handler:
                
            { act -> Void in
                
                
                let ftp = FTPImageUpload(baseUrl: Constant.FTP_HOST_NAME, userName: Constant.FTP_USERNAME, password: Constant.FTP_PASSWORD, directoryPath: Constant.FTP_DIRECTORY_PATH)
                
                AppPreferences.sharedPreferences().showHudWith(title: "Uploading Video..", detailText: "Please wait")
                
                DispatchQueue.global(qos: .background).async
                {
                    
                    let result = ftp.send(data: videoData, with: videoName)
                    
                    DispatchQueue.main.async
                    {
                        
                        if result
                        {
                        
                            let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
                        
                            let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
                        
                            let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
                            
                            if username != nil && password != nil
                            {
                                APIManager.getSharedAPIManager().saveVideo(username: username!, password: password!, linkedinId: "", fileName: videoName)
                            }
                            else
                                if linkedInId != nil
                                {
                                    APIManager.getSharedAPIManager().saveVideo(username: "", password: "", linkedinId: linkedInId!, fileName: videoName)
                            }
                        }
                        else
                        {
                            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                        }
                    
                    }
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler:
            {act -> Void in
                
                alertController.dismiss(animated: true, completion: nil)
                
            })
            
            alertController.addAction(okAction)
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
            
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "Upload Video Limit", withMessage: "Maximum 3 videos can be upload, please delete exsting videos", withCancelText: "ok")
        }
        
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
//        print(error?.localizedDescription)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        let fileManager = FileManager.default
        
        let folderpath = self.UserVideosFolderPath()
        
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
            
            var savePath:String = self.UserVideosFolderPath() + "/" + self.downloadingFileName
        
            let url = URL(fileURLWithPath: savePath)
            
            //let savePath1 = Bundle.main.path(forResource: savePath, ofType: "mp4")
            
            
            try data.write(to: URL(fileURLWithPath: savePath))

            //data.write(toFile: savePath, atomically: false)
            //try data.write(to: URL(fileURLWithPath: savePath), options: .atomic)
            
            DispatchQueue.main.async
            {
                AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                
                self.collectionView.reloadItems(at: [IndexPath.init(row: self.uploadingOrDownloadingRow, section: 0)])
            }
            

            
        } catch let error as Error
        {
//            print(error.localizedDescription)
        }
        
        
//        print(location)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
//        print(totalBytesSent)
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
//        print(bytesWritten)
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
