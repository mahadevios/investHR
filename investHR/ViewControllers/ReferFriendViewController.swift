//
//  ReferFriendViewController.swift
//  investHR
//
//  Created by mac on 30/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import Social

class ReferFriendViewController: UIViewController,UIActivityItemSource
{
   

    var metaDataQuery = NSMetadataQuery()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Refer a friend"
        
        
        //let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(showActivityController))

        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        //self.serachiCloud()
        //let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], inMode: .Import)
        
//        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text","public.image"], in: UIDocumentPickerMode.import)
//        
//        documentPickerController.delegate = self
//        present(documentPickerController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    func popViewController() -> Void
    {
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }

    func showActivityController()
    {
        let tweetAction = UIAlertAction(title: "Tweeter", style: UIAlertActionStyle.default, handler:{ act -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
            {
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                twitterComposeVC?.setInitialText("Sample tweet from my app(Social app integration)")
                
                self.present(twitterComposeVC!, animated: true, completion: nil)
                
            }
            else
            {
                let alertController = UIAlertController(title: "Not logged in", message: "Please login to share", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { act -> Void in
                    
                    alertController.dismiss(animated: true, completion: nil)
                }
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {act -> Void in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                })
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        })
        
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.default) { (action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposeVC?.setInitialText("Facebook")
                
                self.present(facebookComposeVC!, animated: true, completion: nil)
            }
            else {
                //self.showAlertMessage("You are not connected to your Facebook account.")
            }
        }
        
        let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.default, handler:{ act -> Void in })
        
        let cancelAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { act -> Void in})
        
        let url = NSURL(string:"itms://itunes.com/apps/CubeDictate")
        
        let alertController = UIActivityViewController(activityItems:[url], applicationActivities: nil)
        
        // alertController .addAction(tweetAction)
        
        // alertController.addAction(facebookPostAction)
        
        // alertController.addAction(moreAction)
        
        // alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: {})
    }
    
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any
    {
        
        return NSURL(string:"itms://itunes.com/apps/CubeDictate") ?? "investHR"
    }
    
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any?
    {

            return "Get investHR iOS application"

    }
    
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String
    {

        return "Get investHR iOS application"

        
    }
    
    func serachiCloud()
    {
        let filemgr = FileManager.default
        
        let ubiquityURL = filemgr.url(forUbiquityContainerIdentifier: nil)
        
        guard ubiquityURL != nil else {
            print("Unable to access iCloud Account")
            print("Open the Settings app and enter your Apple ID into iCloud settings")
            return
        }
        
//        ubiquityURL = ubiquityURL?.appendingPathComponent(
//            "Documents/savefile.txt")
        
//        metaDataQuery = NSMetadataQuery()
        
        metaDataQuery.predicate =
            NSPredicate(format: "%K like 'AppIcon'",
                        NSMetadataItemFSNameKey)

//        metaDataQuery.predicate =
//            NSPredicate(format: "NOT %K.pathExtension = '.'",
//                        NSMetadataItemFSNameKey)
        
        metaDataQuery.searchScopes =
            [NSMetadataQueryUbiquitousDocumentsScope,NSMetadataQueryUbiquitousDataScope]
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(
                                                metadataQueryDidFinishGathering),
                                               name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
                                               object: metaDataQuery)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(
//                                                metadataQueryDidFinishGathering),
//                                               name: NSNotification.Name.NSMetadataQueryDidUpdate,
//                                               object: metaDataQuery)
        
        metaDataQuery.start()
    }
    
    func metadataQueryDidFinishGathering( notification:AnyObject)
    {
     
        print("metadata value is", notification)
        
        let query: NSMetadataQuery = notification.object as! NSMetadataQuery
        
        query.disableUpdates()
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
                                                  object: query)
        
        query.stop()
        
//        let resultURL = query.value(ofAttribute: NSMetadataItemURLKey,
//                                    forResultAt: 0) as! URL
        
        if query.resultCount == 1 {
            let resultURL = query.value(ofAttribute: NSMetadataItemURLKey,
                                        forResultAt: 0) as! URL
            
            print("resultURL", resultURL)
//            document = MyDocument(fileURL: resultURL as URL)
//            
//            document?.open(completionHandler: {(success: Bool) -> Void in
//                if success {
//                    print("iCloud file open OK")
                    //self.textView.text = self.document?.userText
                    //self.ubiquityURL = resultURL as URL
//                } else {
//                    print("iCloud file open failed")
//                }
//            })
        } else {
//            document = MyDocument(fileURL: ubiquityURL!)
//            
//            document?.save(to: ubiquityURL!,
//                           for: .forCreating,
//                           completionHandler: {(success: Bool) -> Void in
//                            if success {
//                                print("iCloud create OK")
//                            } else {
//                                print("iCloud create failed")
//                            }
//            })
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
