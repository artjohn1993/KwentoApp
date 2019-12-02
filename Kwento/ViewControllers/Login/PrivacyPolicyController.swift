//
//  PrivacyPolicyController.swift
//  Kwento
//
//  Created by Richtone Hangad on 03/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class PrivacyPolicyController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
}
