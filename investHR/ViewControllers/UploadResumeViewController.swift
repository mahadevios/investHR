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
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        let data = NSData(contentsOf: url)
        
        print(url.pathExtension)
        
        let imageView = self.view.viewWithTag(101) as! UIImageView
        
        imageView.image = UIImage(data: data as! Data)
        
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
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text","public.image","public.movie"], in: UIDocumentPickerMode.import)
        
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
