//
//  ForgetPasswordController.swift
//  Kwento
//
//  Created by Art John on 29/01/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class ForgetPasswordController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var sendButton: MDCFlatButton!
    let loginService = LoginServices()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setStatusBarBackgroundColor(color: UIColor.main)
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {

        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }

        statusBar.backgroundColor = color
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func send(_ sender: Any) {
        if email.text != "" {
            loginService.forgetPassword(email: email.text!, completion: { result in
                if result {
                    self.performSegue(withIdentifier: "checkEmail", sender: nil)
                }
            })
        }
        else {
            PublicData.showSnackBar(message: "Please fill out the field")
        }
    }
    
    private func initViews() {
           sendButton.setBackgroundColor(.main, for: .normal)
           sendButton.layer.cornerRadius = 4
           sendButton.setTitleColor(.white, for: .normal)
       }
    
}
