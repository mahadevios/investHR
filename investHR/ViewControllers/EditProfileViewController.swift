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
class EditProfileViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,URLSessionDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate
{
    @IBOutlet weak var circleImageView: UIImageView!

    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var autoCompleteTableView: UITableView!
    @IBOutlet weak var outSideCircleView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cuurentRoleTextField: UITextField!
    @IBOutlet weak var currentCompanyTextField: UITextField!
    @IBOutlet weak var stateTextField: TextField!
    var coutryCodesArray:[String] = []
    var imagedata:Any!
    var candidateFunctionArray : [String] = []
    var imagePickerController = UIImagePickerController()
    //    let servicesArray : [String] = ["Services","Service 2","Service 3","Service 4","Service 5"]
    let relocationArray = ["Not Available","Yes","No","May be"]
    let relocationDic = ["Yes":"1","No":"2","May be":"3","Not Available":"4"]
    let visaTypesArray = ["US Citizen","Green Card Holder","UK Tier 1 Visa","Uk Tier 2 Visa","UK Citizen","UK – PR"," Canadian Citizen","TN Visa","Euro Zone Citizen","EAD card Holder","L2 EAD","H1 Visa","L1 Visa","H4 Visa","L2 Visa"]
    let visaTypesAndIdArray = ["US Citizen":"1","Green Card Holder":"2","UK Tier 1 Visa":"3","Uk Tier 2 Visa":"4","UK Citizen":"5","UK – PR":"6"," Canadian Citizen":"7","TN Visa":"8","Euro Zone Citizen":"9","EAD card Holder":"10","L2 EAD":"11","H1 Visa":"12","L1 Visa":"13","H4 Visa":"14","L2 Visa":"15"]
    var roleNameAndIdDic = [String:Int16]()
    var countryCodeButton:UIButton!
    @IBOutlet weak var visaStatusTextField: TextField!
    @IBOutlet weak var cityTextField: TextField!
    
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
    
    var existingStateName = ""
    var existingCityName = ""

    //@IBOutlet weak var passwordTextField: TextField!
    
    var statesArray:[String] = []
    var cityArray:[String] = []
    var filterArray = [String]()
    var stateNameAndIdDic = [String:Int16]()
    var cityNameAndIdDic = [String:Int64]()
    
    
        override func viewDidLoad()
    {
        super.viewDidLoad()
        
coutryCodesArray = ["+1","+93","+355","+213","+1 684","+376","+244","+1 264","+672","+64","+1 268","+54","+374","+297","+247","+61","+43","+994","+1 242","+973","+880","+1 246","+375","+32","+501","+229","+1 441","+975","+591","+387","+267","+55","+1 284","+673","+359","+226","+95","+257","+855","+237","+238","+1 345","+236","+235","+56","+86","+61","+57","+269","+242","+682","+506","+385","+53","+357","+420","+243","+45","+246","+253","+1 767","+1 809","+1 829","+1, 849","+593","+20","+503","+240","+291","+372","+251","+500","+298","+679","+358","+33","+594","+689","+241","+220","+995","+49","+233","+350","+30","+299","+1 473","+590","+1 671","+502","+224","+245","+592","+509","+39","+504","+852","+36","+354","+91","+62","+98","+964","+353","+44","+972","+225","+1 876","+81","+962","+7","+254","+686","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+596","+222","+230","+262","+52","+691","+373","+377","+976","+382","+1 664","+212","+258","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+672","+850","+1 670","+47","+968","+92","+680","+970","+507","+595","+51","+63","+870","+48","+351","+1 787","+1 939","+974","+242","+262","+40","+250","+590","+290","+1 869","+1 758","+508","+1 784","+685","+378","+239","+966","+221","+381","+248","+232","+65","+1 721","+421","+386","+677","+252","+27","+82","+211","+34","+94","+249","+597","+47","+268","+46","+41","+963","+886","+992","+255","+66","+670","+228","+690","+676","+1 868","+216","+90","+993","+1 649","+688","+256","+380","+971","+598","+1 340","+998","+678","+58","+84","+681","+212","+967","+260","+263"]
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
        
//        stateTextField.theme.font = UIFont.systemFont(ofSize: 15)
//        stateTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.8)
//        stateTextField.theme.cellHeight = 35
//        
//        cityTextField.theme.font = UIFont.systemFont(ofSize: 15)
//        cityTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.8)
//        cityTextField.theme.cellHeight = 35
        
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
        nameTextField.delegate = self
        mobileNumberTextField.delegate = self
        currentCompanyTextField.delegate = self
        cuurentRoleTextField.delegate = self
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
        servicesTextField.delegate = self
        linkedInProfileUrlTextField.delegate = self
        verticalsTextFiled.delegate = self
        revenueQuotaTextFiled.delegate = self
        PLTextFiled.delegate = self
        experienceTextField.delegate = self
        joiningTimeTextFIeld.delegate = self
        expectedCompanyTextField.delegate = self
        benefitsTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        nonCompeteTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor

        companiesInterviewedTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        

        NotificationCenter.default.addObserver(self, selector: #selector(checkUpdateProfileResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_EDITED_PROFILE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkGetProfileResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_GET_USER_PROFILE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

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
        
        autoCompleteTableView.layer.borderColor = UIColor.gray.cgColor
        autoCompleteTableView.layer.borderWidth = 1.0
        autoCompleteTableView.layer.cornerRadius = 3.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        //uploadFIleUsingFTP()
        // Do any additional setup after loading the view.
    }
    
    func userTapped()
    {
      autoCompleteTableView.isHidden = true
    
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: self.autoCompleteTableView))! || (touch.view?.isDescendant(of: self.imagePickerController.view))!
        {
            return false
        }
        return true
    }
    override func viewWillAppear(_ animated: Bool)
    {
      editProfileButton.setTitle("", for: .normal)
      
//        stateTextField.itemSelectionHandler = { filteredResults, itemPosition in
//            let item = filteredResults[itemPosition]
//            
//           
//            self.stateTextField.text = item.title
//            
//            self.cityArray.removeAll()
//            
//            self.getCitiesFromState(stateName: item.title)
//            
//            self.cityTextField.filterStrings(self.cityArray)
//            
//            self.cityTextField.isUserInteractionEnabled = true
//            
//        }
//        
//        stateTextField.filterStrings(statesArray)
//        
//        
//        
//        cityTextField.itemSelectionHandler = { filteredResults, itemPosition in
//            let item = filteredResults[itemPosition]
//            
//            
//            
//            self.cityTextField.text = item.title
//            
//            self.cityTextField.resignFirstResponder()
//            
//        }

        self.autoCompleteTableView.isHidden = true
        
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
        
        let leftView = UIView(frame: CGRect(x: 0, y: 5, width: 70, height: 40))
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
        
        
        
        
        
        
        if companiesInterviewedTextView.text == "Companies interviewed in past 1 year" || companiesInterviewedTextView.text == "Companies interviewed in past 1 year\n"
        {
            companiesInterviewedTextView.textColor = UIColor.lightGray
        }
        else
        {
          companiesInterviewedTextView.textColor = color
        }
        if benefitsTextView.text == "Benefits in current organization(401k/insurance coverage etc)\n" || benefitsTextView.text == "Benefits in current organization(401k/insurance coverage etc)"
        {
            benefitsTextView.textColor = UIColor.lightGray

        }
        else
        {
            benefitsTextView.textColor = color
        }
        if nonCompeteTextView.text == "Any non-compete that will prevent you from managing a specific client OR Not join any specific organization" || nonCompeteTextView.text == "Any non-compete that will prevent you from managing a specific client OR Not join any specific organization\n"
        {
            nonCompeteTextView.textColor = UIColor.lightGray

        }
        else
        {
            nonCompeteTextView.textColor = color
        }
        joiningTimeTextFIeld.textColor = color
        relocationTextFIeld.textColor = color

    
    }
    
    func deviceRotated() -> Void
    {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
            // addView()
            // print("Landscape")
            outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0
            
            circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0
            
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
            // addView()
            // print("Portrait")
            outSideCircleView.layer.cornerRadius = outSideCircleView.frame.size.width/2.0
            
            circleImageView.layer.cornerRadius = circleImageView.frame.size.width/2.0
            
        }
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

        //self.setUserInteractionEnabled(setEnable: false)
        
        //self.resignAllResponsders()
        
        self.setTextFieldsTextColor(color: UIColor.lightGray)
        
        if username != nil && password != nil
        {
            APIManager.getSharedAPIManager().getUserProfile(username: username!, password: password!, linkedinId:"")
        }
        else
            if linkedInId != nil
            {
                APIManager.getSharedAPIManager().getUserProfile(username: "", password: "", linkedinId:linkedInId!)
                
        }
        
        

    }
    
    
    
    func checkGetProfileResponse(dataDic:Notification)
    {
        self.setTextFieldsTextColor(color: UIColor.lightGray)

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
            
//            let code = str?[0 ..< 3]
//            
//            let mob = str?.substring(from: 3) // returns "def"
            let mobileArray = str?.components(separatedBy: "-")
            //
            if mobileArray != nil
            {
                if mobileArray!.count > 1
                {
                    let code = mobileArray![0]
                    let mob = mobileArray![1]
                    countryCodeButton.titleLabel?.text = code
                    mobileNumberTextField.text = mob
                }
            }
            
            

            //let mob = str?.substring(from: 3) // returns "def"
            

//            let index = str?.index((str?.startIndex)!, offsetBy: 4)
//            str?[index!] // returns Character 'o'
//            
//            let endIndex = str.index(str.endIndex, offsetBy:-2)
//            str[Range(index ..< endIndex)] // returns String "o, worl"
//            
//            str.substring(from: index) // returns String "o, world!"
//            str.substring(to: index) // returns String "Hell"
           
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
            self.cityArray.removeAll()
            self.getCitiesFromState(stateName: stateName!)
            stateTextField.text = stateName!

            //self.existingStateName = stateName!
//            DispatchQueue.main.async {
//                self.stateTextField.resignFirstResponder()
//                self.cityTextField.resignFirstResponder()
//            }
            


        }
        if city != nil
        {
            let cityName = city?["city_Name"]
            cityTextField.text = ""
            cityTextField.resignFirstResponder()
            cityTextField.text = cityName as! String?
                       // DispatchQueue.main.async {
//                            self.stateTextField.resignFirstResponder()
//                            self.cityTextField.resignFirstResponder()
                       // }
            //cityTextField.isUserInteractionEnabled = false
            //self.existingStateName = cityName as! String

        }
        guard let pictureUrlString = imageName else
        {
            return
         }
        
        CoreDataManager.getSharedCoreDataManager().updateUser(pictureUrl: imageName!)

        NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil, userInfo: nil)

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


                        }
                      catch let error as NSError
                      {
                        DispatchQueue.main.async
                            {
                                self.circleImageView.image = UIImage(named:"InsideDefaultCircle")
                            }
                        print(error.localizedDescription)
                        }
                    
                    
                }
                else
                {
                    NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil, userInfo: nil)

                    DispatchQueue.main.async
                        {
                            self.circleImageView.image = UIImage(named:"InsideDefaultCircle")
                        }
                }
                //}
        }

        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        resignAllResponsders()
        
        setUserInteractionEnabled(setEnable: false)

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
       // self.stateTextField = nil
       // self.cityTextField = nil
        
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
        self.resignAllResponsders()
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
        
//                stateTextField.itemSelectionHandler = { filteredResults, itemPosition in
//                    // Just in case you need the item position
//                    let item = filteredResults[itemPosition]
//        
////                    DispatchQueue.main.async
////                        {
//                            self.stateTextField.text = item.title
//        
//                            self.cityArray.removeAll()
//        
//                            self.getCitiesFromState(stateName: item.title)
//        
//                            self.cityTextField.filterStrings(self.cityArray)
//                            
//                            self.cityTextField.isUserInteractionEnabled = true
//        
//                   // }
//                }
//        
//               stateTextField.filterStrings(statesArray)
//        
//        //self.cityTextField.isUserInteractionEnabled = false
//
//        
//            cityTextField.itemSelectionHandler = { filteredResults, itemPosition in
//            // Just in case you need the item position
//            let item = filteredResults[itemPosition]
//            
//            
//                    
//                    self.cityTextField.text = item.title
//                    
//        }

    }
    func rightbarButtonClickedSave()
    {
        setUserInteractionEnabled(setEnable: false)

        updateUserProfile()
        
        setRightBarButtonItemEdit()
        
        resignAllResponsders()


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
            let firstLetterCapitalState = state.capitalizingFirstLetter()

            if stateNameAndIdDic[firstLetterCapitalState] != nil
            {
                stateId = String(describing: stateNameAndIdDic[firstLetterCapitalState]!)
                
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.setUserInteractionEnabled(setEnable: true)
                    
                    self.setRightBarButtonItemSave()
                    
                    self.stateTextField.becomeFirstResponder()
                    
                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid State", withMessage: "Please select a valid state", withCancelText: "Ok")
                }
                
                
                return
                
            }
            
        }
        
        var cityId:String! = ""
        
        if city == ""
        {
            
        }
        else
        {
            let firstLetterCapitalCity = city.capitalizingFirstLetter()
            
            if cityNameAndIdDic[firstLetterCapitalCity] != nil
            {
                cityId = String(describing: cityNameAndIdDic[firstLetterCapitalCity]!)
                
            }
            else
            {
                DispatchQueue.main.async
                    {
                self.setUserInteractionEnabled(setEnable: true)

                self.setRightBarButtonItemSave()

                self.cityTextField.becomeFirstResponder()

                AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid City", withMessage: "Please select a valid city", withCancelText: "Ok")
                
                }
                return
                
            }
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
          mobileNumberWithCountryCode = (countryCodeButton.titleLabel?.text!)! + "-" + mobile
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
        
        var companiesInterViewed1:String!
        if companiesInterViewed == "Companies interviewed in past 1 year"
        {
            companiesInterViewed1 = ""
        }
        else
        {
            companiesInterViewed1 = companiesInterviewedTextView.text
        }
        
        var benefit1:String!
        if benefits == "Benefits in current organization(401k/insurance coverage etc)\n"
        {
            benefit1 = ""
        }
        else
        {
            benefit1 = benefitsTextView.text
        }
        var nonCompete1:String!
        if nonCompete == "Any non-compete that will prevent you from managing a specific client OR Not join any specific organization"
        {
            nonCompete1 = ""
        }
        else
        {
            nonCompete1 = nonCompeteTextView.text
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
        
        let dict = ["name":name,"email":username!,"password":password!,"linkedinId":linkedInId!,"editedEmail":editedEmail1,"editedPassword":editedPassword1,"mobile":mobileNumberWithCountryCode,"currentRole":cuurentRole,"currentCompany":currentCompany,"stateId":stateId!,"cityId":cityId,"visaStatus":visaStatus,"candidateFunction":roleId!,"services":service,"linkedInProfileUrl":linkedInUR,"verticalsServiceTo":vertical,"revenueQuota":revenueQuota,"PandL":PL,"currentCompLastYrW2":currentCompany,"expectedCompany":expectedCompany,"joiningTime":joinigTime,"compInterviewPast1Yr":companiesInterViewed1,"benifits":benefit1,"notJoinSpecificOrg":nonCompete1,"image":"","expInOffshoreEng":expOffshore,"relocation":relocationId,"deviceToken":AppPreferences.sharedPreferences().firebaseInstanceId,"linkedIn":linkedInId!] as [String : String]
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            print(decoded)
            
            self.autoCompleteTableView.isHidden = true
            // APIManager.getSharedAPIManager().registerUser(dict: decoded)
            //            do {
            //APIManager.getSharedAPIManager().uodateUserProfile(userDict: decoded)
            APIManager.getSharedAPIManager().createUpdateProfileRequestAndSend(dict: decoded, imageData: imagedata as! Data?)
            //            } catch let error as NSError
            //            {
            //
            //            }
            
            AppPreferences.sharedPreferences().showHudWith(title: "Updating profile", detailText: "Please wait..")
            
            
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
        
        hideBarButtonItems(hide: "Save")
        
        // picker.removeFromParentViewController()
    }

    func setUserInteractionEnabled(setEnable:Bool)
    {
        editProfileButton.isEnabled = setEnable
        nameTextField.isUserInteractionEnabled = setEnable
        mobileNumberTextField.isUserInteractionEnabled = setEnable
        emailTextField.isUserInteractionEnabled = setEnable
        //qualificationTextField.isUserInteractionEnabled = setEnable
        cuurentRoleTextField.isUserInteractionEnabled = setEnable
        currentCompanyTextField.isUserInteractionEnabled = setEnable
        // additionalPhoneTextfield.isUserInteractionEnabled = setEnable
        stateTextField.isUserInteractionEnabled = setEnable
        if stateTextField.text != "" && setEnable == true
        {
            cityTextField.isUserInteractionEnabled = setEnable
        }
        else
        {
//         if setEnable == false
//         {
            cityTextField.isUserInteractionEnabled = setEnable

         //}
        }
        //cityTextField.isUserInteractionEnabled = setEnable
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
            if companiesInterviewedTextView.text == "Companies interviewed in past 1 year" || companiesInterviewedTextView.text == "Companies interviewed in past 1 year\n"
            {
                companiesInterviewedTextView.text = "";
            }
            else
            {
            }
            
            companiesInterviewedTextView.textColor = UIColor.black

        }
        else
            if textView == benefitsTextView
            {
                if benefitsTextView.text == "Benefits in current organization(401k/insurance coverage etc)\n" || benefitsTextView.text == "Benefits in current organization(401k/insurance coverage etc)"
                {
                    benefitsTextView.text = "";
                    
                }
                else
                {
                }
                benefitsTextView.textColor = UIColor.black
            }
            else
                if textView == nonCompeteTextView
                {
                    if nonCompeteTextView.text == "Any non-compete that will prevent you from managing a specific client OR Not join any specific organization" || nonCompeteTextView.text == "Any non-compete that will prevent you from managing a specific client OR Not join any specific organization\n"
                    {
                        nonCompeteTextView.text = "";
                        
                    }
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
                self.autoCompleteTableView.isHidden = true

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
                    self.autoCompleteTableView.isHidden = true

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
                        self.autoCompleteTableView.isHidden = true

                        if self.visaStatusTextField.text == ""
                        {
                            self.visaStatusTextField.text = self.visaTypesArray[0]
                        }
                    }
                    
                }
                else
                    if textField == stateTextField
                    {
                        filterArray.removeAll()

                        cityArray.removeAll()
                        
                        cityTextField.text = nil

                        if stateTextField.text != nil
                        {
                            filterArray = self.statesArray.filter { $0.localizedCaseInsensitiveContains(stateTextField.text!) }
                            
                            if filterArray.count > 0
                            {
                                self.autoCompleteTableView.isHidden = false
                                
                            }
                            else
                            {
                                self.autoCompleteTableView.isHidden = true
                                
                            }
                            self.autoCompleteTableView.reloadData()


                        }
                        

                        
                        
                        
                       // let cgrect = self.stateTextField.convert(stateTextField.frame, to: nil)

                       // self.autoCompleteTableView.frame = CGRect(x: cgrect.origin.x, y: cgrect.origin.y , width: self.autoCompleteTableView.frame.size.width, height: self.autoCompleteTableView.frame.size.height)
                        self.topSpaceConstraint.constant = 0
                        

                    }
                        else
                        if textField == cityTextField
                        {
                            

                            if self.statesArray.contains(stateTextField.text!.capitalizingFirstLetter())
                            {
                                self.filterArray.removeAll()
                                
                                self.cityArray.removeAll()
                                
                                self.getCitiesFromState(stateName: self.stateTextField.text!.capitalizingFirstLetter())
                            }
                            

                            if cityArray.count < 1
                            {
                                stateTextField.becomeFirstResponder()
                                
                                AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid State", withMessage: "Please select state first", withCancelText: "Ok")
                                
                                return
                            }
                            //let cgrect = self.cityTextField.convert(cityTextField.frame, to: nil)
                            
                            //self.autoCompleteTableView.frame = CGRect(x: self.cityTextField.frame.origin.x, y: self.cityTextField.frame.origin.y, width: self.autoCompleteTableView.frame.size.width, height: self.autoCompleteTableView.frame.size.height)
                            self.topSpaceConstraint.constant = 50
                            //self.autoCompleteTableView.frame = CGRect(x: cgrect.origin.x, y: cgrect.origin.y, width: self.autoCompleteTableView.frame.size.width, height: self.autoCompleteTableView.frame.size.height)
                            //self.topSpaceConstraint
//                            self.autoCompleteTableView.removeConstraint(topSpaceConstraint)
//                            let con = NSLayoutConstraint(item: self.autoCompleteTableView, attribute: .top, relatedBy: .equal, toItem: self.cityTextField, attribute: .bottom, multiplier: 1, constant: 50)
//
//                            //self.autoCompleteTableView.addConstraint(con)
//                            NSLayoutConstraint.activate([con])
                            // Add the constraint to the view
                            //self.view.addConstraint(constraintButton)
                            
                            filterArray.removeAll()

                            if cityTextField.text != nil
                            {
                                filterArray = self.cityArray.filter { $0.localizedCaseInsensitiveContains(cityTextField.text!) }
                                
                                if filterArray.count > 0
                                {
                                    self.autoCompleteTableView.isHidden = false

                                }
                                else
                                {
                                    self.autoCompleteTableView.isHidden = true

                                }
                                self.autoCompleteTableView.reloadData()
                                
                                
                            }
                            

                            
                            //cityTextField.filterStrings(self.cityArray)

                        }
                        else
                        {
                            self.autoCompleteTableView.isHidden = true
                        }
    

    }
 
    func textFieldDidEndEditing(_ textField: UITextField)
    {
    
//        if textField == self.stateTextField
//        {
//            if self.stateTextField.text != nil && self.stateTextField.text != ""
//            {
//                if !self.statesArray.contains(self.stateTextField.text!)
//                {
//                    self.cityTextField.isUserInteractionEnabled = false
//                    
//                    //                        DispatchQueue.main.async
//                    //                            {
//                    
//                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid state", withMessage: "Please select a proper state", withCancelText: "Ok")
////                    textField.text = self.existingStateName
////                    self.cityTextField.text = self.existingCityName
//                    textField.text = ""
//                    self.cityTextField.text = ""
//                    //}
//                    
//                    
//                    
//                }
//                else
//                {
//                    textField.resignFirstResponder()
//                    
//                }
//            }
//
//        }
//        else
//            if textField == cityTextField
//            {
//            if self.cityTextField.text != nil && self.cityTextField.text != ""
//            {
//                if !self.cityArray.contains(self.cityTextField.text!)
//                {
//                    //                                DispatchQueue.main.async
//                    //                                    {
//                    self.cityTextField.text = ""
//                    AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid city", withMessage: "Please select a proper city", withCancelText: "Ok")
//                    // }
//                }
//                else
//                {
//                    textField.resignFirstResponder()
//                    
//                }
//            }
//            else
//            {
//                //self.location1TextField.isUserInteractionEnabled = false
//                textField.resignFirstResponder()
//            }
//        }
        
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
        //        DispatchQueue.main.async
        //            {
        if textField == self.stateTextField
        {
            if self.stateTextField.text != nil && self.stateTextField.text != ""
            {
                if !self.statesArray.contains(self.stateTextField.text!)
                {
                    //self.cityTextField.isUserInteractionEnabled = false
                    
                    //                        DispatchQueue.main.async
                    //                            {
                    
                    //AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid state", withMessage: "Please select a proper state", withCancelText: "Ok")
                    //textField.text = nil
                   // self.cityTextField.text = nil
                    textField.resignFirstResponder()

                    self.autoCompleteTableView.isHidden = true

                    //}
                    
                    
                    
                }
                else
                {
                    self.cityArray.removeAll()
                    self.getCitiesFromState(stateName: self.stateTextField.text!)
                    textField.resignFirstResponder()
                    self.autoCompleteTableView.isHidden = true

                }
            }
            else
            {
                //self.cityTextField.isUserInteractionEnabled = false
                textField.resignFirstResponder()
            }
        }
        else
            if textField == self.cityTextField
            {
                if self.cityTextField.text != nil && self.cityTextField.text != ""
                {
                    if !self.cityArray.contains(self.cityTextField.text!)
                    {
                        //                                DispatchQueue.main.async
                        //                                    {
                        //self.cityTextField.text = ""
                       // AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid city", withMessage: "Please select a proper city", withCancelText: "Ok")
                        // }
                        textField.resignFirstResponder()

                        self.autoCompleteTableView.isHidden = true

                    }
                    else
                    {
                        textField.resignFirstResponder()
                        self.autoCompleteTableView.isHidden = true

                    }
                }
                else
                {
                    textField.resignFirstResponder()
                    //self.location1TextField.isUserInteractionEnabled = false
                    
                }
            }
            else
            {
                textField.resignFirstResponder()
                
        }
        
        //}
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        if text == "\n"
        {
          textView.resignFirstResponder()
            return false
        }
        return true
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
            
            let index = statesArray.index(of: "asda")
            
            if index != nil
            {
                statesArray.remove(at: index!)
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
        imagePickerController = UIImagePickerController()
        
        
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
        
        let width = userImage?.size.width
        
        let height = userImage?.size.height

        print("width = \(width)" + "height = \(height)")
//        UIImage *imageToDisplay =
//            [UIImage imageWithCGImage:[originalImage CGImage]
//                scale:[originalImage scale]
//                orientation: UIImageOrientationUp];
        
        //let userImage = UIImage(cgImage: (imageToDisplay?.cgImage)!, scale: (imageToDisplay?.scale)!, orientation: .up)
        let size = CGSize(width: height!, height: width!)
        let image = imageResize(image: userImage!,sizeChange: size)
        //myImageView.image! = imageResize(myImageView.image!,sizeChange: size)
        let width1 = image.size.width
        
        let height1 = image.size.height
        
        print("width1 = \(width1)" + "height = \(height1)")
        
        //imagedata    = UIImagePNGRepresentation(image) as Data!
        imagedata = UIImageJPEGRepresentation(image, 0.01)!
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
    func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        DispatchQueue.main.async
            {
            self.setRightBarButtonItemSave()

        }

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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == stateTextField
        {
            let nsString = textField.text as NSString?
            let newString = nsString?.replacingCharacters(in: range, with: string)
           // let newString = newString1?.lowercased()
            print("ol1dString = \(nsString)")
            print("newString = \(newString)")
            
            if newString == ""
            {
                cityArray.removeAll()
                
                filterArray.removeAll()
                
                self.autoCompleteTableView.reloadData()
                
                self.autoCompleteTableView.isHidden = true
            }
            else
            {
                filterArray.removeAll()
                
                    filterArray = self.statesArray.filter { $0.localizedCaseInsensitiveContains(newString!) }
                
                if filterArray.count > 0
                {
                    self.autoCompleteTableView.isHidden = false
                    
                }
                else
                {
                    self.autoCompleteTableView.isHidden = true
                    
                }
                
                
                        self.autoCompleteTableView.reloadData()
                
            }

         }
        else
            if textField == cityTextField
            {
                let nsString = textField.text as NSString?
                let newString = nsString?.replacingCharacters(in: range, with: string)
                // let newString = newString1?.lowercased()
                print("ol1dString = \(nsString)")
                print("newString = \(newString)")
                
                if newString == ""
                {
                    filterArray.removeAll()
                    
                    self.autoCompleteTableView.reloadData()
                    
                    self.autoCompleteTableView.isHidden = true
                    
                    
                }
                else
                {
                    filterArray.removeAll()
                    
                    filterArray = self.cityArray.filter { $0.localizedCaseInsensitiveContains(newString!) }
                    
                    if filterArray.count > 0
                    {
                        self.autoCompleteTableView.isHidden = false
                        
                    }
                    else
                    {
                        self.autoCompleteTableView.isHidden = true
                        
                    }
                    self.autoCompleteTableView.reloadData()
                    
                }
                
        }

        
        return true
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = filterArray[indexPath.row]
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let cell = tableView.cellForRow(at: indexPath)
        if stateTextField.isFirstResponder
        {
            self.stateTextField.text = cell?.textLabel?.text
            
            self.cityArray.removeAll()
            
            self.filterArray.removeAll()
            
            self.getCitiesFromState(stateName: self.stateTextField.text!)
            
            self.autoCompleteTableView.reloadData()
            
            self.autoCompleteTableView.isHidden = true
        }
        else
        {
            self.cityTextField.text = cell?.textLabel?.text
            
            //self.cityArray.removeAll()
            
            //self.filterArray.removeAll()

            self.autoCompleteTableView.reloadData()

            self.autoCompleteTableView.isHidden = true

        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
//        if self.stateTextField.isFirstResponder
//        {
//            let cgrect = self.stateTextField.convert(stateTextField.frame, to: UIApplication.shared.keyWindow)
//            
//            self.autoCompleteTableView.frame = CGRect(x: cgrect.origin.x, y: cgrect.origin.y + self.stateTextField.frame.size.height+2 , width: self.autoCompleteTableView.frame.size.width, height: self.autoCompleteTableView.frame.size.height)
//        }
//        else
//            if self.cityTextField.isFirstResponder
//            {
//                let cgrect = self.cityTextField.convert(cityTextField.frame, to: UIApplication.shared.keyWindow)
//                
//                self.autoCompleteTableView.frame = CGRect(x: cgrect.origin.x, y: cgrect.origin.y + self.cityTextField.frame.size.height , width: self.autoCompleteTableView.frame.size.width, height: self.autoCompleteTableView.frame.size.height)
//            }
//        
//        if !scrollView.isKind(of: UITableView.classForCoder())
//        {
//         autoCompleteTableView.isHidden = true
//        }
        // self.autoCompleteTableView.isHidden = true
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
