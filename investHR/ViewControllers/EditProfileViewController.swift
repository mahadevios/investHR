//
//  EditProfileViewController.swift
//  investHR
//
//  Created by mac on 29/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import CoreData
import Photos

import AssetsLibrary
class EditProfileViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,URLSessionDelegate
{
    @IBOutlet weak var circleImageView: UIImageView!

    @IBOutlet weak var outSideCircleView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cuurentRoleTextField: UITextField!
    @IBOutlet weak var currentCompanyTextField: UITextField!
    @IBOutlet weak var stateTextField: SearchTextField!
    var coutryCodesArray:[String] = []
    var imagedata:Any!
    var candidateFunctionArray : [String] = []
    //    let servicesArray : [String] = ["Services","Service 2","Service 3","Service 4","Service 5"]
    let relocationArray = ["Not Available","Yes","No","May be"]
    let relocationDic = ["Yes":"1","No":"2","May be":"3","Not Available":"4"]
    let visaTypesArray = ["US Citizen","Green Card Holder","UK Tier 1 Visa","Uk Tier 2 Visa","UK Citizen","UK – PR"," Canadian Citizen","TN Visa","Euro Zone Citizen","EAD card Holder","L2 EAD","H1 Visa","L1 Visa","H4 Visa","L2 Visa"]
    let visaTypesAndIdArray = ["US Citizen":"1","Green Card Holder":"2","UK Tier 1 Visa":"3","Uk Tier 2 Visa":"4","UK Citizen":"5","UK – PR":"6"," Canadian Citizen":"7","TN Visa":"8","Euro Zone Citizen":"9","EAD card Holder":"10","L2 EAD":"11","H1 Visa":"12","L1 Visa":"13","H4 Visa":"14","L2 Visa":"15"]
    var roleNameAndIdDic = [String:Int16]()
    var countryCodeButton:UIButton!
    @IBOutlet weak var visaStatusTextField: TextField!
    @IBOutlet weak var cityTextField: SearchTextField!
    
    @IBOutlet weak var verticalsTextFiled: UITextField!
    
    @IBOutlet weak var PLTextFiled: UITextField!
    @IBOutlet weak var revenueQuotaTextFiled: UITextField!
    @IBOutlet weak var linkedInProfileUrlTextField: UITextField!
    @IBOutlet weak var servicesTextField: UITextField!
    @IBOutlet weak var candidateFunctionTextField: UITextField!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var experienceTextField: UITextField!
    
    @IBOutlet weak var expectedCompanyTextField: UITextField!

    @IBOutlet weak var benefitsTextView: UITextView!
    @IBOutlet weak var nonCompeteTextView: UITextView!
    @IBOutlet weak var companiesInterviewedTextView: UITextView!
    @IBOutlet weak var joiningTimeTextFIeld: UITextField!
    @IBOutlet weak var relocationTextFIeld: UITextField!
    
    //@IBOutlet weak var passwordTextField: TextField!
    
    var statesArray:[String] = []
    var cityArray:[String] = []
    var stateNameAndIdDic = [String:Int16]()
    var cityNameAndIdDic = [String:Int64]()
    
    
        override func viewDidLoad()
    {
        super.viewDidLoad()
        
        coutryCodesArray = ["+90","+91","+92","+93","+94","+95","+96"]
//
        setNavigationItem()
        
        setProfileView()
        
        let imageView2 = UIImageView(frame: CGRect(x: 15, y: 10, width: 14, height: 17))
        let image2 = UIImage(named: "Location")
        imageView2.image = image2
        
        let imageView3 = UIImageView(frame: CGRect(x: 15, y: 10, width: 14, height: 17))
        let image3 = UIImage(named: "Location")
        imageView3.image = image3

        stateTextField.addSubview(imageView2)
        
        cityTextField.addSubview(imageView3)
        
        stateTextField.theme.font = UIFont.systemFont(ofSize: 15)
        stateTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.8)
        stateTextField.theme.cellHeight = 35
        
        cityTextField.theme.font = UIFont.systemFont(ofSize: 15)
        cityTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.8)
        cityTextField.theme.cellHeight = 35
        
        getState()
        getCandidateRoles()
//        stateTextField.itemSelectionHandler = { filteredResults, itemPosition in
//            // Just in case you need the item position
//            let item = filteredResults[itemPosition]
//            
//            DispatchQueue.main.async
//                {
//                    self.stateTextField.text = item.title
//                    
//                    self.cityArray.removeAll()
//                    
//                    self.getCitiesFromState(stateName: item.title)
//                    
//                    self.cityTextField.filterStrings(self.cityArray)
//                    
//            }
//        }
        
 //       stateTextField.filterStrings(statesArray)
        
        stateTextField.delegate = self
        cityTextField.delegate = self
        candidateFunctionTextField.delegate = self
        relocationTextFIeld.delegate = self
        stateTextField.delegate = self
        benefitsTextView.delegate = self
        nonCompeteTextView.delegate = self
        companiesInterviewedTextView.delegate = self
        servicesTextField.delegate = self
        visaStatusTextField.delegate = self
        benefitsTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        nonCompeteTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor

        companiesInterviewedTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        

        NotificationCenter.default.addObserver(self, selector: #selector(checkUpdateProfileResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_EDITED_PROFILE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkGetProfileResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_GET_USER_PROFILE), object: nil)
        
        setUserInteractionEnabled(setEnable: false)

        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getUserProfile(username: username!, password: password!, linkedinId:"")
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getUserProfile(username: "", password: "", linkedinId:linkedInId!)
                
        }
        

        //uploadFIleUsingFTP()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
    //    super.viewWillAppear(true)
      editProfileButton.setTitle("", for: .normal)
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        
        
    }
  
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }

    func setProfileView()
    {
        self.perform(#selector(addView), with: nil, afterDelay: 0.2)
        
        //aboutYouTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        //aboutYouTextView.delegate = self
        
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
//        countryCodePickerView.tag = 10002
        //leftView.addSubview(countryCodePickerView)
        
        countryCodeButton = UIButton(frame: CGRect(x: 35, y: 1, width: 40, height: 40))
        countryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        countryCodeButton.setTitleColor(UIColor.black, for: .normal)
        countryCodeButton.setTitle("\(coutryCodesArray[0])", for: .normal)
        countryCodeButton.addTarget(self, action: #selector(countryCodeButtonClicekd), for: .touchUpInside)
        leftView.addSubview(countryCodeButton)
        
        mobileNumberTextField.leftView = leftView
        mobileNumberTextField.leftViewMode = UITextFieldViewMode.always
        
        
        
        let imageView2 = UIImageView(frame: CGRect(x: 15, y: 8, width: 16, height: 12))
        let image2 = UIImage(named: "Email")
        imageView2.image = image2
        emailTextField.addSubview(imageView2)
        
//        let imageView3 = UIImageView(frame: CGRect(x: 15, y: 5, width: 18, height: 15))
//        let image3 = UIImage(named: "Password")
//        imageView3.image = image3
//        passwordTextField.addSubview(imageView3)
        
        let imageView4 = UIImageView(frame: CGRect(x: 15, y: 5, width: 10, height: 20))
        let image4 = UIImage(named: "Role")
        imageView4.image = image4
        cuurentRoleTextField.addSubview(imageView4)
        
        let imageView5 = UIImageView(frame: CGRect(x: 15, y: 5, width: 20, height: 20))
        let image5 = UIImage(named: "Company")
        imageView5.image = image5
        currentCompanyTextField.addSubview(imageView5)
        
        
        
        let imageView6 = UIImageView(frame: CGRect(x: 15, y: 5, width: 18, height: 17))
        let image6 = UIImage(named: "Visa")
        imageView6.image = image6
        visaStatusTextField.addSubview(imageView6)
        
        //        let imageView7 = UIImageView(frame: CGRect(x: 15, y: 5, width: 14, height: 17))
        //        let image7 = UIImage(named: "Location")
        //        imageView7.image = image7
        //        stateTextField.addSubview(imageView7)
        
        
    }
    
    func countryCodeButtonClicekd(sender:UIButton)
    {
        self.resignAllResponsders()
        
        self.addPickerToolBarForCountryCodes()

    }
    
    func addView() -> Void
    {
        outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0
        
        circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0
        
        outSideCircleView.clipsToBounds = true;
        
        outSideCircleView.image = UIImage(named:"OutsideCircle")
        
        circleImageView.clipsToBounds = true;
        
        //circleImageView.image = UIImage(named:"InsideDefaultCircle")
        
        //showData()
        
    }

    func setTextFieldsTextColor(color: UIColor)
    {
        nameTextField.textColor = color
        mobileNumberTextField.textColor = color
        emailTextField.textColor = color
        cuurentRoleTextField.textColor = color
        currentCompanyTextField.textColor = color
        stateTextField.textColor = color
        visaStatusTextField.textColor = color
        cityTextField.textColor = color
        
        verticalsTextFiled.textColor = color
        
        PLTextFiled.textColor = color
        revenueQuotaTextFiled.textColor = color
        linkedInProfileUrlTextField.textColor = color
        servicesTextField.textColor = color
        candidateFunctionTextField.textColor = color
        experienceTextField.textColor = color
        
        expectedCompanyTextField.textColor = color
        
        benefitsTextView.textColor = color
        nonCompeteTextView.textColor = color
        companiesInterviewedTextView.textColor = color
        joiningTimeTextFIeld.textColor = color
        relocationTextFIeld.textColor = color

    
    }
// MARK: Notification response methods
    
    func checkUpdateProfileResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        guard let code = responseDic["code"] else {
            
            return
        }
        
        let emailId = responseDic["emailId"]
        
        let linkId = responseDic["linkId"]

        
        let username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        
        if emailId == username
        {
            
        }
        else
            if linkId == "" && emailId != ""
        {
            UserDefaults.standard.set(self.emailTextField.text! , forKey: Constant.USERNAME)

        }
        
        let password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        let linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        AppPreferences.sharedPreferences().showAlertViewWith(title: "Profile Update", withMessage: "Profile updated successfully", withCancelText: "Ok")

        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getUserProfile(username: username!, password: password!, linkedinId:"")
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getUserProfile(username: "", password: "", linkedinId:linkedInId!)
                
        }
        
        self.setUserInteractionEnabled(setEnable: false)
        
        self.setTextFieldsTextColor(color: UIColor.gray)

    }
    
    
    
    func checkGetProfileResponse(dataDic:Notification)
    {
        self.setTextFieldsTextColor(color: UIColor.gray)

        guard let dataDictionary = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        if dataDictionary["code"] as! String == Constant.FAILURE
        {
            return
        }
    
        let userDetailsString = dataDictionary["usermodelDetails"] as! String
        
        let userDetailsData = userDetailsString.data(using: .utf8, allowLossyConversion: true)
        
        var userDetailsDict:[String:AnyObject]!
        do {
            userDetailsDict = try JSONSerialization.jsonObject(with: userDetailsData!, options: .allowFragments) as! [String:AnyObject]
        } catch let error as NSError
        {
            
        }
        
        let username = userDetailsDict["userName"] as! String
        
        let mobileNum = userDetailsDict["mobileNum"] as? String

        let emailId = userDetailsDict["emailId"] as? String

        let currentRole = userDetailsDict["currentRole"] as? String

        let currentCompany = userDetailsDict["currentCompany"] as? String

        let stateDic = userDetailsDict["state"] as? [String:Any]

        let city = userDetailsDict["city"] as? [String:Any]
        
        let companiesInterViewed = userDetailsDict["companiesInterviewInlastTwoYears"] as? String

        if companiesInterViewed != nil && companiesInterViewed != ""
        {
            companiesInterviewedTextView.text = companiesInterViewed
            
            //companiesInterviewedTextView.textColor = UIColor.black
        
        }
        let visaStatus = userDetailsDict["visaStatus"] as? String
        
        if visaStatus != nil && visaStatus != ""
        {
            visaStatusTextField.text = visaStatus
        }

        
        let expectedComp = userDetailsDict["expectedComp"] as? String
        
        if expectedComp != nil && expectedComp != ""
        {
            expectedCompanyTextField.text = expectedComp
        }

        let candidateFunctionDic = userDetailsDict["candidateFunction"] as? [String:Any]
        
        if candidateFunctionDic != nil
        {
            let candidateFunction = candidateFunctionDic?["role_name"] as! String
            candidateFunctionTextField.text = candidateFunction
        }
        
        let verticals = userDetailsDict["verticals"] as? String
        
        if verticals != nil && verticals != ""
        {
            verticalsTextFiled.text = verticals
        }

        let verticalsOrIndustory = userDetailsDict["verticalsOrIndustory"] as? String
        
//        if verticalsOrIndustory != nil
//        {
//            vert.text = verticals
//        }

        let pandL = userDetailsDict["pandL"] as? String
        
        if pandL != nil && pandL != ""
        {
            PLTextFiled.text = pandL
        }
        
        let servives = userDetailsDict["services"] as? String
        
        if servives != nil && servives != ""
        {
            servicesTextField.text = servives
        }

        let linkedInUrl = userDetailsDict["linkedInUrl"] as? String
        
        if pandL != nil && pandL != ""
        {
            linkedInProfileUrlTextField.text = linkedInUrl
        }
        
        let benefitsInCurrentOrg = userDetailsDict["benefitsInCurrentOrg"] as? String
        
        if benefitsInCurrentOrg != nil && benefitsInCurrentOrg != ""
        {
            benefitsTextView.text = benefitsInCurrentOrg
            
           // benefitsTextView.textColor = UIColor.black
        }

        let relocation = userDetailsDict["relocation"] as? [String:Any]
        
        if relocation != nil
        {
            relocationTextFIeld.text = relocation?["relocationStatus"] as? String
        }

        let anyNonComplete = userDetailsDict["anyNonComplete"] as? String
        
        if anyNonComplete != nil && anyNonComplete != ""
        {
            nonCompeteTextView.text = anyNonComplete
            
           // nonCompeteTextView.textColor = UIColor.black
        }
        
        let experienceInOffshore = userDetailsDict["experienceInOffshore"] as? String
        
        if experienceInOffshore != nil && experienceInOffshore != ""
        {
            experienceTextField.text = experienceInOffshore
        }

        let imageName = userDetailsDict["imageName"] as? String

        let revenueQuota = userDetailsDict["revenueQuota"] as? String
        
        if revenueQuota != nil && revenueQuota != ""
        {
            revenueQuotaTextFiled.text = revenueQuota
        }

        let joiningTimeRequired = userDetailsDict["joiningTimeRequired"] as? String
        
        if joiningTimeRequired != nil && joiningTimeRequired != ""
        {
            joiningTimeTextFIeld.text = joiningTimeRequired
        }

        nameTextField.text = username
        
        if mobileNum != nil && mobileNum != ""
        {
            let str = mobileNum
            
            let code = str?[0 ..< 3]
            
            let mob = str?.substring(from: 3) // returns "def"

//            let index = str?.index((str?.startIndex)!, offsetBy: 4)
//            str?[index!] // returns Character 'o'
//            
//            let endIndex = str.index(str.endIndex, offsetBy:-2)
//            str[Range(index ..< endIndex)] // returns String "o, worl"
//            
//            str.substring(from: index) // returns String "o, world!"
//            str.substring(to: index) // returns String "Hell"
            countryCodeButton.titleLabel?.text = code!
            mobileNumberTextField.text = mob!
        }
        
        if emailId != nil && emailId != ""
        {
            emailTextField.text = emailId
        }

        if currentRole != nil && currentRole != ""
        {
            cuurentRoleTextField.text = currentRole
        }
        
        if currentCompany != nil && currentCompany != ""
        {
            currentCompanyTextField.text = currentCompany
        }
        
        if stateDic != nil
        {
            let stateName = stateDic?["state_Name"] as? String
            stateTextField.text = stateName
            
            self.getCitiesFromState(stateName: stateName!)

        }
        if city != nil
        {
            let cityName = city?["city_Name"]
            cityTextField.text = cityName as! String?
        }
        guard let pictureUrlString = imageName else
        {
            return
         }
        
        CoreDataManager.getSharedCoreDataManager().updateUser(pictureUrl: imageName!)

        do
        {
        
        DispatchQueue.global(qos: .background).async
            {
                print("This is run on the background queue")
                //                        if let pictureUrlString = Constant.USER_PROFILE_IMAGE_PATH + pictureUrlString!
                //                        {
                let pictureUrl = URL(string: Constant.USER_PROFILE_IMAGE_PATH + pictureUrlString)
                
                if let pictureUrl = pictureUrl
                {
                    
                      do
                      {
                        
                                let imageData = try Data(contentsOf: pictureUrl as URL)
                        
                                let userImage1 = UIImage(data: imageData)
                        
                        let userImage = self.fixOrientation(img: userImage1!)
                        
                        //let userImage = UIImage(cgImage: (userImage1?.cgImage)!, scale: (userImage1?.scale)!, orientation: .up)
                        DispatchQueue.main.async
                            {
                                
                                self.circleImageView.image = userImage
                                
                                print("got in main queue")
                                

                            }
                        NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil, userInfo: nil)


                        }
                      catch let error as NSError
                      {
                        print(error.localizedDescription)
                        }
                    
                    
                }
                else
                {
                    DispatchQueue.main.async
                        {
                            self.circleImageView.image = UIImage(named:"InsideDefaultCircle")
                        }
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil, userInfo: nil)
                }
                //}
        }

        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }


    }
   
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
// MARK: Navigation bar methods
    
    func popViewController() -> Void
    {
        NotificationCenter.default.removeObserver(self)
        
        self.revealViewController().revealToggle(animated: true)
        
        //self.revealViewController().frontViewController.navigationController?.popToRootViewController(animated: true)
        self.stateTextField = nil
        self.stateTextField = nil
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.popToRootViewController(animated: true)
        //self.revealViewController().frontViewController.popoverPresentationController
        //self.revealViewController().popoverPresentationController
    }
    
    func setNavigationItem()
    {
        
        setLeftBarButtonItem()
        setRightBarButtonItemEdit()
        
    }
    
    @IBAction func editProfileButtonClicked(_ sender: Any)
    {
        showImagePickerController()
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
    func setRightBarButtonItemSave()
    {
        let editProfileButton = UIButton(frame: CGRect(x: 75, y: 0, width: 50, height: 50))
        editProfileButton.setTitle("Save", for: UIControlState.normal)
        editProfileButton.addTarget(self, action: #selector(rightbarButtonClickedSave), for: UIControlEvents.touchUpInside)
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
        setUserInteractionEnabled(setEnable: true)
        self.setTextFieldsTextColor(color: UIColor.black)

        setRightBarButtonItemSave()

        //nameTextField.becomeFirstResponder()
        
                stateTextField.itemSelectionHandler = { filteredResults, itemPosition in
                    // Just in case you need the item position
                    let item = filteredResults[itemPosition]
        
                    DispatchQueue.main.async
                        {
                            self.stateTextField.text = item.title
        
                            self.cityArray.removeAll()
        
                            self.getCitiesFromState(stateName: item.title)
        
                            self.cityTextField.filterStrings(self.cityArray)
        
                    }
                }
        
               stateTextField.filterStrings(statesArray)
    }
    func rightbarButtonClickedSave()
    {
        updateUserProfile()
        
        setUserInteractionEnabled(setEnable: false)
        
        setRightBarButtonItemEdit()

    }
    
    func updateUserProfile()
    {
        guard let name = nameTextField.text else {
            
            return
        }
        guard let editedEmail = emailTextField.text else {
            
            return
        }
        if emailTextField.text == "" || !(emailTextField.text?.contains("@"))!
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "Alert", withMessage: "Please enter a valid email address", withCancelText: "Ok")
            
            return
        }
//        guard let editedPassword = passwordTextField.text else {
//            
//            return
//        }
        guard let joinigTime = joiningTimeTextFIeld.text else {
            
            return
        }
        guard let cuurentRole = cuurentRoleTextField.text else {
            
            return
        }
        guard let email = emailTextField.text else {
            
            return
        }
        guard let mobile = mobileNumberTextField.text else {
            
            return
        }
        guard let visaStatus = visaStatusTextField.text else {
            
            return
        }
        
        guard let state = stateTextField.text else {
            
            return
        }
        guard let city = cityTextField.text else {
            
            return
        }
        var stateId:String? = ""
        if state == ""
        {
            
        }
        else
        {
            stateId = String(describing: stateNameAndIdDic[state]!)
            
            
        }
        
        var cityId:String! = ""
        
        if city == ""
        {
            
        }
        else
        {
            cityId = String(describing: cityNameAndIdDic[city]!)
        }
        
        guard let companiesInterViewed = companiesInterviewedTextView.text else {
            
            return
        }
        guard let benefits = benefitsTextView.text else {
            
            return
        }
        guard let nonCompete = nonCompeteTextView.text else {
            
            return
        }
        
        guard let revenueQuota = revenueQuotaTextFiled.text else {
            
            return
        }
        guard let PL = PLTextFiled.text else {
            
            return
        }
        guard let expOffshore = experienceTextField.text else {
            
            return
        }
        guard let currentCompany = currentCompanyTextField.text else {
            
            return
        }
        guard let expectedCompany = expectedCompanyTextField.text else {
            
            return
        }
        guard let relocation = relocationTextFIeld.text else {
            
            return
        }
        
        guard let candidateFunction = candidateFunctionTextField.text else {
            
            return
        }
        
        var roleId:String! = ""
        
        if candidateFunction == ""
        {
            
        }
        else
        {
            roleId = String(describing: roleNameAndIdDic[candidateFunction]!)
        }
        
        guard let service = servicesTextField.text else {
            
            return
        }
        guard let linkedInUR = linkedInProfileUrlTextField.text else {
            
            return
        }
        //        guard let candidateRole = candidateFunctionTextField.text else {
        //
        //            return
        //        }
        guard let vertical = verticalsTextFiled.text else {
            
            return
        }
        
        var mobileNumberWithCountryCode:String = ""
        if !(mobile == "")
        {
          mobileNumberWithCountryCode = (countryCodeButton.titleLabel?.text!)! + mobile
        }
        var username = UserDefaults.standard.object(forKey: Constant.USERNAME) as? String
        var password = UserDefaults.standard.object(forKey: Constant.PASSWORD) as? String
        var linkedInId = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        var editedEmail1:String!
        var editedPassword1:String!
        
        if username != nil && password != nil
        {
            linkedInId = ""
            if editedEmail == ""
            {
                editedEmail1 = username
            }
            else
            {
                editedEmail1 = editedEmail
            }
//            if editedPassword == ""
//            {
                editedPassword1 = password
//            }
//            else
//            {
//                editedPassword1 = editedPassword
//            }
            //APIManager.getSharedAPIManager().getVerticalJobs(username: username!, password: password!, varticalId: String(verticalId), linkedinId:"")
        }
        else
        {
            if editedEmail == ""
            {
                editedEmail1 = username
            }
            else
            {
                editedEmail1 = editedEmail
            }
            editedPassword1 = ""
            
            if linkedInId != nil
            {
                username = ""
                
                password = ""
                //APIManager.getSharedAPIManager().getVerticalJobs(username: "", password: "", varticalId: String(verticalId), linkedinId:linkedInId!)
                
            }
        }
        
        var relocationId:String!
        if relocation != ""
        {
            relocationId = relocationDic[relocation]
        }
        else
        {
            relocationId = "1"
        }
        
        let dict = ["name":name,"email":username!,"password":password!,"linkedinId":linkedInId!,"editedEmail":editedEmail1,"editedPassword":editedPassword1,"mobile":mobileNumberWithCountryCode,"currentRole":cuurentRole,"currentCompany":currentCompany,"stateId":stateId!,"cityId":cityId,"visaStatus":visaStatus,"candidateFunction":roleId!,"services":service,"linkedInProfileUrl":linkedInUR,"verticalsServiceTo":vertical,"revenueQuota":revenueQuota,"PandL":PL,"currentCompLastYrW2":currentCompany,"expectedCompany":expectedCompany,"joiningTime":joinigTime,"compInterviewPast1Yr":companiesInterViewed,"benifits":benefits,"notJoinSpecificOrg":nonCompete,"image":"","expInOffshoreEng":expOffshore,"relocation":relocationId,"deviceToken":AppPreferences.sharedPreferences().firebaseInstanceId,"linkedIn":linkedInId!] as [String : String]
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            print(decoded)
            
            // APIManager.getSharedAPIManager().registerUser(dict: decoded)
            //            do {
            //APIManager.getSharedAPIManager().uodateUserProfile(userDict: decoded)
            APIManager.getSharedAPIManager().createUpdateProfileRequestAndSend(dict: decoded, imageData: imagedata as! Data?)
            //            } catch let error as NSError
            //            {
            //
            //            }
            
            AppPreferences.sharedPreferences().showHudWith(title: "Updating profile..", detailText: "Please wait")
            
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                // use dictFromJSON
            }
        } catch {
            print(error.localizedDescription)
        }
        //        APIManager.getSharedAPIManager().registerUser(dict: dict)
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
        
        hideBarButtonItems(hide: "Edit")
        
        // picker.removeFromParentViewController()
    }

    func setUserInteractionEnabled(setEnable:Bool)
    {
        nameTextField.isUserInteractionEnabled = setEnable
        mobileNumberTextField.isUserInteractionEnabled = setEnable
        emailTextField.isUserInteractionEnabled = setEnable
        //qualificationTextField.isUserInteractionEnabled = setEnable
        cuurentRoleTextField.isUserInteractionEnabled = setEnable
        currentCompanyTextField.isUserInteractionEnabled = setEnable
        // additionalPhoneTextfield.isUserInteractionEnabled = setEnable
        stateTextField.isUserInteractionEnabled = setEnable
        cityTextField.isUserInteractionEnabled = setEnable
        visaStatusTextField.isUserInteractionEnabled = setEnable
        candidateFunctionTextField.isUserInteractionEnabled = setEnable
        servicesTextField.isUserInteractionEnabled = setEnable
        linkedInProfileUrlTextField.isUserInteractionEnabled = setEnable
        revenueQuotaTextFiled.isUserInteractionEnabled = setEnable
        PLTextFiled.isUserInteractionEnabled = setEnable
        experienceTextField.isUserInteractionEnabled = setEnable
        expectedCompanyTextField.isUserInteractionEnabled = setEnable
        relocationTextFIeld.isUserInteractionEnabled = setEnable
        joiningTimeTextFIeld.isUserInteractionEnabled = setEnable
        companiesInterviewedTextView.isUserInteractionEnabled = setEnable
        nonCompeteTextView.isUserInteractionEnabled = setEnable
        benefitsTextView.isUserInteractionEnabled = setEnable
        
        //aboutYouTextView.isUserInteractionEnabled = setEnable
        
        
    }
    
    func resignAllResponsders()
    {
        nameTextField.resignFirstResponder()
        mobileNumberTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        //qualificationTextField.isUserInteractionEnabled = setEnable
        cuurentRoleTextField.resignFirstResponder()
        currentCompanyTextField.resignFirstResponder()
        // additionalPhoneTextfield.isUserInteractionEnabled = setEnable
        stateTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        visaStatusTextField.resignFirstResponder()
        candidateFunctionTextField.resignFirstResponder()
        servicesTextField.resignFirstResponder()
        linkedInProfileUrlTextField.resignFirstResponder()
        revenueQuotaTextFiled.resignFirstResponder()
        PLTextFiled.resignFirstResponder()
        experienceTextField.resignFirstResponder()
        expectedCompanyTextField.resignFirstResponder()
        relocationTextFIeld.resignFirstResponder()
        joiningTimeTextFIeld.resignFirstResponder()
        companiesInterviewedTextView.resignFirstResponder()
        nonCompeteTextView.resignFirstResponder()
        benefitsTextView.resignFirstResponder()
        
        //aboutYouTextView.isUserInteractionEnabled = setEnable
        
        
    }
    
// MARK: Textview delegate methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView == companiesInterviewedTextView
        {
            companiesInterviewedTextView.text = "";
            companiesInterviewedTextView.textColor = UIColor.black
        }
        else
            if textView == benefitsTextView
            {
                benefitsTextView.text = "";
                benefitsTextView.textColor = UIColor.black
            }
            else
                if textView == nonCompeteTextView
                {
                    nonCompeteTextView.text = "";
                    nonCompeteTextView.textColor = UIColor.black
        }
        
        return true;
    }
    
    
    func textViewDidChange(_ textView: UITextView)
    {
        if textView == companiesInterviewedTextView
        {
            if companiesInterviewedTextView.text!.characters.count == 0
            {
                //companiesInterviewedTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
                //companiesInterviewedTextView.text = "Companies interviewed in past 1 year";
            }
        }
        else
            if textView == benefitsTextView
            {
                if benefitsTextView.text!.characters.count == 0
                {
                   // benefitsTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
                    //benefitsTextView.text = "Benefits in current organization(401k/insurance coverage etc)";
                }
            }
            else
                if textView == nonCompeteTextView
                {
                    if nonCompeteTextView.text!.characters.count == 0
                    {
                        //nonCompeteTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
                        //nonCompeteTextView.text = "Any non-compete that will prevent you from managing a specific client OR Not join any specific organization";
                    }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == candidateFunctionTextField
        {
            DispatchQueue.main.async {
                self.resignAllResponsders()
                
                self.addPickerToolBar()
                
                if self.candidateFunctionTextField.text == ""
                {
                    self.candidateFunctionTextField.text = self.candidateFunctionArray[0]
                }
            }
            
        }
        else
            if textField == relocationTextFIeld
            {
                DispatchQueue.main.async {
                    self.resignAllResponsders()
                    
                    self.addPickerToolBarForRelocation()
                    
                    if self.relocationTextFIeld.text == ""
                    {
                        self.relocationTextFIeld.text = self.relocationArray[0]
                    }
                }
                
        }
        
            else
                if textField == visaStatusTextField
                {
                    DispatchQueue.main.async {
                       // self.visaStatusTextField.resignFirstResponder()
                        self.resignAllResponsders()
                        self.addPickerToolBarForVisaTypes()
                        
                        if self.visaStatusTextField.text == ""
                        {
                            self.visaStatusTextField.text = self.visaTypesArray[0]
                        }
                    }
                    
        }

    }
 
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView == companiesInterviewedTextView
        {
            if companiesInterviewedTextView.text!.characters.count == 0
            {
                companiesInterviewedTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
                companiesInterviewedTextView.text = "Companies interviewed in past 1 year";
            }
        }
        else
            if textView == benefitsTextView
            {
                if benefitsTextView.text!.characters.count == 0
                {
                     benefitsTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
                    benefitsTextView.text = "Benefits in current organization(401k/insurance coverage etc)";
                }
            }
            else
                if textView == nonCompeteTextView
                {
                    if nonCompeteTextView.text!.characters.count == 0
                    {
                        nonCompeteTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
                        nonCompeteTextView.text = "Any non-compete that will prevent you from managing a specific client OR Not join any specific organization";
                    }
        }

    }
// MARK: Data support methods
    
    func getCandidateRoles()
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.getAllRecords(entity: "Roles")
            for userObject in managedObjects as! [Roles]
            {
                candidateFunctionArray.append(userObject.roleName!)
                roleNameAndIdDic[userObject.roleName!] = userObject.roleId
                
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
    }

    func getState()
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.getAllRecords(entity: "State")
            for userObject in managedObjects as! [State]
            {
                statesArray.append(userObject.stateName!)
                
                stateNameAndIdDic[userObject.stateName!] = userObject.id
                
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
    }
    
    func getCitiesFromState( stateName:String)
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.fetchCitiesFromStateId(entity: "City", stateId: Int16(stateNameAndIdDic[stateName]!))
            for userObject in managedObjects as! [City]
            {
                cityArray.append(userObject.cityName!)
                
                cityNameAndIdDic[userObject.cityName!] = userObject.id
                //stateNameAndIdDic[userObject.stateName!] = userObject.id as AnyObject?
                
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    }

    
   
    
    
    func hideBarButtonItems( hide:String)
    {
        if hide == "Cancel"
        {
            self.navigationItem.leftBarButtonItem = nil
            setRightBarButtonItemCancel()
        }
        else
            if hide == "Edit"
        {
           setLeftBarButtonItem()
           setRightBarButtonItemEdit()
        }
            else
                if hide == "Save"
                {
                    setLeftBarButtonItem()
                    setRightBarButtonItemSave()
        }
        
        //self.navigationItem.leftBarButtonItem.hide
    }
    
    
 // MARK: Image picker controller delegate
    
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
        
        hideBarButtonItems(hide: "Cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage]
        
        let chosenImageName = info[UIImagePickerControllerOriginalImage]
        
        
        let refURL = info[UIImagePickerControllerReferenceURL]
        
        let userImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
//        UIImage *imageToDisplay =
//            [UIImage imageWithCGImage:[originalImage CGImage]
//                scale:[originalImage scale]
//                orientation: UIImageOrientationUp];
        
        //let userImage = UIImage(cgImage: (imageToDisplay?.cgImage)!, scale: (imageToDisplay?.scale)!, orientation: .up)

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

        hideBarButtonItems(hide: "Save")
        
    }

    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
//    {
//        
//            //aboutYouTextView.text = "";
//            //aboutYouTextView.textColor = UIColor.black
//        
//        return true;
//    }
    
    
//    func textViewDidChange(_ textView: UITextView)
//    {
//       
//            if aboutYouTextView.text!.characters.count == 0
//            {
//                aboutYouTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
//                aboutYouTextView.text = "Companies interviewed in past 1 year";
//            }
//        
//        
//    }

   
    
    
  // MARK: picker toolbar methode and delegates
    
    
    func addPickerToolBar()
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
    
    
    func addPickerToolBarForRelocation()
    {
        if self.view.viewWithTag(20000) == nil
        {
            
            let picker = UIPickerView()
            
            picker.tag = 20001;
            
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
            
            toolBar.tag = 20000
            
            toolBar.setItems([btn], animated: true)
            
            self.view.addSubview(toolBar)
            //     OperatorTextField.inputAccessoryView=toolBar;
        }
    }
    
    func addPickerToolBarForCountryCodes()
    {
        if self.view.viewWithTag(30000) == nil
        {
            
            let picker = UIPickerView()
            
            picker.tag = 30001;
            
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
            
            toolBar.tag = 30000
            
            toolBar.setItems([btn], animated: true)
            
            self.view.addSubview(toolBar)
            //     OperatorTextField.inputAccessoryView=toolBar;
        }
    }
    
    func addPickerToolBarForVisaTypes()
    {
        if self.view.viewWithTag(40000) == nil
        {
            
            let picker = UIPickerView()
            
            picker.tag = 40001;
            
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
            
            toolBar.tag = 40000
            
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
        if let picker = self.view.viewWithTag(10001)
        {
            picker.removeFromSuperview()
            
        }
        
        
        if let toolbar = self.view.viewWithTag(10000)
        {
            toolbar.removeFromSuperview()
            
        }
        
        
        if let picker1 = self.view.viewWithTag(20001)
        {
            picker1.removeFromSuperview()
            
        }
        
        
        if let toolbar1 = self.view.viewWithTag(20000)
        {
            toolbar1.removeFromSuperview()
            
        }
        
        if let picker1 = self.view.viewWithTag(30001)
        {
            picker1.removeFromSuperview()
            
        }
        
        
        if let toolbar1 = self.view.viewWithTag(30000)
        {
            toolbar1.removeFromSuperview()
            
        }
        
        if let picker1 = self.view.viewWithTag(40001)
        {
            picker1.removeFromSuperview()
            
        }
        
        
        if let toolbar1 = self.view.viewWithTag(40000)
        {
            toolbar1.removeFromSuperview()
            
        }
        
        // [DescriptionTextView becomeFirstResponder];
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 10001
        {
            return candidateFunctionArray.count
            
        }
        else
        if pickerView.tag == 20001
        {
            return relocationArray.count
        }
        else
        if pickerView.tag == 30001
        {
            return coutryCodesArray.count
        }
        else
        {
            return visaTypesArray.count

        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 10001
        {
            return candidateFunctionArray[row]
            
        }
        else
        if pickerView.tag == 20001

        {
            return relocationArray[row]
        }
        else
        if pickerView.tag == 30001
        {
            return coutryCodesArray[row]

        }
        else
        {
            return visaTypesArray[row]

        }
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
        if pickerView.tag == 10001
        {
            label?.text =  candidateFunctionArray[row] as String
            
        }
        else
        if pickerView.tag == 20001
        {
            label?.text =  relocationArray[row] as String
            
        }
        else
        if pickerView.tag == 30001
        {
            label?.text =  coutryCodesArray[row] as String
        }
        else
        {
            label?.text =  visaTypesArray[row] as String

        }
        
        label?.textAlignment = .center
        // label?.textAlignment = .left
        //}
        
        return label!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 10001
        {
            let selectedRole = candidateFunctionArray[row]
            
            candidateFunctionTextField.text = selectedRole
        }
        else
        if pickerView.tag == 20001

        {
            let selectedRole = relocationArray[row]
            
            relocationTextFIeld.text = selectedRole
        }
        else
        if pickerView.tag == 30001
        {
            let selectedCountryCode = coutryCodesArray[row]
            
            countryCodeButton.setTitle(selectedCountryCode, for: .normal)
           // relocationTextFIeld.text = selectedRole
        }
        else
        {
            let selectedVisaStatus = visaTypesArray[row]
            
            visaStatusTextField.text = selectedVisaStatus
         
        }
        
    }
    
    
//    func showData() -> Void
//    {
//        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
//        
//        
//        do
//        {
//            var managedObjects:[NSManagedObject]?
//            
//            managedObjects = coreDataManager.getAllRecords(entity: "User")
//            for userObject in managedObjects as! [User]
//            {
//                let firstName = userObject.name
//                let pictureUrlString = userObject.pictureUrl
//                
//                guard firstName != nil else
//                {
//                    break
//                }
//                nameTextField.text = "\(firstName!)"
//                
//                guard userObject.emailAddress != nil else
//                {
//                    break
//                }
//                emailTextField.text = userObject.emailAddress
//                
//                guard userObject.occupation != nil else
//                {
//                    break
//                }
//                cuurentRoleTextField.text = userObject.occupation
//                
//                DispatchQueue.global(qos: .background).async
//                    {
//                        
//                        if let pictureUrlString = pictureUrlString
//                        {
//                            let pictureUrl = URL(string: pictureUrlString)
//                            
//                            guard pictureUrl != nil else
//                            {
//                                return
//                            }
//                            //                    if let pictureUrl = pictureUrl
//                            //                    {
//                            do
//                            {
//                                let imageData = try Data(contentsOf: pictureUrl! as URL)
//                                
//                                let userImage = UIImage(data: imageData)
//                                
//                                DispatchQueue.main.async
//                                    {
//                                        self.circleImageView.image = userImage
//                                        
//                                }
//                                
//                                
//                            }
//                            catch let error as NSError
//                            {
//                                print(error.localizedDescription)
//                            }
//                            // }
//                        }
//                        
//                        
//                }
//                
//                
//            }
//            
//        } catch let error as NSError
//        {
//            print(error.localizedDescription)
//        }
//        
//    }
//
//    
//    func Edit() -> Void
//    {
//        
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
