//
//  Registration1ViewController.swift
//  investHR
//
//  Created by mac on 23/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//
// auto complete textfield https://github.com/apasccon/SearchTextField
import UIKit

import CoreData

class Registration1ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var visaStatusTextField: TextField!
    @IBOutlet weak var locationTextField: TextField!
    @IBOutlet weak var location1TextField: TextField!
    @IBOutlet weak var currentRoleTextField: TextField!
    @IBOutlet weak var currentCompanyTextField: TextField!
    var name:String?
    var email:String?
    var mobile:String?
    var password:String?
    var imageData:Any?

    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var autoCompleteTableView: UITableView!
    var filterArray = [String]()

    var statesArray:[String] = []
    var cityArray:[String] = []
    var stateNameAndIdDic = [String:Int16]()
    var cityNameAndIdDic = [String:Int64]()
    let visaTypesArray = ["US Citizen","Green Card Holder","UK Tier 1 Visa","Uk Tier 2 Visa","UK Citizen","UK – PR","Canadian Citizen","TN Visa","Euro Zone Citizen","EAD card Holder","L2 EAD","H1 Visa","L1 Visa","H4 Visa","L2 Visa"]
    let visaTypesAndIdArray = ["US Citizen":"1","Green Card Holder":"2","UK Tier 1 Visa":"3","Uk Tier 2 Visa":"4","UK Citizen":"5","UK – PR":"6","Canadian Citizen":"7","TN Visa":"8","Euro Zone Citizen":"9","EAD card Holder":"10","L2 EAD":"11","H1 Visa":"12","L1 Visa":"13","H4 Visa":"14","L2 Visa":"15"]

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        

        let imageView = UIImageView(frame: CGRect(x: 15, y: 6, width: 10, height: 20))
        let image = UIImage(named: "Role")
        imageView.image = image
        
        currentRoleTextField.addSubview(imageView)
        
        let imageView1 = UIImageView(frame: CGRect(x: 15, y: 9, width: 20, height: 20))
        let image1 = UIImage(named: "Company")
        imageView1.image = image1
        
        currentCompanyTextField.addSubview(imageView1)
        
        let imageView2 = UIImageView(frame: CGRect(x: 15, y: 10, width: 14, height: 17))
        let image2 = UIImage(named: "Location")
        imageView2.image = image2
        
        let imageView3 = UIImageView(frame: CGRect(x: 15, y: 10, width: 14, height: 17))
        let image3 = UIImage(named: "Location")
        imageView3.image = image3
        //locationTextField.leftView = imageView2
        
        locationTextField.addSubview(imageView2)
        location1TextField.addSubview(imageView3)

//        locationTextField.theme.font = UIFont.systemFont(ofSize: 15)
//        locationTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.8)
//        locationTextField.theme.cellHeight = 35

//        location1TextField.theme.font = UIFont.systemFont(ofSize: 15)
//        location1TextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.8)
//        location1TextField.theme.cellHeight = 35

        autoCompleteTableView.layer.borderColor = UIColor.gray.cgColor
        autoCompleteTableView.layer.borderWidth = 1.0
        autoCompleteTableView.layer.cornerRadius = 3.0
        
//        locationTextField.itemSelectionHandler = { filteredResults, itemPosition in
//            // Just in case you need the item position
//            let item = filteredResults[itemPosition]
//            
//            DispatchQueue.main.async
//            {
//                
//                    self.locationTextField.text = item.title
//                    
//                    self.cityArray.removeAll()
//                    
//                    self.location1TextField.isUserInteractionEnabled = true
//                    
//                    self.getCitiesFromState(stateName: item.title)
//                    
//                    self.location1TextField.filterStrings(self.cityArray)
//                
//                
//
//            }
//        }
        
//        location1TextField.itemSelectionHandler = { filteredResults, itemPosition in
//            // Just in case you need the item position
//            let item = filteredResults[itemPosition]
//            
//            DispatchQueue.main.async
//                {
//                    
//                    self.location1TextField.text = item.title
//                    
//                }
//        }

        
//        let statePickerView = UIPickerView(frame: CGRect(x: imageView2.frame.origin.x + imageView2.frame.size.width + 10, y: 1, width: locationTextField.frame.size.width * 0.40, height: 40))
//        statePickerView.dataSource = self
//        statePickerView.delegate = self
       // locationTextField.addSubview(statePickerView)
        //statePickerView.tag = 1
        
//        let cityPickerView = UIPickerView(frame: CGRect(x: imageView2.frame.origin.x + imageView2.frame.size.width + 10, y: 1, width: locationTextField.frame.size.width * 0.40, height: 40))
//        cityPickerView.dataSource = self
//        cityPickerView.delegate = self
//        location1TextField.addSubview(cityPickerView)
//        cityPickerView.tag = 2
        getState()
        
        //locationTextField.filterStrings(statesArray)
        
        let imageView4 = UIImageView(frame: CGRect(x: 13, y: 11, width: 18, height: 6))
        let image4 = UIImage(named: "Visa")
        imageView4.image = image4
        
        visaStatusTextField.addSubview(imageView4)


        //self.addView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        currentRoleTextField.delegate = self
        currentCompanyTextField.delegate = self
        visaStatusTextField.delegate = self
        locationTextField.delegate = self
        location1TextField.delegate = self
        //location1TextField.isUserInteractionEnabled = false
        // LISDKSessionManager.clearSession()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkRegistrationResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_REGISTERED), object: nil)
        
        self.autoCompleteTableView.isHidden = true


    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
//    func checkRegistrationResponse(dataDic:NSNotification)
//    {
//        //        self.view.viewWithTag(789)?.removeFromSuperview()
//        
//        guard let responseDic = dataDic.object as? [String:String] else
//        {
//            //AppPreferences.sharedPreferences().showAlertViewWith(title: "Something went wrong!", withMessage: "Please try again", withCancelText: "Ok")
//            // hide hud
//            return
//        }
//        
//        guard let code = responseDic["code"] else {
//            // hide hud
//            
//            return
//        }
//        //let code = responseDic["code"]
//        
//        let name = responseDic["name"]
//        
//        let message = responseDic["Message"]
//        
//        let imageName = responseDic["ImageName"]
//        
//        CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
//        
//        let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "User", ["name":name! ,"username":self.email,"password":self.password,"pictureUrl":imageName!])
//        
//        UserDefaults.standard.set(self.email!, forKey: Constant.USERNAME)
//        UserDefaults.standard.set(self.password!, forKey: Constant.PASSWORD)
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        let currentRootVC = (appDelegate.window?.rootViewController)! as UIViewController
//        
//        print(currentRootVC)
//        
//        let className = String(describing: type(of: currentRootVC))
//        
//        self.view.viewWithTag(789)?.removeFromSuperview() // remove hud
//        
//        if className == "LoginViewController"
//        {
//            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//            let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            appDelegate.window?.rootViewController = rootViewController
//            
//        }
//        else
//        {
//            self.dismiss(animated: true, completion: nil)
//            self.presentingViewController?.dismiss(animated: true, completion: nil)
//            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//            
//            NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil, userInfo: nil)
//            
//        }
//        
//        
//    }

    
    func checkRegistrationResponse(dataDic:NSNotification)
    {
        //        self.view.viewWithTag(789)?.removeFromSuperview()
        
        guard let responseDic = dataDic.object as? [String:AnyObject] else
        {
            return
        }
        
        guard let code = responseDic["code"] else {
            
            return
        }
        //let code = responseDic["code"]
        
        let name = responseDic["name"] as? String
        
        let message = responseDic["Message"] as? String
        
        let imageName = responseDic["ImageName"] as? String
        
        var emailId = responseDic["emailId"] as? String
        
        var linkedInId = responseDic["linkId"] as? String
        
        var userId = responseDic["UserId"] as! Int

        
        //var userId = 0
        if emailId == ""
        {
            emailId = "nil"
        }
        if linkedInId == ""
        {
            linkedInId = "nil"
        }
        //let available = CoreDataManager.getSharedCoreDataManager().checkUserAlreadyExistWithEmail(email: emailId, linkledInId: linkedInId)
        let available = CoreDataManager.getSharedCoreDataManager().checkUserAlreadyExistWithUserId(userId: String(describing: userId))

        if !available
        {
           
            //CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
           // let userIdString = CoreDataManager.getSharedCoreDataManager().getMaxUserId(entityName: "User")
            
           // userId = Int(userIdString)!
            
           // userId = userId + 1
            //CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
            
            let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "User", ["userId":"\(userId)", "name":name! ,"username":emailId,"password":self.password!,"pictureUrl":imageName!,"emailAddress":emailId,"linkedInId":linkedInId])
        }
        else
        {
            //userId = CoreDataManager.getSharedCoreDataManager().getUserId(email: emailId, linkledInId: linkedInId)
        
        }
        
        UserDefaults.standard.set(self.email!, forKey: Constant.USERNAME)
        UserDefaults.standard.set(self.password!, forKey: Constant.PASSWORD)
        //UserDefaults.standard.set(imageName!, forKey: Constant.IMAGENAME)
        UserDefaults.standard.set("\(userId)", forKey: Constant.USERID)
        UserDefaults.standard.set("\(self.email!)", forKey: Constant.LAST_LOGGEDIN_USER_NAME)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let currentRootVC = (appDelegate.window?.rootViewController)! as UIViewController
        
        print(currentRootVC)
        
        let className = String(describing: type(of: currentRootVC))
        
        self.view.viewWithTag(789)?.removeFromSuperview() // remove hud
        
        NotificationCenter.default.removeObserver(self)

        if className == "LoginViewController"
        {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            appDelegate.window?.rootViewController = rootViewController
            
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil, userInfo: nil)

            self.dismiss(animated: true, completion: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
//        if pickerView.tag == 1
//        {
//            return statesArray.count
//
//        }
//        else
//        {
          return visaTypesArray.count
        //}
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
//        if pickerView.tag == 1
//        {
//            return statesArray[row]
//            
//        }
//        else
//        {
            return visaTypesArray[row]
        //}
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
//        if pickerView.tag == 1
//        {
//            label?.font = UIFont.systemFont(ofSize: 12)
//            label?.text =  statesArray[row] as? String
//            label?.textAlignment = .center
//        }
//        else
//        {
            label?.font = UIFont.systemFont(ofSize: 14)
            label?.text =  visaTypesArray[row] as? String
            label?.textAlignment = .center
        //}
       
        return label!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        let selectedVisaStatus = visaTypesArray[row]
        
        visaStatusTextField.text = selectedVisaStatus
        //print(pickerView.selectedRow(inComponent: component))
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func submitButtonPressed(_ sender: Any)
    {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let currentRootVC = (appDelegate.window?.rootViewController)! as UIViewController
//
//        let className = String(describing: type(of: currentRootVC))
        
        currentRoleTextField.resignFirstResponder()
        currentCompanyTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        location1TextField.resignFirstResponder()
        visaStatusTextField.resignFirstResponder()
        
        guard let mobileNumber = self.mobile else {
            
            return
        }
        guard let currentRole = currentRoleTextField.text else {
            
            return
        }
        guard let currentCompany = currentCompanyTextField.text else {
            
            return
        }
        guard let state = locationTextField.text else {
            
            return
        }
        guard let city = location1TextField.text else {
            
            return
        }
        var stateId:String? = ""
        if state == ""
        {
            
        }
        else
        {
            if stateNameAndIdDic[state] != nil
            {
                stateId = String(describing: stateNameAndIdDic[state]!)
                
            }
            else
            {
                self.locationTextField.becomeFirstResponder()

                AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid State", withMessage: "Please select a valid state", withCancelText: "Ok")

                
                return

            }
           // stateId = String(describing: stateNameAndIdDic[state]!)
            
            
        }
        
        var cityId:String! = ""
        
        if city == ""
        {
            
        }
        else
            
        {
            if cityNameAndIdDic[city] != nil
            {
                cityId = String(describing: cityNameAndIdDic[city]!)

            }
            else
            {
                self.location1TextField.becomeFirstResponder()

                AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid City", withMessage: "Please select a valid state", withCancelText: "Ok")

                return
            }
        }

        guard let visaStatus = visaStatusTextField.text else {
            
            return
        }
        
        print(visaStatus)
        
        
        
        let dict = ["name":self.name!,"email":self.email!,"password":self.password!,"mobile":mobileNumber,"currentRole":currentRole,"currentCompany":currentCompany,"stateId":stateId!,"cityId":cityId!,"visaStatus":visaStatus,"candidateFunction":"","services":"","linkedInProfileUrl":"","verticalsServiceTo":"","revenueQuota":"","PandL":"","currentCompLastYrW2":"","expectedCompany":"","joiningTime":"","compInterviewPast1Yr":"","benifits":"","notJoinSpecificOrg":"","image":"","expInOffshoreEng":"","relocation":"","deviceToken":AppPreferences.sharedPreferences().firebaseInstanceId,"linkedIn":""] as [String : String]
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            print(decoded)
            // here "decoded" is of type `Any`, decoded from JSON data
            
            //            if AppPreferences.sharedPreferences().isReachable
            //            {
            let data = imageData as? Data
            APIManager.getSharedAPIManager().createRegistrationRequestAndSend(dict: decoded, imageData: data)
           // APIManager.getSharedAPIManager().registerUser(dict: decoded)
            
            let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
            
            hud.tag = 789
            
            hud.minSize = CGSize(width: 150.0, height: 100.0)
            
            hud.label.text = "Logging in.."
            
            hud.detailsLabel.text = "Please wait"
           
        } catch {
            print(error.localizedDescription)
        }

        
        
        
//        APIManager.getSharedAPIManager().registerUser(name: self.name!, emailId: self.email!, mobileNumber:mobileNumber, password: self.password!, curentRole: currentRole, currentCompany: currentCompany, state: String(state), city: String(city), visaStatus: visaStatus, service: "", linkedInProfileUrl: "", candidateRole: "", verticals: "", revenueQuota: "", PL: "", experience: "", cuurrentCompany: "", companyInterViewed: "", expectedCompany: "", relocation: "", joiningTimeReq: "", benefits: "", notJoin: "")
        
        
       

    }
    @IBAction func additionalInformationButtonPressed(_ sender: Any)
    {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AdditionalInfoViewController") as! AdditionalInfoViewController
        
        guard let mobileNumber = self.mobile else {
            
            return
        }
        guard let currentRole = currentRoleTextField.text else {
            
            return
        }
        guard let currentCompany = currentCompanyTextField.text else {
            
            return
        }
        guard let state = locationTextField.text else {
            
            return
        }
        
        var stateId:String? = ""
        if state == ""
        {
        
        }
        else
        {
            if stateNameAndIdDic[state] != nil
            {
                stateId = String(describing: stateNameAndIdDic[state]!)
                
            }
            else
            {
                self.locationTextField.becomeFirstResponder()

                AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid State", withMessage: "Please select a valid state", withCancelText: "Ok")
                
                
                return
                
            }
            
        }
        
        guard let city = location1TextField.text else
        {
            
            return
        }
        
        var cityId:String! = ""
        
        if city == ""
        {
            
        }
        else
        {
            if cityNameAndIdDic[city] != nil
            {
                cityId = String(describing: cityNameAndIdDic[city]!)
                
            }
            else
            {
                self.location1TextField.becomeFirstResponder()

                AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid City", withMessage: "Please select a valid city", withCancelText: "Ok")
                
                
                return
                
            }
        }
        
        guard let visaStatus = visaStatusTextField.text else {
            
            return
        }
        
        vc.name = self.name
        vc.email = self.email
        vc.password = self.password
        vc.mobile = mobileNumber
        vc.imageData = imageData
        vc.state = stateId!
        vc.currentRole = currentRole
        vc.visaStatus = visaStatus
        vc.city = cityId!
        vc.currentCompany = currentCompany
        
        self.navigationController?.present(vc, animated: true, completion: nil)

              //  self.present(viewController, animated: true, completion: nil)
    }

    func deviceRotated() -> Void
    {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
            
            print("Landscape")
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            //self.perform(#selector(addView), with: nil, afterDelay: 0.2)
            
            print("Portrait")
        }
    }

    func keyboardWillShow()
    {
        // Animate the current view out of the way
        if self.view.frame.origin.y >= 0
        {
                        
            if visaStatusTextField.isFirstResponder || locationTextField.isFirstResponder || location1TextField.isFirstResponder
            {
                setViewMovedUp(movedUp: true, localOffset: 136)
            }
            
        }
        //        else
        //            if self.view.frame.origin.y < 0
        //            {
        //                setViewMovedUp(movedUp: false, offset: 100)
        //            }
    }
    
    func keyboardWillHide()
    {
//        if self.view.frame.origin.y > 0
//        {
//            
//            setViewMovedUp(movedUp: true, offset: 100)
//        }
//        else
            if self.view.frame.origin.y < 0
            {
                setViewMovedUp(movedUp: false, localOffset: 136)
            }
    }
    
    func setViewMovedUp(movedUp:ObjCBool, localOffset:CGFloat)
    {
        
//        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
//        {
//            if (movedUpBy == "email" || movedUpBy == "password")
//            {
//                localOffset = 220
//            }
//            else
//            {
//                localOffset = 150
//            }
//        }
//        else
//        {
//            localOffset = 100
//        }
        
        
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
        
        if textField == visaStatusTextField
        {
            DispatchQueue.main.async
                {
                    self.visaStatusTextField.resignFirstResponder()
                    self.currentRoleTextField.resignFirstResponder()
                    self.currentCompanyTextField.resignFirstResponder()
                    
                    self.addPickerToolBarForRelocation()
                    
                    if self.visaStatusTextField.text == ""
                    {
                        self.visaStatusTextField.text = self.visaTypesArray[0]
                    }

            }
            
        }
        else
            if textField == locationTextField
            {
                filterArray.removeAll()
                
                cityArray.removeAll()
                
                location1TextField.text = nil
                
                if locationTextField.text != nil
                {
                    filterArray = self.statesArray.filter { $0.localizedCaseInsensitiveContains(locationTextField.text!) }
                    
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

                self.topSpaceConstraint.constant = 0
                
                
            }
            else
                if textField == location1TextField
                {
                    if cityArray.count < 1
                    {
                        locationTextField.becomeFirstResponder()
                        
                        AppPreferences.sharedPreferences().showAlertViewWith(title: "Invalid State", withMessage: "Please select a valid state", withCancelText: "Ok")
                        
                        return
                    }
                    self.topSpaceConstraint.constant = 50
                   
                    
                    filterArray.removeAll()
                    
                    if location1TextField.text != nil
                    {
                        filterArray = self.cityArray.filter { $0.localizedCaseInsensitiveContains(location1TextField.text!) }
                        
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
        if textField == self.locationTextField
        {
            if self.locationTextField.text != nil && self.locationTextField.text != ""
            {
                if !self.statesArray.contains(self.locationTextField.text!)
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
                    self.getCitiesFromState(stateName: self.locationTextField.text!)
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
            if textField == self.location1TextField
            {
                if self.location1TextField.text != nil && self.location1TextField.text != ""
                {
                    if !self.cityArray.contains(self.location1TextField.text!)
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
    
    func pickerDoneButtonPressed()
    {
        removePickerToolBar()
    }
    
    func removePickerToolBar()
    {
        
        
        if let picker1 = self.view.viewWithTag(20001)
        {
            picker1.removeFromSuperview()
            
        }
        
        
        if let toolbar1 = self.view.viewWithTag(20000)
        {
            toolbar1.removeFromSuperview()
            
        }
        
        // [DescriptionTextView becomeFirstResponder];
        
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == locationTextField
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
            if textField == location1TextField
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
        if locationTextField.isFirstResponder
        {
            self.locationTextField.text = cell?.textLabel?.text
            
            self.cityArray.removeAll()
            
            self.filterArray.removeAll()
            
            self.getCitiesFromState(stateName: self.locationTextField.text!)
            
            self.autoCompleteTableView.reloadData()
            
            self.autoCompleteTableView.isHidden = true
        }
        else
        {
            self.location1TextField.text = cell?.textLabel?.text
            
            //self.cityArray.removeAll()
            
            //self.filterArray.removeAll()
            
            self.autoCompleteTableView.reloadData()
            
            self.autoCompleteTableView.isHidden = true
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
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
