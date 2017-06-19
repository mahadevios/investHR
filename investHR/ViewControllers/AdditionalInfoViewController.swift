//
//  AdditionalInfoViewController.swift
//  investHR
//
//  Created by mac on 24/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

import CoreData

class AdditionalInfoViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var candidateFunctionTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!

    @IBOutlet weak var linkedInURLTextField: UITextField!
    
    @IBOutlet weak var verticalTextField: UITextField!
    @IBOutlet weak var revenueQuotaTextField: UITextField!
    @IBOutlet weak var PLTexField: UITextField!
    @IBOutlet weak var expOffshoreTextField: UITextField!
    @IBOutlet weak var currentCompanyTextFIeld: UITextField!
    @IBOutlet weak var expectedCompanyTextField: UITextField!
    @IBOutlet weak var relocationTextField: UITextField!
    @IBOutlet weak var joiningTimeTextfield: UITextField!
    @IBOutlet weak var companiesInterViewedTextView: UITextView!
    @IBOutlet weak var benefitsTextView: UITextView!
    @IBOutlet weak var nonCompeteTextView: UITextView!
    
    var name:String!
    var email:String!
    var mobile:String!
    var password:String!
    var state:String!
    var city:String!
    var currentRole:String!
    var currentCompany:String!
    var visaStatus:String!
    
    var candidateFunctionArray : [String] = []
    let servicesArray : [String] = ["Services","Service 2","Service 3","Service 4","Service 5"]

    @IBAction func submitButtonClicked(_ sender: Any)
    {
        guard let joinigTime = joiningTimeTextfield.text else {
            
            return
        }
        guard let companiesInterViewed = companiesInterViewedTextView.text else {
            
            return
        }
        guard let benefits = benefitsTextView.text else {
            
            return
        }
        guard let nonCompete = nonCompeteTextView.text else {
            
            return
        }

        guard let revenueQuota = revenueQuotaTextField.text else {
            
            return
        }
        guard let PL = PLTexField.text else {
            
            return
        }
        guard let expOffshore = expOffshoreTextField.text else {
            
            return
        }
        guard let expectedCompany = expectedCompanyTextField.text else {
            
            return
        }
        guard let relocation = relocationTextField.text else {
            
            return
        }

        guard let candidateFunction = candidateFunctionTextField.text else {
            
            return
        }
        guard let service = serviceTextField.text else {
            
            return
        }
        guard let linkedInUR = linkedInURLTextField.text else {
            
            return
        }
        guard let candidateRole = candidateFunctionTextField.text else {
            
            return
        }
        guard let vertical = verticalTextField.text else {
            
            return
        }
        
       let dict = ["name":self.name,"email":self.email,"mobileNumber":self.mobile,"password":self.password,"mobile":mobile,"currentRole":self.currentRole,"currentCompany":self.currentCompany,"stateId":self.state,"cityId":self.city,"visaStatus":self.visaStatus,"candidateFunction":candidateRole,"services":service,"linkedInProfileUrl":linkedInUR,"verticalsServiceTo":vertical,"revenueQuota":revenueQuota,"PandL":PL,"currentCompLastYrW2":currentCompany,"expectedCompany":expectedCompany,"joiningTime":joinigTime,"compInterviewPast1Yr":companiesInterViewed,"benifits":benefits,"notJoinSpecificOrg":nonCompete,"image":"","expInOffshoreEng":expOffshore,"relocation":relocation] as [String : String]
        
//let parameterArray = ["name=\(name)","emailId=\(emailId)","mobileNumber=\(mobileNumber)","password=\(password)","currentRole=\(curentRole)","currentCompany=\(currentCompany)","stateId=\(state)","cityId=\(city)","visaStatus=\(visaStatus)","candidateRole=\(candidateRole)","services=\(service)","linkedInProfileUrl=\(linkedInProfileUrl)","verticalsServiceTo=\(vertical)","revenueQuota=\(revenueQuota)","PandL=\(PL)","currentCompLastYrW2=\(currentCompany)","expectedCompany=\(expectedCompany)","joiningTime=\(joiningTimeReq)","compInterviewPast1Yr=\(companiesInterViewed)","benifits=\(benefits)","notJoinSpecificOrg=\(notJoin)"]
        
//        APIManager.getSharedAPIManager().registerUser(name: self.name!, emailId: self.email!, mobileNumber:self.mobile, password: self.password!, curentRole: currentRole, currentCompany: currentCompany, state: String(state), city: String(city), visaStatus: visaStatus, service: service, linkedInProfileUrl: linkedInUR, candidateRole: candidateRole, verticals: vertical, revenueQuota: revenueQuota, PL: PL, experience: expOffshore, cuurrentCompany: currentCompany, companyInterViewed: companiesInterViewed, expectedCompany: expectedCompany, relocation: relocation, joiningTimeReq: joinigTime, benefits: benefits, notJoin: nonCompete)
        
//        let dict = ["name":"kpk","mobile":"+93-9096284028","email":"kuldeepk@xanadutec.com","password":"kk123","currentRole":"dont","currentCompany":"new","stateId":"9","cityId":"3712","visaStatus":"","candidateFunction":"8","services":"","linkedInProfileUrl":"","verticalsServiceTo":"","revenueQuota":"","PandL":"","expInOffshoreEng":"","currentCompLastYrW2":"","expectedCompany":"","relocation":"","joiningTime":"","compInterviewPast1Yr":"","benifits":"","notJoinSpecificOrg":"hjkjjh","image":""]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            print(decoded)
            // here "decoded" is of type `Any`, decoded from JSON data
            
            APIManager.getSharedAPIManager().registerUser(dict: decoded)

            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                // use dictFromJSON
            }
        } catch {
            print(error.localizedDescription)
        }
//        APIManager.getSharedAPIManager().registerUser(dict: dict)
        
    }
    @IBAction func backButtonPressed(_ sender: Any)
    {
       // self.navigationController?.popViewController(animated: true)

       self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        print(visaStatus)
        //let candidateFunctionPickerView = UIPickerView(frame: CGRect(x: 15, y: 0, width: candidateFunctionTextField.frame.size.width * 0.80, height: 35))
        //candidateFunctionPickerView.dataSource = self
        //candidateFunctionPickerView.delegate = self
        //candidateFunctionTextField.addSubview(candidateFunctionPickerView)
        //candidateFunctionPickerView.tag = 1
        
//        let servicePickerView = UIPickerView(frame: CGRect(x: 15, y: 0, width: serviceTextField.frame.size.width * 0.80, height: 35))
//        servicePickerView.dataSource = self
//        servicePickerView.delegate = self
//        serviceTextField.addSubview(servicePickerView)
//        servicePickerView.tag = 2
        
        companiesInterViewedTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        benefitsTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        nonCompeteTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        companiesInterViewedTextView.delegate = self
        benefitsTextView.delegate = self
        nonCompeteTextView.delegate = self
        candidateFunctionTextField.delegate = self
        getCandidateRoles()
        // Do any additional setup after loading the view.
    }
    
    func getCandidateRoles()
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        
        do
        {
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.fetch(entity: "Roles")
            for userObject in managedObjects as! [Roles]
            {
                candidateFunctionArray.append(userObject.roleName!)
                
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView == companiesInterViewedTextView
        {
            companiesInterViewedTextView.text = "";
            companiesInterViewedTextView.textColor = UIColor.black
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
        if textView == companiesInterViewedTextView
        {
            if companiesInterViewedTextView.text!.characters.count == 0
            {
                companiesInterViewedTextView.textColor = UIColor(colorLiteralRed: 189/255.0, green: 189/255.0, blue: 195/255.0, alpha: 1)
                companiesInterViewedTextView.text = "Companies interviewed in past 1 year";
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == candidateFunctionTextField
        {
            DispatchQueue.main.async {
                self.candidateFunctionTextField.resignFirstResponder()
                
                self.addPickerToolBar()
                
                if self.candidateFunctionTextField.text == ""
                {
                    self.candidateFunctionTextField.text = self.candidateFunctionArray[0]
                }
            }
            
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
            return candidateFunctionArray.count
            
//        }
//        else
//        {
//            return servicesArray.count
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
//        if pickerView.tag == 1
//        {
            return candidateFunctionArray[row]
            
//        }
//        else
//        {
//            return servicesArray[row]
//        }
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
            label?.text =  candidateFunctionArray[row] as String
            label?.textAlignment = .center
           // label?.textAlignment = .left
        //}
        
        return label!
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let selectedRole = candidateFunctionArray[row]
        
        candidateFunctionTextField.text = selectedRole
    }
    
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

    func pickerDoneButtonPressed()
    {
        removePickerToolBar()
    }
    
    func removePickerToolBar()
    {
        guard let picker = self.view.viewWithTag(10001) else {
            return
        }
        
        picker.removeFromSuperview()
        
        guard let toolbar = self.view.viewWithTag(10000) else {
            return
        }
        
        toolbar.removeFromSuperview()
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
