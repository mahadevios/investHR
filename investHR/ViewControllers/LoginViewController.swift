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

import FBSDKLoginKit

import Firebase

import FirebaseAnalytics

import LinkedinSwift

import IOSLinkedInAPIFix

class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {

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
        
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        //
        //
        //            return
        //        }        // Do any additional setup after loading the view, typically from a nib.
        
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        // let obj2 = CoreDataManager.getSharedCoreDataManager()
        
        let manageObjectContext = AppDelegate().getManageObjectContext()
        
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
        
        
        let result : [String: Any] = ["firstName" : "Steve", "surName" : "Jobs"]
        
        //let obj = coreDataManager.save(entity: "User", result)
        
        //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        //        do
        //        {
        //            let manageObject = try manageObjectContext.fetch(fetchRequest)
        
//        let managedObjects = coreDataManager.fetch(entity: "User")
//        for userObject in managedObjects as! [User]
//        {
//            let firstName = userObject.firstName
//            let lastName = userObject.surName
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
        
        //        } catch let error as NSError
        //        {
        //            print(error.localizedDescription)
        //        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        emailTextField.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
//        emailTextField.leftViewMode = UITextFieldViewMode.always;
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 7, width: 15, height: 20))
        let image = UIImage(named: "Username")
        imageView.image = image
        
        emailTextField.addSubview(imageView)
        
//        emailTextField.leftView = UIImageView.init(image: UIImage(named:"Username"))
        
        passwordTextField.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        let imageView1 = UIImageView(frame: CGRect(x: 15, y: 6, width: 16, height: 21))
        let image1 = UIImage(named: "Password")
        imageView1.image = image1
        
        passwordTextField.addSubview(imageView1)
//        passwordTextField.leftViewMode = UITextFieldViewMode.always;
//        
//        passwordTextField.leftView = UIImageView.init(image: UIImage(named:"Password"))
    }

    @IBAction func fbLoginButtonClicked(_ sender: Any)
    {
        self.fbLoginButtonClicked()
    }
    
    @IBAction func googleLoginButtonClicked(_ sender: Any)
    {
        self.googleLoginButtonClicked()
    }
    @IBAction func linkedInLoginButtonClicked(_ sender: Any)
    {
        
        
        
//        self.loadAccount(then: { () in
//            
//            print("cancel pressed")
//        }, or: nil)
        
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
        
        let performFetch:() -> Void = { parameter in
        
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,headline,email-address,picture-urls::(original))?format=json",
                                                           success: {
                                                            response in
                                                            print(response?.data ?? "hh")
                                                            then?()
                },
                                                           error: {
                                                            error in
                                                            print(error ?? "kk")
                                                            or?("error")
                }
                )
            }
        
        }
        
        
        let serializedToken = UserDefaults.standard.value(forKey: Constant.LINKEDIN_ACCESS_TOKEN) as! String
        
        if serializedToken.characters.count > 0
        {
            let accessToken = LISDKAccessToken.init(serializedString: serializedToken)
            
            if (accessToken?.expiration)! > Date()
            {
               LISDKSessionManager.createSession(with: accessToken)
                
                performFetch()
            }
        }
            
        else
        {
    
            LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true,
                                              successBlock:
                                                {
                                                    (state) in
                                                    performFetch()
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
    
//    @IBAction func signUpButtonClicked(_ sender: Any)
//    {
//        if emailTextField.text == "" || passwordTextField.text == ""
//        {
//            let alertController = UIAlertController(title: "Login Error", message: "Please enter valid credentials", preferredStyle: .alert)
//            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(okayAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        else
//        {
//            FIRAuth.auth()?.createUser(withEmail:emailTextField.text!, password: passwordTextField.text!) { (user, error) in
//                if let error = error
//                {
//                    if let errCode = FIRAuthErrorCode(rawValue: error._code)
//                    {
//                        switch errCode
//                        {
//                        case .errorCodeEmailAlreadyInUse:
//                            let alertController = UIAlertController(title: "Login Error", message: "The email is already in use with another account", preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            break
//                            
//                        case .errorCodeUserDisabled:
//                            let alertController = UIAlertController(title: "Login Error", message: "Your account has been disabled. Please contact support.", preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            break
//                            
//                            
//                        case .errorCodeInvalidEmail, .errorCodeInvalidSender, .errorCodeInvalidRecipientEmail:
//                            let alertController = UIAlertController(title: "Login Error", message: "Please enter a valid email", preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            break
//                            
//                        case .errorCodeNetworkError:
//                            let alertController = UIAlertController(title: "Login Error", message: "Network error. Please try again.", preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            break
//                            
//                        case .errorCodeWeakPassword:
//                            let alertController = UIAlertController(title: "Login Error", message: "Your password is too weak", preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            break
//                            
//                            
//                        default:
//                            let alertController = UIAlertController(title: "Login Error", message: "Unknown error occurred, please try again", preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            break
//                        }
//                        print(error.localizedDescription)
//                    }
//                    
//                }
//                else if let user = user
//                {
//                    user.sendEmailVerification { (error) in
//                        // ...
//                        
//                        print("email sent")
//                    }
//                    let alertController = UIAlertController(title: "Verify email", message: "We have sent verification mail to \(self.emailTextField.text!), please verify your email and login again", preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//
//                    print(user)
//                }
//            }
//            
//        }
//
//    }
   
   
    
//    @IBAction func fbLoginButtonClicked(_ sender: Any)
//    {
//       // self.fbLoginButtonClicked()
//    }

       func googleLoginButtonClicked() -> Void
    {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
    {
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil) // this will get called to dismiss "the presented google sign in view" after user successfully sign in
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
    {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (user != nil)
        {
            guard let authentication = user.authentication else { return }
            let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                              accessToken: authentication.accessToken)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
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

                    
                    return
                }
                
                
                
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
            
//            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
//                if let error = error
//                {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    return
//                }
//                
//               //  Present the main view
//                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
//                    UIApplication.shared.keyWindow?.rootViewController = viewController
//                    self.dismiss(animated: true, completion: nil)
//                }
//                
//            })
            
        }
        
    }

    
    func fbLoginButtonClicked() -> Void
    {
        let fbLoginManager = FBSDKLoginManager()
        
        //        fbLoginManager.logIn(withPublishPermissions: ["publish_actions"], from: self, handler: {
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
        //                let fbloginresult : FBSDKLoginManagerLoginResult = result!
        //                if(fbloginresult.grantedPermissions.contains("publish_actions"))
        //                {
        //                    print(fbloginresult)
        //                    print( "tokenString is \(FBSDKAccessToken.current().tokenString)")
        //
        //                    self.showUserData()
        //                }
        //            }
        //
        //        })
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: {
            
            (result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                print("There were an error: \(error)")
            }
            else if (result?.isCancelled)! {
                // Handle cancellations
                fbLoginManager.logOut()
            }
            else
            {
//                let fbloginresult : FBSDKLoginManagerLoginResult = result!
//                if(fbloginresult.grantedPermissions.contains("email"))
//                {
//                    print(fbloginresult)
//                    print( "tokenString is \(FBSDKAccessToken.current().tokenString)")
//                    
//                    UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: "fbAccessToken")
//                    self.showUserData()
//                }
                
            
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                
               
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
//                        FIRAuth.auth()?.currentUser?.link(with: credential)
//                        { (user, error) in
//                        
//                                                // ...
//                           if let error = error
//                            {
//                                    print("Login error: \(error.localizedDescription)")
//                                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                                                    alertController.addAction(okayAction)
//                                    self.present(alertController, animated: true, completion: nil)
//                        
//                                    return
//                            }
//                        
//                                                //  Present the main view
//                            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
//                            UIApplication.shared.keyWindow?.rootViewController = viewController
//                            self.dismiss(animated: true, completion: nil)
//                                
//                            }
//                            
//                        }
                        
                        
                        
                        return
                    }
                    
                    
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
                    
                    UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: "fbAccessToken")

                    self.showUserData()
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                
                })
                
            }
            
        })
        
    }

    func showUserData() -> Void
    {
        
        //        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large), email, name, id, gender,timezone,friends"]).start(completionHandler: {(connection, result, error) -> Void in
        //            if error != nil{
        //                print("error is \(error))")
        //
        //
        //            }else{
        //
        //
        //                print("userInfo is \(result))")
        //
        //            }
        //        })
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large), email, name, id, gender,timezone,friends"], tokenString: UserDefaults.standard.value(forKey: "fbAccessToken") as! String!, version: nil, httpMethod: "GET").start(completionHandler: {(connection, result, error) -> Void in
            
            if error != nil{
                print("error is \(error))")
                
                
            }else{
                
               // result.valueForKey("id") as! NSString
                
                
                print("userInfo is \(result))")
                let userDict = result as! Dictionary<String, AnyObject>

                let id = userDict["id"]
                print("user id = \(id)")
                
//                for (key, value) in userDict
//                {
//                    
//                    print("\(key) -> \(value)")
//                }
//                for ob in userDict
//                {
//                  
//                }
            }
            
            
        })
        
        
        
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
