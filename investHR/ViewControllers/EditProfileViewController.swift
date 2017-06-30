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
    
    @IBOutlet weak var passwordTextField: TextField!
    
    var statesArray:[String] = []
    var cityArray:[String] = []
    var stateNameAndIdDic = [String:Int16]()
    var cityNameAndIdDic = [String:Int64]()
    
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
        
        getState()
        
        stateTextField.filterStrings(statesArray)
        stateTextField.delegate = self
        cityTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(checkUpdateProfileResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_SAVE_EDITED_PROFILE), object: nil)

        //uploadFIleUsingFTP()
        // Do any additional setup after loading the view.
    }
    
    func checkUpdateProfileResponse(dataDic:Notification)
    {
        guard let responseDic = dataDic.object as? [String:String] else
        {
            return
        }
        
        guard let code = responseDic["code"] else {
            
            return
        }

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

    
    }
    
//    func uploadFIleUsingFTP()
//    {
//        
//            //                let dataDictionary = try JSONSerialization.jsonObject(with: responseData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
//            
//            
//            UserDefaults.standard.synchronize()
//            
//            
//            // Specify the URL string that we'll get the profile info from.
//            //let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url,id,first-name,last-name,maiden-name,headline,email-address,picture-urls::(original))?format=json"
//            
//            let targetURLString = "ftp://\(Constant.FTP_USERNAME):\(Constant.FTP_PASSWORD)\(Constant.FTP_HOST_NAME)\(Constant.FTP_FILES_FOLDER_NAME)\("abc")"
//            
//            let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
//            
//            // Indicate that this is a GET request.
//            request.httpMethod = "POST"
//            
//            let data = UIImagePNGRepresentation(UIImage(named:"Cross")!) as NSData?
//            
//            request.httpBody = data! as Data
//            // Add the access token as an HTTP header field.
//            //request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//            
//            //let session = URLSession(configuration: URLSessionConfiguration.default)
//            
//            // Make the request.
//            let sessionConfiguration = URLSessionConfiguration.default
//            //sessionConfiguration.URLCredentialStorage = cred_storage;
//            sessionConfiguration.allowsCellularAccess = true
//            
//            
//            let session = URLSession(configuration: sessionConfiguration)
//        
//        
//            let uploadTask = session.uploadTask(with: request as URLRequest, from: data as! Data)
//            uploadTask.resume()
////            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
////                
////                let statusCode = (response as! HTTPURLResponse).statusCode
////                
////                if statusCode == 200
////                {
////                    // Convert the received JSON data into a dictionary.
////                    
////                }
////                else
////                {
////                    
////                }
////                
////                
////            }
////            
////            task.resume()
//            
//        
//        
//    }
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("hi")

    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        print(data)
        print("hi")

    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
        }
    }
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
        print(error?.localizedDescription)
    }
    override func viewWillAppear(_ animated: Bool)
    {
    //    super.viewWillAppear(true)
      editProfileButton.setTitle("", for: .normal)
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        stateTextField.delegate = self
        
         NotificationCenter.default.addObserver(self, selector: #selector(checkGetProfileResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_GET_USER_PROFILE), object: nil)
        
        setUserInteractionEnabled(setEnable: false)
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
    
    override func viewWillDisappear(_ animated: Bool)
    {
       NotificationCenter.default.removeObserver(self)
    }
    
    func checkGetProfileResponse(dataDic:Notification)
    {
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

        let state = userDetailsDict["state"] as? String

        let city = userDetailsDict["city"] as? String
        
        let companiesInterViewed = userDetailsDict["companiesInterviewInlastTwoYears"] as? String

        if companiesInterViewed != nil
        {
            companiesInterviewedTextView.text = companiesInterViewed
        }
        let visaStatus = userDetailsDict["visaStatus"] as? String
        
        if visaStatus != nil
        {
            visaStatusTextField.text = visaStatus
        }

        
        let expectedComp = userDetailsDict["expectedComp"] as? String
        
        if expectedComp != nil
        {
            expectedCompanyTextField.text = expectedComp
        }

        let candidateFunction = userDetailsDict["candidateFunction"] as? String
        
        if candidateFunction != nil
        {
            candidateFunctionTextField.text = candidateFunction
        }
        
        let verticals = userDetailsDict["verticals"] as? String
        
        if verticals != nil
        {
            verticalsTextFiled.text = verticals
        }

        let verticalsOrIndustory = userDetailsDict["verticalsOrIndustory"] as? String
        
//        if verticalsOrIndustory != nil
//        {
//            vert.text = verticals
//        }

        let pandL = userDetailsDict["pandL"] as? String
        
        if pandL != nil
        {
            PLTextFiled.text = pandL
        }
        
        let linkedInUrl = userDetailsDict["linkedInUrl"] as? String
        
        if pandL != nil
        {
            linkedInProfileUrlTextField.text = linkedInUrl
        }
        
        let benefitsInCurrentOrg = userDetailsDict["benefitsInCurrentOrg"] as? String
        
        if benefitsInCurrentOrg != nil
        {
            benefitsTextView.text = benefitsInCurrentOrg
        }

        let relocation = userDetailsDict["relocation"] as? String
        
        if relocation != nil
        {
            relocationTextFIeld.text = relocation
        }

        let anyNonComplete = userDetailsDict["anyNonComplete"] as? String
        
        if anyNonComplete != nil
        {
            nonCompeteTextView.text = anyNonComplete
        }
        
        let experienceInOffshore = userDetailsDict["experienceInOffshore"] as? String
        
        if experienceInOffshore != nil
        {
            experienceTextField.text = experienceInOffshore
        }

        let imageName = userDetailsDict["imageName"] as? String

        let revenueQuota = userDetailsDict["revenueQuota"] as? String
        
        if revenueQuota != nil
        {
            revenueQuotaTextFiled.text = revenueQuota
        }

        let joiningTimeRequired = userDetailsDict["joiningTimeRequired"] as? String
        
        if joiningTimeRequired != nil
        {
            joiningTimeTextFIeld.text = joiningTimeRequired
        }

        nameTextField.text = username
        
        if mobileNum != nil
        {
            mobileNumberTextField.text = mobileNum
        }
        
        if emailId != nil
        {
            emailTextField.text = emailId
        }

        if currentRole != nil
        {
            cuurentRoleTextField.text = currentRole
        }
        
        if currentCompany != nil
        {
            currentCompanyTextField.text = currentCompany
        }
        
        if state != nil
        {
            stateTextField.text = state
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
                        
                                let userImage = UIImage(data: imageData)
                        
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
        
        setRightBarButtonItemSave()

        nameTextField.becomeFirstResponder()
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
        guard let editedPassword = passwordTextField.text else {
            
            return
        }
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
            roleId = String(describing: stateNameAndIdDic[candidateFunction]!)
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
            if editedPassword == ""
            {
                editedPassword1 = password
            }
            else
            {
                editedPassword1 = editedPassword
            }
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
        
        let dict = ["name":name,"email":username!,"password":password!,"linkedinId":linkedInId!,"editedEmail":editedEmail1,"editedPassword":editedPassword1,"mobile":mobile,"currentRole":cuurentRole,"currentCompany":currentCompany,"stateId":state,"cityId":city,"visaStatus":visaStatus,"candidateFunction":roleId!,"services":service,"linkedInProfileUrl":linkedInUR,"verticalsServiceTo":vertical,"revenueQuota":revenueQuota,"PandL":PL,"currentCompLastYrW2":currentCompany,"expectedCompany":expectedCompany,"joiningTime":joinigTime,"compInterviewPast1Yr":companiesInterViewed,"benifits":benefits,"notJoinSpecificOrg":nonCompete,"image":"","expInOffshoreEng":expOffshore,"relocation":relocation,"deviceToken":AppPreferences.sharedPreferences().firebaseInstanceId,"linkedIn":linkedInId!] as [String : String]
        
        
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
        
        let countryCodePickerView = UIPickerView(frame: CGRect(x: 35, y: 1, width: 40, height: 40))
        countryCodePickerView.dataSource = self
        countryCodePickerView.delegate = self
        leftView.addSubview(countryCodePickerView)
        mobileNumberTextField.leftView = leftView
        mobileNumberTextField.leftViewMode = UITextFieldViewMode.always
        
        
        
        let imageView2 = UIImageView(frame: CGRect(x: 15, y: 8, width: 16, height: 12))
        let image2 = UIImage(named: "Email")
        imageView2.image = image2
        emailTextField.addSubview(imageView2)
        
        let imageView3 = UIImageView(frame: CGRect(x: 15, y: 5, width: 18, height: 15))
        let image3 = UIImage(named: "Password")
        imageView3.image = image3
        passwordTextField.addSubview(imageView3)
        
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
            
            managedObjects = coreDataManager.getAllRecords(entity: "User")
            for userObject in managedObjects as! [User]
            {
                let firstName = userObject.name
                let pictureUrlString = userObject.pictureUrl
                
                guard firstName != nil else
                {
                    break
                }
                nameTextField.text = "\(firstName!)"

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
