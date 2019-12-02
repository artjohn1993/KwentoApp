//
//  LogoutDialogController.swift
//  Kwento
//
//  Created by Richtone Hangad on 08/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class LogoutDialogController: UIViewController {

    @IBOutlet weak var contentView: MDCCard!
    
    @IBOutlet weak var yesButton: MDCFlatButton!
    @IBOutlet weak var noButton: MDCFlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func initViews() {
        contentView.layer.cornerRadius = 8
        
        yesButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
        noButton.initialize(backgroundColor: UIColor.main.withAlphaComponent(0.27), titleColor: .main, cornerRadius: 4)
    }

}
