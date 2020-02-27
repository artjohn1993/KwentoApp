//
//  ProfileController.swift
//  Kwento
//16

//  Created by Richtone Hangad on 01/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents
import CoreData

class ProfileController: UIViewController {
    let service = ProfileServices()
    var userInfo = [UserInfo]()
    let dataServices = CoreDataServices()
    let message = MDCSnackbarMessage()
    var isLocal = false
    var oldMobileValue = ""
    var oldEmailValue = ""
    @IBOutlet weak var navButton: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var loggedInStackView: UIStackView!
    @IBOutlet weak var loggedInViaText: UILabel!
    @IBOutlet weak var loggedInViaImage: UIImageView!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var saveButton: MDCFlatButton!
    @IBOutlet weak var logoutButton: MDCFlatButton!
    @IBOutlet var changePassword: UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    
    
    var mainNavigationController: MainNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
        getCurrentUser()
    }
    
    @IBAction func saveUpdate(_ sender: Any) {
        service.getCurrentUser(completion: { result in
            print(result)
            PublicData.spinnerAlert(controller: self)
            self.service.updateInfo(mobile: self.mobileField.text ?? "",
                               birthdate: result?["birthday"] as! String,
                               fullname: result?["full_name"] as! String,
                               email: self.emailField.text ?? "",
                               userId: result?["id"] as! Int,
                               completion: { result in
                                PublicData.removeSpinnerAlert(controller: self)
                                if result {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 , execute: {
                                        PublicData.showSnackBar(message: "Information were successfully updated")
                                        self.isSaveButton(checker: false)
                                        self.oldMobileValue = self.mobileField.text ?? ""
                                        self.oldEmailValue = self.emailField.text ?? ""
                                    })
                                }
                                else {
                                    self.message.text = "Invalid update"
                                    MDCSnackbarManager.show(self.message)
                                }

            })
        })
    }
    
    @IBAction func didTapNavButton(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        mainNavigationController.popViewController(animated: true)
        SelectedNav.item = .dashboard
    }
    
    @IBAction func logout(_ sender: Any) {
        service.logout(completion: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeController = storyboard.instantiateInitialViewController() as! LoginController
            self.present(homeController, animated: true)
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if oldMobileValue != mobileField.text || oldEmailValue != emailField.text {
            if mobileField.text != "" && emailField.text != "" {
                isSaveButton(checker: true)
            }
            else {
                 isSaveButton(checker: false)
            }
        }
        else {
            isSaveButton(checker: false)
        }
    }
    
    func isSaveButton(checker: Bool) {
        checker ? saveButton.setVisibility(true) : saveButton.setVisibility(false)
    }
    
    func getCurrentUser() {
        indicator.startAnimating()
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        
        service.getCurrentUser(completion: { result in
            print(result)
            self.indicator.stopAnimating()
            let provider = result?["providers"] as? [String]
            provider?.forEach({ item in
                if item == "Local" {
                    self.isLocal =  true
                    self.changePassword.setVisibility(true)
                }
            })
            
            if result != nil {
                self.mobileField.text = result?["phone_number"] as! String
                self.userFullname.text = result?["full_name"] as! String
                self.emailField.text = result?["email_address"] as! String
                self.oldEmailValue = result?["email_address"] as! String
                self.oldMobileValue = result?["phone_number"] as! String
            }
        })
    }
    
    @objc
    func changePasswordEvent(sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "changePassword", sender: nil)
    }
    
    private func initViews() {
        navButton.image = #imageLiteral(resourceName: "nav_button")
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        changePassword.setVisibility(false)
        
        saveButton.setVisibility(false)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changePasswordEvent))
        changePassword.isUserInteractionEnabled = true
        changePassword.addGestureRecognizer(tap)
        
        saveButton.initialize(backgroundColor: UIColor(rgb: 0xC5C5C5), titleColor: .white, cornerRadius: 4)
        logoutButton.initialize(backgroundColor: UIColor(red: 216/255, green: 154/255, blue: 135/255, alpha: 1), titleColor: .white, cornerRadius: 4)
        
        mobileField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

}
