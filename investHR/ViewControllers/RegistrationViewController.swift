//
//  RegistrationViewController.swift
//  investHR
//
//  Created by mac on 23/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var outSideCircleView: UIImageView!
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var mobileNumberTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
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
        
        let imageView3 = UIImageView(frame: CGRect(x: 15, y: 5, width: 16, height: 21))
        let image3 = UIImage(named: "Password")
        imageView3.image = image3
        
        passwordTextField.addSubview(imageView3)

        //self.addView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        
        LISDKSessionManager.clearSession()

        
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
        
        label?.font = UIFont.systemFont(ofSize: 12)
        label?.text =  coutryCodesArray[row] as? String
        label?.textAlignment = .center
        return label!
        
    }
    @IBAction func backButtonPressed(_ sender: Any)
    {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func nextButtonPressed(_ sender: Any)
    {
        
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "Registration1ViewController") as! Registration1ViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
        //self.present(viewController, animated: true, completion: nil)
        
    }
    @IBAction func changeProfilePictureButtonClicked(_ sender: Any)
    {
        
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
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            self.perform(#selector(addView), with: nil, afterDelay: 0.2)

            print("Landscape")
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            self.perform(#selector(addView), with: nil, afterDelay: 0.2)

            print("Portrait")
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
