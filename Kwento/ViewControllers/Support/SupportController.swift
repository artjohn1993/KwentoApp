//
//  SupportController.swift
//  Kwento
//
//  Created by Richtone Hangad on 30/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents
import Pulsator

class SupportController: UIViewController {
    
    @IBOutlet weak var navButton: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: MDCFlatButton!
    
    var mainNavigationController: MainNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
    }
    
    @IBAction func didTapNavButton(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func submit(_ sender: Any) {
        
    }
    
    private func initViews() {
        navButton.image = #imageLiteral(resourceName: "nav_button")
        
        textView.layer.borderColor = UIColor.main.cgColor
        textView.layer.borderWidth = 1
        
        submitButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
    }
    
}
