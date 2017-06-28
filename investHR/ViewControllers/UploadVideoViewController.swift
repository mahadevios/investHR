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

class UploadVideoViewController: UIViewController,UIDocumentPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    var imagePicker = UIImagePickerController()
    var uploadedVideoNamesArray = [String]()
    var recordedVideoNamesArray = [String]()
    var uploadingRow: Int!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
        override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Upload Video"
        
       

       
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
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        

       
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
            
            uploadedVideoNamesArray.append(videoName)
                
            self.collectionView.reloadItems(at: [IndexPath.init(row: uploadingRow, section: 0)])
            
            

        }
        
    }
    
    func checkUploadedVideoListResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        let code = responseDic["code"]
        
        if let videoName = responseDic["videoName"]
        {
            let videoNamesArray = videoName.components(separatedBy: "#@")
            
            for index in 0 ..< videoNamesArray.count
            {
                if videoNamesArray[index] != ""
                {
                    uploadedVideoNamesArray.append(videoNamesArray[index])
                    recordedVideoNamesArray.append(videoNamesArray[index])


                }
                
            }
            
            self.collectionView.reloadData()
            //self.collectionView.reloadItems(at: [IndexPath.init(row: uploadingRow, section: 0)])
            
            
            
        }
        
    }

    
    func popViewController() -> Void
    {
        deleteAllFiles()
        
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteAllFiles()
    {
        // Create a FileManager instance
        
        let fileManager = FileManager.default
        
        // Delete 'subfolder' folder
        
        do {
            try fileManager.removeItem(atPath: UserVideosFolderPath())
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func rightBArButtonCLicked() -> Void
    {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text","public.image","public.movie"], in: UIDocumentPickerMode.import)
        
        documentPickerController.delegate = self
        
        present(documentPickerController, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        let data = NSData(contentsOf: url)
        
        print(url.pathExtension)
        
        let imageView = self.view.viewWithTag(101) as! UIImageView
        
        imageView.image = UIImage(data: data as! Data)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // create a filepath with the current date/time as the image name
       // let fileName = self.presentDateTimeString()
//        let fileName = "video1"

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
        var savePath:String = folderpath + "/" + uniqueImageName + ".mp4"
        
        // try to get our edited image if there is one, as well as the original image
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        
        
        if mediaType == "public.movie"
        {
            let mediaUrl = info[UIImagePickerControllerMediaURL] as! URL
            
            do
            {
                let imgData = try Data(contentsOf: mediaUrl)
                
                do
                {
                    try imgData.write(to: URL(fileURLWithPath: savePath))
                    
                    recordedVideoNamesArray.append(uniqueImageName)
                    
                    self.collectionView.reloadData()
                    
                    
                } catch let error as NSError
                {
                    print(error.localizedDescription)
                }
                
                
            } catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            // write the image data to file
            //imgData.write(to:URL(string: savePath)!, options: true)
            
            
        }
        //let originalImg:UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        // create our image data with the edited img if we have one, else use the original image
        // dismiss the picker
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // picker cancelled, dismiss picker view controller
        self.dismiss(animated: true, completion: nil)
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
            print("Image generation failed with error \(error)")
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.videoMaximumDuration = 10
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert:UIAlertController = UIAlertController(title: "Camera Unavailable", message: "Unable to find a camera on this device", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UICollectionViewDelegate adn Datasource protocol

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return recordedVideoNamesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
 
        let videoName = recordedVideoNamesArray[indexPath.row]
        
        let savePath:String = self.UserVideosFolderPath() + "/" + videoName + ".mp4"

        let videoImagePreview = cell.viewWithTag(101) as! UIImageView

        let playVideoImageView = cell.viewWithTag(102) as! UIImageView

        if let image = videoSnapshot(filePathLocal: savePath as NSString)
        {
            videoImagePreview.image = image
        }
        else
        {
            videoImagePreview.image = UIImage(named:"SideMenuUploadVideo")
            
            playVideoImageView.image = nil
        }
        
        
        let uploadButton = cell.viewWithTag(103) as! subclassedUIButton
        
        if uploadedVideoNamesArray.contains(videoName)
        {
            uploadButton.setTitle("Uploaded", for: .normal)
            uploadButton.setTitleColor(UIColor.appliedJobGreenColor(), for: .normal)
            uploadButton.isUserInteractionEnabled = false
        }
        else
        {
            uploadButton.setTitle("Upload", for: .normal)
            uploadButton.setTitleColor(UIColor.appBlueColor(), for: .normal)
            uploadButton.isUserInteractionEnabled = true
        }
        
        uploadButton.addTarget(self, action: #selector(uploadButtonCLicked(sender:)), for: .touchUpInside)
        
        uploadButton.indexPath = indexPath.row
       // uploadButton.layer.borderWidth = 1.0
        
        //uploadButton.layer.borderColor = UIColor(colorLiteralRed: 29/255.0, green: 123/255.0, blue: 231/255.0, alpha: 1.0).cgColor
        
        return cell
    }
    
    func uploadButtonCLicked( sender: subclassedUIButton)
    {
        //self.perform(#selector(startUploading(sender:)), on: .main, with: sender, waitUntilDone: true)
//        DispatchQueue.main.async(execute: {
//            self.startUploading(sender: sender)
//
//            
//        })
        
        //self.startUploading(sender: sender)
        DispatchQueue.main.async(execute: {
            self.perform(#selector(self.showHud), on: .main, with: nil, waitUntilDone: true)
            self.perform(#selector(self.startUploading(sender:)), on: .main, with: sender, waitUntilDone: false)

            //self.startUploading(sender: sender)

        })
        //DispatchQueue.global().async {
//
            
//
        //}

    }
    
    func showHud()
    {
        AppPreferences.sharedPreferences().showHudWith(title: "Uploading Video..", detailText: "Please wait")

    }
    
    func startUploading( sender: subclassedUIButton)
    {
        //        if uploadedVideoNamesArray.count <= 2
        //        {
        let videoName = recordedVideoNamesArray[sender.indexPath]
        
        self.uploadingRow = sender.indexPath
        
        let savePath:String = self.UserVideosFolderPath() + "/" + videoName + ".mp4"
        
        let videoURL = URL(fileURLWithPath: savePath)
        
        var videoData = Data()
        do {
            videoData = try Data(contentsOf: videoURL)
            
        } catch let error as NSError
        {
            
        }
        
        
        
//            let alertController = UIAlertController(title: "Upload File", message: "Are you sure to upload this file?", preferredStyle: UIAlertControllerStyle.alert)
//
//            let okAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.default, handler: { act -> Void in
        
                
                //AppPreferences.sharedPreferences().showHudWith(title: "Uploading Video..", detailText: "Please wait")
                
                
                
                
                    
                    let ftp = FTPImageUpload(baseUrl: Constant.FTP_HOST_NAME, userName: Constant.FTP_USERNAME, password: Constant.FTP_PASSWORD, directoryPath: Constant.FTP_DIRECTORY_PATH)
                    
                    let result = ftp.send(data: videoData, with: videoName)
                    if result
                    {
                       // AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
                        
                        
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
                    print(result)
                    
//                })
//                
//
//                
//        
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {act -> Void in
//                
//                alertController.dismiss(animated: true, completion: nil)
//                
//            })
//            alertController.addAction(okAction)
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
    
//        DispatchQueue.global().async
//            {
//                
//                
//                
//        }
        
        
        
        //        }
        //
        //        else
        //        {
        //            AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Maximum 3 videos can be upload, please delete exsting videos", withCancelText: "ok")
        //        }
  
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 10), height: CGFloat(100))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var savePath:String = self.UserVideosFolderPath() + "/" + recordedVideoNamesArray[indexPath.row] + ".mp4"
        //savePath = savePath.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let videoURL = URL(fileURLWithPath: savePath)
        
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
//
//        let asset = AVURLAsset(url: videoURL)
//        let item = AVPlayerItem(asset: asset)
//        
//        
//        let player1 = AVPlayer(playerItem: item)
//        
//        playerViewController.player = player1
//        
//        playerViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        
//        playerViewController.showsPlaybackControls = true
//        
//        self.view.addSubview(playerViewController.view)
//        
//        player1.play()
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayVideoViewController") as! PlayVideoViewController
//        
//        vc.filePath = savePath
//        
//        self.present(vc, animated: true, completion: nil)
        
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//         return 20
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 20.0
//    }
   
    
    
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
