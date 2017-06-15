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


import SafariServices

import Firebase

import FirebaseAnalytics

import Auth0


//import LinkedinSwift

//import IOSLinkedInAPIFix

class LoginViewController: UIViewController,UITextFieldDelegate,UIWebViewDelegate
{
    
    // params
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    let linkedInKey = "81no6kz3uepufn"
    
    let linkedInSecret = "tgGDfootCo2zoLwB"
    
    @IBOutlet weak var googleSignInCircleButton: UIButton!
    
    @IBOutlet weak var fbCircleLoginButton: UIButton!
    
    @IBOutlet weak var linkedInLoginCircleButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var accesToken:LISDKAccessToken?
    
    @IBAction func forgotPasswordButtonClicked(_ sender: Any)
    {
        //APIManager.getSharedAPIManager().logoutFromLinkedIn(accesTOken: "ds")
        
        //SessionManager.shared.logout()
        //self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func registerUserButtonClicked(_ sender: Any)
    {
       //let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController

        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "NavigationController")
        
        self.present(viewController!, animated: true, completion: nil)
        
//        let auth = HybridAuth()
//        
//        
//        auth.showLogin(withScope: "openid profile", connection: "linkedin") { (error, cred) in
//            
//            DispatchQueue.main.async
//                {
//                    if let error = error
//                    {
//                        print(error)
//                    }
//                    else
//                    {
//                        let accesTOken = cred?.accessToken
//                        
//                        print(cred)
//                        
//                        auth.userInfo(accessToken: accesTOken!, callback: { (error, profile) in
//                            
//                            print(profile)
//                        })
//                    
//                    }
//            }
//            
//        }
        
        
//        Auth0
//            .webAuth()
//            .scope("openid profile offline_access")
//            .connection("linkedin")
//            .start {
//                switch $0 {
//                case .failure(let error):
//                    // Handle the error
//                    print("Error: \(error)")
//                case .success(let credentials):
//                    guard let accessToken = credentials.accessToken, let refreshToken = credentials.refreshToken else { return }
//                    SessionManager.shared.storeTokens(accessToken, refreshToken: refreshToken)
//                    SessionManager.shared.retrieveProfile { error in
////                        DispatchQueue.main.async {
////                            self.performSegue(withIdentifier: "ShowProfileNonAnimated", sender: nil)
////                        }
//                    }
//                }
//        }

        
        
        
        
      //  com.xanadutec.investHR://investhr.auth0.com/ios/com.xanadutec.investHR/callback
        
             
       
        
    }
    
       
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return
        }
        
        let managedObjectContext1 = appDelegate.managedObjectContext
//
//        let entity1 = NSEntityDescription.entity(forEntityName: "City", in: managedObjectContext)!
//
//        let cityObject = NSManagedObject(entity: entity1, insertInto: managedObjectContext) as! City
//
//        
//        
//        
//        cityObject.id = 1
//        cityObject.cityName = "Pune"
//        cityObject.stateId = 1
//        //userObject.setValue("ABC", forKey: "firstName")
//       // userObject.setValue("XYZ", forKey: "lastName")
//        
//                do {
//                    try managedObjectContext.save()
//        
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
        
        
       // let result : [String: Any] = ["firstName" : "Steve", "surName" : "Jobs"]
        
//        let obj = coreDataManager.save(entity: "User", result)
//        
//        let entityName = "City"
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
//        
//                do
//                {
//                    let manageObject = try managedObjectContext.fetch(fetchRequest)
//                    var managedObjects:[NSManagedObject]?
//                    
//        managedObjects = CoreDataManager.sharedManager.fetch(entity: entityName)
//        for userObject in managedObjects as! [City]
//        {
//            let firstName = userObject.id
//            let lastName = userObject.cityName
//            let stateId = userObject.stateId
//
//            print(firstName ?? "nil")
//            
//            guard let lastname = lastName else
//            {
//                print("nnil value")
//                continue
//            }
//            print(lastname)
//            print(stateId)
//
//        }
//        
//                } catch let error as NSError
//                {
//                    print(error.localizedDescription)
//                }
        
        
        // Do any additional setup after loading the view.
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(fetchUserProfile(dataDictionary:)), name: NSNotification.Name(rawValue: Constant.NOTIFICATION_LIACCESSTOKEN_FETCHED), object: [String:AnyObject]())
//       NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.fetchUserProfile(dataDictionary:)), name: NSNotification.Name(Constant.NOTIFICATION_LIACCESSTOKEN_FETCHED), object: nil)
//
//        let context = appDelegate.managedObjectContext
        print("finished")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        self.checkForAvailableLinkedInSession()
        
        emailTextField.layer.borderColor = UIColor.init(colorLiteralRed: 196/255.0, green: 204/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.fetchUserProfile(dataDictionary:)), name: NSNotification.Name(Constant.NOTIFICATION_LIACCESSTOKEN_FETCHED), object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        //NotificationCenter.default.removeObserver(self)
    }

    func fetchUserProfile(dataDictionary:NSNotification)
    {
        // Convert the received JSON data into a dictionary.
        do {
            
            //                let dataDictionary = try JSONSerialization.jsonObject(with: responseData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
            let dic = dataDictionary.object as! [String:AnyObject]
            let accessToken = dic["access_token"]
            
            print(dataDictionary)
            print(accessToken ?? "")
            
            UserDefaults.standard.set(accessToken, forKey: Constant.LINKEDIN_ACCESS_TOKEN)
            UserDefaults.standard.synchronize()
            
            
            if let accessToken = UserDefaults.standard.object(forKey: Constant.LINKEDIN_ACCESS_TOKEN)
            {
                // Specify the URL string that we'll get the profile info from.
                let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url,id,first-name,last-name,maiden-name,headline,email-address,picture-urls::(original))?format=json"
                
                let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
                
                request.httpMethod = "GET"
                
                request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                
                let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    
                    if statusCode == 200
                    {
                        // Convert the received JSON data into a dictionary.
                        do {
                            let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                            
                            DispatchQueue.main.async
                                {
                                    let userId = dataDictionary["id"]
                                    
                                    // let idExist = CoreDataManager.sharedManager.idExists(aToken: userId as! String, entityName: "User")
                                    let coreDataManager = CoreDataManager.getSharedCoreDataManager()
                                    //                                                                        if idExist
                                    //                                                                        {
                                    //
                                    //                                                                        }
                                    //                                                                        else
                                    //                                                                        {
                                    let firstName = dataDictionary["firstName"]
                                    
                                    let lastName = dataDictionary["lastName"]
                                    
                                    let occupation = dataDictionary["headline"]
                                    
                                    let emailAddress = dataDictionary["emailAddress"]
                                    
                                    let pictureUrlsJson = dataDictionary["pictureUrls"] as! [String:AnyObject]
                                    
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
                                    CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
                                    let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "User", ["firstName":firstName ?? "nil","lastName":lastName ?? "nil","userId":userId ?? "nil","occupation":occupation ?? "nil","emailAddress":emailAddress ?? "nil","pictureUrl":pictureUrlString])
                                    
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
                                        NotificationCenter.default.post(name: NSNotification.Name(Constant.NOTIFICATION_NEW_USER_LOGGED_IN), object: nil, userInfo: nil)

                                    }
                                    
                            }
                            
                        }
                        catch {
                            print("Could not convert JSON data into a dictionary.")
                        }
                    }
                    else
                    {
                        do {
                            let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                            
                            let profileURLString = dataDictionary["publicProfileUrl"] as! String
                            
                            print(profileURLString)
                        }
                        catch {
                            print("Could not convert JSON data into a dictionary.")
                        }
                    }
                    
                    
                }
                
                task.resume()
            }
        }
        catch {
            print("Could not convert JSON data into a dictionary.")
        }
    }
    
    func showData() -> Void
    {
        let coreDataManager = CoreDataManager.getSharedCoreDataManager()
        
        let managedObjectContext = AppDelegate().managedObjectContext
        
        //let obj = coreDataManager.save(entity: "User", result)
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
//        
//        do
//        {
//            let manageObject = try managedObjectContext.fetch(fetchRequest)
//            var managedObjects:[NSManagedObject]?
//            
//            managedObjects = coreDataManager.fetch(entity: "User")
//            for userObject in managedObjects as! [User]
//            {
//                let firstName = userObject.firstName
//                let lastName = userObject.lastName
//                
//                print(firstName ?? "nil")
//                
//                guard let lastname = lastName else
//                {
//                    print("nnil value")
//                    continue
//                }
//                print(lastname)
//            }
//            
//        } catch let error as NSError
//        {
//            print(error.localizedDescription)
//        }

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
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LinkedInLoginViewController")
//        
//        self.present(vc!, animated: true, completion: nil)
        
        showWebView()

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
                                                                        CoreDataManager.getSharedCoreDataManager().deleteAllRecords(entity: "User")
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
                                                                            let managedObject = CoreDataManager.getSharedCoreDataManager().save(entity: "User", ["firstName":firstName ?? "nil","lastName":lastName ?? "nil","userId":userId ?? "nil","occupation":occupation ?? "nil","emailAddress":emailAddress ?? "nil","pictureUrl":pictureUrlString])
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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        return true
    }

    func getStateAndCityUsingWebService()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return
        }        // Do any additional setup after loading the view, typically from a nib.
        
        // let coreDataManager = CoreDataManager.sharedManager
        //let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        
        let managedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "State", in: managedObjectContext)!
        
        let entity1 = NSEntityDescription.entity(forEntityName: "City", in: managedObjectContext)!
        
        // Specify the URL string that we'll get the profile info from.
        let targetURLString = "http://192.168.3.74:9090/coreflex/StateCity"
        
        let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
        
        // Indicate that this is a GET request.
        request.httpMethod = "POST"
        
        // Add the access token as an HTTP header field.
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200
            {
                // Convert the received JSON data into a dictionary.
                do
                {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    
                    let stateString = dataDictionary["State"] as! String
                    
                    let stateData = stateString.data(using: .utf8, allowLossyConversion: true)
                    
                    let stateArray =  try JSONSerialization.jsonObject(with: stateData as Data!, options: .allowFragments) as! [AnyObject]
                    
                    for index in 0 ..< stateArray.count
                    {
                        let stateIdAndNameDic = stateArray[index] as! [String:AnyObject]
                        
                        let stateId = stateIdAndNameDic["id"] as! Int
                        
                        let stateName = stateIdAndNameDic["state_Name"] as! String
                        
                        let stateObject = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! State
                        
                        stateObject.id = Int16(stateId)
                        
                        stateObject.stateName = stateName
                        
                        do {
                            print("inserting state num:",(index))
                            
                            try managedObjectContext.save()
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                    
                    
                    let stateCityString = dataDictionary["StateCity"] as! String
                    
                    let stateCityData = stateCityString.data(using: .utf8, allowLossyConversion: true)
                    
                    let stateCityArray =  try JSONSerialization.jsonObject(with: stateCityData as Data!, options: .allowFragments) as! [AnyObject]
                    
                    for index in 0 ..< stateCityArray.count
                    {
                        let stateCityIdAndNameDic = stateCityArray[index] as! [String:AnyObject]
                        
                        let cityId = stateCityIdAndNameDic["id"] as! Int
                        
                        let cityName = stateCityIdAndNameDic["city_Name"] as! String
                        
                        let stateIdNameDic = stateCityIdAndNameDic["state"] as! [String:AnyObject]
                        
                        let stateId = stateIdNameDic["id"] as! Int
                        
                        //let stateName = stateIdNameDic["state_Name"]
                        
                        let cityObject = NSManagedObject(entity: entity1, insertInto: managedObjectContext) as! City
                        
                        cityObject.id = Int64(cityId)
                        
                        cityObject.stateId = Int16(stateId)
                        
                        cityObject.cityName = cityName
                        
                        do {
                            try managedObjectContext.save()
                            
                            print("inserting city num:",(index))
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                    
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
            }
            else
            {
                print(error?.localizedDescription)
            }
            
            
        }
        
        task.resume()
        
    }

    
    func showWebView() -> Void
    {
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        
        let responseType = "code"
        
        let clientId = responseType
        
        var redirectUrl = "https://www.example.com"
        //var redirectUrl = "https://www.investhr.auth0.com/ios/com.xanadutec.investHR/callback"
        let scope = "r_basicprofile,r_emailaddress"
        
        
        
        
        redirectUrl = redirectUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!
        
        let authUrl = "https://www.linkedin.com/oauth/v2/authorization?scope=\(scope)%20r_emailaddress&redirect_uri=\(redirectUrl)&client_id=81no6kz3uepufn&state=\(state)&responseType=\(responseType)"
        
        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectUrl)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print("1=",authorizationURL)
        print("2=",authUrl)
        
        //        let authUrl = "https://www.linkedin.com/oauth/v2/authorization?response_type=code&redirect_uri=http%3A%2F%2Fwww.example.com%2Fauth%2Flinkedin&state=987654321&scope=r_basicprofile&client_id=F27W4sBvOjnfRKXZNGiL2V18uttDvQZu"
        //https://investhr.auth0.com/ios/com.xanadutec.investHR/callback
        
        
        //
        
        let linkedInLoginView = UIView(frame: self.view.bounds)

        linkedInLoginView.tag = 1000
        
        let cancelLinkedInViewButton = UIButton(frame: CGRect(x:linkedInLoginView.frame.origin.x , y: linkedInLoginView.frame.origin.y+10, width: 30, height: 20))
        
        cancelLinkedInViewButton.addTarget(self, action: #selector(cancelLinkedInViewButtonClicked), for: .touchUpInside)
        
        let webView = UIWebView(frame: CGRect(x:linkedInLoginView.frame.origin.x , y: linkedInLoginView.frame.origin.y+40, width: linkedInLoginView.frame.size.width, height: linkedInLoginView.frame.size.height-40))
        
        linkedInLoginView.addSubview(cancelLinkedInViewButton)
        linkedInLoginView.addSubview(webView)
        
        webView.delegate = self
        
        webView.loadRequest(NSURLRequest(url: NSURL(string: authorizationURL) as! URL) as URLRequest)
        
        self.view.addSubview(linkedInLoginView)
        
        
        
    }
    
    func cancelLinkedInViewButtonClicked()
    {
      self.view.viewWithTag(1000)?.removeFromSuperview()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        let url = request.url!
        print(url)
        
        if url.host == "www.example.com"
        {
            if url.absoluteString.range(of: "code") != nil
            {
                // Extract the authorization code.
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let code = (urlParts[1].components(separatedBy:"=")[1]).components(separatedBy: "&")[0]
                
                requestForAccessToken(authorizationCode: code)
                
                //self.dismiss(animated: true, completion: nil)
            }
            else
            {
                //self.dismiss(animated: true, completion: nil)
                cancelLinkedInViewButtonClicked()
            }
        }
        
        return true
    }
    
    func requestForAccessToken(authorizationCode: String)
    {
        let grantType = "authorization_code"
        
        let redirectURL = "https://www.example.com".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)
        // }
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL!)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        //let params = ["grant_type=\(grantType)&","code=\(authorizationCode)&","redirect_uri=\(redirectURL!)&","client_id=\(linkedInKey)&","client_secret=\(linkedInSecret)"]
        
        //let dic = [Constant.REQUEST_PARAMETER:params]
        
       // let downloadmetadatajob = DownloadMetaDataJob().initWithdownLoadEntityJobName(jobName: Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API, withRequestParameter: dic as AnyObject, withResourcePath: Constant.LINKEDIN_ACCESS_TOKEN_ENDPOINT_API, withHttpMethd: Constant.POST)
        
        //downloadmetadatajob.startMetaDataDownLoad()
        
         APIManager.getSharedAPIManager().getLinkedInAccessToken(grant_type: grantType, code: authorizationCode, redirect_uri: redirectURL!, client_id: linkedInKey, client_secret: linkedInSecret)
        
        cancelLinkedInViewButtonClicked()
        
        //self.hud().show(animated: true)
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hud.tag = 789
        
        hud.minSize = CGSize(width: 150.0, height: 100.0)
        
        hud.label.text = "Logging in.."
        
        hud.detailsLabel.text = "Please wait"
        
       
        //
        
    }
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        print(error)
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
