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

class SignUpController: UIViewController {
    let service = LoginServices()
    
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var birthDateField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
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
        initViews()
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
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func didTapConfirmView(_ sender: Any) {
        confirmField.becomeFirstResponder()
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
        
        self.service.signUp(fullname: fullname, birthday: fBirthdate, gender: gender, password: password, confirmPassword: confirmPassword, phoneNumber: phoneNumber, email: email, completion: { (isSuccess,message) in
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

