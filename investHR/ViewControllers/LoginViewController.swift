//
//  ViewController.swift
//  investHR
//
//  Created by mac on 12/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

import CoreData

import FirebaseAuth

//import FBSDKLoginKit

import Firebase

import FirebaseAnalytics

//import LinkedinSwift

//import IOSLinkedInAPIFix

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var googleSignInCircleButton: UIButton!
    
    @IBOutlet weak var fbCircleLoginButton: UIButton!
    @IBOutlet weak var linkedInLoginCircleButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var accesToken:LISDKAccessToken?
    
    @IBAction func registerUserButtonClicked(_ sender: Any)
    {
//       let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController

        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "NavigationController")
        
        self.present(viewController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
      //  GIDSignIn.sharedInstance().delegate = self
        
       // GIDSignIn.sharedInstance().uiDelegate = self
        //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        //
        //
        //            return
        //        }        // Do any additional setup after loading the view, typically from a nib.
        
        //let coreDataManager = CoreDataManager.sharedManager
        // let managedObjectContext = CoreDataManager.managedObjectContext
        
       
        //let manageContext = appDelegate.persistentContainer.viewContext
        
        //let entity = NSEntityDescription.entity(forEntityName: "User", in: manageObjectContext)!
        
        //let userObject = NSManagedObject(entity: entity, insertInto: manageObjectContext) as! User
        
        //userObject.firstName = "abc"
        //userObject.setValue("ABC", forKey: "firstName")
        //userObject.setValue("XYZ", forKey: "lastName")
        
        //        do {
        //            try manageObjectContext.save()
        //
        //        } catch let error as NSError {
        //            print(error.localizedDescription)
        //        }
        
        
       // let result : [String: Any] = ["firstName" : "Steve", "surName" : "Jobs"]
        
//        let obj = coreDataManager.save(entity: "User", result)
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
//        
//                do
//                {
//                    let manageObject = try managedObjectContext.fetch(fetchRequest)
//                    var managedObjects:[NSManagedObject]?
//                    
//        managedObjects = coreDataManager.fetch(entity: "User")
//        for userObject in managedObjects as! [User]
//        {
//            let firstName = userObject.firstName
//            let lastName = userObject.lastName
//            
//            print(firstName ?? "nil")
//            
//            guard let lastname = lastName else
//            {
//                print("nnil value")
//                continue
//            }
//            print(lastname)
//        }
//        
//                } catch let error as NSError
//                {
//                    print(error.localizedDescription)
//                }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        let coreDataManager = CoreDataManager.sharedManager

        self.checkForAvailableLinkedInSession()
        
        emailTextField.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
//        emailTextField.leftViewMode = UITextFieldViewMode.always;
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 7, width: 15, height: 20))
        let image = UIImage(named: "Username")
        imageView.image = image
        
        emailTextField.addSubview(imageView)
        emailTextField.delegate = self
        
        passwordTextField.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        let imageView1 = UIImageView(frame: CGRect(x: 15, y: 6, width: 16, height: 21))
        let image1 = UIImage(named: "Password")
        imageView1.image = image1
        
        passwordTextField.addSubview(imageView1)
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //self.showData()
        
//        self.loadAccount(then: { () in
//            
//            print("cancel pressed")
//        }, or: nil)

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }

    func showData() -> Void
    {
        let coreDataManager = CoreDataManager.sharedManager
        
        let managedObjectContext = CoreDataManager.managedObjectContext
        
        //let obj = coreDataManager.save(entity: "User", result)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do
        {
            let manageObject = try managedObjectContext.fetch(fetchRequest)
            var managedObjects:[NSManagedObject]?
            
            managedObjects = coreDataManager.fetch(entity: "User")
            for userObject in managedObjects as! [User]
            {
                let firstName = userObject.firstName
                let lastName = userObject.lastName
                
                print(firstName ?? "nil")
                
                guard let lastname = lastName else
                {
                    print("nnil value")
                    continue
                }
                print(lastname)
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }

    }
    func checkForAvailableLinkedInSession() -> Void
    {
        let serializedToken = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if let serializedToken = serializedToken
        {
            if serializedToken.characters.count > 0
            {
                let accessToken = LISDKAccessToken.init(serializedString: serializedToken)
                
                if (accessToken?.expiration)! > Date()
                {
                    LISDKSessionManager.createSession(with: accessToken)
                    
                    dismiss(animated: true, completion: nil)
                    
                }
            }
            
        }

    }
    @IBAction func fbLoginButtonClicked(_ sender: Any)
    {
       // self.fbLoginButtonClicked()
    }
    
    @IBAction func googleLoginButtonClicked(_ sender: Any)
    {
       // self.googleLoginButtonClicked()
    }
    @IBAction func linkedInLoginButtonClicked(_ sender: Any)
    {
        
        
        
        self.loadAccount(then: { () in
            
            print("cancel pressed")
        }, or: nil)
        
        //        let conf = LinkedinSwiftConfiguration(clientId: "81no6kz3uepufn", clientSecret: "tgGDfootCo2zoLwB", state: "DLKDJF45DIWOERCM", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "investHR")
        //
        //        let helper = LinkedinSwiftHelper(
        //            configuration:conf!)
        //        helper.authorizeSuccess({ (lsToken) -> Void in
        //            print(lsToken)
        //
        //            helper.requestURL("https://api.linkedin.com/v1/people/~?format=json",
        //                              requestType: LinkedinSwiftRequestGet,
        //                              success: { (response) -> Void in
        //                                print(response)
        //
        //
        //            }) { [unowned self] (error) -> Void in
        //
        //                print(error.localizedDescription)
        //            }
        //        }, error: { (error) -> Void in
        //            print(error)
        //            
        //        }, cancel: { () -> Void in
        //        })

    }
    
    
    
    func loadAccount(then: (() -> Void)?, or: ((String) -> Void)?)
    { // then & or are handling closures
        //print(LISDKSessionManager.sharedInstance().session.accessToken)
        
        let performFetch:() -> Void = {
            
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,headline,email-address,picture-urls::(original))?format=json",
                                                           success: {
                                                            response in
                                                            print(response?.data ?? "hh")
                                                            
                                                            let token = LISDKSessionManager.sharedInstance().session.accessToken.serializedString()
                                                            UserDefaults.standard.setValue(token, forKey: Constant.LINKEDIN_ACCESS_TOKEN)
                                                            UserDefaults.standard.synchronize()
                                                            
                                                            if let dataFromString = response?.data.data(using: String.Encoding.utf8, allowLossyConversion: false)
                                                            {
                                                                var jsonResponse:[String:AnyObject]?
                                                                do
                                                                {
                                                                    jsonResponse = try JSONSerialization.jsonObject(with: dataFromString, options: .allowFragments) as! [String:AnyObject]
                                                                }
                                                                catch let error as NSError
                                                                {
                                                                  print(error.localizedDescription)
                                                                }
                                                                DispatchQueue.main.async
                                                                    {
                                                                        let userId = jsonResponse?["id"]

                                                                       // let idExist = CoreDataManager.sharedManager.idExists(aToken: userId as! String, entityName: "User")
                                                                        CoreDataManager.sharedManager.deleteAllRecords(entity: "User")
//                                                                        if idExist
//                                                                        {
//                                                                         
//                                                                        }
//                                                                        else
//                                                                        {
                                                                            let firstName = jsonResponse?["firstName"]
                                                                        
                                                                            let lastName = jsonResponse?["lastName"]
                                                                        
                                                                            let occupation = jsonResponse?["headline"]
                                                                        
                                                                            let emailAddress = jsonResponse?["emailAddress"]
                                                                            
                                                                            let pictureUrlsJson = jsonResponse?["pictureUrls"] as! [String:AnyObject]
                                                                        
                                                                            let totalUrlsNumber = pictureUrlsJson["_total"] as! Int
                                                                        
                                                                            let pictureUrlString:String!
                                                                        
                                                                            let pictureUrl:NSURL!
                                                                        
                                                                            var fileURL:NSURL! = NSURL()
                                                                        
                                                                            if(totalUrlsNumber == 0)
                                                                            {
//
                                                                                pictureUrlString = ""
                                                                                
                                                                            }
                                                                            else
                                                                            {
 
                                                                                let pictureUrlArray = pictureUrlsJson["values"] as! [String]
                                                                            
                                                                                pictureUrlString = pictureUrlArray[0]
                                                                            
                                                                                pictureUrl = NSURL(string: pictureUrlArray[0])
                                                                            }
                                                                            let managedObject = CoreDataManager.sharedManager.save(entity: "User", ["firstName":firstName ?? "nil","lastName":lastName ?? "nil","userId":userId ?? "nil","occupation":occupation ?? "nil","emailAddress":emailAddress ?? "nil","pictureUrl":pictureUrlString])
                                                                        //}
                                                                        
                                                                        
                                                                        
                                                                        
                                                                }
                                                            }
                                                            

                                                            //then?()
                                                            
                                                            
                },
                                                           error: {
                                                            error in
                                                            print(error ?? "kk")
                                                            // or?("error")
                }
                )
            }
            
        }
        
        
        let serializedToken = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as? String
        
        if let serializedToken = serializedToken
        {
            if serializedToken.characters.count > 0
            {
                let accessToken = LISDKAccessToken.init(serializedString: serializedToken)
                
                if (accessToken?.expiration)! > Date()
                {

                    DispatchQueue.main.async
                        {
                            
                            self.dismiss(animated: true, completion: nil)
                    }
                    // self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
            
        else
        {
            
            LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true,
                                              successBlock:
                {
                    (state) in
                    performFetch()
                    DispatchQueue.main.async
                    {
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        let currentRootVC = (appDelegate.window?.rootViewController)! as UIViewController
                        
                        print(currentRootVC)
                        
                        let className = String(describing: type(of: currentRootVC))
                        
                        if className == "LoginViewController"
                        {
                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                            let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                            appDelegate.window?.rootViewController = rootViewController

                        }
                        else
                        {
                            self.dismiss(animated: true, completion: nil)

                        }

                    }
            },
                                              errorBlock:
                {
                    (error) in
                    
                    print("got error")
                    
            })
            
        }
    }
    


    @IBAction func emailLoginButtonPressed(_ sender: Any)
    {
        if emailTextField.text == "" || passwordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Login Error", message: "Please enter valid credentials", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion:{ (user, error) in
                if let error = error
                {
                    if let errCode = FIRAuthErrorCode(rawValue: error._code)
                    {
                        switch errCode
                        {
                        case .errorCodeEmailAlreadyInUse:
                            let alertController = UIAlertController(title: "Login Error", message: "The email is already in use with another account", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            break
                            
                        case .errorCodeUserDisabled:
                            let alertController = UIAlertController(title: "Login Error", message: "Your account has been disabled. Please contact support.", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            break
                            
                            
                        case .errorCodeInvalidEmail, .errorCodeInvalidSender, .errorCodeInvalidRecipientEmail:
                            let alertController = UIAlertController(title: "Login Error", message: "Please enter a valid email", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            break
                            
                        case .errorCodeNetworkError:
                            let alertController = UIAlertController(title: "Login Error", message: "Network error. Please try again.", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            break
                            
                        case .errorCodeWeakPassword:
                            let alertController = UIAlertController(title: "Login Error", message: "Your password is too weak", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            break
                            
                            
                        default:
                            let alertController = UIAlertController(title: "Login Error", message: "Unknown error occurred, please try again", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            break
                        }
                        print(error.localizedDescription)
                    }
                    
                }
                else if let user = user
                {
                    if user.isEmailVerified
                    {
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                            UIApplication.shared.keyWindow?.rootViewController = viewController
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Email not verified", message: "Please verify your email try again", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    print(user)
                }
            }
        )
        }
    }
    
//       func googleLoginButtonClicked() -> Void
//    {
//        GIDSignIn.sharedInstance().signIn()
//        
//    }
//    
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
//    {
//        self.present(viewController, animated: true, completion: nil)
//        
//    }
//    
//    
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
//    {
//        self.dismiss(animated: true, completion: nil) // this will get called to dismiss "the presented google sign in view" after user successfully sign in
//        
//    }
//    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
//    {
//        
//    }
//    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
//    {
//        if (user != nil)
//        {
//            guard let authentication = user.authentication else { return }
//            let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                              accessToken: authentication.accessToken)
//            
//            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    
//                    return
//                }
//                
//                
//                
//                // Present the main view
//                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
//                    UIApplication.shared.keyWindow?.rootViewController = viewController
//                    self.dismiss(animated: true, completion: nil)
//                }
//                
//            })
//            
//            
//        }
//        
//    }

    
//    func fbLoginButtonClicked() -> Void
//    {
//        let fbLoginManager = FBSDKLoginManager()
//        
//                fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: {
//            
//            (result, error) -> Void in
//            if ((error) != nil)
//            {
//                // Process error
//                print("There were an error: \(error)")
//            }
//            else if (result?.isCancelled)! {
//                // Handle cancellations
//                fbLoginManager.logOut()
//            }
//            else
//            {
//
//                
//            
//                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//
//                
//               
//                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
//                    if let error = error {
//                        print("Login error: \(error.localizedDescription)")
//                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                        alertController.addAction(okayAction)
//                        self.present(alertController, animated: true, completion: nil)
//                        
//                        
//                        
//                        return
//                    }
    
                    
//                    FIRAuth.auth()?.currentUser?.link(with: credential)
//                    { (user, error) in
//                        
//                        // ...
//                        if let error = error
//                        {
//                            print("Login error: \(error.localizedDescription)")
//                            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            
//                            return
//                        }
//                        
//                        //  Present the main view
//                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
//                            UIApplication.shared.keyWindow?.rootViewController = viewController
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    }

                    // Present the main view
//                    
//                    UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: "fbAccessToken")
//
//                    self.showUserData()
//                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
//                        UIApplication.shared.keyWindow?.rootViewController = viewController
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                
//                })
//                
//            }
//            
//        })
//        
//    }

//    func showUserData() -> Void
//    {
//        
//        
//        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large), email, name, id, gender,timezone,friends"], tokenString: UserDefaults.standard.value(forKey: "fbAccessToken") as! String!, version: nil, httpMethod: "GET").start(completionHandler: {(connection, result, error) -> Void in
//            
//            if error != nil
//            {
//                print("error is \(error))")
//            }
//            else
//            {
//                print("userInfo is \(result))")
//                let userDict = result as! Dictionary<String, AnyObject>
//                let id = userDict["id"]
//                print("user id = \(id)")
//                
//            }
//            
//            
//        })
//        
//        
//        
//    }

    func keyboardWillShow()
    {
        // Animate the current view out of the way
        if self.view.frame.origin.y >= 0
        {
            
//            if passwordTextField.isFirstResponder
//            {
                setViewMovedUp(movedUp: true, localOffset: 145)
            //}
            
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
            setViewMovedUp(movedUp: false, localOffset: 145)
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
