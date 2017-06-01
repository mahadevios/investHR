//
//  UploadVideoViewController.swift
//  investHR
//
//  Created by mac on 30/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import AVFoundation

class UploadVideoViewController: UIViewController,UIDocumentPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var imagePicker = UIImagePickerController()
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
        let savePath:String = self.documentsPath()! + "/" + self.presentDateTimeString() + ".mp4"
        
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Upload Video"
        
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

    func popViewController() -> Void
    {
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    func rightBArButtonCLicked() -> Void
    {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text","public.image","public.movie"], in: UIDocumentPickerMode.import)
        
        documentPickerController.delegate = self
        
        present(documentPickerController, animated: true, completion: nil)
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
