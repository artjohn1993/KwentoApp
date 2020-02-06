//
//  SignUpController.swift
//  Kwento
//
//  Created by Richtone Hangad on 23/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents
import MaterialComponents.MaterialSnackbar
import Network
import MaterialComponents.MaterialTextFields
import KYDrawerController
class SignUpController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let service = LoginServices()
    let connectionService = ConnectionService()
    var isConnected = false
    
    let pickerView = UIPickerView()
    let gender = ["Male", "Female"]
    
    var fullname = ""
    var email = ""
    var provider = ""
    var externalId = ""
    var token = ""
    
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var birthDateField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var passwordText: UILabel!
    @IBOutlet var passwordLine: UIView!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet var confirmLine: UIView!
    @IBOutlet var confirmText: UILabel!
    
    @IBOutlet weak var signUpButton: MDCFlatButton!
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var formTopMargin: NSLayoutConstraint!
    @IBOutlet weak var buttonTopMargin: NSLayoutConstraint!
    @IBOutlet var textFieldMargin: [NSLayoutConstraint]!
    
    let width = UIScreen.main.bounds.size.width
    let isIphoneX = UIApplication.shared.statusBarFrame.size.height > 40
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.genderField.inputView = pickerView
        
        checkProvider(provider: provider)
        initViews()
        connectionService.checkConnection(completion: { connection in
            self.isConnected = connection
        })
        
        if provider != "local" {
            self.passwordField.isEnabled = false
            self.confirmField.isEnabled = false
            self.passwordText.textColor = UIColor.lightGray
            self.confirmText.textColor = UIColor.lightGray
            self.confirmLine.backgroundColor = UIColor.lightGray
            self.passwordLine.backgroundColor = UIColor.lightGray
        }
        else {
            self.passwordField.isEnabled = true
            self.confirmField.isEnabled = true
        }
    }

    func checkProvider(provider : String) {
        if provider != "local" {
            fullNameField.text = fullname
            emailField.text = email   
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapBirthday(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @IBAction func didTapFullname(_ sender: Any) {
        
    }
    
    @IBAction func didTapBirthdayView(_ sender: Any) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        birthDateField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @IBAction func didTapGenderView(_ sender: Any) {
        
    }
    
    @IBAction func didTapMobileView(_ sender: Any) {
        mobileField.becomeFirstResponder()
    }
    
    @IBAction func didTapEmailView(_ sender: Any) {
        emailField.becomeFirstResponder()
    }
    
    @IBAction func didTapPasswordView(_ sender: Any) {
        print("didTapPasswordView")
        self.passwordField.becomeFirstResponder()
    }
    
    @IBAction func didTapConfirmView(_ sender: Any) {
        print("didTapConfirmView")
        self.confirmField.becomeFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = gender[row]
        genderField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    @IBAction func signUp(_ sender: MDCFlatButton) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let fullname: String = String(fullNameField.text ?? "")
        let iBirthdate: String = String(birthDateField.text ?? "")
        let fBirthdate: String = iBirthdate + formatter.string(from: date)
        let gender: String = String(genderField.text ?? "")
        let password: String = String(passwordField.text ?? "")
        let confirmPassword: String = String(confirmField.text ?? "")
        let phoneNumber: String = String(mobileField.text ?? "")
        let email: String = String(emailField.text ?? "")
        
        if isConnected {
            if fullname != "" && iBirthdate != "" && gender != "" && phoneNumber != "" && email != "" {
                if provider == "local" {
                    if password != "" && confirmPassword != "" {
                        if password == confirmPassword {
                            self.service.signUp(fullname: fullname, birthday: fBirthdate, gender: gender, password: password, confirmPassword: confirmPassword, phoneNumber: phoneNumber, email: email,provider : provider,externalId : externalId,  token : token, completion: { (isSuccess,message) in
                                if isSuccess {
                                    self.performSegue(withIdentifier: "signUpToVerification", sender: nil)
                                }
                                else {
                                    if message != nil || message != ""{
                                        PublicData.showSnackBar(message: message)
                                    }
                                    print(message)
                                }
                            })
                        }
                        else {
                            PublicData.showSnackBar(message: "Invalid confirm password")
                        }
                    }
                    else {
                        PublicData.showSnackBar(message: "Please complete all required fields")
                    }
                }
                else {
                    self.service.signUp(fullname: fullname, birthday: fBirthdate, gender: gender, password: password, confirmPassword: confirmPassword, phoneNumber: phoneNumber, email: email,provider : provider,externalId : externalId,  token : token, completion: { (isSuccess,message) in
                        if isSuccess {
                            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                            let homeController = storyboard.instantiateInitialViewController() as! KYDrawerController
                            self.present(homeController, animated: true)
                        }
                        else {
                            if message != nil || message != ""{
                                PublicData.showSnackBar(message: message)
                            }
                            print(message)
                        }
                    })
                }
            }
            else  {
                PublicData.showSnackBar(message: "Please complete all required fields")
            }
        }
        else {
            PublicData.showSnackBar(message: "Not Connected")
        }
       
//        performSegue(withIdentifier: "signUpToVerification", sender: nil)
    }
    
    @IBAction func didTapPrivacyPolicy(_ sender: Any) {
        performSegue(withIdentifier: "signUpToPrivacyPolicy", sender: nil)
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthDateField.text = dateFormatter.string(from: sender.date)
//        genderField.becomeFirstResponder()
    }
    
    private func initViews() {
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.setBackgroundColor(.main, for: .normal)
        signUpButton.layer.cornerRadius = 4
    }

}

extension SignUpController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameField:
            return birthDateField.becomeFirstResponder()
        case mobileField:
            return emailField.becomeFirstResponder()
        case emailField:
            return passwordField.becomeFirstResponder()
        case passwordField:
            return confirmField.becomeFirstResponder()
        case confirmField:
            return confirmField.resignFirstResponder()
        default:
            return true
        }
    }
    
}

