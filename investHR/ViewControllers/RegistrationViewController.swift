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
//    lazy var imagePicker:UIImagePickerController = {
//    
//        let picker = UIImagePickerController()
//        
//        return  picker
//    }()
    var imagePicker:UIImagePickerController? = UIImagePickerController()
    //var picker = UIImagePickerController()
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
       // coutryCodesArray = ["+90","+91","+92","+93","+94","+95","+96"]
        
        coutryCodesArray = ["+1","+93","+355","+213","+1 684","+376","+244","+1 264","+672","+64","+1 268","+54","+374","+297","+247","+61","+43","+994","+1 242","+973","+880","+1 246","+375","+32","+501","+229","+1 441","+975","+591","+387","+267","+55","+1 284","+673","+359","+226","+95","+257","+855","+237","+238","+1 345","+236","+235","+56","+86","+61","+57","+269","+242","+682","+506","+385","+53","+357","+420","+243","+45","+246","+253","+1 767","+1 809","+1 829","+1, 849","+593","+20","+503","+240","+291","+372","+251","+500","+298","+679","+358","+33","+594","+689","+241","+220","+995","+49","+233","+350","+30","+299","+1 473","+590","+1 671","+502","+224","+245","+592","+509","+39","+504","+852","+36","+354","+91","+62","+98","+964","+353","+44","+972","+225","+1 876","+81","+962","+7","+254","+686","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+596","+222","+230","+262","+52","+691","+373","+377","+976","+382","+1 664","+212","+258","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+672","+850","+1 670","+47","+968","+92","+680","+970","+507","+595","+51","+63","+870","+48","+351","+1 787","+1 939","+974","+242","+262","+40","+250","+590","+290","+1 869","+1 758","+508","+1 784","+685","+378","+239","+966","+221","+381","+248","+232","+65","+1 721","+421","+386","+677","+252","+27","+82","+211","+34","+94","+249","+597","+47","+268","+46","+41","+963","+886","+992","+255","+66","+670","+228","+690","+676","+1 868","+216","+90","+993","+1 649","+688","+256","+380","+971","+598","+1 340","+998","+678","+58","+84","+681","+212","+967","+260","+263"]
        
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.perform(#selector(addView), with: nil, afterDelay: 0.2)
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 5, width: 15, height: 20))
        let image = UIImage(named: "Username")
        imageView.image = image
        nameTextField.addSubview(imageView)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 5, width: 65, height: 40))
        let imageView1 = UIImageView(frame: CGRect(x: 15, y: 10, width: 18, height: 17))
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
        mobileNumberTextField.leftViewMode = UITextField.ViewMode.always
        
        
        
        
        let imageView2 = UIImageView(frame: CGRect(x: 15, y: 9, width: 16, height: 12))
        let image2 = UIImage(named: "Email")
        imageView2.image = image2
        
        emailTextField.addSubview(imageView2)
        
        let imageView3 = UIImageView(frame: CGRect(x: 15, y: 5, width: 16, height: 21))
        let image3 = UIImage(named: "Password")
        imageView3.image = image3
        
        passwordTextField.addSubview(imageView3)

        self.imagePicker!.delegate = self
        //self.addView()
        // Do any additional setup after loading the view.
    }
    @objc func countryCodeButtonClicekd(sender:UIButton)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
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
            if emailTextField.text == "" || !(emailTextField.text?.contains("@"))!  || !(emailTextField.text?.contains("."))!
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
                    
                    if mobileNumberTextField.text == "" || mobileNumberTextField.text == nil
                    {
                        viewController.mobile = ""
                    }
                    else
                    {
                        viewController.mobile = countryCode! + "-" + mobileNumberTextField.text!

                    }
        
                    viewController.password = passwordTextField.text
                    
                    viewController.imageData = imagedata
        
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
        
        
        
        //self.present(viewController, animated: true, completion: nil)
        
    }
    @IBAction func changeProfilePictureButtonClicked(_ sender: Any)
    {
        //let imagePickerController = ImagePickerController.getSharedPickerController()
        
       // imagePickerController.delegate = self
        self.imagePicker!.allowsEditing = false

        self.imagePicker!.sourceType = .photoLibrary
        
//        self.addChildViewController(self.imagePicker)
//        
//        self.imagePicker.didMove(toParentViewController: self)
//        
//        self.view.addSubview(self.imagePicker.view)
        
       self.present(self.imagePicker!, animated: true, completion: nil)

        
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        DispatchQueue.main.async
            {
                AppPreferences.sharedPreferences().showHudWith(title: "Loading Image", detailText: "Please wait..")
        }
        //let chosenImage = info[UIImagePickerControllerOriginalImage]
        
        //let chosenImageName = info[UIImagePickerControllerOriginalImage]

        
        //let refURL = info[UIImagePickerControllerReferenceURL]
        
        let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let width = userImage?.size.width
        
        let height = userImage?.size.height

        let size = CGSize(width: width!, height: height!)
        
        
        imagedata = nil
        
//        imagedata = UIImageJPEGRepresentation(userImage!, 0.01)!

        imagedata = userImage?.jpegData(compressionQuality: 0.01)
        //imagedata    = UIImagePNGRepresentation(image) as Data!
        let compressedImage = UIImage(data: imagedata as! Data)
        
        let image = imageResize(image: compressedImage!,sizeChange: size)

        var imageName:String!
        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            imageName = asset?.value(forKey: "filename") as! String?
//            print(asset?.value(forKey: "filename") ?? "nil")
            
        }
        circleImageView.image = nil
        
        circleImageView.image = image
        
        
        //picker.view!.removeFromSuperview()
        
        //picker.removeFromParentViewController()
        
        //self.imagePicker.view.removeFromSuperview()
        
       // self.imagePicker.removeFromParentViewController()
        
        self.imagePicker!.dismiss(animated: true, completion: nil)
       // ImagePickerController.getSharedPickerController().dismiss(animated: true, completion: nil)

        DispatchQueue.main.async
        {
            AppPreferences.sharedPreferences().hideHudWithTag(tag: 789)
        }
        //let uniqueImageName = String(Date().millisecondsSince1970)
        
       // print(uniqueImageName)
        
        ///let ftp = FTPImageUpload(baseUrl: Constant.FTP_HOST_NAME, userName: Constant.FTP_USERNAME, password: Constant.FTP_PASSWORD, directoryPath: Constant.FTP_DIRECTORY_PATH)
        
        //let result = ftp.send(data: data!, with: uniqueImageName+imageName)
        
        //print(result)
        
    }
    func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage{
        
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    
    @objc func addView() -> Void
    {
        outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0
        
        circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0
        
        outSideCircleView.clipsToBounds = true;
        
        outSideCircleView.image = UIImage(named:"OutsideCircle")
        
        circleImageView.clipsToBounds = true;
        
        circleImageView.image = UIImage(named:"InsideDefaultCircle")

    }
    
    @objc func deviceRotated() -> Void
    {
        if UIDevice.current.orientation.isLandscape
        {
            //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
           // addView()
           // print("Landscape")
            outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0

            circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0

        }
        
        if UIDevice.current.orientation.isPortrait
        {
            //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
           // addView()
           // print("Portrait")
            outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0

            circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0

        }
    }
    
    @objc func keyboardWillShow()
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
    
    @objc func keyboardWillHide()
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
        
        if UIDevice.current.orientation.isLandscape
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
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == self.emailTextField
        {
            if self.emailTextField.text != nil
            {
                let emailClean = self.emailTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces) 
                
                self.emailTextField.text = emailClean
            }
            
        }

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
        
        var label = view as! UILabel?
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
    
    
    @objc func pickerDoneButtonPressed()
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
