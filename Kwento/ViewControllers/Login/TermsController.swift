//
//  TermsController.swift
//  Kwento
//
//  Created by Richtone Hangad on 06/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents
import KYDrawerController

class TermsController: UIViewController {
    
    @IBOutlet weak var agreeButton: MDCFlatButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func acceptTerms(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let homeController = storyboard.instantiateInitialViewController() as! KYDrawerController
        present(homeController, animated: true)
    }
    
    
    private func initViews() {
        agreeButton.initialize(backgroundColor: .mainLight, titleColor: .white, cornerRadius: 4)
    }
}
