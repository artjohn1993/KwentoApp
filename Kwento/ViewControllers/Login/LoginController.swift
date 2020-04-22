//
//  ViewController.swift
//  Kwento
//
//  Created by Richtone Hangad on 05/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents
import KYDrawerController
import CoreData
import Network
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginController: UIViewController, GIDSignInDelegate {
    
    

    

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var emailUnderline: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var passwordUnderline: UIView!
    
    @IBOutlet weak var loginbutton: MDCFlatButton!
    @IBOutlet weak var facebookButton: MDCFlatButton!
    @IBOutlet weak var googleButton: MDCFlatButton!
    
    @IBOutlet var forgetPassword: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
     var loginService = LoginServices()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var connectionService = ConnectionService()
    var isConnected = false
    var accessToken = ""
    
    var fullname = ""
    var email = ""
    var provider = ""
    var externalId = ""
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        emailField.text = ""
        passwordField.text = ""
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        
        connectionService.checkConnection(completion: { connection in
            self.isConnected = connection
        })
        
        if let accessToken = AccessToken.current {
            print("user is already login")
            print(AccessToken.current!.tokenString)
            print(AccessToken.current?.appID)
        }
        else {
            print("user need to login")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToSignUp" {
            if let destinationVC = segue.destination as? SignUpController {
                destinationVC.fullname = self.fullname
                destinationVC.email = self.email
                destinationVC.provider = self.provider
                destinationVC.externalId = self.externalId
                 destinationVC.token = self.token
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func initViews() {
        emailIcon.image = #imageLiteral(resourceName: "round_email_black_18pt").withRenderingMode(.alwaysTemplate)
        passwordIcon.image = #imageLiteral(resourceName: "round_lock_black_18pt").withRenderingMode(.alwaysTemplate)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        loginbutton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
        facebookButton.initialize(backgroundColor: .facebook, titleColor: .white, cornerRadius: 4)
        googleButton.initialize(backgroundColor: .google, titleColor: .white, cornerRadius: 4)
        
        let forgetPasswordGesture = UITapGestureRecognizer(target: self, action: #selector(forgetPasswordEvent))
        forgetPassword.isUserInteractionEnabled = true
        forgetPassword.addGestureRecognizer(forgetPasswordGesture)
        
        headerView.addWave()
    }
    
      @IBAction func login(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            login(uname: emailField.text ?? "", pass: passwordField.text ?? "", dataProvider: "local")
        }
        else {
            if emailField.text == "" {
                PublicData.showSnackBar(message: "Your email is required")
            }
            else if passwordField.text == "" {
                PublicData.showSnackBar(message: "Your password is required")
            }
            
        }

        }

        @objc
        func forgetPasswordEvent(sender:UITapGestureRecognizer) {
            performSegue(withIdentifier: "forgetPassword", sender: nil)
        }
        
        @IBAction func signUp() {
            self.provider = "local"
            performSegue(withIdentifier: "loginToSignUp", sender: nil)
        }
    
        @IBAction func loginWithFB(_ sender: Any) {
            let fbLoginManager : LoginManager = LoginManager()
            
            fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
              if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                        return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                  self.getFBUserData()
                }
              }
            }
        }
    
        @IBAction func loginWithGmail(_ sender: Any) {
            print("login gmail")
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().signIn()
        }
     
        //MARK:- Google Delegate
        func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {

        }

        func sign(_ signIn: GIDSignIn!,
                  present viewController: UIViewController!) {
            self.present(viewController, animated: true, completion: nil)
        }
    
        public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                           withError error: Error!) {
            if (error == nil) {
                // Perform any operations on signed in user here.
                let userId = user.userID                  // For client-side use only!
                let idToken = user.authentication.idToken // Safe to send to the server
                let fullName = user.profile.name
                let givenName = user.profile.givenName
                let familyName = user.profile.familyName
                let email = user.profile.email
                
                print(userId!)
                print(idToken!)
                print(fullName!)
                print(email!)
                print("====================DATA FROM GMAIL=====================")
                self.fullname = fullName!
                self.email = email!
                self.provider = "Google"
                self.externalId = userId!
                self.token = idToken!
                
                self.loginService.checkExternalId(id: self.externalId, completion: { result in
                    if result == 1 {
                        self.login(uname: self.externalId, pass: self.token, dataProvider: "Google")
                    }
                    else {
                        self.performSegue(withIdentifier: "loginToSignUp", sender: nil)
                    }
                })
                // ...
            } else {
                print("\(error)")
            }
        }
              

    
        @objc private func presentExampleController() {
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let homeController = storyboard.instantiateInitialViewController() as! KYDrawerController
            self.present(homeController, animated: true)
        }
    
        func login(uname: String, pass :String, dataProvider: String) {
            self.loginService.login(username: uname, password: pass ,provider : dataProvider, completion: { result in
                    if result {
                        self.perform(#selector(self.presentExampleController), with: nil, afterDelay: 0)
                    }
                        
                    else {
                        print("Login failed")
                    }
                
                    PublicData.removeSpinnerAlert(controller: self)
                })
        }
    
        func getFBUserData() {
            PublicData.spinnerAlert(controller: self)
            if((AccessToken.current) != nil) {
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                  if (error == nil) {
                    //everything works print the user data
                    let data = result as? [String:Any]

                    self.fullname = data?["name"] as! String
                    self.email = data?["email"] as! String
                    self.provider = "Facebook"
                    self.externalId = data?["id"] as! String
                    self.token = AccessToken.current!.tokenString
                    
                    self.loginService.checkExternalId(id: self.externalId, completion: { result in
                        if result == 1 {
                            self.login(uname: self.externalId, pass: AccessToken.current!.tokenString, dataProvider: "Facebook")
                        }
                        else {
                            PublicData.removeSpinnerAlert(controller: self)
                            self.performSegue(withIdentifier: "loginToSignUp", sender: nil)
                        }
                    })
                  }
                    
                  else { PublicData.removeSpinnerAlert(controller: self) }
            })
          }
        
            else { PublicData.removeSpinnerAlert(controller: self) }
        }
}

    extension LoginController: UITextFieldDelegate {
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            switch textField {
            case emailField:
                emailIcon.tintColor = .mainDark
                emailUnderline.backgroundColor = .mainDark
                break
            case passwordField:
                passwordIcon.tintColor = .mainDark
                passwordUnderline.backgroundColor = .mainDark
                break
            default:
                break
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            switch textField {
            case emailField:
                emailIcon.tintColor = .lightGray
                emailUnderline.backgroundColor = .lightGray
                break
            case passwordField:
                passwordIcon.tintColor = .lightGray
                passwordUnderline.backgroundColor = .lightGray
                break
            default:
                break
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            switch textField {
            case emailField:
                return passwordField.becomeFirstResponder()
            case passwordField:
                return passwordField.resignFirstResponder()
            default:
                return true
            }
        }
        
        
        
    }
