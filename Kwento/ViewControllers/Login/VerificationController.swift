//
//  VerificationController.swift
//  Kwento
//
//  Created by Richtone Hangad on 04/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents
import CoreData

class VerificationController: UIViewController {
    
    @IBOutlet var digits: [UILabel]!
    @IBOutlet var digitContainers: [UIView]!
    @IBOutlet weak var submitButton: MDCFlatButton!
    var userInfo = [UserInfo]()
    private var digitCount = 0
    let loginService = LoginServices()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        let fetch: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            userInfo = info
            print(userInfo)
        }catch {
            
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapNumber(_ sender: UIButton) {
        if digitCount < 4 {
            digits[digitCount].text = sender.titleLabel?.text
            digitCount += 1
        }
    }
    
    @IBAction func didTapBackspace(_ sender: Any) {
        if digitCount > 0 {
            digits[digitCount - 1].text = ""
            digitCount -= 1
        }
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        var code = ""
        digits.forEach({ item in
            print(item.text!)
            if item.text! != "" {
                code = "\(code)\(item.text!)"
            }
        })
        
        print(code)
        loginService.verifyAccount(code: code, completion: { result in
            print(result)
            if result {
                self.performSegue(withIdentifier: "verificationToTerms", sender: nil)
            }
        })
    }
    
    private func initViews() {
        for container in digitContainers {
            container.layer.cornerRadius = 17
        }
        
        submitButton.initialize(backgroundColor: .mainLight, titleColor: .white, cornerRadius: 4)
    }
}
