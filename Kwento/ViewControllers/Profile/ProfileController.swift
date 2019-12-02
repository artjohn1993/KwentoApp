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
            self.service.updateInfo(mobile: self.mobileField.text ?? "",
                               birthdate: result?["Birthday"] as! String,
                               fullname: result?["FullName"] as! String,
                               email: self.emailField.text ?? "",
                               pasword: self.passwordField.text ?? "",
                               confirm: self.confirmField.text ?? "",
                               userId: result?["Id"] as! Int,
                               completion: { result in
                                
                                if result {
                                    self.message.text = "Information were successfully updated"
                                    MDCSnackbarManager.show(self.message)
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
    }
    
    func getCurrentUser() {
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        
        service.getCurrentUser(completion: { result in
            print(result)
            if result != nil {
                self.mobileField.text = result?["phone_number"] as! String
                self.userFullname.text = result?["full_name"] as! String
                self.emailField.text = result?["email_address"] as! String
                self.passwordField.text = self.userInfo[0].password
                //self.passwordField.text =
            }
        })
    }
    
    private func initViews() {
        navButton.image = #imageLiteral(resourceName: "nav_button")
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        
        saveButton.initialize(backgroundColor: UIColor(rgb: 0xC5C5C5), titleColor: .white, cornerRadius: 4)
        logoutButton.initialize(backgroundColor: UIColor(red: 216/255, green: 154/255, blue: 135/255, alpha: 1), titleColor: .white, cornerRadius: 4)
    }

}
