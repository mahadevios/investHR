//
//  EditProfileViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import CoreData

class EditProfileViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var circleImageView: UIImageView!

    @IBOutlet weak var outSideCircleView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var qualificationTextField: UITextField!
    @IBOutlet weak var cuurentRoleTextField: UITextField!
    @IBOutlet weak var currentCompanyTextField: UITextField!
    @IBOutlet weak var additionalPhoneTextfield: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var aboutYouTextView: UITextView!
    var coutryCodesArray:[String] = []

    @IBOutlet weak var editProfileButton: UIButton!
    @IBAction func editProfileButtonClicked(_ sender: Any)
    {
        showImagePickerController()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        coutryCodesArray = ["+90","+91","+92","+93","+94","+95","+96"]

        
        setNavigationItem()
        
        setProfileView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
    //    super.viewWillAppear(true)
      editProfileButton.setTitle("", for: .normal)
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        locationTextField.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool)
    {
       NotificationCenter.default.removeObserver(self)
    }
    
    func popViewController() -> Void
    {
        self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationItem()
    {
        
        setLeftBarButtonItem()
        setRightBarButtonItemEdit()
        
    }
    func setLeftBarButtonItem()
    {
        self.navigationItem.hidesBackButton = true;
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = barButtonItem
        self.navigationItem.title = "Profile"
    }
    func setRightBarButtonItemEdit()
    {
        let editProfileButton = UIButton(frame: CGRect(x: 75, y: 0, width: 50, height: 50))
        editProfileButton.setTitle("Edit", for: UIControlState.normal)
        editProfileButton.addTarget(self, action: #selector(rightbarButtonClickedEdit), for: UIControlEvents.touchUpInside)
        editProfileButton.titleLabel?.textAlignment = NSTextAlignment.center
        editProfileButton.setTitleColor(UIColor.init(colorLiteralRed: 82/255.0, green: 158/255.0, blue: 242/255.0, alpha: 1), for: UIControlState.normal)
        
        let lineView = UIView(frame: CGRect(x: 65, y: 2, width: 1, height: 40))
        lineView.backgroundColor = UIColor.init(colorLiteralRed: 82/255.0, green: 158/255.0, blue: 242/255.0, alpha: 1)
        
        let editProfileView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        //editProfileView.backgroundColor = UIColor.red
        editProfileView.addSubview(editProfileButton)
        editProfileView.addSubview(lineView)
        
        let rightBarButtonItem = UIBarButtonItem(customView: editProfileView)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    
    }
    func setRightBarButtonItemCancel()
    {
        let editProfileButton = UIButton(frame: CGRect(x: 55, y: 0, width: 80, height: 50))
        
        editProfileButton.setTitle("Cancel", for: UIControlState.normal)
        
        editProfileButton.addTarget(self, action: #selector(rightbarButtonClickedCancel), for: UIControlEvents.touchUpInside)
        
        editProfileButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        editProfileButton.setTitleColor(UIColor.init(colorLiteralRed: 82/255.0, green: 158/255.0, blue: 242/255.0, alpha: 1), for: UIControlState.normal)
        
        let editProfileView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        //editProfileView.backgroundColor = UIColor.red
        editProfileView.addSubview(editProfileButton)
        
        let rightBarButtonItem = UIBarButtonItem(customView: editProfileView)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func rightbarButtonClickedEdit()
    {
        
    }
    func rightbarButtonClickedCancel()
    {
        self.view.viewWithTag(1000)?.removeFromSuperview()
        
        let vcArray = self.childViewControllers
        
        for vc in vcArray
        {
            if vc.isKind(of: UIImagePickerController.classForCoder())
            {
                vc.removeFromParentViewController()
            }
        }
        
        hideBarButtonItems(hide: false)

       // picker.removeFromParentViewController()
    }
    func setProfileView()
    {
        self.perform(#selector(addView), with: nil, afterDelay: 0.2)
        
        aboutYouTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        aboutYouTextView.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 5, width: 15, height: 20))
        let image = UIImage(named: "Username")
        imageView.image = image
        nameTextField.addSubview(imageView)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 5, width: 65, height: 40))
        let imageView1 = UIImageView(frame: CGRect(x: 15, y: 7, width: 18, height: 17))
        let image1 = UIImage(named: "Mobile")
        imageView1.image = image1
        leftView.addSubview(imageView1)
        
        let countryCodePickerView = UIPickerView(frame: CGRect(x: 35, y: 1, width: 40, height: 40))
        countryCodePickerView.dataSource = self
        countryCodePickerView.delegate = self
        leftView.addSubview(countryCodePickerView)
        mobileNumberTextField.leftView = leftView
        mobileNumberTextField.leftViewMode = UITextFieldViewMode.always
        
        
        
        let imageView2 = UIImageView(frame: CGRect(x: 15, y: 5, width: 16, height: 12))
        let image2 = UIImage(named: "Email")
        imageView2.image = image2
        emailTextField.addSubview(imageView2)
        
        let imageView3 = UIImageView(frame: CGRect(x: 15, y: 5, width: 20, height: 15))
        let image3 = UIImage(named: "Qualification")
        imageView3.image = image3
        qualificationTextField.addSubview(imageView3)
        
        let imageView4 = UIImageView(frame: CGRect(x: 15, y: 5, width: 10, height: 20))
        let image4 = UIImage(named: "Role")
        imageView4.image = image4
        cuurentRoleTextField.addSubview(imageView4)
        
        let imageView5 = UIImageView(frame: CGRect(x: 15, y: 5, width: 20, height: 20))
        let image5 = UIImage(named: "Company")
        imageView5.image = image5
        currentCompanyTextField.addSubview(imageView5)
        
        let imageView6 = UIImageView(frame: CGRect(x: 15, y: 5, width: 18, height: 17))
        let image6 = UIImage(named: "Mobile")
        imageView6.image = image6
        additionalPhoneTextfield.addSubview(imageView6)
        
        let imageView7 = UIImageView(frame: CGRect(x: 15, y: 5, width: 14, height: 17))
        let image7 = UIImage(named: "Location")
        imageView7.image = image7
        locationTextField.addSubview(imageView7)

    
    }
    
    
    
    func hideBarButtonItems( hide:Bool)
    {
        if hide
        {
            self.navigationItem.leftBarButtonItem = nil
            setRightBarButtonItemCancel()
        }
        else
        {
           setLeftBarButtonItem()
           setRightBarButtonItemEdit()
        }
        
        //self.navigationItem.leftBarButtonItem.hide
    }
    func addView() -> Void
    {
        outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0
        
        circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0
        
        outSideCircleView.clipsToBounds = true;
        
        outSideCircleView.image = UIImage(named:"OutsideCircle")
        
        circleImageView.clipsToBounds = true;
        
        circleImageView.image = UIImage(named:"InsideDefaultCircle")
        
        showData()
        
    }
    
    
    
    func showImagePickerController()
    {
        let imagePickerController = UIImagePickerController()
        
        
        imagePickerController.view.frame = self.view.frame
        
        imagePickerController.delegate = self
        
        imagePickerController.view.tag = 1000
        
        imagePickerController.sourceType = .photoLibrary
        
        self.addChildViewController(imagePickerController)
        
        imagePickerController.didMove(toParentViewController: self)
        
        self.view.addSubview(imagePickerController.view)
        
        hideBarButtonItems(hide: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage]
        
        let refURL = info[UIImagePickerControllerReferenceURL]
        
        let v = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        circleImageView.image = v
        
        picker.view!.removeFromSuperview()
        
        picker.removeFromParentViewController()
        
        hideBarButtonItems(hide: false)

        
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        
            aboutYouTextView.text = "";
            aboutYouTextView.textColor = UIColor.black
        
        return true;
    }
    
    
    func textViewDidChange(_ textView: UITextView)
    {
       
            if aboutYouTextView.text!.characters.count == 0
            {
                aboutYouTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
                aboutYouTextView.text = "Companies interviewed in past 1 year";
            }
        
        
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return coutryCodesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return coutryCodesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        
        var label = view as! UILabel!
        if label == nil
        {
            label = UILabel()
        }
        
        label?.font = UIFont.systemFont(ofSize: 12)
        label?.text =  coutryCodesArray[row] as? String
        label?.textAlignment = .center
        return label!
        
    }
    
    func Edit() -> Void
    {
        
    }
    func showData() -> Void
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.fetch(entity: "User")
            for userObject in managedObjects as! [User]
            {
                let firstName = userObject.firstName
                let lastName = userObject.lastName
                let pictureUrlString = userObject.pictureUrl
                
                guard firstName != nil else
                {
                    break
                }
                nameTextField.text = "\(firstName!) \(lastName!)"

                guard userObject.emailAddress != nil else
                {
                    break
                }
                emailTextField.text = userObject.emailAddress
                
                guard userObject.occupation != nil else
                {
                    break
                }
                cuurentRoleTextField.text = userObject.occupation
                
                DispatchQueue.global(qos: .background).async
                    {
                    
                        if let pictureUrlString = pictureUrlString
                        {
                            let pictureUrl = URL(string: pictureUrlString)
                            
                            guard pictureUrl != nil else
                            {
                                return
                            }
                            //                    if let pictureUrl = pictureUrl
                            //                    {
                            do
                            {
                                let imageData = try Data(contentsOf: pictureUrl! as URL)
                                
                                let userImage = UIImage(data: imageData)
                                
                                DispatchQueue.main.async
                                    {
                                        self.circleImageView.image = userImage

                                    }

                                
                            }
                            catch let error as NSError
                            {
                                print(error.localizedDescription)
                            }
                            // }
                        }

                    
                }
                
                
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
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
