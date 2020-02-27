//
//  NoConnectionDialogController.swift
//  Kwento
//
//  Created by Richtone Hangad on 09/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class NoConnectionDialogController: UIViewController {
    
    @IBOutlet weak var backButton: MDCFlatButton!
    @IBOutlet var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        logo.tintColor = .main
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
}
