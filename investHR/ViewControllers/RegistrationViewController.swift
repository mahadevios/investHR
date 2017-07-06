//
//  RegistrationViewController.swift
//  investHR
//
//  Created by mac on 23/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

import Photos

import AssetsLibrary

class RegistrationViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var outSideCircleView: UIImageView!
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var mobileNumberTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    var movedUpBy:String = ""
    var imagedata:Any!
    var countryCodeButton:UIButton!

    var coutryCodesArray:[String] = []
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        coutryCodesArray = ["+90","+91","+92","+93","+94","+95","+96"]

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.perform(#selector(addView), with: nil, afterDelay: 0.2)
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 5, width: 15, height: 20))
        let image = UIImage(named: "Username")
        imageView.image = image
        nameTextField.addSubview(imageView)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 5, width: 65, height: 40))
        let imageView1 = UIImageView(frame: CGRect(x: 15, y: 7, width: 18, height: 17))
        let image1 = UIImage(named: "Mobile")
        imageView1.image = image1
        leftView.addSubview(imageView1)
        
//        let countryCodePickerView = UIPickerView(frame: CGRect(x: 35, y: 1, width: 40, height: 40))
//        countryCodePickerView.dataSource = self
//        countryCodePickerView.delegate = self
        countryCodeButton = UIButton(frame: CGRect(x: 35, y: 1, width: 40, height: 40))
        countryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        countryCodeButton.setTitleColor(UIColor.black, for: .normal)
        countryCodeButton.setTitle("\(coutryCodesArray[0])", for: .normal)
        countryCodeButton.addTarget(self, action: #selector(countryCodeButtonClicekd), for: .touchUpInside)
        leftView.addSubview(countryCodeButton)
       // leftView.addSubview(countryCodePickerView)
        mobileNumberTextField.leftView = leftView
        mobileNumberTextField.leftViewMode = UITextFieldViewMode.always
        
        
        
        
        let imageView2 = UIImageView(frame: CGRect(x: 15, y: 5, width: 16, height: 12))
        let image2 = UIImage(named: "Email")
        imageView2.image = image2
        
        emailTextField.addSubview(imageView2)
        
        let imageView3 = UIImageView(frame: CGRect(x: 15, y: 5, width: 16, height: 21))
        let image3 = UIImage(named: "Password")
        imageView3.image = image3
        
        passwordTextField.addSubview(imageView3)

        //self.addView()
        // Do any additional setup after loading the view.
    }
    func countryCodeButtonClicekd(sender:UIButton)
    {
        resignAllResponders()
        self.addPickerToolBarForCountryCodes()
        
    }
    
    func resignAllResponders()
    {
        nameTextField.resignFirstResponder()
        mobileNumberTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        nameTextField.delegate = self
        emailTextField.delegate = self
        mobileNumberTextField.delegate = self
        passwordTextField.delegate = self
        
       // LISDKSessionManager.clearSession()
        
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
       NotificationCenter.default.removeObserver(self)
    }
  
    @IBAction func backButtonPressed(_ sender: Any)
    {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func nextButtonPressed(_ sender: Any)
    {
        if nameTextField.text == ""
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Please enter a name", withCancelText: "Ok")
        }
        else
            if emailTextField.text == "" || !(emailTextField.text?.contains("@"))!
            {
                AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Please enter a valid email address", withCancelText: "Ok")
            }
            else
                if passwordTextField.text == ""
                {
                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Please enter a password", withCancelText: "Ok")
                }
                else
                {
                    let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "Registration1ViewController") as! Registration1ViewController
        
                    viewController.email = emailTextField.text
        
                    viewController.name = nameTextField.text
        
                    let countryCode = countryCodeButton.titleLabel?.text
                    
                    viewController.mobile = countryCode! + mobileNumberTextField.text!
        
                    viewController.password = passwordTextField.text
                    
                    viewController.imageData = imagedata
        
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
        
        
        
        //self.present(viewController, animated: true, completion: nil)
        
    }
    @IBAction func changeProfilePictureButtonClicked(_ sender: Any)
    {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = .photoLibrary
        
        self.addChildViewController(imagePickerController)
        
        imagePickerController.didMove(toParentViewController: self)
        
        self.view.addSubview(imagePickerController.view)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage]
        
        let chosenImageName = info[UIImagePickerControllerOriginalImage]

        
        let refURL = info[UIImagePickerControllerReferenceURL]
        
        let userImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imagedata    = UIImagePNGRepresentation(userImage!) as Data!

        var imageName:String!
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            imageName = asset?.value(forKey: "filename") as! String!
            print(asset?.value(forKey: "filename") ?? "nil")
            
        }
        circleImageView.image = userImage
        
        picker.view!.removeFromSuperview()
        
        picker.removeFromParentViewController()
        
        let uniqueImageName = String(Date().millisecondsSince1970)
        
        print(uniqueImageName)
        
        ///let ftp = FTPImageUpload(baseUrl: Constant.FTP_HOST_NAME, userName: Constant.FTP_USERNAME, password: Constant.FTP_PASSWORD, directoryPath: Constant.FTP_DIRECTORY_PATH)
        
        //let result = ftp.send(data: data!, with: uniqueImageName+imageName)
        
        //print(result)
        
    }
    
    func addView() -> Void
    {
        outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0
        
        circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0
        
        outSideCircleView.clipsToBounds = true;
        
        outSideCircleView.image = UIImage(named:"OutsideCircle")
        
        circleImageView.clipsToBounds = true;
        
        circleImageView.image = UIImage(named:"InsideDefaultCircle")

    }
    
    func deviceRotated() -> Void
    {
//        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
//        {
//            //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
//            addView()
//            print("Landscape")
//        }
//        
//        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
//        {
//            //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
//            addView()
//            print("Portrait")
//        }
    }
    
    func keyboardWillShow()
    {
            // Animate the current view out of the way
        if self.view.frame.origin.y >= 0
        {
            if emailTextField.isFirstResponder
            {
                movedUpBy = "email"
            }
            else
            if passwordTextField.isFirstResponder
            {
                movedUpBy = "password"
            }
            else
            if nameTextField.isFirstResponder
            {
                movedUpBy = "name"
            }
            else
            if mobileNumberTextField.isFirstResponder
            {
                movedUpBy = "mob"
            }
            
            setViewMovedUp(movedUp: true, offset: 100)
        }
//        else
//            if self.view.frame.origin.y < 0
//            {
//                setViewMovedUp(movedUp: false, offset: 100)
//            }
    }
    
    func keyboardWillHide()
    {
        if self.view.frame.origin.y > 0
        {
            
            setViewMovedUp(movedUp: true, offset: 100)
        }
        else
            if self.view.frame.origin.y < 0
        {
            setViewMovedUp(movedUp: false, offset: 100)
        }
    }
    
    func setViewMovedUp(movedUp:ObjCBool, offset:CGFloat)
    {
        var localOffset = offset
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            if (movedUpBy == "email" || movedUpBy == "password")
            {
                localOffset = 220
            }
            else
            {
                localOffset = 150
            }
        }
        else
        {
            localOffset = 100
        }
        
    
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.3)
    
        var rect = self.view.frame
        if movedUp.boolValue
        {
                // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
                // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.origin.y -= localOffset;
            rect.size.height += localOffset;
    
        }
        else
        {
                // revert back to the normal state.
            rect.origin.y += localOffset;
            rect.size.height -= localOffset;
        }
        self.view.frame = rect;
        
        UIView.commitAnimations()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
//        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
//        {
//            if textField == emailTextField || textField == passwordTextField
//            {
//                setViewMovedUp(movedUp: true, offset: 180)
//            }
//            else
//            {
//                setViewMovedUp(movedUp: true, offset: 100)
//            }
//        }
//        else
//        {
//            setViewMovedUp(movedUp: true, offset: 100)
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
//        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
//        {
//            if textField == emailTextField || textField == passwordTextField
//            {
//                setViewMovedUp(movedUp: false, offset: 180)
//            }
//            else
//            {
//                setViewMovedUp(movedUp: false, offset: 100)
//            }
//        }
//        else
//        {
//            setViewMovedUp(movedUp: false, offset: 100)
//        }
        textField.resignFirstResponder()
        return true
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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        //
        //        if pickerView.tag == 1
        //        {
        //            label?.font = UIFont.systemFont(ofSize: 12)
        //            label?.text =  candidateFunctionArray[row] as? String
        //            label?.textAlignment = .left
        //        }
        //        else
        //        {
        label?.font = UIFont.systemFont(ofSize: 14)
        label?.text =  coutryCodesArray[row] as String
        
        label?.textAlignment = .center
        // label?.textAlignment = .left
        //}
        
        return label!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
                let selectedCountryCode = coutryCodesArray[row]
                
                countryCodeButton.setTitle(selectedCountryCode, for: .normal)
                // relocationTextFIeld.text = selectedRole
        
    }
    
    func addPickerToolBarForCountryCodes()
    {
        if self.view.viewWithTag(10000) == nil
        {
            
            let picker = UIPickerView()
            
            picker.tag = 10001;
            
            picker.frame = CGRect(x: 0.0, y: self.view.frame.size.height - 216.0, width: self.view.frame.size.width, height: 216.0)
            
            picker.delegate = self
            
            picker.dataSource = self
            
            picker.showsSelectionIndicator = true
            
            self.view.addSubview(picker)
            
            picker.isUserInteractionEnabled = true
            
            picker.backgroundColor = UIColor.lightGray
            
            //        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressToGetValue:)];
            let btn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonPressed))
            
            //        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, picker.frame.origin.y - 40.0f, self.view.frame.size.width, 40.0f)];
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: picker.frame.origin.y - 40.0, width: self.view.frame.size.width, height: 40.0))
            
            toolBar.tag = 10000
            
            toolBar.setItems([btn], animated: true)
            
            self.view.addSubview(toolBar)
            //     OperatorTextField.inputAccessoryView=toolBar;
        }
    }
    
    
    func pickerDoneButtonPressed()
    {
        removePickerToolBar()
    }
    
    func removePickerToolBar()
    {
        if let picker = self.view.viewWithTag(10000)
        {
            picker.removeFromSuperview()
            
        }
        
        
       
        
       
        
        if let toolbar1 = self.view.viewWithTag(10001)
        {
            toolbar1.removeFromSuperview()
            
        }
     
        
        // [DescriptionTextView becomeFirstResponder];
        
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
