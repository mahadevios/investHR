//
//  AdditionalInfoViewController.swift
//  investHR
//
//  Created by mac on 24/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class AdditionalInfoViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate {

    @IBOutlet weak var candidateFunctionTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!

    @IBOutlet weak var linkedInURLTextField: UITextField!
    
    @IBOutlet weak var currentRoleTextField: UITextField!
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
    
    let candidateFunctionArray : [String] = ["Candidate Role","Candidate 2","Candidate 3","Candidate 4","Candidate 5"]
    let servicesArray : [String] = ["Services","Service 2","Service 3","Service 4","Service 5"]

    @IBAction func submitButtonClicked(_ sender: Any)
    {
        
    }
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)

       //self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        let candidateFunctionPickerView = UIPickerView(frame: CGRect(x: 15, y: 0, width: candidateFunctionTextField.frame.size.width * 0.80, height: 35))
        candidateFunctionPickerView.dataSource = self
        candidateFunctionPickerView.delegate = self
        candidateFunctionTextField.addSubview(candidateFunctionPickerView)
        candidateFunctionPickerView.tag = 1
        
        let servicePickerView = UIPickerView(frame: CGRect(x: 15, y: 0, width: serviceTextField.frame.size.width * 0.80, height: 35))
        servicePickerView.dataSource = self
        servicePickerView.delegate = self
        serviceTextField.addSubview(servicePickerView)
        servicePickerView.tag = 2
        
        companiesInterViewedTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        benefitsTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        nonCompeteTextView.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        companiesInterViewedTextView.delegate = self
        benefitsTextView.delegate = self
        nonCompeteTextView.delegate = self
        // Do any additional setup after loading the view.
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 1
        {
            return candidateFunctionArray.count
            
        }
        else
        {
            return servicesArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 1
        {
            return candidateFunctionArray[row]
            
        }
        else
        {
            return servicesArray[row]
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
            label?.text =  candidateFunctionArray[row] as? String
            label?.textAlignment = .left
        }
        else
        {
            label?.font = UIFont.systemFont(ofSize: 12)
            label?.text =  servicesArray[row] as? String
            label?.textAlignment = .left
        }
        
        return label!
        
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
