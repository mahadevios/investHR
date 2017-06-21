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

class Registration1ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var visaStatusTextField: TextField!
    @IBOutlet weak var locationTextField: SearchTextField!
    @IBOutlet weak var location1TextField: SearchTextField!
    @IBOutlet weak var currentRoleTextField: TextField!
    @IBOutlet weak var currentCompanyTextField: TextField!
    var name:String?
    var email:String?
    var mobile:String?
    var password:String?

    
    var statesArray:[String] = []
    var cityArray:[String] = []
    var stateNameAndIdDic = [String:Int16]()
    var cityNameAndIdDic = [String:Int64]()


    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        

        let imageView = UIImageView(frame: CGRect(x: 15, y: 5, width: 10, height: 20))
        let image = UIImage(named: "Role")
        imageView.image = image
        
        currentRoleTextField.addSubview(imageView)
        
        let imageView1 = UIImageView(frame: CGRect(x: 15, y: 10, width: 20, height: 20))
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

        locationTextField.theme.font = UIFont.systemFont(ofSize: 15)
        locationTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.8)
        locationTextField.theme.cellHeight = 35

        location1TextField.theme.font = UIFont.systemFont(ofSize: 15)
        location1TextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.8)
        location1TextField.theme.cellHeight = 35

        locationTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            
            DispatchQueue.main.async
            {
                self.locationTextField.text = item.title

                self.cityArray.removeAll()
                
                self.getCitiesFromState(stateName: item.title)
                
                self.location1TextField.filterStrings(self.cityArray)

            }
        }
        
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
        
        locationTextField.filterStrings(statesArray)
        
        let imageView4 = UIImageView(frame: CGRect(x: 15, y: 10, width: 18, height: 6))
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

        // LISDKSessionManager.clearSession()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkRegistrationResponse(dataDic:)), name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_REGISTERED), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkRegistrationResponse(dataDic:NSNotification)
    {
        //        self.view.viewWithTag(789)?.removeFromSuperview()
        
        guard let responseDic = dataDic.object as? [String:String] else
        {
            //AppPreferences.sharedPreferences().showAlertViewWith(title: "Something went wrong!", withMessage: "Please try again", withCancelText: "Ok")
            // hide hud
            return
        }
        
        guard let code = responseDic["code"] else {
            // hide hud
            
            return
        }
        //let code = responseDic["code"]
        
        let name = responseDic["name"]
        
        let message = responseDic["Message"]
        
        let imageName = responseDic["ImageName"]
        
        CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
        
        let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "User", ["name":name! ,"username":self.email,"password":self.password,"pictureUrl":imageName!])
        
        UserDefaults.standard.set(self.email!, forKey: Constant.USERNAME)
        UserDefaults.standard.set(self.password!, forKey: Constant.PASSWORD)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let currentRootVC = (appDelegate.window?.rootViewController)! as UIViewController
        
        print(currentRootVC)
        
        let className = String(describing: type(of: currentRootVC))
        
        self.view.viewWithTag(789)?.removeFromSuperview() // remove hud
        
        if className == "LoginViewController"
        {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            appDelegate.window?.rootViewController = rootViewController
            
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_USER_CHANGED), object: nil, userInfo: nil)
            
        }
        
        
    }

    func getState()
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.fetch(entity: "State")
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
        if pickerView.tag == 1
        {
            return statesArray.count

        }
        else
        {
          return cityArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 1
        {
            return statesArray[row]
            
        }
        else
        {
            return cityArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        if pickerView.tag == 1
        {
            label?.font = UIFont.systemFont(ofSize: 12)
            label?.text =  statesArray[row] as? String
            label?.textAlignment = .center
        }
        else
        {
            label?.font = UIFont.systemFont(ofSize: 12)
            label?.text =  cityArray[row] as? String
            label?.textAlignment = .center
        }
       
        return label!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        
        print(pickerView.selectedRow(inComponent: component))
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func submitButtonPressed(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let currentRootVC = (appDelegate.window?.rootViewController)! as UIViewController

        let className = String(describing: type(of: currentRootVC))
        
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
            APIManager.getSharedAPIManager().registerUser(dict: decoded)
            
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
          stateId = String(describing: stateNameAndIdDic[state]!)
            
            
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
            cityId = String(describing: cityNameAndIdDic[city]!)
        }
        
        guard let visaStatus = visaStatusTextField.text else {
            
            return
        }
        
        vc.name = self.name
        vc.email = self.email
        vc.password = self.password
        vc.mobile = mobileNumber
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
