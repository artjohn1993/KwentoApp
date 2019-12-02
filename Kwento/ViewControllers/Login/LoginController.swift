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

class LoginController: UIViewController {

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
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
     var loginService = LoginServices()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        emailField.text = "test2@gmail.com"
        passwordField.text = "password1234"
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
        
        headerView.addWave()
    }
    
      @IBAction func login(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            PublicData().showSpinner(onView: self.view)
            self.loginService.login(username: emailField.text ?? "", password: passwordField.text ?? "" , completion: { result in
                    if result {
                        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let homeController = storyboard.instantiateInitialViewController() as! KYDrawerController
                        self.present(homeController, animated: true)

                    }
                    else {
                        print("Login failed")
                    }
                    PublicData().removeSpinner()
                })
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

        @IBAction func forgotPassword() {
    //        performSegue(withIdentifier: "loginToForgotPassword", sender: nil)
        }
        
        @IBAction func signUp() {
            performSegue(withIdentifier: "loginToSignUp", sender: nil)
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
