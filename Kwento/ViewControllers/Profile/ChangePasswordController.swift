//
//  ChangePasswordController.swift
//  Kwento
//
//  Created by Art John on 27/01/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class ChangePasswordController: UIViewController {
    @IBOutlet var saveButton: MDCFlatButton!
    
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var oldPassword: UITextField!
    @IBOutlet var navButton: UIImageView!
    @IBOutlet var closeButton: UIImageView!
    var mainNavigationController: MainNavigationController!
    let profileService = ProfileServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        mainNavigationController = navigationController as? MainNavigationController
    }
    
    @objc
    func navEvent(sender:UITapGestureRecognizer) {
        mainNavigationController.setDrawerState()
    }
    
    @objc
    func closeEvent(sender:UITapGestureRecognizer) {
        mainNavigationController.popViewController(animated: true)
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        if oldPassword.text != "" && newPassword.text != "" && confirmPassword.text != "" {
            if newPassword == confirmPassword {
                profileService.changePassword(newpass: newPassword.text ?? "",
                                              oldpass: oldPassword.text ?? "",
                                              confirmpass: confirmPassword.text ?? "", completion: { response in
                                         
                                                if response {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 , execute: {
                                                        PublicData.showSnackBar(message: "Password Changed")
                                                        self.oldPassword.text = ""
                                                        self.newPassword.text = ""
                                                        self.confirmPassword.text = ""
                                                        
                                                    })
                                                }
                })
            }
            else {
                PublicData.showSnackBar(message: "Invalid confirm password")
            }
        }
        else {
            PublicData.showSnackBar(message: "Please complete the field")
        }
    }
    func initView() {
         navButton.image = #imageLiteral(resourceName: "nav_button")
        
        let navGesture = UITapGestureRecognizer(target: self, action: #selector(navEvent))
        navButton.isUserInteractionEnabled = true
        navButton.addGestureRecognizer(navGesture)
        
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(closeEvent))
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(closeGesture)
        
        saveButton.initialize(backgroundColor: UIColor(rgb: 0xC5C5C5), titleColor: .white, cornerRadius: 4)
    }

}
